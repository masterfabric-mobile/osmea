'use client';

import { useEffect, useState } from 'react';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Skeleton } from '@/components/ui/skeleton';
import { GitHubService, type GitHubStats } from '@/lib/services/github.service';
import { Rocket, Star, GitFork, AlertCircle, GitPullRequest, Users, Calendar, FileText } from 'lucide-react';
import Link from 'next/link';

interface StatBadgeProps {
  icon: React.ReactNode;
  value: string | number;
  loading?: boolean;
  href?: string;
}

function StatBadge({ icon, value, loading, href }: StatBadgeProps) {
  const content = (
    <Badge variant="outline" className="gap-1.5 bg-white/80 dark:bg-gray-800/80 backdrop-blur-sm">
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

export function HeroSection() {
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
    <section className="relative overflow-hidden bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 dark:from-gray-900 dark:via-gray-800 dark:to-gray-900 py-12 lg:py-16">
      <div className="absolute inset-0 bg-grid-pattern opacity-5"></div>
      <div className="container mx-auto px-4 relative z-10">
        <div className="max-w-4xl mx-auto text-center">
          {/* Logo/Brand */}
          <div className="mb-6">
            <div className="inline-flex items-center justify-center w-16 h-16 rounded-xl bg-primary mb-4 shadow-lg">
              <span className="text-3xl font-bold text-primary-foreground">O</span>
            </div>
            <h1 className="text-4xl lg:text-5xl font-bold mb-3 bg-gradient-to-r from-blue-600 via-indigo-600 to-purple-600 bg-clip-text text-transparent">
              OSMEA Storefront Woo
            </h1>
            <h2 className="text-xl lg:text-2xl font-semibold text-gray-700 dark:text-gray-300 mb-2">
              Offline Admin Panel
            </h2>
            <p className="text-base lg:text-lg text-gray-600 dark:text-gray-400 max-w-2xl mx-auto">
              <span className="font-semibold bg-gradient-to-r from-green-600 via-emerald-600 to-teal-600 bg-clip-text text-transparent">Open source</span> admin panel for your <strong className="underline decoration-2 decoration-primary">WooCommerce</strong> mobile app. 
              <strong>Build</strong>, <strong>configure</strong>, and <strong>deploy</strong> with ease.
            </p>
          </div>

          {/* CTAs */}
          <div className="flex flex-col sm:flex-row gap-4 justify-center items-center mt-6">
            <Button size="lg" className="text-lg px-8 py-6" asChild>
              <Link href="/onboarding">
                <Rocket className="mr-2 h-5 w-5" />
                Get Started
              </Link>
            </Button>
          </div>

          {/* GitHub Stats */}
          <div className="mt-6">
            <div className="mb-3 text-center">
              <h3 className="text-xl font-semibold text-gray-700 dark:text-gray-300 mb-3">GitHub</h3>
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
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
