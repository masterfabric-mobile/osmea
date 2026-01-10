'use client';

import { useState } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { Button } from '@/components/ui/button';
import { cn } from '@/lib/utils';
import {
  LayoutDashboard,
  Package,
  ShoppingCart,
  Settings,
  Smartphone,
  Wrench,
  BarChart3,
  ChevronLeft,
  ChevronRight,
  LogOut,
  Store,
  User,
  Code,
  Users,
} from 'lucide-react';
import { useAuth } from '@/lib/hooks/use-auth';

interface NavItem {
  title: string;
  href: string;
  icon: typeof LayoutDashboard;
  badge?: string | number;
}

const mainNavItems: NavItem[] = [
  {
    title: 'Dashboard',
    href: '/dashboard',
    icon: LayoutDashboard,
  },
  {
    title: 'Products',
    href: '/dashboard/products',
    icon: Package,
  },
  {
    title: 'Orders',
    href: '/dashboard/orders',
    icon: ShoppingCart,
  },
  {
    title: 'Customers',
    href: '/dashboard/customers',
    icon: Users,
  },
  {
    title: 'App Config',
    href: '/dashboard/app-config',
    icon: Smartphone,
  },
  {
    title: 'Builds',
    href: '/dashboard/builds',
    icon: Wrench,
  },
  {
    title: 'Analytics',
    href: '/dashboard/analytics',
    icon: BarChart3,
  },
  {
    title: 'API Tester',
    href: '/dashboard/api-tester',
    icon: Code,
  },
];

const bottomNavItems: NavItem[] = [
  {
    title: 'Store Settings',
    href: '/dashboard/store-settings',
    icon: Store,
  },
  {
    title: 'Settings',
    href: '/dashboard/settings',
    icon: Settings,
  },
];

interface SidebarProps {
  className?: string;
}

export function Sidebar({ className }: SidebarProps) {
  const [collapsed, setCollapsed] = useState(false);
  const pathname = usePathname();
  const { user, signOut } = useAuth();

  const handleSignOut = async () => {
    await signOut();
    window.location.href = '/login';
  };

  return (
    <aside
      className={cn(
        'fixed left-0 top-0 z-40 h-screen bg-white dark:bg-gray-900 border-r border-gray-200 dark:border-gray-800 transition-all duration-300',
        collapsed ? 'w-16' : 'w-64',
        className
      )}
    >
      <div className="flex flex-col h-full">
        {/* Logo */}
        <div className={cn(
          'flex items-center h-16 border-b border-gray-200 dark:border-gray-800',
          collapsed ? 'justify-center px-2' : 'justify-between px-4'
        )}>
          {!collapsed && (
            <Link href="/dashboard" className="flex items-center gap-2">
              <div className="h-8 w-8 rounded-lg bg-primary flex items-center justify-center">
                <span className="text-primary-foreground font-bold">O</span>
              </div>
              <span className="font-bold text-lg">OSMEA</span>
            </Link>
          )}
          <Button
            variant="ghost"
            size="icon"
            onClick={() => setCollapsed(!collapsed)}
            className="h-8 w-8"
          >
            {collapsed ? (
              <ChevronRight className="h-4 w-4" />
            ) : (
              <ChevronLeft className="h-4 w-4" />
            )}
          </Button>
        </div>

        {/* Main Navigation */}
        <nav className="flex-1 overflow-y-auto py-4">
          <div className="px-2 space-y-1">
            {mainNavItems.map((item) => (
              <NavLink
                key={item.href}
                item={item}
                collapsed={collapsed}
                isActive={pathname === item.href}
              />
            ))}
          </div>
        </nav>

        {/* Bottom Navigation */}
        <div className="border-t border-gray-200 dark:border-gray-800 py-4">
          <div className="px-2 space-y-1">
            {bottomNavItems.map((item) => (
              <NavLink
                key={item.href}
                item={item}
                collapsed={collapsed}
                isActive={pathname === item.href}
              />
            ))}
          </div>
        </div>

        {/* User Section */}
        <div className="border-t border-gray-200 dark:border-gray-800 p-4">
          {collapsed ? (
            <Button
              variant="ghost"
              size="icon"
              onClick={handleSignOut}
              className="w-full h-10"
            >
              <LogOut className="h-4 w-4 text-red-600" />
            </Button>
          ) : (
            <div className="space-y-3">
              <div className="flex items-center gap-3">
                <div className="h-8 w-8 rounded-full bg-muted flex items-center justify-center">
                  <User className="h-4 w-4" />
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium truncate">
                    {user?.email || 'Admin User'}
                  </p>
                  <p className="text-xs text-muted-foreground truncate">
                    Super Admin
                  </p>
                </div>
              </div>
              <Button
                variant="ghost"
                size="sm"
                onClick={handleSignOut}
                className="w-full justify-start text-red-600 hover:text-red-700 hover:bg-red-50 dark:hover:bg-red-900/20"
              >
                <LogOut className="mr-2 h-4 w-4" />
                Sign out
              </Button>
            </div>
          )}
        </div>
      </div>
    </aside>
  );
}

interface NavLinkProps {
  item: NavItem;
  collapsed: boolean;
  isActive: boolean;
}

function NavLink({ item, collapsed, isActive }: NavLinkProps) {
  const Icon = item.icon;

  return (
    <Link
      href={item.href}
      className={cn(
        'flex items-center gap-3 rounded-lg px-3 py-2 transition-colors',
        isActive
          ? 'bg-primary text-primary-foreground'
          : 'text-muted-foreground hover:bg-muted hover:text-foreground',
        collapsed && 'justify-center px-2'
      )}
      title={collapsed ? item.title : undefined}
    >
      <Icon className="h-5 w-5 flex-shrink-0" />
      {!collapsed && (
        <>
          <span className="flex-1">{item.title}</span>
          {item.badge && (
            <span className="ml-auto text-xs bg-primary/10 text-primary px-2 py-0.5 rounded-full">
              {item.badge}
            </span>
          )}
        </>
      )}
    </Link>
  );
}

// Export collapsed state hook for responsive handling
export function useSidebarState() {
  const [collapsed, setCollapsed] = useState(false);
  return { collapsed, setCollapsed };
}
