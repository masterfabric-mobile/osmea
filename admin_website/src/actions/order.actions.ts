'use server';

import { revalidatePath } from 'next/cache';
import { getOrderService } from '@/lib/services/order.service';
import type { OrdersQuery, OrderUpdateInput, OrderStatus, OrderNoteInput } from '@/lib/types/order.types';

export async function getOrders(query: OrdersQuery = {}) {
  try {
    const orderService = getOrderService();
    const orders = await orderService.getOrders(query);
    return { success: true, data: orders };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch orders';
    return { success: false, error: errorMessage };
  }
}

export async function getOrder(id: number) {
  try {
    const orderService = getOrderService();
    const order = await orderService.getOrder(id);
    return { success: true, data: order };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch order';
    return { success: false, error: errorMessage };
  }
}

export async function updateOrder(id: number, data: OrderUpdateInput) {
  try {
    const orderService = getOrderService();
    const order = await orderService.updateOrder(id, data);
    revalidatePath('/dashboard/orders');
    revalidatePath(`/dashboard/orders/${id}`);
    return { success: true, data: order };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to update order';
    return { success: false, error: errorMessage };
  }
}

export async function updateOrderStatus(id: number, status: OrderStatus) {
  try {
    const orderService = getOrderService();
    const order = await orderService.updateOrderStatus(id, status);
    revalidatePath('/dashboard/orders');
    revalidatePath(`/dashboard/orders/${id}`);
    return { success: true, data: order };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to update order status';
    return { success: false, error: errorMessage };
  }
}

export async function getOrderNotes(orderId: number) {
  try {
    const orderService = getOrderService();
    const notes = await orderService.getOrderNotes(orderId);
    return { success: true, data: notes };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch order notes';
    return { success: false, error: errorMessage };
  }
}

export async function createOrderNote(orderId: number, data: OrderNoteInput) {
  try {
    const orderService = getOrderService();
    const note = await orderService.createOrderNote(orderId, data);
    revalidatePath(`/dashboard/orders/${orderId}`);
    return { success: true, data: note };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to create order note';
    return { success: false, error: errorMessage };
  }
}

export async function getRecentOrders(limit: number = 10) {
  try {
    const orderService = getOrderService();
    const orders = await orderService.getRecentOrders(limit);
    return { success: true, data: orders };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch recent orders';
    return { success: false, error: errorMessage };
  }
}

export async function getPendingOrders() {
  try {
    const orderService = getOrderService();
    const orders = await orderService.getPendingOrders();
    return { success: true, data: orders };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch pending orders';
    return { success: false, error: errorMessage };
  }
}

export async function syncOrders() {
  try {
    const orderService = getOrderService();
    const orders = await orderService.getOrders({ per_page: 100 });
    revalidatePath('/dashboard/orders');
    return { success: true, data: orders, count: orders.length };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to sync orders';
    return { success: false, error: errorMessage };
  }
}
