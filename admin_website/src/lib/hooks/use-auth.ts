'use client';

import { useAuth } from '@/lib/context/auth-context';

// Re-export useAuth hook for convenience
export { useAuth };

// Additional auth utilities
export function useUser() {
  const { user, loading } = useAuth();
  return { user, loading };
}

export function useSession() {
  const { session, loading } = useAuth();
  return { session, loading };
}

export function useAdminUser() {
  const { adminUser, loading } = useAuth();
  return { adminUser, loading };
}

export function useIsAuthenticated() {
  const { user, loading } = useAuth();
  return { isAuthenticated: !!user, loading };
}
