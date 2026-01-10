import { createClient, SupabaseClient } from '@supabase/supabase-js';

// Get credentials from env vars or localStorage (client-side)
function getSupabaseCredentials(): { url: string; key: string } {
  // First try env vars
  const envUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || '';
  const envKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '';
  
  if (envUrl && envKey) {
    return { url: envUrl, key: envKey };
  }
  
  // On client-side, try localStorage
  if (typeof window !== 'undefined') {
    const localUrl = localStorage.getItem('osmea-supabase-url') || '';
    const localKey = localStorage.getItem('osmea-supabase-key') || '';
    if (localUrl && localKey) {
      return { url: localUrl, key: localKey };
    }
  }
  
  return { url: '', key: '' };
}

let supabaseInstance: SupabaseClient | null = null;

// Create or get the Supabase client
export function getSupabaseClient(): SupabaseClient | null {
  // Return existing instance if available
  if (supabaseInstance) {
    return supabaseInstance;
  }
  
  const { url, key } = getSupabaseCredentials();
  
  if (!url || !key) {
    return null;
  }
  
  supabaseInstance = createClient(url, key, {
    auth: {
      persistSession: true,
      autoRefreshToken: true,
      detectSessionInUrl: true,
    },
  });
  
  return supabaseInstance;
}

// Initialize client on module load if env vars are available
const envUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || '';
const envKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '';

if (envUrl && envKey) {
  supabaseInstance = createClient(envUrl, envKey, {
    auth: {
      persistSession: true,
      autoRefreshToken: true,
      detectSessionInUrl: true,
    },
  });
}

// For backward compatibility, export as supabase (may be null)
export const supabase = supabaseInstance;

export function isSupabaseConfigured(): boolean {
  const { url, key } = getSupabaseCredentials();
  return !!(url && key);
}

// Re-initialize client (useful after onboarding)
export function initializeSupabase(): SupabaseClient | null {
  const { url, key } = getSupabaseCredentials();
  
  if (!url || !key) {
    return null;
  }
  
  supabaseInstance = createClient(url, key, {
    auth: {
      persistSession: true,
      autoRefreshToken: true,
      detectSessionInUrl: true,
    },
  });
  
  return supabaseInstance;
}

export async function checkSupabaseConnection(): Promise<boolean> {
  const client = getSupabaseClient();
  if (!client) {
    return false;
  }
  
  try {
    const { error } = await client.from('projects').select('count').limit(1);
    return !error;
  } catch {
    return false;
  }
}

export async function getCurrentUser() {
  const client = getSupabaseClient();
  if (!client) {
    return null;
  }
  
  try {
    const { data: { user }, error } = await client.auth.getUser();
    if (error) return null;
    return user;
  } catch {
    return null;
  }
}
