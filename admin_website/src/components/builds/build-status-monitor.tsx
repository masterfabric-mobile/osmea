'use client';

import { useEffect, useState } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Progress } from '@/components/ui/progress';
import { AnimatedStatusBadge } from '@/components/ui/status-badge';
import { supabase } from '@/lib/supabase/client';
import { 
  Apple, 
  Smartphone, 
  Clock, 
  Download, 
  XCircle,
  RefreshCw,
  ExternalLink,
} from 'lucide-react';
import { formatDate } from '@/lib/utils';
import type { Build } from '@/lib/types/build.types';

interface BuildStatusMonitorProps {
  build: Build;
  onCancel?: () => void;
  onRetry?: () => void;
  onDownload?: () => void;
}

const BUILD_STEPS = [
  { id: 'init', label: 'Initializing', progress: 0 },
  { id: 'prepare', label: 'Preparing', progress: 10 },
  { id: 'dependencies', label: 'Dependencies', progress: 25 },
  { id: 'compile', label: 'Compiling', progress: 50 },
  { id: 'test', label: 'Testing', progress: 70 },
  { id: 'artifacts', label: 'Generating', progress: 85 },
  { id: 'complete', label: 'Complete', progress: 100 },
];

export function BuildStatusMonitor({
  build: initialBuild,
  onCancel,
  onRetry,
  onDownload,
}: BuildStatusMonitorProps) {
  const [build, setBuild] = useState<Build>(initialBuild);
  const [currentStep, setCurrentStep] = useState<string>('init');
  const [progress, setProgress] = useState(0);

  useEffect(() => {
    // Subscribe to build updates (only if Supabase is available)
    if (supabase && ['pending', 'queued', 'building'].includes(build.status)) {
      const client = supabase;
      const channel = client
        .channel(`build:${build.id}`)
        .on(
          'postgres_changes',
          {
            event: 'UPDATE',
            schema: 'public',
            table: 'builds',
            filter: `id=eq.${build.id}`,
          },
          (payload) => {
            setBuild(payload.new as Build);
          }
        )
        .subscribe();

      // Also subscribe to logs to track progress
      const logsChannel = client
        .channel(`build-logs:${build.id}`)
        .on(
          'postgres_changes',
          {
            event: 'INSERT',
            schema: 'public',
            table: 'build_logs',
            filter: `build_id=eq.${build.id}`,
          },
          (payload) => {
            const step = (payload.new as { step?: string }).step;
            if (step) {
              setCurrentStep(step);
              const stepInfo = BUILD_STEPS.find((s) => s.id === step);
              if (stepInfo) {
                setProgress(stepInfo.progress);
              }
            }
          }
        )
        .subscribe();

      return () => {
        client.removeChannel(channel);
        client.removeChannel(logsChannel);
      };
    }
    
    // For local builds without Supabase, update from props
    if (!supabase) {
      setBuild(initialBuild);
    }
  }, [build.id, build.status, supabase, initialBuild]);

  useEffect(() => {
    // Update progress based on status
    if (build.status === 'success') {
      setProgress(100);
      setCurrentStep('complete');
    } else if (build.status === 'failed' || build.status === 'cancelled') {
      // Keep current progress
    } else if (build.status === 'building') {
      // Simulate progress for local builds
      if (!supabase && progress < 90) {
        const interval = setInterval(() => {
          setProgress(prev => {
            if (prev >= 90) {
              clearInterval(interval);
              return prev;
            }
            const next = prev + 10;
            const step = BUILD_STEPS.find(s => s.progress >= next);
            if (step) setCurrentStep(step.id);
            return next;
          });
        }, 2000);
        return () => clearInterval(interval);
      }
    } else if (build.status === 'queued') {
      setProgress(10);
      setCurrentStep('prepare');
    } else if (build.status === 'pending') {
      setProgress(0);
      setCurrentStep('init');
    }
  }, [build.status, supabase]);

  const PlatformIcon = build.platform === 'ios' ? Apple : Smartphone;
  const isActive = ['pending', 'queued', 'building'].includes(build.status);
  const canCancel = isActive;
  const canRetry = ['failed', 'cancelled'].includes(build.status);
  const canDownload = build.status === 'success' && build.artifact_url;

  const formatDuration = (seconds?: number) => {
    if (!seconds) return '-';
    const minutes = Math.floor(seconds / 60);
    const secs = seconds % 60;
    if (minutes === 0) return `${secs}s`;
    return `${minutes}m ${secs}s`;
  };

  return (
    <Card>
      <CardHeader className="pb-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className={`p-2 rounded-lg ${
              build.platform === 'ios' 
                ? 'bg-gray-100 dark:bg-gray-800' 
                : 'bg-green-100 dark:bg-green-900/30'
            }`}>
              <PlatformIcon className={`h-5 w-5 ${
                build.platform === 'ios' ? '' : 'text-green-600'
              }`} />
            </div>
            <div>
              <CardTitle className="text-lg capitalize">
                {build.platform} Build
              </CardTitle>
              <CardDescription>
                v{build.version} ({build.build_number})
              </CardDescription>
            </div>
          </div>
          <AnimatedStatusBadge status={build.status} />
        </div>
      </CardHeader>
      <CardContent className="space-y-4">
        {/* Progress */}
        {isActive && (
          <div className="space-y-2">
            <div className="flex justify-between text-sm">
              <span className="text-muted-foreground">
                {BUILD_STEPS.find((s) => s.id === currentStep)?.label || 'Processing...'}
              </span>
              <span className="font-medium">{progress}%</span>
            </div>
            <Progress value={progress} className="h-2" />
          </div>
        )}

        {/* Info */}
        <div className="grid grid-cols-2 gap-4 text-sm">
          <div>
            <span className="text-muted-foreground">Type</span>
            <p className="font-medium capitalize">{build.build_type}</p>
          </div>
          <div>
            <span className="text-muted-foreground">Environment</span>
            <p className="font-medium capitalize">{build.environment}</p>
          </div>
          <div>
            <span className="text-muted-foreground">Started</span>
            <p className="font-medium">
              {build.started_at ? formatDate(build.started_at) : '-'}
            </p>
          </div>
          <div>
            <span className="text-muted-foreground">Duration</span>
            <p className="font-medium">{formatDuration(build.build_duration)}</p>
          </div>
        </div>

        {/* Error Message */}
        {build.status === 'failed' && build.error_message && (
          <div className="p-3 bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 rounded-lg text-sm">
            {build.error_message}
          </div>
        )}

        {/* Actions */}
        <div className="flex gap-2 pt-2">
          {canCancel && onCancel && (
            <Button variant="destructive" size="sm" onClick={onCancel}>
              <XCircle className="mr-2 h-4 w-4" />
              Cancel
            </Button>
          )}
          {canRetry && onRetry && (
            <Button variant="outline" size="sm" onClick={onRetry}>
              <RefreshCw className="mr-2 h-4 w-4" />
              Retry
            </Button>
          )}
          {canDownload && (
            <Button size="sm" onClick={onDownload}>
              <Download className="mr-2 h-4 w-4" />
              Download
            </Button>
          )}
          {build.artifact_url && (
            <Button variant="ghost" size="sm" asChild>
              <a href={build.artifact_url} target="_blank" rel="noopener noreferrer">
                <ExternalLink className="h-4 w-4" />
              </a>
            </Button>
          )}
        </div>
      </CardContent>
    </Card>
  );
}
