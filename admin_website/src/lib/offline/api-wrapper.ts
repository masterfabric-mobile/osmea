import { offlineDb } from './db';
import { syncManager } from './sync-manager';

type HttpMethod = 'GET' | 'POST' | 'PUT' | 'DELETE' | 'PATCH';

interface OfflineApiOptions {
  method?: HttpMethod;
  body?: Record<string, unknown>;
  cache?: boolean;
  cacheKey?: string;
  offlineAction?: {
    entityType: 'project' | 'build' | 'config';
    action: 'create' | 'update' | 'delete';
  };
}

interface ApiResponse<T> {
  data: T | null;
  error: string | null;
  isOffline: boolean;
  fromCache: boolean;
}

/**
 * Offline-first API wrapper
 * - Tries network first
 * - Falls back to cache/IndexedDB when offline
 * - Queues write operations for background sync
 */
export async function offlineApi<T>(
  endpoint: string,
  options: OfflineApiOptions = {}
): Promise<ApiResponse<T>> {
  const {
    method = 'GET',
    body,
    cache = true,
    cacheKey,
    offlineAction,
  } = options;

  const isOnline = navigator.onLine;

  // For read operations, try network first, then cache
  if (method === 'GET') {
    if (isOnline) {
      try {
        const response = await fetch(endpoint, {
          method,
          headers: {
            'Content-Type': 'application/json',
          },
        });

        if (!response.ok) {
          throw new Error(`HTTP ${response.status}`);
        }

        const data = await response.json();

        // Cache the response
        if (cache && cacheKey) {
          await cacheResponse(cacheKey, data);
        }

        return {
          data: data as T,
          error: null,
          isOffline: false,
          fromCache: false,
        };
      } catch (error) {
        console.error('Network request failed:', error);
        // Fall through to cache
      }
    }

    // Try cache
    if (cache && cacheKey) {
      const cachedData = await getCachedResponse<T>(cacheKey);
      if (cachedData) {
        return {
          data: cachedData,
          error: null,
          isOffline: !isOnline,
          fromCache: true,
        };
      }
    }

    return {
      data: null,
      error: isOnline ? 'Request failed' : 'You are offline',
      isOffline: !isOnline,
      fromCache: false,
    };
  }

  // For write operations
  if (!isOnline && offlineAction) {
    // Queue for later sync
    await syncManager.queueAction(
      offlineAction.entityType,
      offlineAction.action,
      body || {}
    );

    return {
      data: body as T,
      error: null,
      isOffline: true,
      fromCache: false,
    };
  }

  // Try network
  try {
    const response = await fetch(endpoint, {
      method,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body ? JSON.stringify(body) : undefined,
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const data = await response.json();

    return {
      data: data as T,
      error: null,
      isOffline: false,
      fromCache: false,
    };
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : 'Request failed';
    
    // Queue for later if offline action is defined
    if (offlineAction && body) {
      await syncManager.queueAction(
        offlineAction.entityType,
        offlineAction.action,
        body
      );

      return {
        data: body as T,
        error: null,
        isOffline: true,
        fromCache: false,
      };
    }

    return {
      data: null,
      error: errorMessage,
      isOffline: !isOnline,
      fromCache: false,
    };
  }
}

// Simple in-memory cache for demo
// In production, use IndexedDB
const memoryCache = new Map<string, { data: unknown; timestamp: number }>();
const CACHE_TTL = 5 * 60 * 1000; // 5 minutes

async function cacheResponse(key: string, data: unknown): Promise<void> {
  memoryCache.set(key, {
    data,
    timestamp: Date.now(),
  });
}

async function getCachedResponse<T>(key: string): Promise<T | null> {
  const cached = memoryCache.get(key);
  
  if (!cached) {
    return null;
  }

  // Check if expired
  if (Date.now() - cached.timestamp > CACHE_TTL) {
    memoryCache.delete(key);
    return null;
  }

  return cached.data as T;
}

// Clear cache
export function clearApiCache(): void {
  memoryCache.clear();
}

// Prefetch and cache common data
export async function prefetchData(): Promise<void> {
  const endpoints = [
    { endpoint: '/api/woo/products?per_page=50', cacheKey: 'products' },
    { endpoint: '/api/woo/categories', cacheKey: 'categories' },
    { endpoint: '/api/woo/orders?per_page=20', cacheKey: 'orders' },
  ];

  await Promise.allSettled(
    endpoints.map(({ endpoint, cacheKey }) =>
      offlineApi(endpoint, { cache: true, cacheKey })
    )
  );
}
