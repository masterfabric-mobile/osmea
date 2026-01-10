'use server';

import { revalidatePath } from 'next/cache';
import { supabaseService } from '@/lib/services/supabase.service';
import type { ConfigurationInput } from '@/lib/types/config.types';

export async function getConfigurations(storeId: string) {
  try {
    const configs = await supabaseService.getConfigurations(storeId);
    return { success: true, data: configs };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch configurations';
    return { success: false, error: errorMessage };
  }
}

export async function getConfiguration(id: string) {
  try {
    const config = await supabaseService.getConfiguration(id);
    if (!config) {
      return { success: false, error: 'Configuration not found' };
    }
    return { success: true, data: config };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch configuration';
    return { success: false, error: errorMessage };
  }
}

export async function getActiveConfiguration(
  storeId: string,
  configKey: string,
  environment: string = 'production'
) {
  try {
    const config = await supabaseService.getActiveConfiguration(storeId, configKey, environment);
    return { success: true, data: config };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to fetch active configuration';
    return { success: false, error: errorMessage };
  }
}

export async function createConfiguration(storeId: string, input: ConfigurationInput) {
  try {
    const config = await supabaseService.createConfiguration(storeId, input);
    revalidatePath('/dashboard/app-config');
    return { success: true, data: config };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to create configuration';
    return { success: false, error: errorMessage };
  }
}

export async function updateConfiguration(id: string, configValue: Record<string, unknown>) {
  try {
    const config = await supabaseService.updateConfiguration(id, configValue);
    revalidatePath('/dashboard/app-config');
    return { success: true, data: config };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to update configuration';
    return { success: false, error: errorMessage };
  }
}

export async function publishConfiguration(id: string) {
  try {
    const config = await supabaseService.publishConfiguration(id);
    revalidatePath('/dashboard/app-config');
    return { success: true, data: config };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to publish configuration';
    return { success: false, error: errorMessage };
  }
}
