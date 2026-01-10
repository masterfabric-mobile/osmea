'use server';

import { revalidatePath } from 'next/cache';
import { supabaseService } from '@/lib/services/supabase.service';
import type { BuildTriggerInput } from '@/lib/types/build.types';

export async function getBuilds(storeId: string, limit: number = 20) {
  try {
    const builds = await supabaseService.getBuilds(storeId, limit);
    return { success: true, data: builds };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch builds';
    return { success: false, error: errorMessage };
  }
}

export async function getBuild(buildId: string) {
  try {
    const build = await supabaseService.getBuild(buildId);
    if (!build) {
      return { success: false, error: 'Build not found' };
    }
    return { success: true, data: build };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch build';
    return { success: false, error: errorMessage };
  }
}

export async function triggerBuild(storeId: string, input: BuildTriggerInput) {
  try {
    // Create build record
    const build = await supabaseService.createBuild(storeId, input);
    
    // In a real implementation, you would:
    // 1. Add to build queue
    // 2. Notify build server
    // 3. Start background job
    
    // For now, just log the build initiation
    await supabaseService.addBuildLog({
      buildId: build.id,
      logLevel: 'info',
      message: `Build triggered for ${input.platform} (${input.build_type})`,
      step: 'init',
    });

    revalidatePath('/dashboard/builds');
    
    return { success: true, data: build };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to trigger build';
    return { success: false, error: errorMessage };
  }
}

export async function cancelBuild(buildId: string) {
  try {
    const build = await supabaseService.cancelBuild(buildId);
    
    await supabaseService.addBuildLog({
      buildId: build.id,
      logLevel: 'warning',
      message: 'Build cancelled by user',
      step: 'cancel',
    });

    revalidatePath('/dashboard/builds');
    revalidatePath(`/dashboard/builds/${buildId}`);
    
    return { success: true, data: build };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to cancel build';
    return { success: false, error: errorMessage };
  }
}

export async function getBuildLogs(buildId: string) {
  try {
    const logs = await supabaseService.getBuildLogs(buildId);
    return { success: true, data: logs };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch build logs';
    return { success: false, error: errorMessage };
  }
}

export async function getBuildStatistics(storeId: string) {
  try {
    const stats = await supabaseService.getBuildStatistics(storeId);
    return { success: true, data: stats };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch build statistics';
    return { success: false, error: errorMessage };
  }
}

export async function retryBuild(buildId: string) {
  try {
    const originalBuild = await supabaseService.getBuild(buildId);
    if (!originalBuild) {
      return { success: false, error: 'Original build not found' };
    }

    // Create a new build with the same parameters
    const newBuild = await supabaseService.createBuild(originalBuild.store_id, {
      platform: originalBuild.platform,
      build_type: originalBuild.build_type,
      artifact_type: originalBuild.artifact_type,
      environment: originalBuild.environment,
      version: originalBuild.version,
      branch: originalBuild.branch,
    });

    await supabaseService.addBuildLog({
      buildId: newBuild.id,
      logLevel: 'info',
      message: `Retry of build ${originalBuild.id}`,
      step: 'init',
    });

    revalidatePath('/dashboard/builds');
    
    return { success: true, data: newBuild };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to retry build';
    return { success: false, error: errorMessage };
  }
}
