import { supabaseService } from './supabase.service';
import type { Build, BuildTriggerInput } from '@/lib/types/build.types';

export interface BuildOptions {
  platform: 'ios' | 'android';
  buildType: 'debug' | 'release' | 'adhoc';
  artifactType?: 'ipa' | 'apk' | 'aab';
  environment: 'development' | 'staging' | 'production';
  storeId: string;
  version?: string;
  buildNumber?: string;
}

export class BuildService {
  private flutterProjectPath: string;

  constructor(flutterProjectPath?: string) {
    this.flutterProjectPath = flutterProjectPath || process.env.FLUTTER_PROJECT_PATH || '';
  }

  async triggerBuild(options: BuildOptions): Promise<Build> {
    const input: BuildTriggerInput = {
      platform: options.platform,
      build_type: options.buildType,
      artifact_type: options.artifactType,
      environment: options.environment,
      version: options.version,
      build_number: options.buildNumber,
    };

    // Create build record
    const build = await supabaseService.createBuild(options.storeId, input);

    // Add initial log
    await this.addLog(build.id, 'info', 'Build triggered', 'init');

    // In production, you would queue the build here
    // For now, we just return the build record

    return build;
  }

  async updateStatus(
    buildId: string,
    status: Build['status'],
    additionalData?: Partial<Build>
  ): Promise<Build> {
    return supabaseService.updateBuildStatus(buildId, status, additionalData);
  }

  async cancelBuild(buildId: string): Promise<Build> {
    await this.addLog(buildId, 'warning', 'Build cancelled by user', 'cancel');
    return supabaseService.cancelBuild(buildId);
  }

  async getBuild(buildId: string): Promise<Build | null> {
    return supabaseService.getBuild(buildId);
  }

  async getBuilds(storeId: string, limit?: number): Promise<Build[]> {
    return supabaseService.getBuilds(storeId, limit);
  }

  async getLogs(buildId: string) {
    return supabaseService.getBuildLogs(buildId);
  }

  async addLog(
    buildId: string,
    level: 'debug' | 'info' | 'warning' | 'error' | 'critical',
    message: string,
    step?: string,
    source?: string
  ): Promise<void> {
    return supabaseService.addBuildLog({
      buildId,
      logLevel: level,
      message,
      step,
      source: source || 'build_service',
    });
  }

  // Simulate build execution (for demo purposes)
  async simulateBuild(buildId: string): Promise<void> {
    const steps = [
      { message: 'Preparing build environment...', step: 'prepare' },
      { message: 'Fetching dependencies...', step: 'dependencies' },
      { message: 'Compiling source code...', step: 'compile' },
      { message: 'Running tests...', step: 'test' },
      { message: 'Generating artifacts...', step: 'artifacts' },
      { message: 'Build completed successfully!', step: 'complete' },
    ];

    await this.updateStatus(buildId, 'building', {
      started_at: new Date().toISOString(),
    });

    for (const step of steps) {
      await new Promise((resolve) => setTimeout(resolve, 2000)); // 2s delay per step
      await this.addLog(buildId, 'info', step.message, step.step);
    }

    await this.updateStatus(buildId, 'success', {
      completed_at: new Date().toISOString(),
      build_duration: steps.length * 2, // Simulated duration
    });
  }

  // Get build statistics
  async getStatistics(storeId: string) {
    return supabaseService.getBuildStatistics(storeId);
  }
}

// Singleton instance
let buildService: BuildService | null = null;

export function getBuildService(): BuildService {
  if (!buildService) {
    buildService = new BuildService();
  }
  return buildService;
}

export function createBuildService(flutterProjectPath?: string): BuildService {
  return new BuildService(flutterProjectPath);
}
