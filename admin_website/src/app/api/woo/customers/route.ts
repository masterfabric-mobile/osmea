import { NextRequest, NextResponse } from 'next/server';

// GET method to fetch customers with credentials from query params
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const storeUrl = searchParams.get('storeUrl');
    const consumerKey = searchParams.get('consumerKey');
    const consumerSecret = searchParams.get('consumerSecret');

    if (!storeUrl || !consumerKey || !consumerSecret) {
      return NextResponse.json(
        { error: 'Missing WooCommerce credentials' },
        { status: 400 }
      );
    }

    const page = parseInt(searchParams.get('page') || '1');
    const perPage = parseInt(searchParams.get('per_page') || '20');
    const search = searchParams.get('search') || undefined;
    const email = searchParams.get('email') || undefined;
    const role = searchParams.get('role') || undefined;
    const orderby = searchParams.get('orderby') || 'registered_date';
    const order = searchParams.get('order') || 'desc';

    // Build the WooCommerce API URL
    const baseUrl = storeUrl.replace(/\/$/, '');
    const params = new URLSearchParams({
      page: page.toString(),
      per_page: perPage.toString(),
      orderby,
      order,
    });

    if (search) params.append('search', search);
    if (email) params.append('email', email);
    if (role) params.append('role', role);

    const apiUrl = `${baseUrl}/wp-json/wc/v3/customers?${params.toString()}`;

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
      console.error('WooCommerce Customers API error:', response.status, errorText);
      
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

    const customers = await response.json();
    
    // Log for debugging
    console.log(`[Customers API] Fetched ${Array.isArray(customers) ? customers.length : 'unknown'} customers`);
    
    // Ensure customers is an array
    const customersArray = Array.isArray(customers) ? customers : [];
    
    // Get total count from headers
    const totalCustomers = response.headers.get('X-WP-Total');
    const totalPages = response.headers.get('X-WP-TotalPages');

    return NextResponse.json({
      success: true,
      customers: customersArray,
      pagination: {
        page,
        per_page: perPage,
        total: totalCustomers ? parseInt(totalCustomers) : customersArray.length,
        total_pages: totalPages ? parseInt(totalPages) : 1,
      },
    });

  } catch (error) {
    console.error('Fetch customers error:', error);
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch customers';
    return NextResponse.json(
      { error: errorMessage },
      { status: 500 }
    );
  }
}

// POST method to fetch customers with credentials from request body
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { storeUrl, consumerKey, consumerSecret, page = 1, per_page = 100, search, email, role, orderby = 'registered_date', order = 'desc' } = body;

    if (!storeUrl || !consumerKey || !consumerSecret) {
      return NextResponse.json(
        { error: 'Missing WooCommerce credentials' },
        { status: 400 }
      );
    }

    // Build the WooCommerce API URL
    const baseUrl = storeUrl.replace(/\/$/, '');
    const params = new URLSearchParams({
      page: page.toString(),
      per_page: per_page.toString(),
      orderby,
      order,
    });

    if (search) params.append('search', search);
    if (email) params.append('email', email);
    if (role) params.append('role', role);

    const apiUrl = `${baseUrl}/wp-json/wc/v3/customers?${params.toString()}`;

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
      console.error('WooCommerce Customers API error:', response.status, errorText);
      
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

    const customers = await response.json();
    
    // Log for debugging
    console.log(`[Customers API POST] Fetched ${Array.isArray(customers) ? customers.length : 'unknown'} customers`);
    console.log(`[Customers API POST] Response headers - X-WP-Total: ${response.headers.get('X-WP-Total')}, X-WP-TotalPages: ${response.headers.get('X-WP-TotalPages')}`);
    
    // Ensure customers is an array
    const customersArray = Array.isArray(customers) ? customers : [];
    
    // Get total count from headers
    const totalCustomers = response.headers.get('X-WP-Total');
    const totalPages = response.headers.get('X-WP-TotalPages');

    return NextResponse.json({
      success: true,
      customers: customersArray,
      pagination: {
        page,
        per_page: per_page,
        total: totalCustomers ? parseInt(totalCustomers) : customersArray.length,
        total_pages: totalPages ? parseInt(totalPages) : 1,
      },
    });

  } catch (error) {
    console.error('Fetch customers error:', error);
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch customers';
    return NextResponse.json(
      { error: errorMessage },
      { status: 500 }
    );
  }
}
