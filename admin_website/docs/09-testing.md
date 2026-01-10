# Testing Strategy

**Project:** OSMEA Admin Website  
**Version:** 1.0.0  
**Date:** 2026-01-09  
**Testing Stack:** Jest + React Testing Library + Playwright

---

## 📋 Overview

This document outlines the comprehensive testing strategy for the Admin Website, including unit tests, integration tests, end-to-end tests, and testing best practices.

---

## 🎯 Testing Pyramid

```
           /\
          /E2E\ ← End-to-End Tests (10%)
         /────\
        /Integ-\ ← Integration Tests (30%)
       /────────\
      /  Unit    \ ← Unit Tests (60%)
     /____________\
```

---

## 🧪 Testing Stack

### Core Testing Libraries

```json
// package.json (devDependencies)
{
  "@testing-library/react": "^14.1.2",
  "@testing-library/jest-dom": "^6.1.5",
  "@testing-library/user-event": "^14.5.1",
  "jest": "^29.7.0",
  "jest-environment-jsdom": "^29.7.0",
  "@playwright/test": "^1.40.1",
  "msw": "^2.0.11"
}
```

---

## 🔧 Setup Configuration

### 1. Jest Configuration

```javascript
// jest.config.js
const nextJest = require('next/jest');

const createJestConfig = nextJest({
  dir: './',
});

const customJestConfig = {
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  testEnvironment: 'jest-environment-jsdom',
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
  collectCoverageFrom: [
    'src/**/*.{js,jsx,ts,tsx}',
    '!src/**/*.d.ts',
    '!src/**/*.stories.{js,jsx,ts,tsx}',
    '!src/**/__tests__/**',
  ],
  coverageThreshold: {
    global: {
      branches: 70,
      functions: 70,
      lines: 70,
      statements: 70,
    },
  },
  testMatch: [
    '<rootDir>/src/**/__tests__/**/*.{js,jsx,ts,tsx}',
    '<rootDir>/src/**/*.{spec,test}.{js,jsx,ts,tsx}',
  ],
};

module.exports = createJestConfig(customJestConfig);
```

```javascript
// jest.setup.js
import '@testing-library/jest-dom';

// Mock Next.js router
jest.mock('next/navigation', () => ({
  useRouter() {
    return {
      push: jest.fn(),
      replace: jest.fn(),
      prefetch: jest.fn(),
      back: jest.fn(),
    };
  },
  usePathname() {
    return '/';
  },
  useSearchParams() {
    return new URLSearchParams();
  },
}));

// Mock Supabase
jest.mock('@/lib/supabase/client', () => ({
  createClient: jest.fn(() => ({
    auth: {
      getSession: jest.fn(),
      getUser: jest.fn(),
      signInWithPassword: jest.fn(),
      signOut: jest.fn(),
    },
    from: jest.fn(() => ({
      select: jest.fn().mockReturnThis(),
      insert: jest.fn().mockReturnThis(),
      update: jest.fn().mockReturnThis(),
      delete: jest.fn().mockReturnThis(),
      eq: jest.fn().mockReturnThis(),
      single: jest.fn(),
    })),
  })),
}));
```

### 2. Playwright Configuration

```typescript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
    {
      name: 'Mobile Chrome',
      use: { ...devices['Pixel 5'] },
    },
    {
      name: 'Mobile Safari',
      use: { ...devices['iPhone 12'] },
    },
  ],
  webServer: {
    command: 'pnpm dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
});
```

---

## ✅ Unit Tests

### Component Testing

```typescript
// src/components/ui/button.test.tsx
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { Button } from './button';

describe('Button Component', () => {
  it('renders correctly', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button', { name: /click me/i })).toBeInTheDocument();
  });

  it('handles click events', async () => {
    const handleClick = jest.fn();
    const user = userEvent.setup();
    
    render(<Button onClick={handleClick}>Click me</Button>);
    
    await user.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('renders different variants', () => {
    const { container } = render(<Button variant="destructive">Delete</Button>);
    expect(container.firstChild).toHaveClass('bg-destructive');
  });

  it('disables the button when disabled prop is true', () => {
    render(<Button disabled>Disabled</Button>);
    expect(screen.getByRole('button')).toBeDisabled();
  });

  it('renders as a link when asChild is true', () => {
    render(
      <Button asChild>
        <a href="/test">Link Button</a>
      </Button>
    );
    expect(screen.getByRole('link')).toBeInTheDocument();
  });
});
```

### Service Testing

```typescript
// src/lib/services/product.service.test.ts
import { ProductService } from './product.service';
import { getWooCommerceClient } from '@/lib/woocommerce/client';

jest.mock('@/lib/woocommerce/client');

describe('ProductService', () => {
  let productService: ProductService;
  let mockClient: any;

  beforeEach(() => {
    mockClient = {
      get: jest.fn(),
      post: jest.fn(),
      put: jest.fn(),
      delete: jest.fn(),
    };
    (getWooCommerceClient as jest.Mock).mockReturnValue(mockClient);
    productService = new ProductService();
  });

  describe('getProducts', () => {
    it('fetches products with default parameters', async () => {
      const mockProducts = [{ id: 1, name: 'Product 1' }];
      mockClient.get.mockResolvedValue(mockProducts);

      const result = await productService.getProducts();

      expect(mockClient.get).toHaveBeenCalledWith('/products', {
        page: 1,
        per_page: 20,
        orderby: 'date',
        order: 'desc',
      });
      expect(result).toEqual(mockProducts);
    });

    it('fetches products with custom query', async () => {
      const mockProducts = [{ id: 2, name: 'Product 2' }];
      mockClient.get.mockResolvedValue(mockProducts);

      await productService.getProducts({
        page: 2,
        per_page: 10,
        search: 'test',
        category: 5,
      });

      expect(mockClient.get).toHaveBeenCalledWith('/products', {
        page: 2,
        per_page: 10,
        search: 'test',
        category: 5,
        orderby: 'date',
        order: 'desc',
      });
    });
  });

  describe('createProduct', () => {
    it('creates a new product', async () => {
      const newProduct = { name: 'New Product', price: '99.99' };
      const createdProduct = { id: 3, ...newProduct };
      mockClient.post.mockResolvedValue(createdProduct);

      const result = await productService.createProduct(newProduct);

      expect(mockClient.post).toHaveBeenCalledWith('/products', newProduct);
      expect(result).toEqual(createdProduct);
    });
  });

  describe('updateProduct', () => {
    it('updates an existing product', async () => {
      const updates = { price: '79.99' };
      const updatedProduct = { id: 1, name: 'Product 1', ...updates };
      mockClient.put.mockResolvedValue(updatedProduct);

      const result = await productService.updateProduct(1, updates);

      expect(mockClient.put).toHaveBeenCalledWith('/products/1', updates);
      expect(result).toEqual(updatedProduct);
    });
  });

  describe('deleteProduct', () => {
    it('deletes a product', async () => {
      const deletedProduct = { id: 1, name: 'Deleted Product' };
      mockClient.delete.mockResolvedValue(deletedProduct);

      const result = await productService.deleteProduct(1, true);

      expect(mockClient.delete).toHaveBeenCalledWith('/products/1', { force: true });
      expect(result).toEqual(deletedProduct);
    });
  });
});
```

### Hook Testing

```typescript
// src/lib/hooks/use-permissions.test.tsx
import { renderHook } from '@testing-library/react';
import { usePermissions } from './use-permissions';
import { useAuth } from '@/lib/context/auth-context';

jest.mock('@/lib/context/auth-context');

describe('usePermissions', () => {
  it('returns correct permissions for super admin', () => {
    (useAuth as jest.Mock).mockReturnValue({
      adminUser: {
        role: 'super_admin',
        permissions: {},
      },
    });

    const { result } = renderHook(() => usePermissions());

    expect(result.current.hasPermission('config:write')).toBe(true);
    expect(result.current.hasPermission('users:delete')).toBe(true);
    expect(result.current.isAdmin).toBe(true);
  });

  it('returns limited permissions for viewer', () => {
    (useAuth as jest.Mock).mockReturnValue({
      adminUser: {
        role: 'viewer',
        permissions: {},
      },
    });

    const { result } = renderHook(() => usePermissions());

    expect(result.current.hasPermission('config:read')).toBe(true);
    expect(result.current.hasPermission('config:write')).toBe(false);
    expect(result.current.isViewer).toBe(true);
  });

  it('checks custom permissions', () => {
    (useAuth as jest.Mock).mockReturnValue({
      adminUser: {
        role: 'content_editor',
        permissions: {
          'custom:action': true,
        },
      },
    });

    const { result } = renderHook(() => usePermissions());

    expect(result.current.hasPermission('custom:action' as any)).toBe(true);
  });
});
```

---

## 🔗 Integration Tests

### API Integration

```typescript
// src/actions/product.actions.test.ts
import { getProducts, createProduct, updateProduct } from './product.actions';
import { productService } from '@/lib/services/product.service';
import { createAuditLog } from '@/lib/utils/audit';

jest.mock('@/lib/services/product.service');
jest.mock('@/lib/utils/audit');

describe('Product Actions', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('getProducts', () => {
    it('returns products successfully', async () => {
      const mockProducts = [{ id: 1, name: 'Product 1' }];
      (productService.getProducts as jest.Mock).mockResolvedValue(mockProducts);

      const result = await getProducts();

      expect(result.success).toBe(true);
      expect(result.data).toEqual(mockProducts);
    });

    it('handles errors gracefully', async () => {
      (productService.getProducts as jest.Mock).mockRejectedValue(
        new Error('API Error')
      );

      const result = await getProducts();

      expect(result.success).toBe(false);
      expect(result.error).toBe('API Error');
    });
  });

  describe('createProduct', () => {
    it('creates product and logs audit', async () => {
      const newProduct = { name: 'New Product' };
      const createdProduct = { id: 1, ...newProduct };
      (productService.createProduct as jest.Mock).mockResolvedValue(createdProduct);

      const result = await createProduct(newProduct);

      expect(result.success).toBe(true);
      expect(result.data).toEqual(createdProduct);
      expect(createAuditLog).toHaveBeenCalledWith({
        action: 'product:create',
        entityType: 'product',
        entityId: '1',
        newValue: createdProduct,
      });
    });
  });
});
```

### Database Integration

```typescript
// src/lib/services/supabase.service.test.ts
import { SupabaseService } from './supabase.service';
import { createClient } from '@/lib/supabase/server';

jest.mock('@/lib/supabase/server');

describe('SupabaseService', () => {
  let service: SupabaseService;
  let mockSupabase: any;

  beforeEach(() => {
    mockSupabase = {
      from: jest.fn().mockReturnThis(),
      select: jest.fn().mockReturnThis(),
      insert: jest.fn().mockReturnThis(),
      update: jest.fn().mockReturnThis(),
      eq: jest.fn().mockReturnThis(),
      order: jest.fn().mockReturnThis(),
      limit: jest.fn().mockReturnThis(),
      single: jest.fn(),
    };
    (createClient as jest.Mock).mockReturnValue(mockSupabase);
    service = new SupabaseService();
  });

  it('gets configurations', async () => {
    const mockConfigs = [{ id: '1', config_key: 'app_config' }];
    mockSupabase.single.mockResolvedValue({ data: mockConfigs, error: null });

    const result = await service.getConfigurations('store-1');

    expect(mockSupabase.from).toHaveBeenCalledWith('app_configurations');
    expect(mockSupabase.eq).toHaveBeenCalledWith('store_id', 'store-1');
    expect(result).toEqual(mockConfigs);
  });
});
```

---

## 🌐 End-to-End Tests

### Authentication Flow

```typescript
// e2e/auth.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Authentication', () => {
  test('should login successfully', async ({ page }) => {
    await page.goto('/login');

    await page.fill('input[type="email"]', 'admin@example.com');
    await page.fill('input[type="password"]', 'password123');
    await page.click('button[type="submit"]');

    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('h1')).toContainText('Dashboard');
  });

  test('should show error for invalid credentials', async ({ page }) => {
    await page.goto('/login');

    await page.fill('input[type="email"]', 'wrong@example.com');
    await page.fill('input[type="password"]', 'wrongpassword');
    await page.click('button[type="submit"]');

    await expect(page.locator('[role="alert"]')).toBeVisible();
    await expect(page.locator('[role="alert"]')).toContainText('Invalid credentials');
  });

  test('should logout successfully', async ({ page }) => {
    // Login first
    await page.goto('/login');
    await page.fill('input[type="email"]', 'admin@example.com');
    await page.fill('input[type="password"]', 'password123');
    await page.click('button[type="submit"]');

    await expect(page).toHaveURL('/dashboard');

    // Logout
    await page.click('[data-testid="user-menu"]');
    await page.click('[data-testid="logout-button"]');

    await expect(page).toHaveURL('/login');
  });
});
```

### Product Management Flow

```typescript
// e2e/products.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Product Management', () => {
  test.beforeEach(async ({ page }) => {
    // Login
    await page.goto('/login');
    await page.fill('input[type="email"]', 'admin@example.com');
    await page.fill('input[type="password"]', 'password123');
    await page.click('button[type="submit"]');
  });

  test('should display products list', async ({ page }) => {
    await page.goto('/dashboard/products');

    await expect(page.locator('h1')).toContainText('Products');
    await expect(page.locator('[data-testid="product-list"]')).toBeVisible();
  });

  test('should create new product', async ({ page }) => {
    await page.goto('/dashboard/products');
    await page.click('[data-testid="add-product-button"]');

    await page.fill('input[name="name"]', 'Test Product');
    await page.fill('input[name="price"]', '99.99');
    await page.fill('textarea[name="description"]', 'Test description');
    await page.click('button[type="submit"]');

    await expect(page.locator('[role="alert"]')).toContainText('Product created');
  });

  test('should update product', async ({ page }) => {
    await page.goto('/dashboard/products/1');

    await page.fill('input[name="name"]', 'Updated Product Name');
    await page.click('button:has-text("Save")');

    await expect(page.locator('[role="alert"]')).toContainText('Product updated');
  });

  test('should delete product', async ({ page }) => {
    await page.goto('/dashboard/products');

    await page.click('[data-testid="product-1"] [data-testid="delete-button"]');
    await page.click('[data-testid="confirm-delete"]');

    await expect(page.locator('[role="alert"]')).toContainText('Product deleted');
  });
});
```

### Build Management Flow

```typescript
// e2e/builds.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Build Management', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/login');
    await page.fill('input[type="email"]', 'admin@example.com');
    await page.fill('input[type="password"]', 'password123');
    await page.click('button[type="submit"]');
  });

  test('should trigger new build', async ({ page }) => {
    await page.goto('/dashboard/builds');
    await page.click('[data-testid="new-build-button"]');

    await page.selectOption('select[name="platform"]', 'android');
    await page.selectOption('select[name="buildType"]', 'release');
    await page.selectOption('select[name="environment"]', 'prod');
    await page.click('button:has-text("Start Build")');

    await expect(page.locator('[role="alert"]')).toContainText('Build started');
  });

  test('should view build logs', async ({ page }) => {
    await page.goto('/dashboard/builds/1');

    await expect(page.locator('h1')).toContainText('Build #');
    await expect(page.locator('[data-testid="build-logs"]')).toBeVisible();
  });
});
```

---

## 📊 Test Coverage

### Coverage Goals

| Category | Target | Status |
|----------|--------|--------|
| Statements | ≥ 70% | 🎯 |
| Branches | ≥ 70% | 🎯 |
| Functions | ≥ 70% | 🎯 |
| Lines | ≥ 70% | 🎯 |

### Generate Coverage Report

```bash
# Run tests with coverage
pnpm test --coverage

# View coverage report
open coverage/lcov-report/index.html
```

---

## 🚀 Running Tests

### Unit & Integration Tests

```bash
# Run all tests
pnpm test

# Watch mode
pnpm test --watch

# Run specific test file
pnpm test button.test.tsx

# Update snapshots
pnpm test -u
```

### E2E Tests

```bash
# Install Playwright browsers
pnpm exec playwright install

# Run E2E tests
pnpm test:e2e

# Run E2E tests in UI mode
pnpm exec playwright test --ui

# Run specific test
pnpm exec playwright test auth.spec.ts

# Debug mode
pnpm exec playwright test --debug
```

---

## ✅ Testing Best Practices

### General Principles

- [ ] Write tests before or alongside code (TDD)
- [ ] Test behavior, not implementation
- [ ] Keep tests simple and readable
- [ ] Use descriptive test names
- [ ] Arrange-Act-Assert pattern
- [ ] Mock external dependencies
- [ ] Clean up after tests
- [ ] Avoid test interdependencies
- [ ] Use data-testid for E2E testing
- [ ] Test edge cases and error scenarios

### Component Testing

- [ ] Test user interactions
- [ ] Test different props combinations
- [ ] Test accessibility
- [ ] Test responsive behavior
- [ ] Test loading and error states

### Integration Testing

- [ ] Test API integration
- [ ] Test database operations
- [ ] Test authentication flow
- [ ] Test authorization rules

### E2E Testing

- [ ] Test critical user journeys
- [ ] Test on multiple browsers
- [ ] Test on mobile viewports
- [ ] Test offline scenarios
- [ ] Test performance

---

## 📝 Test Documentation

### Document Test Cases

```typescript
/**
 * Test Suite: Product Management
 * 
 * Scenarios:
 * 1. Display products list
 * 2. Create new product
 * 3. Update existing product
 * 4. Delete product
 * 5. Search products
 * 6. Filter by category
 * 7. Sort products
 * 8. Pagination
 * 
 * Coverage: ProductService, product actions, product pages
 */
```

---

**Document Version:** 1.0.0  
**Last Updated:** 2026-01-09  
**Status:** Complete
