interface WooCommerceCredentials {
  storeUrl: string;
  consumerKey: string;
  consumerSecret: string;
}

interface SalesReportTotalsItem {
  sales?: string;
  orders?: number;
  items?: number;
  tax?: string;
  shipping?: string;
  discount?: string;
  customers?: number;
}

interface SalesReport {
  total_sales: string;
  net_sales: string;
  average_sales: string;
  total_orders: number;
  total_items: number;
  total_tax: string;
  total_shipping: string;
  total_refunds: number;
  total_discount: string;
  totals_grouped_by: string;
  totals?: Record<string, SalesReportTotalsItem>; // Object with date keys
  currency: string;
  segments: Array<unknown>;
}

interface OrderTotalsReport {
  slug: string;
  name: string;
  total: number;
}

interface ProductTotalsReport {
  slug: string;
  name: string;
  total: number;
}

interface CustomerTotalsReport {
  slug: string;
  name: string;
  total: number;
}

export interface AnalyticsData {
  totalRevenue: number;
  totalOrders: number;
  productsSold: number;
  totalCustomers: number;
  netRevenue: number;
  averageOrderValue: number;
  currency: string;
  monthlyRevenue: Array<{
    period: string;
    revenue: number;
    orders: number;
  }>;
  dailyOrders: Array<{
    period: string;
    orders: number;
  }>;
}

export class AnalyticsService {
  private credentials: WooCommerceCredentials | null = null;

  setCredentials(credentials: WooCommerceCredentials) {
    this.credentials = credentials;
  }

  private ensureCredentials(): WooCommerceCredentials {
    if (!this.credentials) {
      // Try to get from localStorage if available (client-side)
      if (typeof window !== 'undefined') {
        const storeUrl = localStorage.getItem('osmea-woo-url');
        const consumerKey = localStorage.getItem('osmea-woo-key');
        const consumerSecret = localStorage.getItem('osmea-woo-secret');

        if (storeUrl && consumerKey && consumerSecret) {
          this.credentials = { storeUrl, consumerKey, consumerSecret };
        }
      }

      if (!this.credentials) {
        throw new Error('WooCommerce credentials are not set');
      }
    }
    return this.credentials;
  }

  async fetchSalesReport(dateMin?: string, dateMax?: string, period?: string): Promise<SalesReport> {
    const creds = this.ensureCredentials();
    
    const response = await fetch('/api/woo/reports', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        storeUrl: creds.storeUrl,
        consumerKey: creds.consumerKey,
        consumerSecret: creds.consumerSecret,
        reportType: 'sales',
        dateMin,
        dateMax,
        period,
      }),
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'Failed to fetch sales report');
    }

    const result = await response.json();
    // Sales report can be an array, take the first item if it's an array
    const data = Array.isArray(result.data) ? result.data[0] : result.data;
    return data as SalesReport;
  }

  async fetchOrderTotals(): Promise<OrderTotalsReport[]> {
    const creds = this.ensureCredentials();
    
    const response = await fetch('/api/woo/reports', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        storeUrl: creds.storeUrl,
        consumerKey: creds.consumerKey,
        consumerSecret: creds.consumerSecret,
        reportType: 'orders',
      }),
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'Failed to fetch order totals');
    }

    const result = await response.json();
    return result.data as OrderTotalsReport[];
  }

  async fetchProductTotals(): Promise<ProductTotalsReport[]> {
    const creds = this.ensureCredentials();
    
    const response = await fetch('/api/woo/reports', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        storeUrl: creds.storeUrl,
        consumerKey: creds.consumerKey,
        consumerSecret: creds.consumerSecret,
        reportType: 'products',
      }),
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'Failed to fetch product totals');
    }

    const result = await response.json();
    return (Array.isArray(result.data) ? result.data : [result.data]) as ProductTotalsReport[];
  }

  async fetchCustomerTotals(): Promise<CustomerTotalsReport[]> {
    const creds = this.ensureCredentials();
    
    const response = await fetch('/api/woo/reports', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        storeUrl: creds.storeUrl,
        consumerKey: creds.consumerKey,
        consumerSecret: creds.consumerSecret,
        reportType: 'customers',
      }),
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'Failed to fetch customer totals');
    }

    const result = await response.json();
    return (Array.isArray(result.data) ? result.data : [result.data]) as CustomerTotalsReport[];
  }

  async getAnalyticsData(): Promise<AnalyticsData> {
    try {
      // Fetch all reports in parallel
      const [salesReport, orderTotals, productTotals, customerTotals] = await Promise.all([
        this.fetchSalesReport(),
        this.fetchOrderTotals(),
        this.fetchProductTotals(),
        this.fetchCustomerTotals(),
      ]);

      // Calculate total orders from order totals (sum all statuses)
      const totalOrders = orderTotals.reduce((sum, item) => sum + (item.total || 0), 0);

      // Parse revenue values (they come as strings)
      const totalRevenue = parseFloat(salesReport.total_sales || '0');
      const netRevenue = parseFloat(salesReport.net_sales || '0');
      const averageOrderValue = totalOrders > 0 ? totalRevenue / totalOrders : 0;

      // Calculate products sold - use total_items from sales report (more reliable)
      // Fallback to product totals if sales report doesn't have it
      const productsSold = salesReport.total_items || productTotals.reduce((sum, item) => {
        // Look for items_sold entry in product totals
        if (item.slug === 'items_sold' || item.name?.toLowerCase().includes('items sold')) {
          return item.total || 0;
        }
        return sum;
      }, 0);

      // Calculate total customers from customer totals
      // Sum all customer totals (registered + guest)
      const totalCustomers = customerTotals.reduce((sum, item) => sum + (item.total || 0), 0);

      // Process monthly revenue data
      // totals is an object with date keys, convert to array
      const totalsArray = salesReport.totals 
        ? Object.entries(salesReport.totals).map(([period, data]) => ({
            period,
            ...data,
          }))
        : [];

      const monthlyRevenue = totalsArray
        .sort((a, b) => a.period.localeCompare(b.period)) // Sort by date
        .map((item) => ({
          period: item.period,
          revenue: parseFloat(item.sales || '0'),
          orders: item.orders || 0,
        }));

      // Process daily orders (use totals for now, can be enhanced with date filtering)
      const dailyOrders = totalsArray
        .sort((a, b) => a.period.localeCompare(b.period)) // Sort by date
        .map((item) => ({
          period: item.period,
          orders: item.orders || 0,
        }));

      return {
        totalRevenue,
        totalOrders,
        productsSold,
        totalCustomers,
        netRevenue,
        averageOrderValue,
        currency: salesReport.currency || 'USD',
        monthlyRevenue,
        dailyOrders,
      };
    } catch (error) {
      console.error('Error fetching analytics data:', error);
      throw error;
    }
  }
}

// Singleton instance
let analyticsService: AnalyticsService | null = null;

export function getAnalyticsService(): AnalyticsService {
  if (!analyticsService) {
    analyticsService = new AnalyticsService();
  }
  return analyticsService;
}

export function createAnalyticsService(credentials: WooCommerceCredentials): AnalyticsService {
  const service = new AnalyticsService();
  service.setCredentials(credentials);
  return service;
}
