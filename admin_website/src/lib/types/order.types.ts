import type { BillingAddress, ShippingAddress } from './address.types';

export type OrderStatus =
  | 'pending'
  | 'processing'
  | 'on-hold'
  | 'completed'
  | 'cancelled'
  | 'refunded'
  | 'failed'
  | 'trash';

export interface Order {
  id: number;
  parent_id: number;
  number: string;
  order_key: string;
  created_via: string;
  version: string;
  status: OrderStatus;
  currency: string;
  currency_symbol: string;
  date_created: string;
  date_modified: string;
  discount_total: string;
  discount_tax: string;
  shipping_total: string;
  shipping_tax: string;
  cart_tax: string;
  total: string;
  total_tax: string;
  prices_include_tax: boolean;
  customer_id: number;
  customer_ip_address: string;
  customer_user_agent: string;
  customer_note: string;
  billing: BillingAddress;
  shipping: ShippingAddress;
  payment_method: string;
  payment_method_title: string;
  transaction_id: string;
  date_paid: string | null;
  date_completed: string | null;
  cart_hash: string;
  meta_data: Array<{
    id: number;
    key: string;
    value: string;
  }>;
  line_items: LineItem[];
  tax_lines: TaxLine[];
  shipping_lines: ShippingLine[];
  fee_lines: FeeLine[];
  coupon_lines: CouponLine[];
  refunds: Refund[];
}

export interface LineItem {
  id: number;
  name: string;
  product_id: number;
  variation_id: number;
  quantity: number;
  tax_class: string;
  subtotal: string;
  subtotal_tax: string;
  total: string;
  total_tax: string;
  taxes: Array<{
    id: number;
    total: string;
    subtotal: string;
  }>;
  meta_data: Array<{
    id: number;
    key: string;
    value: string;
    display_key: string;
    display_value: string;
  }>;
  sku: string;
  price: number;
  image: {
    id: number;
    src: string;
  };
}

export interface TaxLine {
  id: number;
  rate_code: string;
  rate_id: number;
  label: string;
  compound: boolean;
  tax_total: string;
  shipping_tax_total: string;
}

export interface ShippingLine {
  id: number;
  method_title: string;
  method_id: string;
  instance_id: string;
  total: string;
  total_tax: string;
  taxes: Array<{
    id: number;
    total: string;
  }>;
}

export interface FeeLine {
  id: number;
  name: string;
  tax_class: string;
  tax_status: string;
  amount: string;
  total: string;
  total_tax: string;
  taxes: Array<{
    id: number;
    total: string;
    subtotal: string;
  }>;
}

export interface CouponLine {
  id: number;
  code: string;
  discount: string;
  discount_tax: string;
}

export interface Refund {
  id: number;
  reason: string;
  total: string;
}

export interface OrdersQuery {
  page?: number;
  per_page?: number;
  search?: string;
  status?: OrderStatus | OrderStatus[];
  customer?: number;
  product?: number;
  dp?: number;
  after?: string;
  before?: string;
  orderby?: 'date' | 'id' | 'include' | 'title' | 'slug';
  order?: 'asc' | 'desc';
  include?: number[];
  exclude?: number[];
}

export interface OrderUpdateInput {
  status?: OrderStatus;
  customer_note?: string;
  billing?: Partial<BillingAddress>;
  shipping?: Partial<ShippingAddress>;
  meta_data?: Array<{
    key: string;
    value: string;
  }>;
}

export interface OrderNote {
  id: number;
  author: string;
  date_created: string;
  note: string;
  customer_note: boolean;
}

export interface OrderNoteInput {
  note: string;
  customer_note?: boolean;
}
