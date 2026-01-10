import { NextRequest, NextResponse } from 'next/server';
import { getProductService } from '@/lib/services/product.service';
import type { ProductsQuery } from '@/lib/types/product.types';

export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams;
    
    const query: ProductsQuery = {
      page: parseInt(searchParams.get('page') || '1'),
      per_page: parseInt(searchParams.get('per_page') || '20'),
      search: searchParams.get('search') || undefined,
      category: searchParams.get('category') ? parseInt(searchParams.get('category')!) : undefined,
      status: searchParams.get('status') || undefined,
      orderby: (searchParams.get('orderby') as ProductsQuery['orderby']) || 'date',
      order: (searchParams.get('order') as ProductsQuery['order']) || 'desc',
    };

    const productService = getProductService();
    const products = await productService.getProducts(query);

    return NextResponse.json({
      success: true,
      data: products,
      pagination: {
        page: query.page,
        per_page: query.per_page,
        total: products.length,
      },
    });
  } catch (error) {
    console.error('Get products error:', error);
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch products';
    return NextResponse.json(
      { success: false, error: errorMessage },
      { status: 500 }
    );
  }
}

// POST method to fetch products with credentials from request body
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { storeUrl, consumerKey, consumerSecret, page = 1, per_page = 100 } = body;

    if (!storeUrl || !consumerKey || !consumerSecret) {
      return NextResponse.json(
        { error: 'Missing WooCommerce credentials' },
        { status: 400 }
      );
    }

    // Build the WooCommerce API URL
    const baseUrl = storeUrl.replace(/\/$/, '');
    const apiUrl = `${baseUrl}/wp-json/wc/v3/products?page=${page}&per_page=${per_page}`;

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
          { error: 'Invalid WooCommerce API credentials. Please check your Consumer Key and Secret.' },
          { status: 401 }
        );
      }
      
      if (response.status === 404) {
        return NextResponse.json(
          { error: 'WooCommerce REST API not found. Please ensure WooCommerce is installed and REST API is enabled.' },
          { status: 404 }
        );
      }

      return NextResponse.json(
        { error: `WooCommerce API error: ${response.status}` },
        { status: response.status }
      );
    }

    const products = await response.json();
    
    // Get total count from headers
    const totalProducts = response.headers.get('X-WP-Total');
    const totalPages = response.headers.get('X-WP-TotalPages');

    return NextResponse.json({
      success: true,
      products,
      pagination: {
        page,
        per_page,
        total: totalProducts ? parseInt(totalProducts) : products.length,
        total_pages: totalPages ? parseInt(totalPages) : 1,
      },
    });

  } catch (error) {
    console.error('Fetch products error:', error);
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch products';
    return NextResponse.json(
      { error: errorMessage },
      { status: 500 }
    );
  }
}
