'use client';

import { useState } from 'react';
import { PageHeader, PageContainer } from '@/components/layout/page-header';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import { Separator } from '@/components/ui/separator';
import { toast } from 'sonner';
import { 
  Loader2, 
  User, 
  Bell, 
  Shield, 
  Palette,
  Save,
  LogOut,
} from 'lucide-react';
import { useAuth } from '@/lib/hooks/use-auth';

export default function SettingsPage() {
  const { user, signOut } = useAuth();
  const [saving, setSaving] = useState(false);
  const [profile, setProfile] = useState({
    name: user?.user_metadata?.display_name || '',
    email: user?.email || '',
  });
  const [notifications, setNotifications] = useState({
    email: true,
    push: true,
    buildComplete: true,
    buildFailed: true,
  });
  const [appearance, setAppearance] = useState({
    theme: 'system',
    compactMode: false,
  });

  const handleSave = async () => {
    setSaving(true);
    try {
      await new Promise((resolve) => setTimeout(resolve, 1000));
      toast.success('Settings saved successfully!');
    } catch (error) {
      toast.error('Failed to save settings');
    } finally {
      setSaving(false);
    }
  };

  const handleSignOut = async () => {
    try {
      await signOut();
      window.location.href = '/login';
    } catch (error) {
      toast.error('Failed to sign out');
    }
  };

  return (
    <PageContainer>
      <PageHeader
        title="Settings"
        description="Manage your account and preferences"
        actions={
          <Button onClick={handleSave} disabled={saving}>
            {saving ? (
              <>
                <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                Saving...
              </>
            ) : (
              <>
                <Save className="mr-2 h-4 w-4" />
                Save Changes
              </>
            )}
          </Button>
        }
      />

      <div className="space-y-6 mt-6">
        <Card>
          <CardHeader>
            <div className="flex items-center gap-3">
              <div className="p-2 bg-primary/10 rounded-lg">
                <User className="h-5 w-5 text-primary" />
              </div>
              <div>
                <CardTitle>Profile</CardTitle>
                <CardDescription>Your account information</CardDescription>
              </div>
            </div>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid gap-4 md:grid-cols-2">
              <div className="space-y-2">
                <Label htmlFor="name">Display Name</Label>
                <Input
                  id="name"
                  value={profile.name}
                  onChange={(e) => setProfile({ ...profile, name: e.target.value })}
                  placeholder="Your name"
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="email">Email</Label>
                <Input
                  id="email"
                  type="email"
                  value={profile.email}
                  disabled
                  className="bg-muted"
                />
                <p className="text-xs text-muted-foreground">Email cannot be changed</p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <div className="flex items-center gap-3">
              <div className="p-2 bg-blue-100 dark:bg-blue-900/30 rounded-lg">
                <Bell className="h-5 w-5 text-blue-600" />
              </div>
              <div>
                <CardTitle>Notifications</CardTitle>
                <CardDescription>Configure how you receive updates</CardDescription>
              </div>
            </div>
          </CardHeader>
          <CardContent className="space-y-4">
            {[
              { key: 'email', label: 'Email Notifications', description: 'Receive updates via email' },
              { key: 'push', label: 'Push Notifications', description: 'Receive browser notifications' },
              { key: 'buildComplete', label: 'Build Complete', description: 'Notify when a build finishes' },
              { key: 'buildFailed', label: 'Build Failed', description: 'Notify when a build fails' },
            ].map((item) => (
              <div key={item.key} className="flex items-center justify-between">
                <div>
                  <Label htmlFor={item.key} className="text-base">{item.label}</Label>
                  <p className="text-sm text-muted-foreground">{item.description}</p>
                </div>
                <Switch
                  id={item.key}
                  checked={notifications[item.key as keyof typeof notifications]}
                  onCheckedChange={(checked) =>
                    setNotifications({ ...notifications, [item.key]: checked })
                  }
                />
              </div>
            ))}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <div className="flex items-center gap-3">
              <div className="p-2 bg-purple-100 dark:bg-purple-900/30 rounded-lg">
                <Palette className="h-5 w-5 text-purple-600" />
              </div>
              <div>
                <CardTitle>Appearance</CardTitle>
                <CardDescription>Customize the look and feel</CardDescription>
              </div>
            </div>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="flex items-center justify-between">
              <div>
                <Label className="text-base">Compact Mode</Label>
                <p className="text-sm text-muted-foreground">Use a more condensed layout</p>
              </div>
              <Switch
                checked={appearance.compactMode}
                onCheckedChange={(checked) =>
                  setAppearance({ ...appearance, compactMode: checked })
                }
              />
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <div className="flex items-center gap-3">
              <div className="p-2 bg-red-100 dark:bg-red-900/30 rounded-lg">
                <Shield className="h-5 w-5 text-red-600" />
              </div>
              <div>
                <CardTitle>Security</CardTitle>
                <CardDescription>Account security options</CardDescription>
              </div>
            </div>
          </CardHeader>
          <CardContent className="space-y-4">
            <div>
              <Label className="text-base">Password</Label>
              <p className="text-sm text-muted-foreground mb-2">Change your account password</p>
              <Button variant="outline">Change Password</Button>
            </div>

            <Separator />

            <div>
              <Label className="text-base text-red-600">Sign Out</Label>
              <p className="text-sm text-muted-foreground mb-2">Sign out from your account</p>
              <Button variant="destructive" onClick={handleSignOut}>
                <LogOut className="mr-2 h-4 w-4" />
                Sign Out
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>
    </PageContainer>
  );
}
