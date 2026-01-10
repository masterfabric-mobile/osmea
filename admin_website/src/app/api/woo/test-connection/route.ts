import { NextRequest, NextResponse } from 'next/server';
import { testWooCommerceConnection } from '@/lib/woocommerce/client';

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { storeUrl, consumerKey, consumerSecret } = body;

    if (!storeUrl || !consumerKey || !consumerSecret) {
      return NextResponse.json(
        { success: false, error: 'Missing required fields' },
        { status: 400 }
      );
    }

    const result = await testWooCommerceConnection({
      storeUrl,
      consumerKey,
      consumerSecret,
    });

    return NextResponse.json(result);
  } catch (error) {
    console.error('WooCommerce test connection error:', error);
    return NextResponse.json(
      { success: false, error: 'Internal server error' },
      { status: 500 }
    );
  }
}
