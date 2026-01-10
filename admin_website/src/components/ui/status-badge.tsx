'use client';

import { cn } from '@/lib/utils';
import { CheckCircle2, XCircle, AlertTriangle, Clock, Info, Circle } from 'lucide-react';

type Status =
  | 'success'
  | 'error'
  | 'failed'
  | 'warning'
  | 'info'
  | 'pending'
  | 'active'
  | 'inactive'
  | 'building'
  | 'queued'
  | 'cancelled';

interface StatusBadgeProps {
  status: Status;
  label?: string;
  showIcon?: boolean;
  className?: string;
  size?: 'sm' | 'md' | 'lg';
}

const statusConfig: Record<
  Status,
  {
    label: string;
    className: string;
    icon: typeof CheckCircle2;
  }
> = {
  success: {
    label: 'Success',
    className: 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400',
    icon: CheckCircle2,
  },
  error: {
    label: 'Error',
    className: 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400',
    icon: XCircle,
  },
  failed: {
    label: 'Failed',
    className: 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400',
    icon: XCircle,
  },
  warning: {
    label: 'Warning',
    className: 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400',
    icon: AlertTriangle,
  },
  info: {
    label: 'Info',
    className: 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400',
    icon: Info,
  },
  pending: {
    label: 'Pending',
    className: 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400',
    icon: Clock,
  },
  active: {
    label: 'Active',
    className: 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400',
    icon: CheckCircle2,
  },
  inactive: {
    label: 'Inactive',
    className: 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400',
    icon: Circle,
  },
  building: {
    label: 'Building',
    className: 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400',
    icon: Clock,
  },
  queued: {
    label: 'Queued',
    className: 'bg-purple-100 text-purple-800 dark:bg-purple-900/30 dark:text-purple-400',
    icon: Clock,
  },
  cancelled: {
    label: 'Cancelled',
    className: 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400',
    icon: XCircle,
  },
};

const sizeConfig = {
  sm: {
    badge: 'text-xs px-2 py-0.5',
    icon: 'h-3 w-3',
  },
  md: {
    badge: 'text-sm px-2.5 py-0.5',
    icon: 'h-3.5 w-3.5',
  },
  lg: {
    badge: 'text-sm px-3 py-1',
    icon: 'h-4 w-4',
  },
};

export function StatusBadge({
  status,
  label,
  showIcon = true,
  className,
  size = 'md',
}: StatusBadgeProps) {
  const config = statusConfig[status];
  const sizeClass = sizeConfig[size];
  const Icon = config.icon;

  return (
    <span
      className={cn(
        'inline-flex items-center gap-1.5 rounded-full font-medium',
        config.className,
        sizeClass.badge,
        className
      )}
    >
      {showIcon && <Icon className={sizeClass.icon} />}
      {label || config.label}
    </span>
  );
}

// Animated version for building status
interface AnimatedStatusBadgeProps extends StatusBadgeProps {
  animate?: boolean;
}

export function AnimatedStatusBadge({
  animate = true,
  ...props
}: AnimatedStatusBadgeProps) {
  const isAnimating = animate && (props.status === 'building' || props.status === 'queued');

  return (
    <span className="relative inline-flex">
      <StatusBadge {...props} />
      {isAnimating && (
        <span className="absolute top-0 right-0 -mt-1 -mr-1 flex h-3 w-3">
          <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-blue-400 opacity-75" />
          <span className="relative inline-flex rounded-full h-3 w-3 bg-blue-500" />
        </span>
      )}
    </span>
  );
}
