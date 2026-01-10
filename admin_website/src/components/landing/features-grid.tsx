'use client';

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import {
  Package,
  ShoppingCart,
  Smartphone,
  Wrench,
  Code,
  BarChart3,
  Settings,
  Database,
  Zap,
  Shield,
} from 'lucide-react';

interface Feature {
  icon: React.ReactNode;
  title: string;
  description: string;
  color: string;
}

const features: Feature[] = [
  {
    icon: <Package className="h-4 w-4" />,
    title: 'Product Management',
    description: 'Sync, manage, and organize your WooCommerce products',
    color: 'text-blue-600',
  },
  {
    icon: <ShoppingCart className="h-4 w-4" />,
    title: 'Order Tracking',
    description: 'Monitor orders in real-time and track status updates',
    color: 'text-green-600',
  },
  {
    icon: <Smartphone className="h-4 w-4" />,
    title: 'App Configuration',
    description: 'Customize mobile app settings, themes, and features',
    color: 'text-purple-600',
  },
  {
    icon: <Wrench className="h-4 w-4" />,
    title: 'Build Management',
    description: 'Build iOS and Android apps with automated pipelines',
    color: 'text-orange-600',
  },
  {
    icon: <Code className="h-4 w-4" />,
    title: 'API Testing',
    description: 'Test APIs with Postman-like interface and code generation',
    color: 'text-indigo-600',
  },
  {
    icon: <BarChart3 className="h-4 w-4" />,
    title: 'Analytics Dashboard',
    description: 'View sales metrics, user analytics, and performance data',
    color: 'text-pink-600',
  },
  {
    icon: <Database className="h-4 w-4" />,
    title: 'WooCommerce Integration',
    description: 'Seamless connection with your WooCommerce store',
    color: 'text-cyan-600',
  },
  {
    icon: <Zap className="h-4 w-4" />,
    title: 'Real-time Updates',
    description: 'Get instant notifications and live data synchronization',
    color: 'text-yellow-600',
  },
  {
    icon: <Shield className="h-4 w-4" />,
    title: 'Secure & Reliable',
    description: 'Enterprise-grade security with role-based access control',
    color: 'text-red-600',
  },
];

export function FeaturesGrid() {
  return (
    <section className="py-12 bg-gray-50 dark:bg-gray-900">
      <div className="container mx-auto px-4">
        <div className="text-center mb-8">
          <h2 className="text-2xl lg:text-3xl font-bold mb-2">
            Features
          </h2>
          <p className="text-sm text-muted-foreground max-w-2xl mx-auto">
            Everything you need to manage your WooCommerce mobile app
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {features.map((feature, index) => (
            <Card key={index} className="hover:shadow-md transition-all">
              <CardHeader className="p-4">
                <div className={`inline-flex p-2 rounded-md bg-muted mb-3 ${feature.color}`}>
                  {feature.icon}
                </div>
                <CardTitle className="text-base mb-1">{feature.title}</CardTitle>
                <CardDescription className="text-sm">
                  {feature.description}
                </CardDescription>
              </CardHeader>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
}
