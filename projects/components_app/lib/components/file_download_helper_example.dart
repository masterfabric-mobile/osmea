import 'dart:io';
import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// File Download Helper
///
/// Comprehensive usage of FileDownloadHelper with all available methods
/// including public storage downloads, file operations, and permission management.
class FileDownloadHelperExample extends StatefulWidget {
  const FileDownloadHelperExample({super.key});

  @override
  State<FileDownloadHelperExample> createState() => _FileDownloadHelperExampleState();
}

class _FileDownloadHelperExampleState extends State<FileDownloadHelperExample> {
  final TextEditingController _urlController = TextEditingController(
    text: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
  );
  final TextEditingController _filenameController = TextEditingController(
    text: 'sample_document.pdf',
  );
  
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String _downloadStatus = '';
  File? _lastDownloadedFile;
  StorageLocation _selectedLocation = StorageLocation.appPrivate;

  @override
  void dispose() {
    _urlController.dispose();
    _filenameController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _downloadFile(StorageLocation location) async {
    if (_isDownloading) return;
    
    final url = _urlController.text.trim();
    final filename = _filenameController.text.trim();
    
    if (url.isEmpty || filename.isEmpty) {
      _showSnackBar('Please enter both URL and filename', isError: true);
      return;
    }

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
      _downloadStatus = 'Starting download...';
      _lastDownloadedFile = null;
    });

    try {
      File downloadedFile;
      
      switch (location) {
        case StorageLocation.appPrivate:
          downloadedFile = await FileDownloadHelper.downloadFile(
            url: url,
            fileName: filename,
            onProgress: _onDownloadProgress,
          );
          break;
        case StorageLocation.publicDocuments:
          downloadedFile = await FileDownloadHelper.downloadToPublicDocuments(
            url: url,
            fileName: filename,
            onProgress: _onDownloadProgress,
          );
          break;
        case StorageLocation.publicDownloads:
          downloadedFile = await FileDownloadHelper.downloadToPublicDownloads(
            url: url,
            fileName: filename,
            onProgress: _onDownloadProgress,
          );
          break;
      }

      setState(() {
        _isDownloading = false;
        _downloadProgress = 1.0;
        _downloadStatus = 'Download completed!';
        _lastDownloadedFile = downloadedFile;
      });

      _showSnackBar('File downloaded successfully to: ${downloadedFile.path}');
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _downloadProgress = 0.0;
        _downloadStatus = 'Download failed: $e';
      });
      
      if (e is StoragePermissionException) {
        _showSnackBar('Permission denied. Check app settings.', isError: true);
      } else {
        _showSnackBar('Download failed: $e', isError: true);
      }
    }
  }

  void _onDownloadProgress(int received, int total) {
    if (total > 0) {
      final progress = received / total;
      setState(() {
        _downloadProgress = progress;
        _downloadStatus = 'Downloading... ${(progress * 100).toStringAsFixed(1)}%';
      });
    }
  }

  Future<void> _openFile() async {
    if (_lastDownloadedFile == null) {
      _showSnackBar('No file to open. Download a file first.', isError: true);
      return;
    }

    try {
      final success = await FileDownloadHelper.openFile(_lastDownloadedFile!);
      if (success) {
        _showSnackBar('File opened successfully');
      } else {
        _showSnackBar('Failed to open file', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error opening file: $e', isError: true);
    }
  }

  Future<void> _shareFile() async {
    if (_lastDownloadedFile == null) {
      _showSnackBar('No file to share. Download a file first.', isError: true);
      return;
    }

    try {
      final success = await FileDownloadHelper.shareFile(_lastDownloadedFile!);
      if (success) {
        _showSnackBar('File sharing initiated');
      } else {
        _showSnackBar('Failed to share file', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error sharing file: $e', isError: true);
    }
  }

  Future<void> _revealInFileManager() async {
    if (_lastDownloadedFile == null) {
      _showSnackBar('No file to reveal. Download a file first.', isError: true);
      return;
    }

    try {
      final success = await FileDownloadHelper.revealInFileManager(_lastDownloadedFile!);
      if (success) {
        _showSnackBar('File manager opened');
      } else {
        _showSnackBar('Failed to open file manager', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error opening file manager: $e', isError: true);
    }
  }

  Future<void> _checkPermissions() async {
    try {
      final hasPermissions = await FileDownloadHelper.hasStoragePermissions();
      final status = await FileDownloadHelper.getStoragePermissionStatus();
      
      String message = 'Storage Permission: ';
      if (hasPermissions) {
        message += 'Granted ✅';
      } else if (status.isPermanentlyDenied) {
        message += 'Permanently Denied ❌';
      } else {
        message += 'Denied ❌';
      }
      
      _showSnackBar(message);
    } catch (e) {
      _showSnackBar('Error checking permissions: $e', isError: true);
    }
  }

  Future<void> _openAppSettings() async {
    try {
      final success = await FileDownloadHelper.openAppSettings();
      if (success) {
        _showSnackBar('App settings opened');
      } else {
        _showSnackBar('Failed to open app settings', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error opening app settings: $e', isError: true);
    }
  }

  void _cancelDownloads() {
    FileDownloadHelper.cancelAllDownloads();
    setState(() {
      _isDownloading = false;
      _downloadProgress = 0.0;
      _downloadStatus = 'Downloads cancelled';
    });
    _showSnackBar('All downloads cancelled');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Download Helper'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // URL Input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📥 Download Configuration',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        labelText: 'File URL',
                        hintText: 'https://example.com/file.pdf',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _filenameController,
                      decoration: const InputDecoration(
                        labelText: 'File Name',
                        hintText: 'document.pdf',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.file_present),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Storage Location Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📁 Storage Location',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ...StorageLocation.values.map((location) => RadioListTile<StorageLocation>(
                      title: Text(_getLocationDisplayName(location)),
                      subtitle: Text(_getLocationDescription(location)),
                      value: location,
                      groupValue: _selectedLocation,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedLocation = value;
                          });
                        }
                      },
                    )).toList(),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Download Progress
            if (_isDownloading || _downloadProgress > 0)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '📊 Download Progress',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: _downloadProgress,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _isDownloading ? Colors.blue : Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _downloadStatus,
                        style: TextStyle(
                          color: _isDownloading ? Colors.blue : Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Download Actions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🚀 Download Actions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isDownloading ? null : () => _downloadFile(_selectedLocation),
                          icon: const Icon(Icons.download),
                          label: Text('Download to ${_getLocationDisplayName(_selectedLocation)}'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _isDownloading ? _cancelDownloads : null,
                          icon: const Icon(Icons.cancel),
                          label: const Text('Cancel Downloads'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // File Operations
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📱 File Operations',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    if (_lastDownloadedFile != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Last Downloaded File:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _lastDownloadedFile!.path,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _lastDownloadedFile != null ? _openFile : null,
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Open File'),
                        ),
                        ElevatedButton.icon(
                          onPressed: _lastDownloadedFile != null ? _shareFile : null,
                          icon: const Icon(Icons.share),
                          label: const Text('Share File'),
                        ),
                        ElevatedButton.icon(
                          onPressed: _lastDownloadedFile != null ? _revealInFileManager : null,
                          icon: const Icon(Icons.folder_open),
                          label: const Text('Reveal in Files'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Permission Management
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🔐 Permission Management',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _checkPermissions,
                          icon: const Icon(Icons.security),
                          label: const Text('Check Permissions'),
                        ),
                        ElevatedButton.icon(
                          onPressed: _openAppSettings,
                          icon: const Icon(Icons.settings),
                          label: const Text('Open Settings'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Utility Functions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🛠️ Utility Functions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            final extension = FileDownloadHelper.getFileExtension(_urlController.text);
                            _showSnackBar('File extension: ${extension.isEmpty ? 'None' : extension}');
                          },
                          icon: const Icon(Icons.extension),
                          label: const Text('Get Extension'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final tempDir = Directory.systemTemp.path;
                            final uniqueName = await FileDownloadHelper.generateUniqueFileName(
                              tempDir, 
                              _filenameController.text
                            );
                            _showSnackBar('Unique filename: $uniqueName');
                          },
                          icon: const Icon(Icons.auto_fix_high),
                          label: const Text('Generate Unique Name'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Information Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Information',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('Storage Locations:'),
                    const SizedBox(height: 8),
                    const Text('• App Private: Files stored in app\'s private directory'),
                    const Text('• Public Documents: Files visible in system Documents folder'),
                    const Text('• Public Downloads: Files visible in system Downloads folder'),
                    const SizedBox(height: 12),
                    const Text('Note: Public storage requires storage permissions on Android.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLocationDisplayName(StorageLocation location) {
    switch (location) {
      case StorageLocation.appPrivate:
        return 'App Private';
      case StorageLocation.publicDocuments:
        return 'Public Documents';
      case StorageLocation.publicDownloads:
        return 'Public Downloads';
    }
  }

  String _getLocationDescription(StorageLocation location) {
    switch (location) {
      case StorageLocation.appPrivate:
        return 'App-only access, no permissions needed';
      case StorageLocation.publicDocuments:
        return 'Visible in system Documents folder';
      case StorageLocation.publicDownloads:
        return 'Visible in system Downloads folder';
    }
  }
}
