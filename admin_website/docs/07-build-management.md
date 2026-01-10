# Build Management with Fastlane

**Project:** OSMEA Admin Website  
**Version:** 1.0.0  
**Date:** 2026-01-09  
**Build Tools:** Fastlane + Ruby + Flutter

---

## 📋 Overview

This document provides a comprehensive guide to implementing mobile app build management using Fastlane, including iOS and Android build automation, real-time log streaming, artifact management, and CI/CD integration.

---

## 🎯 Build Architecture

### Build Flow

```
Admin Panel (Trigger Build)
        ↓
Server Action (Create Build Record)
        ↓
Background Worker (Execute Fastlane)
        ↓
Fastlane Runner
        ├─→ iOS Build (xcodebuild)
        └─→ Android Build (gradle)
        ↓
Upload Artifact (Supabase Storage)
        ↓
Update Build Status
        ↓
Notify Admin Panel (Real-time)
```

---

## 🛠️ Fastlane Setup

### 1. Install Fastlane

```bash
# Install Ruby (if not already installed)
# macOS: Ruby comes pre-installed
ruby --version

# Install Bundler
gem install bundler

# Navigate to Flutter project
cd /path/to/storefront_woo

# Install Fastlane
gem install fastlane -NV

# Or use Bundler (recommended)
bundle init
echo 'gem "fastlane"' >> Gemfile
bundle install
```

### 2. Initialize Fastlane

```bash
# For iOS
cd ios
fastlane init

# For Android
cd android
fastlane init
```

### 3. Fastfile Configuration

```ruby
# fastlane/Fastfile
default_platform(:ios)

# Global variables
FLUTTER_PROJECT_PATH = ENV['FLUTTER_PROJECT_PATH'] || '../../../storefront_woo'
OUTPUT_DIR = './build'

# Helper method to run Flutter build
def flutter_build(platform:, build_type:, environment:)
  Dir.chdir(FLUTTER_PROJECT_PATH) do
    case platform
    when 'ios'
      sh "flutter build ios --release --no-codesign"
    when 'android'
      if build_type == 'aab'
        sh "flutter build appbundle --release"
      else
        sh "flutter build apk --release"
      end
    end
  end
end

# iOS Platform
platform :ios do
  desc "Build iOS app"
  lane :build do |options|
    # Parameters
    build_type = options[:build_type] || 'debug'
    environment = options[:environment] || 'dev'
    build_id = options[:build_id]
    
    begin
      # Log start
      log_to_supabase(
        build_id: build_id,
        level: 'info',
        message: 'Starting iOS build process',
        step: 'init'
      )
      
      # Get version info
      version = get_version_number(
        xcodeproj: 'Runner.xcodeproj',
        target: 'Runner'
      )
      
      build_number = get_build_number(
        xcodeproj: 'Runner.xcodeproj'
      )
      
      # Increment build number
      increment_build_number(
        xcodeproj: 'Runner.xcodeproj',
        build_number: (build_number.to_i + 1).to_s
      )
      
      log_to_supabase(
        build_id: build_id,
        level: 'info',
        message: "Building version #{version} (#{build_number})",
        step: 'version'
      )
      
      # Select scheme based on environment
      scheme = case environment
      when 'prod'
        'Runner-Production'
      when 'staging'
        'Runner-Staging'
      else
        'Runner-Dev'
      end
      
      # Build app
      case build_type
      when 'release'
        # App Store build
        log_to_supabase(
          build_id: build_id,
          level: 'info',
          message: 'Building for App Store',
          step: 'build'
        )
        
        build_app(
          scheme: scheme,
          export_method: 'app-store',
          output_directory: OUTPUT_DIR,
          output_name: "app-#{environment}-release.ipa",
          clean: true
        )
        
      when 'adhoc'
        # Ad Hoc build
        log_to_supabase(
          build_id: build_id,
          level: 'info',
          message: 'Building Ad Hoc distribution',
          step: 'build'
        )
        
        build_app(
          scheme: scheme,
          export_method: 'ad-hoc',
          output_directory: OUTPUT_DIR,
          output_name: "app-#{environment}-adhoc.ipa",
          clean: true
        )
        
      else
        # Development build
        log_to_supabase(
          build_id: build_id,
          level: 'info',
          message: 'Building for development',
          step: 'build'
        )
        
        build_app(
          scheme: scheme,
          export_method: 'development',
          output_directory: OUTPUT_DIR,
          output_name: "app-#{environment}-debug.ipa",
          clean: true
        )
      end
      
      # Upload to Supabase Storage
      artifact_path = "#{OUTPUT_DIR}/app-#{environment}-#{build_type}.ipa"
      upload_artifact_to_supabase(
        build_id: build_id,
        artifact_path: artifact_path,
        platform: 'ios'
      )
      
      log_to_supabase(
        build_id: build_id,
        level: 'info',
        message: 'iOS build completed successfully',
        step: 'complete'
      )
      
    rescue => exception
      log_to_supabase(
        build_id: build_id,
        level: 'error',
        message: "Build failed: #{exception.message}",
        step: 'error'
      )
      
      raise exception
    end
  end
  
  desc "Upload to TestFlight"
  lane :upload_testflight do |options|
    build_id = options[:build_id]
    ipa_path = options[:ipa_path]
    
    begin
      log_to_supabase(
        build_id: build_id,
        level: 'info',
        message: 'Uploading to TestFlight',
        step: 'upload'
      )
      
      upload_to_testflight(
        ipa: ipa_path,
        skip_waiting_for_build_processing: true
      )
      
      log_to_supabase(
        build_id: build_id,
        level: 'info',
        message: 'Successfully uploaded to TestFlight',
        step: 'upload_complete'
      )
      
    rescue => exception
      log_to_supabase(
        build_id: build_id,
        level: 'error',
        message: "TestFlight upload failed: #{exception.message}",
        step: 'upload_error'
      )
      
      raise exception
    end
  end
end

# Android Platform
platform :android do
  desc "Build Android app"
  lane :build do |options|
    # Parameters
    build_type = options[:build_type] || 'debug'
    artifact_type = options[:artifact_type] || 'apk'
    environment = options[:environment] || 'dev'
    build_id = options[:build_id]
    
    begin
      log_to_supabase(
        build_id: build_id,
        level: 'info',
        message: 'Starting Android build process',
        step: 'init'
      )
      
      # Set flavor based on environment
      flavor = case environment
      when 'prod'
        'production'
      when 'staging'
        'staging'
      else
        'development'
      end
      
      # Build APK or AAB
      if artifact_type == 'aab'
        log_to_supabase(
          build_id: build_id,
          level: 'info',
          message: 'Building Android App Bundle',
          step: 'build'
        )
        
        gradle(
          task: 'bundle',
          build_type: build_type.capitalize,
          flavor: flavor.capitalize,
          properties: {
            'android.injected.signing.store.file' => ENV['ANDROID_KEYSTORE_PATH'],
            'android.injected.signing.store.password' => ENV['ANDROID_KEYSTORE_PASSWORD'],
            'android.injected.signing.key.alias' => ENV['ANDROID_KEY_ALIAS'],
            'android.injected.signing.key.password' => ENV['ANDROID_KEY_PASSWORD'],
          }
        )
        
        artifact_path = "#{lane_context[SharedValues::GRADLE_AAB_OUTPUT_PATH]}"
      else
        log_to_supabase(
          build_id: build_id,
          level: 'info',
          message: 'Building Android APK',
          step: 'build'
        )
        
        gradle(
          task: 'assemble',
          build_type: build_type.capitalize,
          flavor: flavor.capitalize,
          properties: {
            'android.injected.signing.store.file' => ENV['ANDROID_KEYSTORE_PATH'],
            'android.injected.signing.store.password' => ENV['ANDROID_KEYSTORE_PASSWORD'],
            'android.injected.signing.key.alias' => ENV['ANDROID_KEY_ALIAS'],
            'android.injected.signing.key.password' => ENV['ANDROID_KEY_PASSWORD'],
          }
        )
        
        artifact_path = "#{lane_context[SharedValues::GRADLE_APK_OUTPUT_PATH]}"
      end
      
      # Upload to Supabase Storage
      upload_artifact_to_supabase(
        build_id: build_id,
        artifact_path: artifact_path,
        platform: 'android'
      )
      
      log_to_supabase(
        build_id: build_id,
        level: 'info',
        message: 'Android build completed successfully',
        step: 'complete'
      )
      
    rescue => exception
      log_to_supabase(
        build_id: build_id,
        level: 'error',
        message: "Build failed: #{exception.message}",
        step: 'error'
      )
      
      raise exception
    end
  end
  
  desc "Upload to Play Console"
  lane :upload_play_console do |options|
    build_id = options[:build_id]
    aab_path = options[:aab_path]
    track = options[:track] || 'internal'
    
    begin
      log_to_supabase(
        build_id: build_id,
        level: 'info',
        message: "Uploading to Play Console (#{track} track)",
        step: 'upload'
      )
      
      upload_to_play_store(
        aab: aab_path,
        track: track,
        skip_upload_metadata: true,
        skip_upload_images: true,
        skip_upload_screenshots: true
      )
      
      log_to_supabase(
        build_id: build_id,
        level: 'info',
        message: 'Successfully uploaded to Play Console',
        step: 'upload_complete'
      )
      
    rescue => exception
      log_to_supabase(
        build_id: build_id,
        level: 'error',
        message: "Play Console upload failed: #{exception.message}",
        step: 'upload_error'
      )
      
      raise exception
    end
  end
end

# Helper methods
def log_to_supabase(build_id:, level:, message:, step:)
  require 'net/http'
  require 'json'
  
  uri = URI("#{ENV['NEXT_PUBLIC_SUPABASE_URL']}/rest/v1/build_logs")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  
  request = Net::HTTP::Post.new(uri.path)
  request['Content-Type'] = 'application/json'
  request['apikey'] = ENV['SUPABASE_SERVICE_ROLE_KEY']
  request['Authorization'] = "Bearer #{ENV['SUPABASE_SERVICE_ROLE_KEY']}"
  request['Prefer'] = 'return=minimal'
  
  request.body = {
    build_id: build_id,
    log_level: level,
    message: message,
    step: step,
    source: 'fastlane'
  }.to_json
  
  response = http.request(request)
  
  unless response.is_a?(Net::HTTPSuccess)
    puts "Failed to log to Supabase: #{response.body}"
  end
end

def upload_artifact_to_supabase(build_id:, artifact_path:, platform:)
  require 'net/http'
  require 'digest'
  
  # Calculate MD5
  md5 = Digest::MD5.file(artifact_path).hexdigest
  file_size = File.size(artifact_path)
  filename = File.basename(artifact_path)
  
  # Upload to Supabase Storage
  uri = URI("#{ENV['NEXT_PUBLIC_SUPABASE_URL']}/storage/v1/object/builds/#{build_id}/#{filename}")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  
  request = Net::HTTP::Post.new(uri.path)
  request['apikey'] = ENV['SUPABASE_SERVICE_ROLE_KEY']
  request['Authorization'] = "Bearer #{ENV['SUPABASE_SERVICE_ROLE_KEY']}"
  request['Content-Type'] = 'application/octet-stream'
  request.body = File.read(artifact_path)
  
  response = http.request(request)
  
  if response.is_a?(Net::HTTPSuccess)
    # Get public URL
    public_url = "#{ENV['NEXT_PUBLIC_SUPABASE_URL']}/storage/v1/object/public/builds/#{build_id}/#{filename}"
    
    # Update build record
    update_build_artifact(
      build_id: build_id,
      artifact_url: public_url,
      artifact_size: file_size,
      artifact_md5: md5
    )
  else
    raise "Failed to upload artifact: #{response.body}"
  end
end

def update_build_artifact(build_id:, artifact_url:, artifact_size:, artifact_md5:)
  require 'net/http'
  require 'json'
  
  uri = URI("#{ENV['NEXT_PUBLIC_SUPABASE_URL']}/rest/v1/builds?id=eq.#{build_id}")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  
  request = Net::HTTP::Patch.new(uri.path)
  request['Content-Type'] = 'application/json'
  request['apikey'] = ENV['SUPABASE_SERVICE_ROLE_KEY']
  request['Authorization'] = "Bearer #{ENV['SUPABASE_SERVICE_ROLE_KEY']}"
  request['Prefer'] = 'return=minimal'
  
  request.body = {
    artifact_url: artifact_url,
    artifact_size: artifact_size,
    artifact_md5: artifact_md5
  }.to_json
  
  response = http.request(request)
  
  unless response.is_a?(Net::HTTPSuccess)
    puts "Failed to update build record: #{response.body}"
  end
end
```

---

## 🔧 Next.js Integration

### 1. Build Service

```typescript
// src/lib/services/build.service.ts
import { exec } from 'child_process';
import { promisify } from 'util';
import { supabaseService } from './supabase.service';

const execAsync = promisify(exec);

export interface BuildOptions {
  platform: 'ios' | 'android';
  buildType: 'debug' | 'release' | 'adhoc';
  artifactType?: 'ipa' | 'apk' | 'aab';
  environment: 'dev' | 'staging' | 'prod';
  buildId: string;
}

export class BuildService {
  private flutterProjectPath = process.env.FLUTTER_PROJECT_PATH!;

  async executeBuild(options: BuildOptions): Promise<void> {
    const { platform, buildType, artifactType = 'apk', environment, buildId } = options;

    // Update build status to building
    await supabaseService.updateBuildStatus(buildId, 'building', {
      started_at: new Date().toISOString(),
    });

    const startTime = Date.now();

    try {
      // Navigate to platform directory
      const platformDir = platform === 'ios' ? 'ios' : 'android';
      const workDir = `${this.flutterProjectPath}/${platformDir}`;

      // Build Fastlane command
      const command = [
        'cd', workDir, '&&',
        'bundle', 'exec', 'fastlane',
        platform,
        'build',
        `build_type:${buildType}`,
        `environment:${environment}`,
        `build_id:${buildId}`,
      ];

      if (platform === 'android') {
        command.push(`artifact_type:${artifactType}`);
      }

      const cmd = command.join(' ');
      console.log('Executing:', cmd);

      // Execute Fastlane
      const { stdout, stderr } = await execAsync(cmd, {
        env: {
          ...process.env,
          FLUTTER_PROJECT_PATH: this.flutterProjectPath,
        },
      });

      console.log('Build output:', stdout);
      if (stderr) {
        console.error('Build errors:', stderr);
      }

      const endTime = Date.now();
      const duration = Math.floor((endTime - startTime) / 1000);

      // Update build as success
      await supabaseService.updateBuildStatus(buildId, 'success', {
        completed_at: new Date().toISOString(),
        build_duration: duration,
      });

    } catch (error: any) {
      console.error('Build failed:', error);

      // Update build as failed
      await supabaseService.updateBuildStatus(buildId, 'failed', {
        completed_at: new Date().toISOString(),
      });

      // Log error
      await supabaseService.addBuildLog({
        buildId,
        logLevel: 'error',
        message: error.message || 'Build failed',
        source: 'build_service',
        step: 'error',
      });

      throw error;
    }
  }

  async cancelBuild(buildId: string): Promise<void> {
    // Update build status to cancelled
    await supabaseService.updateBuildStatus(buildId, 'cancelled', {
      completed_at: new Date().toISOString(),
    });

    await supabaseService.addBuildLog({
      buildId,
      logLevel: 'warning',
      message: 'Build cancelled by user',
      source: 'build_service',
      step: 'cancel',
    });
  }
}

export const buildService = new BuildService();
```

### 2. Build Actions

```typescript
// src/actions/build.actions.ts
'use server';

import { revalidatePath } from 'next/cache';
import { supabaseService } from '@/lib/services/supabase.service';
import { buildService } from '@/lib/services/build.service';
import { createAuditLog } from '@/lib/utils/audit';

export async function triggerBuild(options: {
  storeId: string;
  platform: 'ios' | 'android';
  buildType: 'debug' | 'release' | 'adhoc';
  artifactType?: 'ipa' | 'apk' | 'aab';
  environment: 'dev' | 'staging' | 'prod';
}) {
  try {
    // Create build record
    const build = await supabaseService.createBuild({
      storeId: options.storeId,
      platform: options.platform,
      buildType: options.buildType,
      environment: options.environment,
      version: '1.0.0', // Get from pubspec.yaml
      buildNumber: Date.now().toString(),
    });

    // Log audit
    await createAuditLog({
      action: 'build:trigger',
      entityType: 'build',
      entityId: build.id,
      newValue: options,
    });

    // Execute build asynchronously (don't await)
    buildService.executeBuild({
      ...options,
      buildId: build.id,
    }).catch(console.error);

    revalidatePath('/dashboard/builds');

    return { success: true, buildId: build.id };
  } catch (error: any) {
    console.error('Failed to trigger build:', error);
    return { success: false, error: error.message };
  }
}

export async function cancelBuild(buildId: string) {
  try {
    await buildService.cancelBuild(buildId);

    await createAuditLog({
      action: 'build:cancel',
      entityType: 'build',
      entityId: buildId,
    });

    revalidatePath('/dashboard/builds');

    return { success: true };
  } catch (error: any) {
    return { success: false, error: error.message };
  }
}

export async function getBuild(buildId: string) {
  try {
    const build = await supabaseService.getBuild(buildId);
    return { success: true, data: build };
  } catch (error: any) {
    return { success: false, error: error.message };
  }
}

export async function getBuildLogs(buildId: string) {
  try {
    const logs = await supabaseService.getBuildLogs(buildId);
    return { success: true, data: logs };
  } catch (error: any) {
    return { success: false, error: error.message };
  }
}
```

---

## 📊 Real-time Log Streaming

### Build Logs Component

```typescript
// src/components/builds/build-logs.tsx
'use client';

import { useEffect, useState, useRef } from 'react';
import { createClient } from '@/lib/supabase/client';
import { ScrollArea } from '@/components/ui/scroll-area';
import { cn } from '@/lib/utils';

interface BuildLog {
  id: string;
  log_level: string;
  message: string;
  timestamp: string;
  step?: string;
  source?: string;
}

interface BuildLogsProps {
  buildId: string;
  autoScroll?: boolean;
}

export function BuildLogs({ buildId, autoScroll = true }: BuildLogsProps) {
  const [logs, setLogs] = useState<BuildLog[]>([]);
  const scrollRef = useRef<HTMLDivElement>(null);
  const supabase = createClient();

  useEffect(() => {
    // Fetch existing logs
    fetchLogs();

    // Subscribe to new logs
    const channel = supabase
      .channel(`build-logs:${buildId}`)
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'build_logs',
          filter: `build_id=eq.${buildId}`,
        },
        (payload) => {
          setLogs((prev) => [...prev, payload.new as BuildLog]);
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [buildId]);

  useEffect(() => {
    if (autoScroll && scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
    }
  }, [logs, autoScroll]);

  async function fetchLogs() {
    const { data, error } = await supabase
      .from('build_logs')
      .select('*')
      .eq('build_id', buildId)
      .order('timestamp', { ascending: true });

    if (data) {
      setLogs(data);
    }
  }

  const getLogColor = (level: string) => {
    switch (level) {
      case 'error':
      case 'critical':
        return 'text-red-500';
      case 'warning':
        return 'text-yellow-500';
      case 'info':
        return 'text-blue-500';
      case 'debug':
        return 'text-gray-500';
      default:
        return 'text-green-400';
    }
  };

  return (
    <ScrollArea className="h-[500px] w-full" ref={scrollRef}>
      <div className="font-mono text-sm bg-black text-green-400 p-4 rounded-lg">
        {logs.length === 0 ? (
          <div className="text-gray-500">No logs yet...</div>
        ) : (
          logs.map((log) => (
            <div key={log.id} className="py-0.5">
              <span className="text-gray-500 mr-2">
                {new Date(log.timestamp).toLocaleTimeString()}
              </span>
              <span className={cn('font-medium', getLogColor(log.log_level))}>
                [{log.log_level.toUpperCase()}]
              </span>
              {log.step && (
                <span className="text-purple-400 ml-2">[{log.step}]</span>
              )}
              <span className="ml-2">{log.message}</span>
            </div>
          ))
        )}
      </div>
    </ScrollArea>
  );
}
```

---

## 🔐 Code Signing

### iOS Code Signing

```bash
# Install Match for code signing
bundle exec fastlane match init

# Configure Match
# Edit fastlane/Matchfile
git_url("https://github.com/your-org/certificates")
storage_mode("git")
type("appstore")

# Generate certificates
bundle exec fastlane match appstore
bundle exec fastlane match adhoc
bundle exec fastlane match development
```

### Android Code Signing

```bash
# Generate keystore
keytool -genkey -v -keystore release.keystore -alias release \
  -keyalg RSA -keysize 2048 -validity 10000

# Add to environment variables
export ANDROID_KEYSTORE_PATH=/path/to/release.keystore
export ANDROID_KEYSTORE_PASSWORD=your_keystore_password
export ANDROID_KEY_ALIAS=release
export ANDROID_KEY_PASSWORD=your_key_password
```

---

## ✅ Best Practices

### Build Management Checklist

- [ ] Implement proper error handling
- [ ] Add real-time log streaming
- [ ] Store build artifacts securely
- [ ] Track build metrics (duration, size)
- [ ] Implement build cancellation
- [ ] Add retry logic for failed builds
- [ ] Use environment-specific configurations
- [ ] Implement code signing automation
- [ ] Add build notifications
- [ ] Track build history
- [ ] Implement artifact cleanup
- [ ] Add build versioning
- [ ] Document build process
- [ ] Test builds on CI/CD
- [ ] Monitor build failures

---

**Document Version:** 1.0.0  
**Last Updated:** 2026-01-09  
**Status:** Complete
