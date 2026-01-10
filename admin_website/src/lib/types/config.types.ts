export interface AppConfiguration {
  id: string;
  store_id: string;
  config_key: string;
  config_value: Record<string, unknown>;
  environment: 'development' | 'staging' | 'production';
  version: number;
  description?: string;
  is_active: boolean;
  is_published: boolean;
  published_at?: string;
  created_at: string;
  updated_at: string;
  created_by?: string;
  updated_by?: string;
}

export interface Store {
  id: string;
  name: string;
  woo_store_url: string;
  woo_consumer_key_encrypted: string;
  woo_consumer_secret_encrypted: string;
  supabase_url?: string;
  supabase_anon_key_encrypted?: string;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface SyncQueueItem {
  id: string;
  store_id: string;
  entity_type: string;
  entity_id?: string;
  operation: 'create' | 'update' | 'delete' | 'sync';
  payload: Record<string, unknown>;
  status: 'pending' | 'processing' | 'completed' | 'failed';
  priority: number;
  retry_count: number;
  max_retries: number;
  error_message?: string;
  created_at: string;
  updated_at: string;
  synced_at?: string;
}

export interface ConfigurationInput {
  config_key: string;
  config_value: Record<string, unknown>;
  environment: AppConfiguration['environment'];
  description?: string;
}

export interface StoreInput {
  name: string;
  woo_store_url: string;
  woo_consumer_key: string;
  woo_consumer_secret: string;
  supabase_url?: string;
  supabase_anon_key?: string;
}

// App config structure
export interface AppConfigValue {
  app_name: string;
  package_name: string;
  bundle_id: string;
  version: string;
  build_number: string;
  theme: {
    primary_color: string;
    secondary_color: string;
    accent_color: string;
    background_color: string;
    surface_color: string;
    text_color: string;
    dark_mode: boolean;
  };
  assets: {
    app_icon?: string;
    splash_screen?: string;
    logo?: string;
  };
  features: {
    push_notifications: boolean;
    analytics: boolean;
    crash_reporting: boolean;
    offline_mode: boolean;
    dark_mode_toggle: boolean;
  };
  store: {
    url: string;
    currency: string;
    language: string;
  };
}
