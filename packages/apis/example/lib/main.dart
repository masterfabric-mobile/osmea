import 'package:apis/network/remote/access/access_scope/abstract/access_scope_service.dart';
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
    return MaterialApp(
      title: 'OSMEA Network',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
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
  String? _requestJson;
  String? _responseJson;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Request Dev Tester'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: _requestType,
              dropdownColor: Colors.black,
              decoration: const InputDecoration(
                labelText: "Request Type",
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
              items: const [
                DropdownMenuItem(value: "GET", child: Text("GET")),
                DropdownMenuItem(value: "POST", child: Text("POST")),
              ],
              onChanged: (v) => setState(() => _requestType = v!),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loading ? null : _sendRequest,
              icon: _loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send, color: Colors.white),
              label: const Text("Send Request"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            if (_requestJson != null) ...[
              const Text("Request:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              Container(
                width: double.infinity,
                color: Colors.grey[900],
                padding: const EdgeInsets.all(8),
                child: Text(_requestJson!, style: const TextStyle(fontFamily: "monospace", color: Colors.white)),
              ),
              const SizedBox(height: 16),
            ],
            if (_responseJson != null) ...[
              const Text("Response:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              Container(
                width: double.infinity,
                color: Colors.grey[850],
                padding: const EdgeInsets.all(8),
                child: Text(_responseJson!, style: const TextStyle(fontFamily: "monospace", color: Colors.white)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _sendRequest() async {
    setState(() {
      _loading = true;
      _requestJson = null;
      _responseJson = null;
    });

    final requestType = _requestType;
    dynamic response;

    try {
      if (requestType == "GET") {
        _requestJson = jsonEncode({"type": "GET", "endpoint": "/accessScope"});
        response = await GetIt.I.get<AccessScopeService>().accessScope();
        _responseJson = const JsonEncoder.withIndent('  ').convert(response.toJson());
      } else if (requestType == "POST") {
        _requestJson = jsonEncode({"type": "POST", "endpoint": "/accessScope"});
        _responseJson = "POST not implemented for /accessScope";
      }
    } catch (e) {
      _responseJson = "Error: $e";
    }

    setState(() {
      _loading = false;
    });
  }
}
