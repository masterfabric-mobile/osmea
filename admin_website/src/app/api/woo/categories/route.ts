import { NextRequest, NextResponse } from 'next/server';
import { getCategoryService } from '@/lib/services/category.service';
import type { CategoriesQuery } from '@/lib/services/category.service';

export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams;
    
    const query: CategoriesQuery = {
      page: parseInt(searchParams.get('page') || '1'),
      per_page: parseInt(searchParams.get('per_page') || '100'),
      search: searchParams.get('search') || undefined,
      parent: searchParams.get('parent') ? parseInt(searchParams.get('parent')!) : undefined,
      hide_empty: searchParams.get('hide_empty') === 'true',
      orderby: (searchParams.get('orderby') as CategoriesQuery['orderby']) || 'name',
      order: (searchParams.get('order') as CategoriesQuery['order']) || 'asc',
    };

    const categoryService = getCategoryService();
    const categories = await categoryService.getCategories(query);

    return NextResponse.json({
      success: true,
      data: categories,
    });
  } catch (error) {
    console.error('Get categories error:', error);
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch categories';
    return NextResponse.json(
      { success: false, error: errorMessage },
      { status: 500 }
    );
  }
}
