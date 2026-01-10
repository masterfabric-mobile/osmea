# Deployment Guide

**Project:** OSMEA Admin Website  
**Version:** 1.0.0  
**Date:** 2026-01-09  
**Platform:** Vercel (Primary), Docker (Alternative)

---

## 📋 Overview

This document provides comprehensive deployment guidelines for the Admin Website, covering Vercel deployment, Docker containerization, environment configuration, domain setup, SSL certificates, and production best practices.

---

## 🎯 Deployment Options

### Option 1: Vercel (Recommended)
- ✅ Zero-configuration deployment
- ✅ Automatic HTTPS/SSL
- ✅ Global CDN
- ✅ Serverless functions
- ✅ Preview deployments
- ✅ Built-in analytics

### Option 2: Docker
- ✅ Complete control
- ✅ Self-hosted
- ✅ Custom infrastructure
- ✅ Cost-effective for scale

### Option 3: Traditional VPS
- ✅ Full control
- ✅ Custom configuration
- ✅ Any cloud provider

---

## 🚀 Vercel Deployment

### 1. Prerequisites

```bash
# Install Vercel CLI
npm install -g vercel

# Login to Vercel
vercel login
```

### 2. Initial Setup

```bash
# Navigate to project
cd admin_website

# Initialize Vercel project
vercel

# Follow prompts:
# ? Set up and deploy "~/admin_website"? Y
# ? Which scope? [Your Team]
# ? Link to existing project? N
# ? What's your project's name? admin-website
# ? In which directory is your code located? ./
# Auto-detected Project Settings (Next.js)
```

### 3. Environment Variables

```bash
# Add environment variables via Vercel CLI
vercel env add NEXT_PUBLIC_SUPABASE_URL
vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY
vercel env add SUPABASE_SERVICE_ROLE_KEY
vercel env add WOOCOMMERCE_STORE_URL
vercel env add WOOCOMMERCE_CONSUMER_KEY
vercel env add WOOCOMMERCE_CONSUMER_SECRET
vercel env add FLUTTER_PROJECT_PATH
vercel env add ENCRYPTION_KEY

# Or add via Vercel Dashboard:
# 1. Go to https://vercel.com/dashboard
# 2. Select your project
# 3. Go to Settings > Environment Variables
# 4. Add each variable for Production, Preview, Development
```

### 4. Deploy to Production

```bash
# Deploy to production
vercel --prod

# Or use Git integration:
git push origin main
# Vercel will auto-deploy
```

### 5. Custom Domain Setup

```bash
# Add custom domain via CLI
vercel domains add admin.yourdomain.com

# Or via Vercel Dashboard:
# 1. Go to Settings > Domains
# 2. Add Domain
# 3. Follow DNS configuration instructions

# DNS Configuration (at your DNS provider):
# Type: CNAME
# Name: admin (or subdomain)
# Value: cname.vercel-dns.com
```

### 6. Vercel Configuration

```javascript
// vercel.json
{
  "version": 2,
  "buildCommand": "pnpm build",
  "devCommand": "pnpm dev",
  "installCommand": "pnpm install",
  "framework": "nextjs",
  "regions": ["iad1"], // US East (or closest to your users)
  "env": {
    "NEXT_PUBLIC_SUPABASE_URL": "@supabase-url",
    "NEXT_PUBLIC_SUPABASE_ANON_KEY": "@supabase-anon-key"
  },
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-XSS-Protection",
          "value": "1; mode=block"
        },
        {
          "key": "Referrer-Policy",
          "value": "strict-origin-when-cross-origin"
        }
      ]
    }
  ],
  "rewrites": [
    {
      "source": "/api/:path*",
      "destination": "/api/:path*"
    }
  ]
}
```

---

## 🐳 Docker Deployment

### 1. Dockerfile

```dockerfile
# Dockerfile
FROM node:20-alpine AS base

# Install pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Dependencies stage
FROM base AS deps
WORKDIR /app

# Copy package files
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

# Builder stage
FROM base AS builder
WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Set environment variables for build
ENV NEXT_TELEMETRY_DISABLED 1
ENV NODE_ENV production

# Build application
RUN pnpm build

# Runner stage
FROM base AS runner
WORKDIR /app

ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1

# Create non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy built application
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

CMD ["node", "server.js"]
```

### 2. Docker Compose

```yaml
# docker-compose.yml
version: '3.8'

services:
  admin-website:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - NEXT_PUBLIC_SUPABASE_URL=${NEXT_PUBLIC_SUPABASE_URL}
      - NEXT_PUBLIC_SUPABASE_ANON_KEY=${NEXT_PUBLIC_SUPABASE_ANON_KEY}
      - SUPABASE_SERVICE_ROLE_KEY=${SUPABASE_SERVICE_ROLE_KEY}
      - WOOCOMMERCE_STORE_URL=${WOOCOMMERCE_STORE_URL}
      - WOOCOMMERCE_CONSUMER_KEY=${WOOCOMMERCE_CONSUMER_KEY}
      - WOOCOMMERCE_CONSUMER_SECRET=${WOOCOMMERCE_CONSUMER_SECRET}
      - FLUTTER_PROJECT_PATH=${FLUTTER_PROJECT_PATH}
      - ENCRYPTION_KEY=${ENCRYPTION_KEY}
    volumes:
      - ./logs:/app/logs
    restart: unless-stopped
    networks:
      - admin-network

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/ssl:/etc/nginx/ssl:ro
    depends_on:
      - admin-website
    restart: unless-stopped
    networks:
      - admin-network

networks:
  admin-network:
    driver: bridge
```

### 3. Nginx Configuration

```nginx
# nginx/nginx.conf
upstream admin_website {
    server admin-website:3000;
}

server {
    listen 80;
    server_name admin.yourdomain.com;
    
    # Redirect to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name admin.yourdomain.com;

    # SSL Configuration
    ssl_certificate /etc/nginx/ssl/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    # Security Headers
    add_header X-Frame-Options "DENY" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    # Gzip Compression
    gzip on;
    gzip_vary on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml text/javascript;

    # Proxy settings
    location / {
        proxy_pass http://admin_website;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # Static files caching
    location /_next/static {
        proxy_pass http://admin_website;
        add_header Cache-Control "public, max-age=31536000, immutable";
    }

    # Health check endpoint
    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
}
```

### 4. Deploy with Docker

```bash
# Build image
docker build -t admin-website:latest .

# Run container
docker run -d \
  -p 3000:3000 \
  --name admin-website \
  --env-file .env.production \
  admin-website:latest

# Or use Docker Compose
docker-compose up -d

# View logs
docker logs -f admin-website

# Stop container
docker-compose down
```

---

## 🔧 Environment Configuration

### Production Environment Variables

```bash
# .env.production

# App Configuration
NODE_ENV=production
NEXT_TELEMETRY_DISABLED=1

# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# WooCommerce
WOOCOMMERCE_STORE_URL=https://your-store.com
WOOCOMMERCE_CONSUMER_KEY=ck_xxxxxxxxxxxx
WOOCOMMERCE_CONSUMER_SECRET=cs_xxxxxxxxxxxx

# Build Management
FLUTTER_PROJECT_PATH=/path/to/storefront_woo
ANDROID_KEYSTORE_PATH=/path/to/release.keystore
ANDROID_KEYSTORE_PASSWORD=your_keystore_password
ANDROID_KEY_ALIAS=release
ANDROID_KEY_PASSWORD=your_key_password

# Security
ENCRYPTION_KEY=your-32-byte-encryption-key

# Monitoring (Optional)
SENTRY_DSN=https://xxx@sentry.io/xxx
```

---

## 📊 Performance Optimization

### Next.js Configuration

```javascript
// next.config.js
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  
  // Standalone output for Docker
  output: 'standalone',
  
  // Image optimization
  images: {
    domains: ['supabase.co', 'your-store.com'],
    formats: ['image/avif', 'image/webp'],
  },
  
  // Compression
  compress: true,
  
  // Headers
  async headers() {
    return [
      {
        source: '/:path*',
        headers: [
          {
            key: 'X-DNS-Prefetch-Control',
            value: 'on'
          },
          {
            key: 'Strict-Transport-Security',
            value: 'max-age=63072000; includeSubDomains; preload'
          },
          {
            key: 'X-Frame-Options',
            value: 'DENY'
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff'
          },
          {
            key: 'Referrer-Policy',
            value: 'origin-when-cross-origin'
          }
        ]
      }
    ]
  },
  
  // Redirects
  async redirects() {
    return [
      {
        source: '/home',
        destination: '/dashboard',
        permanent: true,
      },
    ]
  },
}

module.exports = nextConfig
```

---

## 🔍 Monitoring & Logging

### 1. Vercel Analytics

```typescript
// src/app/layout.tsx
import { Analytics } from '@vercel/analytics/react';

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        {children}
        <Analytics />
      </body>
    </html>
  );
}
```

### 2. Error Tracking (Sentry)

```bash
# Install Sentry
pnpm add @sentry/nextjs
```

```typescript
// sentry.client.config.ts
import * as Sentry from "@sentry/nextjs";

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  tracesSampleRate: 1.0,
  environment: process.env.NODE_ENV,
});
```

### 3. Logging

```typescript
// src/lib/utils/logger.ts
import pino from 'pino';

export const logger = pino({
  level: process.env.NODE_ENV === 'production' ? 'info' : 'debug',
  transport: {
    target: 'pino-pretty',
    options: {
      colorize: true,
    },
  },
});
```

---

## 🔐 Security Checklist

### Pre-Deployment Security

- [ ] All environment variables configured
- [ ] API keys encrypted
- [ ] HTTPS/SSL enabled
- [ ] Security headers configured
- [ ] CORS properly configured
- [ ] Rate limiting enabled
- [ ] SQL injection prevention verified
- [ ] XSS protection enabled
- [ ] CSRF tokens implemented
- [ ] Input validation added
- [ ] File upload restrictions set
- [ ] Session security configured
- [ ] Audit logging enabled

---

## 🚦 Deployment Checklist

### Pre-Deployment

- [ ] All tests passing
- [ ] TypeScript compilation successful
- [ ] Linting errors fixed
- [ ] Production build tested locally
- [ ] Environment variables configured
- [ ] Database migrations run
- [ ] Backup taken
- [ ] Rollback plan prepared

### Deployment

- [ ] Deploy to staging first
- [ ] Smoke tests on staging
- [ ] Monitor staging for issues
- [ ] Deploy to production
- [ ] Verify production deployment
- [ ] Test critical paths
- [ ] Monitor error rates
- [ ] Check performance metrics

### Post-Deployment

- [ ] Monitor application logs
- [ ] Check error tracking (Sentry)
- [ ] Verify SSL certificate
- [ ] Test user flows
- [ ] Confirm email notifications
- [ ] Check database connections
- [ ] Monitor API response times
- [ ] Verify build triggers work
- [ ] Document any issues

---

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow

```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '20'
          
      - name: Setup pnpm
        uses: pnpm/action-setup@v2
        with:
          version: 9
          
      - name: Install dependencies
        run: pnpm install --frozen-lockfile
        
      - name: Type check
        run: pnpm type-check
        
      - name: Lint
        run: pnpm lint
        
      - name: Build
        run: pnpm build
        env:
          NEXT_PUBLIC_SUPABASE_URL: ${{ secrets.NEXT_PUBLIC_SUPABASE_URL }}
          NEXT_PUBLIC_SUPABASE_ANON_KEY: ${{ secrets.NEXT_PUBLIC_SUPABASE_ANON_KEY }}
          
      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'
```

---

## 📱 Health Checks

### Health Check Endpoint

```typescript
// src/app/api/health/route.ts
import { NextResponse } from 'next/server';
import { createClient } from '@/lib/supabase/server';

export async function GET() {
  const checks = {
    status: 'healthy',
    timestamp: new Date().toISOString(),
    checks: {
      database: false,
      api: false,
    },
  };

  try {
    // Check Supabase connection
    const supabase = createClient();
    const { error } = await supabase.from('stores').select('count').limit(1);
    checks.checks.database = !error;

    // Check API availability
    checks.checks.api = true;

    // Overall status
    const allHealthy = Object.values(checks.checks).every(c => c === true);
    checks.status = allHealthy ? 'healthy' : 'unhealthy';

    return NextResponse.json(checks, { 
      status: allHealthy ? 200 : 503 
    });
  } catch (error) {
    checks.status = 'unhealthy';
    return NextResponse.json(checks, { status: 503 });
  }
}
```

---

## 🆘 Troubleshooting

### Common Issues

**Issue: Build fails on Vercel**
```bash
# Check build logs
vercel logs [deployment-url]

# Common fixes:
# 1. Check environment variables
# 2. Verify package.json scripts
# 3. Check Node.js version
# 4. Clear build cache
```

**Issue: Environment variables not working**
```bash
# Verify variables are set
vercel env ls

# Pull environment variables locally
vercel env pull .env.local
```

**Issue: Docker container won't start**
```bash
# Check logs
docker logs admin-website

# Rebuild without cache
docker build --no-cache -t admin-website:latest .
```

---

## 📊 Post-Deployment Monitoring

### Metrics to Monitor

- Response time (p50, p95, p99)
- Error rate
- Request rate
- Database connection pool
- Memory usage
- CPU usage
- Build success rate
- API rate limits

### Alerting Setup

Set up alerts for:
- Error rate > 5%
- Response time > 2s
- Failed deployments
- SSL certificate expiration
- Disk space < 20%

---

**Document Version:** 1.0.0  
**Last Updated:** 2026-01-09  
**Status:** Complete
