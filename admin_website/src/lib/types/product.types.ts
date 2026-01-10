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
  purchasable: boolean;
  total_sales: number;
  virtual: boolean;
  downloadable: boolean;
  stock_status: 'instock' | 'outofstock' | 'onbackorder';
  stock_quantity: number | null;
  manage_stock: boolean;
  backorders: 'no' | 'notify' | 'yes';
  backorders_allowed: boolean;
  sold_individually: boolean;
  weight: string;
  dimensions: {
    length: string;
    width: string;
    height: string;
  };
  shipping_required: boolean;
  shipping_taxable: boolean;
  shipping_class: string;
  shipping_class_id: number;
  reviews_allowed: boolean;
  average_rating: string;
  rating_count: number;
  related_ids: number[];
  upsell_ids: number[];
  cross_sell_ids: number[];
  parent_id: number;
  purchase_note: string;
  categories: Array<{
    id: number;
    name: string;
    slug: string;
  }>;
  tags: Array<{
    id: number;
    name: string;
    slug: string;
  }>;
  images: Array<{
    id: number;
    src: string;
    name: string;
    alt: string;
  }>;
  attributes: Array<{
    id: number;
    name: string;
    position: number;
    visible: boolean;
    variation: boolean;
    options: string[];
  }>;
  default_attributes: Array<{
    id: number;
    name: string;
    option: string;
  }>;
  variations: number[];
  grouped_products: number[];
  menu_order: number;
  meta_data: Array<{
    id: number;
    key: string;
    value: string;
  }>;
  date_created: string;
  date_modified: string;
}

export interface ProductsQuery {
  page?: number;
  per_page?: number;
  search?: string;
  category?: number;
  tag?: number;
  status?: string;
  featured?: boolean;
  on_sale?: boolean;
  min_price?: number;
  max_price?: number;
  stock_status?: string;
  orderby?: 'date' | 'id' | 'title' | 'price' | 'popularity' | 'rating';
  order?: 'asc' | 'desc';
  sku?: string;
  include?: number[];
  exclude?: number[];
}

export interface ProductCreateInput {
  name: string;
  type?: Product['type'];
  status?: Product['status'];
  featured?: boolean;
  description?: string;
  short_description?: string;
  sku?: string;
  regular_price?: string;
  sale_price?: string;
  virtual?: boolean;
  downloadable?: boolean;
  manage_stock?: boolean;
  stock_quantity?: number;
  stock_status?: Product['stock_status'];
  categories?: Array<{ id: number }>;
  tags?: Array<{ id: number }>;
  images?: Array<{ src: string; name?: string; alt?: string }>;
  attributes?: Array<{
    name: string;
    visible?: boolean;
    variation?: boolean;
    options: string[];
  }>;
}

export interface ProductUpdateInput extends Partial<ProductCreateInput> {
  id?: number;
}

export interface ProductBatchInput {
  create?: ProductCreateInput[];
  update?: ProductUpdateInput[];
  delete?: number[];
}

export interface ProductBatchResult {
  create: Product[];
  update: Product[];
  delete: Product[];
}
