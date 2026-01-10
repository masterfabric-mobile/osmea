import { APIError } from '@/lib/types/api.types';
import { toast } from 'sonner';

interface ErrorResult {
  message: string;
  statusCode: number;
  code?: string;
}

/**
 * Handle API errors consistently across the application
 */
export function handleAPIError(error: unknown): ErrorResult {
  console.error('API Error:', error);

  if (error instanceof APIError) {
    toast.error(error.message);
    return {
      message: error.message,
      statusCode: error.statusCode,
      code: error.code,
    };
  }

  if (error instanceof Error) {
    // Check for specific error types
    if (error.message.includes('fetch')) {
      toast.error('Network error. Please check your connection.');
      return {
        message: 'Network error',
        statusCode: 0,
        code: 'NETWORK_ERROR',
      };
    }

    toast.error(error.message);
    return {
      message: error.message,
      statusCode: 500,
    };
  }

  // Unknown error type
  toast.error('An unexpected error occurred');
  return {
    message: 'An unexpected error occurred',
    statusCode: 500,
  };
}

/**
 * Create a user-friendly error message
 */
export function getErrorMessage(error: unknown): string {
  if (error instanceof APIError) {
    return error.message;
  }

  if (error instanceof Error) {
    // Map common errors to user-friendly messages
    const errorMap: Record<string, string> = {
      'Failed to fetch': 'Unable to connect to the server. Please check your connection.',
      'Network request failed': 'Network error. Please try again.',
      'Unauthorized': 'Your session has expired. Please log in again.',
      'Forbidden': 'You don\'t have permission to perform this action.',
    };

    for (const [key, message] of Object.entries(errorMap)) {
      if (error.message.includes(key)) {
        return message;
      }
    }

    return error.message;
  }

  return 'An unexpected error occurred. Please try again.';
}

/**
 * Log error for debugging (in development) or monitoring (in production)
 */
export function logError(error: unknown, context?: Record<string, unknown>): void {
  const errorInfo = {
    timestamp: new Date().toISOString(),
    error: error instanceof Error ? {
      name: error.name,
      message: error.message,
      stack: error.stack,
    } : error,
    context,
  };

  if (process.env.NODE_ENV === 'development') {
    console.error('Error Log:', errorInfo);
  } else {
    // In production, send to error monitoring service (e.g., Sentry)
    // Sentry.captureException(error, { extra: context });
  }
}

/**
 * Wrap async functions with error handling
 */
export function withErrorHandling<T extends (...args: unknown[]) => Promise<unknown>>(
  fn: T,
  errorMessage?: string
): T {
  return (async (...args: Parameters<T>) => {
    try {
      return await fn(...args);
    } catch (error) {
      handleAPIError(error);
      throw error;
    }
  }) as T;
}

/**
 * Retry a function with exponential backoff
 */
export async function retryWithBackoff<T>(
  fn: () => Promise<T>,
  options: {
    maxRetries?: number;
    initialDelay?: number;
    maxDelay?: number;
    shouldRetry?: (error: unknown) => boolean;
  } = {}
): Promise<T> {
  const {
    maxRetries = 3,
    initialDelay = 1000,
    maxDelay = 10000,
    shouldRetry = () => true,
  } = options;

  let lastError: unknown;
  let delay = initialDelay;

  for (let attempt = 0; attempt < maxRetries; attempt++) {
    try {
      return await fn();
    } catch (error) {
      lastError = error;

      if (!shouldRetry(error) || attempt === maxRetries - 1) {
        throw error;
      }

      // Wait before retrying
      await new Promise((resolve) => setTimeout(resolve, delay));
      
      // Exponential backoff with jitter
      delay = Math.min(delay * 2 + Math.random() * 1000, maxDelay);
    }
  }

  throw lastError;
}
