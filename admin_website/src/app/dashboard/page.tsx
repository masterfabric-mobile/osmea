'use client';

import { useState, useEffect, useCallback } from 'react';
import { PageHeader, PageContainer, PageSection } from '@/components/layout/page-header';
import { StatCard, StatCardSkeleton } from '@/components/dashboard/stat-card';
import { RecentBuilds } from '@/components/dashboard/recent-builds';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { EmptyState } from '@/components/ui/empty-state';
import { toast } from 'sonner';
import { 
  Package, 
  ShoppingCart, 
  Wrench, 
  Activity,
  Smartphone,
  ArrowRight,
  BookOpen,
  Settings,
  RefreshCw,
} from 'lucide-react';
import { useRouter } from 'next/navigation';

export default function DashboardPage() {
  const [loading, setLoading] = useState(true);
  const [syncing, setSyncing] = useState(false);
  const [wooConfigured, setWooConfigured] = useState(false);
  const [stats, setStats] = useState({
    products: 0,
    orders: 0,
    builds: 0,
    status: 'online' as 'online' | 'offline',
  });
  const router = useRouter();

  // Check if WooCommerce is configured
  useEffect(() => {
    const wooUrl = localStorage.getItem('osmea-woo-url');
    const wooKey = localStorage.getItem('osmea-woo-key');
    const wooSecret = localStorage.getItem('osmea-woo-secret');
    setWooConfigured(!!(wooUrl && wooKey && wooSecret));
  }, []);

  // Fetch stats from WooCommerce
  const fetchStats = useCallback(async () => {
    const wooUrl = localStorage.getItem('osmea-woo-url');
    const wooKey = localStorage.getItem('osmea-woo-key');
    const wooSecret = localStorage.getItem('osmea-woo-secret');

    if (!wooUrl || !wooKey || !wooSecret) {
      setLoading(false);
      return;
    }

    try {
      // Fetch products count
      const productsRes = await fetch('/api/woo/products', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          storeUrl: wooUrl,
          consumerKey: wooKey,
          consumerSecret: wooSecret,
          per_page: 1, // Just need the count from headers
        }),
      });

      // Fetch orders count
      const ordersRes = await fetch('/api/woo/orders', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          storeUrl: wooUrl,
          consumerKey: wooKey,
          consumerSecret: wooSecret,
          per_page: 1, // Just need the count from headers
        }),
      });

      const productsData = await productsRes.json();
      const ordersData = await ordersRes.json();

      setStats({
        products: productsData.pagination?.total || 0,
        orders: ordersData.pagination?.total || 0,
        builds: 0, // Would come from Supabase
        status: productsRes.ok && ordersRes.ok ? 'online' : 'offline',
      });
    } catch (error) {
      console.error('Error fetching stats:', error);
      setStats(prev => ({ ...prev, status: 'offline' }));
    } finally {
      setLoading(false);
    }
  }, []);

  // Initial fetch
  useEffect(() => {
    fetchStats();
  }, [fetchStats]);

  // Sync all data
  const handleSync = async () => {
    setSyncing(true);
    try {
      await fetchStats();
      toast.success('Dashboard stats refreshed!');
    } catch (error) {
      toast.error('Failed to refresh stats');
    } finally {
      setSyncing(false);
    }
  };

  const builds: never[] = [];

  return (
    <PageContainer>
      <PageHeader
        title="Dashboard"
        description="Welcome to your OSMEA Admin Panel"
        actions={
          wooConfigured && (
            <Button 
              variant="outline" 
              onClick={handleSync} 
              disabled={syncing || loading}
            >
              {syncing ? (
                <>
                  <RefreshCw className="mr-2 h-4 w-4 animate-spin" />
                  Syncing...
                </>
              ) : (
                <>
                  <RefreshCw className="mr-2 h-4 w-4" />
                  Refresh Stats
                </>
              )}
            </Button>
          )
        }
      />

      {/* WooCommerce not configured warning */}
      {!wooConfigured && !loading && (
        <div className="mt-6 bg-amber-50 dark:bg-amber-900/20 border border-amber-200 dark:border-amber-800 rounded-lg p-4">
          <div className="flex gap-3 items-start">
            <Settings className="h-5 w-5 text-amber-600 flex-shrink-0 mt-0.5" />
            <div>
              <p className="font-medium text-amber-800 dark:text-amber-200">
                WooCommerce not configured
              </p>
              <p className="text-sm text-amber-700 dark:text-amber-300 mt-1">
                Connect your WooCommerce store to see real-time stats.
              </p>
              <Button 
                variant="outline" 
                size="sm" 
                className="mt-2"
                onClick={() => router.push('/dashboard/store-settings')}
              >
                Configure Store
              </Button>
            </div>
          </div>
        </div>
      )}

      <PageSection className="mt-6">
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
          {loading ? (
            <>
              <StatCardSkeleton />
              <StatCardSkeleton />
              <StatCardSkeleton />
              <StatCardSkeleton />
            </>
          ) : (
            <>
              <StatCard
                title="Total Products"
                value={stats.products}
                description={wooConfigured ? "Synced from WooCommerce" : "Configure store to sync"}
                icon={Package}
                onClick={() => router.push('/dashboard/products')}
              />
              <StatCard
                title="Total Orders"
                value={stats.orders}
                description={wooConfigured ? "All time orders" : "Configure store to sync"}
                icon={ShoppingCart}
                onClick={() => router.push('/dashboard/orders')}
              />
              <StatCard
                title="App Builds"
                value={stats.builds}
                description="Completed builds"
                icon={Wrench}
                onClick={() => router.push('/dashboard/builds')}
              />
              <StatCard
                title="Store Status"
                value={wooConfigured ? (stats.status === 'online' ? 'Connected' : 'Offline') : 'Not Set'}
                description={wooConfigured ? (stats.status === 'online' ? 'WooCommerce connected' : 'Connection issue') : 'Configure store first'}
                icon={Activity}
                iconClassName={wooConfigured && stats.status === 'online' ? 'text-green-500' : 'text-amber-500'}
              />
            </>
          )}
        </div>
      </PageSection>

      <div className="grid gap-6 md:grid-cols-2 mt-6">
        <Card>
          <CardHeader>
            <CardTitle>Quick Actions</CardTitle>
            <CardDescription>Common tasks and shortcuts</CardDescription>
          </CardHeader>
          <CardContent className="grid gap-3">
            <Button 
              variant="outline" 
              className="justify-start h-auto py-3"
              onClick={() => router.push('/dashboard/app-config')}
            >
              <Smartphone className="mr-3 h-5 w-5 text-primary" />
              <div className="text-left">
                <div className="font-medium">Configure App</div>
                <div className="text-xs text-muted-foreground">Customize your mobile app</div>
              </div>
              <ArrowRight className="ml-auto h-4 w-4" />
            </Button>
            <Button 
              variant="outline" 
              className="justify-start h-auto py-3"
              onClick={() => router.push('/dashboard/products')}
            >
              <Package className="mr-3 h-5 w-5 text-primary" />
              <div className="text-left">
                <div className="font-medium">Manage Products</div>
                <div className="text-xs text-muted-foreground">View and sync products</div>
              </div>
              <ArrowRight className="ml-auto h-4 w-4" />
            </Button>
            <Button 
              variant="outline" 
              className="justify-start h-auto py-3"
              onClick={() => router.push('/dashboard/builds')}
            >
              <Wrench className="mr-3 h-5 w-5 text-primary" />
              <div className="text-left">
                <div className="font-medium">Build App</div>
                <div className="text-xs text-muted-foreground">Generate iOS or Android build</div>
              </div>
              <ArrowRight className="ml-auto h-4 w-4" />
            </Button>
            <Button 
              variant="outline" 
              className="justify-start h-auto py-3"
              onClick={() => router.push('/dashboard/store-settings')}
            >
              <Settings className="mr-3 h-5 w-5 text-primary" />
              <div className="text-left">
                <div className="font-medium">Store Settings</div>
                <div className="text-xs text-muted-foreground">Configure WooCommerce connection</div>
              </div>
              <ArrowRight className="ml-auto h-4 w-4" />
            </Button>
          </CardContent>
        </Card>

        <RecentBuilds
          builds={builds}
          loading={loading}
          onViewAll={() => router.push('/dashboard/builds')}
          onTriggerBuild={() => router.push('/dashboard/builds')}
        />
      </div>

      <PageSection title="Getting Started" className="mt-6">
        <Card>
          <CardContent className="pt-6">
            <EmptyState
              icon={BookOpen}
              title="Welcome to OSMEA Admin Panel"
              description="Follow these steps to set up your mobile app. Connect your WooCommerce store, customize your app settings, and build your first release."
              action={{
                label: 'View Documentation',
                onClick: () => window.open('/docs', '_blank'),
              }}
              secondaryAction={{
                label: 'Configure Store',
                onClick: () => router.push('/dashboard/store-settings'),
                variant: 'outline',
              }}
            />
          </CardContent>
        </Card>
      </PageSection>
    </PageContainer>
  );
}
