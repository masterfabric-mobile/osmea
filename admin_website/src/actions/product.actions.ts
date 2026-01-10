'use server';

import { revalidatePath } from 'next/cache';
import { getProductService } from '@/lib/services/product.service';
import type { ProductsQuery, ProductCreateInput, ProductUpdateInput } from '@/lib/types/product.types';

export async function getProducts(query: ProductsQuery = {}) {
  try {
    const productService = getProductService();
    const products = await productService.getProducts(query);
    return { success: true, data: products };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch products';
    return { success: false, error: errorMessage };
  }
}

export async function getProduct(id: number) {
  try {
    const productService = getProductService();
    const product = await productService.getProduct(id);
    return { success: true, data: product };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch product';
    return { success: false, error: errorMessage };
  }
}

export async function createProduct(data: ProductCreateInput) {
  try {
    const productService = getProductService();
    const product = await productService.createProduct(data);
    revalidatePath('/dashboard/products');
    return { success: true, data: product };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to create product';
    return { success: false, error: errorMessage };
  }
}

export async function updateProduct(id: number, data: ProductUpdateInput) {
  try {
    const productService = getProductService();
    const product = await productService.updateProduct(id, data);
    revalidatePath('/dashboard/products');
    revalidatePath(`/dashboard/products/${id}`);
    return { success: true, data: product };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to update product';
    return { success: false, error: errorMessage };
  }
}

export async function deleteProduct(id: number) {
  try {
    const productService = getProductService();
    await productService.deleteProduct(id, true);
    revalidatePath('/dashboard/products');
    return { success: true };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to delete product';
    return { success: false, error: errorMessage };
  }
}

export async function syncProducts() {
  try {
    const productService = getProductService();
    const products = await productService.getProducts({ per_page: 100 });
    revalidatePath('/dashboard/products');
    return { success: true, data: products, count: products.length };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to sync products';
    return { success: false, error: errorMessage };
  }
}
