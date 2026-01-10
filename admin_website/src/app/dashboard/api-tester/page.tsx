'use client';

import { useState, useEffect } from 'react';
import { PageHeader, PageContainer } from '@/components/layout/page-header';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Badge } from '@/components/ui/badge';
import { toast } from 'sonner';
import { 
  Send,
  Copy,
  Check,
  Loader2,
  FileCode,
  Globe,
  Trash2,
  Plus,
  Database,
  Zap,
  TestTube,
  CheckCircle2,
  XCircle,
  AlertCircle,
} from 'lucide-react';
import { getConfigurations, getActiveConfiguration } from '@/actions/config.actions';

type HttpMethod = 'GET' | 'POST' | 'PUT' | 'DELETE' | 'PATCH';

interface Header {
  key: string;
  value: string;
}

interface ApiResponse {
  status: number;
  statusText: string;
  headers: Record<string, string>;
  data: unknown;
  time: number;
}

interface QuickEndpoint {
  name: string;
  url: string;
  method: HttpMethod;
  headers?: Header[];
  description: string;
}

interface TestResult {
  name: string;
  status: 'success' | 'error' | 'pending';
  message: string;
  time?: number;
}

export default function ApiTesterPage() {
  const [method, setMethod] = useState<HttpMethod>('GET');
  const [url, setUrl] = useState('');
  const [headers, setHeaders] = useState<Header[]>([{ key: '', value: '' }]);
  const [body, setBody] = useState('');
  const [response, setResponse] = useState<ApiResponse | null>(null);
  const [loading, setLoading] = useState(false);
  const [copied, setCopied] = useState<string | null>(null);
  const [selectedLanguage, setSelectedLanguage] = useState<'js' | 'ts' | 'dart' | 'kotlin'>('js');
  const [supabaseEndpoints, setSupabaseEndpoints] = useState<QuickEndpoint[]>([]);
  const [appConfigTests, setAppConfigTests] = useState<TestResult[]>([]);
  const [testingConfig, setTestingConfig] = useState(false);

  // Quick endpoints for Supabase
  const getSupabaseEndpoints = (): QuickEndpoint[] => {
    if (typeof window === 'undefined') return [];
    
    const supabaseUrl = localStorage.getItem('osmea-supabase-url');
    const supabaseKey = localStorage.getItem('osmea-supabase-key');
    
    if (!supabaseUrl || !supabaseKey) return [];
    
    const baseUrl = supabaseUrl.replace(/\/$/, '');
    const authHeader = { key: 'apikey', value: supabaseKey };
    const authHeaderBearer = { key: 'Authorization', value: `Bearer ${supabaseKey}` };
    
    return [
      {
        name: 'Health Check',
        url: `${baseUrl}/rest/v1/`,
        method: 'GET',
        headers: [authHeader],
        description: 'Check Supabase REST API'
      },
      {
        name: 'List Tables',
        url: `${baseUrl}/rest/v1/`,
        method: 'GET',
        headers: [authHeader, { key: 'Accept', value: 'application/vnd.pgjson.object+json' }],
        description: 'List all tables'
      },
    ];
  };

  // Load credentials and setup quick endpoints
  useEffect(() => {
    if (typeof window === 'undefined') return;
    
    const wooUrl = localStorage.getItem('osmea-woo-url');
    const wooKey = localStorage.getItem('osmea-woo-key');
    const wooSecret = localStorage.getItem('osmea-woo-secret');
    
    // Auto-load WooCommerce if available and URL is empty
    if (wooUrl && !url) {
      setUrl(`${wooUrl}/wp-json/wc/v3/products`);
    }
    
    // Auto-load WooCommerce auth if available
    if (wooKey && wooSecret && headers.length === 1 && !headers[0].key) {
      const auth = btoa(`${wooKey}:${wooSecret}`);
      setHeaders([{ key: 'Authorization', value: `Basic ${auth}` }]);
    }
    
    // Load Supabase endpoints
    setSupabaseEndpoints(getSupabaseEndpoints());
  }, []);

  // Test App Config Service
  const testAppConfigService = async () => {
    setTestingConfig(true);
    const tests: TestResult[] = [];
    const startTime = Date.now();

    try {
      // Test 1: Get Store ID from localStorage
      const storeId = localStorage.getItem('osmea-store-id');
      if (!storeId) {
        tests.push({
          name: 'Store ID Check',
          status: 'error',
          message: 'Store ID not found in localStorage',
        });
        setAppConfigTests(tests);
        setTestingConfig(false);
        return;
      }

      tests.push({
        name: 'Store ID Check',
        status: 'success',
        message: `Found store ID: ${storeId.substring(0, 8)}...`,
        time: Date.now() - startTime,
      });

      // Test 2: Get Configurations
      try {
        const result = await getConfigurations(storeId);
        if (result.success && result.data) {
          tests.push({
            name: 'Get Configurations',
            status: 'success',
            message: `Found ${result.data.length} configuration(s)`,
            time: Date.now() - startTime,
          });
        } else {
          tests.push({
            name: 'Get Configurations',
            status: 'error',
            message: result.error || 'Failed to fetch configurations',
            time: Date.now() - startTime,
          });
        }
      } catch (error) {
        tests.push({
          name: 'Get Configurations',
          status: 'error',
          message: error instanceof Error ? error.message : 'Unknown error',
          time: Date.now() - startTime,
        });
      }

      // Test 3: Get Active Configuration
      try {
        const result = await getActiveConfiguration(storeId, 'app_config', 'production');
        if (result.success && result.data) {
          tests.push({
            name: 'Get Active Config',
            status: 'success',
            message: `Active config found (v${result.data.version})`,
            time: Date.now() - startTime,
          });
        } else {
          tests.push({
            name: 'Get Active Config',
            status: 'error',
            message: result.error || 'No active configuration found',
            time: Date.now() - startTime,
          });
        }
      } catch (error) {
        tests.push({
          name: 'Get Active Config',
          status: 'error',
          message: error instanceof Error ? error.message : 'Unknown error',
          time: Date.now() - startTime,
        });
      }

      // Test 4: Supabase Connection Test
      const supabaseUrl = localStorage.getItem('osmea-supabase-url');
      if (supabaseUrl) {
        try {
          const testUrl = `${supabaseUrl.replace(/\/$/, '')}/rest/v1/`;
          const testKey = localStorage.getItem('osmea-supabase-key');
          const res = await fetch(testUrl, {
            headers: {
              apikey: testKey || '',
            },
          });
          
          if (res.ok) {
            tests.push({
              name: 'Supabase Connection',
              status: 'success',
              message: 'Successfully connected to Supabase',
              time: Date.now() - startTime,
            });
          } else {
            tests.push({
              name: 'Supabase Connection',
              status: 'error',
              message: `Connection failed: ${res.status} ${res.statusText}`,
              time: Date.now() - startTime,
            });
          }
        } catch (error) {
          tests.push({
            name: 'Supabase Connection',
            status: 'error',
            message: error instanceof Error ? error.message : 'Connection error',
            time: Date.now() - startTime,
          });
        }
      } else {
        tests.push({
          name: 'Supabase Connection',
          status: 'error',
          message: 'Supabase URL not configured',
          time: Date.now() - startTime,
        });
      }

    } catch (error) {
      tests.push({
        name: 'Test Suite',
        status: 'error',
        message: error instanceof Error ? error.message : 'Unknown error',
        time: Date.now() - startTime,
      });
    }

    setAppConfigTests(tests);
    setTestingConfig(false);
    toast.success(`Tests completed in ${Date.now() - startTime}ms`);
  };

  const loadQuickEndpoint = (endpoint: QuickEndpoint) => {
    setMethod(endpoint.method);
    setUrl(endpoint.url);
    if (endpoint.headers && endpoint.headers.length > 0) {
      setHeaders(endpoint.headers);
    }
    toast.success(`Loaded ${endpoint.name}`);
  };

  const addHeader = () => {
    setHeaders([...headers, { key: '', value: '' }]);
  };

  const removeHeader = (index: number) => {
    setHeaders(headers.filter((_, i) => i !== index));
  };

  const updateHeader = (index: number, field: 'key' | 'value', value: string) => {
    const newHeaders = [...headers];
    newHeaders[index][field] = value;
    setHeaders(newHeaders);
  };

  const handleSend = async () => {
    if (!url) {
      toast.error('Please enter a URL');
      return;
    }

    setLoading(true);
    const startTime = Date.now();

    try {
      const requestHeaders: Record<string, string> = {};
      headers.forEach((h) => {
        if (h.key && h.value) {
          requestHeaders[h.key] = h.value;
        }
      });

      const options: RequestInit = {
        method,
        headers: requestHeaders,
      };

      if (['POST', 'PUT', 'PATCH'].includes(method) && body) {
        try {
          const parsed = JSON.parse(body);
          options.body = JSON.stringify(parsed);
          requestHeaders['Content-Type'] = 'application/json';
        } catch {
          options.body = body;
        }
      }

      const res = await fetch(url, options);
      const time = Date.now() - startTime;

      let data: unknown;
      const contentType = res.headers.get('content-type');
      if (contentType?.includes('application/json')) {
        data = await res.json();
      } else {
        data = await res.text();
      }

      const responseHeaders: Record<string, string> = {};
      res.headers.forEach((value, key) => {
        responseHeaders[key] = value;
      });

      setResponse({
        status: res.status,
        statusText: res.statusText,
        headers: responseHeaders,
        data,
        time,
      });

      toast.success(`Request completed in ${time}ms`);
    } catch (error) {
      const time = Date.now() - startTime;
      setResponse({
        status: 0,
        statusText: 'Error',
        headers: {},
        data: error instanceof Error ? error.message : 'Network error',
        time,
      });
      toast.error('Request failed');
    } finally {
      setLoading(false);
    }
  };

  // Simplified code generation
  const generateCode = (lang: 'js' | 'ts' | 'dart' | 'kotlin') => {
    const validHeaders = headers.filter((h) => h.key && h.value);
    const hasBody = ['POST', 'PUT', 'PATCH'].includes(method) && body.trim();
    
    const escapeString = (str: string): string => {
      return str.replace(/\\/g, '\\\\').replace(/"/g, '\\"').replace(/\n/g, '\\n');
    };

    let bodyValue = '';
    if (hasBody) {
      try {
        const parsed = JSON.parse(body);
        bodyValue = JSON.stringify(parsed, null, 2);
      } catch {
        bodyValue = `"${escapeString(body)}"`;
      }
    }

    const headersObj = validHeaders.length > 0 
      ? Object.fromEntries(validHeaders.map(h => [h.key, h.value]))
      : null;

    switch (lang) {
      case 'js':
        return `const url = "${escapeString(url)}";
const method = "${method}";
${headersObj ? `const headers = ${JSON.stringify(headersObj, null, 2)};` : ''}
${hasBody ? `const body = ${bodyValue};` : ''}

fetch(url, {
  method,
  ${headersObj ? 'headers,' : ''}
  ${hasBody ? 'body: JSON.stringify(body),' : ''}
})
  .then(response => response.json())
  .then(data => console.log(data))
  .catch(error => console.error('Error:', error));`;

      case 'ts':
        return `const url: string = "${escapeString(url)}";
const method: string = "${method}";
${headersObj ? `const headers: Record<string, string> = ${JSON.stringify(headersObj, null, 2)};` : ''}
${hasBody ? `const body: unknown = ${bodyValue};` : ''}

fetch(url, {
  method,
  ${headersObj ? 'headers,' : ''}
  ${hasBody ? 'body: JSON.stringify(body),' : ''}
})
  .then((response: Response) => response.json())
  .then((data: unknown) => console.log(data))
  .catch((error: Error) => console.error('Error:', error));`;

      case 'dart':
        const dartHeaders = validHeaders.map(h => `    '${h.key}': '${h.value.replace(/'/g, "\\'")}'`).join(',\n');
        return `import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> makeRequest() async {
  final url = Uri.parse('${url.replace(/'/g, "\\'")}');
  ${headersObj ? `final headers = {\n${dartHeaders}\n  };` : ''}
  ${hasBody ? `final body = ${bodyValue};` : ''}

  try {
    final response = await http.${method.toLowerCase()}(
      url,
      ${headersObj ? 'headers: headers,' : ''}
      ${hasBody ? 'body: jsonEncode(body),' : ''}
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
    }
  } catch (e) {
    print('Error: \$e');
  }
}`;

      case 'kotlin':
        const kotlinHeaders = validHeaders.map(h => `      "${h.key}" to "${h.value.replace(/"/g, '\\"')}"`).join(',\n');
        return `import okhttp3.*

suspend fun makeRequest() {
    val url = "${url.replace(/"/g, '\\"')}"
    ${headersObj ? `val headers = mapOf(\n${kotlinHeaders}\n    )` : ''}
    ${hasBody ? `val body = ${bodyValue}` : ''}
    
    val client = OkHttpClient()
    val requestBuilder = Request.Builder().url(url)
    
    ${headersObj ? `headers.forEach { (key, value) ->\n        requestBuilder.addHeader(key, value)\n    }` : ''}
    
    ${hasBody ? `val mediaType = "application/json".toMediaType()\n    val requestBody = body.toRequestBody(mediaType)` : ''}
    ${method === 'GET' ? 'requestBuilder.get()' : method === 'POST' ? 'requestBuilder.post(requestBody)' : method === 'PUT' ? 'requestBuilder.put(requestBody)' : 'requestBuilder.delete()'}
    
    val response = client.newCall(requestBuilder.build()).execute()
    println(response.body?.string())
}`;

      default:
        return '';
    }
  };

  const copyToClipboard = async (text: string, id: string) => {
    await navigator.clipboard.writeText(text);
    setCopied(id);
    setTimeout(() => setCopied(null), 2000);
    toast.success('Copied to clipboard!');
  };

  return (
    <PageContainer>
      <PageHeader
        title="API Tester"
        description="Test API endpoints and verify service connections"
      />

      {/* Quick Tests Section */}
      <div className="grid gap-4 md:grid-cols-2 mt-6">
        {/* Supabase Quick Endpoints */}
        {supabaseEndpoints.length > 0 && (
          <Card>
            <CardHeader className="pb-3">
              <CardTitle className="text-base flex items-center gap-2">
                <Database className="h-4 w-4" />
                Supabase Endpoints
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="flex flex-wrap gap-2">
                {supabaseEndpoints.map((endpoint, idx) => (
                  <Button
                    key={idx}
                    variant="outline"
                    size="sm"
                    onClick={() => loadQuickEndpoint(endpoint)}
                    className="h-auto py-1.5 px-3"
                  >
                    <Zap className="h-3 w-3 mr-1.5" />
                    {endpoint.name}
                  </Button>
                ))}
              </div>
            </CardContent>
          </Card>
        )}

        {/* App Config Service Test */}
        <Card>
          <CardHeader className="pb-3">
            <CardTitle className="text-base flex items-center gap-2">
              <TestTube className="h-4 w-4" />
              App Config Service
            </CardTitle>
            <CardDescription className="text-xs">Test Supabase integration</CardDescription>
          </CardHeader>
          <CardContent>
            <Button
              variant="outline"
              size="sm"
              onClick={testAppConfigService}
              disabled={testingConfig}
              className="w-full"
            >
              {testingConfig ? (
                <>
                  <Loader2 className="h-3 w-3 mr-2 animate-spin" />
                  Testing...
                </>
              ) : (
                <>
                  <TestTube className="h-3 w-3 mr-2" />
                  Run Tests
                </>
              )}
            </Button>
            {appConfigTests.length > 0 && (
              <div className="mt-3 space-y-2">
                {appConfigTests.map((test, idx) => (
                  <div key={idx} className="flex items-start gap-2 text-xs">
                    {test.status === 'success' && <CheckCircle2 className="h-3.5 w-3.5 text-green-500 mt-0.5 flex-shrink-0" />}
                    {test.status === 'error' && <XCircle className="h-3.5 w-3.5 text-red-500 mt-0.5 flex-shrink-0" />}
                    {test.status === 'pending' && <AlertCircle className="h-3.5 w-3.5 text-yellow-500 mt-0.5 flex-shrink-0" />}
                    <div className="flex-1 min-w-0">
                      <div className="font-medium">{test.name}</div>
                      <div className="text-muted-foreground">{test.message}</div>
                      {test.time && <div className="text-muted-foreground text-[10px]">{test.time}ms</div>}
                    </div>
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>
      </div>

      {/* Request & Response */}
      <div className="grid gap-6 lg:grid-cols-2 mt-6">
        {/* Request Panel */}
        <Card>
          <CardHeader className="pb-3">
            <CardTitle className="text-base">Request</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            {/* Method & URL */}
            <div className="flex gap-2">
              <Select value={method} onValueChange={(v) => setMethod(v as HttpMethod)}>
                <SelectTrigger className="w-28">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="GET">GET</SelectItem>
                  <SelectItem value="POST">POST</SelectItem>
                  <SelectItem value="PUT">PUT</SelectItem>
                  <SelectItem value="PATCH">PATCH</SelectItem>
                  <SelectItem value="DELETE">DELETE</SelectItem>
                </SelectContent>
              </Select>
              <Input
                value={url}
                onChange={(e) => setUrl(e.target.value)}
                placeholder="https://api.example.com/endpoint"
                className="flex-1"
              />
              <Button onClick={handleSend} disabled={loading || !url} size="icon">
                {loading ? (
                  <Loader2 className="h-4 w-4 animate-spin" />
                ) : (
                  <Send className="h-4 w-4" />
                )}
              </Button>
            </div>

            {/* Headers */}
            <div className="space-y-2">
              <div className="flex items-center justify-between">
                <Label className="text-sm">Headers</Label>
                <Button variant="ghost" size="sm" onClick={addHeader} className="h-7">
                  <Plus className="h-3 w-3 mr-1" />
                  Add
                </Button>
              </div>
              <div className="space-y-2 max-h-40 overflow-y-auto">
                {headers.map((header, index) => (
                  <div key={index} className="flex gap-2">
                    <Input
                      value={header.key}
                      onChange={(e) => updateHeader(index, 'key', e.target.value)}
                      placeholder="Key"
                      className="flex-1 h-8 text-sm"
                    />
                    <Input
                      value={header.value}
                      onChange={(e) => updateHeader(index, 'value', e.target.value)}
                      placeholder="Value"
                      className="flex-1 h-8 text-sm"
                    />
                    {headers.length > 1 && (
                      <Button
                        variant="ghost"
                        size="icon"
                        onClick={() => removeHeader(index)}
                        className="h-8 w-8"
                      >
                        <Trash2 className="h-3 w-3" />
                      </Button>
                    )}
                  </div>
                ))}
              </div>
            </div>

            {/* Body */}
            {['POST', 'PUT', 'PATCH'].includes(method) && (
              <div className="space-y-2">
                <Label className="text-sm">Body (JSON)</Label>
                <textarea
                  value={body}
                  onChange={(e) => setBody(e.target.value)}
                  placeholder='{"key": "value"}'
                  className="w-full min-h-[120px] p-2 rounded-md border border-input bg-background font-mono text-xs resize-none"
                />
              </div>
            )}
          </CardContent>
        </Card>

        {/* Response Panel */}
        <Card>
          <CardHeader className="pb-3">
            <CardTitle className="text-base">Response</CardTitle>
            <CardDescription className="text-xs">
              {response ? `${response.status} ${response.statusText} • ${response.time}ms` : 'No response yet'}
            </CardDescription>
          </CardHeader>
          <CardContent>
            {response ? (
              <div className="space-y-3">
                <div>
                  <Label className="text-xs text-muted-foreground">Status</Label>
                  <div className={`text-sm font-mono p-2 rounded mt-1 ${
                    response.status >= 200 && response.status < 300
                      ? 'bg-green-50 dark:bg-green-950/30 text-green-700 dark:text-green-400'
                      : response.status >= 400
                      ? 'bg-red-50 dark:bg-red-950/30 text-red-700 dark:text-red-400'
                      : 'bg-muted'
                  }`}>
                    {response.status} {response.statusText}
                  </div>
                </div>
                <div>
                  <Label className="text-xs text-muted-foreground">Body</Label>
                  <pre className="mt-1 p-2 bg-gray-950 dark:bg-gray-900 rounded overflow-auto max-h-64 text-xs text-gray-100 font-mono">
                    {JSON.stringify(response.data, null, 2)}
                  </pre>
                </div>
              </div>
            ) : (
              <div className="text-center py-8 text-muted-foreground">
                <Globe className="h-8 w-8 mx-auto mb-2 opacity-50" />
                <p className="text-sm">Send a request to see the response</p>
              </div>
            )}
          </CardContent>
        </Card>
      </div>

      {/* Code Examples */}
      <Card className="mt-6">
        <CardHeader className="pb-3">
          <div className="flex items-center justify-between">
            <div>
              <CardTitle className="text-base">Code Examples</CardTitle>
              <CardDescription className="text-xs">Copy-ready code snippets</CardDescription>
            </div>
            <Select value={selectedLanguage} onValueChange={(v) => setSelectedLanguage(v as typeof selectedLanguage)}>
              <SelectTrigger className="w-32 h-8">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="js">JavaScript</SelectItem>
                <SelectItem value="ts">TypeScript</SelectItem>
                <SelectItem value="dart">Dart</SelectItem>
                <SelectItem value="kotlin">Kotlin</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </CardHeader>
        <CardContent>
          <div className="relative border rounded-lg overflow-hidden bg-[#1e1e1e]">
            <div className="flex items-center justify-between px-3 py-2 bg-[#252526] border-b">
              <div className="flex items-center gap-2">
                <FileCode className="h-3.5 w-3.5 text-gray-400" />
                <span className="text-xs text-gray-300 font-mono">
                  {selectedLanguage === 'js' ? 'request.js' : selectedLanguage === 'ts' ? 'request.ts' : selectedLanguage === 'dart' ? 'request.dart' : 'Request.kt'}
                </span>
              </div>
              <Button
                variant="ghost"
                size="sm"
                className="h-6 px-2 text-xs"
                onClick={() => copyToClipboard(generateCode(selectedLanguage), selectedLanguage)}
              >
                {copied === selectedLanguage ? (
                  <>
                    <Check className="h-3 w-3 mr-1 text-green-500" />
                    Copied
                  </>
                ) : (
                  <>
                    <Copy className="h-3 w-3 mr-1" />
                    Copy
                  </>
                )}
              </Button>
            </div>
            <div className="p-4 overflow-auto max-h-96">
              <pre className="text-sm font-mono text-[#d4d4d4] m-0">
                <code>{generateCode(selectedLanguage)}</code>
              </pre>
            </div>
          </div>
        </CardContent>
      </Card>
    </PageContainer>
  );
}
