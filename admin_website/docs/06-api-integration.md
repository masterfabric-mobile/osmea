# API Integration Guide

**Project:** OSMEA Admin Website  
**Version:** 1.0.0  
**Date:** 2026-01-09  
**APIs:** WooCommerce REST API + Supabase

---

## 📋 Overview

This document covers the complete API integration strategy for the Admin Website, including WooCommerce REST API integration, Supabase client implementation, error handling, rate limiting, and best practices.

---

## 🎯 API Architecture

### API Integration Flow

```
Admin Panel UI
      ↓
Next.js Server Actions / API Routes
      ↓
Service Layer (Business Logic)
      ↓
API Clients
      ├─→ WooCommerce REST API
      └─→ Supabase API
```

---

## 🛍️ WooCommerce API Integration

### 1. WooCommerce Client Setup

```typescript
// src/lib/woocommerce/client.ts
import axios, { AxiosInstance, AxiosError } from 'axios';

interface WooCommerceConfig {
  storeUrl: string;
  consumerKey: string;
  consumerSecret: string;
  version?: string;
  timeout?: number;
}

export class WooCommerceClient {
  private client: AxiosInstance;
  private config: WooCommerceConfig;

  constructor(config: WooCommerceConfig) {
    this.config = {
      version: 'wc/v3',
      timeout: 30000,
      ...config,
    };

    this.client = axios.create({
      baseURL: `${config.storeUrl}/wp-json/${this.config.version}`,
      timeout: this.config.timeout,
      auth: {
        username: config.consumerKey,
        password: config.consumerSecret,
      },
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    });

    // Add request interceptor for logging
    this.client.interceptors.request.use(
      (config) => {
        console.log(`[WooCommerce] ${config.method?.toUpperCase()} ${config.url}`);
        return config;
      },
      (error) => {
        console.error('[WooCommerce] Request error:', error);
        return Promise.reject(error);
      }
    );

    // Add response interceptor for error handling
    this.client.interceptors.response.use(
      (response) => response,
      (error: AxiosError) => {
        return this.handleError(error);
      }
    );
  }

  private handleError(error: AxiosError) {
    if (error.response) {
      // Server responded with error
      const status = error.response.status;
      const data = error.response.data as any;

      switch (status) {
        case 401:
          throw new Error('WooCommerce authentication failed. Check your credentials.');
        case 403:
          throw new Error('Access forbidden. Check your API permissions.');
        case 404:
          throw new Error('Resource not found.');
        case 429:
          throw new Error('Rate limit exceeded. Please try again later.');
        default:
          throw new Error(data?.message || 'WooCommerce API error');
      }
    } else if (error.request) {
      // Request made but no response
      throw new Error('No response from WooCommerce. Check your store URL.');
    } else {
      // Something else happened
      throw new Error(`Request failed: ${error.message}`);
    }
  }

  // Generic GET request
  async get<T>(endpoint: string, params?: Record<string, any>): Promise<T> {
    const response = await this.client.get(endpoint, { params });
    return response.data;
  }

  // Generic POST request
  async post<T>(endpoint: string, data: any): Promise<T> {
    const response = await this.client.post(endpoint, data);
    return response.data;
  }

  // Generic PUT request
  async put<T>(endpoint: string, data: any): Promise<T> {
    const response = await this.client.put(endpoint, data);
    return response.data;
  }

  // Generic DELETE request
  async delete<T>(endpoint: string, params?: Record<string, any>): Promise<T> {
    const response = await this.client.delete(endpoint, { params });
    return response.data;
  }
}

// Singleton instance
let wooCommerceClient: WooCommerceClient | null = null;

export function getWooCommerceClient(): WooCommerceClient {
  if (!wooCommerceClient) {
    wooCommerceClient = new WooCommerceClient({
      storeUrl: process.env.WOOCOMMERCE_STORE_URL!,
      consumerKey: process.env.WOOCOMMERCE_CONSUMER_KEY!,
      consumerSecret: process.env.WOOCOMMERCE_CONSUMER_SECRET!,
    });
  }
  return wooCommerceClient;
}
```

### 2. Product API Service

```typescript
// src/lib/services/product.service.ts
import { getWooCommerceClient } from '@/lib/woocommerce/client';

export interface Product {
  id: number;
  name: string;
  slug: string;
  permalink: string;
  type: 'simple' | 'grouped' | 'external' | 'variable';
  status: 'draft' | 'pending' | 'private' | 'publish';
  featured: boolean;
  catalog_visibility: 'visible' | 'catalog' | 'search' | 'hidden';
  description: string;
  short_description: string;
  sku: string;
  price: string;
  regular_price: string;
  sale_price: string;
  on_sale: boolean;
  stock_status: 'instock' | 'outofstock' | 'onbackorder';
  stock_quantity: number | null;
  manage_stock: boolean;
  categories: Array<{ id: number; name: string; slug: string }>;
  images: Array<{ id: number; src: string; alt: string }>;
  attributes: any[];
  variations: number[];
  date_created: string;
  date_modified: string;
}

export interface ProductsQuery {
  page?: number;
  per_page?: number;
  search?: string;
  category?: number;
  status?: string;
  featured?: boolean;
  on_sale?: boolean;
  min_price?: number;
  max_price?: number;
  stock_status?: string;
  orderby?: 'date' | 'id' | 'title' | 'price';
  order?: 'asc' | 'desc';
}

export class ProductService {
  private client = getWooCommerceClient();

  async getProducts(query: ProductsQuery = {}): Promise<Product[]> {
    return this.client.get<Product[]>('/products', {
      page: query.page || 1,
      per_page: query.per_page || 20,
      search: query.search,
      category: query.category,
      status: query.status,
      featured: query.featured,
      on_sale: query.on_sale,
      min_price: query.min_price,
      max_price: query.max_price,
      stock_status: query.stock_status,
      orderby: query.orderby || 'date',
      order: query.order || 'desc',
    });
  }

  async getProduct(id: number): Promise<Product> {
    return this.client.get<Product>(`/products/${id}`);
  }

  async createProduct(data: Partial<Product>): Promise<Product> {
    return this.client.post<Product>('/products', data);
  }

  async updateProduct(id: number, data: Partial<Product>): Promise<Product> {
    return this.client.put<Product>(`/products/${id}`, data);
  }

  async deleteProduct(id: number, force: boolean = false): Promise<Product> {
    return this.client.delete<Product>(`/products/${id}`, { force });
  }

  async batchUpdateProducts(data: {
    create?: Partial<Product>[];
    update?: Partial<Product>[];
    delete?: number[];
  }): Promise<{ create: Product[]; update: Product[]; delete: Product[] }> {
    return this.client.post('/products/batch', data);
  }
}

export const productService = new ProductService();
```

### 3. Order API Service

```typescript
// src/lib/services/order.service.ts
import { getWooCommerceClient } from '@/lib/woocommerce/client';

export interface Order {
  id: number;
  parent_id: number;
  number: string;
  order_key: string;
  status: 'pending' | 'processing' | 'on-hold' | 'completed' | 'cancelled' | 'refunded' | 'failed';
  currency: string;
  total: string;
  total_tax: string;
  customer_id: number;
  billing: {
    first_name: string;
    last_name: string;
    company: string;
    address_1: string;
    address_2: string;
    city: string;
    state: string;
    postcode: string;
    country: string;
    email: string;
    phone: string;
  };
  shipping: {
    first_name: string;
    last_name: string;
    company: string;
    address_1: string;
    address_2: string;
    city: string;
    state: string;
    postcode: string;
    country: string;
  };
  payment_method: string;
  payment_method_title: string;
  transaction_id: string;
  line_items: Array<{
    id: number;
    name: string;
    product_id: number;
    variation_id: number;
    quantity: number;
    subtotal: string;
    total: string;
    sku: string;
  }>;
  date_created: string;
  date_modified: string;
  date_paid: string | null;
  date_completed: string | null;
}

export interface OrdersQuery {
  page?: number;
  per_page?: number;
  search?: string;
  status?: string;
  customer?: number;
  product?: number;
  after?: string;
  before?: string;
  orderby?: 'date' | 'id' | 'title';
  order?: 'asc' | 'desc';
}

export class OrderService {
  private client = getWooCommerceClient();

  async getOrders(query: OrdersQuery = {}): Promise<Order[]> {
    return this.client.get<Order[]>('/orders', {
      page: query.page || 1,
      per_page: query.per_page || 20,
      search: query.search,
      status: query.status,
      customer: query.customer,
      product: query.product,
      after: query.after,
      before: query.before,
      orderby: query.orderby || 'date',
      order: query.order || 'desc',
    });
  }

  async getOrder(id: number): Promise<Order> {
    return this.client.get<Order>(`/orders/${id}`);
  }

  async updateOrder(id: number, data: Partial<Order>): Promise<Order> {
    return this.client.put<Order>(`/orders/${id}`, data);
  }

  async deleteOrder(id: number, force: boolean = false): Promise<Order> {
    return this.client.delete<Order>(`/orders/${id}`, { force });
  }

  async updateOrderStatus(
    id: number,
    status: Order['status']
  ): Promise<Order> {
    return this.updateOrder(id, { status });
  }
}

export const orderService = new OrderService();
```

### 4. Category API Service

```typescript
// src/lib/services/category.service.ts
import { getWooCommerceClient } from '@/lib/woocommerce/client';

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

export class CategoryService {
  private client = getWooCommerceClient();

  async getCategories(): Promise<Category[]> {
    return this.client.get<Category[]>('/products/categories', {
      per_page: 100,
    });
  }

  async getCategory(id: number): Promise<Category> {
    return this.client.get<Category>(`/products/categories/${id}`);
  }

  async createCategory(data: Partial<Category>): Promise<Category> {
    return this.client.post<Category>('/products/categories', data);
  }

  async updateCategory(id: number, data: Partial<Category>): Promise<Category> {
    return this.client.put<Category>(`/products/categories/${id}`, data);
  }

  async deleteCategory(id: number, force: boolean = false): Promise<Category> {
    return this.client.delete<Category>(`/products/categories/${id}`, { force });
  }
}

export const categoryService = new CategoryService();
```

---

## 🗄️ Supabase API Integration

### 1. Supabase Service Layer

```typescript
// src/lib/services/supabase.service.ts
import { createClient } from '@/lib/supabase/server';

export class SupabaseService {
  private supabase = createClient();

  // Configuration Management
  async getConfigurations(storeId: string) {
    const { data, error } = await this.supabase
      .from('app_configurations')
      .select('*')
      .eq('store_id', storeId)
      .eq('is_active', true)
      .order('version', { ascending: false });

    if (error) throw error;
    return data;
  }

  async getActiveConfiguration(storeId: string, configKey: string, environment: string = 'production') {
    const { data, error } = await this.supabase
      .from('app_configurations')
      .select('*')
      .eq('store_id', storeId)
      .eq('config_key', configKey)
      .eq('environment', environment)
      .eq('is_active', true)
      .eq('is_published', true)
      .order('version', { ascending: false })
      .limit(1)
      .single();

    if (error) throw error;
    return data;
  }

  async createConfiguration(data: {
    storeId: string;
    configKey: string;
    configValue: any;
    environment: string;
    description?: string;
  }) {
    const { data: result, error } = await this.supabase
      .from('app_configurations')
      .insert({
        store_id: data.storeId,
        config_key: data.configKey,
        config_value: data.configValue,
        environment: data.environment,
        description: data.description,
        is_active: true,
        is_published: false,
      })
      .select()
      .single();

    if (error) throw error;
    return result;
  }

  async updateConfiguration(id: string, configValue: any) {
    const { data, error } = await this.supabase
      .from('app_configurations')
      .update({
        config_value: configValue,
        updated_at: new Date().toISOString(),
      })
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;
    return data;
  }

  async publishConfiguration(id: string) {
    const { data, error } = await this.supabase
      .from('app_configurations')
      .update({
        is_published: true,
        published_at: new Date().toISOString(),
      })
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;
    return data;
  }

  // Build Management
  async getBuilds(storeId: string, limit: number = 20) {
    const { data, error } = await this.supabase
      .from('builds')
      .select('*')
      .eq('store_id', storeId)
      .order('created_at', { ascending: false })
      .limit(limit);

    if (error) throw error;
    return data;
  }

  async getBuild(buildId: string) {
    const { data, error } = await this.supabase
      .from('builds')
      .select('*')
      .eq('id', buildId)
      .single();

    if (error) throw error;
    return data;
  }

  async createBuild(data: {
    storeId: string;
    platform: 'ios' | 'android';
    buildType: string;
    environment: string;
    version: string;
    buildNumber: string;
  }) {
    const { data: result, error } = await this.supabase
      .from('builds')
      .insert({
        store_id: data.storeId,
        platform: data.platform,
        build_type: data.buildType,
        environment: data.environment,
        version: data.version,
        build_number: data.buildNumber,
        status: 'pending',
      })
      .select()
      .single();

    if (error) throw error;
    return result;
  }

  async updateBuildStatus(buildId: string, status: string, additionalData?: any) {
    const { data, error } = await this.supabase
      .from('builds')
      .update({
        status,
        ...additionalData,
        updated_at: new Date().toISOString(),
      })
      .eq('id', buildId)
      .select()
      .single();

    if (error) throw error;
    return data;
  }

  async getBuildLogs(buildId: string) {
    const { data, error } = await this.supabase
      .from('build_logs')
      .select('*')
      .eq('build_id', buildId)
      .order('timestamp', { ascending: true });

    if (error) throw error;
    return data;
  }

  async addBuildLog(data: {
    buildId: string;
    logLevel: string;
    message: string;
    source?: string;
    step?: string;
  }) {
    const { error } = await this.supabase
      .from('build_logs')
      .insert({
        build_id: data.buildId,
        log_level: data.logLevel,
        message: data.message,
        source: data.source,
        step: data.step,
      });

    if (error) throw error;
  }

  // Sync Queue Management
  async getSyncQueue(storeId: string) {
    const { data, error } = await this.supabase
      .from('sync_queue')
      .select('*')
      .eq('store_id', storeId)
      .eq('status', 'pending')
      .order('priority', { ascending: false })
      .order('created_at', { ascending: true });

    if (error) throw error;
    return data;
  }

  async addToSyncQueue(data: {
    storeId: string;
    entityType: string;
    operation: string;
    payload: any;
    priority?: number;
  }) {
    const { data: result, error } = await this.supabase
      .from('sync_queue')
      .insert({
        store_id: data.storeId,
        entity_type: data.entityType,
        operation: data.operation,
        payload: data.payload,
        priority: data.priority || 5,
        status: 'pending',
      })
      .select()
      .single();

    if (error) throw error;
    return result;
  }

  async updateSyncQueueItem(id: string, status: string, errorMessage?: string) {
    const { data, error } = await this.supabase
      .from('sync_queue')
      .update({
        status,
        error_message: errorMessage,
        updated_at: new Date().toISOString(),
        synced_at: status === 'completed' ? new Date().toISOString() : null,
      })
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;
    return data;
  }

  // Real-time Subscriptions
  subscribeToBuildUpdates(buildId: string, callback: (payload: any) => void) {
    return this.supabase
      .channel(`build:${buildId}`)
      .on(
        'postgres_changes',
        {
          event: 'UPDATE',
          schema: 'public',
          table: 'builds',
          filter: `id=eq.${buildId}`,
        },
        callback
      )
      .subscribe();
  }

  subscribeToBuildLogs(buildId: string, callback: (payload: any) => void) {
    return this.supabase
      .channel(`build-logs:${buildId}`)
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'build_logs',
          filter: `build_id=eq.${buildId}`,
        },
        callback
      )
      .subscribe();
  }
}

export const supabaseService = new SupabaseService();
```

---

## 🔄 Server Actions

### Configuration Actions

```typescript
// src/actions/config.actions.ts
'use server';

import { revalidatePath } from 'next/cache';
import { supabaseService } from '@/lib/services/supabase.service';
import { createAuditLog } from '@/lib/utils/audit';

export async function getConfigurations(storeId: string) {
  try {
    const configs = await supabaseService.getConfigurations(storeId);
    return { success: true, data: configs };
  } catch (error: any) {
    return { success: false, error: error.message };
  }
}

export async function updateConfiguration(
  id: string,
  configValue: any,
  storeId: string
) {
  try {
    const result = await supabaseService.updateConfiguration(id, configValue);
    
    await createAuditLog({
      action: 'config:update',
      entityType: 'configuration',
      entityId: id,
      newValue: configValue,
    });

    revalidatePath('/dashboard/config');
    
    return { success: true, data: result };
  } catch (error: any) {
    return { success: false, error: error.message };
  }
}

export async function publishConfiguration(id: string) {
  try {
    const result = await supabaseService.publishConfiguration(id);
    
    await createAuditLog({
      action: 'config:publish',
      entityType: 'configuration',
      entityId: id,
    });

    revalidatePath('/dashboard/config');
    
    return { success: true, data: result };
  } catch (error: any) {
    return { success: false, error: error.message };
  }
}
```

### Product Actions

```typescript
// src/actions/product.actions.ts
'use server';

import { revalidatePath } from 'next/cache';
import { productService } from '@/lib/services/product.service';
import { createAuditLog } from '@/lib/utils/audit';

export async function getProducts(query: any = {}) {
  try {
    const products = await productService.getProducts(query);
    return { success: true, data: products };
  } catch (error: any) {
    return { success: false, error: error.message };
  }
}

export async function createProduct(data: any) {
  try {
    const product = await productService.createProduct(data);
    
    await createAuditLog({
      action: 'product:create',
      entityType: 'product',
      entityId: product.id.toString(),
      newValue: product,
    });

    revalidatePath('/dashboard/products');
    
    return { success: true, data: product };
  } catch (error: any) {
    return { success: false, error: error.message };
  }
}

export async function updateProduct(id: number, data: any) {
  try {
    const product = await productService.updateProduct(id, data);
    
    await createAuditLog({
      action: 'product:update',
      entityType: 'product',
      entityId: id.toString(),
      newValue: data,
    });

    revalidatePath('/dashboard/products');
    revalidatePath(`/dashboard/products/${id}`);
    
    return { success: true, data: product };
  } catch (error: any) {
    return { success: false, error: error.message };
  }
}

export async function deleteProduct(id: number) {
  try {
    await productService.deleteProduct(id, true);
    
    await createAuditLog({
      action: 'product:delete',
      entityType: 'product',
      entityId: id.toString(),
    });

    revalidatePath('/dashboard/products');
    
    return { success: true };
  } catch (error: any) {
    return { success: false, error: error.message };
  }
}
```

---

## ⚠️ Error Handling

### API Error Types

```typescript
// src/lib/types/api.types.ts
export class APIError extends Error {
  constructor(
    message: string,
    public statusCode: number,
    public code?: string
  ) {
    super(message);
    this.name = 'APIError';
  }
}

export class ValidationError extends APIError {
  constructor(message: string, public errors: Record<string, string[]>) {
    super(message, 400, 'VALIDATION_ERROR');
    this.name = 'ValidationError';
  }
}

export class AuthenticationError extends APIError {
  constructor(message: string = 'Authentication failed') {
    super(message, 401, 'AUTHENTICATION_ERROR');
    this.name = 'AuthenticationError';
  }
}

export class RateLimitError extends APIError {
  constructor(message: string = 'Rate limit exceeded') {
    super(message, 429, 'RATE_LIMIT_ERROR');
    this.name = 'RateLimitError';
  }
}
```

### Error Handler Utility

```typescript
// src/lib/utils/error-handler.ts
import { APIError } from '@/lib/types/api.types';
import { toast } from 'sonner';

export function handleAPIError(error: unknown) {
  console.error('API Error:', error);

  if (error instanceof APIError) {
    toast.error(error.message);
    return {
      message: error.message,
      statusCode: error.statusCode,
      code: error.code,
    };
  }

  if (error instanceof Error) {
    toast.error(error.message);
    return {
      message: error.message,
      statusCode: 500,
    };
  }

  toast.error('An unexpected error occurred');
  return {
    message: 'An unexpected error occurred',
    statusCode: 500,
  };
}
```

---

## 🔄 Rate Limiting

### Rate Limiter Implementation

```typescript
// src/lib/utils/rate-limiter.ts
interface RateLimitConfig {
  maxRequests: number;
  windowMs: number;
}

class RateLimiter {
  private requests: Map<string, number[]> = new Map();
  private config: RateLimitConfig;

  constructor(config: RateLimitConfig) {
    this.config = config;
  }

  async checkLimit(key: string): Promise<boolean> {
    const now = Date.now();
    const windowStart = now - this.config.windowMs;

    // Get existing requests for this key
    let timestamps = this.requests.get(key) || [];
    
    // Filter out old requests
    timestamps = timestamps.filter(ts => ts > windowStart);

    // Check if limit exceeded
    if (timestamps.length >= this.config.maxRequests) {
      return false;
    }

    // Add new request
    timestamps.push(now);
    this.requests.set(key, timestamps);

    return true;
  }

  async reset(key: string) {
    this.requests.delete(key);
  }
}

// WooCommerce rate limiter (60 requests per minute)
export const wooCommerceLimiter = new RateLimiter({
  maxRequests: 60,
  windowMs: 60 * 1000,
});

// Supabase rate limiter (100 requests per minute)
export const supabaseLimiter = new RateLimiter({
  maxRequests: 100,
  windowMs: 60 * 1000,
});
```

---

## 🧪 API Testing

### Test Utilities

```typescript
// src/lib/utils/api-test.ts
import { getWooCommerceClient } from '@/lib/woocommerce/client';

export async function testWooCommerceConnection(): Promise<{
  success: boolean;
  message: string;
  data?: any;
}> {
  try {
    const client = getWooCommerceClient();
    const data = await client.get('/system_status');
    
    return {
      success: true,
      message: 'WooCommerce connection successful',
      data,
    };
  } catch (error: any) {
    return {
      success: false,
      message: error.message || 'Failed to connect to WooCommerce',
    };
  }
}

export async function testSupabaseConnection(): Promise<{
  success: boolean;
  message: string;
}> {
  try {
    const { createClient } = await import('@/lib/supabase/server');
    const supabase = createClient();
    
    const { error } = await supabase.from('stores').select('count').limit(1);
    
    if (error) throw error;
    
    return {
      success: true,
      message: 'Supabase connection successful',
    };
  } catch (error: any) {
    return {
      success: false,
      message: error.message || 'Failed to connect to Supabase',
    };
  }
}
```

---

## ✅ Best Practices

### API Integration Checklist

- [ ] Implement proper error handling
- [ ] Add rate limiting
- [ ] Use TypeScript for type safety
- [ ] Implement retry logic for failed requests
- [ ] Cache responses where appropriate
- [ ] Log all API calls for debugging
- [ ] Use environment variables for credentials
- [ ] Implement request timeouts
- [ ] Handle network failures gracefully
- [ ] Add request/response interceptors
- [ ] Implement pagination for large datasets
- [ ] Use batch operations when possible
- [ ] Validate data before sending to API
- [ ] Implement audit logging
- [ ] Add unit tests for API clients

---

**Document Version:** 1.0.0  
**Last Updated:** 2026-01-09  
**Status:** Complete
