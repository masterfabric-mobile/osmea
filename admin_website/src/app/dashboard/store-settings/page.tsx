'use client';

import { useState } from 'react';
import { PageHeader, PageContainer } from '@/components/layout/page-header';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { StatusBadge } from '@/components/ui/status-badge';
import { toast } from 'sonner';
import { Loader2, Store, Database, RefreshCw } from 'lucide-react';
import { testWooCommerceConnection } from '@/lib/woocommerce/client';

export default function StoreSettingsPage() {
  const [wooUrl, setWooUrl] = useState('');
  const [wooKey, setWooKey] = useState('');
  const [wooSecret, setWooSecret] = useState('');
  const [supabaseUrl, setSupabaseUrl] = useState('');
  const [supabaseKey, setSupabaseKey] = useState('');
  const [testing, setTesting] = useState(false);
  const [saving, setSaving] = useState(false);
  const [wooConnected, setWooConnected] = useState<boolean | null>(null);
  const [supabaseConnected, setSupabaseConnected] = useState<boolean | null>(null);

  const handleTestWooCommerce = async () => {
    if (!wooUrl || !wooKey || !wooSecret) {
      toast.error('Please fill in all WooCommerce fields');
      return;
    }

    setTesting(true);
    try {
      const result = await testWooCommerceConnection({
        storeUrl: wooUrl,
        consumerKey: wooKey,
        consumerSecret: wooSecret,
      });

      if (result.success) {
        setWooConnected(true);
        toast.success('WooCommerce connection successful!');
      } else {
        setWooConnected(false);
        toast.error(result.message);
      }
    } catch (error) {
      setWooConnected(false);
      toast.error('Failed to connect to WooCommerce');
    } finally {
      setTesting(false);
    }
  };

  const handleSave = async () => {
    setSaving(true);
    try {
      localStorage.setItem('woo_store_url', wooUrl);
      localStorage.setItem('supabase_url', supabaseUrl);
      toast.success('Settings saved successfully!');
    } catch (error) {
      toast.error('Failed to save settings');
    } finally {
      setSaving(false);
    }
  };

  return (
    <PageContainer>
      <PageHeader
        title="Store Settings"
        description="Configure your WooCommerce and Supabase connections"
      />

      <div className="grid gap-6 mt-6">
        <Card>
          <CardHeader>
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="p-2 bg-purple-100 dark:bg-purple-900/30 rounded-lg">
                  <Store className="h-5 w-5 text-purple-600" />
                </div>
                <div>
                  <CardTitle>WooCommerce Connection</CardTitle>
                  <CardDescription>Connect your WooCommerce store</CardDescription>
                </div>
              </div>
              {wooConnected !== null && (
                <StatusBadge 
                  status={wooConnected ? 'success' : 'error'} 
                  label={wooConnected ? 'Connected' : 'Disconnected'}
                />
              )}
            </div>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="woo-url">Store URL</Label>
              <Input
                id="woo-url"
                type="url"
                placeholder="https://yourstore.com"
                value={wooUrl}
                onChange={(e) => setWooUrl(e.target.value)}
              />
            </div>
            <div className="grid gap-4 md:grid-cols-2">
              <div className="space-y-2">
                <Label htmlFor="woo-key">Consumer Key</Label>
                <Input
                  id="woo-key"
                  placeholder="ck_xxxxx"
                  value={wooKey}
                  onChange={(e) => setWooKey(e.target.value)}
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="woo-secret">Consumer Secret</Label>
                <Input
                  id="woo-secret"
                  type="password"
                  placeholder="cs_xxxxx"
                  value={wooSecret}
                  onChange={(e) => setWooSecret(e.target.value)}
                />
              </div>
            </div>
            <Button onClick={handleTestWooCommerce} disabled={testing}>
              {testing ? (
                <>
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                  Testing...
                </>
              ) : (
                <>
                  <RefreshCw className="mr-2 h-4 w-4" />
                  Test Connection
                </>
              )}
            </Button>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="p-2 bg-green-100 dark:bg-green-900/30 rounded-lg">
                  <Database className="h-5 w-5 text-green-600" />
                </div>
                <div>
                  <CardTitle>Supabase Connection</CardTitle>
                  <CardDescription>Configure your Supabase backend</CardDescription>
                </div>
              </div>
              {supabaseConnected !== null && (
                <StatusBadge 
                  status={supabaseConnected ? 'success' : 'error'} 
                  label={supabaseConnected ? 'Connected' : 'Disconnected'}
                />
              )}
            </div>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="supabase-url">Project URL</Label>
              <Input
                id="supabase-url"
                type="url"
                placeholder="https://xxxxx.supabase.co"
                value={supabaseUrl}
                onChange={(e) => setSupabaseUrl(e.target.value)}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="supabase-key">Anon Key</Label>
              <Input
                id="supabase-key"
                type="password"
                placeholder="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
                value={supabaseKey}
                onChange={(e) => setSupabaseKey(e.target.value)}
              />
            </div>
            <p className="text-sm text-muted-foreground">
              Supabase connection is configured via environment variables.
            </p>
          </CardContent>
        </Card>

        <div className="flex justify-end">
          <Button onClick={handleSave} disabled={saving}>
            {saving ? (
              <>
                <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                Saving...
              </>
            ) : (
              'Save Settings'
            )}
          </Button>
        </div>
      </div>
    </PageContainer>
  );
}
