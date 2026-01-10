import { offlineDb, syncOfflineData, OfflineProject, OfflineBuild } from './db';
import { supabase } from '@/lib/supabase/client';

export interface SyncStatus {
  isOnline: boolean;
  isSyncing: boolean;
  pendingCount: number;
  lastSyncedAt: Date | null;
  error: string | null;
}

class SyncManager {
  private status: SyncStatus = {
    isOnline: typeof navigator !== 'undefined' ? navigator.onLine : true,
    isSyncing: false,
    pendingCount: 0,
    lastSyncedAt: null,
    error: null,
  };
  private listeners: Set<(status: SyncStatus) => void> = new Set();
  private syncInterval: NodeJS.Timeout | null = null;

  constructor() {
    if (typeof window !== 'undefined') {
      window.addEventListener('online', this.handleOnline);
      window.addEventListener('offline', this.handleOffline);
      
      // Start periodic sync check
      this.startPeriodicSync();
    }
  }

  private handleOnline = () => {
    this.updateStatus({ isOnline: true });
    this.sync();
  };

  private handleOffline = () => {
    this.updateStatus({ isOnline: false });
  };

  private updateStatus(updates: Partial<SyncStatus>) {
    this.status = { ...this.status, ...updates };
    this.notifyListeners();
  }

  private notifyListeners() {
    this.listeners.forEach((listener) => listener(this.status));
  }

  subscribe(listener: (status: SyncStatus) => void): () => void {
    this.listeners.add(listener);
    // Immediately call with current status
    listener(this.status);
    // Return unsubscribe function
    return () => this.listeners.delete(listener);
  }

  getStatus(): SyncStatus {
    return { ...this.status };
  }

  async getPendingCount(): Promise<number> {
    const { unsyncedProjects, unsyncedBuilds } = await syncOfflineData();
    return unsyncedProjects.length + unsyncedBuilds.length;
  }

  async sync(): Promise<void> {
    if (!this.status.isOnline || this.status.isSyncing) {
      return;
    }

    this.updateStatus({ isSyncing: true, error: null });

    try {
      const { unsyncedProjects, unsyncedBuilds } = await syncOfflineData();
      
      // Sync projects
      for (const project of unsyncedProjects) {
        try {
          await this.syncProject(project);
          await offlineDb.projects.update(project.id, { synced: true });
        } catch (error) {
          console.error('Failed to sync project:', project.id, error);
        }
      }

      // Sync builds
      for (const build of unsyncedBuilds) {
        try {
          await this.syncBuild(build);
          await offlineDb.builds.update(build.id, { synced: true });
        } catch (error) {
          console.error('Failed to sync build:', build.id, error);
        }
      }

      const pendingCount = await this.getPendingCount();
      this.updateStatus({
        isSyncing: false,
        pendingCount,
        lastSyncedAt: new Date(),
      });

      // Request background sync if supported
      if ('serviceWorker' in navigator && 'SyncManager' in window) {
        const registration = await navigator.serviceWorker.ready;
        try {
          // Background Sync API - cast to any for TypeScript
          await (registration as unknown as { sync: { register: (tag: string) => Promise<void> } }).sync.register('sync-data');
        } catch (error) {
          console.log('Background sync not available:', error);
        }
      }
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : 'Sync failed';
      this.updateStatus({
        isSyncing: false,
        error: errorMessage,
      });
    }
  }

  private async syncProject(project: OfflineProject): Promise<void> {
    if (!supabase) return;
    
    // Implementation would sync to Supabase
    // await supabase.from('projects').upsert(project);
    console.log('Syncing project:', project.id);
  }

  private async syncBuild(build: OfflineBuild): Promise<void> {
    if (!supabase) return;
    
    // Implementation would sync to Supabase
    // await supabase.from('builds').upsert(build);
    console.log('Syncing build:', build.id);
  }

  startPeriodicSync(intervalMs: number = 30000): void {
    if (this.syncInterval) {
      clearInterval(this.syncInterval);
    }
    
    this.syncInterval = setInterval(() => {
      if (this.status.isOnline) {
        this.sync();
      }
    }, intervalMs);
  }

  stopPeriodicSync(): void {
    if (this.syncInterval) {
      clearInterval(this.syncInterval);
      this.syncInterval = null;
    }
  }

  // Add item to offline queue
  async queueAction(
    entityType: 'project' | 'build' | 'config',
    action: 'create' | 'update' | 'delete',
    data: Record<string, unknown>
  ): Promise<void> {
    // Store in IndexedDB for later sync
    const queueItem = {
      id: crypto.randomUUID(),
      entityType,
      action,
      data,
      createdAt: new Date(),
      synced: false,
    };

    // For now, just log - would add to IndexedDB queue
    console.log('Queued offline action:', queueItem);
    
    const pendingCount = await this.getPendingCount();
    this.updateStatus({ pendingCount: pendingCount + 1 });
  }

  destroy(): void {
    if (typeof window !== 'undefined') {
      window.removeEventListener('online', this.handleOnline);
      window.removeEventListener('offline', this.handleOffline);
    }
    this.stopPeriodicSync();
    this.listeners.clear();
  }
}

// Singleton instance
export const syncManager = new SyncManager();

// React hook for sync status
export function useSyncStatus(): SyncStatus {
  // This would be implemented with useState and useEffect
  // to subscribe to the syncManager
  return syncManager.getStatus();
}
