import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import '../routes/app_routes.dart';

/// Utility class for handling permission checks and navigation
class PermissionNavigationHelper {
  /// Check if permissions are needed and redirect to permissions screen if necessary
  /// Returns true if redirect happened, false if permissions are already granted
  static Future<bool> checkAndRedirectToPermissions(BuildContext context) async {
    try {
      final permissionHelper = PermissionHandlerHelper.instance;
      final shouldShowPermissions = await permissionHelper.shouldShowPermissionsScreen();
      
      if (shouldShowPermissions) {
        // Navigate to permissions screen (push to keep back stack)
        final current = GoRouterState.of(context).uri.toString();
        GoRouter.of(context).push(AppRoutes.permissions, extra: current);
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('Error checking permissions: $e');
      return false;
    }
  }

  /// Check specific permission and redirect to permissions screen if denied
  /// Returns true if permission is granted, false if denied/redirected
  static Future<bool> checkSpecificPermission(
    BuildContext context, 
    AppPermission permission
  ) async {
    try {
      final permissionHelper = PermissionHandlerHelper.instance;
      final status = await permissionHelper.getPermissionStatus(permission);
      
      if (status.isGranted || status.isLimited) {
        return true;
      }
      
      // Permission not granted, redirect to permissions screen
      final current = GoRouterState.of(context).uri.toString();
      GoRouter.of(context).push(AppRoutes.permissions, extra: current);
      return false;
    } catch (e) {
      debugPrint('Error checking specific permission: $e');
      return false;
    }
  }

  /// Show a dialog asking user if they want to go to permissions screen
  /// Returns true if user chooses to go to permissions
  static Future<bool> showPermissionDialog(BuildContext context) async {
    debugPrint('🔍 [PermissionDialog] Showing permission dialog');
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        debugPrint('🔍 [PermissionDialog] Dialog builder called');
        return AlertDialog(
          title: const Text('Permissions Required'),
          content: const Text(
            'This feature requires additional permissions. Would you like to manage your app permissions?'
          ),
          actions: [
            TextButton(
              onPressed: () {
                debugPrint('🔍 [PermissionDialog] User clicked "Not now"');
                Navigator.of(ctx).pop(false);
              },
              child: const Text('Not now'),
            ),
            TextButton(
              onPressed: () {
                debugPrint('🔍 [PermissionDialog] User clicked "Manage Permissions"');
                Navigator.of(ctx).pop(true);
              },
              child: const Text('Manage Permissions'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  /// Check permission with user confirmation dialog
  /// Returns true if permission is granted, false if denied/redirected
  static Future<bool> checkPermissionWithDialog(
    BuildContext context, 
    AppPermission permission
  ) async {
    debugPrint('🔍 [PermissionCheck] Starting checkPermissionWithDialog for $permission');
    try {
      final permissionHelper = PermissionHandlerHelper.instance;
      final status = await permissionHelper.getPermissionStatus(permission);
      debugPrint('🔍 [PermissionCheck] Current permission status: $status');
      
      if (status.isGranted || status.isLimited) {
        debugPrint('🔍 [PermissionCheck] Permission already granted/limited, returning true');
        return true;
      }
      
      debugPrint('🔍 [PermissionCheck] Permission not granted, showing dialog');
      // Show dialog asking user if they want to manage permissions
      final shouldManagePermissions = await showPermissionDialog(context);
      debugPrint('🔍 [PermissionCheck] Dialog result: $shouldManagePermissions');
      
      if (shouldManagePermissions) {
        debugPrint('🔍 [PermissionCheck] User chose to manage permissions, navigating to permissions screen');
        AppRoutes.goToPermissions(context);
      }
      
      return false;
    } catch (e) {
      debugPrint('🔴 [PermissionCheck] Error in checkPermissionWithDialog: $e');
      debugPrintStack();
      return false;
    }
  }
}
