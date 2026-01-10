'use client';

import { createContext, useContext, useEffect, useState, ReactNode } from 'react';
import { getSupabaseClient, initializeSupabase } from '@/lib/supabase/client';
import type { User, Session } from '@supabase/supabase-js';

export interface AdminUser {
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
  signIn: (email: string, password: string) => Promise<{ error: Error | null }>;
  signOut: () => Promise<void>;
  signUp: (email: string, password: string, userData?: Record<string, unknown>) => Promise<{ error: Error | null }>;
  resetPassword: (email: string) => Promise<{ error: Error | null }>;
  updatePassword: (password: string) => Promise<{ error: Error | null }>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [adminUser, setAdminUser] = useState<AdminUser | null>(null);
  const [session, setSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Try to initialize Supabase (will use localStorage on client)
    const supabase = getSupabaseClient() || initializeSupabase();
    
    if (!supabase) {
      setLoading(false);
      return;
    }

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
    const supabase = getSupabaseClient();
    if (!supabase) {
      setLoading(false);
      return;
    }

    try {
      const { data, error } = await supabase
        .from('admin_users')
        .select('*')
        .eq('auth_user_id', authUserId)
        .eq('is_active', true)
        .single();

      if (error) {
        // Admin user might not exist yet, that's okay
        console.log('Admin user not found:', error.message);
        setAdminUser(null);
      } else if (data) {
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
      }
    } catch (error) {
      console.error('Error loading admin user:', error);
      setAdminUser(null);
    } finally {
      setLoading(false);
    }
  };

  const signIn = async (email: string, password: string) => {
    const supabase = getSupabaseClient();
    if (!supabase) {
      return { error: new Error('Supabase is not configured') };
    }

    setLoading(true);
    try {
      const { error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });
      if (error) {
        setLoading(false);
        return { error };
      }
      return { error: null };
    } catch (error) {
      setLoading(false);
      return { error: error as Error };
    }
  };

  const signOut = async () => {
    const supabase = getSupabaseClient();
    if (!supabase) return;

    const { error } = await supabase.auth.signOut();
    if (error) throw error;
    setUser(null);
    setAdminUser(null);
    setSession(null);
  };

  const signUp = async (email: string, password: string, userData?: Record<string, unknown>) => {
    const supabase = getSupabaseClient();
    if (!supabase) {
      return { error: new Error('Supabase is not configured') };
    }

    try {
      const { error } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: userData,
        },
      });
      if (error) return { error };
      return { error: null };
    } catch (error) {
      return { error: error as Error };
    }
  };

  const resetPassword = async (email: string) => {
    const supabase = getSupabaseClient();
    if (!supabase) {
      return { error: new Error('Supabase is not configured') };
    }

    try {
      const { error } = await supabase.auth.resetPasswordForEmail(email, {
        redirectTo: `${window.location.origin}/reset-password`,
      });
      if (error) return { error };
      return { error: null };
    } catch (error) {
      return { error: error as Error };
    }
  };

  const updatePassword = async (password: string) => {
    const supabase = getSupabaseClient();
    if (!supabase) {
      return { error: new Error('Supabase is not configured') };
    }

    try {
      const { error } = await supabase.auth.updateUser({
        password,
      });
      if (error) return { error };
      return { error: null };
    } catch (error) {
      return { error: error as Error };
    }
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
        updatePassword,
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
