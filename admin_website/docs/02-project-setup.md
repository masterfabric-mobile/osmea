# Admin Website - Project Setup Guide

**Project:** OSMEA Admin Website  
**Version:** 1.0.0  
**Date:** 2026-01-09  
**Technology:** Next.js 15 + TypeScript + Supabase

---

## 📋 Prerequisites

### Required Software

| Software | Version | Purpose |
|----------|---------|---------|
| Node.js | >= 20.0.0 | Runtime environment |
| pnpm | >= 9.0.0 | Package manager (preferred) |
| Git | >= 2.0.0 | Version control |
| Supabase CLI | latest | Local development |
| Ruby | >= 2.6.0 | Fastlane dependency |
| Bundler | latest | Ruby dependency manager |
| Flutter SDK | >= 3.8.1 | For mobile app builds |

### Optional Software

| Software | Version | Purpose |
|----------|---------|---------|
| Docker | latest | Containerization |
| Xcode | latest | iOS builds (macOS only) |
| Android Studio | latest | Android builds |
| VS Code | latest | Recommended IDE |

---

## 🚀 Step 1: Clone Repository

```bash
# Clone the OSMEA repository
git clone https://github.com/masterfabric-mobile/osmea.git

# Navigate to admin website directory
cd osmea/admin_website

# Verify structure
ls -la
```

Expected directory structure:
```
admin_website/
├── docs/           # Documentation (you are here)
├── src/            # Source code (to be created)
├── public/         # Static assets (to be created)
├── supabase/       # Supabase config (to be created)
├── fastlane/       # Fastlane config (to be created)
└── package.json    # Dependencies (to be created)
```

---

## 📦 Step 2: Initialize Next.js Project

### Option A: Using create-next-app (Recommended)

```bash
# Create Next.js app with TypeScript
pnpm create next-app@latest . --typescript --tailwind --app --src-dir --import-alias "@/*"

# Answer prompts:
# ✔ Would you like to use ESLint? … Yes
# ✔ Would you like to use Turbopack? … Yes
# ✔ Would you like to customize the default import alias? … No
```

### Option B: Manual Setup

```bash
# Initialize package.json
pnpm init

# Install Next.js and dependencies
pnpm add next@latest react@latest react-dom@latest typescript @types/react @types/node

# Install Tailwind CSS
pnpm add -D tailwindcss postcss autoprefixer
pnpx tailwindcss init -p
```

---

## 🎨 Step 3: Install shadcn/ui

```bash
# Initialize shadcn/ui
pnpm dlx shadcn@latest init

# Answer prompts:
# ✔ Which style would you like to use? › New York
# ✔ Which color would you like to use as base color? › Slate
# ✔ Would you like to use CSS variables for colors? › yes

# Install required components
pnpm dlx shadcn@latest add button
pnpm dlx shadcn@latest add card
pnpm dlx shadcn@latest add dialog
pnpm dlx shadcn@latest add input
pnpm dlx shadcn@latest add label
pnpm dlx shadcn@latest add select
pnpm dlx shadcn@latest add tabs
pnpm dlx shadcn@latest add badge
pnpm dlx shadcn@latest add progress
pnpm dlx shadcn@latest add scroll-area
pnpm dlx shadcn@latest add separator
pnpm dlx shadcn@latest add skeleton
pnpm dlx shadcn@latest add switch
pnpm dlx shadcn@latest add toast
pnpm dlx shadcn@latest add tooltip
pnpm dlx shadcn@latest add dropdown-menu
pnpm dlx shadcn@latest add command
pnpm dlx shadcn@latest add table
pnpm dlx shadcn@latest add alert-dialog
```

---

## 🗄️ Step 4: Setup Supabase

### Install Supabase CLI

```bash
# macOS
brew install supabase/tap/supabase

# Windows (PowerShell)
scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
scoop install supabase

# Linux
brew install supabase/tap/supabase
```

### Initialize Supabase Project

```bash
# Initialize Supabase in the project
supabase init

# This creates:
# supabase/
# ├── config.toml
# ├── migrations/
# └── functions/

# Start local Supabase
supabase start

# Note the output:
# API URL: http://localhost:54321
# DB URL: postgresql://postgres:postgres@localhost:54322/postgres
# Studio URL: http://localhost:54323
# Anon key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
# Service Role key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Install Supabase Client

```bash
# Install Supabase JS client
pnpm add @supabase/supabase-js @supabase/ssr
```

---

## 📁 Step 5: Project Structure Setup

Create the following directory structure:

```bash
mkdir -p src/app/{api,\(auth\),\(dashboard\)}
mkdir -p src/components/{ui,dashboard,config,builds,wizard,layout}
mkdir -p src/lib/{supabase,woocommerce,fastlane,services,stores,types,utils}
mkdir -p src/actions
mkdir -p public/{images,icons}
mkdir -p supabase/{migrations,functions}
```

Full structure:
```
admin_website/
├── src/
│   ├── app/
│   │   ├── (auth)/
│   │   │   ├── login/
│   │   │   └── setup/
│   │   ├── (dashboard)/
│   │   │   ├── builds/
│   │   │   ├── config/
│   │   │   ├── products/
│   │   │   ├── orders/
│   │   │   ├── analytics/
│   │   │   └── settings/
│   │   ├── api/
│   │   │   ├── config/
│   │   │   ├── sync/
│   │   │   ├── woocommerce/
│   │   │   └── builds/
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   └── globals.css
│   ├── components/
│   │   ├── ui/              # shadcn/ui components
│   │   ├── dashboard/
│   │   ├── config/
│   │   ├── builds/
│   │   ├── wizard/
│   │   └── layout/
│   ├── lib/
│   │   ├── supabase/
│   │   ├── woocommerce/
│   │   ├── fastlane/
│   │   ├── services/
│   │   ├── stores/
│   │   ├── types/
│   │   └── utils/
│   └── actions/
├── public/
│   ├── images/
│   └── icons/
├── supabase/
│   ├── config.toml
│   ├── migrations/
│   └── functions/
├── fastlane/
│   ├── Fastfile
│   ├── Appfile
│   └── Matchfile
├── .env.local
├── .env.example
├── next.config.js
├── tailwind.config.ts
├── tsconfig.json
├── components.json
├── package.json
└── README.md
```

---

## ⚙️ Step 6: Configuration Files

### 6.1 Environment Variables (.env.local)

```bash
# Create .env.local
cat > .env.local << 'EOF'
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=http://localhost:54321
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here

# WooCommerce Configuration
WOOCOMMERCE_STORE_URL=https://your-store.com
WOOCOMMERCE_CONSUMER_KEY=ck_xxxxxxxxxxxx
WOOCOMMERCE_CONSUMER_SECRET=cs_xxxxxxxxxxxx

# Build Management
FLUTTER_PROJECT_PATH=../projects/storefront_woo
ANDROID_KEYSTORE_PATH=/path/to/keystore.jks
ANDROID_KEYSTORE_PASSWORD=***
ANDROID_KEY_ALIAS=***
ANDROID_KEY_PASSWORD=***

# App Configuration
NODE_ENV=development
EOF
```

### 6.2 Environment Variables Template (.env.example)

```bash
# Create .env.example
cat > .env.example << 'EOF'
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=http://localhost:54321
NEXT_PUBLIC_SUPABASE_ANON_KEY=

# WooCommerce Configuration
WOOCOMMERCE_STORE_URL=
WOOCOMMERCE_CONSUMER_KEY=
WOOCOMMERCE_CONSUMER_SECRET=

# Build Management
FLUTTER_PROJECT_PATH=
ANDROID_KEYSTORE_PATH=
ANDROID_KEYSTORE_PASSWORD=
ANDROID_KEY_ALIAS=
ANDROID_KEY_PASSWORD=

# App Configuration
NODE_ENV=development
EOF
```

### 6.3 Next.js Config (next.config.js)

```typescript
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  images: {
    domains: [
      'localhost',
      'supabase.co',
      'images.unsplash.com',
    ],
  },
  experimental: {
    serverActions: {
      bodySizeLimit: '10mb',
    },
  },
};

module.exports = nextConfig;
```

### 6.4 TypeScript Config (tsconfig.json)

```json
{
  "compilerOptions": {
    "target": "ES2017",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
```

### 6.5 Tailwind Config (tailwind.config.ts)

```typescript
import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: ["class"],
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    container: {
      center: true,
      padding: "2rem",
      screens: {
        "2xl": "1400px",
      },
    },
    extend: {
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
      keyframes: {
        "accordion-down": {
          from: { height: "0" },
          to: { height: "var(--radix-accordion-content-height)" },
        },
        "accordion-up": {
          from: { height: "var(--radix-accordion-content-height)" },
          to: { height: "0" },
        },
      },
      animation: {
        "accordion-down": "accordion-down 0.2s ease-out",
        "accordion-up": "accordion-up 0.2s ease-out",
      },
    },
  },
  plugins: [require("tailwindcss-animate")],
};

export default config;
```

---

## 🔧 Step 7: Install Dependencies

### Core Dependencies

```bash
# Install all dependencies
pnpm add next@latest react@latest react-dom@latest
pnpm add typescript @types/react @types/node @types/react-dom

# Supabase
pnpm add @supabase/supabase-js @supabase/ssr

# State Management
pnpm add zustand jotai

# UI Components (Radix UI)
pnpm add @radix-ui/react-accordion
pnpm add @radix-ui/react-alert-dialog
pnpm add @radix-ui/react-avatar
pnpm add @radix-ui/react-checkbox
pnpm add @radix-ui/react-dialog
pnpm add @radix-ui/react-dropdown-menu
pnpm add @radix-ui/react-label
pnpm add @radix-ui/react-popover
pnpm add @radix-ui/react-select
pnpm add @radix-ui/react-separator
pnpm add @radix-ui/react-slider
pnpm add @radix-ui/react-switch
pnpm add @radix-ui/react-tabs
pnpm add @radix-ui/react-toast
pnpm add @radix-ui/react-tooltip

# Styling
pnpm add tailwindcss postcss autoprefixer
pnpm add tailwindcss-animate
pnpm add class-variance-authority
pnpm add clsx tailwind-merge

# Icons
pnpm add lucide-react

# Charts
pnpm add recharts

# Tables
pnpm add @tanstack/react-table

# Forms
pnpm add react-hook-form @hookform/resolvers zod

# Storage
pnpm add idb

# HTTP Client
pnpm add axios

# Date Utilities
pnpm add date-fns

# Toast Notifications
pnpm add sonner

# Command Palette
pnpm add cmdk
```

### Development Dependencies

```bash
# Install dev dependencies
pnpm add -D @types/node
pnpm add -D @types/react
pnpm add -D @types/react-dom
pnpm add -D eslint
pnpm add -D eslint-config-next
pnpm add -D prettier
pnpm add -D prettier-plugin-tailwindcss
pnpm add -D @typescript-eslint/eslint-plugin
pnpm add -D @typescript-eslint/parser
pnpm add -D supabase
```

---

## 🏗️ Step 8: Create Initial Files

### 8.1 Root Layout (src/app/layout.tsx)

```typescript
import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { Toaster } from "sonner";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Admin Panel - Storefront WooCommerce",
  description: "Manage your WooCommerce storefront app",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        {children}
        <Toaster />
      </body>
    </html>
  );
}
```

### 8.2 Global Styles (src/app/globals.css)

```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
    --card: 0 0% 100%;
    --card-foreground: 222.2 84% 4.9%;
    --popover: 0 0% 100%;
    --popover-foreground: 222.2 84% 4.9%;
    --primary: 222.2 47.4% 11.2%;
    --primary-foreground: 210 40% 98%;
    --secondary: 210 40% 96.1%;
    --secondary-foreground: 222.2 47.4% 11.2%;
    --muted: 210 40% 96.1%;
    --muted-foreground: 215.4 16.3% 46.9%;
    --accent: 210 40% 96.1%;
    --accent-foreground: 222.2 47.4% 11.2%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 210 40% 98%;
    --border: 214.3 31.8% 91.4%;
    --input: 214.3 31.8% 91.4%;
    --ring: 222.2 84% 4.9%;
    --radius: 0.5rem;
  }

  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
    --card: 222.2 84% 4.9%;
    --card-foreground: 210 40% 98%;
    --popover: 222.2 84% 4.9%;
    --popover-foreground: 210 40% 98%;
    --primary: 210 40% 98%;
    --primary-foreground: 222.2 47.4% 11.2%;
    --secondary: 217.2 32.6% 17.5%;
    --secondary-foreground: 210 40% 98%;
    --muted: 217.2 32.6% 17.5%;
    --muted-foreground: 215 20.2% 65.1%;
    --accent: 217.2 32.6% 17.5%;
    --accent-foreground: 210 40% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 210 40% 98%;
    --border: 217.2 32.6% 17.5%;
    --input: 217.2 32.6% 17.5%;
    --ring: 212.7 26.8% 83.9%;
  }
}

@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground;
  }
}
```

### 8.3 Utility Functions (src/lib/utils/cn.ts)

```typescript
import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

---

## 🧪 Step 9: Verify Setup

```bash
# Check if everything is installed
pnpm list

# Run type check
pnpm tsc --noEmit

# Run linter
pnpm eslint .

# Start development server
pnpm dev

# Open browser
open http://localhost:3000
```

---

## 📚 Step 10: Additional Setup

### 10.1 Setup Fastlane

```bash
# Navigate to Flutter project
cd ../projects/storefront_woo

# Install Fastlane
sudo gem install fastlane -NV

# Initialize Fastlane
fastlane init

# Return to admin website
cd ../../admin_website
```

### 10.2 Setup Git Hooks

```bash
# Install husky for git hooks
pnpm add -D husky lint-staged

# Initialize husky
pnpm exec husky init

# Create pre-commit hook
cat > .husky/pre-commit << 'EOF'
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

pnpm lint-staged
EOF

chmod +x .husky/pre-commit
```

### 10.3 Package.json Scripts

Add to `package.json`:

```json
{
  "scripts": {
    "dev": "next dev --turbo",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "type-check": "tsc --noEmit",
    "format": "prettier --write \"**/*.{ts,tsx,md}\"",
    "supabase:start": "supabase start",
    "supabase:stop": "supabase stop",
    "supabase:status": "supabase status",
    "db:push": "supabase db push",
    "db:reset": "supabase db reset"
  },
  "lint-staged": {
    "*.{ts,tsx}": [
      "eslint --fix",
      "prettier --write"
    ]
  }
}
```

---

## ✅ Verification Checklist

- [ ] Node.js installed (>= 20.0.0)
- [ ] pnpm installed (>= 9.0.0)
- [ ] Repository cloned
- [ ] Next.js initialized
- [ ] shadcn/ui installed
- [ ] All dependencies installed
- [ ] Supabase CLI installed
- [ ] Supabase initialized and running
- [ ] Environment variables configured
- [ ] Directory structure created
- [ ] Initial files created
- [ ] Development server runs
- [ ] Type checking passes
- [ ] No linting errors

---

## 🆘 Troubleshooting

### Issue: `pnpm` not found

```bash
# Install pnpm globally
npm install -g pnpm
```

### Issue: Supabase CLI not found

```bash
# macOS
brew install supabase/tap/supabase

# Verify installation
supabase --version
```

### Issue: Port already in use

```bash
# Kill process on port 3000
lsof -ti:3000 | xargs kill -9

# Or use different port
pnpm dev -- -p 3001
```

### Issue: TypeScript errors

```bash
# Clear Next.js cache
rm -rf .next

# Reinstall dependencies
rm -rf node_modules pnpm-lock.yaml
pnpm install

# Rebuild
pnpm dev
```

---

## 📖 Next Steps

After completing this setup, proceed to:

1. **03-database-schema.md** - Set up database tables
2. **04-authentication.md** - Implement authentication
3. **05-ui-components.md** - Build UI components
4. **06-api-integration.md** - Integrate APIs
5. **07-build-management.md** - Set up Fastlane builds

---

**Document Version:** 1.0.0  
**Last Updated:** 2026-01-09  
**Status:** Ready for Implementation
