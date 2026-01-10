'use client';

import { useEffect, useState, useRef } from 'react';
import { supabase } from '@/lib/supabase/client';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Button } from '@/components/ui/button';
import { cn } from '@/lib/utils';
import { Download, Copy, Check, AlertCircle, Info, AlertTriangle, Bug } from 'lucide-react';
import { toast } from 'sonner';
import type { BuildLog } from '@/lib/types/build.types';

interface BuildLogsProps {
  buildId: string;
  autoScroll?: boolean;
  maxHeight?: string;
}

export function BuildLogs({ buildId, autoScroll = true, maxHeight = '500px' }: BuildLogsProps) {
  const [logs, setLogs] = useState<BuildLog[]>([]);
  const [loading, setLoading] = useState(true);
  const [copied, setCopied] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    fetchLogs();

    // Subscribe to new logs in real-time
    if (supabase) {
      const client = supabase;
      const channel = client
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
        client.removeChannel(channel);
      };
    }
  }, [buildId]);

  useEffect(() => {
    if (autoScroll && scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
    }
  }, [logs, autoScroll]);

  async function fetchLogs() {
    if (!supabase) {
      setLoading(false);
      return;
    }

    try {
      const { data, error } = await supabase
        .from('build_logs')
        .select('*')
        .eq('build_id', buildId)
        .order('timestamp', { ascending: true });

      if (error) throw error;
      setLogs(data || []);
    } catch (error) {
      console.error('Error fetching logs:', error);
    } finally {
      setLoading(false);
    }
  }

  const getLogIcon = (level: string) => {
    switch (level) {
      case 'error':
      case 'critical':
        return <AlertCircle className="h-3 w-3" />;
      case 'warning':
        return <AlertTriangle className="h-3 w-3" />;
      case 'debug':
        return <Bug className="h-3 w-3" />;
      default:
        return <Info className="h-3 w-3" />;
    }
  };

  const getLogColor = (level: string) => {
    switch (level) {
      case 'error':
      case 'critical':
        return 'text-red-400';
      case 'warning':
        return 'text-yellow-400';
      case 'debug':
        return 'text-gray-500';
      case 'info':
        return 'text-blue-400';
      default:
        return 'text-green-400';
    }
  };

  const handleCopyLogs = async () => {
    const logText = logs
      .map(
        (log) =>
          `[${new Date(log.timestamp).toISOString()}] [${log.log_level.toUpperCase()}]${
            log.step ? ` [${log.step}]` : ''
          } ${log.message}`
      )
      .join('\n');

    try {
      await navigator.clipboard.writeText(logText);
      setCopied(true);
      toast.success('Logs copied to clipboard');
      setTimeout(() => setCopied(false), 2000);
    } catch {
      toast.error('Failed to copy logs');
    }
  };

  const handleDownloadLogs = () => {
    const logText = logs
      .map(
        (log) =>
          `[${new Date(log.timestamp).toISOString()}] [${log.log_level.toUpperCase()}]${
            log.step ? ` [${log.step}]` : ''
          } ${log.message}`
      )
      .join('\n');

    const blob = new Blob([logText], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `build-${buildId}-logs.txt`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  };

  return (
    <div className="rounded-lg border overflow-hidden">
      {/* Toolbar */}
      <div className="flex items-center justify-between px-4 py-2 bg-muted border-b">
        <span className="text-sm font-medium">Build Logs</span>
        <div className="flex items-center gap-2">
          <Button variant="ghost" size="sm" onClick={handleCopyLogs}>
            {copied ? (
              <Check className="h-4 w-4 text-green-500" />
            ) : (
              <Copy className="h-4 w-4" />
            )}
          </Button>
          <Button variant="ghost" size="sm" onClick={handleDownloadLogs}>
            <Download className="h-4 w-4" />
          </Button>
        </div>
      </div>

      {/* Log Content */}
      <ScrollArea style={{ height: maxHeight }} ref={scrollRef}>
        <div className="font-mono text-sm bg-gray-950 text-gray-100 p-4 min-h-full">
          {loading ? (
            <div className="flex items-center gap-2 text-gray-500">
              <span className="animate-pulse">Loading logs...</span>
            </div>
          ) : logs.length === 0 ? (
            <div className="text-gray-500">No logs available yet...</div>
          ) : (
            <div className="space-y-1">
              {logs.map((log) => (
                <div key={log.id} className="flex items-start gap-2 leading-relaxed">
                  <span className="text-gray-500 flex-shrink-0 w-20">
                    {new Date(log.timestamp).toLocaleTimeString()}
                  </span>
                  <span
                    className={cn(
                      'flex items-center gap-1 flex-shrink-0 w-20',
                      getLogColor(log.log_level)
                    )}
                  >
                    {getLogIcon(log.log_level)}
                    <span className="uppercase text-xs">{log.log_level}</span>
                  </span>
                  {log.step && (
                    <span className="text-purple-400 flex-shrink-0">
                      [{log.step}]
                    </span>
                  )}
                  <span className="text-gray-100 break-all">{log.message}</span>
                </div>
              ))}
            </div>
          )}
        </div>
      </ScrollArea>
    </div>
  );
}
