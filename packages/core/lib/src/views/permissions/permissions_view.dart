import 'package:core/src/base/master_view_cubit/master_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:core/src/helper/permission_handler_helper/models/permission_models.dart';
import 'cubit/permissions_cubit.dart';
import 'cubit/permissions_state.dart';

/// 🔐 Permissions View
///
/// MasterViewCubit-based screen to manage app permissions.
/// Uses core PermissionsCubit/State and can be embedded by host apps.
class PermissionsView
    extends MasterViewCubit<PermissionsCubit, PermissionsState> {
  PermissionsView({
    required super.goRoute,
    super.arguments = const {},
    super.coreAppBar,
  });

  @override
  Future<void> initialContent(viewModel, BuildContext context) async {
    debugPrint('🔍 [PermissionsView] initialContent called');
    final prev = (arguments as Map?)?['previousRoute'] as String?;
    try {
      await viewModel.initialize(previousRoute: prev);
      debugPrint('🔍 [PermissionsView] Initialization completed');
    } catch (e) {
      debugPrint('🔴 [PermissionsView] Error in initialization: $e');
      rethrow;
    }
  }

  @override
  Widget viewContent(BuildContext context, viewModel, state) {
    debugPrint('🔍 [PermissionsView] viewContent called - Status: ${state.status}');
    
    if (state.status == PermissionsStatus.loading ||
        state.status == PermissionsStatus.initial) {
      debugPrint('🔍 [PermissionsView] Showing loading indicator');
      return const Center(child: CircularProgressIndicator());
    }

    final permissionStates = state.permissionStates;
    debugPrint('🔍 [PermissionsView] Building content with ${permissionStates.length} permissions');
    
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'App Permissions',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Manage app permissions to enable features',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: permissionStates.length,
              itemBuilder: (context, index) {
                final permission = permissionStates.keys.elementAt(index);
                final isEnabled = permissionStates[permission] ?? false;
                final label = _permissionLabel(permission);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(label),
                    trailing: Switch(
                      value: isEnabled,
                      onChanged: (_) {
                        debugPrint('🔍 [PermissionsView] Toggling permission: $permission');
                        viewModel.toggle(permission);
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          // Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Some permissions may require app restart to take effect.',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _permissionLabel(permission) {
    switch (permission) {
      case AppPermission.storage:
        return 'Storage';
      case AppPermission.camera:
        return 'Camera';
      case AppPermission.microphone:
        return 'Microphone';
      case AppPermission.locationWhenInUse:
        return 'Location';
      case AppPermission.photos:
        return 'Photos';
      case AppPermission.notifications:
        return 'Notifications';
      case AppPermission.contacts:
        return 'Contacts';
      case AppPermission.calendar:
        return 'Calendar';
      default:
        return 'Permission';
    }
  }
}


