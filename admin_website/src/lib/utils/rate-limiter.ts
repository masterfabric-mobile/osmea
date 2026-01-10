interface RateLimitConfig {
  maxRequests: number;
  windowMs: number;
}

interface RateLimitInfo {
  remaining: number;
  resetAt: Date;
  isLimited: boolean;
}

class RateLimiter {
  private requests: Map<string, number[]> = new Map();
  private config: RateLimitConfig;

  constructor(config: RateLimitConfig) {
    this.config = config;
  }

  /**
   * Check if a request is allowed
   */
  checkLimit(key: string): RateLimitInfo {
    const now = Date.now();
    const windowStart = now - this.config.windowMs;

    // Get existing requests for this key
    let timestamps = this.requests.get(key) || [];

    // Filter out old requests
    timestamps = timestamps.filter((ts) => ts > windowStart);

    // Calculate rate limit info
    const remaining = Math.max(0, this.config.maxRequests - timestamps.length);
    const resetAt = new Date(now + this.config.windowMs);
    const isLimited = timestamps.length >= this.config.maxRequests;

    return { remaining, resetAt, isLimited };
  }

  /**
   * Record a request
   */
  recordRequest(key: string): RateLimitInfo {
    const info = this.checkLimit(key);

    if (!info.isLimited) {
      const now = Date.now();
      const windowStart = now - this.config.windowMs;
      let timestamps = this.requests.get(key) || [];
      timestamps = timestamps.filter((ts) => ts > windowStart);
      timestamps.push(now);
      this.requests.set(key, timestamps);

      return {
        remaining: info.remaining - 1,
        resetAt: info.resetAt,
        isLimited: false,
      };
    }

    return info;
  }

  /**
   * Reset the rate limit for a key
   */
  reset(key: string): void {
    this.requests.delete(key);
  }

  /**
   * Clear all rate limits
   */
  clear(): void {
    this.requests.clear();
  }

  /**
   * Wait until rate limit resets (for client-side)
   */
  async waitForReset(key: string): Promise<void> {
    const info = this.checkLimit(key);
    if (info.isLimited) {
      const waitTime = info.resetAt.getTime() - Date.now();
      if (waitTime > 0) {
        await new Promise((resolve) => setTimeout(resolve, waitTime));
      }
    }
  }
}

// Pre-configured rate limiters
export const wooCommerceLimiter = new RateLimiter({
  maxRequests: 60,
  windowMs: 60 * 1000, // 60 requests per minute
});

export const supabaseLimiter = new RateLimiter({
  maxRequests: 100,
  windowMs: 60 * 1000, // 100 requests per minute
});

export const buildLimiter = new RateLimiter({
  maxRequests: 5,
  windowMs: 60 * 60 * 1000, // 5 builds per hour
});

// Rate limited fetch wrapper
export async function rateLimitedFetch(
  url: string,
  options: RequestInit = {},
  limiter: RateLimiter = wooCommerceLimiter
): Promise<Response> {
  const key = new URL(url).hostname;
  const info = limiter.recordRequest(key);

  if (info.isLimited) {
    throw new Error(`Rate limit exceeded. Try again at ${info.resetAt.toISOString()}`);
  }

  const response = await fetch(url, options);

  // Check for rate limit headers from the server
  const rateLimitRemaining = response.headers.get('X-RateLimit-Remaining');
  const rateLimitReset = response.headers.get('X-RateLimit-Reset');

  if (response.status === 429) {
    throw new Error('Server rate limit exceeded. Please try again later.');
  }

  return response;
}

// Throttle function for UI actions
export function throttle<T extends (...args: Parameters<T>) => ReturnType<T>>(
  func: T,
  limit: number
): (...args: Parameters<T>) => ReturnType<T> | undefined {
  let inThrottle = false;
  let lastResult: ReturnType<T>;

  return function (this: ThisParameterType<T>, ...args: Parameters<T>): ReturnType<T> | undefined {
    if (!inThrottle) {
      lastResult = func.apply(this, args);
      inThrottle = true;
      setTimeout(() => (inThrottle = false), limit);
      return lastResult;
    }
    return undefined;
  };
}

// Debounce function for search inputs
export function debounce<T extends (...args: Parameters<T>) => void>(
  func: T,
  wait: number
): (...args: Parameters<T>) => void {
  let timeout: NodeJS.Timeout | null = null;

  return function (this: ThisParameterType<T>, ...args: Parameters<T>): void {
    if (timeout) {
      clearTimeout(timeout);
    }
    timeout = setTimeout(() => {
      func.apply(this, args);
    }, wait);
  };
}

export { RateLimiter };
export type { RateLimitConfig, RateLimitInfo };
