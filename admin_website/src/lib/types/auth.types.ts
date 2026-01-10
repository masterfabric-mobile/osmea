export type UserRole = 'super_admin' | 'store_manager' | 'content_editor' | 'viewer';

export interface RolePermissions {
  // Configuration
  'config:read': boolean;
  'config:write': boolean;
  'config:publish': boolean;
  'config:delete': boolean;

  // Products
  'products:read': boolean;
  'products:write': boolean;
  'products:delete': boolean;

  // Orders
  'orders:read': boolean;
  'orders:update': boolean;
  'orders:cancel': boolean;

  // Builds
  'builds:read': boolean;
  'builds:trigger': boolean;
  'builds:cancel': boolean;
  'builds:download': boolean;

  // Users
  'users:read': boolean;
  'users:write': boolean;
  'users:delete': boolean;

  // Settings
  'settings:read': boolean;
  'settings:write': boolean;

  // Analytics
  'analytics:read': boolean;
}

export const ROLE_PERMISSIONS: Record<UserRole, Partial<RolePermissions>> = {
  super_admin: {
    'config:read': true,
    'config:write': true,
    'config:publish': true,
    'config:delete': true,
    'products:read': true,
    'products:write': true,
    'products:delete': true,
    'orders:read': true,
    'orders:update': true,
    'orders:cancel': true,
    'builds:read': true,
    'builds:trigger': true,
    'builds:cancel': true,
    'builds:download': true,
    'users:read': true,
    'users:write': true,
    'users:delete': true,
    'settings:read': true,
    'settings:write': true,
    'analytics:read': true,
  },
  store_manager: {
    'config:read': true,
    'config:write': true,
    'config:publish': true,
    'products:read': true,
    'products:write': true,
    'products:delete': true,
    'orders:read': true,
    'orders:update': true,
    'builds:read': true,
    'builds:trigger': true,
    'builds:download': true,
    'users:read': true,
    'settings:read': true,
    'settings:write': true,
    'analytics:read': true,
  },
  content_editor: {
    'config:read': true,
    'config:write': true,
    'products:read': true,
    'products:write': true,
    'orders:read': true,
    'builds:read': true,
    'analytics:read': true,
  },
  viewer: {
    'config:read': true,
    'products:read': true,
    'orders:read': true,
    'builds:read': true,
    'analytics:read': true,
  },
};

export interface AdminUser {
  id: string;
  authUserId: string;
  storeId: string;
  displayName: string;
  avatarUrl: string;
  role: UserRole;
  permissions: Record<string, boolean>;
  isActive: boolean;
  createdAt?: string;
  updatedAt?: string;
  lastActivityAt?: string;
}

export interface AuthState {
  isAuthenticated: boolean;
  isLoading: boolean;
  user: AdminUser | null;
  error: string | null;
}

export interface SessionConfig {
  maxAge: number; // seconds
  refreshInterval: number; // seconds
  inactivityTimeout: number; // seconds
}

export const SESSION_CONFIG: SessionConfig = {
  maxAge: 7 * 24 * 60 * 60, // 7 days
  refreshInterval: 60 * 60, // 1 hour
  inactivityTimeout: 45 * 60, // 45 minutes
};

export interface PasswordRequirements {
  minLength: number;
  requireUppercase: boolean;
  requireLowercase: boolean;
  requireNumber: boolean;
  requireSpecial: boolean;
}

export const PASSWORD_REQUIREMENTS: PasswordRequirements = {
  minLength: 8,
  requireUppercase: true,
  requireLowercase: true,
  requireNumber: true,
  requireSpecial: true,
};

export function validatePassword(password: string): {
  isValid: boolean;
  errors: string[];
} {
  const errors: string[] = [];

  if (password.length < PASSWORD_REQUIREMENTS.minLength) {
    errors.push(`Password must be at least ${PASSWORD_REQUIREMENTS.minLength} characters`);
  }

  if (PASSWORD_REQUIREMENTS.requireUppercase && !/[A-Z]/.test(password)) {
    errors.push('Password must contain at least one uppercase letter');
  }

  if (PASSWORD_REQUIREMENTS.requireLowercase && !/[a-z]/.test(password)) {
    errors.push('Password must contain at least one lowercase letter');
  }

  if (PASSWORD_REQUIREMENTS.requireNumber && !/\d/.test(password)) {
    errors.push('Password must contain at least one number');
  }

  if (PASSWORD_REQUIREMENTS.requireSpecial && !/[!@#$%^&*(),.?":{}|<>]/.test(password)) {
    errors.push('Password must contain at least one special character');
  }

  return {
    isValid: errors.length === 0,
    errors,
  };
}
