'use client';

import { LucideIcon } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { cn } from '@/lib/utils';

interface EmptyStateProps {
  icon?: LucideIcon;
  title: string;
  description?: string;
  action?: {
    label: string;
    onClick: () => void;
    variant?: 'default' | 'outline' | 'secondary' | 'ghost';
  };
  secondaryAction?: {
    label: string;
    onClick: () => void;
    variant?: 'default' | 'outline' | 'secondary' | 'ghost';
  };
  className?: string;
  compact?: boolean;
}

export function EmptyState({
  icon: Icon,
  title,
  description,
  action,
  secondaryAction,
  className,
  compact = false,
}: EmptyStateProps) {
  return (
    <div
      className={cn(
        'flex flex-col items-center justify-center text-center',
        compact ? 'py-8' : 'py-12',
        className
      )}
    >
      {Icon && (
        <div className={cn(
          'rounded-full bg-muted flex items-center justify-center',
          compact ? 'mb-3 p-4' : 'mb-4 p-6'
        )}>
          <Icon className={cn(
            'text-muted-foreground',
            compact ? 'h-6 w-6' : 'h-10 w-10'
          )} />
        </div>
      )}
      <h3 className={cn(
        'font-semibold mb-2',
        compact ? 'text-base' : 'text-lg'
      )}>
        {title}
      </h3>
      {description && (
        <p className={cn(
          'text-muted-foreground max-w-md',
          compact ? 'text-xs mb-4' : 'text-sm mb-6'
        )}>
          {description}
        </p>
      )}
      {(action || secondaryAction) && (
        <div className="flex gap-2">
          {action && (
            <Button
              onClick={action.onClick}
              variant={action.variant || 'default'}
              size={compact ? 'sm' : 'default'}
            >
              {action.label}
            </Button>
          )}
          {secondaryAction && (
            <Button
              onClick={secondaryAction.onClick}
              variant={secondaryAction.variant || 'outline'}
              size={compact ? 'sm' : 'default'}
            >
              {secondaryAction.label}
            </Button>
          )}
        </div>
      )}
    </div>
  );
}
