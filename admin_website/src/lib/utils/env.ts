/**
 * Environment detection utilities
 */

/**
 * Check if the application is running in local development mode
 * This checks both NODE_ENV and hostname to ensure it's truly local
 */
export function isLocalDevelopment(): boolean {
  if (typeof window === 'undefined') {
    // Server-side: check NODE_ENV only
    return process.env.NODE_ENV === 'development';
  }
  
  // Client-side: check both NODE_ENV and hostname
  return (
    process.env.NODE_ENV === 'development' &&
    (window.location.hostname === 'localhost' ||
     window.location.hostname === '127.0.0.1' ||
     window.location.hostname === '0.0.0.0')
  );
}

/**
 * Get the base path to the storefront_woo project
 * This assumes the admin_website is at admin_website/ and storefront_woo is at projects/storefront_woo/
 */
export function getStorefrontWooPath(): string {
  if (typeof window === 'undefined') {
    // Server-side: use process.cwd() and navigate relative
    const path = require('path');
    return path.resolve(process.cwd(), '..', 'projects', 'storefront_woo');
  }
  
  // Client-side: not applicable, but return relative path for reference
  return '../projects/storefront_woo';
}
