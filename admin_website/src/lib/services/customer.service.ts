import { getWooCommerceClient, WooCommerceClient } from '@/lib/woocommerce/client';
import type {
  Customer,
  CustomersQuery,
  CustomerUpdateInput,
} from '@/lib/types/customer.types';

export class CustomerService {
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

  async getCustomers(query: CustomersQuery = {}): Promise<Customer[]> {
    const client = this.ensureClient();
    
    const params: Record<string, unknown> = {
      page: query.page || 1,
      per_page: query.per_page || 20,
      search: query.search,
      email: query.email,
      role: query.role,
      orderby: query.orderby || 'registered_date',
      order: query.order || 'desc',
    };

    if (query.include) {
      params.include = query.include.join(',');
    }

    if (query.exclude) {
      params.exclude = query.exclude.join(',');
    }

    return client.get<Customer[]>('/customers', params);
  }

  async getCustomer(id: number): Promise<Customer> {
    const client = this.ensureClient();
    return client.get<Customer>(`/customers/${id}`);
  }

  async updateCustomer(id: number, data: CustomerUpdateInput): Promise<Customer> {
    const client = this.ensureClient();
    return client.put<Customer>(`/customers/${id}`, data);
  }

  async deleteCustomer(id: number, force: boolean = false, reassign?: number): Promise<Customer> {
    const client = this.ensureClient();
    const params: Record<string, unknown> = { force };
    if (reassign) {
      params.reassign = reassign;
    }
    return client.delete<Customer>(`/customers/${id}`, params);
  }

  async createCustomer(data: CustomerUpdateInput & { email: string }): Promise<Customer> {
    const client = this.ensureClient();
    return client.post<Customer>('/customers', data);
  }

  // Helper methods
  async getCustomersByRole(role: string): Promise<Customer[]> {
    return this.getCustomers({ role, per_page: 100 });
  }

  async searchCustomers(searchTerm: string): Promise<Customer[]> {
    return this.getCustomers({ search: searchTerm, per_page: 100 });
  }
}

// Singleton instance
let customerService: CustomerService | null = null;

export function getCustomerService(): CustomerService {
  if (!customerService) {
    customerService = new CustomerService();
  }
  return customerService;
}

export function createCustomerService(client: WooCommerceClient): CustomerService {
  return new CustomerService(client);
}
