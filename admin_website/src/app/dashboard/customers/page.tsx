'use client';

import { useState, useEffect, useMemo } from 'react';
import { PageHeader, PageContainer } from '@/components/layout/page-header';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { EmptyState } from '@/components/ui/empty-state';
import { TableSkeleton } from '@/components/ui/skeleton-loader';
import { DataTable } from '@/components/ui/data-table';
import { StatusBadge } from '@/components/ui/status-badge';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Separator } from '@/components/ui/separator';
import { toast } from 'sonner';
import { Users, RefreshCw, Mail, Phone, MapPin, AlertCircle, Filter, X } from 'lucide-react';
import type { ColumnDef } from '@tanstack/react-table';
import type { Customer } from '@/lib/types/customer.types';

const formatDate = (dateString: string) => {
  try {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
  } catch {
    return dateString;
  }
};

const getInitials = (firstName: string, lastName: string) => {
  const first = firstName?.charAt(0) || '';
  const last = lastName?.charAt(0) || '';
  return `${first}${last}`.toUpperCase() || '?';
};

const columns: ColumnDef<Customer>[] = [
  {
    accessorKey: 'email',
    header: 'Customer',
    cell: ({ row }) => {
      const customer = row.original;
      const fullName = `${customer.first_name || ''} ${customer.last_name || ''}`.trim() || customer.username || 'Guest';
      const initials = getInitials(customer.first_name || '', customer.last_name || '');
      
      return (
        <div className="flex items-center gap-3">
          <Avatar className="h-10 w-10">
            <AvatarImage src={customer.avatar_url} alt={fullName} />
            <AvatarFallback>{initials}</AvatarFallback>
          </Avatar>
          <div>
            <div className="font-medium">{fullName}</div>
            <div className="text-sm text-muted-foreground">{customer.email}</div>
          </div>
        </div>
      );
    },
  },
  {
    accessorKey: 'billing',
    header: 'Contact',
    cell: ({ row }) => {
      const billing = row.original.billing;
      if (!billing) {
        return <div className="text-muted-foreground">-</div>;
      }
      return (
        <div className="space-y-1">
          {billing.phone && (
            <div className="flex items-center gap-1 text-sm">
              <Phone className="h-3 w-3 text-muted-foreground" />
              <span>{billing.phone}</span>
            </div>
          )}
          {billing.email && (
            <div className="flex items-center gap-1 text-sm text-muted-foreground">
              <Mail className="h-3 w-3" />
              <span>{billing.email}</span>
            </div>
          )}
        </div>
      );
    },
  },
  {
    accessorKey: 'billing.city',
    header: 'Location',
    cell: ({ row }) => {
      const billing = row.original.billing;
      if (!billing || (!billing.city && !billing.country)) {
        return <div className="text-muted-foreground">-</div>;
      }
      const location = [billing.city, billing.state, billing.country].filter(Boolean).join(', ');
      return (
        <div className="flex items-center gap-1 text-sm">
          <MapPin className="h-3 w-3 text-muted-foreground" />
          <span>{location || '-'}</span>
        </div>
      );
    },
  },
  {
    accessorKey: 'date_created',
    header: 'Registered',
    cell: ({ row }) => (
      <div className="text-sm">
        {row.original.date_created ? formatDate(row.original.date_created) : '-'}
      </div>
    ),
  },
  {
    accessorKey: 'is_paying_customer',
    header: 'Status',
    cell: ({ row }) => {
      const isPaying = row.original.is_paying_customer;
      const role = row.original.role;
      
      return (
        <div className="space-y-1">
          <StatusBadge
            status={isPaying ? 'success' : 'inactive'}
            label={isPaying ? 'Paying' : 'Guest'}
            size="sm"
          />
          {role && role !== 'customer' && (
            <div className="text-xs text-muted-foreground mt-1">{role}</div>
          )}
        </div>
      );
    },
  },
];

export default function CustomersPage() {
  const [loading, setLoading] = useState(false);
  const [syncing, setSyncing] = useState(false);
  const [customers, setCustomers] = useState<Customer[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [wooConfigured, setWooConfigured] = useState(false);
  const [totalCustomers, setTotalCustomers] = useState<number | null>(null);
  
  // CRM Filters
  const [searchQuery, setSearchQuery] = useState('');
  const [roleFilter, setRoleFilter] = useState<string>('all');
  const [payingFilter, setPayingFilter] = useState<string>('all');
  const [countryFilter, setCountryFilter] = useState<string>('all');
  const [showFilters, setShowFilters] = useState(false);

  // Check if WooCommerce is configured
  useEffect(() => {
    const wooUrl = localStorage.getItem('osmea-woo-url');
    const wooKey = localStorage.getItem('osmea-woo-key');
    const wooSecret = localStorage.getItem('osmea-woo-secret');
    setWooConfigured(!!(wooUrl && wooKey && wooSecret));
  }, []);

  const fetchCustomers = async (filters?: {
    role?: string;
    search?: string;
  }): Promise<Customer[]> => {
    const wooUrl = localStorage.getItem('osmea-woo-url');
    const wooKey = localStorage.getItem('osmea-woo-key');
    const wooSecret = localStorage.getItem('osmea-woo-secret');

    if (!wooUrl || !wooKey || !wooSecret) {
      throw new Error('WooCommerce credentials not found. Please configure in Store Settings.');
    }

    const response = await fetch('/api/woo/customers', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        storeUrl: wooUrl,
        consumerKey: wooKey,
        consumerSecret: wooSecret,
        per_page: 100,
        role: filters?.role && filters.role !== 'all' ? filters.role : undefined,
        search: filters?.search || undefined,
      }),
    });

    const data = await response.json();

    if (!response.ok) {
      console.error('[Customers Page] API Error:', data);
      throw new Error(data.error || `Failed to fetch customers (${response.status})`);
    }

    // Log for debugging
    console.log('[Customers Page] Response data:', {
      success: data.success,
      customersCount: Array.isArray(data.customers) ? data.customers.length : 'not an array',
      pagination: data.pagination,
      rawResponse: data,
    });

    // Ensure customers is an array
    const customersData = Array.isArray(data.customers) ? data.customers : [];
    
    // Store total count for display
    if (data.pagination?.total !== undefined) {
      setTotalCustomers(data.pagination.total);
    }
    
    if (customersData.length === 0 && data.pagination?.total > 0) {
      console.warn('[Customers Page] No customers in array but total > 0. Response:', data);
      console.warn('[Customers Page] This might indicate a pagination issue. Total:', data.pagination.total);
    }

    // Ensure customers have required fields with defaults
    const customers = customersData.map((customer: Record<string, unknown>) => ({
      ...customer,
      id: customer.id || 0,
      email: customer.email || '',
      first_name: customer.first_name || '',
      last_name: customer.last_name || '',
      username: customer.username || '',
      role: customer.role || 'customer',
      is_paying_customer: customer.is_paying_customer || false,
      avatar_url: customer.avatar_url || '',
      date_created: customer.date_created || new Date().toISOString(),
      date_modified: customer.date_modified || new Date().toISOString(),
      billing: customer.billing || {
        first_name: '',
        last_name: '',
        company: '',
        address_1: '',
        address_2: '',
        city: '',
        state: '',
        postcode: '',
        country: '',
        email: '',
        phone: '',
      },
      shipping: customer.shipping || {
        first_name: '',
        last_name: '',
        company: '',
        address_1: '',
        address_2: '',
        city: '',
        state: '',
        postcode: '',
        country: '',
      },
      meta_data: customer.meta_data || [],
    }));

    return customers;
  };

  const handleSync = async () => {
    setSyncing(true);
    setError(null);
    
    try {
      const fetchedCustomers = await fetchCustomers();
      setCustomers(fetchedCustomers);
      
      if (fetchedCustomers.length > 0) {
        toast.success(`Synced ${fetchedCustomers.length} customers!`);
      } else {
        toast.info('No customers found in your store');
      }
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Failed to sync customers';
      setError(message);
      toast.error('Sync failed', { description: message });
    } finally {
      setSyncing(false);
    }
  };

  const handleRefresh = async () => {
    if (customers.length === 0) {
      await handleSync();
    } else {
      setLoading(true);
      try {
        const fetchedCustomers = await fetchCustomers();
        setCustomers(fetchedCustomers);
        toast.success('Customers refreshed!');
      } catch (err) {
        const message = err instanceof Error ? err.message : 'Failed to refresh';
        toast.error(message);
      } finally {
        setLoading(false);
      }
    }
  };

  // Filter customers based on CRM filters
  const filteredCustomers = useMemo(() => {
    let filtered = [...customers];

    // Search filter
    if (searchQuery) {
      const query = searchQuery.toLowerCase();
      filtered = filtered.filter((customer) => {
        const fullName = `${customer.first_name} ${customer.last_name}`.toLowerCase();
        const email = customer.email?.toLowerCase() || '';
        const username = customer.username?.toLowerCase() || '';
        return (
          fullName.includes(query) ||
          email.includes(query) ||
          username.includes(query)
        );
      });
    }

    // Role filter
    if (roleFilter !== 'all') {
      filtered = filtered.filter((customer) => customer.role === roleFilter);
    }

    // Paying customer filter
    if (payingFilter === 'paying') {
      filtered = filtered.filter((customer) => customer.is_paying_customer === true);
    } else if (payingFilter === 'non-paying') {
      filtered = filtered.filter((customer) => customer.is_paying_customer === false);
    }

    // Country filter
    if (countryFilter !== 'all') {
      filtered = filtered.filter(
        (customer) => customer.billing?.country?.toLowerCase() === countryFilter.toLowerCase()
      );
    }

    return filtered;
  }, [customers, searchQuery, roleFilter, payingFilter, countryFilter]);

  // Get unique countries and roles for filters
  const uniqueCountries = useMemo(() => {
    const countries = new Set<string>();
    customers.forEach((customer) => {
      if (customer.billing?.country) {
        countries.add(customer.billing.country);
      }
    });
    return Array.from(countries).sort();
  }, [customers]);

  const uniqueRoles = useMemo(() => {
    const roles = new Set<string>();
    customers.forEach((customer) => {
      if (customer.role) {
        roles.add(customer.role);
      }
    });
    return Array.from(roles).sort();
  }, [customers]);

  const clearFilters = () => {
    setSearchQuery('');
    setRoleFilter('all');
    setPayingFilter('all');
    setCountryFilter('all');
  };

  const activeFiltersCount = useMemo(() => {
    let count = 0;
    if (searchQuery) count++;
    if (roleFilter !== 'all') count++;
    if (payingFilter !== 'all') count++;
    if (countryFilter !== 'all') count++;
    return count;
  }, [searchQuery, roleFilter, payingFilter, countryFilter]);

  useEffect(() => {
    if (wooConfigured) {
      setLoading(true);
      fetchCustomers()
        .then((data) => {
          setCustomers(data);
        })
        .catch((err) => {
          const errorMessage = err instanceof Error ? err.message : 'Failed to fetch customers';
          setError(errorMessage);
        })
        .finally(() => {
          setLoading(false);
        });
    }
  }, [wooConfigured]);

  return (
    <PageContainer>
      <PageHeader
        title="Customers"
        description={
          totalCustomers !== null
            ? `Total: ${totalCustomers.toLocaleString()} customer${totalCustomers !== 1 ? 's' : ''}`
            : 'Manage your store customers'
        }
        actions={
          <Button
            onClick={handleSync}
            disabled={syncing || !wooConfigured}
            variant="outline"
          >
            <RefreshCw className={`h-4 w-4 mr-2 ${syncing ? 'animate-spin' : ''}`} />
            {syncing ? 'Syncing...' : 'Sync Customers'}
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

      {/* Stats Cards */}
      {customers.length > 0 && (
        <div className="grid gap-4 md:grid-cols-4 mt-6">
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                Total Customers
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">
                {totalCustomers !== null ? totalCustomers.toLocaleString() : customers.length}
              </div>
              <p className="text-xs text-muted-foreground mt-1">
                {filteredCustomers.length} shown
              </p>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                Paying Customers
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">
                {customers.filter((c) => c.is_paying_customer).length}
              </div>
              <p className="text-xs text-muted-foreground mt-1">
                {((customers.filter((c) => c.is_paying_customer).length / customers.length) * 100).toFixed(1)}% of total
              </p>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                Countries
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{uniqueCountries.length}</div>
              <p className="text-xs text-muted-foreground mt-1">Unique locations</p>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                Filtered
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{filteredCustomers.length}</div>
              <p className="text-xs text-muted-foreground mt-1">
                {activeFiltersCount > 0 ? `${activeFiltersCount} filter${activeFiltersCount > 1 ? 's' : ''} active` : 'No filters'}
              </p>
            </CardContent>
          </Card>
        </div>
      )}

      {/* CRM Filters */}
      {customers.length > 0 && (
        <Card className="mt-6">
          <CardHeader>
            <div className="flex items-center justify-between">
              <div>
                <CardTitle className="flex items-center gap-2">
                  <Filter className="h-5 w-5" />
                  Filters
                </CardTitle>
                <CardDescription>
                  Filter customers by various criteria
                </CardDescription>
              </div>
              <div className="flex items-center gap-2">
                {activeFiltersCount > 0 && (
                  <Button
                    variant="ghost"
                    size="sm"
                    onClick={clearFilters}
                    className="text-muted-foreground"
                  >
                    <X className="h-4 w-4 mr-1" />
                    Clear ({activeFiltersCount})
                  </Button>
                )}
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => setShowFilters(!showFilters)}
                >
                  {showFilters ? 'Hide' : 'Show'} Filters
                </Button>
              </div>
            </div>
          </CardHeader>
          {showFilters && (
            <CardContent>
              <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
                {/* Search */}
                <div className="space-y-2">
                  <Label htmlFor="search">Search</Label>
                  <Input
                    id="search"
                    placeholder="Search by name, email..."
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                  />
                </div>

                {/* Role Filter */}
                <div className="space-y-2">
                  <Label htmlFor="role">Role</Label>
                  <Select value={roleFilter} onValueChange={setRoleFilter}>
                    <SelectTrigger id="role">
                      <SelectValue placeholder="All roles" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">All Roles</SelectItem>
                      {uniqueRoles.map((role) => (
                        <SelectItem key={role} value={role}>
                          {role.charAt(0).toUpperCase() + role.slice(1)}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>

                {/* Paying Customer Filter */}
                <div className="space-y-2">
                  <Label htmlFor="paying">Customer Type</Label>
                  <Select value={payingFilter} onValueChange={setPayingFilter}>
                    <SelectTrigger id="paying">
                      <SelectValue placeholder="All types" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">All Customers</SelectItem>
                      <SelectItem value="paying">Paying Customers</SelectItem>
                      <SelectItem value="non-paying">Non-Paying</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                {/* Country Filter */}
                <div className="space-y-2">
                  <Label htmlFor="country">Country</Label>
                  <Select value={countryFilter} onValueChange={setCountryFilter}>
                    <SelectTrigger id="country">
                      <SelectValue placeholder="All countries" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">All Countries</SelectItem>
                      {uniqueCountries.map((country) => (
                        <SelectItem key={country} value={country}>
                          {country}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
              </div>
            </CardContent>
          )}
        </Card>
      )}

      <Card className="mt-6">
        <CardContent className="pt-6">
          {!wooConfigured ? (
            <EmptyState
              icon={Users}
              title="WooCommerce not configured"
              description="Please configure your WooCommerce store credentials to sync customers"
              action={{
                label: 'Configure Store',
                onClick: () => window.location.href = '/dashboard/store-settings',
              }}
            />
          ) : loading || syncing ? (
            <TableSkeleton rows={5} />
          ) : customers.length === 0 ? (
            <EmptyState
              icon={Users}
              title={totalCustomers && totalCustomers > 0 ? `Found ${totalCustomers} customers` : "No customers found"}
              description={
                totalCustomers && totalCustomers > 0
                  ? `There are ${totalCustomers} customers in WooCommerce, but they couldn't be loaded. Try syncing again or check the console for errors.`
                  : "Click 'Sync Customers' to fetch customers from your WooCommerce store"
              }
              action={{
                label: 'Sync Customers',
                onClick: handleSync,
              }}
            />
          ) : (
            <DataTable
              columns={columns}
              data={filteredCustomers}
              searchKey="email"
              searchPlaceholder="Search customers by email..."
              showSearch={false}
            />
          )}
        </CardContent>
      </Card>
    </PageContainer>
  );
}
