import { NextRequest, NextResponse } from 'next/server';
import { getOrderService } from '@/lib/services/order.service';
import type { OrdersQuery, OrderStatus } from '@/lib/types/order.types';

export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams;
    
    const statusParam = searchParams.get('status');
    const query: OrdersQuery = {
      page: parseInt(searchParams.get('page') || '1'),
      per_page: parseInt(searchParams.get('per_page') || '20'),
      search: searchParams.get('search') || undefined,
      status: statusParam ? (statusParam as OrderStatus) : undefined,
      customer: searchParams.get('customer') ? parseInt(searchParams.get('customer')!) : undefined,
      orderby: (searchParams.get('orderby') as OrdersQuery['orderby']) || 'date',
      order: (searchParams.get('order') as OrdersQuery['order']) || 'desc',
    };

    const orderService = getOrderService();
    const orders = await orderService.getOrders(query);

    return NextResponse.json({
      success: true,
      data: orders,
      pagination: {
        page: query.page,
        per_page: query.per_page,
        total: orders.length,
      },
    });
  } catch (error) {
    console.error('Get orders error:', error);
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch orders';
    return NextResponse.json(
      { success: false, error: errorMessage },
      { status: 500 }
    );
  }
}

// POST method to fetch orders with credentials from request body
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { storeUrl, consumerKey, consumerSecret, page = 1, per_page = 100, status } = body;

    if (!storeUrl || !consumerKey || !consumerSecret) {
      return NextResponse.json(
        { error: 'Missing WooCommerce credentials' },
        { status: 400 }
      );
    }

    // Build the WooCommerce API URL
    const baseUrl = storeUrl.replace(/\/$/, '');
    let apiUrl = `${baseUrl}/wp-json/wc/v3/orders?page=${page}&per_page=${per_page}`;
    
    if (status) {
      apiUrl += `&status=${status}`;
    }

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
      console.error('WooCommerce API error:', response.status, errorText);
      
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

    const orders = await response.json();
    
    // Get total count from headers
    const totalOrders = response.headers.get('X-WP-Total');
    const totalPages = response.headers.get('X-WP-TotalPages');

    return NextResponse.json({
      success: true,
      orders,
      pagination: {
        page,
        per_page,
        total: totalOrders ? parseInt(totalOrders) : orders.length,
        total_pages: totalPages ? parseInt(totalPages) : 1,
      },
    });

  } catch (error) {
    console.error('Fetch orders error:', error);
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch orders';
    return NextResponse.json(
      { error: errorMessage },
      { status: 500 }
    );
  }
}
