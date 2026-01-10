'use client';

import { Button } from '@/components/ui/button';
import {
  Menu,
  Bell,
  Sun,
  Moon,
  HelpCircle,
  X,
  Package,
  ShoppingCart,
  Smartphone,
  Wrench,
  Database,
  ExternalLink,
} from 'lucide-react';
import { useState, useEffect } from 'react';
import { createPortal } from 'react-dom';

interface NavbarProps {
  onMenuClick?: () => void;
  showMenuButton?: boolean;
}

export function Navbar({ onMenuClick, showMenuButton = true }: NavbarProps) {
  const [isDark, setIsDark] = useState(false);
  const [showNotifications, setShowNotifications] = useState(false);
  const [showHelp, setShowHelp] = useState(false);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  useEffect(() => {
    // Check initial theme
    const isDarkMode = document.documentElement.classList.contains('dark');
    setIsDark(isDarkMode);
  }, []);

  const toggleTheme = () => {
    const newIsDark = !isDark;
    setIsDark(newIsDark);
    document.documentElement.classList.toggle('dark', newIsDark);
    localStorage.setItem('theme', newIsDark ? 'dark' : 'light');
  };

  return (
    <header className="sticky top-0 z-30 h-16 bg-white dark:bg-gray-900 border-b border-gray-200 dark:border-gray-800">
      <div className="flex items-center justify-between h-full px-4">
        {/* Left Section */}
        <div className="flex items-center gap-4">
          {showMenuButton && (
            <Button
              variant="ghost"
              size="icon"
              onClick={onMenuClick}
              className="lg:hidden"
            >
              <Menu className="h-5 w-5" />
            </Button>
          )}
        </div>

        {/* Right Section */}
        <div className="flex items-center gap-2">
          {/* Theme Toggle */}
          <Button variant="ghost" size="icon" onClick={toggleTheme}>
            {isDark ? (
              <Sun className="h-5 w-5" />
            ) : (
              <Moon className="h-5 w-5" />
            )}
          </Button>

          {/* Help */}
          <Button variant="ghost" size="icon" onClick={() => setShowHelp(true)}>
            <HelpCircle className="h-5 w-5" />
          </Button>

          {/* Help Modal - Using Portal */}
          {mounted && showHelp && createPortal(
            <>
              <div
                className="fixed inset-0 z-[9999] bg-black/50 backdrop-blur-sm"
                onClick={() => setShowHelp(false)}
              />
              <div className="fixed inset-x-4 top-[10%] z-[10000] mx-auto max-w-2xl rounded-xl bg-white dark:bg-gray-900 shadow-2xl border border-gray-200 dark:border-gray-800 max-h-[80vh] overflow-auto">
                {/* Header */}
                <div className="sticky top-0 bg-white dark:bg-gray-900 border-b border-gray-200 dark:border-gray-800 p-4 flex items-center justify-between">
                  <div>
                    <h2 className="text-xl font-bold">About OSMEA Admin Panel</h2>
                    <p className="text-sm text-muted-foreground">Your WooCommerce mobile app builder</p>
                  </div>
                  <Button variant="ghost" size="icon" onClick={() => setShowHelp(false)}>
                    <X className="h-5 w-5" />
                  </Button>
                </div>

                {/* Content */}
                <div className="p-6 space-y-6">
                  {/* What is OSMEA */}
                  <div>
                    <h3 className="font-semibold text-lg mb-2">What is OSMEA?</h3>
                    <p className="text-muted-foreground text-sm leading-relaxed">
                      OSMEA (Open Source Mobile E-commerce App) is an open-source solution that transforms your WooCommerce store into a beautiful native mobile application. This admin panel helps you manage, customize, and build your mobile app without any coding knowledge.
                    </p>
                  </div>

                  {/* How it Works */}
                  <div>
                    <h3 className="font-semibold text-lg mb-3">How It Works</h3>
                    <div className="grid gap-3">
                      <div className="flex gap-3 p-3 rounded-lg bg-muted/50">
                        <div className="h-10 w-10 rounded-lg bg-blue-100 dark:bg-blue-900/30 flex items-center justify-center flex-shrink-0">
                          <Database className="h-5 w-5 text-blue-600" />
                        </div>
                        <div>
                          <p className="font-medium text-sm">1. Connect Your Store</p>
                          <p className="text-xs text-muted-foreground">Link your WooCommerce store using API keys to sync products, orders, and customers.</p>
                        </div>
                      </div>
                      <div className="flex gap-3 p-3 rounded-lg bg-muted/50">
                        <div className="h-10 w-10 rounded-lg bg-purple-100 dark:bg-purple-900/30 flex items-center justify-center flex-shrink-0">
                          <Smartphone className="h-5 w-5 text-purple-600" />
                        </div>
                        <div>
                          <p className="font-medium text-sm">2. Customize Your App</p>
                          <p className="text-xs text-muted-foreground">Personalize colors, branding, layouts, and features to match your brand identity.</p>
                        </div>
                      </div>
                      <div className="flex gap-3 p-3 rounded-lg bg-muted/50">
                        <div className="h-10 w-10 rounded-lg bg-green-100 dark:bg-green-900/30 flex items-center justify-center flex-shrink-0">
                          <Wrench className="h-5 w-5 text-green-600" />
                        </div>
                        <div>
                          <p className="font-medium text-sm">3. Build & Deploy</p>
                          <p className="text-xs text-muted-foreground">Generate iOS and Android builds ready for App Store and Google Play submission.</p>
                        </div>
                      </div>
                    </div>
                  </div>

                  {/* Features */}
                  <div>
                    <h3 className="font-semibold text-lg mb-3">Dashboard Features</h3>
                    <div className="grid grid-cols-2 gap-2">
                      <div className="flex items-center gap-2 text-sm">
                        <Package className="h-4 w-4 text-muted-foreground" />
                        <span>Product Management</span>
                      </div>
                      <div className="flex items-center gap-2 text-sm">
                        <ShoppingCart className="h-4 w-4 text-muted-foreground" />
                        <span>Order Tracking</span>
                      </div>
                      <div className="flex items-center gap-2 text-sm">
                        <Smartphone className="h-4 w-4 text-muted-foreground" />
                        <span>App Configuration</span>
                      </div>
                      <div className="flex items-center gap-2 text-sm">
                        <Wrench className="h-4 w-4 text-muted-foreground" />
                        <span>Build Management</span>
                      </div>
                    </div>
                  </div>

                  {/* Links */}
                  <div className="pt-4 border-t border-gray-200 dark:border-gray-800">
                    <h3 className="font-semibold text-lg mb-3">Resources</h3>
                    <div className="flex flex-wrap gap-2">
                      <a
                        href="https://github.com/user/osmea"
                        target="_blank"
                        rel="noopener noreferrer"
                        className="inline-flex items-center gap-1.5 px-3 py-1.5 text-sm bg-muted rounded-md hover:bg-muted/80 transition-colors"
                      >
                        GitHub Repository
                        <ExternalLink className="h-3 w-3" />
                      </a>
                      <a
                        href="https://woocommerce.com/documentation/"
                        target="_blank"
                        rel="noopener noreferrer"
                        className="inline-flex items-center gap-1.5 px-3 py-1.5 text-sm bg-muted rounded-md hover:bg-muted/80 transition-colors"
                      >
                        WooCommerce Docs
                        <ExternalLink className="h-3 w-3" />
                      </a>
                      <a
                        href="https://supabase.com/docs"
                        target="_blank"
                        rel="noopener noreferrer"
                        className="inline-flex items-center gap-1.5 px-3 py-1.5 text-sm bg-muted rounded-md hover:bg-muted/80 transition-colors"
                      >
                        Supabase Docs
                        <ExternalLink className="h-3 w-3" />
                      </a>
                    </div>
                  </div>

                  {/* Version */}
                  <div className="text-center text-xs text-muted-foreground pt-2">
                    OSMEA Admin Panel v1.0.0 • Open Source • MIT License
                  </div>
                </div>
              </div>
            </>,
            document.body
          )}

          {/* Notifications */}
          <div className="relative">
            <Button
              variant="ghost"
              size="icon"
              onClick={() => setShowNotifications(!showNotifications)}
            >
              <Bell className="h-5 w-5" />
              <span className="absolute top-1 right-1 h-2 w-2 bg-red-500 rounded-full" />
            </Button>

            {showNotifications && (
              <>
                <div
                  className="fixed inset-0 z-40"
                  onClick={() => setShowNotifications(false)}
                />
                <div className="absolute right-0 mt-2 w-80 bg-white dark:bg-gray-900 rounded-lg shadow-lg border border-gray-200 dark:border-gray-800 z-50">
                  <div className="p-4 border-b border-gray-200 dark:border-gray-800">
                    <h3 className="font-semibold">Notifications</h3>
                  </div>
                  <div className="p-4">
                    <p className="text-sm text-muted-foreground text-center py-4">
                      No new notifications
                    </p>
                  </div>
                </div>
              </>
            )}
          </div>
        </div>
      </div>
    </header>
  );
}
