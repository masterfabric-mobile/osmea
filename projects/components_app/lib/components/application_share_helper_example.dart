import 'dart:io';
import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// 📤 Application Share Helper
///
/// Validate and showcase sharing text, URLs, a single file,
/// and multiple files using `ApplicationShareHelper`.
class ApplicationShareHelperExample extends StatefulWidget {
  const ApplicationShareHelperExample({super.key});

  @override
  State<ApplicationShareHelperExample> createState() => _ApplicationShareHelperExampleState();
}

class _ApplicationShareHelperExampleState extends State<ApplicationShareHelperExample> {
  final TextEditingController _textController = TextEditingController(text: 'Hello from OSMEA!');
  final TextEditingController _subjectController = TextEditingController(text: 'OSMEA Share');
  final TextEditingController _urlController = TextEditingController(text: 'https://flutter.dev');
  final TextEditingController _filePathController = TextEditingController();
  final TextEditingController _multiFilePathsController = TextEditingController();

  bool _isSharing = false;
  String _lastResult = '';

  @override
  void dispose() {
    _textController.dispose();
    _subjectController.dispose();
    _urlController.dispose();
    _filePathController.dispose();
    _multiFilePathsController.dispose();
    super.dispose();
  }

  void _setLoading(String message) {
    setState(() {
      _isSharing = true;
      _lastResult = message;
    });
  }

  void _setResult(String message) {
    setState(() {
      _isSharing = false;
      _lastResult = message;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Share Helper'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Results Panel
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text('Results', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        if (_isSharing)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _lastResult.isEmpty ? 'No tests run yet' : _lastResult,
                      style: TextStyle(
                        color: _lastResult.contains('✅')
                            ? Colors.green.shade700
                            : _lastResult.contains('❌')
                                ? Colors.red.shade700
                                : Colors.grey.shade700,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Share Text
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('📝 Share Text', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        labelText: 'Text',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.text_fields),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Subject (optional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.subject),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _isSharing
                          ? null
                          : () async {
                              final text = _textController.text.trim();
                              if (text.isEmpty) {
                                _showSnackBar('Please enter text to share', isError: true);
                                return;
                              }
                              _setLoading('Sharing text...');
                              final ok = await ApplicationShareHelper.shareText(text, subject: _subjectController.text.trim().isEmpty ? null : _subjectController.text.trim());
                              _setResult('Share Text: ${ok ? '✅ Success' : '❌ Failed'}');
                              _showSnackBar(ok ? 'Text share started' : 'Failed to start text share', isError: !ok);
                            },
                      icon: const Icon(Icons.share),
                      label: const Text('Share Text'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Share URL
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🔗 Share URL', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        labelText: 'URL',
                        hintText: 'https://example.com',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _isSharing
                          ? null
                          : () async {
                              final url = _urlController.text.trim();
                              if (url.isEmpty || !UrlLauncher.isValidUrl(url)) {
                                _showSnackBar('Enter a valid URL to share', isError: true);
                                return;
                              }
                              _setLoading('Sharing URL...');
                              final ok = await ApplicationShareHelper.shareUrl(url, subject: _subjectController.text.trim().isEmpty ? null : _subjectController.text.trim());
                              _setResult('Share URL: ${ok ? '✅ Success' : '❌ Failed'}');
                              _showSnackBar(ok ? 'URL share started' : 'Failed to start URL share', isError: !ok);
                            },
                      icon: const Icon(Icons.share),
                      label: const Text('Share URL'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Share Single File
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('📄 Share Single File', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _filePathController,
                      decoration: const InputDecoration(
                        labelText: 'File path',
                        hintText: '/path/to/file.pdf',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.insert_drive_file),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _isSharing
                          ? null
                          : () async {
                              final path = _filePathController.text.trim();
                              if (path.isEmpty) {
                                _showSnackBar('Enter a file path', isError: true);
                                return;
                              }
                              final file = File(path);
                              if (!file.existsSync()) {
                                _showSnackBar('File not found: $path', isError: true);
                                return;
                              }
                              _setLoading('Sharing file...');
                              final ok = await ApplicationShareHelper.shareFile(
                                file,
                                text: _textController.text.trim().isEmpty ? null : _textController.text.trim(),
                                subject: _subjectController.text.trim().isEmpty ? null : _subjectController.text.trim(),
                              );
                              _setResult('Share File: ${ok ? '✅ Success' : '❌ Failed'}');
                              _showSnackBar(ok ? 'File share started' : 'Failed to start file share', isError: !ok);
                            },
                      icon: const Icon(Icons.share),
                      label: const Text('Share File'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Share Multiple Files
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🗂️ Share Multiple Files', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _multiFilePathsController,
                      decoration: const InputDecoration(
                        labelText: 'File paths (comma-separated)',
                        hintText: '/path/one.png, /path/two.pdf',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.folder_copy),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _isSharing
                          ? null
                          : () async {
                              final raw = _multiFilePathsController.text.trim();
                              if (raw.isEmpty) {
                                _showSnackBar('Enter at least one file path', isError: true);
                                return;
                              }
                              final paths = raw
                                  .split(',')
                                  .map((e) => e.trim())
                                  .where((e) => e.isNotEmpty)
                                  .toList();
                              final files = paths.map((p) => File(p)).toList();
                              if (files.isEmpty) {
                                _showSnackBar('No valid file paths', isError: true);
                                return;
                              }
                              _setLoading('Sharing multiple files...');
                              final ok = await ApplicationShareHelper.shareFiles(
                                files,
                                text: _textController.text.trim().isEmpty ? null : _textController.text.trim(),
                                subject: _subjectController.text.trim().isEmpty ? null : _subjectController.text.trim(),
                              );
                              _setResult('Share Files: ${ok ? '✅ Success' : '❌ Failed'}');
                              _showSnackBar(ok ? 'Files share started' : 'Failed to start files share', isError: !ok);
                            },
                      icon: const Icon(Icons.share),
                      label: const Text('Share Files'),
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
}


