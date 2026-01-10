# Security Guide

**Project:** OSMEA Admin Website  
**Version:** 1.0.0  
**Date:** 2026-01-09  
**Security Level:** Enterprise-Grade

---

## 📋 Overview

This document provides comprehensive security guidelines for the Admin Website, covering authentication, authorization, data protection, API security, infrastructure security, and compliance requirements.

---

## 🔐 Security Architecture

### Security Layers

```
┌─────────────────────────────────────────┐
│   Layer 1: Network Security             │
│   - HTTPS/TLS                           │
│   - Firewall Rules                      │
│   - DDoS Protection                     │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│   Layer 2: Application Security         │
│   - Authentication (JWT)                │
│   - Authorization (RBAC)                │
│   - Input Validation                    │
│   - CSRF Protection                     │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│   Layer 3: Data Security                │
│   - Encryption at Rest                  │
│   - Encryption in Transit               │
│   - Secure API Keys                     │
│   - Data Masking                        │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│   Layer 4: Database Security            │
│   - Row Level Security (RLS)            │
│   - Prepared Statements                 │
│   - Access Control                      │
│   - Audit Logging                       │
└─────────────────────────────────────────┘
```

---

## 🛡️ Authentication Security

### 1. Password Security

```typescript
// src/lib/utils/password.ts
import bcrypt from 'bcryptjs';
import { z } from 'zod';

export const passwordSchema = z
  .string()
  .min(8, 'Password must be at least 8 characters')
  .regex(/[A-Z]/, 'Password must contain at least one uppercase letter')
  .regex(/[a-z]/, 'Password must contain at least one lowercase letter')
  .regex(/[0-9]/, 'Password must contain at least one number')
  .regex(/[^A-Za-z0-9]/, 'Password must contain at least one special character');

export async function hashPassword(password: string): Promise<string> {
  const saltRounds = 12;
  return bcrypt.hash(password, saltRounds);
}

export async function verifyPassword(
  password: string,
  hash: string
): Promise<boolean> {
  return bcrypt.compare(password, hash);
}

export function generateSecurePassword(length: number = 16): string {
  const charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*';
  const values = new Uint32Array(length);
  crypto.getRandomValues(values);
  
  return Array.from(values)
    .map(value => charset[value % charset.length])
    .join('');
}
```

### 2. Multi-Factor Authentication (MFA)

```typescript
// src/lib/utils/mfa.ts
import speakeasy from 'speakeasy';
import qrcode from 'qrcode';

export async function generateMFASecret(email: string): Promise<{
  secret: string;
  qrCodeUrl: string;
}> {
  const secret = speakeasy.generateSecret({
    name: `OSMEA Admin (${email})`,
    length: 32,
  });

  const qrCodeUrl = await qrcode.toDataURL(secret.otpauth_url!);

  return {
    secret: secret.base32,
    qrCodeUrl,
  };
}

export function verifyMFAToken(token: string, secret: string): boolean {
  return speakeasy.totp.verify({
    secret,
    encoding: 'base32',
    token,
    window: 2, // Allow 2 time steps before/after
  });
}

export function generateBackupCodes(count: number = 8): string[] {
  const codes: string[] = [];
  
  for (let i = 0; i < count; i++) {
    const code = Math.random().toString(36).substring(2, 10).toUpperCase();
    codes.push(code);
  }
  
  return codes;
}
```

### 3. Session Management

```typescript
// src/lib/utils/session.ts
import { cookies } from 'next/headers';
import { createServerClient } from '@supabase/ssr';

export const SESSION_CONFIG = {
  maxAge: 7 * 24 * 60 * 60, // 7 days
  refreshThreshold: 60 * 60, // 1 hour
  inactivityTimeout: 45 * 60, // 45 minutes
  maxConcurrentSessions: 3,
};

export async function validateSession(): Promise<{
  valid: boolean;
  reason?: string;
}> {
  const cookieStore = cookies();
  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        get(name: string) {
          return cookieStore.get(name)?.value;
        },
      },
    }
  );

  const { data: { session }, error } = await supabase.auth.getSession();

  if (error || !session) {
    return { valid: false, reason: 'No active session' };
  }

  // Check session expiry
  const now = Math.floor(Date.now() / 1000);
  if (session.expires_at && session.expires_at < now) {
    return { valid: false, reason: 'Session expired' };
  }

  // Check if refresh is needed
  const expiresIn = session.expires_at ? session.expires_at - now : 0;
  if (expiresIn < SESSION_CONFIG.refreshThreshold) {
    await supabase.auth.refreshSession();
  }

  return { valid: true };
}

export async function revokeSession(sessionId?: string) {
  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        get(name: string) {
          return cookies().get(name)?.value;
        },
      },
    }
  );

  if (sessionId) {
    // Revoke specific session
    // Implementation depends on Supabase session management
  } else {
    // Revoke current session
    await supabase.auth.signOut();
  }
}
```

---

## 🔒 Authorization & Access Control

### 1. Role-Based Access Control (RBAC)

```typescript
// src/lib/middleware/authorization.ts
import { NextRequest, NextResponse } from 'next/server';
import { createServerClient } from '@supabase/ssr';
import type { RolePermissions } from '@/lib/types/auth.types';

export async function checkPermission(
  request: NextRequest,
  permission: keyof RolePermissions
): Promise<boolean> {
  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        get(name: string) {
          return request.cookies.get(name)?.value;
        },
      },
    }
  );

  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return false;

  const { data: adminUser } = await supabase
    .from('admin_users')
    .select('role, permissions')
    .eq('auth_user_id', user.id)
    .eq('is_active', true)
    .single();

  if (!adminUser) return false;

  // Super admin has all permissions
  if (adminUser.role === 'super_admin') return true;

  // Check role-based permissions
  const rolePermissions = ROLE_PERMISSIONS[adminUser.role];
  if (rolePermissions && rolePermissions[permission]) return true;

  // Check custom permissions
  if (adminUser.permissions && adminUser.permissions[permission]) return true;

  return false;
}

export function requirePermission(permission: keyof RolePermissions) {
  return async (request: NextRequest) => {
    const hasPermission = await checkPermission(request, permission);
    
    if (!hasPermission) {
      return NextResponse.json(
        { error: 'Insufficient permissions' },
        { status: 403 }
      );
    }
    
    return NextResponse.next();
  };
}
```

---

## 🔐 Data Protection

### 1. Encryption at Rest

```typescript
// src/lib/utils/encryption.ts
import crypto from 'crypto';

const ALGORITHM = 'aes-256-gcm';
const KEY_LENGTH = 32;
const IV_LENGTH = 16;
const AUTH_TAG_LENGTH = 16;

export class Encryption {
  private key: Buffer;

  constructor(key?: string) {
    this.key = key
      ? Buffer.from(key, 'hex')
      : crypto.randomBytes(KEY_LENGTH);
  }

  encrypt(text: string): string {
    try {
      const iv = crypto.randomBytes(IV_LENGTH);
      const cipher = crypto.createCipheriv(ALGORITHM, this.key, iv);

      let encrypted = cipher.update(text, 'utf8', 'hex');
      encrypted += cipher.final('hex');

      const authTag = cipher.getAuthTag();

      // Format: iv:authTag:encrypted
      return `${iv.toString('hex')}:${authTag.toString('hex')}:${encrypted}`;
    } catch (error) {
      console.error('Encryption error:', error);
      throw new Error('Failed to encrypt data');
    }
  }

  decrypt(encryptedText: string): string {
    try {
      const parts = encryptedText.split(':');
      if (parts.length !== 3) {
        throw new Error('Invalid encrypted text format');
      }

      const [ivHex, authTagHex, encrypted] = parts;
      const iv = Buffer.from(ivHex, 'hex');
      const authTag = Buffer.from(authTagHex, 'hex');

      const decipher = crypto.createDecipheriv(ALGORITHM, this.key, iv);
      decipher.setAuthTag(authTag);

      let decrypted = decipher.update(encrypted, 'hex', 'utf8');
      decrypted += decipher.final('utf8');

      return decrypted;
    } catch (error) {
      console.error('Decryption error:', error);
      throw new Error('Failed to decrypt data');
    }
  }

  static generateKey(): string {
    return crypto.randomBytes(KEY_LENGTH).toString('hex');
  }
}

// Singleton instance
const encryptionKey = process.env.ENCRYPTION_KEY!;
export const encryption = new Encryption(encryptionKey);

// Usage:
// const encrypted = encryption.encrypt('sensitive data');
// const decrypted = encryption.decrypt(encrypted);
```

### 2. Data Masking

```typescript
// src/lib/utils/masking.ts
export function maskEmail(email: string): string {
  const [username, domain] = email.split('@');
  if (username.length <= 2) return email;
  
  const masked = username[0] + '*'.repeat(username.length - 2) + username.slice(-1);
  return `${masked}@${domain}`;
}

export function maskPhone(phone: string): string {
  if (phone.length < 4) return phone;
  return '*'.repeat(phone.length - 4) + phone.slice(-4);
}

export function maskCreditCard(card: string): string {
  if (card.length < 4) return card;
  return '*'.repeat(card.length - 4) + card.slice(-4);
}

export function maskApiKey(key: string): string {
  if (key.length <= 8) return '*'.repeat(key.length);
  return key.slice(0, 4) + '*'.repeat(key.length - 8) + key.slice(-4);
}

export function sanitizeForLog(data: any): any {
  const sensitiveKeys = ['password', 'token', 'apiKey', 'secret', 'ssn', 'creditCard'];
  
  if (typeof data !== 'object' || data === null) {
    return data;
  }
  
  const sanitized = Array.isArray(data) ? [] : {};
  
  for (const [key, value] of Object.entries(data)) {
    if (sensitiveKeys.some(k => key.toLowerCase().includes(k))) {
      sanitized[key] = '***REDACTED***';
    } else if (typeof value === 'object' && value !== null) {
      sanitized[key] = sanitizeForLog(value);
    } else {
      sanitized[key] = value;
    }
  }
  
  return sanitized;
}
```

---

## 🌐 API Security

### 1. Rate Limiting

```typescript
// src/lib/middleware/rate-limit.ts
import { NextRequest, NextResponse } from 'next/server';
import { Redis } from '@upstash/redis';

const redis = new Redis({
  url: process.env.UPSTASH_REDIS_URL!,
  token: process.env.UPSTASH_REDIS_TOKEN!,
});

interface RateLimitConfig {
  maxRequests: number;
  windowMs: number;
  message?: string;
}

export async function rateLimit(
  request: NextRequest,
  config: RateLimitConfig
): Promise<NextResponse | null> {
  const ip = request.ip || request.headers.get('x-forwarded-for') || 'unknown';
  const key = `rate-limit:${ip}`;

  const now = Date.now();
  const windowStart = now - config.windowMs;

  // Get request timestamps
  const requests = await redis.zrange(key, windowStart, now, { byScore: true });

  if (requests.length >= config.maxRequests) {
    return NextResponse.json(
      {
        error: config.message || 'Too many requests',
        retryAfter: Math.ceil(config.windowMs / 1000),
      },
      {
        status: 429,
        headers: {
          'Retry-After': String(Math.ceil(config.windowMs / 1000)),
        },
      }
    );
  }

  // Add current request
  await redis.zadd(key, { score: now, member: now.toString() });
  await redis.expire(key, Math.ceil(config.windowMs / 1000));

  // Remove old entries
  await redis.zremrangebyscore(key, 0, windowStart);

  return null;
}

// Usage in API routes:
export async function POST(request: NextRequest) {
  const rateLimitResponse = await rateLimit(request, {
    maxRequests: 10,
    windowMs: 60 * 1000, // 1 minute
    message: 'Too many login attempts',
  });

  if (rateLimitResponse) return rateLimitResponse;

  // Continue with normal flow
}
```

### 2. Input Validation

```typescript
// src/lib/utils/validation.ts
import { z } from 'zod';

// Email validation
export const emailSchema = z
  .string()
  .email('Invalid email address')
  .max(255, 'Email too long');

// URL validation
export const urlSchema = z
  .string()
  .url('Invalid URL')
  .regex(/^https?:\/\//, 'URL must start with http:// or https://');

// SQL Injection prevention
export function sanitizeSQLInput(input: string): string {
  return input
    .replace(/['";\\]/g, '') // Remove dangerous characters
    .trim();
}

// XSS prevention
export function sanitizeHTML(html: string): string {
  return html
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#x27;')
    .replace(/\//g, '&#x2F;');
}

// File upload validation
export const fileUploadSchema = z.object({
  name: z.string().max(255),
  size: z.number().max(10 * 1024 * 1024), // 10MB
  type: z.enum([
    'image/jpeg',
    'image/png',
    'image/webp',
    'application/pdf',
  ]),
});

export function validateFileUpload(file: File): {
  valid: boolean;
  error?: string;
} {
  try {
    fileUploadSchema.parse({
      name: file.name,
      size: file.size,
      type: file.type,
    });
    return { valid: true };
  } catch (error) {
    if (error instanceof z.ZodError) {
      return {
        valid: false,
        error: error.errors[0].message,
      };
    }
    return {
      valid: false,
      error: 'Invalid file',
    };
  }
}
```

### 3. CSRF Protection

```typescript
// src/lib/utils/csrf.ts
import { cookies } from 'next/headers';
import crypto from 'crypto';

const CSRF_TOKEN_KEY = 'csrf_token';
const CSRF_HEADER_NAME = 'x-csrf-token';

export function generateCSRFToken(): string {
  return crypto.randomBytes(32).toString('hex');
}

export function setCSRFToken(): string {
  const token = generateCSRFToken();
  const cookieStore = cookies();
  
  cookieStore.set(CSRF_TOKEN_KEY, token, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict',
    maxAge: 60 * 60, // 1 hour
  });
  
  return token;
}

export function validateCSRFToken(request: Request): boolean {
  const cookieStore = cookies();
  const cookieToken = cookieStore.get(CSRF_TOKEN_KEY)?.value;
  const headerToken = request.headers.get(CSRF_HEADER_NAME);
  
  if (!cookieToken || !headerToken) {
    return false;
  }
  
  return crypto.timingSafeEqual(
    Buffer.from(cookieToken),
    Buffer.from(headerToken)
  );
}

// Middleware
export async function csrfProtection(request: Request) {
  const method = request.method;
  
  // Only check for state-changing methods
  if (['POST', 'PUT', 'DELETE', 'PATCH'].includes(method)) {
    if (!validateCSRFToken(request)) {
      return new Response('Invalid CSRF token', { status: 403 });
    }
  }
  
  return null;
}
```

---

## 🗄️ Database Security

### 1. Prepared Statements

```typescript
// Always use parameterized queries
// ❌ BAD - SQL Injection vulnerable
const userId = req.query.userId;
const query = `SELECT * FROM users WHERE id = ${userId}`;

// ✅ GOOD - Safe parameterized query
const { data } = await supabase
  .from('users')
  .select('*')
  .eq('id', userId);
```

### 2. Row Level Security (RLS)

See `03-database-schema.md` for complete RLS policies.

### 3. Database Auditing

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
  result?: 'success' | 'failure';
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
    result: entry.result || 'success',
  });
}
```

---

## 🔍 Security Monitoring

### 1. Security Event Logging

```typescript
// src/lib/utils/security-logger.ts
import { logger } from '@/lib/utils/logger';
import { createAuditLog } from '@/lib/utils/audit';

export enum SecurityEventType {
  LOGIN_SUCCESS = 'login_success',
  LOGIN_FAILURE = 'login_failure',
  LOGOUT = 'logout',
  PASSWORD_CHANGE = 'password_change',
  PASSWORD_RESET = 'password_reset',
  MFA_ENABLED = 'mfa_enabled',
  MFA_DISABLED = 'mfa_disabled',
  PERMISSION_DENIED = 'permission_denied',
  SUSPICIOUS_ACTIVITY = 'suspicious_activity',
  DATA_ACCESS = 'data_access',
  DATA_MODIFICATION = 'data_modification',
}

export async function logSecurityEvent(
  type: SecurityEventType,
  details: Record<string, any>
) {
  logger.info({
    event: 'security_event',
    type,
    ...details,
    timestamp: new Date().toISOString(),
  });

  await createAuditLog({
    action: type,
    ...details,
  });

  // Alert on critical events
  if (isCriticalEvent(type)) {
    await sendSecurityAlert(type, details);
  }
}

function isCriticalEvent(type: SecurityEventType): boolean {
  return [
    SecurityEventType.LOGIN_FAILURE,
    SecurityEventType.PERMISSION_DENIED,
    SecurityEventType.SUSPICIOUS_ACTIVITY,
  ].includes(type);
}

async function sendSecurityAlert(
  type: SecurityEventType,
  details: Record<string, any>
) {
  // Send to monitoring service (e.g., Sentry, Datadog)
  // Send email to security team
  // Send Slack notification
}
```

---

## ✅ Security Checklist

### Infrastructure Security
- [ ] HTTPS/TLS enabled
- [ ] SSL certificates valid and up-to-date
- [ ] Firewall rules configured
- [ ] DDoS protection enabled
- [ ] Regular security updates
- [ ] Backup and disaster recovery plan
- [ ] Monitoring and alerting setup

### Application Security
- [ ] Authentication implemented
- [ ] Authorization (RBAC) configured
- [ ] Session management secure
- [ ] Password policy enforced
- [ ] MFA available
- [ ] CSRF protection enabled
- [ ] XSS protection enabled
- [ ] SQL injection prevention
- [ ] Input validation everywhere
- [ ] Output encoding
- [ ] Secure headers configured

### Data Security
- [ ] Encryption at rest
- [ ] Encryption in transit
- [ ] API keys encrypted
- [ ] Sensitive data masked in logs
- [ ] Data retention policy
- [ ] Secure file uploads
- [ ] Data backup encrypted

### API Security
- [ ] Rate limiting implemented
- [ ] API authentication required
- [ ] API versioning
- [ ] CORS configured properly
- [ ] Request validation
- [ ] Response sanitization

### Database Security
- [ ] RLS policies enabled
- [ ] Prepared statements used
- [ ] Least privilege access
- [ ] Database backups
- [ ] Connection encryption
- [ ] Audit logging enabled

### Code Security
- [ ] Dependencies updated
- [ ] No hardcoded secrets
- [ ] Security linting enabled
- [ ] Code review process
- [ ] Security testing
- [ ] Vulnerability scanning

### Compliance
- [ ] GDPR compliance
- [ ] Data privacy policy
- [ ] Terms of service
- [ ] Cookie consent
- [ ] Data processing agreement
- [ ] Security incident response plan

---

## 🚨 Incident Response Plan

### 1. Detection
- Monitor logs and alerts
- User reports
- Automated scanning

### 2. Assessment
- Determine severity
- Identify affected systems
- Estimate impact

### 3. Containment
- Isolate affected systems
- Block malicious activity
- Preserve evidence

### 4. Eradication
- Remove threat
- Patch vulnerabilities
- Update security measures

### 5. Recovery
- Restore systems
- Verify security
- Monitor for recurrence

### 6. Post-Incident
- Document incident
- Review response
- Update procedures
- Train team

---

## 📚 Security Resources

### Tools
- **OWASP ZAP** - Security testing
- **Snyk** - Dependency scanning
- **SonarQube** - Code quality & security
- **Sentry** - Error tracking
- **Cloudflare** - DDoS protection

### Documentation
- OWASP Top 10
- OWASP Cheat Sheets
- Next.js Security Best Practices
- Supabase Security Guide

---

**Document Version:** 1.0.0  
**Last Updated:** 2026-01-09  
**Status:** Complete
