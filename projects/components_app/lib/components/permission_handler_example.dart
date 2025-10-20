import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'file_download_helper_example.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import '../utils/permission_navigation_helper.dart';

class PermissionHandlerExample extends StatefulWidget {
  const PermissionHandlerExample({super.key});

  @override
  State<PermissionHandlerExample> createState() => _PermissionHandlerExampleState();
}

class _PermissionHandlerExampleState extends State<PermissionHandlerExample> {
  final PermissionHandlerHelper _permissionHelper = PermissionHandlerHelper.instance;

  final Map<AppPermission, String> _statusTextByPermission = {
    AppPermission.camera: 'Unknown',
    AppPermission.microphone: 'Unknown',
    AppPermission.storage: 'Unknown',
    AppPermission.photos: 'Unknown',
    AppPermission.notifications: 'Unknown',
  };

  bool _isLoading = false;

  // Notifications via MethodChannel
  static const MethodChannel _notifChannel = MethodChannel('osmea/notifications');
  static const MethodChannel _micChannel = MethodChannel('osmea/microphone');

  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _refreshAllStatuses();
  }

  Future<void> _refreshAllStatuses() async {
    setState(() => _isLoading = true);
    for (final p in _statusTextByPermission.keys) {
      final status = await _permissionHelper.getPermissionStatusString(p);
      _statusTextByPermission[p] = status;
    }
    setState(() => _isLoading = false);
  }

  Future<void> _request(AppPermission permission) async {
    setState(() => _isLoading = true);
    
    // Use the new navigation helper to check and redirect if needed
    final granted = await PermissionNavigationHelper.checkPermissionWithDialog(
      context, 
      permission
    );
    
    if (granted) {
      // Permission was granted, refresh status
      final status = await _permissionHelper.getPermissionStatusString(permission);
      _statusTextByPermission[permission] = status;
    } else {
      // User was redirected to permissions screen or denied
      // Refresh status when they return
      await _refreshAllStatuses();
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _check(AppPermission permission) async {
    setState(() => _isLoading = true);
    final isAllowed = await _permissionHelper.checkPermission(permission);
    final status = await _permissionHelper.getPermissionStatusString(permission);
    _statusTextByPermission[permission] = status;
    setState(() => _isLoading = false);

    if (!mounted) return;

    // Trigger real device features
    switch (permission) {
      case AppPermission.microphone:
        if (isAllowed) await _toggleMicRecording();
        break;
      case AppPermission.storage:
        if (isAllowed) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FileDownloadHelperExample()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Storage denied. Enable permission first.')),
          );
        }
        break;
      case AppPermission.photos:
        if (isAllowed) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FileDownloadHelperExample()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Photos denied. Enable permission first.')),
          );
        }
        break;
      case AppPermission.notifications:
        if (isAllowed) {
          await _showDeviceNotification();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notifications denied. Enable permission first.')),
          );
        }
        break;
      case AppPermission.camera:
        if (isAllowed) {
          await _openCameraPreview();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Camera denied. Enable permission first.')),
          );
        }
        break;
      default:
        break;
    }
  }

  Future<void> _toggleMicRecording() async {
    try {
      if (_isRecording) {
        final path = await _micChannel.invokeMethod<String>('stop');
        setState(() => _isRecording = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recording saved: ${path ?? 'unknown'}')),
        );
      } else {
        // Ensure path provider linked to trigger permissions if needed
        await getTemporaryDirectory();
        final started = await _micChannel.invokeMethod<bool>('start') ?? false;
        setState(() => _isRecording = started);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(started ? 'Recording started... tap Check to stop' : 'Failed to start recording')),
        );
      }
    } on PlatformException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mic error: ${e.message}')),
      );
    }
  }

  Future<void> _openCameraPreview() async {
    try {
      final cameras = await availableCameras();
      final first = cameras.first;
      if (!mounted) return;
      await Navigator.push(context, MaterialPageRoute(builder: (_) => _CameraPreviewScreen(cameraDescription: first)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open camera: $e')),
      );
    }
  }

  Future<void> _showDeviceNotification() async {
    try {
      // Respect permission: block if notifications are denied
      final allowed = await _permissionHelper.checkPermission(AppPermission.notifications);
      if (!allowed) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notifications denied. Enable permission first.')),
        );
        return;
      }
      await _notifChannel.invokeMethod('showNotification', {
        'title': 'OSMEA',
        'body': 'Test notification from Permissions Helper',
      });
    } on PlatformException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification failed: ${e.message}')),
      );
    }
  }

  Future<void> _clearCacheAndRefresh() async {
    setState(() => _isLoading = true);
    await _permissionHelper.clearPermissionCache();
    await _refreshAllStatuses();
    setState(() => _isLoading = false);
  }

  String _label(AppPermission p) {
    switch (p) {
      case AppPermission.camera:
        return 'Camera';
      case AppPermission.microphone:
        return 'Microphone';
      case AppPermission.location:
        return 'Location';
      case AppPermission.locationWhenInUse:
        return 'Location (In Use)';
      case AppPermission.storage:
        return 'Storage';
      case AppPermission.photos:
        return 'Photos / Media';
      case AppPermission.notifications:
        return 'Notifications';
      case AppPermission.contacts:
        return 'Contacts';
      case AppPermission.calendar:
        return 'Calendar';
      case AppPermission.manageExternalStorage:
        return 'Manage External Storage';
      case AppPermission.scheduleExactAlarm:
        return 'Schedule Exact Alarm';
    }
  }

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('granted')) return Colors.green;
    if (s.contains('limited')) return Colors.orange;
    if (s.contains('provisional')) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      appBar: AppBar(
        title: const Text('Permissions Helper Example'),
      ),
      backgroundColor: OsmeaColors.white,
      body: SafeArea(
        child: OsmeaComponents.column(
          children: [
            OsmeaComponents.padding(
              padding: const EdgeInsets.all(16),
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.text(
                    'Request and inspect common permissions',
                    variant: OsmeaTextVariant.titleMedium,
                    color: OsmeaColors.black,
                  ),
                  OsmeaComponents.sizedBox(height: 8),
                  if (_isLoading)
                    const LinearProgressIndicator(minHeight: 2),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                children: [
                  _permissionTile(AppPermission.camera),
                  _permissionTile(AppPermission.microphone),
                  _permissionTile(AppPermission.storage),
                  _permissionTile(AppPermission.photos),
                  _permissionTile(AppPermission.notifications),

                  OsmeaComponents.padding(
                    padding: const EdgeInsets.all(16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isNarrow = constraints.maxWidth < 360;
                        if (isNarrow) {
                          return OsmeaComponents.column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              OsmeaComponents.text(
                                'Actions',
                                variant: OsmeaTextVariant.titleSmall,
                                color: OsmeaColors.black,
                              ),
                              OsmeaComponents.sizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  OsmeaComponents.button(
                                    onPressed: _isLoading ? null : _refreshAllStatuses,
                                    text: 'Refresh All',
                                  ),
                                  OsmeaComponents.button(
                                    onPressed: _isLoading ? null : _clearCacheAndRefresh,
                                    text: 'Clear Cache',
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                        return OsmeaComponents.row(
                          children: [
                            OsmeaComponents.text(
                              'Actions',
                              variant: OsmeaTextVariant.titleSmall,
                              color: OsmeaColors.black,
                            ),
                            const Spacer(),
                            Wrap(
                              spacing: 8,
                              children: [
                                OsmeaComponents.button(
                                  onPressed: _isLoading ? null : _refreshAllStatuses,
                                  text: 'Refresh All',
                                ),
                                OsmeaComponents.button(
                                  onPressed: _isLoading ? null : _clearCacheAndRefresh,
                                  text: 'Clear Cache',
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _permissionTile(AppPermission permission) {
    final status = _statusTextByPermission[permission] ?? 'Unknown';
    return OsmeaComponents.container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: OsmeaColors.black.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 380;
            if (isNarrow) {
              return OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.security, color: OsmeaColors.black.withValues(alpha: 0.7)),
                      OsmeaComponents.sizedBox(width: 12),
                      Expanded(
                        child: OsmeaComponents.column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OsmeaComponents.text(
                              _label(permission),
                              variant: OsmeaTextVariant.bodyLarge,
                              color: OsmeaColors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            OsmeaComponents.sizedBox(height: 2),
                            OsmeaComponents.text(
                              'Status: $status',
                              variant: OsmeaTextVariant.bodySmall,
                              color: OsmeaColors.black.withValues(alpha: 0.6),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  OsmeaComponents.sizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusColor(status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(color: _statusColor(status), fontSize: 12),
                        ),
                      ),
                      OsmeaComponents.button(
                        onPressed: _isLoading ? null : () => _request(permission),
                        text: 'Request',
                      ),
                      OsmeaComponents.button(
                        onPressed: _isLoading ? null : () => _check(permission),
                        text: 'Check',
                      ),
                    ],
                  ),
                ],
              );
            }
            return OsmeaComponents.row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.security, color: OsmeaColors.black.withValues(alpha: 0.7)),
                OsmeaComponents.sizedBox(width: 12),
                Expanded(
                  child: OsmeaComponents.column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OsmeaComponents.text(
                        _label(permission),
                        variant: OsmeaTextVariant.bodyLarge,
                        color: OsmeaColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      OsmeaComponents.sizedBox(height: 2),
                      OsmeaComponents.text(
                        'Status: $status',
                        variant: OsmeaTextVariant.bodySmall,
                        color: OsmeaColors.black.withValues(alpha: 0.6),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusColor(status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(color: _statusColor(status), fontSize: 12),
                      ),
                    ),
                    OsmeaComponents.button(
                      onPressed: _isLoading ? null : () => _request(permission),
                      text: 'Request',
                    ),
                    OsmeaComponents.button(
                      onPressed: _isLoading ? null : () => _check(permission),
                      text: 'Check',
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CameraPreviewScreen extends StatefulWidget {
  final CameraDescription cameraDescription;
  const _CameraPreviewScreen({required this.cameraDescription});

  @override
  State<_CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<_CameraPreviewScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameraDescription, ResolutionPreset.medium, enableAudio: true);
    _initializeControllerFuture = _controller!.initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera Preview')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller!);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final file = await _controller!.takePicture();
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Photo captured: ${file.path}')),
            );
          } catch (e) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Capture failed: $e')),
            );
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
