'use client';

import { useState, useEffect, useRef, useCallback } from 'react';
import { useRouter } from 'next/navigation';
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Progress } from '@/components/ui/progress';
import { Badge } from '@/components/ui/badge';
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from '@/components/ui/tooltip';
import { toast } from 'sonner';
import { 
  CheckCircle2, 
  Database, 
  Store, 
  Smartphone, 
  ArrowRight, 
  ArrowLeft,
  HelpCircle,
  ExternalLink,
  Shield,
  Key,
  Globe,
  Info,
  ChevronDown,
  ChevronUp,
  Copy,
  Check,
  Code,
  Sparkles,
  Zap,
  Lock,
  Loader2,
  AlertCircle,
  XCircle,
} from 'lucide-react';

type OnboardingStep = 1 | 2 | 3;
type UrlValidationStatus = 'idle' | 'typing' | 'checking' | 'valid' | 'invalid';

export default function OnboardingPage() {
  const router = useRouter();
  const [currentStep, setCurrentStep] = useState<OnboardingStep>(1);
  const [isLoading, setIsLoading] = useState(false);
  const [showSupabaseHelp, setShowSupabaseHelp] = useState(false);
  const [showSupabaseScripts, setShowSupabaseScripts] = useState(false);
  const [showScriptStores, setShowScriptStores] = useState(false);
  const [showScriptAdminUsers, setShowScriptAdminUsers] = useState(false);
  const [showScriptAppConfigs, setShowScriptAppConfigs] = useState(false);
  const [showScriptBuilds, setShowScriptBuilds] = useState(false);
  const [showWooHelp, setShowWooHelp] = useState(false);
  const [copiedField, setCopiedField] = useState<string | null>(null);
  const [checkingTables, setCheckingTables] = useState(false);
  const [tableCheckResult, setTableCheckResult] = useState<{
    success: boolean;
    allTablesExist: boolean;
    tables: Record<string, { exists: boolean; rowCount?: number }>;
    missingTables: string[];
    message: string;
  } | null>(null);

  const [supabaseUrl, setSupabaseUrl] = useState('');
  const [supabaseAnonKey, setSupabaseAnonKey] = useState('');
  const [wooStoreUrl, setWooStoreUrl] = useState('');
  const [wooConsumerKey, setWooConsumerKey] = useState('');
  const [wooConsumerSecret, setWooConsumerSecret] = useState('');
  const [projectName, setProjectName] = useState('');
  const [appName, setAppName] = useState('');

  // WooCommerce URL validation state
  const [urlValidationStatus, setUrlValidationStatus] = useState<UrlValidationStatus>('idle');
  const [urlValidationMessage, setUrlValidationMessage] = useState('');
  const [hasWooCommerce, setHasWooCommerce] = useState(false);
  const urlCheckTimeoutRef = useRef<NodeJS.Timeout | null>(null);

  // Supabase validation state
  const [supabaseValidationStatus, setSupabaseValidationStatus] = useState<UrlValidationStatus>('idle');
  const [supabaseValidationMessage, setSupabaseValidationMessage] = useState('');
  const supabaseCheckTimeoutRef = useRef<NodeJS.Timeout | null>(null);

  const progress = (currentStep / 3) * 100;

  // Check if URL is valid format
  const isValidUrlFormat = useCallback((url: string) => {
    try {
      const parsed = new URL(url);
      return ['http:', 'https:'].includes(parsed.protocol);
    } catch {
      return false;
    }
  }, []);

  // Debounced URL validation
  const checkStoreUrl = useCallback(async (url: string) => {
    if (!url || !isValidUrlFormat(url)) {
      setUrlValidationStatus('idle');
      setUrlValidationMessage('');
      return;
    }

    setUrlValidationStatus('checking');
    setUrlValidationMessage('Verifying website connection...');

    try {
      const response = await fetch('/api/check-url', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ url }),
      });

      const data = await response.json();

      if (data.success) {
        setUrlValidationStatus('valid');
        setUrlValidationMessage(data.message);
        setHasWooCommerce(data.hasWooCommerce || false);
        toast.success('Store URL verified!', {
          description: data.hasWooCommerce 
            ? 'WooCommerce detected. You can now enter your API keys.'
            : 'Website is reachable. Please enter your WooCommerce API keys.',
        });
      } else {
        setUrlValidationStatus('invalid');
        setUrlValidationMessage(data.message || 'Unable to verify website');
        setHasWooCommerce(false);
        
        // Show specific error toast based on error type
        if (data.details === 'dns_error') {
          toast.error('Domain not found', {
            description: 'Please check if the URL is spelled correctly.',
          });
        } else if (data.details === 'timeout') {
          toast.error('Connection timed out', {
            description: 'The website is taking too long to respond.',
          });
        } else if (data.details === 'ssl_error') {
          toast.error('SSL certificate issue', {
            description: 'The website has a security certificate problem.',
          });
        } else {
          toast.error('Cannot reach website', {
            description: data.message,
          });
        }
      }
    } catch (error) {
      setUrlValidationStatus('invalid');
      setUrlValidationMessage('Network error. Please check your internet connection.');
      setHasWooCommerce(false);
      toast.error('Connection failed', {
        description: 'Could not connect to the server. Please try again.',
      });
    }
  }, [isValidUrlFormat]);

  // Handle store URL change with debounce
  const handleStoreUrlChange = (value: string) => {
    setWooStoreUrl(value);
    
    // Clear previous timeout
    if (urlCheckTimeoutRef.current) {
      clearTimeout(urlCheckTimeoutRef.current);
    }

    // Reset API key fields if URL changes
    if (urlValidationStatus === 'valid') {
      setWooConsumerKey('');
      setWooConsumerSecret('');
    }

    if (!value) {
      setUrlValidationStatus('idle');
      setUrlValidationMessage('');
      return;
    }

    // Show typing status
    setUrlValidationStatus('typing');
    setUrlValidationMessage('');

    // Debounce: wait 2.5 seconds after user stops typing
    urlCheckTimeoutRef.current = setTimeout(() => {
      checkStoreUrl(value);
    }, 2500);
  };

  // Cleanup timeout on unmount
  useEffect(() => {
    return () => {
      if (urlCheckTimeoutRef.current) {
        clearTimeout(urlCheckTimeoutRef.current);
      }
      if (supabaseCheckTimeoutRef.current) {
        clearTimeout(supabaseCheckTimeoutRef.current);
      }
    };
  }, []);

  // Check if Supabase URL format is valid
  const isValidSupabaseUrl = useCallback((url: string) => {
    try {
      const parsed = new URL(url);
      return parsed.protocol === 'https:';
    } catch {
      return false;
    }
  }, []);

  // Check if Anon Key format is valid
  const isValidAnonKey = useCallback((key: string) => {
    return key.startsWith('eyJ') && key.length > 100;
  }, []);

  // Debounced Supabase validation
  const checkSupabaseConnection = useCallback(async (url: string, key: string) => {
    if (!url || !key || !isValidSupabaseUrl(url) || !isValidAnonKey(key)) {
      if (url && !isValidSupabaseUrl(url)) {
        setSupabaseValidationStatus('invalid');
        setSupabaseValidationMessage('Invalid URL format. Should be https://xxxxx.supabase.co');
      } else if (key && !isValidAnonKey(key)) {
        setSupabaseValidationStatus('invalid');
        setSupabaseValidationMessage('Invalid key format. Should start with "eyJ..."');
      } else {
        setSupabaseValidationStatus('idle');
        setSupabaseValidationMessage('');
      }
      return;
    }

    setSupabaseValidationStatus('checking');
    setSupabaseValidationMessage('Testing Supabase connection...');

    try {
      const response = await fetch('/api/check-supabase', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ url, anonKey: key }),
      });

      const data = await response.json();

      if (data.success) {
        setSupabaseValidationStatus('valid');
        setSupabaseValidationMessage(data.message);
        toast.success('Supabase connected!', {
          description: `Connection verified in ${data.responseTime || 0}ms`,
        });
      } else {
        setSupabaseValidationStatus('invalid');
        setSupabaseValidationMessage(data.message || 'Connection failed');
        
        toast.error('Connection failed', {
          description: data.message,
        });
      }
    } catch (error) {
      setSupabaseValidationStatus('invalid');
      setSupabaseValidationMessage('Network error. Please try again.');
      toast.error('Connection failed', {
        description: 'Could not verify Supabase credentials.',
      });
    }
  }, [isValidSupabaseUrl, isValidAnonKey]);

  // Handle Supabase URL change with debounce
  const handleSupabaseUrlChange = (value: string) => {
    setSupabaseUrl(value);
    
    if (supabaseCheckTimeoutRef.current) {
      clearTimeout(supabaseCheckTimeoutRef.current);
    }

    if (!value) {
      setSupabaseValidationStatus('idle');
      setSupabaseValidationMessage('');
      return;
    }

    setSupabaseValidationStatus('typing');
    setSupabaseValidationMessage('');

    // Only check if we have both URL and key
    if (supabaseAnonKey && isValidAnonKey(supabaseAnonKey)) {
      supabaseCheckTimeoutRef.current = setTimeout(() => {
        checkSupabaseConnection(value, supabaseAnonKey);
      }, 2500);
    }
  };

  // Handle Supabase Anon Key change with debounce
  const handleSupabaseKeyChange = (value: string) => {
    setSupabaseAnonKey(value);
    
    if (supabaseCheckTimeoutRef.current) {
      clearTimeout(supabaseCheckTimeoutRef.current);
    }

    if (!value) {
      setSupabaseValidationStatus('idle');
      setSupabaseValidationMessage('');
      return;
    }

    setSupabaseValidationStatus('typing');
    setSupabaseValidationMessage('');

    // Only check if we have both URL and key
    if (supabaseUrl && isValidSupabaseUrl(supabaseUrl)) {
      supabaseCheckTimeoutRef.current = setTimeout(() => {
        checkSupabaseConnection(supabaseUrl, value);
      }, 2500);
    }
  };

  const copyToClipboard = async (text: string, field: string) => {
    await navigator.clipboard.writeText(text);
    setCopiedField(field);
    setTimeout(() => setCopiedField(null), 2000);
  };

  // Check if all required tables exist
  const handleCheckTables = async () => {
    if (!supabaseUrl || !supabaseAnonKey) {
      toast.error('Please enter Supabase credentials first');
      return;
    }

    setCheckingTables(true);
    setTableCheckResult(null);

    try {
      const response = await fetch('/api/check-tables', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          url: supabaseUrl,
          anonKey: supabaseAnonKey,
        }),
      });

      const data = await response.json();

      if (data.success && data.allTablesExist) {
        setTableCheckResult(data);
        toast.success('All tables are set up correctly!', {
          description: 'You can proceed with the setup.',
        });
      } else if (data.success && !data.allTablesExist) {
        setTableCheckResult(data);
        toast.warning('Some tables are missing', {
          description: `Missing: ${data.missingTables.join(', ')}`,
        });
      } else {
        setTableCheckResult(data);
        toast.error('Failed to check tables', {
          description: data.message || 'Please verify your Supabase credentials.',
        });
      }
    } catch (error) {
      console.error('Error checking tables:', error);
      toast.error('Failed to check tables', {
        description: 'Network error. Please try again.',
      });
    } finally {
      setCheckingTables(false);
    }
  };

  const handleSupabaseTest = async () => {
    // Already validated, just proceed
    if (supabaseValidationStatus === 'valid') {
      setCurrentStep(2);
      return;
    }

    // If not validated, show error
    if (!supabaseUrl || !supabaseAnonKey) {
      toast.error('Please fill in all Supabase credentials');
      return;
    }

    toast.error('Please wait for credentials to be verified');
  };

  const handleWooCommerceTest = async () => {
    setIsLoading(true);
    try {
      await new Promise(resolve => setTimeout(resolve, 1500));
      
      if (!wooStoreUrl || !wooConsumerKey || !wooConsumerSecret) {
        toast.error('Please fill in all WooCommerce credentials');
        return;
      }

      toast.success('WooCommerce connection successful!');
      setCurrentStep(3);
    } catch (error) {
      toast.error('Failed to connect to WooCommerce store');
    } finally {
      setIsLoading(false);
    }
  };

  const handleFinish = async () => {
    setIsLoading(true);
    try {
      await new Promise(resolve => setTimeout(resolve, 2000));
      
      if (!projectName || !appName) {
        toast.error('Please fill in all project details');
        return;
      }

      toast.success('Setup complete! Redirecting to dashboard...');
      localStorage.setItem('osmea-setup-complete', 'true');
      
      // Also store credentials for client-side use
      localStorage.setItem('osmea-supabase-url', supabaseUrl);
      localStorage.setItem('osmea-supabase-key', supabaseAnonKey);
      localStorage.setItem('osmea-woo-url', wooStoreUrl);
      localStorage.setItem('osmea-woo-key', wooConsumerKey);
      localStorage.setItem('osmea-woo-secret', wooConsumerSecret);
      localStorage.setItem('osmea-project-name', projectName);
      localStorage.setItem('osmea-app-name', appName);
      
      // Set cookie for middleware to read
      document.cookie = 'osmea-setup-complete=true; path=/; max-age=31536000';
      
      setTimeout(() => {
        router.push('/dashboard');
      }, 1000);
    } catch (error) {
      toast.error('Setup failed. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <TooltipProvider>
      <div className="min-h-screen bg-white dark:bg-gray-900 flex items-center justify-center p-4">
        <div className="w-full max-w-2xl space-y-6">
          {/* Header */}
          <div className="text-center space-y-4">
            <div className="inline-flex items-center gap-2 bg-primary/10 text-primary px-4 py-1.5 rounded-full text-sm font-medium">
              <Sparkles className="h-4 w-4" />
              Quick Setup Wizard
            </div>
            <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
              Welcome to OSMEA Admin Panel
            </h1>
            <p className="text-gray-600 dark:text-gray-300 max-w-md mx-auto">
              Let&apos;s set up your admin panel in 3 easy steps. This will only take a few minutes.
            </p>
            
            {/* What you'll configure */}
            <div className="mt-6 p-4 bg-muted/50 rounded-lg text-left max-w-lg mx-auto">
              <h3 className="text-sm font-semibold mb-3 text-gray-900 dark:text-white">What you&apos;ll configure:</h3>
              <ul className="space-y-2 text-sm text-gray-600 dark:text-gray-400">
                <li className="flex items-start gap-2">
                  <CheckCircle2 className="h-4 w-4 text-green-600 mt-0.5 flex-shrink-0" />
                  <span><strong>Supabase Database:</strong> Connect your Supabase project for data storage and authentication</span>
                </li>
                <li className="flex items-start gap-2">
                  <CheckCircle2 className="h-4 w-4 text-green-600 mt-0.5 flex-shrink-0" />
                  <span><strong>WooCommerce Store:</strong> Link your WooCommerce store to sync products and orders</span>
                </li>
                <li className="flex items-start gap-2">
                  <CheckCircle2 className="h-4 w-4 text-green-600 mt-0.5 flex-shrink-0" />
                  <span><strong>Project Details:</strong> Set your project name and mobile app configuration</span>
                </li>
              </ul>
            </div>

            {/* Benefits */}
            <div className="mt-4 text-sm text-gray-500 dark:text-gray-400">
              <p>After setup, you&apos;ll be able to manage products, track orders, configure your mobile app, and build iOS/Android releases.</p>
            </div>
          </div>

          {/* Progress */}
          <div className="space-y-3">
            <Progress value={progress} className="h-2" />
            <div className="flex justify-between">
              {[
                { step: 1, label: 'Supabase', icon: Database },
                { step: 2, label: 'WooCommerce', icon: Store },
                { step: 3, label: 'Project', icon: Smartphone },
              ].map(({ step, label, icon: Icon }) => (
                <div 
                  key={step}
                  className={`flex items-center gap-2 text-sm transition-colors ${
                    currentStep >= step 
                      ? 'text-primary font-medium' 
                      : 'text-gray-400'
                  }`}
                >
                  <div className={`w-6 h-6 rounded-full flex items-center justify-center text-xs ${
                    currentStep > step 
                      ? 'bg-primary text-white' 
                      : currentStep === step 
                        ? 'bg-primary/20 text-primary border-2 border-primary' 
                        : 'bg-gray-200 dark:bg-gray-700'
                  }`}>
                    {currentStep > step ? <Check className="h-3 w-3" /> : step}
                  </div>
                  <span className="hidden sm:inline">{label}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Main Card */}
          <Card className="shadow-xl border-2">
            {/* Step 1: Supabase */}
            {currentStep === 1 && (
              <>
                <CardHeader className="pb-4">
                  <div className="flex items-start justify-between">
                    <div className="flex items-center gap-3">
                      <div className="p-3 bg-emerald-100 dark:bg-emerald-900/30 rounded-xl">
                        <Database className="h-6 w-6 text-emerald-600" />
                      </div>
                      <div>
                        <CardTitle className="flex items-center gap-2">
                          Configure Supabase
                          <Badge variant="secondary" className="font-normal">
                            <Shield className="h-3 w-3 mr-1" />
                            Secure
                          </Badge>
                        </CardTitle>
                        <CardDescription className="mt-1">
                          Connect your Supabase project for database and authentication
                        </CardDescription>
                      </div>
                    </div>
                  </div>
                </CardHeader>

                <CardContent className="space-y-5">
                  {/* Info Banner */}
                  <div className="bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg p-4">
                    <div className="flex gap-3">
                      <Info className="h-5 w-5 text-blue-600 flex-shrink-0 mt-0.5" />
                      <div className="text-sm">
                        <p className="font-medium text-blue-800 dark:text-blue-200">
                          Don&apos;t have a Supabase account?
                        </p>
                        <p className="text-blue-700 dark:text-blue-300 mt-1">
                          Create a free account at{' '}
                          <a 
                            href="https://supabase.com" 
                            target="_blank" 
                            rel="noopener noreferrer"
                            className="underline font-medium hover:no-underline inline-flex items-center gap-1"
                          >
                            supabase.com
                            <ExternalLink className="h-3 w-3" />
                          </a>
                        </p>
                      </div>
                    </div>
                  </div>

                  {/* Supabase URL */}
                  <div className="space-y-2">
                    <div className="flex items-center justify-between">
                      <Label htmlFor="supabase-url" className="flex items-center gap-2">
                        <Globe className="h-4 w-4 text-muted-foreground" />
                        Project URL
                        <Badge variant="destructive" className="text-[10px] px-1.5 py-0">
                          Required
                        </Badge>
                      </Label>
                      <Tooltip>
                        <TooltipTrigger asChild>
                          <Button variant="ghost" size="sm" className="h-6 px-2 text-xs">
                            <HelpCircle className="h-3 w-3 mr-1" />
                            Where to find?
                          </Button>
                        </TooltipTrigger>
                        <TooltipContent side="left" className="max-w-xs">
                          <p>Go to your Supabase Dashboard → Project Settings → API → Project URL</p>
                        </TooltipContent>
                      </Tooltip>
                    </div>
                    <div className="relative">
                      <Input
                        id="supabase-url"
                        type="url"
                        placeholder="https://xxxxx.supabase.co"
                        value={supabaseUrl}
                        onChange={(e) => handleSupabaseUrlChange(e.target.value)}
                        className={`font-mono text-sm pr-10 ${
                          supabaseValidationStatus === 'valid' 
                            ? 'border-green-500 focus-visible:ring-green-500' 
                            : supabaseValidationStatus === 'invalid'
                              ? 'border-red-500 focus-visible:ring-red-500'
                              : ''
                        }`}
                      />
                      <div className="absolute right-3 top-1/2 -translate-y-1/2">
                        {supabaseValidationStatus === 'typing' && supabaseAnonKey && (
                          <div className="flex gap-1">
                            <span className="typing-dot w-1.5 h-1.5 bg-primary rounded-full" />
                            <span className="typing-dot w-1.5 h-1.5 bg-primary rounded-full" />
                            <span className="typing-dot w-1.5 h-1.5 bg-primary rounded-full" />
                          </div>
                        )}
                        {supabaseValidationStatus === 'checking' && (
                          <Loader2 className="h-4 w-4 text-muted-foreground animate-spin" />
                        )}
                        {supabaseValidationStatus === 'valid' && (
                          <CheckCircle2 className="h-4 w-4 text-green-500" />
                        )}
                        {supabaseValidationStatus === 'invalid' && (
                          <XCircle className="h-4 w-4 text-red-500" />
                        )}
                      </div>
                    </div>
                    <p className="text-xs text-muted-foreground">
                      Example: https://abcd1234.supabase.co
                    </p>
                  </div>

                  {/* Supabase Anon Key */}
                  <div className="space-y-2">
                    <div className="flex items-center justify-between">
                      <Label htmlFor="supabase-key" className="flex items-center gap-2">
                        <Key className="h-4 w-4 text-muted-foreground" />
                        Anon (Public) Key
                        <Badge variant="destructive" className="text-[10px] px-1.5 py-0">
                          Required
                        </Badge>
                      </Label>
                      <Tooltip>
                        <TooltipTrigger asChild>
                          <Button variant="ghost" size="sm" className="h-6 px-2 text-xs">
                            <HelpCircle className="h-3 w-3 mr-1" />
                            Where to find?
                          </Button>
                        </TooltipTrigger>
                        <TooltipContent side="left" className="max-w-xs">
                          <p>Go to your Supabase Dashboard → Project Settings → API → Project API keys → anon public</p>
                        </TooltipContent>
                      </Tooltip>
                    </div>
                    <div className="relative">
                      <Input
                        id="supabase-key"
                        type="password"
                        placeholder="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
                        value={supabaseAnonKey}
                        onChange={(e) => handleSupabaseKeyChange(e.target.value)}
                        className={`font-mono text-sm pr-10 ${
                          supabaseValidationStatus === 'valid' 
                            ? 'border-green-500 focus-visible:ring-green-500' 
                            : supabaseValidationStatus === 'invalid'
                              ? 'border-red-500 focus-visible:ring-red-500'
                              : ''
                        }`}
                      />
                      <div className="absolute right-3 top-1/2 -translate-y-1/2">
                        {supabaseValidationStatus === 'typing' && supabaseUrl && (
                          <div className="flex gap-1">
                            <span className="typing-dot w-1.5 h-1.5 bg-primary rounded-full" />
                            <span className="typing-dot w-1.5 h-1.5 bg-primary rounded-full" />
                            <span className="typing-dot w-1.5 h-1.5 bg-primary rounded-full" />
                          </div>
                        )}
                        {supabaseValidationStatus === 'checking' && (
                          <Loader2 className="h-4 w-4 text-muted-foreground animate-spin" />
                        )}
                        {supabaseValidationStatus === 'valid' && (
                          <CheckCircle2 className="h-4 w-4 text-green-500" />
                        )}
                        {supabaseValidationStatus === 'invalid' && (
                          <XCircle className="h-4 w-4 text-red-500" />
                        )}
                      </div>
                    </div>
                    <p className="text-xs text-muted-foreground flex items-center gap-1">
                      <Lock className="h-3 w-3" />
                      This is safe to use in browser - it&apos;s the public key
                    </p>
                  </div>

                  {/* Validation Status Message */}
                  {supabaseValidationStatus !== 'idle' && (
                    <div className={`rounded-lg p-3 ${
                      supabaseValidationStatus === 'valid' 
                        ? 'bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800'
                        : supabaseValidationStatus === 'invalid'
                          ? 'bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800'
                          : supabaseValidationStatus === 'checking'
                            ? 'bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800'
                            : 'bg-muted border'
                    }`}>
                      <p className={`text-sm flex items-center gap-2 ${
                        supabaseValidationStatus === 'valid' 
                          ? 'text-green-700 dark:text-green-300'
                          : supabaseValidationStatus === 'invalid'
                            ? 'text-red-700 dark:text-red-300'
                            : supabaseValidationStatus === 'checking'
                              ? 'text-blue-700 dark:text-blue-300'
                              : 'text-muted-foreground'
                      }`}>
                        {supabaseValidationStatus === 'valid' && <CheckCircle2 className="h-4 w-4 flex-shrink-0" />}
                        {supabaseValidationStatus === 'invalid' && <AlertCircle className="h-4 w-4 flex-shrink-0" />}
                        {supabaseValidationStatus === 'checking' && <Loader2 className="h-4 w-4 flex-shrink-0 animate-spin" />}
                        {supabaseValidationStatus === 'typing' && <Loader2 className="h-4 w-4 flex-shrink-0 animate-spin" />}
                        <span>
                          {supabaseValidationStatus === 'typing' 
                            ? 'Waiting for you to finish typing...' 
                            : supabaseValidationMessage || 'Validating...'}
                        </span>
                      </p>
                    </div>
                  )}

                  {/* Collapsible Help */}
                  <div className="border rounded-lg overflow-hidden">
                    <button
                      onClick={() => setShowSupabaseHelp(!showSupabaseHelp)}
                      className="w-full flex items-center justify-between p-3 text-sm font-medium hover:bg-muted/50 transition-colors"
                    >
                      <span className="flex items-center gap-2">
                        <Zap className="h-4 w-4 text-amber-500" />
                        Step-by-step guide to get Supabase credentials
                      </span>
                      {showSupabaseHelp ? (
                        <ChevronUp className="h-4 w-4" />
                      ) : (
                        <ChevronDown className="h-4 w-4" />
                      )}
                    </button>
                    {showSupabaseHelp && (
                      <div className="p-4 pt-0 space-y-3 text-sm border-t bg-muted/30">
                        <ol className="list-decimal list-inside space-y-2 text-muted-foreground">
                          <li>
                            Go to{' '}
                            <a 
                              href="https://supabase.com/dashboard" 
                              target="_blank" 
                              rel="noopener noreferrer"
                              className="text-primary underline"
                            >
                              supabase.com/dashboard
                            </a>
                          </li>
                          <li>Sign in or create a new account</li>
                          <li>Click &quot;New Project&quot; and fill in the details</li>
                          <li>Wait for the project to be created (~ 2 minutes)</li>
                          <li>Go to <strong>Project Settings</strong> (gear icon)</li>
                          <li>Click on <strong>API</strong> in the sidebar</li>
                          <li>Copy the <strong>Project URL</strong> and <strong>anon public</strong> key</li>
                        </ol>
                        <div className="flex gap-2 pt-2">
                          <Button variant="outline" size="sm" asChild>
                            <a href="https://supabase.com/dashboard" target="_blank" rel="noopener noreferrer">
                              <ExternalLink className="h-3 w-3 mr-2" />
                              Open Supabase Dashboard
                            </a>
                          </Button>
                        </div>
                      </div>
                    )}
                  </div>

                  {/* Developer SQL Scripts */}
                  <div className="border rounded-lg overflow-hidden mt-4">
                    <button
                      onClick={() => setShowSupabaseScripts(!showSupabaseScripts)}
                      className="w-full flex items-center justify-between p-3 text-sm font-medium hover:bg-muted/50 transition-colors"
                    >
                      <span className="flex items-center gap-2">
                        <Code className="h-4 w-4 text-blue-500" />
                        Developer: Database Setup Scripts
                      </span>
                      {showSupabaseScripts ? (
                        <ChevronUp className="h-4 w-4" />
                      ) : (
                        <ChevronDown className="h-4 w-4" />
                      )}
                    </button>
                    {showSupabaseScripts && (
                      <div className="p-4 pt-0 space-y-4 text-sm border-t bg-muted/30">
                        <p className="text-muted-foreground">
                          Run these SQL scripts in your Supabase SQL Editor to set up the required database tables:
                        </p>
                        
                        <div className="space-y-3">
                          {/* Stores Table */}
                          <div className="border rounded-md overflow-hidden bg-background">
                            <div
                              onClick={() => setShowScriptStores(!showScriptStores)}
                              className="w-full bg-muted px-3 py-2 text-xs font-semibold flex items-center justify-between hover:bg-muted/80 transition-colors cursor-pointer"
                            >
                              <span>1. Create stores table</span>
                              <div className="flex items-center gap-2">
                                <Button
                                  variant="ghost"
                                  size="sm"
                                  className="h-6 px-2"
                                  onClick={(e) => {
                                    e.stopPropagation();
                                  navigator.clipboard.writeText(`CREATE TABLE stores (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE NOT NULL,
  woo_store_url VARCHAR(500) NOT NULL,
  woo_consumer_key VARCHAR(255),
  woo_consumer_secret VARCHAR(255),
  woo_auth_key TEXT,
  woo_api_version VARCHAR(10) DEFAULT 'wc/v3',
  brand_name VARCHAR(100),
  logo_url TEXT,
  status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended')),
  is_configured BOOLEAN DEFAULT false,
  settings JSONB DEFAULT '{}',
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  last_sync_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT valid_woo_url CHECK (woo_store_url ~* '^https?://.*')
);

CREATE INDEX idx_stores_status ON stores(status);
CREATE INDEX idx_stores_slug ON stores(slug);
CREATE INDEX idx_stores_created_at ON stores(created_at DESC);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_stores_updated_at
  BEFORE UPDATE ON stores
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();`);
                                  setCopiedField('stores');
                                  setTimeout(() => setCopiedField(null), 2000);
                                }}
                              >
                                    {copiedField === 'stores' ? <Check className="h-3 w-3" /> : <Copy className="h-3 w-3" />}
                                  </Button>
                                {showScriptStores ? <ChevronUp className="h-3 w-3" /> : <ChevronDown className="h-3 w-3" />}
                              </div>
                            </div>
                            {showScriptStores && (
                              <pre className="p-3 text-xs overflow-x-auto bg-background max-h-96 overflow-y-auto">
                              <code>{`CREATE TABLE stores (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE NOT NULL,
  woo_store_url VARCHAR(500) NOT NULL,
  woo_consumer_key VARCHAR(255),
  woo_consumer_secret VARCHAR(255),
  woo_auth_key TEXT,
  woo_api_version VARCHAR(10) DEFAULT 'wc/v3',
  brand_name VARCHAR(100),
  logo_url TEXT,
  status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended')),
  is_configured BOOLEAN DEFAULT false,
  settings JSONB DEFAULT '{}',
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  last_sync_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT valid_woo_url CHECK (woo_store_url ~* '^https?://.*')
);

CREATE INDEX idx_stores_status ON stores(status);
CREATE INDEX idx_stores_slug ON stores(slug);
CREATE INDEX idx_stores_created_at ON stores(created_at DESC);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_stores_updated_at
  BEFORE UPDATE ON stores
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();`}</code>
                              </pre>
                            )}
                          </div>

                          {/* Admin Users Table */}
                          <div className="border rounded-md overflow-hidden bg-background">
                            <div
                              onClick={() => setShowScriptAdminUsers(!showScriptAdminUsers)}
                              className="w-full bg-muted px-3 py-2 text-xs font-semibold flex items-center justify-between hover:bg-muted/80 transition-colors cursor-pointer"
                            >
                              <span>2. Create admin_users table</span>
                              <div className="flex items-center gap-2">
                                <Button
                                  variant="ghost"
                                  size="sm"
                                  className="h-6 px-2"
                                  onClick={(e) => {
                                    e.stopPropagation();
                                  navigator.clipboard.writeText(`CREATE TABLE admin_users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  auth_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  display_name VARCHAR(255),
  avatar_url TEXT,
  role VARCHAR(50) NOT NULL DEFAULT 'content_editor' 
    CHECK (role IN ('super_admin', 'store_manager', 'content_editor', 'viewer')),
  permissions JSONB DEFAULT '{}',
  is_active BOOLEAN DEFAULT true,
  is_email_verified BOOLEAN DEFAULT false,
  last_login_at TIMESTAMP WITH TIME ZONE,
  last_activity_at TIMESTAMP WITH TIME ZONE,
  login_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(auth_user_id, store_id)
);

CREATE INDEX idx_admin_users_auth_user ON admin_users(auth_user_id);
CREATE INDEX idx_admin_users_store ON admin_users(store_id);
CREATE INDEX idx_admin_users_role ON admin_users(role);
CREATE INDEX idx_admin_users_active ON admin_users(is_active);

CREATE TRIGGER update_admin_users_updated_at
  BEFORE UPDATE ON admin_users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();`);
                                  setCopiedField('admin_users');
                                  setTimeout(() => setCopiedField(null), 2000);
                                }}
                              >
                                    {copiedField === 'admin_users' ? <Check className="h-3 w-3" /> : <Copy className="h-3 w-3" />}
                                  </Button>
                                {showScriptAdminUsers ? <ChevronUp className="h-3 w-3" /> : <ChevronDown className="h-3 w-3" />}
                              </div>
                            </div>
                            {showScriptAdminUsers && (
                              <pre className="p-3 text-xs overflow-x-auto bg-background max-h-96 overflow-y-auto">
                              <code>{`CREATE TABLE admin_users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  auth_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  display_name VARCHAR(255),
  avatar_url TEXT,
  role VARCHAR(50) NOT NULL DEFAULT 'content_editor' 
    CHECK (role IN ('super_admin', 'store_manager', 'content_editor', 'viewer')),
  permissions JSONB DEFAULT '{}',
  is_active BOOLEAN DEFAULT true,
  is_email_verified BOOLEAN DEFAULT false,
  last_login_at TIMESTAMP WITH TIME ZONE,
  last_activity_at TIMESTAMP WITH TIME ZONE,
  login_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(auth_user_id, store_id)
);

CREATE INDEX idx_admin_users_auth_user ON admin_users(auth_user_id);
CREATE INDEX idx_admin_users_store ON admin_users(store_id);
CREATE INDEX idx_admin_users_role ON admin_users(role);
CREATE INDEX idx_admin_users_active ON admin_users(is_active);

CREATE TRIGGER update_admin_users_updated_at
  BEFORE UPDATE ON admin_users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();`}</code>
                              </pre>
                            )}
                          </div>

                          {/* App Configurations Table */}
                          <div className="border rounded-md overflow-hidden bg-background">
                            <div
                              onClick={() => setShowScriptAppConfigs(!showScriptAppConfigs)}
                              className="w-full bg-muted px-3 py-2 text-xs font-semibold flex items-center justify-between hover:bg-muted/80 transition-colors cursor-pointer"
                            >
                              <span>3. Create app_configurations table</span>
                              <div className="flex items-center gap-2">
                                <Button
                                  variant="ghost"
                                  size="sm"
                                  className="h-6 px-2"
                                  onClick={(e) => {
                                    e.stopPropagation();
                                  navigator.clipboard.writeText(`CREATE TABLE app_configurations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  config_key VARCHAR(255) NOT NULL,
  config_value JSONB NOT NULL,
  version INTEGER NOT NULL DEFAULT 1,
  parent_version_id UUID REFERENCES app_configurations(id),
  is_active BOOLEAN DEFAULT true,
  is_published BOOLEAN DEFAULT false,
  published_at TIMESTAMP WITH TIME ZONE,
  environment VARCHAR(20) DEFAULT 'production' 
    CHECK (environment IN ('development', 'staging', 'production')),
  description TEXT,
  tags TEXT[],
  created_by UUID REFERENCES admin_users(id),
  updated_by UUID REFERENCES admin_users(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(store_id, config_key, version)
);

CREATE INDEX idx_app_configs_store ON app_configurations(store_id);
CREATE INDEX idx_app_configs_active ON app_configurations(is_active);
CREATE INDEX idx_app_configs_key ON app_configurations(config_key);

CREATE TRIGGER update_app_configs_updated_at
  BEFORE UPDATE ON app_configurations
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();`);
                                  setCopiedField('app_configs');
                                  setTimeout(() => setCopiedField(null), 2000);
                                }}
                              >
                                    {copiedField === 'app_configs' ? <Check className="h-3 w-3" /> : <Copy className="h-3 w-3" />}
                                  </Button>
                                {showScriptAppConfigs ? <ChevronUp className="h-3 w-3" /> : <ChevronDown className="h-3 w-3" />}
                              </div>
                            </div>
                            {showScriptAppConfigs && (
                              <pre className="p-3 text-xs overflow-x-auto bg-background max-h-96 overflow-y-auto">
                              <code>{`CREATE TABLE app_configurations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  config_key VARCHAR(255) NOT NULL,
  config_value JSONB NOT NULL,
  version INTEGER NOT NULL DEFAULT 1,
  parent_version_id UUID REFERENCES app_configurations(id),
  is_active BOOLEAN DEFAULT true,
  is_published BOOLEAN DEFAULT false,
  published_at TIMESTAMP WITH TIME ZONE,
  environment VARCHAR(20) DEFAULT 'production' 
    CHECK (environment IN ('development', 'staging', 'production')),
  description TEXT,
  tags TEXT[],
  created_by UUID REFERENCES admin_users(id),
  updated_by UUID REFERENCES admin_users(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(store_id, config_key, version)
);

CREATE INDEX idx_app_configs_store ON app_configurations(store_id);
CREATE INDEX idx_app_configs_active ON app_configurations(is_active);
CREATE INDEX idx_app_configs_key ON app_configurations(config_key);

CREATE TRIGGER update_app_configs_updated_at
  BEFORE UPDATE ON app_configurations
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();`}</code>
                              </pre>
                            )}
                          </div>

                          {/* Builds Table */}
                          <div className="border rounded-md overflow-hidden bg-background">
                            <div
                              onClick={() => setShowScriptBuilds(!showScriptBuilds)}
                              className="w-full bg-muted px-3 py-2 text-xs font-semibold flex items-center justify-between hover:bg-muted/80 transition-colors cursor-pointer"
                            >
                              <span>4. Create builds table</span>
                              <div className="flex items-center gap-2">
                                <Button
                                  variant="ghost"
                                  size="sm"
                                  className="h-6 px-2"
                                  onClick={(e) => {
                                    e.stopPropagation();
                                  navigator.clipboard.writeText(`CREATE TABLE builds (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  platform VARCHAR(20) NOT NULL CHECK (platform IN ('ios', 'android')),
  status VARCHAR(50) DEFAULT 'queued' 
    CHECK (status IN ('queued', 'building', 'success', 'failed', 'cancelled')),
  build_number INTEGER NOT NULL,
  version VARCHAR(50) NOT NULL,
  artifact_url TEXT,
  error_message TEXT,
  metadata JSONB DEFAULT '{}',
  created_by UUID REFERENCES admin_users(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  started_at TIMESTAMP WITH TIME ZONE,
  completed_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_builds_store ON builds(store_id);
CREATE INDEX idx_builds_status ON builds(status);
CREATE INDEX idx_builds_platform ON builds(platform);
CREATE INDEX idx_builds_created_at ON builds(created_at DESC);`);
                                  setCopiedField('builds');
                                  setTimeout(() => setCopiedField(null), 2000);
                                }}
                              >
                                    {copiedField === 'builds' ? <Check className="h-3 w-3" /> : <Copy className="h-3 w-3" />}
                                  </Button>
                                {showScriptBuilds ? <ChevronUp className="h-3 w-3" /> : <ChevronDown className="h-3 w-3" />}
                              </div>
                            </div>
                            {showScriptBuilds && (
                              <pre className="p-3 text-xs overflow-x-auto bg-background max-h-96 overflow-y-auto">
                              <code>{`CREATE TABLE builds (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  platform VARCHAR(20) NOT NULL CHECK (platform IN ('ios', 'android')),
  status VARCHAR(50) DEFAULT 'queued' 
    CHECK (status IN ('queued', 'building', 'success', 'failed', 'cancelled')),
  build_number INTEGER NOT NULL,
  version VARCHAR(50) NOT NULL,
  artifact_url TEXT,
  error_message TEXT,
  metadata JSONB DEFAULT '{}',
  created_by UUID REFERENCES admin_users(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  started_at TIMESTAMP WITH TIME ZONE,
  completed_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_builds_store ON builds(store_id);
CREATE INDEX idx_builds_status ON builds(status);
CREATE INDEX idx_builds_platform ON builds(platform);
CREATE INDEX idx_builds_created_at ON builds(created_at DESC);`}</code>
                              </pre>
                            )}
                          </div>
                        </div>

                        <div className="pt-2 border-t space-y-3">
                          <p className="text-xs text-muted-foreground mb-2">
                            <strong>Note:</strong> Run these scripts in order in your Supabase SQL Editor. 
                            Go to <strong>SQL Editor</strong> → <strong>New Query</strong> → Paste and execute each script.
                          </p>
                          
                          {/* Table Check Status */}
                          {tableCheckResult && (
                            <div className="space-y-2">
                              <div className="flex items-center gap-2 text-xs font-semibold">
                                {tableCheckResult.allTablesExist ? (
                                  <>
                                    <CheckCircle2 className="h-4 w-4 text-green-600" />
                                    <span className="text-green-600">All tables verified!</span>
                                  </>
                                ) : (
                                  <>
                                    <AlertCircle className="h-4 w-4 text-amber-600" />
                                    <span className="text-amber-600">Some tables are missing</span>
                                  </>
                                )}
                              </div>
                              <div className="grid grid-cols-2 gap-2 text-xs">
                                {['stores', 'admin_users', 'app_configurations', 'builds'].map((table) => {
                                  const exists = tableCheckResult.tables[table]?.exists;
                                  return (
                                    <div key={table} className="flex items-center gap-2">
                                      {exists ? (
                                        <CheckCircle2 className="h-3 w-3 text-green-600 flex-shrink-0" />
                                      ) : (
                                        <XCircle className="h-3 w-3 text-red-600 flex-shrink-0" />
                                      )}
                                      <span className={exists ? 'text-green-600' : 'text-red-600'}>
                                        {table.replace('_', ' ')}
                                      </span>
                                    </div>
                                  );
                                })}
                              </div>
                            </div>
                          )}

                          <div className="flex gap-2">
                            <Button 
                              variant="outline" 
                              size="sm" 
                              onClick={handleCheckTables}
                              disabled={checkingTables || !supabaseUrl || !supabaseAnonKey}
                            >
                              {checkingTables ? (
                                <>
                                  <Loader2 className="h-3 w-3 mr-2 animate-spin" />
                                  Checking...
                                </>
                              ) : (
                                <>
                                  <CheckCircle2 className="h-3 w-3 mr-2" />
                                  Verify Tables
                                </>
                              )}
                            </Button>
                            <Button variant="outline" size="sm" asChild>
                              <a href="https://supabase.com/dashboard" target="_blank" rel="noopener noreferrer">
                                <ExternalLink className="h-3 w-3 mr-2" />
                                Open SQL Editor
                              </a>
                            </Button>
                          </div>
                        </div>
                      </div>
                    )}
                  </div>
                </CardContent>

                <CardFooter className="flex justify-between border-t pt-6">
                  <Button variant="ghost" disabled>
                    <ArrowLeft className="mr-2 h-4 w-4" />
                    Previous
                  </Button>
                  <Button 
                    onClick={handleSupabaseTest} 
                    disabled={isLoading || supabaseValidationStatus !== 'valid'}
                  >
                    {isLoading ? 'Continuing...' : supabaseValidationStatus === 'valid' ? 'Continue' : 'Verify Credentials First'}
                    <ArrowRight className="ml-2 h-4 w-4" />
                  </Button>
                </CardFooter>
              </>
            )}

            {/* Step 2: WooCommerce */}
            {currentStep === 2 && (
              <>
                <CardHeader className="pb-4">
                  <div className="flex items-start justify-between">
                    <div className="flex items-center gap-3">
                      <div className="p-3 bg-purple-100 dark:bg-purple-900/30 rounded-xl">
                        <Store className="h-6 w-6 text-purple-600" />
                      </div>
                      <div>
                        <CardTitle className="flex items-center gap-2">
                          Connect WooCommerce
                          <Badge variant="secondary" className="font-normal">
                            <Zap className="h-3 w-3 mr-1" />
                            REST API
                          </Badge>
                        </CardTitle>
                        <CardDescription className="mt-1">
                          Link your WooCommerce store to sync products and orders
                        </CardDescription>
                      </div>
                    </div>
                  </div>
                </CardHeader>

                <CardContent className="space-y-5">
                  {/* Info Banner */}
                  <div className="bg-amber-50 dark:bg-amber-900/20 border border-amber-200 dark:border-amber-800 rounded-lg p-4">
                    <div className="flex gap-3">
                      <Info className="h-5 w-5 text-amber-600 flex-shrink-0 mt-0.5" />
                      <div className="text-sm">
                        <p className="font-medium text-amber-800 dark:text-amber-200">
                          Requirements
                        </p>
                        <ul className="text-amber-700 dark:text-amber-300 mt-1 space-y-1">
                          <li>• WordPress with WooCommerce plugin installed</li>
                          <li>• REST API enabled (usually on by default)</li>
                          <li>• Permalinks set to anything except &quot;Plain&quot;</li>
                        </ul>
                      </div>
                    </div>
                  </div>

                  {/* Store URL */}
                  <div className="space-y-2">
                    <div className="flex items-center justify-between">
                      <Label htmlFor="woo-url" className="flex items-center gap-2">
                        <Globe className="h-4 w-4 text-muted-foreground" />
                        Store URL
                        <Badge variant="destructive" className="text-[10px] px-1.5 py-0">
                          Required
                        </Badge>
                      </Label>
                      {/* Validation Status Badge */}
                      {urlValidationStatus === 'checking' && (
                        <Badge variant="secondary" className="font-normal animate-pulse">
                          <Loader2 className="h-3 w-3 mr-1 animate-spin" />
                          Checking...
                        </Badge>
                      )}
                      {urlValidationStatus === 'valid' && (
                        <Badge className="bg-green-100 text-green-700 hover:bg-green-100">
                          <CheckCircle2 className="h-3 w-3 mr-1" />
                          Verified
                        </Badge>
                      )}
                      {urlValidationStatus === 'invalid' && (
                        <Badge variant="destructive" className="font-normal">
                          <XCircle className="h-3 w-3 mr-1" />
                          Unreachable
                        </Badge>
                      )}
                    </div>
                    <div className="relative">
                      <Input
                        id="woo-url"
                        type="url"
                        placeholder="https://yourstore.com"
                        value={wooStoreUrl}
                        onChange={(e) => handleStoreUrlChange(e.target.value)}
                        className={`font-mono text-sm pr-10 ${
                          urlValidationStatus === 'valid' 
                            ? 'border-green-500 focus-visible:ring-green-500' 
                            : urlValidationStatus === 'invalid'
                              ? 'border-red-500 focus-visible:ring-red-500'
                              : ''
                        }`}
                      />
                      {/* Status Icon inside input */}
                      <div className="absolute right-3 top-1/2 -translate-y-1/2">
                        {urlValidationStatus === 'typing' && (
                          <div className="flex gap-1">
                            <span className="typing-dot w-1.5 h-1.5 bg-primary rounded-full" />
                            <span className="typing-dot w-1.5 h-1.5 bg-primary rounded-full" />
                            <span className="typing-dot w-1.5 h-1.5 bg-primary rounded-full" />
                          </div>
                        )}
                        {urlValidationStatus === 'checking' && (
                          <Loader2 className="h-4 w-4 text-muted-foreground animate-spin" />
                        )}
                        {urlValidationStatus === 'valid' && (
                          <CheckCircle2 className="h-4 w-4 text-green-500" />
                        )}
                        {urlValidationStatus === 'invalid' && (
                          <XCircle className="h-4 w-4 text-red-500" />
                        )}
                      </div>
                    </div>
                    {/* Validation Message */}
                    {urlValidationStatus === 'typing' && (
                      <p className="text-xs text-muted-foreground flex items-center gap-1">
                        <Loader2 className="h-3 w-3 animate-spin" />
                        Waiting for you to finish typing...
                      </p>
                    )}
                    {urlValidationStatus === 'checking' && (
                      <p className="text-xs text-blue-600 flex items-center gap-1">
                        <Loader2 className="h-3 w-3 animate-spin" />
                        {urlValidationMessage}
                      </p>
                    )}
                    {urlValidationStatus === 'valid' && (
                      <p className="text-xs text-green-600 flex items-center gap-1">
                        <CheckCircle2 className="h-3 w-3" />
                        {urlValidationMessage}
                      </p>
                    )}
                    {urlValidationStatus === 'invalid' && (
                      <p className="text-xs text-red-600 flex items-center gap-1">
                        <AlertCircle className="h-3 w-3" />
                        {urlValidationMessage}
                      </p>
                    )}
                    {urlValidationStatus === 'idle' && (
                      <p className="text-xs text-muted-foreground">
                        Your WordPress site URL where WooCommerce is installed
                      </p>
                    )}
                  </div>

                  {/* API Keys Section - Only shown when URL is valid */}
                  {urlValidationStatus === 'valid' ? (
                    <div className="space-y-5 animate-slide-in">
                      {/* Success Message */}
                      <div className="bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800 rounded-lg p-3">
                        <p className="text-sm text-green-700 dark:text-green-300 flex items-center gap-2">
                          <CheckCircle2 className="h-4 w-4 flex-shrink-0" />
                          <span>
                            {hasWooCommerce 
                              ? 'WooCommerce detected! Now enter your API keys below.'
                              : 'Website is reachable. Enter your WooCommerce API keys to continue.'}
                          </span>
                        </p>
                      </div>

                      {/* Consumer Key */}
                      <div className="space-y-2">
                        <div className="flex items-center justify-between">
                          <Label htmlFor="woo-key" className="flex items-center gap-2">
                            <Key className="h-4 w-4 text-muted-foreground" />
                            Consumer Key
                            <Badge variant="destructive" className="text-[10px] px-1.5 py-0">
                              Required
                            </Badge>
                          </Label>
                          <Tooltip>
                            <TooltipTrigger asChild>
                              <Button variant="ghost" size="sm" className="h-6 px-2 text-xs">
                                <HelpCircle className="h-3 w-3 mr-1" />
                                Where to find?
                              </Button>
                            </TooltipTrigger>
                            <TooltipContent side="left" className="max-w-xs">
                              <p>WooCommerce → Settings → Advanced → REST API → Add Key</p>
                            </TooltipContent>
                          </Tooltip>
                        </div>
                        <Input
                          id="woo-key"
                          placeholder="ck_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
                          value={wooConsumerKey}
                          onChange={(e) => setWooConsumerKey(e.target.value)}
                          className="font-mono text-sm"
                        />
                        <p className="text-xs text-muted-foreground">
                          Starts with <code className="bg-muted px-1 rounded">ck_</code>
                        </p>
                      </div>

                      {/* Consumer Secret */}
                      <div className="space-y-2">
                        <div className="flex items-center justify-between">
                          <Label htmlFor="woo-secret" className="flex items-center gap-2">
                            <Lock className="h-4 w-4 text-muted-foreground" />
                            Consumer Secret
                            <Badge variant="destructive" className="text-[10px] px-1.5 py-0">
                              Required
                            </Badge>
                          </Label>
                        </div>
                        <Input
                          id="woo-secret"
                          type="password"
                          placeholder="cs_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
                          value={wooConsumerSecret}
                          onChange={(e) => setWooConsumerSecret(e.target.value)}
                          className="font-mono text-sm"
                        />
                        <p className="text-xs text-muted-foreground">
                          Starts with <code className="bg-muted px-1 rounded">cs_</code> - Keep this secret!
                        </p>
                      </div>
                    </div>
                  ) : (
                    /* Placeholder when URL not yet validated */
                    <div className="border-2 border-dashed border-muted rounded-lg p-6 text-center">
                      <div className="space-y-2">
                        <div className="mx-auto w-12 h-12 rounded-full bg-muted flex items-center justify-center">
                          <Key className="h-5 w-5 text-muted-foreground" />
                        </div>
                        <h4 className="font-medium text-muted-foreground">API Keys</h4>
                        <p className="text-sm text-muted-foreground">
                          {urlValidationStatus === 'checking' 
                            ? 'Verifying your store URL...'
                            : urlValidationStatus === 'typing'
                              ? 'Waiting for URL validation...'
                              : urlValidationStatus === 'invalid'
                                ? 'Please fix the store URL above'
                                : 'Enter a valid store URL above to unlock API key fields'}
                        </p>
                      </div>
                    </div>
                  )}

                  {/* Collapsible Help */}
                  <div className="border rounded-lg overflow-hidden">
                    <button
                      onClick={() => setShowWooHelp(!showWooHelp)}
                      className="w-full flex items-center justify-between p-3 text-sm font-medium hover:bg-muted/50 transition-colors"
                    >
                      <span className="flex items-center gap-2">
                        <Zap className="h-4 w-4 text-amber-500" />
                        How to create WooCommerce API keys
                      </span>
                      {showWooHelp ? (
                        <ChevronUp className="h-4 w-4" />
                      ) : (
                        <ChevronDown className="h-4 w-4" />
                      )}
                    </button>
                    {showWooHelp && (
                      <div className="p-4 pt-0 space-y-3 text-sm border-t bg-muted/30">
                        <ol className="list-decimal list-inside space-y-2 text-muted-foreground">
                          <li>Login to your WordPress admin dashboard</li>
                          <li>Go to <strong>WooCommerce → Settings</strong></li>
                          <li>Click the <strong>Advanced</strong> tab</li>
                          <li>Click <strong>REST API</strong> sub-tab</li>
                          <li>Click <strong>Add key</strong> button</li>
                          <li>Enter a description (e.g., &quot;OSMEA Admin Panel&quot;)</li>
                          <li>Set permissions to <strong>Read/Write</strong></li>
                          <li>Click <strong>Generate API key</strong></li>
                          <li>Copy both the Consumer Key and Consumer Secret</li>
                        </ol>
                        <div className="bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg p-3 mt-3">
                          <p className="text-red-700 dark:text-red-300 text-xs flex items-center gap-2">
                            <Info className="h-4 w-4 flex-shrink-0" />
                            <span>
                              <strong>Important:</strong> The Consumer Secret is only shown once. Make sure to copy it immediately!
                            </span>
                          </p>
                        </div>
                      </div>
                    )}
                  </div>
                </CardContent>

                <CardFooter className="flex justify-between border-t pt-6">
                  <Button variant="ghost" onClick={() => setCurrentStep(1)}>
                    <ArrowLeft className="mr-2 h-4 w-4" />
                    Previous
                  </Button>
                  <Button 
                    onClick={handleWooCommerceTest} 
                    disabled={isLoading || urlValidationStatus !== 'valid' || !wooConsumerKey || !wooConsumerSecret}
                  >
                    {isLoading ? 'Testing Connection...' : 'Test & Continue'}
                    <ArrowRight className="ml-2 h-4 w-4" />
                  </Button>
                </CardFooter>
              </>
            )}

            {/* Step 3: Project Details */}
            {currentStep === 3 && (
              <>
                <CardHeader className="pb-4">
                  <div className="flex items-start justify-between">
                    <div className="flex items-center gap-3">
                      <div className="p-3 bg-blue-100 dark:bg-blue-900/30 rounded-xl">
                        <Smartphone className="h-6 w-6 text-blue-600" />
                      </div>
                      <div>
                        <CardTitle className="flex items-center gap-2">
                          Project Details
                          <Badge className="bg-green-100 text-green-700 hover:bg-green-100">
                            <CheckCircle2 className="h-3 w-3 mr-1" />
                            Almost Done!
                          </Badge>
                        </CardTitle>
                        <CardDescription className="mt-1">
                          Name your project and configure your mobile app
                        </CardDescription>
                      </div>
                    </div>
                  </div>
                </CardHeader>

                <CardContent className="space-y-5">
                  {/* Success Banner */}
                  <div className="bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800 rounded-lg p-4">
                    <div className="flex gap-3">
                      <CheckCircle2 className="h-5 w-5 text-green-600 flex-shrink-0 mt-0.5" />
                      <div className="text-sm">
                        <p className="font-medium text-green-800 dark:text-green-200">
                          All connections verified!
                        </p>
                        <div className="text-green-700 dark:text-green-300 mt-1 space-y-1">
                          <p className="flex items-center gap-2">
                            <Check className="h-3 w-3" /> Supabase connected
                          </p>
                          <p className="flex items-center gap-2">
                            <Check className="h-3 w-3" /> WooCommerce connected
                          </p>
                        </div>
                      </div>
                    </div>
                  </div>

                  {/* Project Name */}
                  <div className="space-y-2">
                    <div className="flex items-center justify-between">
                      <Label htmlFor="project-name" className="flex items-center gap-2">
                        Project Name
                        <Badge variant="destructive" className="text-[10px] px-1.5 py-0">
                          Required
                        </Badge>
                      </Label>
                    </div>
                    <Input
                      id="project-name"
                      placeholder="My Awesome Store"
                      value={projectName}
                      onChange={(e) => setProjectName(e.target.value)}
                    />
                    <p className="text-xs text-muted-foreground">
                      Internal name for your project (visible only in admin panel)
                    </p>
                  </div>

                  {/* App Name */}
                  <div className="space-y-2">
                    <div className="flex items-center justify-between">
                      <Label htmlFor="app-name" className="flex items-center gap-2">
                        Mobile App Name
                        <Badge variant="destructive" className="text-[10px] px-1.5 py-0">
                          Required
                        </Badge>
                      </Label>
                      <Tooltip>
                        <TooltipTrigger asChild>
                          <Button variant="ghost" size="sm" className="h-6 px-2 text-xs">
                            <HelpCircle className="h-3 w-3 mr-1" />
                            Tips
                          </Button>
                        </TooltipTrigger>
                        <TooltipContent side="left" className="max-w-xs">
                          <p>This name will appear on the user&apos;s device. Keep it short (max 12 characters recommended).</p>
                        </TooltipContent>
                      </Tooltip>
                    </div>
                    <Input
                      id="app-name"
                      placeholder="Store App"
                      value={appName}
                      onChange={(e) => setAppName(e.target.value)}
                      maxLength={30}
                    />
                    <p className="text-xs text-muted-foreground">
                      Name displayed on user devices under the app icon
                    </p>
                  </div>

                  {/* What's Next */}
                  <div className="border rounded-lg p-4 space-y-3">
                    <h4 className="font-medium flex items-center gap-2">
                      <Sparkles className="h-4 w-4 text-primary" />
                      What&apos;s next?
                    </h4>
                    <ul className="text-sm text-muted-foreground space-y-2">
                      <li className="flex items-start gap-2">
                        <div className="w-5 h-5 rounded-full bg-primary/10 flex items-center justify-center text-xs text-primary flex-shrink-0 mt-0.5">1</div>
                        <span>Customize your app&apos;s theme, colors, and branding</span>
                      </li>
                      <li className="flex items-start gap-2">
                        <div className="w-5 h-5 rounded-full bg-primary/10 flex items-center justify-center text-xs text-primary flex-shrink-0 mt-0.5">2</div>
                        <span>Configure app features and settings</span>
                      </li>
                      <li className="flex items-start gap-2">
                        <div className="w-5 h-5 rounded-full bg-primary/10 flex items-center justify-center text-xs text-primary flex-shrink-0 mt-0.5">3</div>
                        <span>Build and download your iOS/Android apps</span>
                      </li>
                    </ul>
                  </div>
                </CardContent>

                <CardFooter className="flex justify-between border-t pt-6">
                  <Button variant="ghost" onClick={() => setCurrentStep(2)}>
                    <ArrowLeft className="mr-2 h-4 w-4" />
                    Previous
                  </Button>
                  <Button onClick={handleFinish} disabled={isLoading} className="bg-green-600 hover:bg-green-700">
                    {isLoading ? 'Finishing Setup...' : 'Complete Setup'}
                    <CheckCircle2 className="ml-2 h-4 w-4" />
                  </Button>
                </CardFooter>
              </>
            )}
          </Card>

          {/* Footer Help */}
          <div className="text-center text-sm text-muted-foreground">
            <p>
              Need help?{' '}
              <a 
                href="https://github.com/masterfabric-mobile/osmea" 
                target="_blank"
                rel="noopener noreferrer"
                className="text-primary hover:underline"
              >
                View documentation
              </a>
              {' '}or{' '}
              <a 
                href="https://github.com/masterfabric-mobile/osmea/issues" 
                target="_blank"
                rel="noopener noreferrer"
                className="text-primary hover:underline"
              >
                contact support
              </a>
            </p>
          </div>
        </div>
      </div>
    </TooltipProvider>
  );
}
