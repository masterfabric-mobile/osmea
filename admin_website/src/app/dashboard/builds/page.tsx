'use client';

import { useState, useEffect, useCallback } from 'react';
import { PageHeader, PageContainer, PageSection } from '@/components/layout/page-header';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { EmptyState } from '@/components/ui/empty-state';
import { StatusBadge } from '@/components/ui/status-badge';
import { DataTable } from '@/components/ui/data-table';
import { TableSkeleton } from '@/components/ui/skeleton-loader';
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { toast } from 'sonner';
import { 
  Wrench, 
  Apple, 
  Smartphone, 
  Download,
  Play,
  Clock,
  RefreshCw,
  XCircle,
  Eye,
  Trash2,
  Rocket,
} from 'lucide-react';
import type { ColumnDef } from '@tanstack/react-table';
import type { Build } from '@/lib/types/build.types';
import { formatDate, formatDateTime } from '@/lib/utils';
import { BuildTrigger } from '@/components/builds/build-trigger';
import { BuildStatusMonitor } from '@/components/builds/build-status-monitor';
import { BuildLogsStream } from '@/components/builds/build-logs-stream';
import { isLocalDevelopment } from '@/lib/utils/env';

const STORAGE_KEY = 'osmea-builds';

// Local build storage helper
const getBuildsFromStorage = (): Build[] => {
  if (typeof window === 'undefined') return [];
  try {
    const stored = localStorage.getItem(STORAGE_KEY);
    return stored ? JSON.parse(stored) : [];
  } catch {
    return [];
  }
};

const saveBuildsToStorage = (builds: Build[]) => {
  if (typeof window === 'undefined') return;
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(builds));
  } catch (error) {
    console.error('Failed to save builds:', error);
  }
};

const generateBuildId = () => `build_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;

const columns: ColumnDef<Build>[] = [
  {
    accessorKey: 'platform',
    header: 'Platform',
    cell: ({ row }) => {
      const platform = row.original.platform;
      const Icon = platform === 'ios' ? Apple : Smartphone;
      return (
        <div className="flex items-center gap-2">
          <Icon className="h-4 w-4" />
          <span className="capitalize">{platform}</span>
        </div>
      );
    },
  },
  {
    accessorKey: 'version',
    header: 'Version',
    cell: ({ row }) => (
      <div>
        <div className="font-medium">v{row.original.version}</div>
        <div className="text-sm text-muted-foreground">Build {row.original.build_number}</div>
      </div>
    ),
  },
  {
    accessorKey: 'build_type',
    header: 'Type',
    cell: ({ row }) => (
      <span className="capitalize">{row.original.build_type}</span>
    ),
  },
  {
    accessorKey: 'status',
    header: 'Status',
    cell: ({ row }) => (
      <StatusBadge
        status={row.original.status}
        size="sm"
      />
    ),
  },
  {
    accessorKey: 'created_at',
    header: 'Date',
    cell: ({ row }) => formatDate(row.original.created_at),
  },
  {
    accessorKey: 'build_duration',
    header: 'Duration',
    cell: ({ row }) => {
      const duration = row.original.build_duration;
      if (!duration) return '-';
      const minutes = Math.floor(duration / 60);
      const seconds = duration % 60;
      return `${minutes}m ${seconds}s`;
    },
  },
  {
    id: 'actions',
    header: '',
    cell: ({ row }) => {
      const build = row.original;
      return (
        <div className="flex gap-2">
          {build.artifact_url && (
            <Button variant="ghost" size="sm" asChild>
              <a href={build.artifact_url} download>
                <Download className="h-4 w-4" />
              </a>
            </Button>
          )}
        </div>
      );
    },
  },
];

export default function BuildsPage() {
  const [loading, setLoading] = useState(false);
  const [builds, setBuilds] = useState<Build[]>([]);
  const [selectedBuild, setSelectedBuild] = useState<Build | null>(null);
  const [showBuildDialog, setShowBuildDialog] = useState(false);
  const [showTriggerDialog, setShowTriggerDialog] = useState(false);
  const [isLocal, setIsLocal] = useState(false);

  // Check if running in local development
  useEffect(() => {
    setIsLocal(isLocalDevelopment());
  }, []);

  // Load builds from localStorage
  useEffect(() => {
    loadBuilds();
  }, []);

  const loadBuilds = useCallback(() => {
    setLoading(true);
    try {
      const storedBuilds = getBuildsFromStorage();
      // Sort by created_at descending
      const sorted = storedBuilds.sort((a, b) => 
        new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
      );
      setBuilds(sorted);
    } catch (error) {
      console.error('Failed to load builds:', error);
      toast.error('Failed to load builds');
    } finally {
      setLoading(false);
    }
  }, []);

  // Trigger real build via API (only in local development)
  const triggerRealBuild = async (build: Build, options: {
    platform: 'ios' | 'android';
    buildType: 'debug' | 'release' | 'adhoc';
    artifactType?: 'ipa' | 'apk' | 'aab';
    environment: 'development' | 'staging' | 'production';
  }) => {
    try {
      // Update build status to queued
      const queuedBuild: Build = {
        ...build,
        status: 'queued',
        started_at: new Date().toISOString(),
      };
      updateBuild(queuedBuild);

      // Call the build API
      const response = await fetch('/api/build/local', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          platform: options.platform,
          buildType: options.buildType,
          artifactType: options.artifactType,
          environment: options.environment,
          version: build.version,
          buildNumber: build.build_number,
        }),
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || 'Failed to start build');
      }

      const data = await response.json();
      const buildId = data.buildId;

      // Update build with buildId and start monitoring
      const buildingBuild: Build = {
        ...queuedBuild,
        id: buildId, // Use API buildId
        status: 'building',
      };
      updateBuild(buildingBuild);

      // Monitor build status via SSE
      monitorBuildStatus(buildId, buildingBuild);
    } catch (error) {
      const message = error instanceof Error ? error.message : 'Failed to trigger build';
      const failedBuild: Build = {
        ...build,
        status: 'failed',
        completed_at: new Date().toISOString(),
        error_message: message,
      };
      updateBuild(failedBuild);
      toast.error(`Build failed: ${message}`);
    }
  };

  // Monitor build status via SSE
  const monitorBuildStatus = (buildId: string, build: Build) => {
    const eventSource = new EventSource(`/api/build/local?buildId=${buildId}`);

    eventSource.addEventListener('status', (event) => {
      const data = JSON.parse(event.data);
      const updatedBuild: Build = {
        ...build,
        status: data.status === 'success' ? 'success' : data.status === 'failed' ? 'failed' : 'building',
      };
      updateBuild(updatedBuild);
    });

    eventSource.addEventListener('complete', (event) => {
      const data = JSON.parse(event.data);
      const completedAt = new Date().toISOString();
      const startTime = build.started_at ? new Date(build.started_at).getTime() : Date.now();
      const duration = Math.floor((Date.now() - startTime) / 1000);

      const completedBuild: Build = {
        ...build,
        status: data.status === 'success' ? 'success' : 'failed',
        completed_at: completedAt,
        build_duration: duration,
        artifact_url: data.artifactPath,
        error_message: data.status === 'failed' 
          ? (data.errorMessage || 'Build failed. Check logs for details.')
          : undefined,
      };
      updateBuild(completedBuild);
      eventSource.close();

      if (data.status === 'success') {
        toast.success(`${build.platform.toUpperCase()} build completed successfully!`);
      } else {
        const errorMsg = data.errorMessage || 'Build failed';
        toast.error(`${build.platform.toUpperCase()} build failed: ${errorMsg}`);
      }
    });

    eventSource.onerror = () => {
      eventSource.close();
    };
  };

  // Simulate build process (fallback for non-local or demo)
  const simulateBuild = async (build: Build) => {
    const steps = [
      { status: 'queued' as const, delay: 500 },
      { status: 'building' as const, delay: 2000 },
      { status: 'building' as const, delay: 3000 },
      { status: 'building' as const, delay: 2000 },
    ];

    let currentBuild: Build = { ...build, status: 'queued' as const, started_at: new Date().toISOString() };
    updateBuild(currentBuild);

    for (const step of steps) {
      await new Promise(resolve => setTimeout(resolve, step.delay));
      currentBuild = { ...currentBuild, status: step.status as Build['status'] };
      updateBuild(currentBuild);
    }

    // Final status (80% success rate for demo)
    const success = Math.random() > 0.2;
    const finalStatus = success ? 'success' : 'failed';
    const completedAt = new Date().toISOString();
    const duration = Math.floor((new Date(completedAt).getTime() - new Date(currentBuild.started_at!).getTime()) / 1000);

    const finalBuild: Build = {
      ...currentBuild,
      status: finalStatus,
      completed_at: completedAt,
      build_duration: duration,
      artifact_url: success ? `https://example.com/builds/${build.id}.${build.platform === 'ios' ? 'ipa' : 'apk'}` : undefined,
      error_message: success ? undefined : 'Build simulation failed (not running in local development mode)',
    };

    updateBuild(finalBuild);
    
    if (success) {
      toast.success(`${build.platform.toUpperCase()} build simulation completed!`);
    } else {
      toast.error(`${build.platform.toUpperCase()} build simulation failed`);
    }
  };

  const updateBuild = (updatedBuild: Build) => {
    setBuilds(prev => {
      const updated = prev.map(b => b.id === updatedBuild.id ? updatedBuild : b);
      saveBuildsToStorage(updated);
      return updated;
    });
  };

  const handleTriggerBuild = async (options: {
    platform: 'ios' | 'android';
    buildType: 'debug' | 'release' | 'adhoc';
    artifactType?: 'ipa' | 'apk' | 'aab';
    environment: 'development' | 'staging' | 'production';
    uploadToStore: boolean;
  }) => {
    try {
      // Get app config for version
      const appConfig = localStorage.getItem('osmea-app-config');
      let version = '1.0.0';
      let buildNumber = '1';
      
      if (appConfig) {
        try {
          const config = JSON.parse(appConfig);
          version = config.app_settings?.app_version || version;
          buildNumber = config.app_settings?.build_number || buildNumber;
        } catch {}
      }

      // Get existing builds to determine next build number
      const existingBuilds = getBuildsFromStorage();
      const platformBuilds = existingBuilds.filter(b => b.platform === options.platform);
      const nextBuildNumber = platformBuilds.length > 0 
        ? String(parseInt(platformBuilds[0].build_number) + 1)
        : buildNumber;

      const newBuild: Build = {
        id: generateBuildId(),
        store_id: 'local-store',
        platform: options.platform,
        build_type: options.buildType,
        artifact_type: options.artifactType,
        environment: options.environment,
        status: 'pending',
        version,
        build_number: nextBuildNumber,
        branch: 'main',
        triggered_by: 'local-user',
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
      };

      // Add to builds list
      const updatedBuilds = [newBuild, ...builds];
      setBuilds(updatedBuilds);
      saveBuildsToStorage(updatedBuilds);

      setShowTriggerDialog(false);
      toast.success(`${options.platform.toUpperCase()} build queued!`);

      // Use real API if in local development, otherwise simulate
      if (isLocal) {
        await triggerRealBuild(newBuild, options);
      } else {
        simulateBuild(newBuild);
      }
    } catch (error) {
      const message = error instanceof Error ? error.message : 'Failed to trigger build';
      toast.error(message);
    }
  };

  const handleCancelBuild = async (buildId: string) => {
    const build = builds.find(b => b.id === buildId);
    if (!build) return;

    if (['pending', 'queued', 'building'].includes(build.status)) {
      const updated: Build = {
        ...build,
        status: 'cancelled',
        completed_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
      };
      updateBuild(updated);
      toast.success('Build cancelled');
    }
  };

  const handleRetryBuild = async (buildId: string) => {
    const originalBuild = builds.find(b => b.id === buildId);
    if (!originalBuild) return;

    const newBuild: Build = {
      ...originalBuild,
      id: generateBuildId(),
      status: 'pending',
      build_number: String(parseInt(originalBuild.build_number) + 1),
      started_at: undefined,
      completed_at: undefined,
      build_duration: undefined,
      error_message: undefined,
      artifact_url: undefined,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    };

    const updatedBuilds = [newBuild, ...builds];
    setBuilds(updatedBuilds);
    saveBuildsToStorage(updatedBuilds);

    toast.success('Build retried');
    
    // Use real API if in local development, otherwise simulate
    if (isLocal) {
      await triggerRealBuild(newBuild, {
        platform: originalBuild.platform,
        buildType: originalBuild.build_type,
        artifactType: originalBuild.artifact_type,
        environment: originalBuild.environment,
      });
    } else {
      simulateBuild(newBuild);
    }
  };

  const handleDeleteBuild = async (buildId: string) => {
    if (!confirm('Are you sure you want to delete this build?')) return;

    const updated = builds.filter(b => b.id !== buildId);
    setBuilds(updated);
    saveBuildsToStorage(updated);
    toast.success('Build deleted');
  };

  const handleRefresh = async () => {
    setLoading(true);
    await new Promise(resolve => setTimeout(resolve, 500));
    loadBuilds();
  };

  const activeBuilds = builds.filter(b => ['pending', 'queued', 'building'].includes(b.status));
  const recentBuilds = builds.slice(0, 10);

  return (
    <PageContainer>
      <PageHeader
        title="Build Management"
        description="Build and manage your iOS and Android apps"
        onRefresh={handleRefresh}
        refreshing={loading}
        actions={
          <Dialog open={showTriggerDialog} onOpenChange={setShowTriggerDialog}>
            <DialogTrigger asChild>
              <Button disabled={!isLocal}>
                <Rocket className="mr-2 h-4 w-4" />
                New Build {!isLocal && '(Local Only)'}
              </Button>
            </DialogTrigger>
            <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
              <DialogHeader>
                <DialogTitle>Trigger New Build</DialogTitle>
                <DialogDescription>
                  {isLocal 
                    ? 'Configure and start a new build for iOS or Android using Fastlane'
                    : 'Build feature is only available in local development mode. Run `npm run dev` on localhost to enable builds.'}
                </DialogDescription>
              </DialogHeader>
              {isLocal ? (
                <BuildTrigger onTrigger={handleTriggerBuild} />
              ) : (
                <div className="p-4 bg-muted rounded-lg text-center">
                  <p className="text-sm text-muted-foreground">
                    Builds are only available when running on localhost in development mode.
                  </p>
                </div>
              )}
            </DialogContent>
          </Dialog>
        }
      />

      {/* Active Builds */}
      {activeBuilds.length > 0 && (
        <PageSection className="mt-6">
          <h3 className="text-lg font-semibold mb-4">Active Builds</h3>
          <div className="grid gap-4 md:grid-cols-2">
            {activeBuilds.map((build) => (
              <BuildStatusMonitor
                key={build.id}
                build={build}
                onCancel={() => handleCancelBuild(build.id)}
                onRetry={() => handleRetryBuild(build.id)}
                onDownload={() => {
                  if (build.artifact_url) {
                    window.open(build.artifact_url, '_blank');
                  }
                }}
              />
            ))}
          </div>
        </PageSection>
      )}

      {/* Quick Actions */}
      <PageSection className="mt-6">
        <div className="grid gap-4 md:grid-cols-2">
          <Card>
            <CardHeader>
              <div className="flex items-center gap-3">
                <div className="p-2 bg-gray-100 dark:bg-gray-800 rounded-lg">
                  <Apple className="h-5 w-5" />
                </div>
                <div>
                  <CardTitle className="text-lg">iOS Build</CardTitle>
                  <CardDescription>Build for iPhone and iPad</CardDescription>
                </div>
              </div>
            </CardHeader>
            <CardContent>
              <div className="flex gap-2">
                <Button 
                  className="flex-1"
                  onClick={() => setShowTriggerDialog(true)}
                >
                  <Play className="mr-2 h-4 w-4" />
                  Build IPA
                </Button>
                <Button variant="outline" className="flex-1" disabled>
                  <Clock className="mr-2 h-4 w-4" />
                  TestFlight
                </Button>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <div className="flex items-center gap-3">
                <div className="p-2 bg-green-100 dark:bg-green-900/30 rounded-lg">
                  <Smartphone className="h-5 w-5 text-green-600" />
                </div>
                <div>
                  <CardTitle className="text-lg">Android Build</CardTitle>
                  <CardDescription>Build for Android devices</CardDescription>
                </div>
              </div>
            </CardHeader>
            <CardContent>
              <div className="flex gap-2">
                <Button 
                  className="flex-1"
                  onClick={() => setShowTriggerDialog(true)}
                >
                  <Play className="mr-2 h-4 w-4" />
                  Build APK
                </Button>
                <Button variant="outline" className="flex-1" disabled>
                  <Clock className="mr-2 h-4 w-4" />
                  Build AAB
                </Button>
              </div>
            </CardContent>
          </Card>
        </div>
      </PageSection>

      {/* Build History */}
      <PageSection title="Build History" className="mt-6">
        <Card>
          <CardContent className="pt-6">
            {loading ? (
              <TableSkeleton rows={5} />
            ) : builds.length === 0 ? (
              <EmptyState
                icon={Wrench}
                title="No builds yet"
                description="Start by triggering your first build above"
                action={{
                  label: 'Trigger Build',
                  onClick: () => setShowTriggerDialog(true),
                }}
              />
            ) : (
              <>
                <DataTable
                  columns={columns}
                  data={builds}
                  searchKey="platform"
                  searchPlaceholder="Filter builds..."
                  onRowClick={(build) => {
                    setSelectedBuild(build);
                    setShowBuildDialog(true);
                  }}
                />
                
                {/* Build Details Dialog */}
                <Dialog open={showBuildDialog} onOpenChange={setShowBuildDialog}>
                  <DialogContent className="max-w-3xl max-h-[90vh] overflow-y-auto">
                    {selectedBuild && (
                      <>
                        <DialogHeader>
                          <DialogTitle className="flex items-center gap-2">
                            {selectedBuild.platform === 'ios' ? (
                              <Apple className="h-5 w-5" />
                            ) : (
                              <Smartphone className="h-5 w-5" />
                            )}
                            Build Details
                          </DialogTitle>
                          <DialogDescription>
                            v{selectedBuild.version} ({selectedBuild.build_number})
                          </DialogDescription>
                        </DialogHeader>
                        <BuildStatusMonitor
                          build={selectedBuild}
                          onCancel={() => {
                            handleCancelBuild(selectedBuild.id);
                            setShowBuildDialog(false);
                          }}
                          onRetry={() => {
                            handleRetryBuild(selectedBuild.id);
                            setShowBuildDialog(false);
                          }}
                          onDownload={() => {
                            if (selectedBuild.artifact_url) {
                              window.open(selectedBuild.artifact_url, '_blank');
                            }
                          }}
                        />
                        <div className="flex gap-2 pt-4 border-t">
                          <Button
                            variant="destructive"
                            size="sm"
                            onClick={() => {
                              handleDeleteBuild(selectedBuild.id);
                              setShowBuildDialog(false);
                            }}
                          >
                            <Trash2 className="mr-2 h-4 w-4" />
                            Delete Build
                          </Button>
                        </div>
                      </>
                    )}
                  </DialogContent>
                </Dialog>
              </>
            )}
          </CardContent>
        </Card>
      </PageSection>
    </PageContainer>
  );
}
