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
import { Package, RefreshCw, ExternalLink, AlertCircle } from 'lucide-react';
import type { ColumnDef } from '@tanstack/react-table';
import type { Product } from '@/lib/types/product.types';

const columns: ColumnDef<Product>[] = [
  {
    accessorKey: 'images',
    header: 'Image',
    cell: ({ row }) => {
      const images = row.original.images;
      const firstImage = images?.[0];
      return (
        <div className="w-12 h-12 rounded-lg bg-muted overflow-hidden">
          {firstImage ? (
            <img
              src={firstImage.src}
              alt={firstImage.alt || row.original.name}
              className="w-full h-full object-cover"
            />
          ) : (
            <div className="w-full h-full flex items-center justify-center">
              <Package className="h-5 w-5 text-muted-foreground" />
            </div>
          )}
        </div>
      );
    },
  },
  {
    accessorKey: 'name',
    header: 'Product',
    cell: ({ row }) => (
      <div>
        <div className="font-medium">{row.original.name}</div>
        <div className="text-sm text-muted-foreground">SKU: {row.original.sku || 'N/A'}</div>
      </div>
    ),
  },
  {
    accessorKey: 'price',
    header: 'Price',
    cell: ({ row }) => (
      <div>
        {row.original.on_sale ? (
          <>
            <span className="line-through text-muted-foreground mr-2">
              ${row.original.regular_price}
            </span>
            <span className="font-medium text-green-600">${row.original.sale_price}</span>
          </>
        ) : (
          <span className="font-medium">${row.original.price}</span>
        )}
      </div>
    ),
  },
  {
    accessorKey: 'stock_status',
    header: 'Stock',
    cell: ({ row }) => {
      const status = row.original.stock_status;
      return (
        <StatusBadge
          status={status === 'instock' ? 'success' : status === 'outofstock' ? 'error' : 'warning'}
          label={status === 'instock' ? 'In Stock' : status === 'outofstock' ? 'Out of Stock' : 'On Backorder'}
          size="sm"
        />
      );
    },
  },
  {
    accessorKey: 'status',
    header: 'Status',
    cell: ({ row }) => (
      <StatusBadge
        status={row.original.status === 'publish' ? 'active' : 'inactive'}
        label={row.original.status}
        size="sm"
      />
    ),
  },
  {
    id: 'actions',
    header: '',
    cell: ({ row }) => (
      <Button variant="ghost" size="sm" asChild>
        <a href={row.original.permalink} target="_blank" rel="noopener noreferrer">
          <ExternalLink className="h-4 w-4" />
        </a>
      </Button>
    ),
  },
];

export default function ProductsPage() {
  const [loading, setLoading] = useState(false);
  const [syncing, setSyncing] = useState(false);
  const [products, setProducts] = useState<Product[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [wooConfigured, setWooConfigured] = useState(false);

  // Check if WooCommerce is configured
  useEffect(() => {
    const wooUrl = localStorage.getItem('osmea-woo-url');
    const wooKey = localStorage.getItem('osmea-woo-key');
    const wooSecret = localStorage.getItem('osmea-woo-secret');
    setWooConfigured(!!(wooUrl && wooKey && wooSecret));
  }, []);

  const fetchProducts = async () => {
    const wooUrl = localStorage.getItem('osmea-woo-url');
    const wooKey = localStorage.getItem('osmea-woo-key');
    const wooSecret = localStorage.getItem('osmea-woo-secret');

    if (!wooUrl || !wooKey || !wooSecret) {
      setError('WooCommerce credentials not found. Please configure in Store Settings.');
      return [];
    }

    try {
      // Call our API route to fetch products
      const response = await fetch('/api/woo/products', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          storeUrl: wooUrl,
          consumerKey: wooKey,
          consumerSecret: wooSecret,
          per_page: 100,
        }),
      });

      if (!response.ok) {
        const data = await response.json();
        throw new Error(data.error || 'Failed to fetch products');
      }

      const data = await response.json();
      return data.products || [];
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Failed to fetch products';
      throw new Error(message);
    }
  };

  const handleSync = async () => {
    setSyncing(true);
    setError(null);
    
    try {
      const fetchedProducts = await fetchProducts();
      setProducts(fetchedProducts);
      
      if (fetchedProducts.length > 0) {
        toast.success(`Synced ${fetchedProducts.length} products!`);
      } else {
        toast.info('No products found in your store');
      }
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Failed to sync products';
      setError(message);
      toast.error('Sync failed', { description: message });
    } finally {
      setSyncing(false);
    }
  };

  const handleRefresh = async () => {
    if (products.length === 0) {
      await handleSync();
    } else {
      setLoading(true);
      try {
        const fetchedProducts = await fetchProducts();
        setProducts(fetchedProducts);
        toast.success('Products refreshed!');
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
        title="Products"
        description="View and manage your WooCommerce products"
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
                Sync Products
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
              icon={Package}
              title="WooCommerce not configured"
              description="Please configure your WooCommerce store credentials to sync products"
              action={{
                label: 'Configure Store',
                onClick: () => window.location.href = '/dashboard/store-settings',
              }}
            />
          ) : loading || syncing ? (
            <TableSkeleton rows={5} />
          ) : products.length === 0 ? (
            <EmptyState
              icon={Package}
              title="No products found"
              description="Click 'Sync Products' to fetch products from your WooCommerce store"
              action={{
                label: 'Sync Products',
                onClick: handleSync,
              }}
            />
          ) : (
            <DataTable
              columns={columns}
              data={products}
              searchKey="name"
              searchPlaceholder="Search products..."
            />
          )}
        </CardContent>
      </Card>
    </PageContainer>
  );
}
