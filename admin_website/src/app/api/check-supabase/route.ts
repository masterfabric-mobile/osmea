import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@supabase/supabase-js';

export async function POST(request: NextRequest) {
  try {
    const { url, anonKey } = await request.json();

    // Validate inputs
    if (!url) {
      return NextResponse.json({
        success: false,
        message: 'Supabase URL is required',
        field: 'url',
      });
    }

    if (!anonKey) {
      return NextResponse.json({
        success: false,
        message: 'Anon Key is required',
        field: 'anonKey',
      });
    }

    // Validate URL format
    let parsedUrl: URL;
    try {
      parsedUrl = new URL(url);
      if (!url.includes('supabase.co') && !url.includes('supabase.in')) {
        // Allow custom domains but warn
      }
    } catch {
      return NextResponse.json({
        success: false,
        message: 'Invalid URL format. Should be like: https://xxxxx.supabase.co',
        field: 'url',
        details: 'invalid_url',
      });
    }

    // Validate anon key format (JWT)
    if (!anonKey.startsWith('eyJ')) {
      return NextResponse.json({
        success: false,
        message: 'Invalid Anon Key format. It should start with "eyJ..."',
        field: 'anonKey',
        details: 'invalid_key_format',
      });
    }

    // Try to create Supabase client and test connection
    try {
      const supabase = createClient(url, anonKey, {
        auth: {
          persistSession: false,
          autoRefreshToken: false,
        },
      });

      // Test connection by making a simple request
      // We'll try to get the session (which should work even if no user is logged in)
      const startTime = Date.now();
      
      // Try to ping the health endpoint first
      const healthResponse = await fetch(`${url}/rest/v1/`, {
        method: 'GET',
        headers: {
          'apikey': anonKey,
          'Authorization': `Bearer ${anonKey}`,
        },
      });

      const responseTime = Date.now() - startTime;

      if (healthResponse.ok || healthResponse.status === 200) {
        return NextResponse.json({
          success: true,
          message: `Connected to Supabase successfully! (${responseTime}ms)`,
          details: 'connected',
          responseTime,
        });
      }

      // Try auth endpoint as backup
      const { error } = await supabase.auth.getSession();
      
      if (!error) {
        return NextResponse.json({
          success: true,
          message: `Supabase connection verified! (${responseTime}ms)`,
          details: 'connected',
          responseTime,
        });
      }

      // Check specific error types
      if (error.message.includes('Invalid API key')) {
        return NextResponse.json({
          success: false,
          message: 'Invalid API key. Please check your Anon Key.',
          field: 'anonKey',
          details: 'invalid_api_key',
        });
      }

      if (error.message.includes('Invalid URL') || error.message.includes('fetch')) {
        return NextResponse.json({
          success: false,
          message: 'Cannot reach Supabase. Please check your Project URL.',
          field: 'url',
          details: 'unreachable',
        });
      }

      // Generic error
      return NextResponse.json({
        success: false,
        message: error.message || 'Failed to connect to Supabase',
        details: 'connection_error',
      });

    } catch (connectionError) {
      const error = connectionError as Error;
      
      // Check for network errors
      if (error.message.includes('fetch') || error.message.includes('network')) {
        return NextResponse.json({
          success: false,
          message: 'Cannot reach Supabase server. Please check the URL.',
          field: 'url',
          details: 'network_error',
        });
      }

      if (error.message.includes('Invalid URL')) {
        return NextResponse.json({
          success: false,
          message: 'Invalid Supabase URL format.',
          field: 'url',
          details: 'invalid_url',
        });
      }

      return NextResponse.json({
        success: false,
        message: 'Connection failed. Please verify your credentials.',
        details: 'unknown_error',
      });
    }

  } catch (error) {
    console.error('Supabase check error:', error);
    return NextResponse.json({
      success: false,
      message: 'An unexpected error occurred. Please try again.',
      details: 'internal_error',
    });
  }
}
