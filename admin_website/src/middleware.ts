import { createServerClient, type CookieOptions } from '@supabase/ssr';
import { NextResponse, type NextRequest } from 'next/server';

export async function middleware(request: NextRequest) {
  let response = NextResponse.next({
    request: {
      headers: request.headers,
    },
  });

  // API routes should always be allowed
  const isApiRoute = request.nextUrl.pathname.startsWith('/api');
  if (isApiRoute) {
    return response;
  }

  // Static files and Next.js internals - allow immediately
  const isStaticOrInternal = 
    request.nextUrl.pathname.startsWith('/_next') ||
    request.nextUrl.pathname.startsWith('/favicon') ||
    request.nextUrl.pathname.includes('.');

  if (isStaticOrInternal) {
    return response;
  }

  // Check if Supabase is configured via env vars OR if setup is complete via cookie
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  const setupComplete = request.cookies.get('osmea-setup-complete')?.value === 'true';
  const hasSupabaseConfig = !!(supabaseUrl && supabaseAnonKey);

  // If Supabase is NOT configured AND setup NOT complete
  if (!hasSupabaseConfig && !setupComplete) {
    const allowedPaths = ['/onboarding', '/splash', '/'];
    if (!allowedPaths.includes(request.nextUrl.pathname)) {
      return NextResponse.redirect(new URL('/onboarding', request.url));
    }
    return response;
  }

  // If setup is complete but no env vars (demo mode) - allow all dashboard access without auth
  if (setupComplete && !hasSupabaseConfig) {
    // Allow all paths in demo mode
    return response;
  }

  // Only proceed with Supabase auth if we have valid config
  if (!hasSupabaseConfig) {
    return response;
  }

  const supabase = createServerClient(
    supabaseUrl!,
    supabaseAnonKey!,
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
  const publicRoutes = [
    '/login',
    '/signup',
    '/forgot-password',
    '/reset-password',
    '/onboarding',
    '/splash',
    '/',
  ];

  const isPublicRoute = publicRoutes.some((route) =>
    request.nextUrl.pathname === route || request.nextUrl.pathname.startsWith(route + '/')
  );

  // If user is not logged in and trying to access protected route
  if (!session && !isPublicRoute) {
    const redirectUrl = request.nextUrl.clone();
    redirectUrl.pathname = '/login';
    redirectUrl.searchParams.set('redirect', request.nextUrl.pathname);
    return NextResponse.redirect(redirectUrl);
  }

  // If user is logged in and trying to access auth pages (login, signup, etc.)
  const authRoutes = ['/login', '/signup', '/forgot-password', '/reset-password'];
  const isAuthRoute = authRoutes.some((route) => request.nextUrl.pathname === route);
  
  if (session && isAuthRoute) {
    const redirectUrl = request.nextUrl.clone();
    redirectUrl.pathname = '/dashboard';
    return NextResponse.redirect(redirectUrl);
  }

  return response;
}

export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     * - public files
     */
    '/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)',
  ],
};
