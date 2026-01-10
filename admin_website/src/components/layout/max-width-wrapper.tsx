'use client';

import { cn } from '@/lib/utils';
import { ReactNode } from 'react';

interface MaxWidthWrapperProps {
  children: ReactNode;
  className?: string;
  maxWidth?: 'sm' | 'md' | 'lg' | 'xl' | '2xl' | '7xl' | 'full';
}

export function MaxWidthWrapper({
  children,
  className,
  maxWidth = '7xl',
}: MaxWidthWrapperProps) {
  const maxWidthClass = {
    sm: 'max-w-screen-sm',
    md: 'max-w-screen-md',
    lg: 'max-w-screen-lg',
    xl: 'max-w-screen-xl',
    '2xl': 'max-w-screen-2xl',
    '7xl': 'max-w-7xl',
    full: 'max-w-full',
  }[maxWidth];

  return (
    <div className={cn('mx-auto w-full px-4 md:px-6 lg:px-8', maxWidthClass, className)}>
      {children}
    </div>
  );
}
