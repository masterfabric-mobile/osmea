'use client';

import { ReactNode } from 'react';
import { usePermissions } from '@/lib/hooks/use-permissions';
import type { RolePermissions } from '@/lib/types/auth.types';

interface ProtectedProps {
  children: ReactNode;
  permission?: keyof RolePermissions;
  permissions?: Array<keyof RolePermissions>;
  requireAll?: boolean;
  fallback?: ReactNode;
}

/**
 * Protected component that renders children only if user has the required permission(s)
 * 
 * @example
 * // Single permission
 * <Protected permission="builds:trigger">
 *   <Button onClick={triggerBuild}>Trigger Build</Button>
 * </Protected>
 * 
 * @example
 * // Multiple permissions (any)
 * <Protected permissions={['products:write', 'products:delete']}>
 *   <ProductActions />
 * </Protected>
 * 
 * @example
 * // Multiple permissions (all required)
 * <Protected permissions={['config:write', 'config:publish']} requireAll>
 *   <PublishButton />
 * </Protected>
 */
export function Protected({
  children,
  permission,
  permissions,
  requireAll = false,
  fallback = null,
}: ProtectedProps) {
  const { hasPermission, hasAllPermissions, hasAnyPermission } = usePermissions();

  // Single permission check
  if (permission && !hasPermission(permission)) {
    return <>{fallback}</>;
  }

  // Multiple permissions check
  if (permissions) {
    const hasAccess = requireAll
      ? hasAllPermissions(permissions)
      : hasAnyPermission(permissions);

    if (!hasAccess) {
      return <>{fallback}</>;
    }
  }

  return <>{children}</>;
}

/**
 * Higher-order component for protecting entire components
 */
export function withProtection<P extends object>(
  WrappedComponent: React.ComponentType<P>,
  permission: keyof RolePermissions,
  FallbackComponent?: React.ComponentType
) {
  return function ProtectedComponent(props: P) {
    return (
      <Protected
        permission={permission}
        fallback={FallbackComponent ? <FallbackComponent /> : null}
      >
        <WrappedComponent {...props} />
      </Protected>
    );
  };
}
