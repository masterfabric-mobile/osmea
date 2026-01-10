import { supabase } from '@/lib/supabase/client';
import type { AppConfiguration, Store, SyncQueueItem, ConfigurationInput, StoreInput } from '@/lib/types/config.types';
import type { Build, BuildLog, BuildTriggerInput, BuildStatistics } from '@/lib/types/build.types';

export class SupabaseService {
  // Store Management
  async getStore(storeId: string): Promise<Store | null> {
    if (!supabase) throw new Error('Supabase client not initialized');
    
    const { data, error } = await supabase
      .from('stores')
      .select('*')
      .eq('id', storeId)
      .single();

    if (error) {
      console.error('Error fetching store:', error);
      return null;
    }
    
    return data;
  }

  async createStore(input: StoreInput): Promise<Store> {
    if (!supabase) throw new Error('Supabase client not initialized');
    
    const { data, error } = await supabase
      .from('stores')
      .insert({
        name: input.name,
        woo_store_url: input.woo_store_url,
        woo_consumer_key_encrypted: input.woo_consumer_key, // Should be encrypted
        woo_consumer_secret_encrypted: input.woo_consumer_secret, // Should be encrypted
        supabase_url: input.supabase_url,
        supabase_anon_key_encrypted: input.supabase_anon_key,
        is_active: true,
      })
      .select()
      .single();

    if (error) throw error;
    return data;
  }

  async updateStore(storeId: string, updates: Partial<StoreInput>): Promise<Store> {
    if (!supabase) throw new Error('Supabase client not initialized');
    
    const { data, error } = await supabase
      .from('stores')
      .update({
        ...updates,
        updated_at: new Date().toISOString(),
      })
      .eq('id', storeId)
      .select()
      .single();

    if (error) throw error;
    return data;
  }

  // Configuration Management
  async getConfigurations(storeId: string): Promise<AppConfiguration[]> {
    if (!supabase) throw new Error('Supabase client not initialized');
    
    const { data, error } = await supabase
      .from('app_configurations')
      .select('*')
      .eq('store_id', storeId)
      .eq('is_active', true)
      .order('version', { ascending: false });

    if (error) throw error;
    return data || [];
  }

  async getConfiguration(id: string): Promise<AppConfiguration | null> {
    if (!supabase) throw new Error('Supabase client not initialized');
    
    const { data, error } = await supabase
      .from('app_configurations')
      .select('*')
      .eq('id', id)
      .single();

    if (error) {
      console.error('Error fetching configuration:', error);
      return null;
    }
    
    return data;
  }

  async getActiveConfiguration(
    storeId: string,
    configKey: string,
    environment: string = 'production'
  ): Promise<AppConfiguration | null> {
    if (!supabase) throw new Error('Supabase client not initialized');
    
    const { data, error } = await supabase
      .from('app_configurations')
      .select('*')
      .eq('store_id', storeId)
      .eq('config_key', configKey)
      .eq('environment', environment)
      .eq('is_active', true)
      .eq('is_published', true)
      .order('version', { ascending: false })
      .limit(1)
      .single();

    if (error) {
      console.error('Error fetching active configuration:', error);
      return null;
    }
    
    return data;
  }

  async createConfiguration(storeId: string, input: ConfigurationInput): Promise<AppConfiguration> {
    if (!supabase) throw new Error('Supabase client not initialized');
    
    const { data, error } = await supabase
      .from('app_configurations')
      .insert({
        store_id: storeId,
        config_key: input.config_key,
        config_value: input.config_value,
        environment: input.environment,
        description: input.description,
        version: 1,
        is_active: true,
        is_published: false,
      })
      .select()
      .single();

    if (error) throw error;
    return data;
  }

  async updateConfiguration(id: string, configValue: Record<string, unknown>): Promise<AppConfiguration> {
    if (!supabase) throw new Error('Supabase client not initialized');
    
    const { data, error } = await supabase
      .from('app_configurations')
      .update({
        config_value: configValue,
        updated_at: new Date().toISOString(),
      })
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;
    return data;
  }

  async publishConfiguration(id: string): Promise<AppConfiguration> {
    if (!supabase) throw new Error('Supabase client not initialized');
    
    const { data, error } = await supabase
      .from('app_configurations')
      .update({
        is_published: true,
        published_at: new Date().toISOString(),
      })
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;
    return data;
  }

  // Build Management
  async getBuilds(storeId: string, limit: number = 20): Promise<Build[]> {
    if (!supabase) throw new Error('Supabase client not initialized');
    
    const { data, error } = await supabase
      .from('builds')
      .select('*')
      .eq('store_id', storeId)
      .order('created_at', { ascending: false })
      .limit(limit);

    if (error) throw error;
    return data || [];
  }

  async getBuild(buildId: string): Promise<Build | null> {
    if (!supabase) throw new Error('Supabase client not initialized');
    
    const { data, error } = await supabase
      .from('builds')
      .select('*')
      .eq('id', buildId)
      .single();

    if (error) {
      console.error('Error fetching build:', error);
      return null;
    }
    
    return data;
  }

  async createBuild(storeId: string, input: BuildTriggerInput): Promise<Build> {
    if (!supabase) throw new Error('Supabase client not initialized');
    
    const { data, error } = await supabase
      .from('builds')
      .insert({
        store_id: storeId,
        platform: input.platform,
        build_type: input.build_type,
        artifact_type: input.artifact_type,
        environment: input.environment,
        version: input.version || '1.0.0',
        build_number: input.build_number || Date.now().toString(),
        branch: input.branch,
        status: 'pending',
      })
      .select()
      .single();

    if (error) throw error;
    return data;
  }

  async updateBuildStatus(
    buildId: string,
    status: Build['status'],
    additionalData?: Partial<Build>
  ): Promise<Build> {
    if (!supabase) throw new Error('Supabase client not initialized');
    
    const updateData: Partial<Build> = {
      status,
      updated_at: new Date().toISOString(),
      ...additionalData,
    };

    // Set timestamps based on status
    if (status === 'building' && !additionalData?.started_at) {
      updateData.started_at = new Date().toISOString();
    }
    if (['success', 'failed', 'cancelled'].includes(status) && !additionalData?.completed_at) {
      updateData.completed_at = new Date().toISOString();
    }

    const { data, error } = await supabase
      .from('builds')
      .update(updateData)
      .eq('id', buildId)
      .select()
      .single();

    if (error) throw error;
    return data;
  }

  async cancelBuild(buildId: string): Promise<Build> {
    return this.updateBuildStatus(buildId, 'cancelled');
  }

  // Build Logs
  async getBuildLogs(buildId: string): Promise<BuildLog[]> {
    if (!supabase) throw new Error('Supabase client not initialized');
    
    const { data, error } = await supabase
      .from('build_logs')
      .select('*')
      .eq('build_id', buildId)
      .order('timestamp', { ascending: true });

    if (error) throw error;
    return data || [];
  }

  async addBuildLog(data: {
    buildId: string;
    logLevel: BuildLog['log_level'];
    message: string;
    source?: string;
    step?: string;
  }): Promise<void> {
    if (!supabase) throw new Error('Supabase client not initialized');
    
    const { error } = await supabase
      .from('build_logs')
      .insert({
        build_id: data.buildId,
        log_level: data.logLevel,
        message: data.message,
        source: data.source,
        step: data.step,
        timestamp: new Date().toISOString(),
      });

    if (error) throw error;
  }

  // Sync Queue Management
  async getSyncQueue(storeId: string): Promise<SyncQueueItem[]> {
    if (!supabase) throw new Error('Supabase client not initialized');
    
    const { data, error } = await supabase
      .from('sync_queue')
      .select('*')
      .eq('store_id', storeId)
      .eq('status', 'pending')
      .order('priority', { ascending: false })
      .order('created_at', { ascending: true });

    if (error) throw error;
    return data || [];
  }

  async addToSyncQueue(data: {
    storeId: string;
    entityType: string;
    entityId?: string;
    operation: SyncQueueItem['operation'];
    payload: Record<string, unknown>;
    priority?: number;
  }): Promise<SyncQueueItem> {
    if (!supabase) throw new Error('Supabase client not initialized');
    
    const { data: result, error } = await supabase
      .from('sync_queue')
      .insert({
        store_id: data.storeId,
        entity_type: data.entityType,
        entity_id: data.entityId,
        operation: data.operation,
        payload: data.payload,
        priority: data.priority || 5,
        status: 'pending',
        retry_count: 0,
        max_retries: 3,
      })
      .select()
      .single();

    if (error) throw error;
    return result;
  }

  async updateSyncQueueItem(
    id: string,
    status: SyncQueueItem['status'],
    errorMessage?: string
  ): Promise<SyncQueueItem> {
    if (!supabase) throw new Error('Supabase client not initialized');
    
    const { data, error } = await supabase
      .from('sync_queue')
      .update({
        status,
        error_message: errorMessage,
        updated_at: new Date().toISOString(),
        synced_at: status === 'completed' ? new Date().toISOString() : null,
      })
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;
    return data;
  }

  // Real-time Subscriptions
  subscribeToBuildUpdates(buildId: string, callback: (payload: unknown) => void) {
    if (!supabase) throw new Error('Supabase client not initialized');
    
    return supabase
      .channel(`build:${buildId}`)
      .on(
        'postgres_changes',
        {
          event: 'UPDATE',
          schema: 'public',
          table: 'builds',
          filter: `id=eq.${buildId}`,
        },
        callback
      )
      .subscribe();
  }

  subscribeToBuildLogs(buildId: string, callback: (payload: unknown) => void) {
    if (!supabase) throw new Error('Supabase client not initialized');
    
    return supabase
      .channel(`build-logs:${buildId}`)
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'build_logs',
          filter: `build_id=eq.${buildId}`,
        },
        callback
      )
      .subscribe();
  }

  // Statistics
  async getBuildStatistics(storeId: string): Promise<BuildStatistics> {
    const builds = await this.getBuilds(storeId, 100);
    
    const stats: BuildStatistics = {
      total_builds: builds.length,
      successful_builds: builds.filter(b => b.status === 'success').length,
      failed_builds: builds.filter(b => b.status === 'failed').length,
      average_build_time: 0,
      builds_by_platform: {
        ios: builds.filter(b => b.platform === 'ios').length,
        android: builds.filter(b => b.platform === 'android').length,
      },
      builds_by_status: {
        pending: builds.filter(b => b.status === 'pending').length,
        queued: builds.filter(b => b.status === 'queued').length,
        building: builds.filter(b => b.status === 'building').length,
        success: builds.filter(b => b.status === 'success').length,
        failed: builds.filter(b => b.status === 'failed').length,
        cancelled: builds.filter(b => b.status === 'cancelled').length,
      },
      recent_builds: builds.slice(0, 5),
    };

    // Calculate average build time
    const completedBuilds = builds.filter(b => b.build_duration && b.build_duration > 0);
    if (completedBuilds.length > 0) {
      const totalTime = completedBuilds.reduce((sum, b) => sum + (b.build_duration || 0), 0);
      stats.average_build_time = Math.round(totalTime / completedBuilds.length);
    }

    return stats;
  }
}

// Singleton instance
export const supabaseService = new SupabaseService();
