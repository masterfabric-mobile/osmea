export type BuildPlatform = 'ios' | 'android';
export type BuildStatus = 'pending' | 'queued' | 'building' | 'success' | 'failed' | 'cancelled';
export type BuildType = 'debug' | 'release' | 'adhoc';
export type ArtifactType = 'ipa' | 'apk' | 'aab';

export interface Build {
  id: string;
  store_id: string;
  platform: BuildPlatform;
  build_type: BuildType;
  artifact_type?: ArtifactType;
  environment: 'development' | 'staging' | 'production';
  status: BuildStatus;
  version: string;
  build_number: string;
  commit_hash?: string;
  branch?: string;
  triggered_by?: string;
  started_at?: string;
  completed_at?: string;
  build_duration?: number; // in seconds
  artifact_url?: string;
  artifact_size?: number; // in bytes
  artifact_md5?: string;
  error_message?: string;
  logs_url?: string;
  metadata?: Record<string, unknown>;
  created_at: string;
  updated_at: string;
}

export interface BuildLog {
  id: string;
  build_id: string;
  log_level: 'debug' | 'info' | 'warning' | 'error' | 'critical';
  message: string;
  source?: string;
  step?: string;
  timestamp: string;
  metadata?: Record<string, unknown>;
}

export interface BuildTriggerInput {
  platform: BuildPlatform;
  build_type: BuildType;
  artifact_type?: ArtifactType;
  environment: Build['environment'];
  version?: string;
  build_number?: string;
  branch?: string;
}

export interface BuildStatistics {
  total_builds: number;
  successful_builds: number;
  failed_builds: number;
  average_build_time: number;
  builds_by_platform: {
    ios: number;
    android: number;
  };
  builds_by_status: Record<BuildStatus, number>;
  recent_builds: Build[];
}

export interface BuildQueueItem {
  id: string;
  build_id: string;
  priority: number;
  position: number;
  estimated_start_time?: string;
  created_at: string;
}
