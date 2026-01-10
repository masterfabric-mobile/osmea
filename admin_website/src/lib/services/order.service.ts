import { getWooCommerceClient, WooCommerceClient } from '@/lib/woocommerce/client';
import type {
  Order,
  OrdersQuery,
  OrderUpdateInput,
  OrderNote,
  OrderNoteInput,
  OrderStatus,
} from '@/lib/types/order.types';

export class OrderService {
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

  async getOrders(query: OrdersQuery = {}): Promise<Order[]> {
    const client = this.ensureClient();
    
    const params: Record<string, unknown> = {
      page: query.page || 1,
      per_page: query.per_page || 20,
      search: query.search,
      customer: query.customer,
      product: query.product,
      dp: query.dp,
      after: query.after,
      before: query.before,
      orderby: query.orderby || 'date',
      order: query.order || 'desc',
    };

    // Handle status - can be single or array
    if (query.status) {
      params.status = Array.isArray(query.status) ? query.status.join(',') : query.status;
    }

    if (query.include) {
      params.include = query.include.join(',');
    }

    if (query.exclude) {
      params.exclude = query.exclude.join(',');
    }

    return client.get<Order[]>('/orders', params);
  }

  async getOrder(id: number): Promise<Order> {
    const client = this.ensureClient();
    return client.get<Order>(`/orders/${id}`);
  }

  async updateOrder(id: number, data: OrderUpdateInput): Promise<Order> {
    const client = this.ensureClient();
    return client.put<Order>(`/orders/${id}`, data);
  }

  async deleteOrder(id: number, force: boolean = false): Promise<Order> {
    const client = this.ensureClient();
    return client.delete<Order>(`/orders/${id}`, { force });
  }

  async updateOrderStatus(id: number, status: OrderStatus): Promise<Order> {
    return this.updateOrder(id, { status });
  }

  // Order Notes
  async getOrderNotes(orderId: number): Promise<OrderNote[]> {
    const client = this.ensureClient();
    return client.get<OrderNote[]>(`/orders/${orderId}/notes`);
  }

  async getOrderNote(orderId: number, noteId: number): Promise<OrderNote> {
    const client = this.ensureClient();
    return client.get<OrderNote>(`/orders/${orderId}/notes/${noteId}`);
  }

  async createOrderNote(orderId: number, data: OrderNoteInput): Promise<OrderNote> {
    const client = this.ensureClient();
    return client.post<OrderNote>(`/orders/${orderId}/notes`, data);
  }

  async deleteOrderNote(orderId: number, noteId: number, force: boolean = true): Promise<OrderNote> {
    const client = this.ensureClient();
    return client.delete<OrderNote>(`/orders/${orderId}/notes/${noteId}`, { force });
  }

  // Order Refunds
  async getOrderRefunds(orderId: number): Promise<unknown[]> {
    const client = this.ensureClient();
    return client.get<unknown[]>(`/orders/${orderId}/refunds`);
  }

  async createOrderRefund(
    orderId: number,
    data: {
      amount?: string;
      reason?: string;
      refunded_by?: number;
      line_items?: Array<{
        id: number;
        quantity?: number;
        refund_total?: string;
      }>;
    }
  ): Promise<unknown> {
    const client = this.ensureClient();
    return client.post(`/orders/${orderId}/refunds`, data);
  }

  // Statistics helpers
  async getOrdersByStatus(status: OrderStatus): Promise<Order[]> {
    return this.getOrders({ status, per_page: 100 });
  }

  async getRecentOrders(limit: number = 10): Promise<Order[]> {
    return this.getOrders({ per_page: limit, orderby: 'date', order: 'desc' });
  }

  async getPendingOrders(): Promise<Order[]> {
    return this.getOrdersByStatus('pending');
  }

  async getProcessingOrders(): Promise<Order[]> {
    return this.getOrdersByStatus('processing');
  }
}

// Singleton instance
let orderService: OrderService | null = null;

export function getOrderService(): OrderService {
  if (!orderService) {
    orderService = new OrderService();
  }
  return orderService;
}

export function createOrderService(client: WooCommerceClient): OrderService {
  return new OrderService(client);
}
