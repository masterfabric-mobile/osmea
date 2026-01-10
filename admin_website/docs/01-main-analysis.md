# Storefront WooCommerce Admin Panel - Technical Analysis & Architecture

**Project:** OSMEA Storefront WooCommerce
**Document Version:** 2.0.0
**Date:** 2026-01-09
**Technology Stack:** Next.js 15 + TypeScript + Supabase
**Analysis Type:** Admin Panel Implementation with Supabase Integration & Offline Support

---

## 📋 Executive Summary

This document provides a comprehensive technical analysis for building an **Admin Panel** for the Storefront WooCommerce Flutter mobile application. The admin panel will be built as a **Next.js 15** web application using **TypeScript** to manage app configurations, WooCommerce settings, and provide API-side management through **Supabase**. The solution includes **offline-first capabilities** with a splash screen that transitions to Supabase onboarding/settings before continuing to the main panel.

---

## 🎯 Project Overview

### Current State Analysis

**Storefront WooCommerce Mobile App (Flutter):**

- **Platform:** Flutter 3.8+, Dart 3.8+
- **State Management:** BLoC Pattern (flutter_bloc)
- **Architecture:** Multi-layer (Core, APIs, Components packages)
- **Navigation:** GoRouter with declarative routing
- **DI:** GetIt + Injectable
- **Localization:** Slang (JSON-based i18n)
- **Backend:** WooCommerce REST API integration
- **Configuration:** JSON-based (app_config.json) with Firebase Remote Config support

**Mobile App Key Features:**

- E-commerce storefront with product catalog, cart, checkout
- User authentication (JWT-based)
- WooCommerce API integration
- Multi-environment support (dev/prod)
- Offline cart persistence
- Wishlist, orders, categories, search
- Responsive UI with Shadcn ui

**Admin Panel (New - Next.js):**

- **Platform:** Next.js 15 (App Router)
- **Language:** TypeScript
- **UI Framework:** React 19
- **Styling:** Tailwind CSS + shadcn/ui
- **State Management:** Zustand / Jotai
- **Backend:** Supabase (PostgreSQL + Auth + Storage + Realtime)
- **API:** Next.js API Routes + Server Actions
- **Deployment:** Vercel / Netlify

---

## 🎨 Admin Panel Requirements

### Functional Requirements

#### 1. **Configuration Management**

- Manage `app_config.json` settings remotely
- WooCommerce connection settings (store URL, auth key, API version)
- UI configuration (theme colors, fonts, layout settings)
- Feature flags (enable/disable features)
- Account page configuration (sections, menu items)
- Home page components (banners, campaigns, categories)
- Navigation bar configuration
- Splash & onboarding settings
- Search & empty state configurations

#### 2. **Store Management**

- Product management (CRUD operations)
- Category management
- Order tracking & management
- Customer management
- Inventory monitoring
- Promotional campaigns
- Discount & coupon management

#### 3. **Analytics & Monitoring**

- Sales analytics
- User behavior tracking
- Product performance metrics
- Real-time order notifications
- System health monitoring

#### 4. **User & Access Management**

- Admin user roles (Super Admin, Store Manager, Content Editor)
- Permission-based access control
- Audit logs for sensitive operations

#### 5. **Build Management (Fastlane Integration)**

- Generate IPA (iOS) builds locally
- Generate APK/AAB (Android) builds locally
- Real-time build status monitoring
- Build logs viewer with live updates
- Build history and versioning
- Code signing management
- Distribution to TestFlight/Play Console
- Environment-specific builds (dev/staging/prod)

---

## 🏗️ Proposed Architecture

### System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│              ADMIN PANEL (Next.js 15 + TypeScript)           │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │  Splash +   │→ │  Supabase    │→ │  Dashboard &     │  │
│  │  Onboarding │  │  Setup       │  │  Management      │  │
│  └─────────────┘  └──────────────┘  └──────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  React Server Components + Server Actions            │  │
│  │  API Routes + Middleware                              │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                           ↕
┌─────────────────────────────────────────────────────────────┐
│                      SUPABASE BACKEND                        │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐ │
│  │  PostgreSQL  │  │  Auth        │  │  Storage         │ │
│  │  Database    │  │  (JWT-based) │  │  (Media files)   │ │
│  └──────────────┘  └──────────────┘  └──────────────────┘ │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐ │
│  │  Realtime    │  │  Edge        │  │  Row Level       │ │
│  │  Subscriptions│  │  Functions   │  │  Security (RLS)  │ │
│  └──────────────┘  └──────────────┘  └──────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                           ↕
┌─────────────────────────────────────────────────────────────┐
│                    WOOCOMMERCE API                           │
├─────────────────────────────────────────────────────────────┤
│  Products │ Orders │ Customers │ Categories │ Coupons       │
└─────────────────────────────────────────────────────────────┘
                           ↕
┌─────────────────────────────────────────────────────────────┐
│              FLUTTER MOBILE APP (Consumers)                  │
├─────────────────────────────────────────────────────────────┤
│  Reads app_config.json from Supabase Storage                │
│  Syncs with WooCommerce API for products/orders             │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow Architecture

```
┌──────────────────────────┐
│  Next.js Admin Panel UI  │
│  (React Components)      │
└────────┬─────────────────┘
         │
         ↓
┌──────────────────────────┐
│  State Management        │
│  - Zustand Stores        │
│  - React Server State    │
│  - React Context         │
└────────┬─────────────────┘
         │
         ↓
┌──────────────────────────────────────────────┐
│  Next.js Server Layer                        │
│  - Server Actions (mutations)                │
│  - Server Components (data fetching)         │
│  - API Routes (REST endpoints)               │
│  - Middleware (auth, logging)                │
└────────┬─────────────────────────────────────┘
         │
         ↓
┌──────────────────────────┐      ┌──────────────────┐
│  Service Layer           │←────→│  Local Storage   │
│  - SupabaseClient        │      │  (IndexedDB)     │
│  - WooCommerceClient     │      │  - Offline Cache │
│  - SyncService           │      │  - Sync Queue    │
└────────┬─────────────────┘      └──────────────────┘
         │
         ├────────────┐
         ↓            ↓
┌────────────┐  ┌────────────────┐
│  Supabase  │  │  WooCommerce   │
│  Backend   │  │  REST API      │
└────────────┘  └────────────────┘
```

---

## 🛠️ Technical Implementation

### 1. Project Structure

```
projects/admin_panel/
├── src/
│   ├── app/
│   │   ├── (auth)/              # Auth group routes
│   │   │   ├── login/
│   │   │   │   └── page.tsx
│   │   │   └── setup/
│   │   │       ├── page.tsx     # Setup wizard main
│   │   │       ├── supabase/
│   │   │       │   └── page.tsx # Supabase config step
│   │   │       ├── woocommerce/
│   │   │       │   └── page.tsx # WooCommerce config step
│   │   │       └── fastlane/
│   │   │           └── page.tsx # Fastlane config step
│   │   ├── (dashboard)/         # Protected dashboard routes
│   │   │   ├── layout.tsx       # Dashboard layout
│   │   │   ├── page.tsx         # Dashboard home
│   │   │   ├── config/
│   │   │   │   └── page.tsx     # Config management
│   │   │   ├── products/
│   │   │   │   ├── page.tsx     # Product list
│   │   │   │   └── [id]/
│   │   │   │       └── page.tsx # Product detail
│   │   │   ├── orders/
│   │   │   │   └── page.tsx     # Order management
│   │   │   ├── builds/
│   │   │   │   ├── page.tsx     # Build management
│   │   │   │   ├── history/
│   │   │   │   │   └── page.tsx # Build history
│   │   │   │   └── [id]/
│   │   │   │       └── page.tsx # Build details
│   │   │   ├── analytics/
│   │   │   │   └── page.tsx     # Analytics dashboard
│   │   │   └── settings/
│   │   │       └── page.tsx     # App settings
│   │   ├── api/                 # API routes
│   │   │   ├── config/
│   │   │   │   └── route.ts
│   │   │   ├── sync/
│   │   │   │   └── route.ts
│   │   │   ├── woocommerce/
│   │   │   │   └── route.ts
│   │   │   └── builds/
│   │   │       ├── trigger/
│   │   │       │   └── route.ts # Trigger build
│   │   │       ├── status/
│   │   │       │   └── route.ts # Get build status
│   │   │       └── logs/
│   │   │           └── route.ts # Stream build logs
│   │   ├── layout.tsx           # Root layout
│   │   └── page.tsx             # Splash/landing page
│   ├── components/
│   │   ├── ui/                  # shadcn/ui components
│   │   │   ├── button.tsx
│   │   │   ├── card.tsx
│   │   │   ├── dialog.tsx
│   │   │   ├── badge.tsx
│   │   │   ├── progress.tsx
│   │   │   ├── skeleton.tsx
│   │   │   ├── scroll-area.tsx
│   │   │   ├── command.tsx
│   │   │   └── ...
│   │   ├── dashboard/           # Dashboard-specific components
│   │   │   ├── overview-cards.tsx
│   │   │   ├── recent-orders.tsx
│   │   │   ├── analytics-chart.tsx
│   │   │   └── quick-actions.tsx
│   │   ├── config/              # Config editor components
│   │   │   ├── config-editor.tsx
│   │   │   ├── json-viewer.tsx
│   │   │   ├── version-history.tsx
│   │   │   └── config-field.tsx
│   │   ├── builds/              # Build management components
│   │   │   ├── build-trigger.tsx
│   │   │   ├── build-status.tsx
│   │   │   ├── build-logs.tsx
│   │   │   ├── build-history.tsx
│   │   │   └── build-card.tsx
│   │   ├── wizard/              # Setup wizard components
│   │   │   ├── wizard-container.tsx
│   │   │   ├── wizard-step.tsx
│   │   │   ├── wizard-progress.tsx
│   │   │   └── wizard-navigation.tsx
│   │   └── layout/              # Layout components
│   │       ├── sidebar.tsx
│   │       ├── navbar.tsx
│   │       ├── footer.tsx
│   │       └── max-width-wrapper.tsx
│   ├── lib/
│   │   ├── supabase/
│   │   │   ├── client.ts        # Supabase client
│   │   │   ├── server.ts        # Server-side client
│   │   │   └── middleware.ts    # Auth middleware
│   │   ├── woocommerce/
│   │   │   └── client.ts        # WooCommerce API client
│   │   ├── fastlane/
│   │   │   ├── client.ts        # Fastlane command executor
│   │   │   ├── parser.ts        # Parse build logs
│   │   │   └── config.ts        # Fastlane config manager
│   │   ├── services/
│   │   │   ├── config.service.ts
│   │   │   ├── product.service.ts
│   │   │   ├── order.service.ts
│   │   │   ├── sync.service.ts
│   │   │   └── build.service.ts # Build management
│   │   ├── stores/              # Zustand stores
│   │   │   ├── config.store.ts
│   │   │   ├── auth.store.ts
│   │   │   ├── sync.store.ts
│   │   │   └── build.store.ts
│   │   ├── types/               # TypeScript types
│   │   │   ├── config.types.ts
│   │   │   ├── product.types.ts
│   │   │   ├── supabase.types.ts
│   │   │   └── build.types.ts
│   │   └── utils/               # Utility functions
│   │       ├── db.ts            # IndexedDB helpers
│   │       ├── sync.ts          # Sync utilities
│   │       ├── validators.ts
│   │       └── cn.ts            # Class name merger
│   └── actions/                 # Server actions
│       ├── config.actions.ts
│       ├── product.actions.ts
│       ├── order.actions.ts
│       └── build.actions.ts
├── public/
│   ├── images/
│   └── icons/
├── supabase/
│   ├── migrations/              # Database migrations
│   │   ├── 001_initial_schema.sql
│   │   ├── 002_rls_policies.sql
│   │   └── 003_build_tables.sql
│   └── functions/               # Edge functions
│       ├── sync-config/
│       │   └── index.ts
│       └── build-webhook/
│           └── index.ts
├── fastlane/                    # Fastlane configuration
│   ├── Fastfile                 # Build lanes
│   ├── Appfile                  # App metadata
│   └── Matchfile                # Code signing
├── .env.local                   # Environment variables
├── .env.example
├── next.config.js
├── tailwind.config.ts
├── tsconfig.json
├── components.json              # shadcn/ui config
├── package.json
└── README.md
```

### 2. Database Schema (Supabase PostgreSQL)

#### Table: `app_configurations`

```sql
CREATE TABLE app_configurations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id),
  config_key VARCHAR(255) NOT NULL,
  config_value JSONB NOT NULL,
  version INTEGER NOT NULL DEFAULT 1,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id),
  UNIQUE(store_id, config_key)
);

-- Indexes
CREATE INDEX idx_app_configs_store ON app_configurations(store_id);
CREATE INDEX idx_app_configs_active ON app_configurations(is_active);
```

#### Table: `stores`

```sql
CREATE TABLE stores (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  woo_store_url VARCHAR(500) NOT NULL,
  woo_consumer_key VARCHAR(255),
  woo_consumer_secret VARCHAR(255),
  woo_auth_key TEXT,
  brand_name VARCHAR(100),
  status VARCHAR(50) DEFAULT 'active',
  settings JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### Table: `sync_queue`

```sql
CREATE TABLE sync_queue (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id),
  entity_type VARCHAR(100) NOT NULL, -- 'config', 'product', 'order', etc.
  entity_id VARCHAR(255),
  operation VARCHAR(50) NOT NULL, -- 'create', 'update', 'delete'
  payload JSONB NOT NULL,
  status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'syncing', 'completed', 'failed'
  retry_count INTEGER DEFAULT 0,
  error_message TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  synced_at TIMESTAMP WITH TIME ZONE
);

-- Indexes
CREATE INDEX idx_sync_queue_status ON sync_queue(status);
CREATE INDEX idx_sync_queue_store ON sync_queue(store_id);
```

#### Table: `admin_users`

```sql
CREATE TABLE admin_users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  auth_user_id UUID NOT NULL REFERENCES auth.users(id),
  store_id UUID NOT NULL REFERENCES stores(id),
  role VARCHAR(50) NOT NULL, -- 'super_admin', 'store_manager', 'content_editor'
  permissions JSONB,
  is_active BOOLEAN DEFAULT true,
  last_login_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### Table: `audit_logs`

```sql
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id),
  user_id UUID NOT NULL REFERENCES admin_users(id),
  action VARCHAR(100) NOT NULL,
  entity_type VARCHAR(100),
  entity_id VARCHAR(255),
  old_value JSONB,
  new_value JSONB,
  ip_address VARCHAR(45),
  user_agent TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_audit_logs_store ON audit_logs(store_id);
CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_created ON audit_logs(created_at);
```

#### Table: `builds`

```sql
CREATE TABLE builds (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id),
  platform VARCHAR(20) NOT NULL, -- 'ios', 'android'
  build_type VARCHAR(20) NOT NULL, -- 'debug', 'release', 'adhoc'
  build_number VARCHAR(50) NOT NULL,
  version VARCHAR(50) NOT NULL,
  environment VARCHAR(20), -- 'dev', 'staging', 'prod'
  status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'building', 'success', 'failed', 'cancelled'
  artifact_type VARCHAR(20), -- 'ipa', 'apk', 'aab'
  artifact_url TEXT,
  artifact_size BIGINT, -- in bytes
  build_duration INTEGER, -- in seconds
  started_at TIMESTAMP WITH TIME ZONE,
  completed_at TIMESTAMP WITH TIME ZONE,
  created_by UUID REFERENCES admin_users(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_builds_store ON builds(store_id);
CREATE INDEX idx_builds_status ON builds(status);
CREATE INDEX idx_builds_platform ON builds(platform);
CREATE INDEX idx_builds_created ON builds(created_at DESC);
```

#### Table: `build_logs`

```sql
CREATE TABLE build_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  build_id UUID NOT NULL REFERENCES builds(id) ON DELETE CASCADE,
  log_level VARCHAR(20) NOT NULL, -- 'info', 'warning', 'error', 'debug'
  message TEXT NOT NULL,
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_build_logs_build ON build_logs(build_id);
CREATE INDEX idx_build_logs_timestamp ON build_logs(timestamp);
```

### 3. Row Level Security (RLS) Policies

```sql
-- Enable RLS
ALTER TABLE app_configurations ENABLE ROW LEVEL SECURITY;
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;

-- Policy: Admins can only access their store's configurations
CREATE POLICY "Admins access own store configs" ON app_configurations
  FOR ALL
  USING (
    store_id IN (
      SELECT store_id FROM admin_users 
      WHERE auth_user_id = auth.uid() AND is_active = true
    )
  );

-- Policy: Super admins can access all stores
CREATE POLICY "Super admins access all configs" ON app_configurations
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM admin_users 
      WHERE auth_user_id = auth.uid() 
        AND role = 'super_admin' 
        AND is_active = true
    )
  );
```

---

## 📱 Admin Panel Features

### 1. Splash Screen & Onboarding

**Flow:**

```
Splash Screen (3s)
    ↓
Check Supabase Connection
    ↓
┌─────────────────────┐
│ Connection Status?  │
└─────────┬───────────┘
          │
    ┌─────┴─────┐
    │           │
   YES          NO
    │           │
    ↓           ↓
Configured?   Offline Mode
    │         (Limited Features)
┌───┴───┐
│       │
YES     NO
│       │
↓       ↓
Dashboard  Setup Wizard
           (Supabase Config)
```

**Implementation:**

```typescript
// src/app/page.tsx (Splash/Landing Page)
'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { createClient } from '@/lib/supabase/client';
import { Loader2 } from 'lucide-react';

export default function SplashPage() {
  const [status, setStatus] = useState<'loading' | 'checking' | 'error'>('loading');
  const router = useRouter();

  useEffect(() => {
    initializeApp();
  }, []);

  async function initializeApp() {
    try {
      // Show splash for minimum duration
      await new Promise(resolve => setTimeout(resolve, 3000));
  
      setStatus('checking');
  
      // Check Supabase connection
      const supabase = createClient();
      const { data: { session }, error } = await supabase.auth.getSession();
  
      if (error) {
        console.error('Supabase connection error:', error);
        router.push('/offline');
        return;
      }
  
      // Check if user is authenticated
      if (!session) {
        router.push('/login');
        return;
      }
  
      // Check if store is configured
      const { data: store } = await supabase
        .from('stores')
        .select('*')
        .single();
  
      if (!store) {
        router.push('/setup');
      } else {
        router.push('/dashboard');
      }
    } catch (err) {
      console.error('Initialization error:', err);
      setStatus('error');
    }
  }

  return (
    <div className="flex h-screen items-center justify-center bg-gradient-to-br from-slate-900 to-slate-800">
      <div className="text-center">
        <h1 className="text-4xl font-bold text-white mb-4">Admin Panel</h1>
        <Loader2 className="w-8 h-8 animate-spin text-white mx-auto" />
        <p className="text-slate-300 mt-4">
          {status === 'loading' && 'Initializing...'}
          {status === 'checking' && 'Checking configuration...'}
          {status === 'error' && 'Connection failed'}
        </p>
      </div>
    </div>
  );
}
```

### 2. Supabase Setup Wizard

**Modern shadcn/ui Design - Minimal & Clean**

**Steps:**

1. **Welcome Screen** - Introduction to admin panel
2. **Supabase Connection** - Enter Supabase URL & Anon Key
3. **WooCommerce Store** - WooCommerce credentials
4. **Fastlane Setup** - Configure build tools (optional)
5. **Admin Account** - Create first admin user
6. **Verification** - Test connections
7. **Complete** - Redirect to dashboard

**Implementation:**

```typescript
// src/components/wizard/wizard-container.tsx
import { cn } from '@/lib/utils';
import { ReactNode } from 'react';

interface WizardContainerProps {
  children: ReactNode;
  className?: string;
}

export function WizardContainer({ children, className }: WizardContainerProps) {
  return (
    <div className="min-h-screen bg-background">
      <div className="container max-w-5xl mx-auto px-4 py-8">
        <div className={cn('space-y-8', className)}>
          {children}
        </div>
      </div>
    </div>
  );
}

// src/components/wizard/wizard-progress.tsx
import { Check } from 'lucide-react';
import { cn } from '@/lib/utils';

interface Step {
  id: number;
  title: string;
  description: string;
}

interface WizardProgressProps {
  steps: Step[];
  currentStep: number;
}

export function WizardProgress({ steps, currentStep }: WizardProgressProps) {
  return (
    <div className="w-full">
      <div className="flex items-center justify-between">
        {steps.map((step, index) => (
          <div key={step.id} className="flex flex-col items-center flex-1">
            <div className="flex items-center w-full">
              {/* Step circle */}
              <div
                className={cn(
                  'flex h-10 w-10 items-center justify-center rounded-full border-2 transition-all',
                  index < currentStep && 'border-primary bg-primary text-primary-foreground',
                  index === currentStep && 'border-primary bg-background text-primary',
                  index > currentStep && 'border-muted bg-background text-muted-foreground'
                )}
              >
                {index < currentStep ? (
                  <Check className="h-5 w-5" />
                ) : (
                  <span className="text-sm font-medium">{index + 1}</span>
                )}
              </div>
          
              {/* Line connector */}
              {index < steps.length - 1 && (
                <div
                  className={cn(
                    'h-0.5 flex-1 transition-all',
                    index < currentStep ? 'bg-primary' : 'bg-muted'
                  )}
                />
              )}
            </div>
        
            {/* Step label */}
            <div className="mt-2 text-center">
              <p
                className={cn(
                  'text-sm font-medium transition-all',
                  index <= currentStep ? 'text-foreground' : 'text-muted-foreground'
                )}
              >
                {step.title}
              </p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

// src/app/(auth)/setup/page.tsx
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { WizardContainer } from '@/components/wizard/wizard-container';
import { WizardProgress } from '@/components/wizard/wizard-progress';
import { ArrowRight, ArrowLeft, Loader2 } from 'lucide-react';
import { toast } from 'sonner';

const STEPS = [
  { id: 0, title: 'Welcome', description: 'Get started' },
  { id: 1, title: 'Supabase', description: 'Database' },
  { id: 2, title: 'WooCommerce', description: 'Store' },
  { id: 3, title: 'Fastlane', description: 'Builds' },
  { id: 4, title: 'Admin', description: 'Account' },
  { id: 5, title: 'Verify', description: 'Test setup' },
];

export default function SetupWizardPage() {
  const [currentStep, setCurrentStep] = useState(0);
  const [loading, setLoading] = useState(false);
  const router = useRouter();
  
  const [formData, setFormData] = useState({
    supabaseUrl: process.env.NEXT_PUBLIC_SUPABASE_URL || '',
    supabaseKey: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '',
    wooStoreUrl: '',
    wooConsumerKey: '',
    wooConsumerSecret: '',
    fastlaneEnabled: false,
    fastlaneAppleId: '',
    fastlaneTeamId: '',
    adminEmail: '',
    adminPassword: '',
  });

  const handleNext = async () => {
    setLoading(true);
  
    try {
      if (currentStep === 1) {
        const isValid = await validateSupabaseConnection();
        if (!isValid) {
          toast.error('Failed to connect to Supabase');
          setLoading(false);
          return;
        }
      } else if (currentStep === 2) {
        const isValid = await validateWooCommerceConnection();
        if (!isValid) {
          toast.error('Failed to connect to WooCommerce');
          setLoading(false);
          return;
        }
      } else if (currentStep === 5) {
        await completeSetup();
        toast.success('Setup completed!');
        router.push('/dashboard');
        return;
      }
  
      setCurrentStep(prev => prev + 1);
    } catch (error) {
      console.error('Setup error:', error);
      toast.error('An error occurred');
    } finally {
      setLoading(false);
    }
  };

  const handleBack = () => {
    setCurrentStep(prev => Math.max(0, prev - 1));
  };

  const validateSupabaseConnection = async () => {
    // Mock validation
    await new Promise(resolve => setTimeout(resolve, 1000));
    return true;
  };

  const validateWooCommerceConnection = async () => {
    // Mock validation
    await new Promise(resolve => setTimeout(resolve, 1000));
    return true;
  };

  const completeSetup = async () => {
    await new Promise(resolve => setTimeout(resolve, 1000));
  };

  return (
    <WizardContainer>
      {/* Header */}
      <div className="text-center space-y-2">
        <h1 className="text-3xl font-bold tracking-tight">Setup Admin Panel</h1>
        <p className="text-muted-foreground">
          Configure your admin panel in a few simple steps
        </p>
      </div>

      {/* Progress */}
      <WizardProgress steps={STEPS} currentStep={currentStep} />

      {/* Content */}
      <Card className="border-2">
        <CardHeader>
          <CardTitle>{STEPS[currentStep].title}</CardTitle>
          <CardDescription>{STEPS[currentStep].description}</CardDescription>
        </CardHeader>
        <CardContent className="space-y-6">
          {/* Step 0: Welcome */}
          {currentStep === 0 && (
            <div className="py-8 text-center space-y-4">
              <div className="mx-auto h-24 w-24 rounded-full bg-primary/10 flex items-center justify-center">
                <span className="text-4xl">🚀</span>
              </div>
              <div>
                <h3 className="text-xl font-semibold mb-2">Welcome to Admin Panel</h3>
                <p className="text-muted-foreground max-w-md mx-auto">
                  Let's configure your admin panel to manage your WooCommerce storefront app.
                  This will only take a few minutes.
                </p>
              </div>
            </div>
          )}

          {/* Step 1: Supabase */}
          {currentStep === 1 && (
            <div className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="supabaseUrl">Supabase URL</Label>
                <Input
                  id="supabaseUrl"
                  placeholder="https://xxx.supabase.co"
                  value={formData.supabaseUrl}
                  onChange={(e) => setFormData({ ...formData, supabaseUrl: e.target.value })}
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="supabaseKey">Anon Key</Label>
                <Input
                  id="supabaseKey"
                  type="password"
                  placeholder="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
                  value={formData.supabaseKey}
                  onChange={(e) => setFormData({ ...formData, supabaseKey: e.target.value })}
                />
              </div>
              <div className="rounded-lg bg-muted p-4 text-sm">
                <p className="text-muted-foreground">
                  You can find these credentials in your Supabase project settings under API.
                </p>
              </div>
            </div>
          )}

          {/* Step 2: WooCommerce */}
          {currentStep === 2 && (
            <div className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="wooStoreUrl">Store URL</Label>
                <Input
                  id="wooStoreUrl"
                  placeholder="https://mystore.com"
                  value={formData.wooStoreUrl}
                  onChange={(e) => setFormData({ ...formData, wooStoreUrl: e.target.value })}
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="wooConsumerKey">Consumer Key</Label>
                <Input
                  id="wooConsumerKey"
                  placeholder="ck_xxxxxxxxxxxx"
                  value={formData.wooConsumerKey}
                  onChange={(e) => setFormData({ ...formData, wooConsumerKey: e.target.value })}
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="wooConsumerSecret">Consumer Secret</Label>
                <Input
                  id="wooConsumerSecret"
                  type="password"
                  placeholder="cs_xxxxxxxxxxxx"
                  value={formData.wooConsumerSecret}
                  onChange={(e) => setFormData({ ...formData, wooConsumerSecret: e.target.value })}
                />
              </div>
            </div>
          )}

          {/* Navigation */}
          <div className="flex justify-between pt-4">
            <Button
              variant="outline"
              onClick={handleBack}
              disabled={currentStep === 0 || loading}
            >
              <ArrowLeft className="w-4 h-4 mr-2" />
              Back
            </Button>
            <Button onClick={handleNext} disabled={loading}>
              {loading ? (
                <>
                  <Loader2 className="w-4 h-4 mr-2 animate-spin" />
                  Processing...
                </>
              ) : currentStep === 5 ? (
                'Complete Setup'
              ) : (
                <>
                  Next
                  <ArrowRight className="w-4 h-4 ml-2" />
                </>
              )}
            </Button>
          </div>
        </CardContent>
      </Card>
    </WizardContainer>
  );
}
```

### 3. Dashboard

**Clean shadcn/ui Design with Max-Width Container**

**Components:**

- **Overview Cards** - Sales, Orders, Customers, Revenue (responsive grid)
- **Quick Actions** - Minimal button group with icons
- **Recent Activity** - Simple table with real-time updates
- **Analytics Charts** - Clean line/bar charts
- **System Status** - Compact status indicators

**Implementation:**

```typescript
// src/components/layout/max-width-wrapper.tsx
import { cn } from '@/lib/utils';
import { ReactNode } from 'react';

interface MaxWidthWrapperProps {
  children: ReactNode;
  className?: string;
  maxWidth?: 'sm' | 'md' | 'lg' | 'xl' | '2xl' | 'full';
}

export function MaxWidthWrapper({ 
  children, 
  className,
  maxWidth = '2xl' 
}: MaxWidthWrapperProps) {
  const maxWidthClass = {
    sm: 'max-w-screen-sm',
    md: 'max-w-screen-md',
    lg: 'max-w-screen-lg',
    xl: 'max-w-screen-xl',
    '2xl': 'max-w-screen-2xl',
    full: 'max-w-full',
  }[maxWidth];

  return (
    <div className={cn('mx-auto w-full px-4 md:px-8', maxWidthClass, className)}>
      {children}
    </div>
  );
}

// src/app/(dashboard)/page.tsx
'use client';

import { MaxWidthWrapper } from '@/components/layout/max-width-wrapper';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { 
  ShoppingCart, 
  Package, 
  Users, 
  DollarSign,
  Settings,
  Plus,
  Hammer,
  TrendingUp
} from 'lucide-react';

export default function DashboardPage() {
  return (
    <MaxWidthWrapper maxWidth="2xl" className="py-8 space-y-8">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Dashboard</h1>
          <p className="text-muted-foreground mt-1">
            Welcome back! Here's what's happening.
          </p>
        </div>
        <div className="flex gap-2">
          <Button variant="outline" size="sm">
            <Settings className="w-4 h-4 mr-2" />
            Settings
          </Button>
          <Button size="sm">
            <Plus className="w-4 h-4 mr-2" />
            Quick Action
          </Button>
        </div>
      </div>

      {/* Overview Cards */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Total Revenue
            </CardTitle>
            <DollarSign className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">$45,231.89</div>
            <p className="text-xs text-muted-foreground mt-1">
              <span className="text-green-600">+20.1%</span> from last month
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Orders
            </CardTitle>
            <ShoppingCart className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">+2,350</div>
            <p className="text-xs text-muted-foreground mt-1">
              <span className="text-green-600">+180</span> new today
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Products
            </CardTitle>
            <Package className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">1,284</div>
            <p className="text-xs text-muted-foreground mt-1">
              <span className="text-yellow-600">12</span> low stock items
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Customers
            </CardTitle>
            <Users className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">+573</div>
            <p className="text-xs text-muted-foreground mt-1">
              <span className="text-green-600">+201</span> this month
            </p>
          </CardContent>
        </Card>
      </div>

      {/* Quick Actions */}
      <Card>
        <CardHeader>
          <CardTitle className="text-base">Quick Actions</CardTitle>
        </CardHeader>
        <CardContent className="grid gap-2 md:grid-cols-4">
          <Button variant="outline" className="justify-start">
            <Plus className="w-4 h-4 mr-2" />
            Add Product
          </Button>
          <Button variant="outline" className="justify-start">
            <ShoppingCart className="w-4 h-4 mr-2" />
            View Orders
          </Button>
          <Button variant="outline" className="justify-start">
            <Settings className="w-4 h-4 mr-2" />
            Edit Config
          </Button>
          <Button variant="outline" className="justify-start">
            <Hammer className="w-4 h-4 mr-2" />
            New Build
          </Button>
        </CardContent>
      </Card>

      {/* Recent Activity & System Status */}
      <div className="grid gap-4 md:grid-cols-2">
        {/* Recent Orders */}
        <Card>
          <CardHeader>
            <CardTitle className="text-base">Recent Orders</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {[1, 2, 3, 4, 5].map((_, i) => (
                <div key={i} className="flex items-center justify-between">
                  <div className="space-y-1">
                    <p className="text-sm font-medium">Order #{1234 + i}</p>
                    <p className="text-xs text-muted-foreground">2 mins ago</p>
                  </div>
                  <Badge variant="outline">Pending</Badge>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* System Status */}
        <Card>
          <CardHeader>
            <CardTitle className="text-base">System Status</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <span className="text-sm">Supabase</span>
                <Badge variant="default" className="bg-green-600">Online</Badge>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm">WooCommerce API</span>
                <Badge variant="default" className="bg-green-600">Connected</Badge>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm">Sync Queue</span>
                <span className="text-sm text-muted-foreground">0 pending</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm">Last Build</span>
                <span className="text-sm text-muted-foreground">2 hours ago</span>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </MaxWidthWrapper>
  );
}
```

### 4. Build Management (Fastlane Integration)

**Real-time Build Monitoring with Clean UI**

**Features:**

- Trigger builds for iOS/Android with environment selection
- Real-time build status with WebSocket updates
- Live log streaming with syntax highlighting
- Build history with filtering
- Artifact downloads (IPA/APK/AAB)
- Build metrics (duration, size, success rate)

**Implementation:**

```typescript
// src/lib/types/build.types.ts
export type BuildPlatform = 'ios' | 'android';
export type BuildType = 'debug' | 'release' | 'adhoc';
export type BuildStatus = 'pending' | 'building' | 'success' | 'failed' | 'cancelled';
export type ArtifactType = 'ipa' | 'apk' | 'aab';

export interface Build {
  id: string;
  storeId: string;
  platform: BuildPlatform;
  buildType: BuildType;
  buildNumber: string;
  version: string;
  environment?: 'dev' | 'staging' | 'prod';
  status: BuildStatus;
  artifactType?: ArtifactType;
  artifactUrl?: string;
  artifactSize?: number;
  buildDuration?: number;
  startedAt?: Date;
  completedAt?: Date;
  createdBy: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface BuildLog {
  id: string;
  buildId: string;
  logLevel: 'info' | 'warning' | 'error' | 'debug';
  message: string;
  timestamp: Date;
}

// src/app/(dashboard)/builds/page.tsx
'use client';

import { useState, useEffect } from 'react';
import { MaxWidthWrapper } from '@/components/layout/max-width-wrapper';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import { Label } from '@/components/ui/label';
import { ScrollArea } from '@/components/ui/scroll-area';
import { 
  Hammer, 
  Apple, 
  Smartphone, 
  Download, 
  Clock, 
  CheckCircle2,
  XCircle,
  Loader2,
  Play
} from 'lucide-react';
import { useBuildStore } from '@/lib/stores/build.store';
import { cn } from '@/lib/utils';

export default function BuildsPage() {
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [selectedPlatform, setSelectedPlatform] = useState<'ios' | 'android'>('ios');
  const [selectedType, setSelectedType] = useState<'debug' | 'release'>('debug');
  const [selectedEnv, setSelectedEnv] = useState<'dev' | 'staging' | 'prod'>('dev');
  
  const { builds, loading, triggerBuild, fetchBuilds } = useBuildStore();

  useEffect(() => {
    fetchBuilds();
  
    // Subscribe to real-time updates
    const channel = supabase
      .channel('builds')
      .on('postgres_changes', {
        event: '*',
        schema: 'public',
        table: 'builds',
      }, (payload) => {
        console.log('Build update:', payload);
        fetchBuilds();
      })
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, []);

  const handleTriggerBuild = async () => {
    await triggerBuild({
      platform: selectedPlatform,
      buildType: selectedType,
      environment: selectedEnv,
    });
    setIsDialogOpen(false);
  };

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'building':
        return <Loader2 className="h-4 w-4 animate-spin text-blue-600" />;
      case 'success':
        return <CheckCircle2 className="h-4 w-4 text-green-600" />;
      case 'failed':
        return <XCircle className="h-4 w-4 text-red-600" />;
      default:
        return <Clock className="h-4 w-4 text-yellow-600" />;
    }
  };

  const getStatusBadge = (status: string) => {
    const variants: Record<string, string> = {
      building: 'bg-blue-600',
      success: 'bg-green-600',
      failed: 'bg-red-600',
      pending: 'bg-yellow-600',
    };
  
    return (
      <Badge className={cn('text-white', variants[status] || 'bg-gray-600')}>
        {status}
      </Badge>
    );
  };

  return (
    <MaxWidthWrapper maxWidth="2xl" className="py-8 space-y-8">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Build Management</h1>
          <p className="text-muted-foreground mt-1">
            Manage and monitor your app builds
          </p>
        </div>
    
        <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
          <DialogTrigger asChild>
            <Button>
              <Hammer className="w-4 h-4 mr-2" />
              New Build
            </Button>
          </DialogTrigger>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Trigger New Build</DialogTitle>
              <DialogDescription>
                Configure and start a new build for your mobile app
              </DialogDescription>
            </DialogHeader>
        
            <div className="space-y-4 py-4">
              <div className="space-y-2">
                <Label>Platform</Label>
                <Select value={selectedPlatform} onValueChange={(v: any) => setSelectedPlatform(v)}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="ios">
                      <div className="flex items-center">
                        <Apple className="w-4 h-4 mr-2" />
                        iOS
                      </div>
                    </SelectItem>
                    <SelectItem value="android">
                      <div className="flex items-center">
                        <Smartphone className="w-4 h-4 mr-2" />
                        Android
                      </div>
                    </SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-2">
                <Label>Build Type</Label>
                <Select value={selectedType} onValueChange={(v: any) => setSelectedType(v)}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="debug">Debug</SelectItem>
                    <SelectItem value="release">Release</SelectItem>
                    <SelectItem value="adhoc">Ad Hoc (iOS)</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-2">
                <Label>Environment</Label>
                <Select value={selectedEnv} onValueChange={(v: any) => setSelectedEnv(v)}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="dev">Development</SelectItem>
                    <SelectItem value="staging">Staging</SelectItem>
                    <SelectItem value="prod">Production</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            <div className="flex justify-end gap-2">
              <Button variant="outline" onClick={() => setIsDialogOpen(false)}>
                Cancel
              </Button>
              <Button onClick={handleTriggerBuild}>
                <Play className="w-4 h-4 mr-2" />
                Start Build
              </Button>
            </div>
          </DialogContent>
        </Dialog>
      </div>

      {/* Build Stats */}
      <div className="grid gap-4 md:grid-cols-4">
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Total Builds
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{builds.length}</div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Success Rate
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">94.5%</div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Avg Duration
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">8.5m</div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Active Builds
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {builds.filter(b => b.status === 'building').length}
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Build List */}
      <Card>
        <CardHeader>
          <CardTitle className="text-base">Recent Builds</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            {loading ? (
              <div className="text-center py-8">
                <Loader2 className="w-8 h-8 animate-spin mx-auto text-muted-foreground" />
              </div>
            ) : builds.length === 0 ? (
              <div className="text-center py-8 text-muted-foreground">
                No builds yet. Start your first build!
              </div>
            ) : (
              builds.map((build) => (
                <div
                  key={build.id}
                  className="flex items-center justify-between p-4 border rounded-lg hover:bg-accent transition-colors"
                >
                  <div className="flex items-center gap-4">
                    {getStatusIcon(build.status)}
                
                    <div>
                      {build.platform === 'ios' ? (
                        <Apple className="w-5 h-5" />
                      ) : (
                        <Smartphone className="w-5 h-5" />
                      )}
                    </div>
                
                    <div>
                      <p className="font-medium">
                        {build.platform.toUpperCase()} {build.buildType}
                      </p>
                      <p className="text-sm text-muted-foreground">
                        v{build.version} ({build.buildNumber})
                      </p>
                    </div>
                  </div>

                  <div className="flex items-center gap-4">
                    {getStatusBadge(build.status)}
                
                    {build.artifactUrl && (
                      <Button variant="outline" size="sm" asChild>
                        <a href={build.artifactUrl} download>
                          <Download className="w-4 h-4" />
                        </a>
                      </Button>
                    )}
                
                    <Button variant="ghost" size="sm" asChild>
                      <a href={`/builds/${build.id}`}>
                        View Details
                      </a>
                    </Button>
                  </div>
                </div>
              ))
            )}
          </div>
        </CardContent>
      </Card>
    </MaxWidthWrapper>
  );
}
```

### 4. Configuration Management

**Features:**

- Visual editor for `app_config.json`
- Category-based organization (UI, WooCommerce, Features, etc.)
- JSON preview & validation
- Version history with rollback
- Publish changes to production
- A/B testing support

**Implementation:**

```typescript
// src/app/(dashboard)/config/page.tsx
'use client';

import { useState, useEffect } from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { History, Upload, Download, Save } from 'lucide-react';
import { useConfigStore } from '@/lib/stores/config.store';
import { toast } from 'sonner';
import ConfigSection from '@/components/config/config-section';
import JsonViewer from '@/components/config/json-viewer';
import VersionHistory from '@/components/config/version-history';

export default function ConfigEditorPage() {
  const { config, loading, error, loadConfig, updateConfig, publishConfig } = useConfigStore();
  const [activeTab, setActiveTab] = useState('app_settings');
  const [showHistory, setShowHistory] = useState(false);
  const [localConfig, setLocalConfig] = useState<any>(null);

  useEffect(() => {
    loadConfig();
  }, []);

  useEffect(() => {
    if (config) {
      setLocalConfig(config);
    }
  }, [config]);

  const handleSave = async () => {
    try {
      await updateConfig(localConfig);
      toast.success('Configuration saved successfully');
    } catch (err) {
      toast.error('Failed to save configuration');
    }
  };

  const handlePublish = async () => {
    try {
      await publishConfig();
      toast.success('Configuration published to production');
    } catch (err) {
      toast.error('Failed to publish configuration');
    }
  };

  const handleExport = () => {
    const blob = new Blob([JSON.stringify(localConfig, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `app_config_${new Date().toISOString()}.json`;
    a.click();
  };

  if (loading) {
    return <div className="flex items-center justify-center h-screen">Loading...</div>;
  }

  if (error) {
    return <div className="text-red-500">Error: {error}</div>;
  }

  return (
    <div className="container py-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold">Configuration Management</h1>
        <div className="flex gap-2">
          <Button variant="outline" onClick={() => setShowHistory(true)}>
            <History className="w-4 h-4 mr-2" />
            History
          </Button>
          <Button variant="outline" onClick={handleExport}>
            <Download className="w-4 h-4 mr-2" />
            Export
          </Button>
          <Button variant="outline" onClick={handleSave}>
            <Save className="w-4 h-4 mr-2" />
            Save
          </Button>
          <Button onClick={handlePublish}>
            <Upload className="w-4 h-4 mr-2" />
            Publish
          </Button>
        </div>
      </div>

      <Tabs value={activeTab} onValueChange={setActiveTab}>
        <TabsList>
          <TabsTrigger value="app_settings">App Settings</TabsTrigger>
          <TabsTrigger value="woocommerce">WooCommerce</TabsTrigger>
          <TabsTrigger value="ui">UI Config</TabsTrigger>
          <TabsTrigger value="features">Features</TabsTrigger>
          <TabsTrigger value="home">Home View</TabsTrigger>
          <TabsTrigger value="navbar">Navigation</TabsTrigger>
          <TabsTrigger value="json">JSON</TabsTrigger>
        </TabsList>

        <TabsContent value="app_settings">
          <ConfigSection
            title="App Settings"
            config={localConfig?.app_settings}
            onChange={(data) => setLocalConfig({ ...localConfig, app_settings: data })}
          />
        </TabsContent>

        <TabsContent value="woocommerce">
          <ConfigSection
            title="WooCommerce Configuration"
            config={localConfig?.woocommerce_configuration}
            onChange={(data) => setLocalConfig({ ...localConfig, woocommerce_configuration: data })}
          />
        </TabsContent>

        <TabsContent value="ui">
          <ConfigSection
            title="UI Configuration"
            config={localConfig?.ui_configuration}
            onChange={(data) => setLocalConfig({ ...localConfig, ui_configuration: data })}
          />
        </TabsContent>

        <TabsContent value="features">
          <ConfigSection
            title="Feature Flags"
            config={localConfig?.feature_flags}
            onChange={(data) => setLocalConfig({ ...localConfig, feature_flags: data })}
          />
        </TabsContent>

        <TabsContent value="home">
          <ConfigSection
            title="Home View Configuration"
            config={localConfig?.home_view}
            onChange={(data) => setLocalConfig({ ...localConfig, home_view: data })}
          />
        </TabsContent>

        <TabsContent value="navbar">
          <ConfigSection
            title="Navigation Bar Configuration"
            config={localConfig?.navbar_configuration}
            onChange={(data) => setLocalConfig({ ...localConfig, navbar_configuration: data })}
          />
        </TabsContent>

        <TabsContent value="json">
          <JsonViewer data={localConfig} />
        </TabsContent>
      </Tabs>

      {showHistory && (
        <VersionHistory onClose={() => setShowHistory(false)} />
      )}
    </div>
  );
}
```

### 5. Offline Support

**Strategy:**

- **Local-First Architecture** - All operations work offline
- **Sync Queue** - Operations queued when offline
- **Conflict Resolution** - Server wins on conflicts
- **Background Sync** - Auto-sync when online
- **Offline Indicators** - Clear UI feedback

**Implementation:**

```typescript
// src/lib/services/sync.service.ts
import { createClient } from '@/lib/supabase/client';
import { openDB, DBSchema, IDBPDatabase } from 'idb';

interface SyncQueueItem {
  id: string;
  entityType: 'config' | 'product' | 'order';
  entityId?: string;
  operation: 'create' | 'update' | 'delete';
  payload: any;
  status: 'pending' | 'syncing' | 'completed' | 'failed';
  retryCount: number;
  errorMessage?: string;
  createdAt: Date;
  syncedAt?: Date;
}

interface SyncDB extends DBSchema {
  'sync-queue': {
    key: string;
    value: SyncQueueItem;
    indexes: { 'by-status': string };
  };
}

class SyncService {
  private db: IDBPDatabase<SyncDB> | null = null;
  private syncInterval: NodeJS.Timeout | null = null;
  private supabase = createClient();

  async initialize() {
    // Initialize IndexedDB
    this.db = await openDB<SyncDB>('admin-panel-sync', 1, {
      upgrade(db) {
        const store = db.createObjectStore('sync-queue', { keyPath: 'id' });
        store.createIndex('by-status', 'status');
      },
    });

    // Start periodic sync (every 30 seconds)
    this.syncInterval = setInterval(() => {
      this.syncPendingOperations();
    }, 30000);

    // Listen to online/offline events
    if (typeof window !== 'undefined') {
      window.addEventListener('online', () => {
        console.log('Back online, syncing...');
        this.syncPendingOperations();
      });
    }

    // Initial sync
    this.syncPendingOperations();
  }

  async queueOperation(params: {
    entityType: SyncQueueItem['entityType'];
    operation: SyncQueueItem['operation'];
    payload: any;
    entityId?: string;
  }) {
    if (!this.db) throw new Error('SyncService not initialized');

    const queueItem: SyncQueueItem = {
      id: crypto.randomUUID(),
      entityType: params.entityType,
      entityId: params.entityId,
      operation: params.operation,
      payload: params.payload,
      status: 'pending',
      retryCount: 0,
      createdAt: new Date(),
    };

    await this.db.add('sync-queue', queueItem);

    // Try immediate sync if online
    if (this.isOnline()) {
      await this.syncPendingOperations();
    }
  }

  async syncPendingOperations() {
    if (!this.db || !this.isOnline()) return;

    const tx = this.db.transaction('sync-queue', 'readonly');
    const index = tx.store.index('by-status');
    const pendingItems = await index.getAll('pending');

    for (const item of pendingItems) {
      try {
        // Update status to syncing
        await this.updateItemStatus(item.id, 'syncing');

        // Perform sync
        await this.performSync(item);

        // Mark as completed and remove from queue
        await this.db.delete('sync-queue', item.id);
      } catch (error) {
        console.error(`Sync failed for item ${item.id}:`, error);

        // Mark as failed
        await this.updateItemStatus(item.id, 'failed', {
          errorMessage: error instanceof Error ? error.message : 'Unknown error',
          retryCount: item.retryCount + 1,
        });

        // Remove if max retries exceeded
        if (item.retryCount >= 3) {
          await this.db.delete('sync-queue', item.id);
        }
      }
    }
  }

  private async performSync(item: SyncQueueItem) {
    switch (item.entityType) {
      case 'config':
        await this.syncConfig(item);
        break;
      case 'product':
        await this.syncProduct(item);
        break;
      case 'order':
        await this.syncOrder(item);
        break;
      default:
        throw new Error(`Unknown entity type: ${item.entityType}`);
    }
  }

  private async syncConfig(item: SyncQueueItem) {
    const { error } = await this.supabase
      .from('app_configurations')
      .upsert(item.payload);

    if (error) throw error;
  }

  private async syncProduct(item: SyncQueueItem) {
    // Implement WooCommerce product sync
    const response = await fetch('/api/woocommerce/products', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(item.payload),
    });

    if (!response.ok) {
      throw new Error(`Product sync failed: ${response.statusText}`);
    }
  }

  private async syncOrder(item: SyncQueueItem) {
    // Implement order sync logic
  }

  private async updateItemStatus(
    id: string,
    status: SyncQueueItem['status'],
    updates?: Partial<SyncQueueItem>
  ) {
    if (!this.db) return;

    const item = await this.db.get('sync-queue', id);
    if (!item) return;

    await this.db.put('sync-queue', {
      ...item,
      status,
      ...updates,
      syncedAt: status === 'completed' ? new Date() : item.syncedAt,
    });
  }

  private isOnline(): boolean {
    return typeof navigator !== 'undefined' && navigator.onLine;
  }

  async getPendingCount(): Promise<number> {
    if (!this.db) return 0;
    const tx = this.db.transaction('sync-queue', 'readonly');
    const index = tx.store.index('by-status');
    const count = await index.count('pending');
    return count;
  }

  destroy() {
    if (this.syncInterval) {
      clearInterval(this.syncInterval);
    }
  }
}

export const syncService = new SyncService();
```

---

## 📦 Required Dependencies

### package.json

```json
{
  "name": "admin-panel",
  "version": "1.0.0",
  "description": "Admin panel for Storefront WooCommerce Flutter app",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "type-check": "tsc --noEmit",
    "supabase:start": "supabase start",
    "supabase:stop": "supabase stop",
    "supabase:status": "supabase status",
    "db:migrate": "supabase db push",
    "db:reset": "supabase db reset"
  },
  "dependencies": {
    "next": "^15.1.3",
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "typescript": "^5.7.2",
  
    "@supabase/supabase-js": "^2.47.10",
    "@supabase/ssr": "^0.6.1",
  
    "zustand": "^5.0.3",
    "jotai": "^2.10.5",
  
    "@radix-ui/react-accordion": "^1.2.2",
    "@radix-ui/react-alert-dialog": "^1.1.4",
    "@radix-ui/react-avatar": "^1.1.2",
    "@radix-ui/react-checkbox": "^1.1.4",
    "@radix-ui/react-dialog": "^1.1.4",
    "@radix-ui/react-dropdown-menu": "^2.1.4",
    "@radix-ui/react-label": "^2.1.1",
    "@radix-ui/react-popover": "^1.1.4",
    "@radix-ui/react-select": "^2.1.4",
    "@radix-ui/react-separator": "^1.1.1",
    "@radix-ui/react-slider": "^1.2.1",
    "@radix-ui/react-switch": "^1.1.2",
    "@radix-ui/react-tabs": "^1.1.2",
    "@radix-ui/react-toast": "^1.2.4",
    "@radix-ui/react-tooltip": "^1.1.6",
  
    "tailwindcss": "^3.4.17",
    "tailwindcss-animate": "^1.0.7",
    "class-variance-authority": "^0.7.1",
    "clsx": "^2.1.1",
    "tailwind-merge": "^2.6.0",
  
    "lucide-react": "^0.468.0",
    "recharts": "^2.15.0",
    "@tanstack/react-table": "^8.20.6",
  
    "idb": "^8.0.2",
    "axios": "^1.7.9",
    "zod": "^3.24.1",
    "react-hook-form": "^7.54.2",
    "@hookform/resolvers": "^3.9.1",
  
    "date-fns": "^4.1.0",
    "sonner": "^1.7.1",
    "cmdk": "^1.0.4"
  },
  "devDependencies": {
    "@types/node": "^22.10.5",
    "@types/react": "^19.0.7",
    "@types/react-dom": "^19.0.2",
    "eslint": "^9.18.0",
    "eslint-config-next": "^15.1.3",
    "prettier": "^3.4.2",
    "prettier-plugin-tailwindcss": "^0.6.11",
    "@typescript-eslint/eslint-plugin": "^8.21.0",
    "@typescript-eslint/parser": "^8.21.0",
    "supabase": "^1.242.4"
  },
  "engines": {
    "node": ">=20.0.0",
    "pnpm": ">=9.0.0"
  }
}
```

---

## 🔐 Security Considerations

### 1. Authentication & Authorization

- **JWT-based Auth** - Supabase built-in authentication
- **Role-Based Access Control (RBAC)** - Super Admin, Store Manager, Content Editor
- **Row Level Security (RLS)** - Database-level access control
- **API Key Encryption** - Encrypt WooCommerce credentials at rest

### 2. Data Protection

- **HTTPS Only** - All communications encrypted
- **Secrets Management** - Use environment variables for sensitive data
- **Input Validation** - Sanitize all user inputs
- **SQL Injection Prevention** - Use parameterized queries

### 3. Audit Trail

- **Comprehensive Logging** - Log all CRUD operations
- **User Activity Tracking** - Track admin actions
- **Change History** - Version control for configurations

---

## 🚀 Deployment Strategy

### 1. Development Environment

```bash
# Setup Supabase local development
supabase init
supabase start

# Install dependencies
cd projects/admin_panel
pnpm install

# Run development server
pnpm dev

# Open browser at http://localhost:3000
```

### 2. Production Deployment

**Supabase:**

- Create production project at supabase.com
- Run migrations: `supabase db push`
- Configure RLS policies
- Set up Edge Functions for complex operations

**Next.js Admin Panel (Vercel):**

```bash
# Install Vercel CLI
npm i -g vercel

# Build for production
npm run build

# Deploy to Vercel
vercel --prod

# Or push to main branch (auto-deploy)
git push origin main
```

**Next.js Admin Panel (Alternative - Docker):**

```bash
# Build Docker image
docker build -t admin-panel .

# Run container
docker run -p 3000:3000 admin-panel

# Deploy to any cloud provider (AWS, GCP, Azure)
```

---

## 📊 Performance Optimization

### 1. Offline Performance

- **Indexed DB** - Fast local storage for web
- **SQLite** - Optimized queries with indexes
- **Lazy Loading** - Load data on-demand
- **Pagination** - Handle large datasets efficiently

### 2. Network Optimization

- **Request Batching** - Combine multiple requests
- **Caching Strategy** - Cache frequently accessed data
- **Compression** - Compress request/response payloads
- **CDN** - Use CDN for static assets

### 3. UI Performance

- **Widget Recycling** - Reuse widgets in lists
- **Code Splitting** - Load features on-demand
- **Image Optimization** - Compress and cache images
- **Debouncing** - Debounce search and form inputs

---

## 🧪 Testing Strategy

### 1. Unit Tests

```dart
// test/cubits/config_cubit_test.dart
void main() {
  group('ConfigCubit', () {
    late ConfigCubit cubit;
    late MockConfigRepository repository;

    setUp(() {
      repository = MockConfigRepository();
      cubit = ConfigCubit(repository);
    });

    test('loads configurations successfully', () async {
      // Arrange
      final mockConfig = {'app_name': 'Test Store'};
      when(() => repository.getConfiguration())
          .thenAnswer((_) async => mockConfig);

      // Act
      await cubit.loadConfigurations();

      // Assert
      expect(cubit.state, isA<ConfigLoaded>());
      expect((cubit.state as ConfigLoaded).config, mockConfig);
    });
  });
}
```

### 2. Integration Tests

```dart
// integration_test/config_flow_test.dart
void main() {
  testWidgets('Admin can update configuration', (tester) async {
    // Given: Admin is logged in
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
  
    // When: Navigate to config editor
    await tester.tap(find.text('Configuration'));
    await tester.pumpAndSettle();
  
    // Then: Config editor is displayed
    expect(find.text('Configuration Management'), findsOneWidget);
  
    // When: Update a config value
    await tester.enterText(find.byKey(Key('app_name')), 'New Store Name');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
  
    // Then: Success message is shown
    expect(find.text('Configuration updated'), findsOneWidget);
  });
}
```

### 3. End-to-End Tests

- **Offline Sync Flow** - Test offline → online sync
- **Configuration Publishing** - Test full config update flow
- **Multi-User Conflict** - Test concurrent edits

---

## 📝 Implementation Roadmap

### Phase 1: Foundation (Week 1-2)

- [ ] Set up project structure
- [ ] Configure Supabase backend
- [ ] Implement database schema & RLS policies
- [ ] Create splash screen & setup wizard
- [ ] Implement authentication flow

### Phase 2: Core Features (Week 3-4)

- [ ] Build dashboard with overview cards
- [ ] Implement configuration management UI
- [ ] Create product management module
- [ ] Build order management module
- [ ] Implement local storage with SQLite

### Phase 3: Offline Support (Week 5)

- [ ] Implement sync queue system
- [ ] Build conflict resolution logic
- [ ] Add offline indicators to UI
- [ ] Test offline → online scenarios

### Phase 4: Advanced Features (Week 6-7)

- [ ] Add analytics dashboard with charts
- [ ] Implement audit logging
- [ ] Build user management & roles
- [ ] Create version history for configs
- [ ] Add A/B testing support

### Phase 5: Testing & Polish (Week 8)

- [ ] Write comprehensive unit tests
- [ ] Perform integration testing
- [ ] Conduct end-to-end testing
- [ ] Optimize performance
- [ ] Fix bugs and polish UI

### Phase 6: Deployment (Week 9)

- [ ] Deploy Supabase production environment
- [ ] Deploy admin panel to hosting
- [ ] Configure CI/CD pipeline
- [ ] Write deployment documentation
- [ ] Train admin users

---

## 🎓 Best Practices

### 1. Code Organization

- Follow Clean Architecture principles
- Separate business logic from UI
- Use dependency injection
- Keep widgets small and focused

### 2. State Management

- Use BLoC for complex state
- Leverage HydratedBloc for persistence
- Handle loading, success, and error states
- Avoid mutable state

### 3. Error Handling

- Use Result/Either pattern for operations
- Show user-friendly error messages
- Log errors for debugging
- Implement retry mechanisms

### 4. Documentation

- Document all public APIs
- Write inline comments for complex logic
- Maintain up-to-date README
- Create user guides for admin users

---

## 🔗 References

### Documentation

- [Supabase Docs](https://supabase.com/docs)
- [Flutter BLoC](https://bloclibrary.dev/)
- [WooCommerce REST API](https://woocommerce.github.io/woocommerce-rest-api-docs/)
- [GoRouter](https://pub.dev/packages/go_router)

### Packages

- `supabase_flutter`: ^2.11.0
- `flutter_bloc`: ^9.1.1
- `get_it`: ^8.3.0
- `go_router`: ^15.1.3
- `sqflite`: ^2.4.2

---

## 📞 Support & Maintenance

### Monitoring

- Set up error tracking (Sentry, Firebase Crashlytics)
- Monitor API performance (Supabase Dashboard)
- Track sync failures and retry patterns
- Set up alerts for critical errors

### Maintenance

- Regular Supabase backups
- Database optimization (vacuum, analyze)
- Update dependencies quarterly
- Review and rotate API keys

---

## ✅ Success Metrics

### Technical Metrics

- **Offline Sync Success Rate:** > 99%
- **API Response Time:** < 500ms (p95)
- **Config Update Time:** < 2 seconds
- **App Load Time:** < 3 seconds
- **Crash-Free Rate:** > 99.9%

### Business Metrics

- **Admin Productivity:** 50% faster config updates
- **Store Management Time:** 30% reduction
- **Error Rate:** < 0.1% failed operations
- **User Satisfaction:** > 4.5/5 rating

---

## 🏁 Conclusion

This admin panel will provide a powerful, offline-capable management solution for the Storefront WooCommerce Flutter mobile app. Built with **Next.js 15 + TypeScript**, it leverages Supabase for backend services and implements a robust offline-first architecture with advanced build management capabilities.

**Key Advantages:**

- ✅ **Modern Tech Stack** - Next.js 15, TypeScript, React 19, shadcn/ui
- ✅ **Clean UI Design** - Minimal, responsive design with max-width containers
- ✅ **Offline-First** - Works seamlessly without internet, auto-syncs when online
- ✅ **Real-Time Updates** - WebSocket-based live updates for builds, orders, configs
- ✅ **Build Management** - Integrated Fastlane for iOS/Android builds with real-time logs
- ✅ **Setup Wizard** - Step-by-step guided setup with modern progress indicators
- ✅ **Secure** - Row-level security, JWT auth, encrypted credentials
- ✅ **Scalable** - Supabase handles growth automatically
- ✅ **Developer-Friendly** - Clean architecture, TypeScript, well-documented

### 🎯 New Features Highlighted

#### **1. Modern UI with shadcn/ui**

- Clean, minimal design philosophy
- Fully responsive with mobile-first approach
- Max-width containers for better readability
- Consistent component library (shadcn/ui)
- Dark mode support ready

#### **2. Enhanced Setup Wizard**

- Visual step-by-step progress indicator
- Supabase connection configuration
- WooCommerce store setup
- Fastlane build tools configuration (optional)
- Admin account creation
- Connection verification
- Smooth animations and transitions

#### **3. Build Management System**

- **Trigger Builds**: Start iOS/Android builds directly from admin panel
- **Platform Support**: iOS (IPA) and Android (APK/AAB)
- **Build Types**: Debug, Release, Ad Hoc
- **Environment Selection**: Dev, Staging, Production
- **Real-Time Monitoring**: Live build status with WebSocket updates
- **Log Streaming**: Watch build logs in real-time with syntax highlighting
- **Build History**: Track all builds with filtering and search
- **Artifact Management**: Download builds directly from the panel
- **Build Metrics**: Duration, size, success rate analytics
- **Fastlane Integration**: Seamless integration with local Fastlane setup

#### **4. Dashboard Improvements**

- Overview cards with key metrics
- Quick action buttons for common tasks
- Recent activity feed with real-time updates
- System status indicators
- Build status at a glance
- Clean grid layout with proper spacing

#### **5. Configuration Management**

- Tabbed interface for different config sections
- JSON preview with syntax highlighting
- Version history with rollback capability
- Export/Import configuration files
- Publish to production with one click
- A/B testing support (planned)

### 📊 Build Management Workflow

```
Admin Panel → Trigger Build → Fastlane Executes → Real-time Logs → Artifact Upload → Download
     ↓                ↓                                    ↑              ↑
Supabase DB    Build Status Updates            WebSocket Connection    Storage
```

### 🛠️ Fastlane Integration Details

**Local Setup Requirements:**

- Ruby >= 2.6.0
- Bundler installed
- Fastlane gem installed
- Xcode (for iOS builds)
- Android SDK (for Android builds)
- Code signing certificates configured

**Environment Variables:**

```bash
# Admin Panel .env.local
NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
FLUTTER_PROJECT_PATH=/path/to/storefront_woo
ANDROID_KEYSTORE_PATH=/path/to/keystore.jks
ANDROID_KEYSTORE_PASSWORD=***
ANDROID_KEY_ALIAS=***
ANDROID_KEY_PASSWORD=***
```

### 🚀 Quick Start Guide

```bash
# 1. Clone repository
git clone https://github.com/masterfabric-mobile/osmea.git
cd osmea/projects/admin_panel

# 2. Install dependencies
pnpm install

# 3. Setup Supabase
supabase init
supabase start
supabase db push

# 4. Configure environment
cp .env.example .env.local
# Edit .env.local with your credentials

# 5. Run development server
pnpm dev

# 6. Open browser
open http://localhost:3000

# 7. Complete setup wizard
# Follow on-screen instructions
```

### 📱 Mobile App Integration

The Flutter mobile app (storefront_woo) will:

1. Fetch `app_config.json` from Supabase Storage
2. Parse and apply configuration at runtime
3. Support hot-reload of configs without app restart
4. Download new builds from admin panel for testing
5. Report analytics back to admin panel

### 🔄 Continuous Integration Flow

```
Code Push → GitHub Actions → Admin Panel Trigger → Fastlane Build → Upload → Deploy
                  ↓                     ↓                  ↓           ↓        ↓
              Run Tests         Update Build DB    Real-time Logs   Supabase  TestFlight/
                                                                     Storage   Play Console
```

---

## 📦 Complete Feature List

### ✅ Core Features

- [X] User authentication with Supabase Auth
- [X] Setup wizard with step-by-step guidance
- [X] Dashboard with key metrics
- [X] Configuration management (JSON editor)
- [X] WooCommerce integration
- [X] Product management (CRUD)
- [X] Order management
- [X] Customer management
- [X] Offline-first architecture with sync queue
- [X] Real-time updates via WebSocket

### ✅ Build Management Features

- [X] iOS build support (IPA)
- [X] Android build support (APK/AAB)
- [X] Environment selection (dev/staging/prod)
- [X] Build type selection (debug/release/adhoc)
- [X] Real-time build status updates
- [X] Live log streaming with WebSocket
- [X] Build history with filtering
- [X] Artifact downloads
- [X] Build metrics and analytics
- [X] Fastlane integration

### 🔮 Planned Features

- [ ] A/B testing for configurations
- [ ] Push notification management
- [ ] In-app messaging system
- [ ] Advanced analytics with charts
- [ ] Multi-tenant support
- [ ] Team collaboration features
- [ ] Build scheduling (cron jobs)
- [ ] Automated testing integration
- [ ] Code signing automation
- [ ] Distribution automation (TestFlight/Play Console)

---

**Document Prepared By:** AI Assistant
**Last Updated:** 2026-01-09
**Status:** Ready for Implementation
**Technology:** Next.js 15 + TypeScript + Supabase + Fastlane
