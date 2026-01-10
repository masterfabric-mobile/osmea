import { getWooCommerceClient, WooCommerceClient } from '@/lib/woocommerce/client';
import type {
  Product,
  ProductsQuery,
  ProductCreateInput,
  ProductUpdateInput,
  ProductBatchInput,
  ProductBatchResult,
} from '@/lib/types/product.types';

export class ProductService {
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

  async getProducts(query: ProductsQuery = {}): Promise<Product[]> {
    const client = this.ensureClient();
    return client.get<Product[]>('/products', {
      page: query.page || 1,
      per_page: query.per_page || 20,
      search: query.search,
      category: query.category,
      tag: query.tag,
      status: query.status,
      featured: query.featured,
      on_sale: query.on_sale,
      min_price: query.min_price,
      max_price: query.max_price,
      stock_status: query.stock_status,
      orderby: query.orderby || 'date',
      order: query.order || 'desc',
      sku: query.sku,
      include: query.include?.join(','),
      exclude: query.exclude?.join(','),
    });
  }

  async getProduct(id: number): Promise<Product> {
    const client = this.ensureClient();
    return client.get<Product>(`/products/${id}`);
  }

  async createProduct(data: ProductCreateInput): Promise<Product> {
    const client = this.ensureClient();
    return client.post<Product>('/products', data);
  }

  async updateProduct(id: number, data: ProductUpdateInput): Promise<Product> {
    const client = this.ensureClient();
    return client.put<Product>(`/products/${id}`, data);
  }

  async deleteProduct(id: number, force: boolean = false): Promise<Product> {
    const client = this.ensureClient();
    return client.delete<Product>(`/products/${id}`, { force });
  }

  async batchProducts(data: ProductBatchInput): Promise<ProductBatchResult> {
    const client = this.ensureClient();
    return client.post<ProductBatchResult>('/products/batch', data);
  }

  // Product variations (for variable products)
  async getVariations(productId: number): Promise<Product[]> {
    const client = this.ensureClient();
    return client.get<Product[]>(`/products/${productId}/variations`);
  }

  async getVariation(productId: number, variationId: number): Promise<Product> {
    const client = this.ensureClient();
    return client.get<Product>(`/products/${productId}/variations/${variationId}`);
  }

  async createVariation(productId: number, data: ProductCreateInput): Promise<Product> {
    const client = this.ensureClient();
    return client.post<Product>(`/products/${productId}/variations`, data);
  }

  async updateVariation(
    productId: number,
    variationId: number,
    data: ProductUpdateInput
  ): Promise<Product> {
    const client = this.ensureClient();
    return client.put<Product>(`/products/${productId}/variations/${variationId}`, data);
  }

  async deleteVariation(
    productId: number,
    variationId: number,
    force: boolean = false
  ): Promise<Product> {
    const client = this.ensureClient();
    return client.delete<Product>(`/products/${productId}/variations/${variationId}`, { force });
  }

  // Product count
  async getProductCount(query: Omit<ProductsQuery, 'page' | 'per_page'> = {}): Promise<number> {
    // Get products with minimal data just to count
    const products = await this.getProducts({ ...query, per_page: 1 });
    // Note: In a real implementation, you'd use the X-WP-Total header from the response
    return products.length;
  }
}

// Singleton instance
let productService: ProductService | null = null;

export function getProductService(): ProductService {
  if (!productService) {
    productService = new ProductService();
  }
  return productService;
}

export function createProductService(client: WooCommerceClient): ProductService {
  return new ProductService(client);
}
