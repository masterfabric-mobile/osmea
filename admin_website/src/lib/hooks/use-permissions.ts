'use client';

import { useAuth } from '@/lib/context/auth-context';
import { ROLE_PERMISSIONS, type RolePermissions, type UserRole } from '@/lib/types/auth.types';

export function usePermissions() {
  const { adminUser } = useAuth();

  const hasPermission = (permission: keyof RolePermissions): boolean => {
    if (!adminUser) return false;

    // Super admin has all permissions
    if (adminUser.role === 'super_admin') return true;

    // Check role-based permissions
    const rolePermissions = ROLE_PERMISSIONS[adminUser.role];
    if (rolePermissions && rolePermissions[permission]) return true;

    // Check custom user permissions
    if (adminUser.permissions && adminUser.permissions[permission]) return true;

    return false;
  };

  const hasAnyPermission = (permissions: Array<keyof RolePermissions>): boolean => {
    return permissions.some((permission) => hasPermission(permission));
  };

  const hasAllPermissions = (permissions: Array<keyof RolePermissions>): boolean => {
    return permissions.every((permission) => hasPermission(permission));
  };

  const role: UserRole | undefined = adminUser?.role;

  return {
    hasPermission,
    hasAnyPermission,
    hasAllPermissions,
    role,
    isAdmin: adminUser?.role === 'super_admin',
    isManager: adminUser?.role === 'store_manager',
    isEditor: adminUser?.role === 'content_editor',
    isViewer: adminUser?.role === 'viewer',
  };
}
