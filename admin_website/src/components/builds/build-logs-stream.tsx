'use client';

import { useEffect, useState, useRef } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Loader2, X, Copy, Check } from 'lucide-react';
import { toast } from 'sonner';

interface BuildLogsStreamProps {
  buildId: string;
  onComplete?: (status: 'success' | 'failed', artifactPath?: string) => void;
  onCancel?: () => void;
}

export function BuildLogsStream({ buildId, onComplete, onCancel }: BuildLogsStreamProps) {
  const [logs, setLogs] = useState<string[]>([]);
  const [status, setStatus] = useState<'building' | 'success' | 'failed' | 'cancelled'>('building');
  const [artifactPath, setArtifactPath] = useState<string | undefined>();
  const [copied, setCopied] = useState(false);
  const scrollAreaRef = useRef<HTMLDivElement>(null);
  const eventSourceRef = useRef<EventSource | null>(null);

  useEffect(() => {
    if (!buildId) return;

    // Create EventSource for SSE
    const eventSource = new EventSource(`/api/build/local?buildId=${buildId}`);
    eventSourceRef.current = eventSource;

    // Handle status updates
    eventSource.addEventListener('status', (event) => {
      const data = JSON.parse(event.data);
      setStatus(data.status);
      if (data.artifactPath) {
        setArtifactPath(data.artifactPath);
      }
    });

    // Handle log lines
    eventSource.addEventListener('log', (event) => {
      const data = JSON.parse(event.data);
      setLogs((prev) => [...prev, data.line]);
      
      // Auto-scroll to bottom
      setTimeout(() => {
        if (scrollAreaRef.current) {
          const scrollContainer = scrollAreaRef.current.querySelector('[data-radix-scroll-area-viewport]');
          if (scrollContainer) {
            scrollContainer.scrollTop = scrollContainer.scrollHeight;
          }
        }
      }, 100);
    });

    // Handle completion
    eventSource.addEventListener('complete', (event) => {
      const data = JSON.parse(event.data);
      setStatus(data.status);
      if (data.artifactPath) {
        setArtifactPath(data.artifactPath);
      }
      eventSource.close();
      if (onComplete) {
        onComplete(data.status, data.artifactPath);
      }
    });

    // Handle errors
    eventSource.onerror = (error) => {
      console.error('SSE error:', error);
      setLogs((prev) => [...prev, '[ERROR] Connection lost']);
      eventSource.close();
    };

    // Cleanup
    return () => {
      eventSource.close();
    };
  }, [buildId, onComplete]);

  const handleCancel = async () => {
    try {
      const response = await fetch(`/api/build/local?buildId=${buildId}`, {
        method: 'DELETE',
      });

      if (response.ok) {
        setStatus('cancelled');
        setLogs((prev) => [...prev, '[INFO] Build cancelled']);
        if (eventSourceRef.current) {
          eventSourceRef.current.close();
        }
        if (onCancel) {
          onCancel();
        }
      } else {
        toast.error('Failed to cancel build');
      }
    } catch (error) {
      console.error('Cancel error:', error);
      toast.error('Failed to cancel build');
    }
  };

  const handleCopyLogs = async () => {
    try {
      await navigator.clipboard.writeText(logs.join('\n'));
      setCopied(true);
      toast.success('Logs copied to clipboard');
      setTimeout(() => setCopied(false), 2000);
    } catch (error) {
      toast.error('Failed to copy logs');
    }
  };

  const getStatusColor = () => {
    switch (status) {
      case 'success':
        return 'text-green-600';
      case 'failed':
        return 'text-red-600';
      case 'cancelled':
        return 'text-gray-600';
      default:
        return 'text-blue-600';
    }
  };

  return (
    <Card>
      <CardHeader className="pb-3">
        <div className="flex items-center justify-between">
          <CardTitle className="text-lg">Build Logs</CardTitle>
          <div className="flex items-center gap-2">
            {status === 'building' && (
              <>
                <Loader2 className="h-4 w-4 animate-spin text-blue-600" />
                <span className="text-sm text-muted-foreground">Building...</span>
              </>
            )}
            {status === 'success' && (
              <span className="text-sm text-green-600 font-medium">✓ Build Successful</span>
            )}
            {status === 'failed' && (
              <span className="text-sm text-red-600 font-medium">✗ Build Failed</span>
            )}
            {status === 'cancelled' && (
              <span className="text-sm text-gray-600 font-medium">Build Cancelled</span>
            )}
            {status === 'building' && (
              <Button
                variant="outline"
                size="sm"
                onClick={handleCancel}
                className="h-8"
              >
                <X className="h-3 w-3 mr-1" />
                Cancel
              </Button>
            )}
            <Button
              variant="ghost"
              size="sm"
              onClick={handleCopyLogs}
              className="h-8"
            >
              {copied ? (
                <Check className="h-3 w-3" />
              ) : (
                <Copy className="h-3 w-3" />
              )}
            </Button>
          </div>
        </div>
      </CardHeader>
      <CardContent>
        <ScrollArea className="h-[400px] w-full" ref={scrollAreaRef}>
          <div className="font-mono text-xs bg-black text-green-400 p-4 rounded-md">
            {logs.length === 0 ? (
              <div className="text-muted-foreground">Waiting for build logs...</div>
            ) : (
              logs.map((log, index) => {
                // Color code different log types
                let className = 'text-green-400';
                if (log.includes('[ERROR]') || log.includes('error') || log.includes('Error')) {
                  className = 'text-red-400';
                } else if (log.includes('[WARN]') || log.includes('warning') || log.includes('Warning')) {
                  className = 'text-yellow-400';
                } else if (log.includes('[INFO]') || log.includes('info') || log.includes('Info')) {
                  className = 'text-blue-400';
                } else if (log.includes('✓') || log.includes('success') || log.includes('Success')) {
                  className = 'text-green-400';
                }

                return (
                  <div key={index} className={className}>
                    {log}
                  </div>
                );
              })
            )}
            {status === 'building' && (
              <div className="text-green-400 animate-pulse">
                ▋
              </div>
            )}
          </div>
        </ScrollArea>
        {artifactPath && status === 'success' && (
          <div className="mt-4 p-3 bg-green-50 dark:bg-green-900/20 rounded-md">
            <p className="text-sm font-medium text-green-900 dark:text-green-100 mb-1">
              Build Artifact:
            </p>
            <p className="text-xs text-green-700 dark:text-green-300 font-mono break-all">
              {artifactPath}
            </p>
          </div>
        )}
      </CardContent>
    </Card>
  );
}
