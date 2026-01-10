'use client';

import { useState, useEffect } from 'react';
import { PageHeader, PageContainer } from '@/components/layout/page-header';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { EmptyState } from '@/components/ui/empty-state';
import { TableSkeleton } from '@/components/ui/skeleton-loader';
import { DataTable } from '@/components/ui/data-table';
import { StatusBadge } from '@/components/ui/status-badge';
import { toast } from 'sonner';
import { ShoppingCart, RefreshCw, Eye, AlertCircle } from 'lucide-react';
import type { ColumnDef } from '@tanstack/react-table';
import type { Order } from '@/lib/types/order.types';
import { formatDate } from '@/lib/utils';

const getOrderStatusType = (status: string): 'success' | 'error' | 'warning' | 'info' | 'pending' | 'building' | 'cancelled' => {
  switch (status) {
    case 'completed':
      return 'success';
    case 'processing':
      return 'building';
    case 'pending':
    case 'on-hold':
      return 'pending';
    case 'cancelled':
      return 'cancelled';
    case 'refunded':
    case 'failed':
      return 'error';
    default:
      return 'info';
  }
};

const columns: ColumnDef<Order>[] = [
  {
    accessorKey: 'number',
    header: 'Order',
    cell: ({ row }) => (
      <div>
        <div className="font-medium">#{row.original.number || row.original.id}</div>
        <div className="text-sm text-muted-foreground">
          {row.original.date_created ? formatDate(row.original.date_created) : '-'}
        </div>
      </div>
    ),
  },
  {
    accessorKey: 'billing',
    header: 'Customer',
    cell: ({ row }) => {
      const billing = row.original.billing;
      if (!billing) {
        return <div className="text-muted-foreground">-</div>;
      }
      const name = `${billing.first_name || ''} ${billing.last_name || ''}`.trim();
      return (
        <div>
          <div className="font-medium">{name || 'Guest'}</div>
          <div className="text-sm text-muted-foreground">{billing.email || '-'}</div>
        </div>
      );
    },
  },
  {
    accessorKey: 'total',
    header: 'Total',
    cell: ({ row }) => (
      <div className="font-medium">
        {row.original.currency_symbol || '$'}{row.original.total || '0.00'}
      </div>
    ),
  },
  {
    accessorKey: 'line_items',
    header: 'Items',
    cell: ({ row }) => (
      <div className="text-sm">
        {row.original.line_items?.length || 0} item(s)
      </div>
    ),
  },
  {
    accessorKey: 'status',
    header: 'Status',
    cell: ({ row }) => {
      const status = row.original.status || 'pending';
      return (
        <StatusBadge
          status={getOrderStatusType(status)}
          label={status.replace(/-/g, ' ')}
          size="sm"
        />
      );
    },
  },
  {
    id: 'actions',
    header: '',
    cell: () => (
      <Button variant="ghost" size="sm">
        <Eye className="h-4 w-4" />
      </Button>
    ),
  },
];

export default function OrdersPage() {
  const [loading, setLoading] = useState(false);
  const [syncing, setSyncing] = useState(false);
  const [orders, setOrders] = useState<Order[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [wooConfigured, setWooConfigured] = useState(false);

  // Check if WooCommerce is configured
  useEffect(() => {
    const wooUrl = localStorage.getItem('osmea-woo-url');
    const wooKey = localStorage.getItem('osmea-woo-key');
    const wooSecret = localStorage.getItem('osmea-woo-secret');
    setWooConfigured(!!(wooUrl && wooKey && wooSecret));
  }, []);

  const fetchOrders = async (): Promise<Order[]> => {
    const wooUrl = localStorage.getItem('osmea-woo-url');
    const wooKey = localStorage.getItem('osmea-woo-key');
    const wooSecret = localStorage.getItem('osmea-woo-secret');

    if (!wooUrl || !wooKey || !wooSecret) {
      throw new Error('WooCommerce credentials not found. Please configure in Store Settings.');
    }

    const response = await fetch('/api/woo/orders', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        storeUrl: wooUrl,
        consumerKey: wooKey,
        consumerSecret: wooSecret,
        per_page: 100,
      }),
    });

    const data = await response.json();

    if (!response.ok) {
      throw new Error(data.error || `Failed to fetch orders (${response.status})`);
    }

    // Ensure orders have required fields with defaults
    const orders = (data.orders || []).map((order: Record<string, unknown>) => ({
      ...order,
      id: order.id || 0,
      number: order.number || String(order.id),
      status: order.status || 'pending',
      total: order.total || '0.00',
      currency_symbol: order.currency_symbol || '$',
      date_created: order.date_created || new Date().toISOString(),
      billing: order.billing || { first_name: '', last_name: '', email: '' },
      line_items: order.line_items || [],
    }));

    return orders;
  };

  const handleSync = async () => {
    setSyncing(true);
    setError(null);
    
    try {
      const fetchedOrders = await fetchOrders();
      setOrders(fetchedOrders);
      
      if (fetchedOrders.length > 0) {
        toast.success(`Synced ${fetchedOrders.length} orders!`);
      } else {
        toast.info('No orders found in your store');
      }
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Failed to sync orders';
      setError(message);
      toast.error('Sync failed', { description: message });
    } finally {
      setSyncing(false);
    }
  };

  const handleRefresh = async () => {
    if (orders.length === 0) {
      await handleSync();
    } else {
      setLoading(true);
      try {
        const fetchedOrders = await fetchOrders();
        setOrders(fetchedOrders);
        toast.success('Orders refreshed!');
      } catch (err) {
        const message = err instanceof Error ? err.message : 'Failed to refresh';
        toast.error(message);
      } finally {
        setLoading(false);
      }
    }
  };

  return (
    <PageContainer>
      <PageHeader
        title="Orders"
        description="View and manage your WooCommerce orders"
        onRefresh={handleRefresh}
        refreshing={loading}
        actions={
          <Button variant="outline" onClick={handleSync} disabled={syncing}>
            {syncing ? (
              <>
                <RefreshCw className="mr-2 h-4 w-4 animate-spin" />
                Syncing...
              </>
            ) : (
              <>
                <RefreshCw className="mr-2 h-4 w-4" />
                Sync Orders
              </>
            )}
          </Button>
        }
      />

      {/* Error Banner */}
      {error && (
        <div className="mt-6 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg p-4">
          <div className="flex gap-3">
            <AlertCircle className="h-5 w-5 text-red-600 flex-shrink-0 mt-0.5" />
            <div>
              <p className="font-medium text-red-800 dark:text-red-200">Sync Error</p>
              <p className="text-sm text-red-700 dark:text-red-300 mt-1">{error}</p>
              {!wooConfigured && (
                <Button 
                  variant="outline" 
                  size="sm" 
                  className="mt-2"
                  onClick={() => window.location.href = '/dashboard/store-settings'}
                >
                  Configure WooCommerce
                </Button>
              )}
            </div>
          </div>
        </div>
      )}

      <Card className="mt-6">
        <CardContent className="pt-6">
          {!wooConfigured ? (
            <EmptyState
              icon={ShoppingCart}
              title="WooCommerce not configured"
              description="Please configure your WooCommerce store credentials to sync orders"
              action={{
                label: 'Configure Store',
                onClick: () => window.location.href = '/dashboard/store-settings',
              }}
            />
          ) : loading || syncing ? (
            <TableSkeleton rows={5} />
          ) : orders.length === 0 ? (
            <EmptyState
              icon={ShoppingCart}
              title="No orders found"
              description="Click 'Sync Orders' to fetch orders from your WooCommerce store"
              action={{
                label: 'Sync Orders',
                onClick: handleSync,
              }}
            />
          ) : (
            <DataTable
              columns={columns}
              data={orders}
              searchKey="number"
              searchPlaceholder="Search orders..."
            />
          )}
        </CardContent>
      </Card>
    </PageContainer>
  );
}
