# Authentication & Authorization

**Project:** OSMEA Admin Website  
**Version:** 1.0.0  
**Date:** 2026-01-09  
**Technology:** Supabase Auth + JWT

---

## 📋 Overview

This document covers the complete authentication and authorization implementation using Supabase Auth, including user management, role-based access control (RBAC), session management, and security best practices.

---

## 🎯 Authentication Strategy

### Authentication Flow

```
User Opens App → Check Session → Session Valid? 
                                      │
                        ┌─────────────┴─────────────┐
                        │                           │
                       YES                          NO
                        │                           │
                        ▼                           ▼
                  Load Dashboard              Show Login Page
                        │                           │
                        │                           ▼
                        │                    User Enters Credentials
                        │                           │
                        │                           ▼
                        │                    Supabase Auth Validates
                        │                           │
                        │                ┌──────────┴──────────┐
                        │                │                     │
                        │             Success                 Fail
                        │                │                     │
                        │                ▼                     ▼
                        │          Create Session      Show Error Message
                        │                │
                        │                ▼
                        │          Check Admin Role
                        │                │
                        │     ┌──────────┴──────────┐
                        │     │                     │
                        │   Exists              Not Exists
                        │     │                     │
                        └─────┘                     ▼
                                          Redirect to Setup Wizard
```

---

## 🔐 Supabase Auth Implementation

### 1. Create Supabase Clients

```typescript
// src/lib/supabase/client.ts
import { createBrowserClient } from '@supabase/ssr';

export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );
}

// src/lib/supabase/server.ts
import { createServerClient, type CookieOptions } from '@supabase/ssr';
import { cookies } from 'next/headers';

export function createClient() {
  const cookieStore = cookies();

  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        get(name: string) {
          return cookieStore.get(name)?.value;
        },
        set(name: string, value: string, options: CookieOptions) {
          try {
            cookieStore.set({ name, value, ...options });
          } catch (error) {
            // Handle server component error
          }
        },
        remove(name: string, options: CookieOptions) {
          try {
            cookieStore.set({ name, value: '', ...options });
          } catch (error) {
            // Handle server component error
          }
        },
      },
    }
  );
}
```

### 2. Authentication Context

```typescript
// src/lib/context/auth-context.tsx
'use client';

import { createContext, useContext, useEffect, useState } from 'react';
import { createClient } from '@/lib/supabase/client';
import type { User, Session } from '@supabase/supabase-js';

interface AdminUser {
  id: string;
  authUserId: string;
  storeId: string;
  displayName: string;
  avatarUrl: string;
  role: 'super_admin' | 'store_manager' | 'content_editor' | 'viewer';
  permissions: Record<string, boolean>;
  isActive: boolean;
}

interface AuthContextType {
  user: User | null;
  adminUser: AdminUser | null;
  session: Session | null;
  loading: boolean;
  signIn: (email: string, password: string) => Promise<void>;
  signOut: () => Promise<void>;
  signUp: (email: string, password: string, userData: any) => Promise<void>;
  resetPassword: (email: string) => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [adminUser, setAdminUser] = useState<AdminUser | null>(null);
  const [session, setSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(true);

  const supabase = createClient();

  useEffect(() => {
    // Get initial session
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session);
      setUser(session?.user ?? null);
      if (session?.user) {
        loadAdminUser(session.user.id);
      } else {
        setLoading(false);
      }
    });

    // Listen for auth changes
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange(async (event, session) => {
      setSession(session);
      setUser(session?.user ?? null);
      
      if (session?.user) {
        await loadAdminUser(session.user.id);
      } else {
        setAdminUser(null);
        setLoading(false);
      }
    });

    return () => subscription.unsubscribe();
  }, []);

  const loadAdminUser = async (authUserId: string) => {
    try {
      const { data, error } = await supabase
        .from('admin_users')
        .select('*')
        .eq('auth_user_id', authUserId)
        .eq('is_active', true)
        .single();

      if (error) throw error;
      
      setAdminUser({
        id: data.id,
        authUserId: data.auth_user_id,
        storeId: data.store_id,
        displayName: data.display_name,
        avatarUrl: data.avatar_url,
        role: data.role,
        permissions: data.permissions || {},
        isActive: data.is_active,
      });
    } catch (error) {
      console.error('Error loading admin user:', error);
      setAdminUser(null);
    } finally {
      setLoading(false);
    }
  };

  const signIn = async (email: string, password: string) => {
    setLoading(true);
    try {
      const { error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });
      if (error) throw error;
    } catch (error) {
      setLoading(false);
      throw error;
    }
  };

  const signOut = async () => {
    const { error } = await supabase.auth.signOut();
    if (error) throw error;
    setUser(null);
    setAdminUser(null);
    setSession(null);
  };

  const signUp = async (email: string, password: string, userData: any) => {
    const { error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: userData,
      },
    });
    if (error) throw error;
  };

  const resetPassword = async (email: string) => {
    const { error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: `${window.location.origin}/auth/reset-password`,
    });
    if (error) throw error;
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        adminUser,
        session,
        loading,
        signIn,
        signOut,
        signUp,
        resetPassword,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}
```

### 3. Login Page

```typescript
// src/app/(auth)/login/page.tsx
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/lib/context/auth-context';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Loader2, Mail, Lock } from 'lucide-react';
import { toast } from 'sonner';
import Link from 'next/link';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const { signIn } = useAuth();
  const router = useRouter();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      await signIn(email, password);
      toast.success('Login successful!');
      router.push('/dashboard');
    } catch (error: any) {
      console.error('Login error:', error);
      toast.error(error.message || 'Failed to login');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-slate-900 to-slate-800 p-4">
      <Card className="w-full max-w-md border-2">
        <CardHeader className="space-y-1 text-center">
          <div className="mx-auto h-12 w-12 rounded-full bg-primary/10 flex items-center justify-center mb-4">
            <Lock className="h-6 w-6 text-primary" />
          </div>
          <CardTitle className="text-2xl font-bold">Welcome Back</CardTitle>
          <CardDescription>
            Sign in to your admin account
          </CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleLogin} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="email">Email</Label>
              <div className="relative">
                <Mail className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                <Input
                  id="email"
                  type="email"
                  placeholder="admin@example.com"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="pl-10"
                  required
                  disabled={loading}
                />
              </div>
            </div>

            <div className="space-y-2">
              <div className="flex items-center justify-between">
                <Label htmlFor="password">Password</Label>
                <Link
                  href="/auth/forgot-password"
                  className="text-sm text-primary hover:underline"
                >
                  Forgot password?
                </Link>
              </div>
              <div className="relative">
                <Lock className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                <Input
                  id="password"
                  type="password"
                  placeholder="••••••••"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="pl-10"
                  required
                  disabled={loading}
                />
              </div>
            </div>

            <Button type="submit" className="w-full" disabled={loading}>
              {loading ? (
                <>
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                  Signing in...
                </>
              ) : (
                'Sign In'
              )}
            </Button>
          </form>

          <div className="mt-6 text-center text-sm">
            <span className="text-muted-foreground">Don't have an account? </span>
            <Link href="/auth/signup" className="text-primary hover:underline font-medium">
              Sign up
            </Link>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
```

### 4. Protected Route Middleware

```typescript
// src/middleware.ts
import { createServerClient, type CookieOptions } from '@supabase/ssr';
import { NextResponse, type NextRequest } from 'next/server';

export async function middleware(request: NextRequest) {
  let response = NextResponse.next({
    request: {
      headers: request.headers,
    },
  });

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        get(name: string) {
          return request.cookies.get(name)?.value;
        },
        set(name: string, value: string, options: CookieOptions) {
          request.cookies.set({
            name,
            value,
            ...options,
          });
          response = NextResponse.next({
            request: {
              headers: request.headers,
            },
          });
          response.cookies.set({
            name,
            value,
            ...options,
          });
        },
        remove(name: string, options: CookieOptions) {
          request.cookies.set({
            name,
            value: '',
            ...options,
          });
          response = NextResponse.next({
            request: {
              headers: request.headers,
            },
          });
          response.cookies.set({
            name,
            value: '',
            ...options,
          });
        },
      },
    }
  );

  const {
    data: { session },
  } = await supabase.auth.getSession();

  // Public routes that don't require authentication
  const publicRoutes = ['/login', '/signup', '/forgot-password', '/reset-password'];
  const isPublicRoute = publicRoutes.some((route) =>
    request.nextUrl.pathname.startsWith(route)
  );

  // If user is not logged in and trying to access protected route
  if (!session && !isPublicRoute) {
    const redirectUrl = request.nextUrl.clone();
    redirectUrl.pathname = '/login';
    redirectUrl.searchParams.set('redirect', request.nextUrl.pathname);
    return NextResponse.redirect(redirectUrl);
  }

  // If user is logged in and trying to access auth pages
  if (session && isPublicRoute) {
    const redirectUrl = request.nextUrl.clone();
    redirectUrl.pathname = '/dashboard';
    return NextResponse.redirect(redirectUrl);
  }

  return response;
}

export const config = {
  matcher: [
    '/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)',
  ],
};
```

---

## 👥 Role-Based Access Control (RBAC)

### Role Definitions

```typescript
// src/lib/types/auth.types.ts
export type UserRole = 'super_admin' | 'store_manager' | 'content_editor' | 'viewer';

export interface RolePermissions {
  // Configuration
  'config:read': boolean;
  'config:write': boolean;
  'config:publish': boolean;
  'config:delete': boolean;

  // Products
  'products:read': boolean;
  'products:write': boolean;
  'products:delete': boolean;

  // Orders
  'orders:read': boolean;
  'orders:update': boolean;
  'orders:cancel': boolean;

  // Builds
  'builds:read': boolean;
  'builds:trigger': boolean;
  'builds:cancel': boolean;
  'builds:download': boolean;

  // Users
  'users:read': boolean;
  'users:write': boolean;
  'users:delete': boolean;

  // Settings
  'settings:read': boolean;
  'settings:write': boolean;

  // Analytics
  'analytics:read': boolean;
}

export const ROLE_PERMISSIONS: Record<UserRole, Partial<RolePermissions>> = {
  super_admin: {
    'config:read': true,
    'config:write': true,
    'config:publish': true,
    'config:delete': true,
    'products:read': true,
    'products:write': true,
    'products:delete': true,
    'orders:read': true,
    'orders:update': true,
    'orders:cancel': true,
    'builds:read': true,
    'builds:trigger': true,
    'builds:cancel': true,
    'builds:download': true,
    'users:read': true,
    'users:write': true,
    'users:delete': true,
    'settings:read': true,
    'settings:write': true,
    'analytics:read': true,
  },
  store_manager: {
    'config:read': true,
    'config:write': true,
    'config:publish': true,
    'products:read': true,
    'products:write': true,
    'products:delete': true,
    'orders:read': true,
    'orders:update': true,
    'builds:read': true,
    'builds:trigger': true,
    'builds:download': true,
    'users:read': true,
    'settings:read': true,
    'settings:write': true,
    'analytics:read': true,
  },
  content_editor: {
    'config:read': true,
    'config:write': true,
    'products:read': true,
    'products:write': true,
    'orders:read': true,
    'builds:read': true,
    'analytics:read': true,
  },
  viewer: {
    'config:read': true,
    'products:read': true,
    'orders:read': true,
    'builds:read': true,
    'analytics:read': true,
  },
};
```

### Permission Hooks

```typescript
// src/lib/hooks/use-permissions.ts
import { useAuth } from '@/lib/context/auth-context';
import { ROLE_PERMISSIONS, type RolePermissions } from '@/lib/types/auth.types';

export function usePermissions() {
  const { adminUser } = useAuth();

  const hasPermission = (permission: keyof RolePermissions): boolean => {
    if (!adminUser) return false;

    // Super admin has all permissions
    if (adminUser.role === 'super_admin') return true;

    // Check role-based permissions
    const rolePermissions = ROLE_PERMISSIONS[adminUser.role];
    if (rolePermissions && rolePermissions[permission]) return true;

    // Check custom user permissions
    if (adminUser.permissions && adminUser.permissions[permission]) return true;

    return false;
  };

  const hasAnyPermission = (permissions: Array<keyof RolePermissions>): boolean => {
    return permissions.some((permission) => hasPermission(permission));
  };

  const hasAllPermissions = (permissions: Array<keyof RolePermissions>): boolean => {
    return permissions.every((permission) => hasPermission(permission));
  };

  return {
    hasPermission,
    hasAnyPermission,
    hasAllPermissions,
    role: adminUser?.role,
    isAdmin: adminUser?.role === 'super_admin',
    isManager: adminUser?.role === 'store_manager',
    isEditor: adminUser?.role === 'content_editor',
    isViewer: adminUser?.role === 'viewer',
  };
}
```

### Protected Component

```typescript
// src/components/auth/protected.tsx
'use client';

import { usePermissions } from '@/lib/hooks/use-permissions';
import type { RolePermissions } from '@/lib/types/auth.types';
import { ReactNode } from 'react';

interface ProtectedProps {
  children: ReactNode;
  permission?: keyof RolePermissions;
  permissions?: Array<keyof RolePermissions>;
  requireAll?: boolean;
  fallback?: ReactNode;
}

export function Protected({
  children,
  permission,
  permissions,
  requireAll = false,
  fallback = null,
}: ProtectedProps) {
  const { hasPermission, hasAllPermissions, hasAnyPermission } = usePermissions();

  // Single permission check
  if (permission && !hasPermission(permission)) {
    return <>{fallback}</>;
  }

  // Multiple permissions check
  if (permissions) {
    const hasAccess = requireAll
      ? hasAllPermissions(permissions)
      : hasAnyPermission(permissions);

    if (!hasAccess) {
      return <>{fallback}</>;
    }
  }

  return <>{children}</>;
}

// Usage example:
// <Protected permission="builds:trigger">
//   <Button onClick={triggerBuild}>Trigger Build</Button>
// </Protected>
```

---

## 🔒 Security Best Practices

### 1. Password Requirements

```typescript
// src/lib/utils/validation.ts
export const passwordRequirements = {
  minLength: 8,
  requireUppercase: true,
  requireLowercase: true,
  requireNumber: true,
  requireSpecial: true,
};

export function validatePassword(password: string): {
  isValid: boolean;
  errors: string[];
} {
  const errors: string[] = [];

  if (password.length < passwordRequirements.minLength) {
    errors.push(`Password must be at least ${passwordRequirements.minLength} characters`);
  }

  if (passwordRequirements.requireUppercase && !/[A-Z]/.test(password)) {
    errors.push('Password must contain at least one uppercase letter');
  }

  if (passwordRequirements.requireLowercase && !/[a-z]/.test(password)) {
    errors.push('Password must contain at least one lowercase letter');
  }

  if (passwordRequirements.requireNumber && !/\d/.test(password)) {
    errors.push('Password must contain at least one number');
  }

  if (passwordRequirements.requireSpecial && !/[!@#$%^&*(),.?":{}|<>]/.test(password)) {
    errors.push('Password must contain at least one special character');
  }

  return {
    isValid: errors.length === 0,
    errors,
  };
}
```

### 2. Session Management

```typescript
// src/lib/utils/session.ts
export const SESSION_CONFIG = {
  maxAge: 7 * 24 * 60 * 60, // 7 days
  refreshInterval: 60 * 60, // 1 hour
  inactivityTimeout: 45 * 60, // 45 minutes
};

export function setupSessionRefresh(supabase: any) {
  // Refresh session every hour
  const refreshInterval = setInterval(async () => {
    const { data, error } = await supabase.auth.refreshSession();
    if (error) {
      console.error('Session refresh error:', error);
      clearInterval(refreshInterval);
    }
  }, SESSION_CONFIG.refreshInterval * 1000);

  return () => clearInterval(refreshInterval);
}

export function trackUserActivity() {
  let lastActivity = Date.now();

  const updateActivity = () => {
    lastActivity = Date.now();
  };

  // Track user activity
  document.addEventListener('mousemove', updateActivity);
  document.addEventListener('keypress', updateActivity);
  document.addEventListener('click', updateActivity);
  document.addEventListener('scroll', updateActivity);

  // Check inactivity
  const inactivityCheck = setInterval(() => {
    const inactiveTime = Date.now() - lastActivity;
    if (inactiveTime > SESSION_CONFIG.inactivityTimeout * 1000) {
      // Logout user
      window.location.href = '/login?reason=inactivity';
    }
  }, 60 * 1000); // Check every minute

  return () => {
    clearInterval(inactivityCheck);
    document.removeEventListener('mousemove', updateActivity);
    document.removeEventListener('keypress', updateActivity);
    document.removeEventListener('click', updateActivity);
    document.removeEventListener('scroll', updateActivity);
  };
}
```

### 3. API Key Encryption

```typescript
// src/lib/utils/encryption.ts
import { createCipheriv, createDecipheriv, randomBytes } from 'crypto';

const ENCRYPTION_KEY = process.env.ENCRYPTION_KEY!; // Must be 32 bytes
const ALGORITHM = 'aes-256-cbc';

export function encryptApiKey(apiKey: string): string {
  const iv = randomBytes(16);
  const cipher = createCipheriv(ALGORITHM, Buffer.from(ENCRYPTION_KEY, 'hex'), iv);
  
  let encrypted = cipher.update(apiKey, 'utf8', 'hex');
  encrypted += cipher.final('hex');
  
  return `${iv.toString('hex')}:${encrypted}`;
}

export function decryptApiKey(encryptedKey: string): string {
  const [ivHex, encrypted] = encryptedKey.split(':');
  const iv = Buffer.from(ivHex, 'hex');
  
  const decipher = createDecipheriv(ALGORITHM, Buffer.from(ENCRYPTION_KEY, 'hex'), iv);
  
  let decrypted = decipher.update(encrypted, 'hex', 'utf8');
  decrypted += decipher.final('utf8');
  
  return decrypted;
}
```

---

## 📊 Audit Logging

### Automatic Audit Trail

```typescript
// src/lib/utils/audit.ts
import { createClient } from '@/lib/supabase/server';

export interface AuditLogEntry {
  action: string;
  entityType?: string;
  entityId?: string;
  oldValue?: any;
  newValue?: any;
  changes?: Record<string, any>;
  ipAddress?: string;
  userAgent?: string;
}

export async function createAuditLog(entry: AuditLogEntry) {
  const supabase = createClient();
  
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return;

  const { data: adminUser } = await supabase
    .from('admin_users')
    .select('id, store_id')
    .eq('auth_user_id', user.id)
    .single();

  if (!adminUser) return;

  await supabase.from('audit_logs').insert({
    store_id: adminUser.store_id,
    user_id: adminUser.id,
    action: entry.action,
    entity_type: entry.entityType,
    entity_id: entry.entityId,
    old_value: entry.oldValue,
    new_value: entry.newValue,
    changes: entry.changes,
    ip_address: entry.ipAddress,
    user_agent: entry.userAgent,
  });
}
```

---

## ✅ Security Checklist

- [ ] Implement password complexity requirements
- [ ] Enable email verification
- [ ] Set up session timeout
- [ ] Implement rate limiting
- [ ] Enable CORS properly
- [ ] Use HTTPS only
- [ ] Encrypt sensitive data at rest
- [ ] Implement audit logging
- [ ] Set up MFA (optional)
- [ ] Regular security audits

---

**Document Version:** 1.0.0  
**Last Updated:** 2026-01-09  
**Status:** Complete
