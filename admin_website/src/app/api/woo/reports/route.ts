import { NextRequest, NextResponse } from 'next/server';

// GET method to fetch reports with credentials from query params or body
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const storeUrl = searchParams.get('storeUrl');
    const consumerKey = searchParams.get('consumerKey');
    const consumerSecret = searchParams.get('consumerSecret');
    const reportType = searchParams.get('type') || 'sales'; // sales, orders, products, customers

    if (!storeUrl || !consumerKey || !consumerSecret) {
      return NextResponse.json(
        { error: 'Missing WooCommerce credentials' },
        { status: 400 }
      );
    }

    // Build the WooCommerce API URL
    const baseUrl = storeUrl.replace(/\/$/, '');
    let endpoint = '/reports/sales';
    
    switch (reportType) {
      case 'orders':
        endpoint = '/reports/orders/totals';
        break;
      case 'products':
        endpoint = '/reports/products/totals';
        break;
      case 'customers':
        endpoint = '/reports/customers/totals';
        break;
      case 'sales':
      default:
        endpoint = '/reports/sales';
        break;
    }

    const apiUrl = `${baseUrl}/wp-json/wc/v3${endpoint}`;

    // Create Basic Auth header
    const auth = Buffer.from(`${consumerKey}:${consumerSecret}`).toString('base64');

    const response = await fetch(apiUrl, {
      method: 'GET',
      headers: {
        'Authorization': `Basic ${auth}`,
        'Content-Type': 'application/json',
      },
    });

    if (!response.ok) {
      const errorText = await response.text();
      console.error('WooCommerce Reports API error:', response.status, errorText);
      
      if (response.status === 401) {
        return NextResponse.json(
          { error: 'Invalid WooCommerce API credentials.' },
          { status: 401 }
        );
      }

      return NextResponse.json(
        { error: `WooCommerce API error: ${response.status}` },
        { status: response.status }
      );
    }

    const data = await response.json();

    return NextResponse.json({
      success: true,
      reportType,
      data,
    });

  } catch (error) {
    console.error('Fetch reports error:', error);
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch reports';
    return NextResponse.json(
      { error: errorMessage },
      { status: 500 }
    );
  }
}

// POST method to fetch reports with credentials from request body
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { storeUrl, consumerKey, consumerSecret, reportType = 'sales', dateMin, dateMax, period } = body;

    if (!storeUrl || !consumerKey || !consumerSecret) {
      return NextResponse.json(
        { error: 'Missing WooCommerce credentials' },
        { status: 400 }
      );
    }

    // Build the WooCommerce API URL
    const baseUrl = storeUrl.replace(/\/$/, '');
    let endpoint = '/reports/sales';
    
    switch (reportType) {
      case 'orders':
        endpoint = '/reports/orders/totals';
        break;
      case 'products':
        endpoint = '/reports/products/totals';
        break;
      case 'customers':
        endpoint = '/reports/customers/totals';
        break;
      case 'sales':
      default:
        endpoint = '/reports/sales';
        break;
    }

    // Build query params for sales report
    const params = new URLSearchParams();
    if (dateMin) params.append('date_min', dateMin);
    if (dateMax) params.append('date_max', dateMax);
    if (period) params.append('period', period);

    const queryString = params.toString();
    const apiUrl = `${baseUrl}/wp-json/wc/v3${endpoint}${queryString ? `?${queryString}` : ''}`;

    // Create Basic Auth header
    const auth = Buffer.from(`${consumerKey}:${consumerSecret}`).toString('base64');

    const response = await fetch(apiUrl, {
      method: 'GET',
      headers: {
        'Authorization': `Basic ${auth}`,
        'Content-Type': 'application/json',
      },
    });

    if (!response.ok) {
      const errorText = await response.text();
      console.error('WooCommerce Reports API error:', response.status, errorText);
      
      if (response.status === 401) {
        return NextResponse.json(
          { error: 'Invalid WooCommerce API credentials.' },
          { status: 401 }
        );
      }

      return NextResponse.json(
        { error: `WooCommerce API error: ${response.status}` },
        { status: response.status }
      );
    }

    const data = await response.json();

    return NextResponse.json({
      success: true,
      reportType,
      data,
    });

  } catch (error) {
    console.error('Fetch reports error:', error);
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch reports';
    return NextResponse.json(
      { error: errorMessage },
      { status: 500 }
    );
  }
}
