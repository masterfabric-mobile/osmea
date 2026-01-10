import type { BillingAddress, ShippingAddress } from './address.types';

export interface Customer {
  id: number;
  date_created: string;
  date_created_gmt: string;
  date_modified: string;
  date_modified_gmt: string;
  email: string;
  first_name: string;
  last_name: string;
  role: string;
  username: string;
  billing: BillingAddress;
  shipping: ShippingAddress;
  is_paying_customer: boolean;
  avatar_url: string;
  meta_data: Array<{
    id: number;
    key: string;
    value: string;
  }>;
}

export interface CustomersQuery {
  page?: number;
  per_page?: number;
  search?: string;
  email?: string;
  role?: string;
  orderby?: 'id' | 'include' | 'name' | 'registered_date';
  order?: 'asc' | 'desc';
  include?: number[];
  exclude?: number[];
}

export interface CustomerUpdateInput {
  email?: string;
  first_name?: string;
  last_name?: string;
  username?: string;
  password?: string;
  billing?: Partial<BillingAddress>;
  shipping?: Partial<ShippingAddress>;
  meta_data?: Array<{
    key: string;
    value: string;
  }>;
}
