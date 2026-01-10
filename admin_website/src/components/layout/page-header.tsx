'use client';

import { ReactNode } from 'react';
import { Button } from '@/components/ui/button';
import { ArrowLeft, RefreshCw } from 'lucide-react';
import Link from 'next/link';

interface PageHeaderProps {
  title: string;
  description?: string;
  backLink?: string;
  backLabel?: string;
  actions?: ReactNode;
  onRefresh?: () => void;
  refreshing?: boolean;
}

export function PageHeader({
  title,
  description,
  backLink,
  backLabel = 'Back',
  actions,
  onRefresh,
  refreshing = false,
}: PageHeaderProps) {
  return (
    <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
      <div className="space-y-1">
        {backLink && (
          <Button variant="ghost" size="sm" asChild className="mb-2 -ml-3">
            <Link href={backLink}>
              <ArrowLeft className="w-4 h-4 mr-2" />
              {backLabel}
            </Link>
          </Button>
        )}
        <h1 className="text-2xl font-bold tracking-tight md:text-3xl">{title}</h1>
        {description && (
          <p className="text-muted-foreground">{description}</p>
        )}
      </div>
      {(actions || onRefresh) && (
        <div className="flex items-center gap-2">
          {onRefresh && (
            <Button
              variant="outline"
              size="icon"
              onClick={onRefresh}
              disabled={refreshing}
            >
              <RefreshCw className={`h-4 w-4 ${refreshing ? 'animate-spin' : ''}`} />
            </Button>
          )}
          {actions}
        </div>
      )}
    </div>
  );
}

interface PageContainerProps {
  children: ReactNode;
  className?: string;
}

export function PageContainer({ children, className }: PageContainerProps) {
  return (
    <div className={`p-4 md:p-6 lg:p-8 ${className || ''}`}>
      {children}
    </div>
  );
}

interface PageSectionProps {
  title?: string;
  description?: string;
  children: ReactNode;
  className?: string;
  actions?: ReactNode;
}

export function PageSection({
  title,
  description,
  children,
  className,
  actions,
}: PageSectionProps) {
  return (
    <section className={`space-y-4 ${className || ''}`}>
      {(title || description || actions) && (
        <div className="flex items-center justify-between">
          <div>
            {title && <h2 className="text-lg font-semibold">{title}</h2>}
            {description && (
              <p className="text-sm text-muted-foreground">{description}</p>
            )}
          </div>
          {actions && <div className="flex items-center gap-2">{actions}</div>}
        </div>
      )}
      {children}
    </section>
  );
}
