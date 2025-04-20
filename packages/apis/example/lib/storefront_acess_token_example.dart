import 'package:apis/apis.dart';
import 'package:apis/network/remote/access/storefront_access_token/abstract/storefront_access_token.dart';
import 'package:apis/network/remote/access/storefront_access_token/freezed_model/request/create_new_storefront_access_token_request.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:convert';

import 'di/config/config_di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Simple, clean, modern theme
    return MaterialApp(
      title: 'Storefront API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF334155), // Slate color
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF334155),
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _requestType = "GET";
  String? _responseJson;
  bool _loading = false;
  final TextEditingController _tokenController = TextEditingController();

  // Define method options and their colors
  final List<Map<String, dynamic>> _methods = [
    {'name': 'GET', 'color': const Color(0xFF10B981)}, // Green
    {'name': 'POST', 'color': const Color(0xFF3B82F6)}, // Blue 
    {'name': 'PUT', 'color': const Color(0xFFF59E0B)}, // Amber
    {'name': 'DELETE', 'color': const Color(0xFFEF4444)}, // Red
  ];

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storefront Token API'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HTTP Method Selection
            const Text(
              'HTTP Method',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            
            // Method selection pills
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _methods.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final method = _methods[index];
                  final isSelected = _requestType == method['name'];
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() => _requestType = method['name']);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? method['color'] : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          method['name'],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Parameters (only for non-GET methods)
            if (_requestType == "POST") ...[
              const Text(
                'Parameters',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _tokenController,
                decoration: const InputDecoration(
                  labelText: "Token Title",
                  hintText: "Enter a title for the new token",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
            ],
            
            // Execute button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _sendRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getMethodColor(),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text("Execute $_requestType Request"),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Response section
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Response',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(color: Colors.white24),
                    if (_loading)
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      )
                    else if (_responseJson == null)
                      const Expanded(
                        child: Center(
                          child: Text(
                            'No response data',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            _responseJson!,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getMethodColor() {
    for (final method in _methods) {
      if (method['name'] == _requestType) {
        return method['color'];
      }
    }
    return Colors.grey;
  }

  Future<void> _sendRequest() async {
    setState(() {
      _loading = true;
      _responseJson = null;
    });

    final requestType = _requestType;
    dynamic response;

    try {
      if (requestType == "GET") {
        response = await GetIt.I
            .get<StorefrontAccessTokenService>()
            .storefrontAccessToken(
              apiVersion: ApiNetwork.apiVersion,
            );
        _responseJson =
            const JsonEncoder.withIndent('  ').convert(response.toJson());
      } else if (requestType == "POST") {
        
        response = await GetIt.I
            .get<StorefrontAccessTokenService>()
            .createNewStorefrontAccessToken(
              apiVersion: ApiNetwork.apiVersion,
              model: CreateNewStorefrontAccessTokenRequest(
                
              ),
            );
        _responseJson =
            const JsonEncoder.withIndent('  ').convert(response.toJson());
      }
    } catch (e) {
      _responseJson = "Error: $e";
    }

    setState(() {
      _loading = false;
    });
  }
}
