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

    // Ensure storeUrl doesn't have trailing slash
    const baseUrl = config.storeUrl.replace(/\/$/, '');

    this.client = axios.create({
      baseURL: `${baseUrl}/wp-json/${this.config.version}`,
      timeout: this.config.timeout,
      auth: {
        username: config.consumerKey,
        password: config.consumerSecret,
      },
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
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

  private handleError(error: AxiosError): never {
    if (error.response) {
      const status = error.response.status;
      const data = error.response.data as Record<string, unknown>;

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
          throw new Error((data?.message as string) || 'WooCommerce API error');
      }
    } else if (error.request) {
      throw new Error('No response from WooCommerce. Check your store URL.');
    } else {
      throw new Error(`Request failed: ${error.message}`);
    }
  }

  async get<T>(endpoint: string, params?: Record<string, unknown>): Promise<T> {
    const response = await this.client.get(endpoint, { params });
    return response.data;
  }

  async post<T>(endpoint: string, data: unknown): Promise<T> {
    const response = await this.client.post(endpoint, data);
    return response.data;
  }

  async put<T>(endpoint: string, data: unknown): Promise<T> {
    const response = await this.client.put(endpoint, data);
    return response.data;
  }

  async delete<T>(endpoint: string, params?: Record<string, unknown>): Promise<T> {
    const response = await this.client.delete(endpoint, { params });
    return response.data;
  }

  async testConnection(): Promise<boolean> {
    try {
      await this.get('/system_status');
      return true;
    } catch {
      return false;
    }
  }
}

// Singleton instance management
let wooCommerceClient: WooCommerceClient | null = null;

export function initWooCommerceClient(config: WooCommerceConfig): WooCommerceClient {
  wooCommerceClient = new WooCommerceClient(config);
  return wooCommerceClient;
}

export function getWooCommerceClient(): WooCommerceClient | null {
  return wooCommerceClient;
}

export function createWooCommerceClient(config: WooCommerceConfig): WooCommerceClient {
  return new WooCommerceClient(config);
}

// Test connection utility
export async function testWooCommerceConnection(config: WooCommerceConfig): Promise<{
  success: boolean;
  message: string;
  data?: unknown;
}> {
  try {
    const client = new WooCommerceClient(config);
    const data = await client.get('/system_status');
    return {
      success: true,
      message: 'WooCommerce connection successful',
      data,
    };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to connect to WooCommerce';
    return {
      success: false,
      message: errorMessage,
    };
  }
}
