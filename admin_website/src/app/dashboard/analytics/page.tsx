'use client';

import { useState, useEffect, useCallback } from 'react';
import { PageHeader, PageContainer, PageSection } from '@/components/layout/page-header';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { StatCard } from '@/components/dashboard/stat-card';
import { EmptyState } from '@/components/ui/empty-state';
import { getAnalyticsService, type AnalyticsData } from '@/lib/services/analytics.service';
import { 
  BarChart3, 
  TrendingUp, 
  Users, 
  ShoppingCart, 
  DollarSign,
  Package,
  AlertCircle,
} from 'lucide-react';
import { toast } from 'sonner';

export default function AnalyticsPage() {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [analyticsData, setAnalyticsData] = useState<AnalyticsData | null>(null);

  const formatCurrency = (amount: number, currency: string = 'USD') => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: currency,
    }).format(amount);
  };

  const fetchAnalytics = useCallback(async () => {
    setLoading(true);
    setError(null);
    
    try {
      const service = getAnalyticsService();
      const data = await service.getAnalyticsData();
      setAnalyticsData(data);
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'Failed to fetch analytics data';
      setError(errorMessage);
      console.error('Error fetching analytics:', err);
      toast.error('Failed to sync analytics data', {
        description: errorMessage,
      });
    } finally {
      setLoading(false);
    }
  }, []);

  const handleRefresh = async () => {
    await fetchAnalytics();
  };

  useEffect(() => {
    fetchAnalytics();
  }, [fetchAnalytics]);

  return (
    <PageContainer>
      <PageHeader
        title="Analytics"
        description="Track your store and app performance"
        onRefresh={handleRefresh}
        refreshing={loading}
      />

      {error && (
        <Card className="mt-6 border-destructive">
          <CardContent className="pt-6">
            <div className="flex items-center gap-2 text-destructive">
              <AlertCircle className="h-5 w-5" />
              <div>
                <p className="font-medium">Failed to sync analytics</p>
                <p className="text-sm text-muted-foreground">{error}</p>
              </div>
            </div>
          </CardContent>
        </Card>
      )}

      <PageSection className="mt-6">
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
          <StatCard
            title="Total Revenue"
            value={analyticsData ? formatCurrency(analyticsData.totalRevenue, analyticsData.currency) : '$0.00'}
            description="All time"
            icon={DollarSign}
            trend={analyticsData ? { value: analyticsData.averageOrderValue, isPositive: true } : undefined}
          />
          <StatCard
            title="Total Orders"
            value={analyticsData ? analyticsData.totalOrders.toLocaleString() : '0'}
            description="All time"
            icon={ShoppingCart}
          />
          <StatCard
            title="Products Sold"
            value={analyticsData ? analyticsData.productsSold.toLocaleString() : '0'}
            description="All time"
            icon={Package}
          />
          <StatCard
            title="Total Customers"
            value={analyticsData ? analyticsData.totalCustomers.toLocaleString() : '0'}
            description="Registered customers"
            icon={Users}
          />
        </div>
      </PageSection>

      <div className="grid gap-6 md:grid-cols-2 mt-6">
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <TrendingUp className="h-5 w-5" />
              Revenue Overview
            </CardTitle>
            <CardDescription>Monthly revenue trends</CardDescription>
          </CardHeader>
          <CardContent>
            {loading ? (
              <div className="flex items-center justify-center h-48">
                <div className="text-muted-foreground">Loading...</div>
              </div>
            ) : analyticsData && analyticsData.monthlyRevenue.length > 0 ? (
              <div className="space-y-4">
                {analyticsData.monthlyRevenue.slice(0, 6).map((item, index) => (
                  <div key={index} className="flex items-center justify-between">
                    <div className="flex-1">
                      <div className="text-sm font-medium">{item.period}</div>
                      <div className="text-xs text-muted-foreground">{item.orders} orders</div>
                    </div>
                    <div className="text-right">
                      <div className="text-sm font-semibold">
                        {formatCurrency(item.revenue, analyticsData.currency)}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <EmptyState
                icon={BarChart3}
                title="No data yet"
                description="Revenue data will appear here once your store has orders"
                compact
              />
            )}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <ShoppingCart className="h-5 w-5" />
              Orders Overview
            </CardTitle>
            <CardDescription>Daily order trends</CardDescription>
          </CardHeader>
          <CardContent>
            {loading ? (
              <div className="flex items-center justify-center h-48">
                <div className="text-muted-foreground">Loading...</div>
              </div>
            ) : analyticsData && analyticsData.dailyOrders.length > 0 ? (
              <div className="space-y-4">
                {analyticsData.dailyOrders.slice(0, 6).map((item, index) => (
                  <div key={index} className="flex items-center justify-between">
                    <div className="flex-1">
                      <div className="text-sm font-medium">{item.period}</div>
                    </div>
                    <div className="text-right">
                      <div className="text-sm font-semibold">{item.orders} orders</div>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <EmptyState
                icon={BarChart3}
                title="No data yet"
                description="Order data will appear here once synced"
                compact
              />
            )}
          </CardContent>
        </Card>
      </div>

      <PageSection title="App Analytics" className="mt-6">
        <div className="grid gap-4 md:grid-cols-3">
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                App Downloads
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">0</div>
              <p className="text-xs text-muted-foreground">Total installations</p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                Active Sessions
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">0</div>
              <p className="text-xs text-muted-foreground">Current active users</p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                Avg. Session Duration
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">0m</div>
              <p className="text-xs text-muted-foreground">Per user session</p>
            </CardContent>
          </Card>
        </div>
      </PageSection>

      <PageSection title="Build Analytics" className="mt-6">
        <div className="grid gap-4 md:grid-cols-4">
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                Total Builds
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">0</div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                Success Rate
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">0%</div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                Avg Build Time
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">0m</div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                Failed Builds
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">0</div>
            </CardContent>
          </Card>
        </div>
      </PageSection>
    </PageContainer>
  );
}
