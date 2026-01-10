import { NextRequest, NextResponse } from 'next/server';

export async function POST(request: NextRequest) {
  try {
    const { url } = await request.json();

    if (!url) {
      return NextResponse.json(
        { success: false, message: 'URL is required' },
        { status: 400 }
      );
    }

    // Validate URL format
    let parsedUrl: URL;
    try {
      parsedUrl = new URL(url);
      if (!['http:', 'https:'].includes(parsedUrl.protocol)) {
        throw new Error('Invalid protocol');
      }
    } catch {
      return NextResponse.json(
        { success: false, message: 'Invalid URL format. Make sure to include https://' },
        { status: 400 }
      );
    }

    const baseUrl = url.replace(/\/$/, '');

    // Helper function to try fetching with timeout
    const fetchWithTimeout = async (fetchUrl: string, method: string = 'GET', timeout: number = 8000) => {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), timeout);
      
      try {
        const response = await fetch(fetchUrl, {
          method,
          signal: controller.signal,
          headers: {
            'User-Agent': 'Mozilla/5.0 (compatible; OSMEA-Admin-Panel/1.0)',
            'Accept': 'text/html,application/json,*/*',
          },
          redirect: 'follow',
        });
        clearTimeout(timeoutId);
        return { response, error: null };
      } catch (error) {
        clearTimeout(timeoutId);
        return { response: null, error };
      }
    };

    // Try to reach the website (try GET if HEAD fails, as some servers block HEAD)
    let mainResponse = await fetchWithTimeout(baseUrl, 'HEAD');
    
    // If HEAD fails, try GET
    if (!mainResponse.response || !mainResponse.response.ok) {
      mainResponse = await fetchWithTimeout(baseUrl, 'GET');
    }

    // Check if we could reach the site at all
    if (!mainResponse.response) {
      const error = mainResponse.error;
      
      if (error instanceof Error) {
        if (error.name === 'AbortError') {
          return NextResponse.json({
            success: false,
            message: 'Connection timed out. The website may be slow or unreachable.',
            details: 'timeout',
          });
        }
        
        // Check for common network errors
        const errorMessage = error.message.toLowerCase();
        if (errorMessage.includes('enotfound') || errorMessage.includes('getaddrinfo')) {
          return NextResponse.json({
            success: false,
            message: 'Domain not found. Please check if the URL is correct.',
            details: 'dns_error',
          });
        }
        if (errorMessage.includes('econnrefused')) {
          return NextResponse.json({
            success: false,
            message: 'Connection refused. The server may be down.',
            details: 'connection_refused',
          });
        }
        if (errorMessage.includes('cert') || errorMessage.includes('ssl')) {
          return NextResponse.json({
            success: false,
            message: 'SSL certificate error. The site may have security issues.',
            details: 'ssl_error',
          });
        }
      }
      
      return NextResponse.json({
        success: false,
        message: 'Unable to connect to the website. Please verify the URL.',
        details: 'network_error',
      });
    }

    const response = mainResponse.response;
    
    // Website is reachable - now check for WooCommerce
    let hasWooCommerce = false;
    let wooCheckMessage = '';

    // Try to detect WooCommerce via REST API
    const wooApiUrl = `${baseUrl}/wp-json/wc/v3/`;
    const wooResult = await fetchWithTimeout(wooApiUrl, 'GET', 5000);

    if (wooResult.response) {
      const wooStatus = wooResult.response.status;
      // 401 = WooCommerce installed but needs auth (good!)
      // 200 = WooCommerce accessible (good!)
      // 404 = WooCommerce not installed or REST API disabled
      if (wooStatus === 401 || wooStatus === 200) {
        hasWooCommerce = true;
        wooCheckMessage = 'WooCommerce REST API detected!';
      } else if (wooStatus === 404) {
        wooCheckMessage = 'WooCommerce REST API not found. Please ensure WooCommerce is installed and REST API is enabled.';
      }
    }

    // Also try WordPress REST API to confirm it's WordPress
    if (!hasWooCommerce) {
      const wpApiUrl = `${baseUrl}/wp-json/`;
      const wpResult = await fetchWithTimeout(wpApiUrl, 'GET', 5000);
      
      if (wpResult.response && (wpResult.response.status === 200 || wpResult.response.status === 401)) {
        wooCheckMessage = 'WordPress detected, but WooCommerce REST API not found. Please ensure WooCommerce is installed.';
      }
    }

    // Success - website is reachable
    return NextResponse.json({
      success: true,
      status: response.status,
      hasWooCommerce,
      message: hasWooCommerce 
        ? `Website verified! ${wooCheckMessage}`
        : `Website is reachable (${response.status}). ${wooCheckMessage || 'You can now enter your API keys.'}`,
      details: 'success',
    });

  } catch (error) {
    console.error('URL check error:', error);
    return NextResponse.json({
      success: false, 
      message: 'An unexpected error occurred. Please try again.',
      details: 'internal_error',
    });
  }
}
