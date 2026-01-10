'use client';

import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import {
  Github,
  BookOpen,
  MessageSquare,
  AlertCircle,
  ExternalLink,
  Code,
  Rocket,
} from 'lucide-react';
import Link from 'next/link';

export function ProjectInfo() {
  return (
    <section className="py-16 bg-white dark:bg-gray-950">
      <div className="container mx-auto px-4">
        <div className="max-w-4xl mx-auto">
          <div className="text-center mb-12">
            <h2 className="text-3xl lg:text-4xl font-bold mb-4">
              About OSMEA Storefront Woo
            </h2>
            <p className="text-lg text-muted-foreground">
              Open Source Mobile E-commerce Architecture
            </p>
          </div>

          <Card className="mb-8">
            <CardContent className="p-8">
              <div className="prose prose-gray dark:prose-invert max-w-none">
                <p className="text-lg leading-relaxed mb-6">
                  <strong>OSMEA Storefront Woo</strong> is a complete e-commerce mobile application 
                  built with Flutter and integrated with WooCommerce. This admin panel provides 
                  a powerful interface for managing your WooCommerce store, configuring your mobile 
                  app, and building production-ready iOS and Android applications.
                </p>
                
                <div className="grid md:grid-cols-2 gap-6 my-8">
                  <div>
                    <h3 className="text-xl font-semibold mb-3">Key Features</h3>
                    <ul className="space-y-2 text-muted-foreground">
                      <li>• Complete WooCommerce integration</li>
                      <li>• Product and order management</li>
                      <li>• Mobile app configuration</li>
                      <li>• Build automation for iOS & Android</li>
                      <li>• API testing and code generation</li>
                      <li>• Real-time analytics</li>
                    </ul>
                  </div>
                  <div>
                    <h3 className="text-xl font-semibold mb-3">Technology Stack</h3>
                    <ul className="space-y-2 text-muted-foreground">
                      <li>• Next.js 15 with App Router</li>
                      <li>• TypeScript & Tailwind CSS</li>
                      <li>• Supabase for backend</li>
                      <li>• WooCommerce REST API</li>
                      <li>• Flutter for mobile apps</li>
                      <li>• Material Design 3</li>
                    </ul>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Quick Links */}
          <div className="flex flex-wrap items-center justify-center gap-2">
            <Button
              variant="outline"
              size="sm"
              className="h-8 gap-1.5"
              asChild
            >
              <a
                href="https://github.com/masterfabric-mobile/osmea"
                target="_blank"
                rel="noopener noreferrer"
              >
                <Github className="h-3.5 w-3.5" />
                <span className="text-xs">GitHub</span>
              </a>
            </Button>
            <Button
              variant="outline"
              size="sm"
              className="h-8 gap-1.5"
              asChild
            >
              <a
                href="https://github.com/masterfabric-mobile/osmea/tree/dev/docs"
                target="_blank"
                rel="noopener noreferrer"
              >
                <BookOpen className="h-3.5 w-3.5" />
                <span className="text-xs">Docs</span>
              </a>
            </Button>
            <Button
              variant="outline"
              size="sm"
              className="h-8 gap-1.5"
              asChild
            >
              <a
                href="https://github.com/masterfabric-mobile/osmea/issues"
                target="_blank"
                rel="noopener noreferrer"
              >
                <AlertCircle className="h-3.5 w-3.5" />
                <span className="text-xs">Issues</span>
              </a>
            </Button>
            <Button
              variant="outline"
              size="sm"
              className="h-8 gap-1.5"
              asChild
            >
              <a
                href="https://github.com/masterfabric-mobile/osmea/discussions"
                target="_blank"
                rel="noopener noreferrer"
              >
                <MessageSquare className="h-3.5 w-3.5" />
                <span className="text-xs">Discussions</span>
              </a>
            </Button>
          </div>
        </div>
      </div>
    </section>
  );
}

export function Footer() {
  return (
    <footer className="bg-gray-900 dark:bg-black text-gray-300 py-12">
      <div className="container mx-auto px-4">
        <div className="grid md:grid-cols-3 gap-8 mb-8">
          <div>
            <h3 className="text-white font-semibold mb-4">OSMEA</h3>
            <p className="text-sm text-gray-400">
              Open Source Mobile E-commerce Architecture
            </p>
            <p className="text-sm text-gray-400 mt-2">
              Built with ❤️ by the MasterFabric Team
            </p>
          </div>
          <div>
            <h3 className="text-white font-semibold mb-4">Resources</h3>
            <ul className="space-y-2 text-sm">
              <li>
                <a
                  href="https://github.com/masterfabric-mobile/osmea"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="hover:text-white transition-colors"
                >
                  GitHub Repository
                </a>
              </li>
              <li>
                <a
                  href="https://github.com/masterfabric-mobile/osmea/tree/dev/docs"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="hover:text-white transition-colors"
                >
                  Documentation
                </a>
              </li>
              <li>
                <a
                  href="https://github.com/masterfabric-mobile/osmea/issues"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="hover:text-white transition-colors"
                >
                  Report Issues
                </a>
              </li>
            </ul>
          </div>
          <div>
            <h3 className="text-white font-semibold mb-4">License</h3>
            <p className="text-sm text-gray-400">
              GNU AGPL v3.0
            </p>
            <p className="text-sm text-gray-400 mt-2">
              Open source and free to use
            </p>
          </div>
        </div>
        <div className="border-t border-gray-800 pt-8 text-center text-sm text-gray-400">
          <p>© 2025 MasterFabric Mobile • Maintained by the OSMEA Engineering Team</p>
        </div>
      </div>
    </footer>
  );
}
