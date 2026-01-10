'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { checkSupabaseConnection } from '@/lib/supabase/client';
import { Loader2 } from 'lucide-react';

export default function SplashPage() {
  const router = useRouter();
  const [status, setStatus] = useState<string>('Initializing...');

  useEffect(() => {
    async function initialize() {
      try {
        setStatus('Checking Supabase connection...');
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        const isConnected = await checkSupabaseConnection();
        
        if (!isConnected) {
          setStatus('Supabase not configured');
          await new Promise(resolve => setTimeout(resolve, 1500));
          router.push('/onboarding');
        } else {
          setStatus('Loading admin panel...');
          await new Promise(resolve => setTimeout(resolve, 800));
          router.push('/dashboard');
        }
      } catch (error) {
        console.error('Initialization error:', error);
        setStatus('Setup required');
        await new Promise(resolve => setTimeout(resolve, 1500));
        router.push('/onboarding');
      }
    }

    initialize();
  }, [router]);

  return (
    <div className="flex min-h-screen flex-col items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100 dark:from-gray-900 dark:to-gray-800">
      <div className="text-center space-y-6">
        <div className="flex justify-center">
          <div className="w-24 h-24 bg-primary rounded-2xl flex items-center justify-center shadow-2xl">
            <span className="text-4xl font-bold text-white">O</span>
          </div>
        </div>
        
        <div className="space-y-2">
          <h1 className="text-4xl font-bold text-gray-900 dark:text-white">
            OSMEA Admin Panel
          </h1>
          <p className="text-gray-600 dark:text-gray-300">
            WooCommerce App Builder
          </p>
        </div>

        <div className="flex flex-col items-center gap-3 mt-8">
          <Loader2 className="h-8 w-8 animate-spin text-primary" />
          <p className="text-sm text-gray-600 dark:text-gray-400">{status}</p>
        </div>
      </div>

      <footer className="absolute bottom-8 text-center text-sm text-gray-500 dark:text-gray-400">
        <p>Version 1.0.0 • Built with Next.js</p>
      </footer>
    </div>
  );
}
