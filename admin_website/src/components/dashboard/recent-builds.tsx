'use client';

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { StatusBadge } from '@/components/ui/status-badge';
import { EmptyState } from '@/components/ui/empty-state';
import { Skeleton } from '@/components/ui/skeleton-loader';
import { Smartphone, Apple, Clock, ArrowRight } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { formatDate } from '@/lib/utils';

interface Build {
  id: string;
  platform: 'ios' | 'android';
  status: 'success' | 'error' | 'building' | 'queued' | 'cancelled';
  version: string;
  buildNumber: string;
  createdAt: string;
  duration?: number;
}

interface RecentBuildsProps {
  builds: Build[];
  loading?: boolean;
  onViewAll?: () => void;
  onTriggerBuild?: () => void;
}

export function RecentBuilds({
  builds,
  loading = false,
  onViewAll,
  onTriggerBuild,
}: RecentBuildsProps) {
  if (loading) {
    return <RecentBuildsSkeleton />;
  }

  return (
    <Card>
      <CardHeader className="flex flex-row items-center justify-between">
        <div>
          <CardTitle className="text-lg">Recent Builds</CardTitle>
          <CardDescription>Latest app builds</CardDescription>
        </div>
        {onViewAll && builds.length > 0 && (
          <Button variant="ghost" size="sm" onClick={onViewAll}>
            View All
            <ArrowRight className="ml-1 h-4 w-4" />
          </Button>
        )}
      </CardHeader>
      <CardContent>
        {builds.length === 0 ? (
          <EmptyState
            icon={Smartphone}
            title="No builds yet"
            description="Start building your app to see build history here"
            action={onTriggerBuild ? { label: 'Start Build', onClick: onTriggerBuild } : undefined}
            compact
          />
        ) : (
          <div className="space-y-4">
            {builds.slice(0, 5).map((build) => (
              <BuildItem key={build.id} build={build} />
            ))}
          </div>
        )}
      </CardContent>
    </Card>
  );
}

function BuildItem({ build }: { build: Build }) {
  const PlatformIcon = build.platform === 'ios' ? Apple : Smartphone;

  return (
    <div className="flex items-center gap-4">
      <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-muted">
        <PlatformIcon className="h-5 w-5" />
      </div>
      <div className="flex-1 min-w-0">
        <div className="flex items-center gap-2">
          <span className="font-medium capitalize">{build.platform}</span>
          <span className="text-sm text-muted-foreground">
            v{build.version} ({build.buildNumber})
          </span>
        </div>
        <div className="flex items-center gap-2 text-xs text-muted-foreground">
          <Clock className="h-3 w-3" />
          {formatDate(build.createdAt)}
          {build.duration && (
            <span>• {formatDuration(build.duration)}</span>
          )}
        </div>
      </div>
      <StatusBadge status={build.status} size="sm" />
    </div>
  );
}

function formatDuration(seconds: number): string {
  if (seconds < 60) return `${seconds}s`;
  const minutes = Math.floor(seconds / 60);
  const remainingSeconds = seconds % 60;
  if (minutes < 60) return `${minutes}m ${remainingSeconds}s`;
  const hours = Math.floor(minutes / 60);
  const remainingMinutes = minutes % 60;
  return `${hours}h ${remainingMinutes}m`;
}

function RecentBuildsSkeleton() {
  return (
    <Card>
      <CardHeader>
        <Skeleton className="h-5 w-32" />
        <Skeleton className="h-4 w-24" />
      </CardHeader>
      <CardContent className="space-y-4">
        {Array.from({ length: 3 }).map((_, i) => (
          <div key={i} className="flex items-center gap-4">
            <Skeleton className="h-10 w-10 rounded-lg" />
            <div className="flex-1 space-y-2">
              <Skeleton className="h-4 w-32" />
              <Skeleton className="h-3 w-24" />
            </div>
            <Skeleton className="h-6 w-16 rounded-full" />
          </div>
        ))}
      </CardContent>
    </Card>
  );
}
