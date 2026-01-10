'use client';

import { useState, useEffect } from 'react';
import { PageHeader, PageContainer } from '@/components/layout/page-header';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { toast } from 'sonner';
import { 
  Loader2, 
  Smartphone, 
  Palette, 
  Settings,
  Save,
  Download,
  Upload,
  Home,
  Navigation,
  Shield,
  Bell,
  Globe,
  Zap,
  Layout,
  Search,
  User,
  ShoppingBag,
  AlertCircle,
  ChevronDown,
  ChevronUp,
  Copy,
  Check,
  RotateCcw,
  Code,
  Eye,
} from 'lucide-react';

// Default configuration matching the storefront_woo app_config.json structure
const defaultConfig = {
  app_settings: {
    app_name: "Storefront WooCommerce",
    app_version: "1.0.0",
    build_number: "1",
    environment: "production",
    debug_mode: false,
    maintenance_mode: false
  },
  api_configuration: {
    base_url: "",
    timeout_seconds: 45,
    retry_count: 3,
    enable_logging: true
  },
  woocommerce_configuration: {
    store_url: "",
    brand_name: "",
    auth_key: "",
    version: "v1",
    verify_ssl: true,
    query_string_auth: false,
    products_per_page: 20,
    enable_reviews: true,
    enable_coupons: true,
    enable_guest_checkout: true
  },
  firebase_configuration: {
    analytics_enabled: true,
    crashlytics_enabled: true,
    performance_monitoring_enabled: true,
    remote_config_enabled: true,
    remote_config_fetch_timeout: 60,
    remote_config_cache_expiration: 3600
  },
  ui_configuration: {
    theme_mode: "light",
    primary_color: "#000000",
    accent_color: "#FFFFFF",
    search_app_bar_color: "#A3D3F2FF",
    font_scale: 1.0,
    enable_haptic_feedback: true,
    enable_sound_effects: true
  },
  security_configuration: {
    enable_ssl_pinning: true,
    certificate_validation: true,
    biometric_authentication: true,
    session_timeout_minutes: 45
  },
  storage_configuration: {
    enable_encryption: true,
    cache_size_mb: 150,
    auto_cleanup_enabled: true,
    backup_enabled: true
  },
  notification_configuration: {
    push_notifications_enabled: true,
    local_notifications_enabled: true,
    notification_sound: "default",
    vibration_enabled: true
  },
  feature_flags: {
    onboarding_enabled: true,
    dark_mode_available: true,
    offline_mode_enabled: true,
    beta_features_enabled: false,
    analytics_opt_out_available: true,
    woocommerce_integration_enabled: true,
    payment_gateway_enabled: true,
    wishlist_enabled: true,
    cart_persistence_enabled: true
  },
  splash_configuration: {
    enabled: true,
    style: "startup",
    duration_milliseconds: 3000,
    min_duration_milliseconds: 1500,
    logo_url: "",
    background_color: "#FFFFFF",
    logo_color: "#000000",
    show_loading_indicator: true,
    loading_indicator_color: "#000000",
    show_version_info: true,
    version_text_color: "#666666",
    fade_animation_enabled: true,
    animation_duration_milliseconds: 500,
    enable_logo_animation: true,
    logo_animation_type: "fade_scale",
    show_app_name: true,
    app_name_text_color: "#000000",
    app_name_font_size: 24,
    navigation_target: "/onboarding",
    fallback_navigation_target: "/home"
  },
  localization_configuration: {
    default_language: "en",
    supported_languages: ["en", "tr", "de", "fr"],
    rtl_support: false,
    auto_detect_language: true
  },
  performance_configuration: {
    image_cache_size_mb: 75,
    network_cache_size_mb: 50,
    lazy_loading_enabled: true,
    preload_critical_assets: true
  },
  navbar_configuration: {
    enabled: true,
    items: [
      { id: "home", order_id: 0, text: "Home", iconName: "home_outlined", route: "/home" },
      { id: "search", order_id: 1, text: "Search", iconName: "search_outlined", route: "/search" },
      { id: "cart", order_id: 2, text: "Cart", iconName: "shopping_cart_outlined", route: "/cart" },
      { id: "saved", order_id: 3, text: "Saved", iconName: "favorite_outline", route: "/saved" },
      { id: "profile", order_id: 4, text: "Profile", iconName: "person_outline", route: "/profile" }
    ]
  },
  home_view: {
    search: { enabled: true, order_id: 0 },
    circle_categories: { enabled: true, order_id: 1 },
    banner: { enabled: true, order_id: 2 },
    promotional_bar: { enabled: true, order_id: 3 },
    campaign_cards: { enabled: true, order_id: 4 },
    campaign_alert: { enabled: true, order_id: 6 },
    brands: { enabled: true, order_id: 7 },
    deals_of_day: { enabled: true, order_id: 8 },
    flash_sale: { enabled: true, order_id: 9 },
    recommended: { enabled: true, order_id: 10 }
  }
};

type ConfigType = typeof defaultConfig;

export default function AppConfigPage() {
  const [saving, setSaving] = useState(false);
  const [config, setConfig] = useState<ConfigType>(defaultConfig);
  const [expandedSections, setExpandedSections] = useState<Record<string, boolean>>({});
  const [copied, setCopied] = useState(false);

  // Load config from localStorage on mount
  useEffect(() => {
    const savedConfig = localStorage.getItem('osmea-app-config');
    if (savedConfig) {
      try {
        const parsed = JSON.parse(savedConfig);
        setConfig({ ...defaultConfig, ...parsed });
      } catch (e) {
        console.error('Failed to parse saved config:', e);
      }
    }

    // Also load WooCommerce credentials from onboarding
    const wooUrl = localStorage.getItem('osmea-woo-url');
    const wooKey = localStorage.getItem('osmea-woo-key');
    const appName = localStorage.getItem('osmea-app-name');
    
    if (wooUrl || wooKey || appName) {
      setConfig(prev => ({
        ...prev,
        app_settings: {
          ...prev.app_settings,
          app_name: appName || prev.app_settings.app_name
        },
        woocommerce_configuration: {
          ...prev.woocommerce_configuration,
          store_url: wooUrl || prev.woocommerce_configuration.store_url,
        }
      }));
    }
  }, []);

  const toggleSection = (section: string) => {
    setExpandedSections(prev => ({ ...prev, [section]: !prev[section] }));
  };

  const updateConfig = <K extends keyof ConfigType>(
    section: K,
    key: keyof ConfigType[K],
    value: unknown
  ) => {
    setConfig(prev => ({
      ...prev,
      [section]: {
        ...prev[section],
        [key]: value
      }
    }));
  };

  const handleSave = async () => {
    setSaving(true);
    try {
      localStorage.setItem('osmea-app-config', JSON.stringify(config));
      await new Promise((resolve) => setTimeout(resolve, 500));
      toast.success('Configuration saved successfully!');
    } catch (error) {
      toast.error('Failed to save configuration');
    } finally {
      setSaving(false);
    }
  };

  const handleExport = () => {
    const dataStr = JSON.stringify(config, null, 2);
    const dataUri = 'data:application/json;charset=utf-8,'+ encodeURIComponent(dataStr);
    const exportFileDefaultName = 'app_config.json';
    
    const linkElement = document.createElement('a');
    linkElement.setAttribute('href', dataUri);
    linkElement.setAttribute('download', exportFileDefaultName);
    linkElement.click();
    toast.success('Configuration exported!');
  };

  const handleImport = () => {
    const input = document.createElement('input');
    input.type = 'file';
    input.accept = '.json';
    input.onchange = (e) => {
      const file = (e.target as HTMLInputElement).files?.[0];
      if (file) {
        const reader = new FileReader();
        reader.onload = (event) => {
          try {
            const imported = JSON.parse(event.target?.result as string);
            setConfig({ ...defaultConfig, ...imported });
            toast.success('Configuration imported!');
          } catch (err) {
            toast.error('Invalid JSON file');
          }
        };
        reader.readAsText(file);
      }
    };
    input.click();
  };

  const handleReset = () => {
    if (confirm('Are you sure you want to reset all settings to default?')) {
      setConfig(defaultConfig);
      localStorage.removeItem('osmea-app-config');
      toast.success('Configuration reset to defaults');
    }
  };

  const handleCopyJson = async () => {
    await navigator.clipboard.writeText(JSON.stringify(config, null, 2));
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
    toast.success('JSON copied to clipboard!');
  };

  // Collapsible Section Component
  const CollapsibleSection = ({ 
    title, 
    description, 
    id, 
    children 
  }: { 
    title: string; 
    description: string; 
    id: string; 
    children: React.ReactNode;
  }) => (
    <Card className="mb-4">
      <CardHeader 
        className="cursor-pointer hover:bg-muted/50 transition-colors"
        onClick={() => toggleSection(id)}
      >
        <div className="flex items-center justify-between">
          <div>
            <CardTitle className="text-base">{title}</CardTitle>
            <CardDescription>{description}</CardDescription>
          </div>
          {expandedSections[id] ? <ChevronUp className="h-5 w-5" /> : <ChevronDown className="h-5 w-5" />}
        </div>
      </CardHeader>
      {expandedSections[id] && (
        <CardContent className="border-t">{children}</CardContent>
      )}
    </Card>
  );

  // Color Picker Component
  const ColorPicker = ({ 
    label, 
    value, 
    onChange 
  }: { 
    label: string; 
    value: string; 
    onChange: (v: string) => void;
  }) => (
    <div className="space-y-2">
      <Label>{label}</Label>
      <div className="flex gap-2">
        <Input
          type="color"
          value={value.substring(0, 7)}
          onChange={(e) => onChange(e.target.value)}
          className="w-12 h-10 p-1 cursor-pointer"
        />
        <Input
          value={value}
          onChange={(e) => onChange(e.target.value)}
          className="flex-1 font-mono text-sm"
          placeholder="#000000"
        />
      </div>
    </div>
  );

  // Toggle Item Component
  const ToggleItem = ({ 
    label, 
    description, 
    checked, 
    onChange 
  }: { 
    label: string; 
    description: string; 
    checked: boolean; 
    onChange: (v: boolean) => void;
  }) => (
    <div className="flex items-center justify-between p-3 bg-muted/50 rounded-lg">
      <div>
        <Label className="text-sm font-medium">{label}</Label>
        <p className="text-xs text-muted-foreground">{description}</p>
      </div>
      <Switch checked={checked} onCheckedChange={onChange} />
    </div>
  );

  return (
    <PageContainer>
      <PageHeader
        title="App Configuration"
        description="Configure your mobile app settings - matches storefront_woo/assets/app_config.json"
        actions={
          <div className="flex gap-2 flex-wrap">
            <Button variant="outline" size="sm" onClick={handleImport}>
              <Upload className="mr-2 h-4 w-4" />
              Import
            </Button>
            <Button variant="outline" size="sm" onClick={handleExport}>
              <Download className="mr-2 h-4 w-4" />
              Export
            </Button>
            <Button variant="outline" size="sm" onClick={handleCopyJson}>
              {copied ? <Check className="mr-2 h-4 w-4" /> : <Copy className="mr-2 h-4 w-4" />}
              {copied ? 'Copied!' : 'Copy JSON'}
            </Button>
            <Button variant="outline" size="sm" onClick={handleReset}>
              <RotateCcw className="mr-2 h-4 w-4" />
              Reset
            </Button>
            <Button onClick={handleSave} disabled={saving}>
              {saving ? (
                <>
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                  Saving...
                </>
              ) : (
                <>
                  <Save className="mr-2 h-4 w-4" />
                  Save
                </>
              )}
            </Button>
          </div>
        }
      />

      <Tabs defaultValue="general" className="mt-6">
        <TabsList className="flex flex-wrap h-auto gap-1 bg-muted p-1">
          <TabsTrigger value="general" className="text-xs">
            <Smartphone className="mr-1.5 h-3.5 w-3.5" />
            General
          </TabsTrigger>
          <TabsTrigger value="theme" className="text-xs">
            <Palette className="mr-1.5 h-3.5 w-3.5" />
            Theme
          </TabsTrigger>
          <TabsTrigger value="features" className="text-xs">
            <Settings className="mr-1.5 h-3.5 w-3.5" />
            Features
          </TabsTrigger>
          <TabsTrigger value="home" className="text-xs">
            <Home className="mr-1.5 h-3.5 w-3.5" />
            Home
          </TabsTrigger>
          <TabsTrigger value="navigation" className="text-xs">
            <Navigation className="mr-1.5 h-3.5 w-3.5" />
            Navigation
          </TabsTrigger>
          <TabsTrigger value="splash" className="text-xs">
            <Zap className="mr-1.5 h-3.5 w-3.5" />
            Splash
          </TabsTrigger>
          <TabsTrigger value="security" className="text-xs">
            <Shield className="mr-1.5 h-3.5 w-3.5" />
            Security
          </TabsTrigger>
          <TabsTrigger value="preview" className="text-xs">
            <Code className="mr-1.5 h-3.5 w-3.5" />
            Preview JSON
          </TabsTrigger>
        </TabsList>

        {/* GENERAL TAB */}
        <TabsContent value="general" className="mt-6 space-y-4">
          <CollapsibleSection 
            id="app_settings" 
            title="App Settings" 
            description="Basic app information and environment"
          >
            <div className="grid gap-4 md:grid-cols-2 pt-4">
              <div className="space-y-2">
                <Label>App Name</Label>
                <Input
                  value={config.app_settings.app_name}
                  onChange={(e) => updateConfig('app_settings', 'app_name', e.target.value)}
                  placeholder="My Store App"
                />
              </div>
              <div className="space-y-2">
                <Label>Version</Label>
                <Input
                  value={config.app_settings.app_version}
                  onChange={(e) => updateConfig('app_settings', 'app_version', e.target.value)}
                  placeholder="1.0.0"
                />
              </div>
              <div className="space-y-2">
                <Label>Build Number</Label>
                <Input
                  value={config.app_settings.build_number}
                  onChange={(e) => updateConfig('app_settings', 'build_number', e.target.value)}
                  placeholder="1"
                />
              </div>
              <div className="space-y-2">
                <Label>Environment</Label>
                <select 
                  className="w-full h-10 px-3 rounded-md border border-input bg-background"
                  value={config.app_settings.environment}
                  onChange={(e) => updateConfig('app_settings', 'environment', e.target.value)}
                >
                  <option value="development">Development</option>
                  <option value="staging">Staging</option>
                  <option value="production">Production</option>
                </select>
              </div>
            </div>
            <div className="grid gap-3 mt-4">
              <ToggleItem
                label="Debug Mode"
                description="Enable debug logging and tools"
                checked={config.app_settings.debug_mode}
                onChange={(v) => updateConfig('app_settings', 'debug_mode', v)}
              />
              <ToggleItem
                label="Maintenance Mode"
                description="Show maintenance screen to users"
                checked={config.app_settings.maintenance_mode}
                onChange={(v) => updateConfig('app_settings', 'maintenance_mode', v)}
              />
            </div>
          </CollapsibleSection>

          <CollapsibleSection 
            id="api_configuration" 
            title="API Configuration" 
            description="API settings, timeouts, and logging"
          >
            <div className="grid gap-4 md:grid-cols-2 pt-4">
              <div className="space-y-2 md:col-span-2">
                <Label>Base URL</Label>
                <Input
                  value={config.api_configuration.base_url}
                  onChange={(e) => updateConfig('api_configuration', 'base_url', e.target.value)}
                  placeholder="https://api.example.com"
                />
              </div>
              <div className="space-y-2">
                <Label>Timeout (seconds)</Label>
                <Input
                  type="number"
                  value={config.api_configuration.timeout_seconds}
                  onChange={(e) => updateConfig('api_configuration', 'timeout_seconds', parseInt(e.target.value))}
                />
              </div>
              <div className="space-y-2">
                <Label>Retry Count</Label>
                <Input
                  type="number"
                  value={config.api_configuration.retry_count}
                  onChange={(e) => updateConfig('api_configuration', 'retry_count', parseInt(e.target.value))}
                />
              </div>
            </div>
            <div className="mt-4">
              <ToggleItem
                label="Enable Logging"
                description="Log API requests and responses"
                checked={config.api_configuration.enable_logging}
                onChange={(v) => updateConfig('api_configuration', 'enable_logging', v)}
              />
            </div>
          </CollapsibleSection>

          <CollapsibleSection 
            id="woocommerce_configuration" 
            title="WooCommerce Configuration" 
            description="Store URL and WooCommerce settings"
          >
            <div className="grid gap-4 md:grid-cols-2 pt-4">
              <div className="space-y-2 md:col-span-2">
                <Label>Store URL</Label>
                <Input
                  value={config.woocommerce_configuration.store_url}
                  onChange={(e) => updateConfig('woocommerce_configuration', 'store_url', e.target.value)}
                  placeholder="https://mystore.com"
                />
              </div>
              <div className="space-y-2">
                <Label>Brand Name</Label>
                <Input
                  value={config.woocommerce_configuration.brand_name}
                  onChange={(e) => updateConfig('woocommerce_configuration', 'brand_name', e.target.value)}
                  placeholder="My Brand"
                />
              </div>
              <div className="space-y-2">
                <Label>Products Per Page</Label>
                <Input
                  type="number"
                  value={config.woocommerce_configuration.products_per_page}
                  onChange={(e) => updateConfig('woocommerce_configuration', 'products_per_page', parseInt(e.target.value))}
                />
              </div>
            </div>
            <div className="grid gap-3 mt-4">
              <ToggleItem
                label="Enable Reviews"
                description="Show product reviews in the app"
                checked={config.woocommerce_configuration.enable_reviews}
                onChange={(v) => updateConfig('woocommerce_configuration', 'enable_reviews', v)}
              />
              <ToggleItem
                label="Enable Coupons"
                description="Allow customers to use discount coupons"
                checked={config.woocommerce_configuration.enable_coupons}
                onChange={(v) => updateConfig('woocommerce_configuration', 'enable_coupons', v)}
              />
              <ToggleItem
                label="Guest Checkout"
                description="Allow checkout without account"
                checked={config.woocommerce_configuration.enable_guest_checkout}
                onChange={(v) => updateConfig('woocommerce_configuration', 'enable_guest_checkout', v)}
              />
              <ToggleItem
                label="Verify SSL"
                description="Validate SSL certificates"
                checked={config.woocommerce_configuration.verify_ssl}
                onChange={(v) => updateConfig('woocommerce_configuration', 'verify_ssl', v)}
              />
            </div>
          </CollapsibleSection>

          <CollapsibleSection 
            id="localization" 
            title="Localization" 
            description="Language and regional settings"
          >
            <div className="grid gap-4 md:grid-cols-2 pt-4">
              <div className="space-y-2">
                <Label>Default Language</Label>
                <select 
                  className="w-full h-10 px-3 rounded-md border border-input bg-background"
                  value={config.localization_configuration.default_language}
                  onChange={(e) => updateConfig('localization_configuration', 'default_language', e.target.value)}
                >
                  <option value="en">English</option>
                  <option value="tr">Turkish</option>
                  <option value="de">German</option>
                  <option value="fr">French</option>
                  <option value="es">Spanish</option>
                </select>
              </div>
              <div className="space-y-2">
                <Label>Supported Languages</Label>
                <Input
                  value={config.localization_configuration.supported_languages.join(', ')}
                  onChange={(e) => updateConfig('localization_configuration', 'supported_languages', e.target.value.split(',').map(s => s.trim()))}
                  placeholder="en, tr, de, fr"
                />
              </div>
            </div>
            <div className="grid gap-3 mt-4">
              <ToggleItem
                label="RTL Support"
                description="Enable right-to-left text direction"
                checked={config.localization_configuration.rtl_support}
                onChange={(v) => updateConfig('localization_configuration', 'rtl_support', v)}
              />
              <ToggleItem
                label="Auto-detect Language"
                description="Detect language from device settings"
                checked={config.localization_configuration.auto_detect_language}
                onChange={(v) => updateConfig('localization_configuration', 'auto_detect_language', v)}
              />
            </div>
          </CollapsibleSection>
        </TabsContent>

        {/* THEME TAB */}
        <TabsContent value="theme" className="mt-6 space-y-4">
          <Card>
            <CardHeader>
              <CardTitle>UI Configuration</CardTitle>
              <CardDescription>Colors and appearance settings</CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
                <ColorPicker
                  label="Primary Color"
                  value={config.ui_configuration.primary_color}
                  onChange={(v) => updateConfig('ui_configuration', 'primary_color', v)}
                />
                <ColorPicker
                  label="Accent Color"
                  value={config.ui_configuration.accent_color}
                  onChange={(v) => updateConfig('ui_configuration', 'accent_color', v)}
                />
                <ColorPicker
                  label="Search Bar Color"
                  value={config.ui_configuration.search_app_bar_color}
                  onChange={(v) => updateConfig('ui_configuration', 'search_app_bar_color', v)}
                />
              </div>

              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label>Theme Mode</Label>
                  <select 
                    className="w-full h-10 px-3 rounded-md border border-input bg-background"
                    value={config.ui_configuration.theme_mode}
                    onChange={(e) => updateConfig('ui_configuration', 'theme_mode', e.target.value)}
                  >
                    <option value="light">Light</option>
                    <option value="dark">Dark</option>
                    <option value="system">System</option>
                  </select>
                </div>
                <div className="space-y-2">
                  <Label>Font Scale</Label>
                  <Input
                    type="number"
                    step="0.1"
                    min="0.5"
                    max="2"
                    value={config.ui_configuration.font_scale}
                    onChange={(e) => updateConfig('ui_configuration', 'font_scale', parseFloat(e.target.value))}
                  />
                </div>
              </div>

              <div className="grid gap-3">
                <ToggleItem
                  label="Haptic Feedback"
                  description="Vibration feedback on interactions"
                  checked={config.ui_configuration.enable_haptic_feedback}
                  onChange={(v) => updateConfig('ui_configuration', 'enable_haptic_feedback', v)}
                />
                <ToggleItem
                  label="Sound Effects"
                  description="Play sounds on certain actions"
                  checked={config.ui_configuration.enable_sound_effects}
                  onChange={(v) => updateConfig('ui_configuration', 'enable_sound_effects', v)}
                />
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* FEATURES TAB */}
        <TabsContent value="features" className="mt-6 space-y-4">
          <Card>
            <CardHeader>
              <CardTitle>Feature Flags</CardTitle>
              <CardDescription>Enable or disable app features</CardDescription>
            </CardHeader>
            <CardContent className="grid gap-3">
              <ToggleItem
                label="Onboarding"
                description="Show onboarding screens for new users"
                checked={config.feature_flags.onboarding_enabled}
                onChange={(v) => updateConfig('feature_flags', 'onboarding_enabled', v)}
              />
              <ToggleItem
                label="Dark Mode"
                description="Allow users to switch to dark theme"
                checked={config.feature_flags.dark_mode_available}
                onChange={(v) => updateConfig('feature_flags', 'dark_mode_available', v)}
              />
              <ToggleItem
                label="Offline Mode"
                description="Enable offline browsing capabilities"
                checked={config.feature_flags.offline_mode_enabled}
                onChange={(v) => updateConfig('feature_flags', 'offline_mode_enabled', v)}
              />
              <ToggleItem
                label="Beta Features"
                description="Enable experimental features"
                checked={config.feature_flags.beta_features_enabled}
                onChange={(v) => updateConfig('feature_flags', 'beta_features_enabled', v)}
              />
              <ToggleItem
                label="Analytics Opt-out"
                description="Allow users to opt out of analytics"
                checked={config.feature_flags.analytics_opt_out_available}
                onChange={(v) => updateConfig('feature_flags', 'analytics_opt_out_available', v)}
              />
              <ToggleItem
                label="WooCommerce Integration"
                description="Enable WooCommerce store connection"
                checked={config.feature_flags.woocommerce_integration_enabled}
                onChange={(v) => updateConfig('feature_flags', 'woocommerce_integration_enabled', v)}
              />
              <ToggleItem
                label="Payment Gateway"
                description="Enable in-app payments"
                checked={config.feature_flags.payment_gateway_enabled}
                onChange={(v) => updateConfig('feature_flags', 'payment_gateway_enabled', v)}
              />
              <ToggleItem
                label="Wishlist"
                description="Enable product wishlist feature"
                checked={config.feature_flags.wishlist_enabled}
                onChange={(v) => updateConfig('feature_flags', 'wishlist_enabled', v)}
              />
              <ToggleItem
                label="Cart Persistence"
                description="Save cart between sessions"
                checked={config.feature_flags.cart_persistence_enabled}
                onChange={(v) => updateConfig('feature_flags', 'cart_persistence_enabled', v)}
              />
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Firebase Configuration</CardTitle>
              <CardDescription>Firebase services and analytics</CardDescription>
            </CardHeader>
            <CardContent className="grid gap-3">
              <ToggleItem
                label="Analytics"
                description="Track user behavior with Firebase Analytics"
                checked={config.firebase_configuration.analytics_enabled}
                onChange={(v) => updateConfig('firebase_configuration', 'analytics_enabled', v)}
              />
              <ToggleItem
                label="Crashlytics"
                description="Automatic crash reporting"
                checked={config.firebase_configuration.crashlytics_enabled}
                onChange={(v) => updateConfig('firebase_configuration', 'crashlytics_enabled', v)}
              />
              <ToggleItem
                label="Performance Monitoring"
                description="Track app performance metrics"
                checked={config.firebase_configuration.performance_monitoring_enabled}
                onChange={(v) => updateConfig('firebase_configuration', 'performance_monitoring_enabled', v)}
              />
              <ToggleItem
                label="Remote Config"
                description="Enable remote configuration updates"
                checked={config.firebase_configuration.remote_config_enabled}
                onChange={(v) => updateConfig('firebase_configuration', 'remote_config_enabled', v)}
              />
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Notifications</CardTitle>
              <CardDescription>Push and local notification settings</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid gap-3">
                <ToggleItem
                  label="Push Notifications"
                  description="Receive push notifications"
                  checked={config.notification_configuration.push_notifications_enabled}
                  onChange={(v) => updateConfig('notification_configuration', 'push_notifications_enabled', v)}
                />
                <ToggleItem
                  label="Local Notifications"
                  description="Show local reminder notifications"
                  checked={config.notification_configuration.local_notifications_enabled}
                  onChange={(v) => updateConfig('notification_configuration', 'local_notifications_enabled', v)}
                />
                <ToggleItem
                  label="Vibration"
                  description="Vibrate on notifications"
                  checked={config.notification_configuration.vibration_enabled}
                  onChange={(v) => updateConfig('notification_configuration', 'vibration_enabled', v)}
                />
              </div>
              <div className="space-y-2">
                <Label>Notification Sound</Label>
                <select 
                  className="w-full h-10 px-3 rounded-md border border-input bg-background"
                  value={config.notification_configuration.notification_sound}
                  onChange={(e) => updateConfig('notification_configuration', 'notification_sound', e.target.value)}
                >
                  <option value="default">Default</option>
                  <option value="chime">Chime</option>
                  <option value="ding">Ding</option>
                  <option value="none">None</option>
                </select>
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* HOME TAB */}
        <TabsContent value="home" className="mt-6">
          <Card>
            <CardHeader>
              <CardTitle>Home Screen Components</CardTitle>
              <CardDescription>Enable/disable and order home screen sections</CardDescription>
            </CardHeader>
            <CardContent className="grid gap-3">
              <ToggleItem
                label="Search Bar"
                description="Show search bar at top"
                checked={config.home_view.search.enabled}
                onChange={(v) => setConfig(prev => ({
                  ...prev,
                  home_view: { ...prev.home_view, search: { ...prev.home_view.search, enabled: v } }
                }))}
              />
              <ToggleItem
                label="Circle Categories"
                description="Show category circles"
                checked={config.home_view.circle_categories.enabled}
                onChange={(v) => setConfig(prev => ({
                  ...prev,
                  home_view: { ...prev.home_view, circle_categories: { ...prev.home_view.circle_categories, enabled: v } }
                }))}
              />
              <ToggleItem
                label="Banner Carousel"
                description="Show promotional banner slider"
                checked={config.home_view.banner.enabled}
                onChange={(v) => setConfig(prev => ({
                  ...prev,
                  home_view: { ...prev.home_view, banner: { ...prev.home_view.banner, enabled: v } }
                }))}
              />
              <ToggleItem
                label="Promotional Bar"
                description="Show promotional announcements"
                checked={config.home_view.promotional_bar.enabled}
                onChange={(v) => setConfig(prev => ({
                  ...prev,
                  home_view: { ...prev.home_view, promotional_bar: { ...prev.home_view.promotional_bar, enabled: v } }
                }))}
              />
              <ToggleItem
                label="Campaign Cards"
                description="Show campaign/collection cards"
                checked={config.home_view.campaign_cards.enabled}
                onChange={(v) => setConfig(prev => ({
                  ...prev,
                  home_view: { ...prev.home_view, campaign_cards: { ...prev.home_view.campaign_cards, enabled: v } }
                }))}
              />
              <ToggleItem
                label="Campaign Alert"
                description="Show time-limited campaign alert"
                checked={config.home_view.campaign_alert.enabled}
                onChange={(v) => setConfig(prev => ({
                  ...prev,
                  home_view: { ...prev.home_view, campaign_alert: { ...prev.home_view.campaign_alert, enabled: v } }
                }))}
              />
              <ToggleItem
                label="Brands Section"
                description="Show brand logos grid"
                checked={config.home_view.brands.enabled}
                onChange={(v) => setConfig(prev => ({
                  ...prev,
                  home_view: { ...prev.home_view, brands: { ...prev.home_view.brands, enabled: v } }
                }))}
              />
              <ToggleItem
                label="Deals of the Day"
                description="Show daily deals products"
                checked={config.home_view.deals_of_day.enabled}
                onChange={(v) => setConfig(prev => ({
                  ...prev,
                  home_view: { ...prev.home_view, deals_of_day: { ...prev.home_view.deals_of_day, enabled: v } }
                }))}
              />
              <ToggleItem
                label="Flash Sale"
                description="Show flash sale countdown"
                checked={config.home_view.flash_sale.enabled}
                onChange={(v) => setConfig(prev => ({
                  ...prev,
                  home_view: { ...prev.home_view, flash_sale: { ...prev.home_view.flash_sale, enabled: v } }
                }))}
              />
              <ToggleItem
                label="Recommended Products"
                description="Show personalized recommendations"
                checked={config.home_view.recommended.enabled}
                onChange={(v) => setConfig(prev => ({
                  ...prev,
                  home_view: { ...prev.home_view, recommended: { ...prev.home_view.recommended, enabled: v } }
                }))}
              />
            </CardContent>
          </Card>
        </TabsContent>

        {/* NAVIGATION TAB */}
        <TabsContent value="navigation" className="mt-6">
          <Card>
            <CardHeader>
              <CardTitle>Bottom Navigation Bar</CardTitle>
              <CardDescription>Configure bottom navigation items</CardDescription>
            </CardHeader>
            <CardContent>
              <ToggleItem
                label="Enable Navigation Bar"
                description="Show bottom navigation in the app"
                checked={config.navbar_configuration.enabled}
                onChange={(v) => updateConfig('navbar_configuration', 'enabled', v)}
              />
              
              <div className="mt-6 space-y-3">
                <Label>Navigation Items</Label>
                {config.navbar_configuration.items.map((item, index) => (
                  <div key={item.id} className="flex items-center gap-3 p-3 bg-muted/50 rounded-lg">
                    <span className="text-sm font-medium w-8 text-center">{index + 1}</span>
                    <Input
                      value={item.text}
                      onChange={(e) => {
                        const newItems = [...config.navbar_configuration.items];
                        newItems[index] = { ...newItems[index], text: e.target.value };
                        setConfig(prev => ({
                          ...prev,
                          navbar_configuration: { ...prev.navbar_configuration, items: newItems }
                        }));
                      }}
                      className="flex-1"
                      placeholder="Label"
                    />
                    <Input
                      value={item.route}
                      onChange={(e) => {
                        const newItems = [...config.navbar_configuration.items];
                        newItems[index] = { ...newItems[index], route: e.target.value };
                        setConfig(prev => ({
                          ...prev,
                          navbar_configuration: { ...prev.navbar_configuration, items: newItems }
                        }));
                      }}
                      className="w-32"
                      placeholder="/route"
                    />
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* SPLASH TAB */}
        <TabsContent value="splash" className="mt-6 space-y-4">
          <Card>
            <CardHeader>
              <CardTitle>Splash Screen</CardTitle>
              <CardDescription>Configure app launch screen</CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <ToggleItem
                label="Enable Splash Screen"
                description="Show splash screen on app launch"
                checked={config.splash_configuration.enabled}
                onChange={(v) => updateConfig('splash_configuration', 'enabled', v)}
              />

              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label>Style</Label>
                  <select 
                    className="w-full h-10 px-3 rounded-md border border-input bg-background"
                    value={config.splash_configuration.style}
                    onChange={(e) => updateConfig('splash_configuration', 'style', e.target.value)}
                  >
                    <option value="startup">Startup</option>
                    <option value="minimal">Minimal</option>
                    <option value="enterprise">Enterprise</option>
                  </select>
                </div>
                <div className="space-y-2">
                  <Label>Duration (ms)</Label>
                  <Input
                    type="number"
                    value={config.splash_configuration.duration_milliseconds}
                    onChange={(e) => updateConfig('splash_configuration', 'duration_milliseconds', parseInt(e.target.value))}
                  />
                </div>
              </div>

              <div className="space-y-2">
                <Label>Logo URL</Label>
                <Input
                  value={config.splash_configuration.logo_url}
                  onChange={(e) => updateConfig('splash_configuration', 'logo_url', e.target.value)}
                  placeholder="https://example.com/logo.png"
                />
              </div>

              <div className="grid gap-4 md:grid-cols-3">
                <ColorPicker
                  label="Background Color"
                  value={config.splash_configuration.background_color}
                  onChange={(v) => updateConfig('splash_configuration', 'background_color', v)}
                />
                <ColorPicker
                  label="Logo Color"
                  value={config.splash_configuration.logo_color}
                  onChange={(v) => updateConfig('splash_configuration', 'logo_color', v)}
                />
                <ColorPicker
                  label="Loading Indicator"
                  value={config.splash_configuration.loading_indicator_color}
                  onChange={(v) => updateConfig('splash_configuration', 'loading_indicator_color', v)}
                />
              </div>

              <div className="grid gap-3">
                <ToggleItem
                  label="Show Loading Indicator"
                  description="Display loading spinner"
                  checked={config.splash_configuration.show_loading_indicator}
                  onChange={(v) => updateConfig('splash_configuration', 'show_loading_indicator', v)}
                />
                <ToggleItem
                  label="Show Version Info"
                  description="Display app version on splash"
                  checked={config.splash_configuration.show_version_info}
                  onChange={(v) => updateConfig('splash_configuration', 'show_version_info', v)}
                />
                <ToggleItem
                  label="Show App Name"
                  description="Display app name on splash"
                  checked={config.splash_configuration.show_app_name}
                  onChange={(v) => updateConfig('splash_configuration', 'show_app_name', v)}
                />
                <ToggleItem
                  label="Fade Animation"
                  description="Enable fade transition"
                  checked={config.splash_configuration.fade_animation_enabled}
                  onChange={(v) => updateConfig('splash_configuration', 'fade_animation_enabled', v)}
                />
                <ToggleItem
                  label="Logo Animation"
                  description="Animate logo on splash"
                  checked={config.splash_configuration.enable_logo_animation}
                  onChange={(v) => updateConfig('splash_configuration', 'enable_logo_animation', v)}
                />
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* SECURITY TAB */}
        <TabsContent value="security" className="mt-6 space-y-4">
          <Card>
            <CardHeader>
              <CardTitle>Security Configuration</CardTitle>
              <CardDescription>SSL, authentication, and security settings</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid gap-3">
                <ToggleItem
                  label="SSL Pinning"
                  description="Enable SSL certificate pinning"
                  checked={config.security_configuration.enable_ssl_pinning}
                  onChange={(v) => updateConfig('security_configuration', 'enable_ssl_pinning', v)}
                />
                <ToggleItem
                  label="Certificate Validation"
                  description="Validate SSL certificates"
                  checked={config.security_configuration.certificate_validation}
                  onChange={(v) => updateConfig('security_configuration', 'certificate_validation', v)}
                />
                <ToggleItem
                  label="Biometric Authentication"
                  description="Allow fingerprint/face login"
                  checked={config.security_configuration.biometric_authentication}
                  onChange={(v) => updateConfig('security_configuration', 'biometric_authentication', v)}
                />
              </div>
              <div className="space-y-2">
                <Label>Session Timeout (minutes)</Label>
                <Input
                  type="number"
                  value={config.security_configuration.session_timeout_minutes}
                  onChange={(e) => updateConfig('security_configuration', 'session_timeout_minutes', parseInt(e.target.value))}
                />
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Storage Configuration</CardTitle>
              <CardDescription>Cache and data storage settings</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid gap-3">
                <ToggleItem
                  label="Enable Encryption"
                  description="Encrypt stored data"
                  checked={config.storage_configuration.enable_encryption}
                  onChange={(v) => updateConfig('storage_configuration', 'enable_encryption', v)}
                />
                <ToggleItem
                  label="Auto Cleanup"
                  description="Automatically clean old cache"
                  checked={config.storage_configuration.auto_cleanup_enabled}
                  onChange={(v) => updateConfig('storage_configuration', 'auto_cleanup_enabled', v)}
                />
                <ToggleItem
                  label="Backup Enabled"
                  description="Include data in device backups"
                  checked={config.storage_configuration.backup_enabled}
                  onChange={(v) => updateConfig('storage_configuration', 'backup_enabled', v)}
                />
              </div>
              <div className="space-y-2">
                <Label>Cache Size (MB)</Label>
                <Input
                  type="number"
                  value={config.storage_configuration.cache_size_mb}
                  onChange={(e) => updateConfig('storage_configuration', 'cache_size_mb', parseInt(e.target.value))}
                />
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Performance Configuration</CardTitle>
              <CardDescription>Image and network caching</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label>Image Cache (MB)</Label>
                  <Input
                    type="number"
                    value={config.performance_configuration.image_cache_size_mb}
                    onChange={(e) => updateConfig('performance_configuration', 'image_cache_size_mb', parseInt(e.target.value))}
                  />
                </div>
                <div className="space-y-2">
                  <Label>Network Cache (MB)</Label>
                  <Input
                    type="number"
                    value={config.performance_configuration.network_cache_size_mb}
                    onChange={(e) => updateConfig('performance_configuration', 'network_cache_size_mb', parseInt(e.target.value))}
                  />
                </div>
              </div>
              <div className="grid gap-3">
                <ToggleItem
                  label="Lazy Loading"
                  description="Load images on demand"
                  checked={config.performance_configuration.lazy_loading_enabled}
                  onChange={(v) => updateConfig('performance_configuration', 'lazy_loading_enabled', v)}
                />
                <ToggleItem
                  label="Preload Critical Assets"
                  description="Load essential assets on startup"
                  checked={config.performance_configuration.preload_critical_assets}
                  onChange={(v) => updateConfig('performance_configuration', 'preload_critical_assets', v)}
                />
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* PREVIEW JSON TAB */}
        <TabsContent value="preview" className="mt-6">
          <Card>
            <CardHeader>
              <div className="flex items-center justify-between">
                <div>
                  <CardTitle>JSON Preview</CardTitle>
                  <CardDescription>Real-time preview of your app configuration</CardDescription>
                </div>
                <Button variant="outline" size="sm" onClick={handleCopyJson}>
                  {copied ? (
                    <>
                      <Check className="mr-2 h-4 w-4" />
                      Copied!
                    </>
                  ) : (
                    <>
                      <Copy className="mr-2 h-4 w-4" />
                      Copy JSON
                    </>
                  )}
                </Button>
              </div>
            </CardHeader>
            <CardContent>
              <div className="relative group">
                <div className="absolute top-4 right-4 z-10 opacity-0 group-hover:opacity-100 transition-opacity">
                  <Button
                    variant="ghost"
                    size="sm"
                    className="h-7 text-xs bg-black/70 hover:bg-black/90 text-white backdrop-blur-sm"
                    onClick={() => {
                      const pre = document.querySelector('#json-preview pre');
                      if (pre) {
                        pre.scrollTop = 0;
                      }
                    }}
                  >
                    ↑ Scroll to Top
                  </Button>
                </div>
                <div id="json-preview" className="relative">
                  <pre className="bg-gray-950 dark:bg-gray-900 rounded-lg p-6 overflow-auto max-h-[70vh] border border-gray-800 shadow-inner">
                    <code className="text-sm text-gray-100 font-mono leading-relaxed whitespace-pre-wrap break-words">
                      {JSON.stringify(config, null, 2)}
                    </code>
                  </pre>
                </div>
              </div>
              <div className="mt-4 p-4 bg-blue-50 dark:bg-blue-950/30 rounded-lg border border-blue-200 dark:border-blue-900">
                <div className="flex items-start gap-3">
                  <Eye className="h-5 w-5 text-blue-600 dark:text-blue-400 flex-shrink-0 mt-0.5" />
                  <div className="flex-1">
                    <p className="text-sm font-medium text-blue-900 dark:text-blue-100 mb-1">
                      JSON Preview Tips
                    </p>
                    <ul className="text-xs text-blue-800 dark:text-blue-200 space-y-1 list-disc list-inside">
                      <li>This preview updates in real-time as you change settings</li>
                      <li>Use "Copy JSON" to copy the entire configuration</li>
                      <li>Export to save as app_config.json file</li>
                      <li>The JSON matches the structure expected by your Flutter app</li>
                    </ul>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </PageContainer>
  );
}
