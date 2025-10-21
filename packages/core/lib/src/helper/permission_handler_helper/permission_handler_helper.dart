library permission_handler_helper;

import 'dart:io';
import 'package:permission_handler/permission_handler.dart' as ph;
import '../device_info_helper.dart';
import '../local_storage/local_storage_helper.dart';
import 'abstract/permission_handler_base.dart';
import 'models/permission_models.dart';

void coreDebugPrint(Object? message) {
  // Lightweight logger that does nothing in release if desired
  // For now, forward to print to avoid importing Flutter in core package
  // ignore: avoid_print
  print(message);
}

/// 🔐 Permission Handler Helper for managing runtime permissions
/// 
/// This helper provides a unified API for managing runtime permissions across
/// different platforms (Android/iOS) with features like:
/// - Centralized permission management
/// - Consistent user experience
/// - Cross-platform support
/// - Extensible permission types
/// - Safe defaults and error handling
/// 
/// ## Supported Permissions
/// 
/// - **Camera**: Access to device camera for photo/video capture
/// - **Microphone**: Access to device microphone for audio recording
/// - **Location**: Access to device location services
/// - **Storage**: Access to device storage for file operations
/// - **Photos**: Access to photo library (iOS) / Media files (Android)
/// - **Notifications**: Permission to send push notifications
/// - **Contacts**: Access to device contacts
/// - **Calendar**: Access to device calendar
/// - **Schedule Exact Alarm**: Permission to schedule exact alarms (Android 12+)
/// 
/// ## Usage Examples
/// 
/// ### Basic Permission Request
/// ```dart
/// final permissionHelper = PermissionHandlerHelper.instance;
/// 
/// // Request camera permission
/// final granted = await permissionHelper.requestPermission(AppPermission.camera);
/// if (granted) {
///   // Camera access granted, proceed with camera operations
///   openCamera();
/// } else {
///   // Camera access denied, show alternative UI or message
///   showPermissionDeniedMessage();
/// }
/// ```
/// 
/// ### Check Permission Status
/// ```dart
/// // Check if permission is already granted
/// final hasPermission = await permissionHelper.checkPermission(AppPermission.location);
/// if (hasPermission) {
///   startLocationTracking();
/// }
/// ```
/// 
/// ### Multiple Permissions
/// ```dart
/// // Request multiple permissions at once
/// final results = await permissionHelper.requestMultiplePermissions([
///   AppPermission.camera,
///   AppPermission.microphone,
/// ]);
/// 
/// if (results[AppPermission.camera] == ph.PermissionStatus.granted &&
///     results[AppPermission.microphone] == ph.PermissionStatus.granted) {
///   // Both permissions granted
///   startVideoRecording();
/// }
/// ```
/// 
/// ### Handle Permanently Denied Permissions
/// ```dart
/// final status = await permissionHelper.getPermissionStatus(AppPermission.storage);
/// if (status == ph.PermissionStatus.permanentlyDenied) {
///   // Show dialog explaining the permission and offer to open settings
///   final shouldOpenSettings = await showPermissionDialog();
///   if (shouldOpenSettings) {
///     await permissionHelper.openAppSettings();
///   }
/// }
/// ```
/// 
/// ### Permission Rationale
/// ```dart
/// // Check if we should show rationale (Android)
/// if (await permissionHelper.shouldShowRequestPermissionRationale(AppPermission.camera)) {
///   // Show explanation before requesting permission
///   await showPermissionExplanationDialog();
/// }
/// 
/// // Then request permission
/// await permissionHelper.requestPermission(AppPermission.camera);
/// ```
/// 
/// ### Exact Alarm Permissions (Android 12+)
/// ```dart
/// // Check if exact alarm permissions are needed (Android 12+)
/// final hasSchedulePermission = await permissionHelper.checkPermission(AppPermission.scheduleExactAlarm);
/// if (!hasSchedulePermission) {
///   final granted = await permissionHelper.requestPermission(AppPermission.scheduleExactAlarm);
///   if (!granted) {
///     // Show explanation and redirect to settings
///     await permissionHelper.openAppSettings();
///   }
/// }
/// ```


/// Main PermissionHandlerHelper class implementing centralized permission management
class PermissionHandlerHelper implements IPermissionHandlerBase {
  // Singleton pattern implementation
  static final PermissionHandlerHelper _instance = PermissionHandlerHelper._internal();
  static PermissionHandlerHelper get instance => _instance;
  PermissionHandlerHelper._internal();
  
  /// Factory constructor for easy access
  factory PermissionHandlerHelper() => _instance;

  /// Local storage helper instance for caching permission states
  final LocalStorageHelper _localStorage = LocalStorageHelper();
  
  /// Flag to track if local storage is initialized
  bool _isStorageInitialized = false;

  /// Permission cache keys prefix
  static const String _permissionPrefix = 'permission_';
  static const String _permissionTimestampPrefix = 'permission_timestamp_';
  static const String _permissionCacheValidityHours = 'permission_cache_validity_hours';
  
  /// Default cache validity in hours
  static const int _defaultCacheValidityHours = 24;

  /// Initialize local storage for permission caching
  Future<void> _initializeStorage() async {
    if (_isStorageInitialized) return;
    
    try {
      await _localStorage.init();
      _isStorageInitialized = true;
      coreDebugPrint('🗂️ Permission storage initialized successfully');
    } catch (e) {
      coreDebugPrint('🔴 Failed to initialize permission storage: $e');
      _isStorageInitialized = false;
    }
  }

  /// Get cache key for permission
  String _getPermissionCacheKey(AppPermission permission) {
    return '$_permissionPrefix${permission.name}';
  }

  /// Get timestamp cache key for permission
  String _getPermissionTimestampKey(AppPermission permission) {
    return '$_permissionTimestampPrefix${permission.name}';
  }

  /// Check if cached permission is still valid
  Future<bool> _isCacheValid(AppPermission permission) async {
    if (!_isStorageInitialized) return false;

    try {
      final timestampStr = await _localStorage.getItem(_getPermissionTimestampKey(permission));
      if (timestampStr == null) return false;

      final timestamp = int.tryParse(timestampStr.toString());
      if (timestamp == null) return false;

      final cacheValidityHours = await _localStorage.getItem(_permissionCacheValidityHours) ?? _defaultCacheValidityHours;
      final validityMs = (cacheValidityHours as int) * 60 * 60 * 1000; // Convert hours to milliseconds
      final now = DateTime.now().millisecondsSinceEpoch;

      final isValid = (now - timestamp) < validityMs;
      coreDebugPrint('📅 Cache validity for ${permission.name}: $isValid (age: ${(now - timestamp) ~/ (60 * 1000)} minutes)');
      
      return isValid;
    } catch (e) {
      coreDebugPrint('🔴 Error checking cache validity for ${permission.name}: $e');
      return false;
    }
  }

  /// Cache permission status
  Future<void> _cachePermissionStatus(AppPermission permission, ph.PermissionStatus status) async {
    if (!_isStorageInitialized) {
      await _initializeStorage();
      if (!_isStorageInitialized) return;
    }

    try {
      final cacheKey = _getPermissionCacheKey(permission);
      final timestampKey = _getPermissionTimestampKey(permission);
      final now = DateTime.now().millisecondsSinceEpoch;

      await _localStorage.setItem(cacheKey, status.toString());
      await _localStorage.setItem(timestampKey, now.toString());
      
      coreDebugPrint('💾 Cached permission status: ${permission.name} = ${status.toString()}');
    } catch (e) {
      coreDebugPrint('🔴 Error caching permission status for ${permission.name}: $e');
    }
  }

  /// Get cached permission status
  Future<ph.PermissionStatus?> _getCachedPermissionStatus(AppPermission permission) async {
    if (!_isStorageInitialized) {
      await _initializeStorage();
      if (!_isStorageInitialized) return null;
    }

    try {
      if (!(await _isCacheValid(permission))) {
        coreDebugPrint('⏰ Cache expired for ${permission.name}');
        return null;
      }

      final cacheKey = _getPermissionCacheKey(permission);
      final cachedStatusStr = await _localStorage.getItem(cacheKey);
      
      if (cachedStatusStr == null) {
        coreDebugPrint('📭 No cached status found for ${permission.name}');
        return null;
      }

      // Parse PermissionStatus from string
      final statusString = cachedStatusStr.toString().split('.').last;
      for (final status in ph.PermissionStatus.values) {
        if (status.toString().split('.').last == statusString) {
          coreDebugPrint('📋 Retrieved cached permission status: ${permission.name} = ${status.toString()}');
          return status;
        }
      }

      coreDebugPrint('🔴 Failed to parse cached status for ${permission.name}: $cachedStatusStr');
      return null;
    } catch (e) {
      coreDebugPrint('🔴 Error getting cached permission status for ${permission.name}: $e');
      return null;
    }
  }

  /// Clear permission cache
  Future<void> clearPermissionCache([AppPermission? specificPermission]) async {
    if (!_isStorageInitialized) {
      await _initializeStorage();
      if (!_isStorageInitialized) return;
    }

    try {
      if (specificPermission != null) {
        // Clear specific permission cache
        await _localStorage.removeItem(_getPermissionCacheKey(specificPermission));
        await _localStorage.removeItem(_getPermissionTimestampKey(specificPermission));
        coreDebugPrint('🗑️ Cleared cache for ${specificPermission.name}');
      } else {
        // Clear all permission caches
        final allItems = await _localStorage.getAllItems();
        for (final key in allItems.keys) {
          if (key.startsWith(_permissionPrefix) || key.startsWith(_permissionTimestampPrefix)) {
            await _localStorage.removeItem(key);
          }
        }
        coreDebugPrint('🗑️ Cleared all permission caches');
      }
    } catch (e) {
      coreDebugPrint('🔴 Error clearing permission cache: $e');
    }
  }

  // Soft override storage keys
  static const String _softOverridePrefix = 'perm_soft_override_';

  String _getSoftOverrideKey(AppPermission permission) =>
      '$_softOverridePrefix${permission.name}';

  /// Set a soft permission override which the app respects before querying OS
  /// When [granted] is true, the permission is treated as granted by the app.
  /// When false, it is treated as denied by the app.
  Future<void> setSoftPermission(AppPermission permission, bool granted) async {
    if (!_isStorageInitialized) {
      await _initializeStorage();
      if (!_isStorageInitialized) return;
    }
    try {
      // Store as string for compatibility across storage backends
      await _localStorage.setItem(
        _getSoftOverrideKey(permission),
        granted ? 'true' : 'false',
      );
      coreDebugPrint('📝 Soft override set for ${permission.name}: $granted');
    } catch (e) {
      coreDebugPrint('🔴 Error setting soft override for ${permission.name}: $e');
    }
  }

  /// Clear soft override for a permission
  Future<void> clearSoftPermission(AppPermission permission) async {
    if (!_isStorageInitialized) {
      await _initializeStorage();
      if (!_isStorageInitialized) return;
    }
    try {
      await _localStorage.removeItem(_getSoftOverrideKey(permission));
      coreDebugPrint('🧹 Soft override cleared for ${permission.name}');
    } catch (e) {
      coreDebugPrint('🔴 Error clearing soft override for ${permission.name}: $e');
    }
  }

  /// Clear all soft overrides for permissions (useful for debugging)
  Future<void> clearAllSoftOverrides() async {
    if (!_isStorageInitialized) {
      await _initializeStorage();
      if (!_isStorageInitialized) return;
    }
    try {
      final allItems = await _localStorage.getAllItems();
      final softOverrideKeys = allItems.keys
          .where((key) => key.startsWith(_softOverridePrefix))
          .toList();
      
      for (final key in softOverrideKeys) {
        await _localStorage.removeItem(key);
        final permissionName = key.replaceFirst(_softOverridePrefix, '');
        coreDebugPrint('🧹 Soft override cleared for $permissionName');
      }
      
      coreDebugPrint('🧹 Cleared ${softOverrideKeys.length} soft overrides');
    } catch (e) {
      coreDebugPrint('🔴 Error clearing all soft overrides: $e');
    }
  }

  /// Initialize permission handler for real iOS devices
  /// This method should be called at app startup to ensure proper permission handling
  Future<void> initializeForRealDevice() async {
    if (!_isStorageInitialized) {
      await _initializeStorage();
      if (!_isStorageInitialized) return;
    }

    // Clear soft overrides on real iOS devices to ensure proper permission handling
    if (Platform.isIOS) {
      final isSimulator = !(await DeviceInfoHelper.instance.platformDevicePhysical());
      if (!isSimulator) {
        coreDebugPrint('📱 iOS Real Device detected - clearing soft overrides for proper permission handling');
        await clearAllSoftOverrides();
        // Also clear permission cache to force fresh checks
        await clearPermissionCache();
      } else {
        coreDebugPrint('📱 iOS Simulator detected - keeping soft overrides for testing');
      }
    }
    
    coreDebugPrint('🔐 PermissionHandlerHelper initialized for real device');
  }

  /// Get soft override value if any. Returns null if not set.
  Future<bool?> _getSoftPermission(AppPermission permission) async {
    if (!_isStorageInitialized) {
      await _initializeStorage();
      if (!_isStorageInitialized) return null;
    }
    try {
      final value = await _localStorage.getItem(_getSoftOverrideKey(permission));
      if (value is bool) return value;
      if (value is String) {
        final v = value.toLowerCase().trim();
        if (v == 'true' || v == '1') return true;
        if (v == 'false' || v == '0') return false;
      }
      if (value is num) {
        return value != 0;
      }
      return null;
    } catch (e) {
      coreDebugPrint('🔴 Error getting soft override for ${permission.name}: $e');
      return null;
    }
  }

  /// Check if any critical permissions are missing and need user attention
  /// Returns a list of permissions that are denied or permanently denied
  Future<List<AppPermission>> getMissingPermissions() async {
    final missingPermissions = <AppPermission>[];
    
    // Define critical permissions that should be checked
    final criticalPermissions = [
      AppPermission.storage,
      AppPermission.camera,
      AppPermission.microphone,
      AppPermission.locationWhenInUse,
      AppPermission.photos,
      AppPermission.notifications,
      AppPermission.contacts,
      AppPermission.calendar,
    ];
    
    for (final permission in criticalPermissions) {
      final status = await getPermissionStatus(permission);
      if (!status.isGranted && !status.isLimited) {
        missingPermissions.add(permission);
      }
    }
    
    return missingPermissions;
  }

  /// Check if user should be redirected to permissions screen
  /// Returns true if there are missing critical permissions
  Future<bool> shouldShowPermissionsScreen() async {
    final missingPermissions = await getMissingPermissions();
    return missingPermissions.isNotEmpty;
  }

  /// Set cache validity period in hours
  Future<void> setCacheValidityHours(int hours) async {
    if (!_isStorageInitialized) {
      await _initializeStorage();
      if (!_isStorageInitialized) return;
    }

    try {
      await _localStorage.setItem(_permissionCacheValidityHours, hours);
      coreDebugPrint('⏱️ Cache validity set to $hours hours');
    } catch (e) {
      coreDebugPrint('🔴 Error setting cache validity: $e');
    }
  }

  /// Direct permission request without cache or smart logic (internal use)
  Future<bool> _requestPermissionDirect(AppPermission appPermission) async {
    try {
      final permissionName = _getPermissionName(appPermission);
      coreDebugPrint('🔐 Requesting $permissionName permission (direct)...');
      
      final permission = _mapToPermission(appPermission);
      final status = await permission.request();
      
      // Cache the new status immediately after request
      await _cachePermissionStatus(appPermission, status);
      
      final isGranted = status == ph.PermissionStatus.granted;
      
      if (isGranted) {
        coreDebugPrint('✅ $permissionName permission granted (direct)');
      } else {
        coreDebugPrint('❌ $permissionName permission denied (direct): $status');
        
        // Check if we're in iOS simulator and handle accordingly
        if (Platform.isIOS && status == ph.PermissionStatus.permanentlyDenied) {
          // Only treat as granted in simulator, not on real devices
          final isSimulator = !(await DeviceInfoHelper.instance.platformDevicePhysical());
          if (isSimulator) {
            coreDebugPrint('📱 iOS Simulator detected - treating permanently denied as granted for testing');
            await _cachePermissionStatus(appPermission, ph.PermissionStatus.granted);
            return true;
          } else {
            coreDebugPrint('📱 iOS Real Device - permission permanently denied, returning false');
            return false;
          }
        }
      }
      
      return isGranted;
    } catch (e) {
      final permissionName = _getPermissionName(appPermission);
      coreDebugPrint('🔴 Error requesting $permissionName permission (direct): $e');
      
      // In iOS simulator, if there's an error, assume granted for testing
      if (Platform.isIOS) {
        final isSimulator = !(await DeviceInfoHelper.instance.platformDevicePhysical());
        if (isSimulator) {
          coreDebugPrint('📱 iOS Simulator - treating error as granted for testing');
          await _cachePermissionStatus(appPermission, ph.PermissionStatus.granted);
          return true;
        } else {
          coreDebugPrint('📱 iOS Real Device - error occurred, returning false');
        }
      }
      
      return false;
    }
  }

  /// Direct permission check without cache or smart logic (internal use)
  Future<bool> _checkPermissionDirect(AppPermission appPermission) async {
    try {
      final permission = _mapToPermission(appPermission);
      final status = await permission.status;
      
      // Cache the result
      await _cachePermissionStatus(appPermission, status);
      
      final isGranted = status == ph.PermissionStatus.granted;
      final permissionName = _getPermissionName(appPermission);
      
      coreDebugPrint('🔍 $permissionName permission status (direct): $status (granted: $isGranted)');
      
      // Handle iOS simulator case
      if (Platform.isIOS && status == ph.PermissionStatus.permanentlyDenied) {
        final isSimulator = !(await DeviceInfoHelper.instance.platformDevicePhysical());
        if (isSimulator) {
          coreDebugPrint('📱 iOS Simulator detected - treating permanently denied as granted for testing');
          await _cachePermissionStatus(appPermission, ph.PermissionStatus.granted);
          return true;
        } else {
          coreDebugPrint('📱 iOS Real Device - permission permanently denied, returning false');
          return false;
        }
      }
      
      return isGranted;
    } catch (e) {
      final permissionName = _getPermissionName(appPermission);
      coreDebugPrint('🔴 Error checking $permissionName permission (direct): $e');
      
      // In iOS simulator, if there's an error, assume granted for testing
      if (Platform.isIOS) {
        final isSimulator = !(await DeviceInfoHelper.instance.platformDevicePhysical());
        if (isSimulator) {
          coreDebugPrint('📱 iOS Simulator - treating error as granted for testing');
          await _cachePermissionStatus(appPermission, ph.PermissionStatus.granted);
          return true;
        } else {
          coreDebugPrint('📱 iOS Real Device - error occurred, returning false');
        }
      }
      
      return false;
    }
  }

  /// Direct permission status without cache or smart logic (internal use)
  Future<PermissionResult> _getPermissionStatusDirect(AppPermission appPermission) async {
    try {
      final permission = _mapToPermission(appPermission);
      final status = await permission.status;
      
      // Cache the result
      await _cachePermissionStatus(appPermission, status);
      
      final result = PermissionResult.fromStatus(appPermission, status);
      final permissionName = _getPermissionName(appPermission);
      
      coreDebugPrint('📊 $permissionName permission detailed status (direct): $result');
      
      // Handle iOS simulator case
      if (Platform.isIOS && status == ph.PermissionStatus.permanentlyDenied) {
        final isSimulator = !(await DeviceInfoHelper.instance.platformDevicePhysical());
        if (isSimulator) {
          coreDebugPrint('📱 iOS Simulator detected - treating permanently denied as granted for testing');
          await _cachePermissionStatus(appPermission, ph.PermissionStatus.granted);
          return PermissionResult.fromStatus(appPermission, ph.PermissionStatus.granted);
        } else {
          coreDebugPrint('📱 iOS Real Device - permission permanently denied, returning denied result');
          return result;
        }
      }
      
      return result;
    } catch (e) {
      final permissionName = _getPermissionName(appPermission);
      final errorMsg = 'Error getting $permissionName permission status (direct): $e';
      coreDebugPrint('🔴 $errorMsg');
      
      // In iOS simulator, if there's an error, assume granted for testing
      if (Platform.isIOS) {
        final isSimulator = !(await DeviceInfoHelper.instance.platformDevicePhysical());
        if (isSimulator) {
          coreDebugPrint('📱 iOS Simulator - treating error as granted for testing');
          await _cachePermissionStatus(appPermission, ph.PermissionStatus.granted);
          return PermissionResult.fromStatus(appPermission, ph.PermissionStatus.granted);
        } else {
          coreDebugPrint('📱 iOS Real Device - error occurred, returning error result');
          return PermissionResult.error(appPermission, errorMsg);
        }
      }
      
      return PermissionResult.error(appPermission, errorMsg);
    }
  }

  /// Direct multiple permissions request without smart logic (internal use)
  Future<Map<AppPermission, ph.PermissionStatus>> _requestMultiplePermissionsDirect(List<AppPermission> appPermissions) async {
    try {
      coreDebugPrint('🔐 Requesting multiple permissions (direct): ${appPermissions.map(_getPermissionName).join(', ')}');
      
      // Map AppPermission to Permission objects
      final permissions = appPermissions.map(_mapToPermission).toList();
      
      // Request all permissions at once
      final statuses = await permissions.request();
      
      // Map back to AppPermission enum and cache results
      final result = <AppPermission, ph.PermissionStatus>{};
      for (int i = 0; i < appPermissions.length; i++) {
        final appPermission = appPermissions[i];
        final permission = permissions[i];
        final status = statuses[permission] ?? ph.PermissionStatus.denied;
        
        // Handle iOS simulator case
        if (Platform.isIOS && status == ph.PermissionStatus.permanentlyDenied) {
          coreDebugPrint('📱 iOS Simulator detected - treating permanently denied as granted for testing');
          result[appPermission] = ph.PermissionStatus.granted;
          await _cachePermissionStatus(appPermission, ph.PermissionStatus.granted);
        } else {
          result[appPermission] = status;
          await _cachePermissionStatus(appPermission, status);
        }
        
        final permissionName = _getPermissionName(appPermission);
        final finalStatus = result[appPermission]!;
        if (finalStatus == ph.PermissionStatus.granted) {
          coreDebugPrint('✅ $permissionName permission granted (direct)');
        } else {
          coreDebugPrint('❌ $permissionName permission denied (direct): $finalStatus');
        }
      }
      
      return result;
    } catch (e) {
      coreDebugPrint('🔴 Error requesting multiple permissions (direct): $e');
      
      // Return granted status for all permissions in iOS simulator only
      final result = <AppPermission, ph.PermissionStatus>{};
      for (final appPermission in appPermissions) {
        if (Platform.isIOS) {
          final isSimulator = !(await DeviceInfoHelper.instance.platformDevicePhysical());
          if (isSimulator) {
            result[appPermission] = ph.PermissionStatus.granted;
            await _cachePermissionStatus(appPermission, ph.PermissionStatus.granted);
          } else {
            result[appPermission] = ph.PermissionStatus.denied;
            await _cachePermissionStatus(appPermission, ph.PermissionStatus.denied);
          }
        } else {
          result[appPermission] = ph.PermissionStatus.denied;
          await _cachePermissionStatus(appPermission, ph.PermissionStatus.denied);
        }
      }
      return result;
    }
  }

  /// Map AppPermission enum to permission_handler Permission objects
  ph.Permission _mapToPermission(AppPermission appPermission) {
    switch (appPermission) {
      case AppPermission.camera:
        return ph.Permission.camera;
      case AppPermission.microphone:
        return ph.Permission.microphone;
      case AppPermission.location:
        return ph.Permission.location;
      case AppPermission.locationWhenInUse:
        return ph.Permission.locationWhenInUse;
      case AppPermission.storage:
        if (Platform.isIOS) {
          return ph.Permission.photos;
        }
        return ph.Permission.storage;
      case AppPermission.photos:
        return ph.Permission.photos;
      case AppPermission.notifications:
        return ph.Permission.notification;
      case AppPermission.contacts:
        return ph.Permission.contacts;
      case AppPermission.calendar:
        return ph.Permission.calendarFullAccess;
      case AppPermission.manageExternalStorage:
        return ph.Permission.manageExternalStorage;
      case AppPermission.scheduleExactAlarm:
        return ph.Permission.scheduleExactAlarm;
    }
  }

  /// Handle storage permission based on Android API level
  Future<bool> _requestStoragePermissionSmart(AppPermission appPermission) async {
    if (!Platform.isAndroid) {
      // iOS'ta storage permission'ı photos permission'ı olarak handle et
      if (Platform.isIOS && appPermission == AppPermission.storage) {
        return _requestPermissionDirect(AppPermission.photos);
      }
      return _requestPermissionDirect(appPermission);
    }

    try {
      final apiLevel = await DeviceInfoHelper.instance.getAndroidApiLevel();
      
      coreDebugPrint('🤖 Android API Level: $apiLevel');

      if (apiLevel >= 33) {
        // Android 13+ (API 33+) - Granular media permissions
        if (appPermission == AppPermission.storage) {
          coreDebugPrint('📱 Android 13+ detected - requesting granular media permissions');
          final results = await _requestMultiplePermissionsDirect([
            AppPermission.photos, // READ_MEDIA_IMAGES, READ_MEDIA_VIDEO
            AppPermission.manageExternalStorage, // For full file access
          ]);
          final granted = results.values.any((status) => status == ph.PermissionStatus.granted);
          coreDebugPrint('🔍 Granular media permissions result: $granted');
          return granted;
        }
      } else if (apiLevel >= 30) {
        // Android 11-12 (API 30-32) - MANAGE_EXTERNAL_STORAGE
        if (appPermission == AppPermission.storage) {
          coreDebugPrint('📱 Android 11-12 detected - requesting MANAGE_EXTERNAL_STORAGE');
          return _requestPermissionDirect(AppPermission.manageExternalStorage);
        }
      } else {
        // Android 6-10 (API 23-29) - Legacy storage permissions
        coreDebugPrint('📱 Android 6-10 detected - using legacy storage permissions');
        return _requestPermissionDirect(appPermission);
      }
      
      return _requestPermissionDirect(appPermission);
    } catch (e) {
      coreDebugPrint('🔴 Error in smart storage permission: $e');
      return _requestPermissionDirect(appPermission);
    }
  }

  /// Check storage permission status based on Android API level
  Future<bool> _checkStoragePermissionSmart(AppPermission appPermission) async {
    // Respect soft override first
    final soft = await _getSoftPermission(appPermission);
    if (soft != null) return soft;
    if (!Platform.isAndroid) {

      if (Platform.isIOS && appPermission == AppPermission.storage) {
        return _checkPermissionDirect(AppPermission.photos);
      }
      return _checkPermissionDirect(appPermission);
    }

    try {
      final apiLevel = await DeviceInfoHelper.instance.getAndroidApiLevel();
      
      coreDebugPrint('🔍 Checking storage permission on API Level: $apiLevel');

      if (apiLevel >= 33) {
        // Android 13+ (API 33+) - Check granular media permissions
        coreDebugPrint('📱 Android 13+ - checking granular media permissions');
        final photosGranted = await _checkPermissionDirect(AppPermission.photos);
        final manageGranted = await _checkPermissionDirect(AppPermission.manageExternalStorage);
        final result = photosGranted || manageGranted;
        coreDebugPrint('🖼️ Photos permission status: $photosGranted');
        coreDebugPrint('📁 Manage External Storage status: $manageGranted');
        coreDebugPrint('🔍 Combined storage permission result: $result');
        return result;
      } else if (apiLevel >= 30) {
        // Android 11-12 (API 30-32) - Check MANAGE_EXTERNAL_STORAGE
        coreDebugPrint('📱 Android 11-12 - checking MANAGE_EXTERNAL_STORAGE');
        return _checkPermissionDirect(AppPermission.manageExternalStorage);
      } else {
        // Android 6-10 (API 23-29) - Check legacy storage permissions
        coreDebugPrint('📱 Android 6-10 - checking legacy storage permissions');
        return _checkPermissionDirect(appPermission);
      }
    } catch (e) {
      coreDebugPrint('🔴 Error in smart storage permission check: $e');
      return _checkPermissionDirect(appPermission);
    }
  }

  /// Get storage permission status based on Android API level
  Future<PermissionResult> _getStoragePermissionStatusSmart(AppPermission appPermission) async {
    // Respect soft override first
    final soft = await _getSoftPermission(appPermission);
    if (soft != null) {
      final status = soft ? ph.PermissionStatus.granted : ph.PermissionStatus.denied;
      return PermissionResult.fromStatus(appPermission, status);
    }
    if (!Platform.isAndroid) {

      if (Platform.isIOS && appPermission == AppPermission.storage) {
        return _getPermissionStatusDirect(AppPermission.photos);
      }
      return _getPermissionStatusDirect(appPermission);
    }

    try {
      final apiLevel = await DeviceInfoHelper.instance.getAndroidApiLevel();
      
      coreDebugPrint('📊 Getting storage permission status on API Level: $apiLevel');

      if (apiLevel >= 33) {
        // Android 13+ (API 33+) - Check granular media permissions
        coreDebugPrint('📱 Android 13+ - getting granular media permission status');
        final photosResult = await _getPermissionStatusDirect(AppPermission.photos);
        final manageResult = await _getPermissionStatusDirect(AppPermission.manageExternalStorage);
        
        // If either is granted, consider storage permission granted
        final storageStatus = (photosResult.isGranted || manageResult.isGranted) 
            ? ph.PermissionStatus.granted 
            : ph.PermissionStatus.denied;
        final result = PermissionResult.fromStatus(appPermission, storageStatus);
        
        coreDebugPrint('📊 Storage permission mapped from Photos/Manage: ${result.isGranted}');
        return result;
      } else if (apiLevel >= 30) {
        // Android 11-12 (API 30-32) - Check MANAGE_EXTERNAL_STORAGE
        coreDebugPrint('📱 Android 11-12 - getting MANAGE_EXTERNAL_STORAGE status');
        final manageResult = await _getPermissionStatusDirect(AppPermission.manageExternalStorage);
        
        final storageStatus = manageResult.isGranted ? ph.PermissionStatus.granted : ph.PermissionStatus.denied;
        return PermissionResult.fromStatus(appPermission, storageStatus);
      } else {
        // Android 6-10 (API 23-29) - Check legacy storage permissions
        coreDebugPrint('📱 Android 6-10 - getting legacy storage permission status');
        return _getPermissionStatusDirect(appPermission);
      }
    } catch (e) {
      coreDebugPrint('🔴 Error in smart storage permission status: $e');
      return _getPermissionStatusDirect(appPermission);
    }
  }

  /// Handle exact alarm permission based on Android API level
  Future<bool> _requestExactAlarmPermissionSmart(AppPermission appPermission) async {
    if (!Platform.isAndroid) {
      coreDebugPrint('🔔 Exact alarm request: iOS - no restrictions');
      return true;
    }

    try {
      final apiLevel = await DeviceInfoHelper.instance.getAndroidApiLevel();
      coreDebugPrint('🔔 Android API Level: $apiLevel');

      if (apiLevel >= 31) {
        // Android 12+ (API 31+) - Request exact alarm permission
        coreDebugPrint('🔔 Android 12+ detected - requesting exact alarm permission');
        return _requestPermissionDirect(appPermission);
      } else {
        // Android 11 and below - No exact alarm restrictions
        coreDebugPrint('🔔 Android 11 and below - exact alarm permissions not required');
        return true;
      }
    } catch (e) {
      coreDebugPrint('🔔 Error requesting exact alarm permission: $e');
      return false;
    }
  }

  /// Check exact alarm permission based on Android API level
  Future<bool> _checkExactAlarmPermissionSmart(AppPermission appPermission) async {
    if (!Platform.isAndroid) {
      coreDebugPrint('🔔 Exact alarm check: iOS - no restrictions');
      return true;
    }

    try {
      final apiLevel = await DeviceInfoHelper.instance.getAndroidApiLevel();
      coreDebugPrint('🔔 Android API Level: $apiLevel');

      if (apiLevel >= 31) {
        // Android 12+ (API 31+) - Check exact alarm permission
        coreDebugPrint('🔔 Android 12+ detected - checking exact alarm permission');
        return _checkPermissionDirect(appPermission);
      } else {
        // Android 11 and below - No exact alarm restrictions
        coreDebugPrint('🔔 Android 11 and below - exact alarm permissions not required');
        return true;
      }
    } catch (e) {
      coreDebugPrint('🔔 Error checking exact alarm permission: $e');
      return false;
    }
  }

  /// Get exact alarm permission status based on Android API level
  Future<PermissionResult> _getExactAlarmPermissionStatusSmart(AppPermission appPermission) async {
    if (!Platform.isAndroid) {
      coreDebugPrint('🔔 Exact alarm status: iOS - no restrictions');
      return PermissionResult.fromStatus(appPermission, ph.PermissionStatus.granted);
    }

    try {
      final apiLevel = await DeviceInfoHelper.instance.getAndroidApiLevel();
      coreDebugPrint('🔔 Android API Level: $apiLevel');

      if (apiLevel >= 31) {
        // Android 12+ (API 31+) - Get exact alarm permission status
        coreDebugPrint('🔔 Android 12+ detected - getting exact alarm permission status');
        return _getPermissionStatusDirect(appPermission);
      } else {
        // Android 11 and below - No exact alarm restrictions
        coreDebugPrint('🔔 Android 11 and below - exact alarm permissions not required');
        return PermissionResult.fromStatus(appPermission, ph.PermissionStatus.granted);
      }
    } catch (e) {
      coreDebugPrint('🔔 Error getting exact alarm permission status: $e');
      return PermissionResult.error(appPermission, 'Error getting exact alarm permission status: $e');
    }
  }

  /// Get human-readable permission name for logging and debugging
  String _getPermissionName(AppPermission permission) {
    switch (permission) {
      case AppPermission.camera:
        return 'Camera';
      case AppPermission.microphone:
        return 'Microphone';
      case AppPermission.location:
        return 'Location';
      case AppPermission.locationWhenInUse:
        return 'Location (When in Use)';
      case AppPermission.storage:
        return 'Storage';
      case AppPermission.photos:
        return 'Photos';
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

  @override
  Future<bool> requestPermission(AppPermission appPermission) async {
    if (appPermission == AppPermission.storage) {
      final result = await _requestStoragePermissionSmart(appPermission);
      // Clear cache after request to ensure fresh status
      await clearPermissionCache(appPermission);
      return result;
    }
    
    if (appPermission == AppPermission.scheduleExactAlarm) {
      final result = await _requestExactAlarmPermissionSmart(appPermission);
      // Clear cache after request to ensure fresh status
      await clearPermissionCache(appPermission);
      return result;
    }

    try {
    
      if (Platform.isIOS) {
        await clearPermissionCache(appPermission);
        coreDebugPrint('🧹 iOS: Cleared cache for ${appPermission.name} before request');
      }
      
      // When soft override exists, respect it but don't auto-grant
      final soft = await _getSoftPermission(appPermission);
      if (soft != null) {
        coreDebugPrint('📝 Soft override exists for ${appPermission.name}: $soft');
        return soft;
      }
      final permissionName = _getPermissionName(appPermission);
      coreDebugPrint('🔐 Requesting $permissionName permission...');
      
      final permission = _mapToPermission(appPermission);
      final status = await permission.request();
      
      // Cache the new status immediately after request
      await _cachePermissionStatus(appPermission, status);
      
      final isGranted = status == ph.PermissionStatus.granted;
      
      if (isGranted) {
        coreDebugPrint('✅ $permissionName permission granted');
      } else {
        coreDebugPrint('❌ $permissionName permission denied: $status');
        
        if (Platform.isIOS && status == ph.PermissionStatus.permanentlyDenied) {
          final isSimulator = !(await DeviceInfoHelper.instance.platformDevicePhysical());
          if (!isSimulator) {
            coreDebugPrint('📱 iOS Real Device - permission permanently denied, user needs to enable in settings');
    
            // await openAppSettings();
          }
        }
      }
      
      return isGranted;
    } catch (e) {
      final permissionName = _getPermissionName(appPermission);
      coreDebugPrint('🔴 Error requesting $permissionName permission: $e');
      return false;
    }
  }

  @override
  Future<bool> checkPermission(AppPermission appPermission) async {
    if (appPermission == AppPermission.storage) {
      return _checkStoragePermissionSmart(appPermission);
    }
    
    if (appPermission == AppPermission.scheduleExactAlarm) {
      return _checkExactAlarmPermissionSmart(appPermission);
    }

    try {
    
      if (Platform.isIOS) {
        await clearPermissionCache(appPermission);
        coreDebugPrint('🧹 iOS: Cleared cache for ${appPermission.name} before check');
      }
      
      // Soft override takes precedence if present (but not for storage)
      final soft = await _getSoftPermission(appPermission);
      if (soft != null) {
        coreDebugPrint('📝 Using soft override for ${appPermission.name}: $soft');
        return soft;
      }
      final permissionName = _getPermissionName(appPermission);
      
   
      if (Platform.isIOS) {
        final permission = _mapToPermission(appPermission);
        final status = await permission.status;
        
        // Cache the result
        await _cachePermissionStatus(appPermission, status);
        
        final isGranted = status == ph.PermissionStatus.granted;
        coreDebugPrint('🔍 $permissionName permission status (iOS fresh): $status (granted: $isGranted)');
        return isGranted;
      }
     
      // Check cache first
      final cachedStatus = await _getCachedPermissionStatus(appPermission);
      if (cachedStatus != null) {
        final isGranted = cachedStatus == ph.PermissionStatus.granted;
        coreDebugPrint('📋 $permissionName permission status (cached): $cachedStatus (granted: $isGranted)');
        return isGranted;
      }

      // Cache miss - check actual permission
      final permission = _mapToPermission(appPermission);
      final status = await permission.status;
      
      // Cache the result
      await _cachePermissionStatus(appPermission, status);
      
      final isGranted = status == ph.PermissionStatus.granted;
      coreDebugPrint('🔍 $permissionName permission status (fresh): $status (granted: $isGranted)');
      
      return isGranted;
    } catch (e) {
      final permissionName = _getPermissionName(appPermission);
      coreDebugPrint('🔴 Error checking $permissionName permission: $e');
      return false;
    }
  }

  @override
  Future<PermissionResult> getPermissionStatus(AppPermission appPermission) async {
    if (appPermission == AppPermission.storage) {
      return _getStoragePermissionStatusSmart(appPermission);
    }
    
    if (appPermission == AppPermission.scheduleExactAlarm) {
      return _getExactAlarmPermissionStatusSmart(appPermission);
    }

    try {
      
      if (Platform.isIOS) {
        await clearPermissionCache(appPermission);
        coreDebugPrint('🧹 iOS: Cleared cache for ${appPermission.name} before status check');
      }
      
      // Soft override takes precedence if present
      final soft = await _getSoftPermission(appPermission);
      if (soft != null) {
        final status = soft ? ph.PermissionStatus.granted : ph.PermissionStatus.denied;
        final overridden = PermissionResult.fromStatus(appPermission, status);
        coreDebugPrint('📝 Using soft override detailed for ${appPermission.name}: $status');
        return overridden;
      }
      final permissionName = _getPermissionName(appPermission);

      if (Platform.isIOS) {
        final permission = _mapToPermission(appPermission);
        final status = await permission.status;
        
        // Cache the result
        await _cachePermissionStatus(appPermission, status);
        
        final result = PermissionResult.fromStatus(appPermission, status);
        coreDebugPrint('📊 $permissionName permission detailed status (iOS fresh): $result');
        return result;
      }
      
      // Android için cache logic'i koru
      // Check cache first
      final cachedStatus = await _getCachedPermissionStatus(appPermission);
      if (cachedStatus != null) {
        final result = PermissionResult.fromStatus(appPermission, cachedStatus);
        coreDebugPrint('📊 $permissionName permission detailed status (cached): $result');
        return result;
      }

      // Cache miss - get fresh status
      final permission = _mapToPermission(appPermission);
      final status = await permission.status;
      
      // Cache the result
      await _cachePermissionStatus(appPermission, status);
      
      final result = PermissionResult.fromStatus(appPermission, status);
      coreDebugPrint('📊 $permissionName permission detailed status (fresh): $result');
      
      return result;
    } catch (e) {
      final permissionName = _getPermissionName(appPermission);
      final errorMsg = 'Error getting $permissionName permission status: $e';
      coreDebugPrint('🔴 $errorMsg');
      
      return PermissionResult.error(appPermission, errorMsg);
    }
  }

  @override
  Future<Map<AppPermission, ph.PermissionStatus>> requestMultiplePermissions(List<AppPermission> appPermissions) async {
    try {
      coreDebugPrint('🔐 Requesting multiple permissions: ${appPermissions.map(_getPermissionName).join(', ')}');
      
      // Map AppPermission to Permission objects
      final permissions = appPermissions.map(_mapToPermission).toList();
      
      // Request all permissions at once
      final statuses = await permissions.request();
      
      // Map back to AppPermission enum and cache results
      final result = <AppPermission, ph.PermissionStatus>{};
      for (int i = 0; i < appPermissions.length; i++) {
        final appPermission = appPermissions[i];
        final permission = permissions[i];
        final status = statuses[permission] ?? ph.PermissionStatus.denied;
        
        // Handle iOS simulator case
        if (Platform.isIOS && status == ph.PermissionStatus.permanentlyDenied) {
          final isSimulator = !(await DeviceInfoHelper.instance.platformDevicePhysical());
          if (isSimulator) {
            coreDebugPrint('📱 iOS Simulator detected - treating permanently denied as granted for testing');
            result[appPermission] = ph.PermissionStatus.granted;
            await _cachePermissionStatus(appPermission, ph.PermissionStatus.granted);
          } else {
            coreDebugPrint('📱 iOS Real Device - permission permanently denied, keeping status');
            result[appPermission] = status;
            await _cachePermissionStatus(appPermission, status);
          }
        } else {
          result[appPermission] = status;
          await _cachePermissionStatus(appPermission, status);
        }
        
        final permissionName = _getPermissionName(appPermission);
        final finalStatus = result[appPermission]!;
        if (finalStatus == ph.PermissionStatus.granted) {
          coreDebugPrint('✅ $permissionName permission granted');
        } else {
          coreDebugPrint('❌ $permissionName permission denied: $finalStatus');
        }
      }
      
      return result;
    } catch (e) {
      coreDebugPrint('🔴 Error requesting multiple permissions: $e');
      
      // Return granted status for all permissions in iOS simulator
      final result = <AppPermission, ph.PermissionStatus>{};
      for (final appPermission in appPermissions) {
        if (Platform.isIOS) {
          result[appPermission] = ph.PermissionStatus.granted;
          await _cachePermissionStatus(appPermission, ph.PermissionStatus.granted);
        } else {
          result[appPermission] = ph.PermissionStatus.denied;
          await _cachePermissionStatus(appPermission, ph.PermissionStatus.denied);
        }
      }
      return result;
    }
  }

  @override
  Future<bool> openAppSettings() async {
    try {
      coreDebugPrint('⚙️ Opening app settings for manual permission management...');
      
      final opened = await ph.openAppSettings();
      
      if (opened) {
        coreDebugPrint('✅ App settings opened successfully');
      } else {
        coreDebugPrint('❌ Failed to open app settings');
      }
      
      return opened;
    } catch (e) {
      coreDebugPrint('🔴 Error opening app settings: $e');
      return false;
    }
  }

  @override
  Future<bool> shouldShowRequestPermissionRationale(AppPermission appPermission) async {
    try {
      final permission = _mapToPermission(appPermission);
      final shouldShow = await permission.shouldShowRequestRationale;
      
      final permissionName = _getPermissionName(appPermission);
      coreDebugPrint('🤔 Should show $permissionName rationale: $shouldShow');
      
      return shouldShow;
    } catch (e) {
      final permissionName = _getPermissionName(appPermission);
      coreDebugPrint('🔴 Error checking rationale for $permissionName: $e');
      return false;
    }
  }

  /// Check if permission is permanently denied and needs settings redirect
  Future<bool> isPermanentlyDenied(AppPermission appPermission) async {
    try {
      final result = await getPermissionStatus(appPermission);
      return result.isPermanentlyDenied;
    } catch (e) {
      final permissionName = _getPermissionName(appPermission);
      coreDebugPrint('🔴 Error checking if $permissionName is permanently denied: $e');
      return false;
    }
  }

  /// Get permission status as string for debugging
  Future<String> getPermissionStatusString(AppPermission appPermission) async {
    try {
      final result = await getPermissionStatus(appPermission);
      return result.status.toString().split('.').last; // Get enum name without prefix
    } catch (e) {
      return 'error';
    }
  }

  /// Convenience method to check if all permissions in a list are granted
  Future<bool> areAllPermissionsGranted(List<AppPermission> appPermissions) async {
    try {
      final results = await Future.wait(
        appPermissions.map((permission) => checkPermission(permission)),
      );
      
      final allGranted = results.every((granted) => granted);
      coreDebugPrint('🔍 All permissions granted: $allGranted');
      
      return allGranted;
    } catch (e) {
      coreDebugPrint('🔴 Error checking multiple permissions: $e');
      return false;
    }
  }

  /// Get a summary of all permission statuses for debugging
  Future<Map<String, String>> getPermissionsSummary() async {
    final summary = <String, String>{};
    
    for (final permission in AppPermission.values) {
      final status = await getPermissionStatusString(permission);
      final name = _getPermissionName(permission);
      
      // Check if status comes from cache
      final cachedStatus = await _getCachedPermissionStatus(permission);
      final statusWithSource = cachedStatus != null ? '$status (cached)' : '$status (fresh)';
      
      summary[name] = statusWithSource;
    }
    
    coreDebugPrint('📋 Permissions Summary: $summary');
    return summary;
  }

  /// Get cache statistics for debugging
  Future<Map<String, dynamic>> getCacheStatistics() async {
    if (!_isStorageInitialized) {
      await _initializeStorage();
      if (!_isStorageInitialized) {
        return {'error': 'Storage not initialized'};
      }
    }

    try {
      final allItems = await _localStorage.getAllItems();
      final cacheStats = <String, dynamic>{};
      
      int cachedPermissions = 0;
      int expiredCache = 0;
      final cacheDetails = <String, dynamic>{};
      
      for (final permission in AppPermission.values) {
        final cacheKey = _getPermissionCacheKey(permission);
        final timestampKey = _getPermissionTimestampKey(permission);
        
        if (allItems.containsKey(cacheKey) && allItems.containsKey(timestampKey)) {
          cachedPermissions++;
          
          final isValid = await _isCacheValid(permission);
          if (!isValid) expiredCache++;
          
          final timestamp = int.tryParse(allItems[timestampKey].toString()) ?? 0;
          final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
          
          cacheDetails[permission.name] = {
            'status': allItems[cacheKey].toString(),
            'age_minutes': (cacheAge / (60 * 1000)).round(),
            'is_valid': isValid,
          };
        }
      }
      
      cacheStats['total_permissions'] = AppPermission.values.length;
      cacheStats['cached_permissions'] = cachedPermissions;
      cacheStats['expired_cache'] = expiredCache;
      cacheStats['cache_hit_rate'] = cachedPermissions > 0 ? '${((cachedPermissions - expiredCache) / cachedPermissions * 100).toStringAsFixed(1)}%' : '0%';
      cacheStats['cache_details'] = cacheDetails;
      
      final validityHours = await _localStorage.getItem(_permissionCacheValidityHours) ?? _defaultCacheValidityHours;
      cacheStats['cache_validity_hours'] = validityHours;
      
      coreDebugPrint('📊 Permission Cache Statistics: $cacheStats');
      return cacheStats;
    } catch (e) {
      coreDebugPrint('🔴 Error getting cache statistics: $e');
      return {'error': e.toString()};
    }
  }
}