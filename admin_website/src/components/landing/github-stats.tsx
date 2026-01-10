'use client';

import { useEffect, useState } from 'react';
import { Badge } from '@/components/ui/badge';
import { Skeleton } from '@/components/ui/skeleton';
import { GitHubService, type GitHubStats } from '@/lib/services/github.service';
import { 
  Star, 
  GitFork, 
  AlertCircle, 
  GitPullRequest, 
  Users, 
  Calendar,
  FileText,
  ExternalLink,
} from 'lucide-react';

interface StatBadgeProps {
  icon: React.ReactNode;
  value: string | number;
  loading?: boolean;
  href?: string;
}

function StatBadge({ icon, value, loading, href }: StatBadgeProps) {
  const content = (
    <Badge variant="outline" className="gap-1.5">
      {icon}
      {loading ? <Skeleton className="h-4 w-8" /> : <span>{value}</span>}
    </Badge>
  );

  if (href) {
    return (
      <a
        href={href}
        target="_blank"
        rel="noopener noreferrer"
        className="inline-block"
      >
        {content}
      </a>
    );
  }

  return content;
}

export function GitHubStats() {
  const [stats, setStats] = useState<GitHubStats | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    GitHubService.getStats().then((data) => {
      setStats(data);
      setLoading(false);
    });
  }, []);

  const formatNumber = (num: number) => {
    if (num >= 1000) {
      return `${(num / 1000).toFixed(1)}k`;
    }
    return num.toString();
  };

  return (
    <section className="py-12">
      <div className="container mx-auto px-4">
        <div className="mb-6 text-center">
          <h2 className="text-xl font-semibold mb-1">GitHub</h2>
        </div>

        <div className="flex flex-wrap items-center justify-center gap-2">
          <StatBadge
            icon={<Star className="h-3 w-3" />}
            value={loading ? '...' : formatNumber(stats?.stars || 0)}
            loading={loading}
            href={stats?.url ? `${stats.url}/stargazers` : undefined}
          />
          <StatBadge
            icon={<GitFork className="h-3 w-3" />}
            value={loading ? '...' : formatNumber(stats?.forks || 0)}
            loading={loading}
            href={stats?.url ? `${stats.url}/network/members` : undefined}
          />
          <StatBadge
            icon={<AlertCircle className="h-3 w-3" />}
            value={loading ? '...' : formatNumber(stats?.openIssues || 0)}
            loading={loading}
            href={stats?.url ? `${stats.url}/issues` : undefined}
          />
          <StatBadge
            icon={<GitPullRequest className="h-3 w-3" />}
            value={loading ? '...' : formatNumber(stats?.openPulls || 0)}
            loading={loading}
            href={stats?.url ? `${stats.url}/pulls` : undefined}
          />
          <StatBadge
            icon={<Users className="h-3 w-3" />}
            value={loading ? '...' : formatNumber(stats?.contributors || 0)}
            loading={loading}
            href={stats?.url ? `${stats.url}/graphs/contributors` : undefined}
          />
          <StatBadge
            icon={<Calendar className="h-3 w-3" />}
            value={loading ? '...' : GitHubService.formatDate(stats?.lastCommit || null)}
            loading={loading}
          />
          <StatBadge
            icon={<FileText className="h-3 w-3" />}
            value={loading ? '...' : stats?.license || 'AGPL-3.0'}
            loading={loading}
          />
          {stats?.url && (
            <a
              href={stats.url}
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-1 text-xs text-muted-foreground hover:text-foreground"
            >
              <ExternalLink className="h-3 w-3" />
            </a>
          )}
        </div>
      </div>
    </section>
  );
}
