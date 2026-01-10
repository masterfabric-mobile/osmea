import Dexie, { Table } from 'dexie';

export interface OfflineProject {
  id: string;
  name: string;
  woo_store_url: string;
  app_config: any;
  updated_at: Date;
  synced: boolean;
}

export interface OfflineBuild {
  id: string;
  project_id: string;
  platform: 'ios' | 'android';
  status: string;
  logs: string;
  created_at: Date;
  synced: boolean;
}

export class OfflineDatabase extends Dexie {
  projects!: Table<OfflineProject, string>;
  builds!: Table<OfflineBuild, string>;

  constructor() {
    super('osmea-admin-offline');
    
    this.version(1).stores({
      projects: 'id, name, updated_at, synced',
      builds: 'id, project_id, platform, status, created_at, synced',
    });
  }
}

export const offlineDb = new OfflineDatabase();

export async function syncOfflineData() {
  const unsyncedProjects = await offlineDb.projects
    .filter((project) => !project.synced)
    .toArray();
  
  const unsyncedBuilds = await offlineDb.builds
    .filter((build) => !build.synced)
    .toArray();

  return { unsyncedProjects, unsyncedBuilds };
}
