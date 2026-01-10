import { getWooCommerceClient, WooCommerceClient } from '@/lib/woocommerce/client';

export interface Category {
  id: number;
  name: string;
  slug: string;
  parent: number;
  description: string;
  display: 'default' | 'products' | 'subcategories' | 'both';
  image: {
    id: number;
    src: string;
    alt: string;
  } | null;
  menu_order: number;
  count: number;
}

export interface CategoriesQuery {
  page?: number;
  per_page?: number;
  search?: string;
  parent?: number;
  hide_empty?: boolean;
  orderby?: 'id' | 'include' | 'name' | 'slug' | 'term_group' | 'description' | 'count';
  order?: 'asc' | 'desc';
  include?: number[];
  exclude?: number[];
}

export interface CategoryCreateInput {
  name: string;
  slug?: string;
  parent?: number;
  description?: string;
  display?: Category['display'];
  image?: {
    id?: number;
    src?: string;
    alt?: string;
  };
  menu_order?: number;
}

export interface CategoryUpdateInput extends Partial<CategoryCreateInput> {}

export class CategoryService {
  private client: WooCommerceClient | null;

  constructor(client?: WooCommerceClient) {
    this.client = client || getWooCommerceClient();
  }

  private ensureClient(): WooCommerceClient {
    if (!this.client) {
      throw new Error('WooCommerce client is not initialized');
    }
    return this.client;
  }

  async getCategories(query: CategoriesQuery = {}): Promise<Category[]> {
    const client = this.ensureClient();
    return client.get<Category[]>('/products/categories', {
      page: query.page || 1,
      per_page: query.per_page || 100,
      search: query.search,
      parent: query.parent,
      hide_empty: query.hide_empty,
      orderby: query.orderby || 'name',
      order: query.order || 'asc',
      include: query.include?.join(','),
      exclude: query.exclude?.join(','),
    });
  }

  async getCategory(id: number): Promise<Category> {
    const client = this.ensureClient();
    return client.get<Category>(`/products/categories/${id}`);
  }

  async createCategory(data: CategoryCreateInput): Promise<Category> {
    const client = this.ensureClient();
    return client.post<Category>('/products/categories', data);
  }

  async updateCategory(id: number, data: CategoryUpdateInput): Promise<Category> {
    const client = this.ensureClient();
    return client.put<Category>(`/products/categories/${id}`, data);
  }

  async deleteCategory(id: number, force: boolean = false): Promise<Category> {
    const client = this.ensureClient();
    return client.delete<Category>(`/products/categories/${id}`, { force });
  }

  // Batch operations
  async batchCategories(data: {
    create?: CategoryCreateInput[];
    update?: (CategoryUpdateInput & { id: number })[];
    delete?: number[];
  }): Promise<{
    create: Category[];
    update: Category[];
    delete: Category[];
  }> {
    const client = this.ensureClient();
    return client.post('/products/categories/batch', data);
  }

  // Helper methods
  async getRootCategories(): Promise<Category[]> {
    return this.getCategories({ parent: 0 });
  }

  async getSubcategories(parentId: number): Promise<Category[]> {
    return this.getCategories({ parent: parentId });
  }

  async getCategoryTree(): Promise<CategoryNode[]> {
    const categories = await this.getCategories({ per_page: 100 });
    return buildCategoryTree(categories);
  }
}

// Helper types and functions for category tree
export interface CategoryNode extends Category {
  children: CategoryNode[];
}

function buildCategoryTree(categories: Category[]): CategoryNode[] {
  const categoryMap = new Map<number, CategoryNode>();
  const roots: CategoryNode[] = [];

  // First pass: create nodes
  categories.forEach((category) => {
    categoryMap.set(category.id, { ...category, children: [] });
  });

  // Second pass: build tree
  categories.forEach((category) => {
    const node = categoryMap.get(category.id)!;
    if (category.parent === 0) {
      roots.push(node);
    } else {
      const parent = categoryMap.get(category.parent);
      if (parent) {
        parent.children.push(node);
      } else {
        // Parent not found, treat as root
        roots.push(node);
      }
    }
  });

  return roots;
}

// Singleton instance
let categoryService: CategoryService | null = null;

export function getCategoryService(): CategoryService {
  if (!categoryService) {
    categoryService = new CategoryService();
  }
  return categoryService;
}

export function createCategoryService(client: WooCommerceClient): CategoryService {
  return new CategoryService(client);
}
