import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'permission_handler_helper/permission_handler_helper.dart';
import 'permission_handler_helper/models/permission_models.dart';

/// 🔔 **OSMEA Local Notification Helper**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Comprehensive local notification management system for Flutter applications
/// with cross-platform support, advanced scheduling, and rich notification features.
/// Integrates with PermissionHandlerHelper for unified permission management.
///
/// ## Features
/// - **Cross-Platform Support**: iOS and Android native notifications
/// - **Instant Notifications**: Show immediate notifications with custom styling
/// - **Scheduled Notifications**: Schedule notifications for future dates/times
/// - **Repeating Notifications**: Daily, weekly, monthly recurring notifications
/// - **Rich Notifications**: Big text, custom sounds, action buttons, colors
/// - **Integrated Permission Management**: Uses PermissionHandlerHelper for unified permission handling
/// - **Automatic Permission Checks**: Optional permission validation before showing notifications
/// - **Notification Actions**: Interactive buttons with custom callbacks
/// - **Custom Sounds**: Platform-specific custom notification sounds
/// - **Timezone Support**: Accurate scheduling across timezones
/// - **Channel Management**: Android notification channels with priorities
/// - **Badge Management**: iOS badge count management
/// - **Background Handling**: Handle notifications when app is closed
/// - **Payload Support**: Pass custom data with notifications
/// - **Notification Cancellation**: Cancel individual or all notifications
/// - **Active Monitoring**: Track pending and active notifications
/// - **Error Handling**: Comprehensive error handling with debug logging
/// - **Permission Caching**: Leverages permission caching from PermissionHandlerHelper
/// - **Settings Integration**: Direct access to app settings for permission management
///
/// ## Supported Notification Types
/// - **Simple Notifications**: Basic title + body notifications
/// - **Big Text Notifications**: Expandable text content (Android)
/// - **Action Notifications**: Interactive buttons with callbacks
/// - **Custom Sound Notifications**: Platform-specific sound files
/// - **Scheduled Notifications**: One-time future notifications
/// - **Repeating Notifications**: Recurring notifications with intervals
/// - **Priority Notifications**: High importance notifications
/// - **Silent Notifications**: Background notifications without sound
///
/// ## Usage Examples
/// ```dart
/// import 'package:core/core.dart';
///
/// // Initialize notification service (call in main.dart)
/// await NotificationHelper.initialize(
///   androidIcon: '@mipmap/ic_launcher',
///   onNotificationTap: (NotificationResponse response) {
///     print('Notification tapped: ${response.payload}');
///     // Handle notification tap
///   },
/// );
///
/// // Request permissions using integrated PermissionHandlerHelper (required for iOS, recommended for Android 13+)
/// bool granted = await NotificationHelper.requestPermissions();
/// if (!granted) {
///   print('Notification permissions denied');
///   // Check if permission is permanently denied and redirect to settings
///   final status = await NotificationHelper.getNotificationPermissionStatus();
///   if (status.isPermanentlyDenied) {
///     await NotificationHelper.openAppSettings();
///   }
///   return;
/// }
///
/// // Show instant notification
/// await NotificationHelper.showNotification(
///   id: 1,
///   title: 'Welcome!',
///   body: 'Thanks for using our app',
///   payload: 'welcome_notification',
///   importance: NotificationImportance.high,
///   color: Colors.blue,
/// );
///
/// // Schedule future notification
/// await NotificationHelper.scheduleNotification(
///   id: 2,
///   title: 'Reminder',
///   body: 'Don\'t forget your appointment',
///   scheduledDate: DateTime.now().add(Duration(hours: 2)),
///   payload: 'appointment_reminder',
/// );
///
/// // Schedule repeating notification
/// await NotificationHelper.scheduleRepeatingNotification(
///   id: 3,
///   title: 'Daily Reminder',
///   body: 'Check your daily tasks',
///   repeatInterval: RepeatInterval.daily,
///   importance: NotificationImportance.defaultImportance,
/// );
///
/// // Show notification with custom sound
/// await NotificationHelper.showNotificationWithCustomSound(
///   id: 4,
///   title: 'Alert!',
///   body: 'Important message',
///   soundFileName: 'custom_alert', // custom_alert.mp3 (Android) / custom_alert.aiff (iOS)
/// );
///
/// // Show big text notification (Android)
/// await NotificationHelper.showBigTextNotification(
///   id: 5,
///   title: 'Long Message',
///   body: 'Short preview...',
///   bigText: 'This is a very long message that will be displayed when the notification is expanded...',
/// );
///
/// // Show notification with action buttons
/// await NotificationHelper.showNotificationWithActions(
///   id: 6,
///   title: 'Message Received',
///   body: 'You have a new message',
///   actions: [
///     NotificationAction(
///       id: 'reply',
///       title: 'Reply',
///       showsUserInterface: true,
///     ),
///     NotificationAction(
///       id: 'dismiss',
///       title: 'Dismiss',
///       cancelNotification: true,
///     ),
///   ],
/// );
///
/// // Cancel specific notification
/// await NotificationHelper.cancelNotification(1);
///
/// // Cancel all notifications
/// await NotificationHelper.cancelAllNotifications();
///
/// // Get pending notifications
/// List<PendingNotificationRequest> pending = await NotificationHelper.getPendingNotifications();
/// print('Pending notifications: ${pending.length}');
///
/// // Get active notifications (Android only)
/// List<ActiveNotification> active = await NotificationHelper.getActiveNotifications();
/// print('Active notifications: ${active.length}');
/// ```
class NotificationHelper {
  // ============================================================================
  // 🔧 SINGLETON PATTERN & INITIALIZATION
  // ============================================================================

  static final NotificationHelper _instance = NotificationHelper._internal();
  factory NotificationHelper() => _instance;
  NotificationHelper._internal();

  /// Permission handler helper instance for unified permission management
  static final PermissionHandlerHelper _permissionHelper = PermissionHandlerHelper.instance;

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;
  static Function(NotificationResponse)? _onNotificationTap;

  // ============================================================================
  // 🚀 INITIALIZATION METHODS
  // ============================================================================

  /// 🚀 **Initialize Notification Service**
  ///
  /// Initializes the local notification service with platform-specific settings.
  /// Must be called before using any notification functionality, typically in main.dart.
  ///
  /// **Parameters:**
  /// - `androidIcon`: Android notification icon (default: '@mipmap/ic_launcher')
  /// - `onNotificationTap`: Callback when notification is tapped (foreground)
  ///
  /// **Returns:** True if initialization successful, false otherwise
  ///
  /// **Platform Notes:**
  /// - iOS: Requests basic permissions (alert, badge, sound)
  /// - Android: Sets up notification channels and icons
  /// - Timezone: Initializes timezone data for scheduling
  ///
  /// Example: 
  /// ```dart
  /// bool success = await NotificationHelper.initialize(
  ///   androidIcon: '@drawable/notification_icon',
  ///   onNotificationTap: (response) => handleNotificationTap(response),
  /// );
  /// ```
  static Future<bool> initialize({
    String androidIcon = '@mipmap/ic_launcher',
    Function(NotificationResponse)? onNotificationTap,
  }) async {
    if (_isInitialized) return true;

    try {
      // Initialize timezone
      tz.initializeTimeZones();
      
      _onNotificationTap = onNotificationTap;

      // Android initialization
      final AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings(androidIcon);

      // iOS initialization
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        requestCriticalPermission: false,
        requestProvisionalPermission: false,
      );

      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      final bool? result = await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
        // Note: Background handler removed as it needs to be a top-level function
        // Background notifications can be handled through the main app lifecycle
      );

      _isInitialized = result ?? false;
      return _isInitialized;
    } catch (e) {
      debugPrint('NotificationHelper: Initialize error: $e');
      return false;
    }
  }

  /// 🔐 **Request Notification Permissions**
  ///
  /// Requests notification permissions from the user on both platforms using
  /// the integrated permission handler helper. Required for iOS notifications 
  /// and recommended for Android 13+.
  ///
  /// **Returns:** True if permissions granted, false if denied
  ///
  /// **Platform Behavior:**
  /// - iOS: Shows system permission dialog for alert, badge, sound
  /// - Android: Requests notification permission (API 33+)
  /// - Older Android: Returns true (permissions granted by default)
  ///
  /// **Best Practice:** Call this after initialize() and before showing notifications
  ///
  /// Example: 
  /// ```dart
  /// bool granted = await NotificationHelper.requestPermissions();
  /// if (!granted) {
  ///   // Show explanation or disable notifications
  ///   showPermissionRationale();
  /// }
  /// ```
  static Future<bool> requestPermissions() async {
    try {
      // Use the permission handler helper to request notification permissions
      final granted = await _permissionHelper.requestPermission(AppPermission.notifications);
      
      if (granted) {
        debugPrint('✅ Notification permissions granted via PermissionHandlerHelper');
        return true;
      } else {
        debugPrint('❌ Notification permissions denied via PermissionHandlerHelper');
        
        // Fallback to direct flutter_local_notifications permission request
        // for cases where permission_handler might not cover all scenarios
        if (Platform.isAndroid) {
          final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
              _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();

          if (androidImplementation != null) {
            final bool? fallbackGranted = await androidImplementation.requestNotificationsPermission();
            debugPrint('🔄 Fallback Android permission result: ${fallbackGranted ?? false}');
            return fallbackGranted ?? false;
          }
        } else if (Platform.isIOS) {
          final IOSFlutterLocalNotificationsPlugin? iosImplementation =
              _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>();

          if (iosImplementation != null) {
            final bool? fallbackGranted = await iosImplementation.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
              critical: false,
              provisional: false,
            );
            debugPrint('🔄 Fallback iOS permission result: ${fallbackGranted ?? false}');
            return fallbackGranted ?? false;
          }
        }
        
        return false;
      }
    } catch (e) {
      debugPrint('🔴 Error requesting notification permissions: $e');
      
      // Fallback to direct permission request in case of error
      if (Platform.isAndroid) {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

        if (androidImplementation != null) {
          final bool? fallbackGranted = await androidImplementation.requestNotificationsPermission();
          return fallbackGranted ?? false;
        }
      } else if (Platform.isIOS) {
        final IOSFlutterLocalNotificationsPlugin? iosImplementation =
            _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>();

        if (iosImplementation != null) {
          final bool? fallbackGranted = await iosImplementation.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            critical: false,
            provisional: false,
          );
          return fallbackGranted ?? false;
        }
      }
      
      return true; // Default to true for older Android versions
    }
  }

  /// 🔍 **Check Notification Permissions**
  ///
  /// Checks if notification permissions are currently granted using the
  /// integrated permission handler helper.
  ///
  /// **Returns:** True if permissions are granted, false otherwise
  ///
  /// **Use Cases:**
  /// - Check permissions before showing notifications
  /// - Determine if permission request is needed
  /// - Validate permission status in settings
  ///
  /// Example: 
  /// ```dart
  /// bool hasPermission = await NotificationHelper.checkNotificationPermissions();
  /// if (!hasPermission) {
  ///   // Request permissions or show alternative UI
  ///   await NotificationHelper.requestPermissions();
  /// }
  /// ```
  static Future<bool> checkNotificationPermissions() async {
    try {
      // Use the permission handler helper to check notification permissions
      final hasPermission = await _permissionHelper.checkPermission(AppPermission.notifications);
      
      debugPrint('🔍 Notification permission check result: $hasPermission');
      return hasPermission;
    } catch (e) {
      debugPrint('🔴 Error checking notification permissions: $e');
      return false;
    }
  }

  /// 📊 **Get Detailed Notification Permission Status**
  ///
  /// Gets detailed information about notification permission status using
  /// the integrated permission handler helper.
  ///
  /// **Returns:** PermissionResult with detailed status information
  ///
  /// **Use Cases:**
  /// - Check if permission is permanently denied
  /// - Determine if settings redirect is needed
  /// - Get comprehensive permission information
  ///
  /// Example: 
  /// ```dart
  /// final result = await NotificationHelper.getNotificationPermissionStatus();
  /// if (result.isPermanentlyDenied) {
  ///   // Show dialog to redirect to settings
  ///   await NotificationHelper.openAppSettings();
  /// }
  /// ```
  static Future<PermissionResult> getNotificationPermissionStatus() async {
    try {
      // Use the permission handler helper to get detailed permission status
      final result = await _permissionHelper.getPermissionStatus(AppPermission.notifications);
      
      debugPrint('📊 Notification permission status: ${result.statusDescription}');
      return result;
    } catch (e) {
      debugPrint('🔴 Error getting notification permission status: $e');
      return PermissionResult.error(AppPermission.notifications, 'Error getting notification permission status: $e');
    }
  }

  /// ⚙️ **Open App Settings**
  ///
  /// Opens the app settings page for manual permission management.
  /// Useful when permissions are permanently denied.
  ///
  /// **Returns:** True if settings page was opened successfully, false otherwise
  ///
  /// **Use Cases:**
  /// - Redirect users when permissions are permanently denied
  /// - Allow manual permission management
  /// - Provide alternative to permission request dialogs
  ///
  /// Example: 
  /// ```dart
  /// final status = await NotificationHelper.getNotificationPermissionStatus();
  /// if (status.isPermanentlyDenied) {
  ///   final opened = await NotificationHelper.openAppSettings();
  ///   if (opened) {
  ///     // Settings opened successfully
  ///   }
  /// }
  /// ```
  static Future<bool> openAppSettings() async {
    try {
      // Use the permission handler helper to open app settings
      final opened = await _permissionHelper.openAppSettings();
      
      debugPrint('⚙️ App settings opened: $opened');
      return opened;
    } catch (e) {
      debugPrint('🔴 Error opening app settings: $e');
      return false;
    }
  }

  // ============================================================================
  // 📱 INSTANT NOTIFICATION METHODS
  // ============================================================================

  /// 📱 **Show Instant Notification**
  ///
  /// Displays an immediate notification with customizable appearance and behavior.
  /// Supports rich formatting, custom colors, sounds, and importance levels.
  ///
  /// **Parameters:**
  /// - `id`: Unique notification identifier (for cancellation/updates)
  /// - `title`: Notification title (bold text)
  /// - `body`: Notification body text
  /// - `payload`: Custom data passed to tap callbacks (optional)
  /// - `importance`: Android importance level (affects sound/vibration)
  /// - `priority`: Android priority level (affects display order)
  /// - `channelId`: Android notification channel ID
  /// - `channelName`: Android notification channel name
  /// - `channelDescription`: Android notification channel description
  /// - `icon`: Custom Android icon (optional)
  /// - `color`: Android notification color accent
  /// - `playSound`: Enable/disable notification sound
  /// - `enableVibration`: Enable/disable vibration
  /// - `soundFileName`: Custom sound file name (without extension)
  ///
  /// **Returns:** Void (async operation)
  ///
  /// Example: 
  /// ```dart
  /// await NotificationHelper.showNotification(
  ///   id: 1,
  ///   title: 'Order Complete',
  ///   body: 'Your order #12345 has been delivered',
  ///   payload: 'order_12345',
  ///   importance: NotificationImportance.high,
  ///   color: Colors.green,
  /// );
  /// ```
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationImportance importance = NotificationImportance.defaultImportance,
    NotificationPriority priority = NotificationPriority.defaultPriority,
    String channelId = 'default_channel',
    String channelName = 'Default Notifications',
    String channelDescription = 'Default notification channel',
    String? icon,
    Color? color,
    bool playSound = true,
    bool enableVibration = true,
    String? soundFileName,
    bool checkPermissions = true,
  }) async {
    if (!_isInitialized) {
      debugPrint('NotificationHelper: Not initialized');
      return;
    }

    // Check notification permissions if requested
    if (checkPermissions) {
      final hasPermission = await checkNotificationPermissions();
      if (!hasPermission) {
        debugPrint('🔔 Notification permission not granted, skipping notification');
        return;
      }
    }

    try {
      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: _mapImportance(importance),
        priority: _mapPriority(priority),
        icon: icon,
        color: color,
        playSound: playSound,
        enableVibration: enableVibration,
        sound: soundFileName != null ? RawResourceAndroidNotificationSound(soundFileName) : null,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
    } catch (e) {
      debugPrint('NotificationHelper: Show notification error: $e');
    }
  }

  // ============================================================================
  // ⏰ SCHEDULED NOTIFICATION METHODS
  // ============================================================================

  /// ⏰ **Schedule Future Notification**
  ///
  /// Schedules a notification to be shown at a specific date and time.
  /// Uses timezone-aware scheduling for accurate delivery across time zones.
  ///
  /// **Parameters:**
  /// - `id`: Unique notification identifier
  /// - `title`: Notification title
  /// - `body`: Notification body text
  /// - `scheduledDate`: DateTime when notification should be shown
  /// - `payload`: Custom data for tap callbacks (optional)
  /// - `importance`: Android importance level
  /// - `priority`: Android priority level
  /// - `channelId`: Android notification channel ID
  /// - `channelName`: Android notification channel name
  /// - `channelDescription`: Android notification channel description
  /// - `icon`: Custom Android icon (optional)
  /// - `color`: Android notification color
  /// - `playSound`: Enable notification sound
  /// - `enableVibration`: Enable vibration
  ///
  /// **Returns:** Void (async operation)
  ///
  /// **Note:** Scheduled notifications persist across app restarts and device reboots
  ///
  /// Example: 
  /// ```dart
  /// // Schedule notification for 2 hours from now
  /// await NotificationHelper.scheduleNotification(
  ///   id: 100,
  ///   title: 'Meeting Reminder',
  ///   body: 'Team meeting starts in 15 minutes',
  ///   scheduledDate: DateTime.now().add(Duration(hours: 2)),
  ///   payload: 'meeting_reminder',
  /// );
  /// ```
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    NotificationImportance importance = NotificationImportance.defaultImportance,
    NotificationPriority priority = NotificationPriority.defaultPriority,
    String channelId = 'scheduled_channel',
    String channelName = 'Scheduled Notifications',
    String channelDescription = 'Scheduled notification channel',
    String? icon,
    Color? color,
    bool playSound = true,
    bool enableVibration = true,
    bool checkPermissions = true,
  }) async {
    if (!_isInitialized) {
      debugPrint('NotificationHelper: Not initialized');
      return;
    }

    // Check notification permissions if requested
    if (checkPermissions) {
      final hasPermission = await checkNotificationPermissions();
      if (!hasPermission) {
        debugPrint('🔔 Notification permission not granted, skipping scheduled notification');
        return;
      }
    }

    try {
      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: _mapImportance(importance),
        priority: _mapPriority(priority),
        icon: icon,
        color: color,
        playSound: playSound,
        enableVibration: enableVibration,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint('NotificationHelper: Schedule notification error: $e');
    }
  }

  /// 🔁 **Schedule Repeating Notification**
  ///
  /// Creates a notification that repeats at regular intervals (daily, weekly, etc.).
  /// Perfect for reminders, daily tasks, or recurring alerts.
  ///
  /// **Parameters:**
  /// - `id`: Unique notification identifier
  /// - `title`: Notification title
  /// - `body`: Notification body text
  /// - `repeatInterval`: How often to repeat (daily, weekly, everyMinute, hourly)
  /// - `payload`: Custom data for tap callbacks (optional)
  /// - `importance`: Android importance level
  /// - `priority`: Android priority level
  /// - `channelId`: Android notification channel ID
  /// - `channelName`: Android notification channel name
  /// - `channelDescription`: Android notification channel description
  /// - `icon`: Custom Android icon (optional)
  /// - `color`: Android notification color
  /// - `playSound`: Enable notification sound
  /// - `enableVibration`: Enable vibration
  ///
  /// **Returns:** Void (async operation)
  ///
  /// **Available Intervals:**
  /// - `RepeatInterval.everyMinute`: Every minute (testing only)
  /// - `RepeatInterval.hourly`: Every hour
  /// - `RepeatInterval.daily`: Every day at the same time
  /// - `RepeatInterval.weekly`: Every week on the same day
  ///
  /// Example: 
  /// ```dart
  /// // Daily reminder at current time
  /// await NotificationHelper.scheduleRepeatingNotification(
  ///   id: 200,
  ///   title: 'Daily Reminder',
  ///   body: 'Don\'t forget to check your tasks!',
  ///   repeatInterval: RepeatInterval.daily,
  ///   importance: NotificationImportance.defaultImportance,
  /// );
  /// ```
  static Future<void> scheduleRepeatingNotification({
    required int id,
    required String title,
    required String body,
    required RepeatInterval repeatInterval,
    String? payload,
    NotificationImportance importance = NotificationImportance.defaultImportance,
    NotificationPriority priority = NotificationPriority.defaultPriority,
    String channelId = 'repeating_channel',
    String channelName = 'Repeating Notifications',
    String channelDescription = 'Repeating notification channel',
    String? icon,
    Color? color,
    bool playSound = true,
    bool enableVibration = true,
    bool checkPermissions = true,
  }) async {
    if (!_isInitialized) {
      debugPrint('NotificationHelper: Not initialized');
      return;
    }

    // Check notification permissions if requested
    if (checkPermissions) {
      final hasPermission = await checkNotificationPermissions();
      if (!hasPermission) {
        debugPrint('🔔 Notification permission not granted, skipping repeating notification');
        return;
      }
    }

    try {
      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: _mapImportance(importance),
        priority: _mapPriority(priority),
        icon: icon,
        color: color,
        playSound: playSound,
        enableVibration: enableVibration,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _flutterLocalNotificationsPlugin.periodicallyShow(
        id,
        title,
        body,
        repeatInterval,
        notificationDetails,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('NotificationHelper: Schedule repeating notification error: $e');
    }
  }

  // ============================================================================
  // 🎵 RICH NOTIFICATION METHODS
  // ============================================================================

  /// 🎵 **Show Notification with Custom Sound**
  ///
  /// Displays a notification with a custom sound file for enhanced user experience.
  /// Useful for different alert types (messages, calls, alerts).
  ///
  /// **Parameters:**
  /// - `id`: Unique notification identifier
  /// - `title`: Notification title
  /// - `body`: Notification body text
  /// - `soundFileName`: Sound file name without extension
  /// - `payload`: Custom data for tap callbacks (optional)
  /// - `importance`: Android importance level
  /// - `channelId`: Android notification channel ID
  /// - `channelName`: Android notification channel name
  ///
  /// **Returns:** Void (async operation)
  ///
  /// **Sound File Requirements:**
  /// - Android: Place .mp3 files in `android/app/src/main/res/raw/`
  /// - iOS: Place .aiff files in `ios/Runner/` and add to Xcode project
  /// - File naming: Use same name for both platforms (e.g., 'alert' → alert.mp3 & alert.aiff)
  ///
  /// Example: 
  /// ```dart
  /// await NotificationHelper.showNotificationWithCustomSound(
  ///   id: 300,
  ///   title: 'New Message',
  ///   body: 'You have received a message from John',
  ///   soundFileName: 'message_sound',
  ///   importance: NotificationImportance.high,
  /// );
  /// ```
  static Future<void> showNotificationWithCustomSound({
    required int id,
    required String title,
    required String body,
    required String soundFileName,
    String? payload,
    NotificationImportance importance = NotificationImportance.defaultImportance,
    String channelId = 'custom_sound_channel',
    String channelName = 'Custom Sound Notifications',
    bool checkPermissions = true,
  }) async {
    if (!_isInitialized) return;

    // Check notification permissions if requested
    if (checkPermissions) {
      final hasPermission = await checkNotificationPermissions();
      if (!hasPermission) {
        debugPrint('🔔 Notification permission not granted, skipping custom sound notification');
        return;
      }
    }

    try {
      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        importance: _mapImportance(importance),
        sound: RawResourceAndroidNotificationSound(soundFileName),
        playSound: true,
      );

      final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        sound: '$soundFileName.aiff',
        presentSound: true,
      );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
    } catch (e) {
      debugPrint('NotificationHelper: Custom sound notification error: $e');
    }
  }

  /// 📄 **Show Big Text Notification (Android)**
  ///
  /// Displays an expandable notification with large text content on Android.
  /// Perfect for long messages, articles, or detailed information.
  ///
  /// **Parameters:**
  /// - `id`: Unique notification identifier
  /// - `title`: Notification title
  /// - `body`: Short preview text (shown when collapsed)
  /// - `bigText`: Full expanded text content
  /// - `payload`: Custom data for tap callbacks (optional)
  /// - `channelId`: Android notification channel ID
  /// - `channelName`: Android notification channel name
  ///
  /// **Returns:** Void (async operation)
  ///
  /// **Platform Behavior:**
  /// - Android: Shows expandable notification with big text style
  /// - iOS: Shows regular notification (iOS doesn't support big text)
  ///
  /// Example: 
  /// ```dart
  /// await NotificationHelper.showBigTextNotification(
  ///   id: 400,
  ///   title: 'Article Update',
  ///   body: 'New article published...',
  ///   bigText: 'Complete article content here with detailed information '
  ///            'that users can read by expanding the notification.',
  /// );
  /// ```
  static Future<void> showBigTextNotification({
    required int id,
    required String title,
    required String body,
    required String bigText,
    String? payload,
    String channelId = 'big_text_channel',
    String channelName = 'Big Text Notifications',
    bool checkPermissions = true,
  }) async {
    if (!_isInitialized) return;

    // Check notification permissions if requested
    if (checkPermissions) {
      final hasPermission = await checkNotificationPermissions();
      if (!hasPermission) {
        debugPrint('🔔 Notification permission not granted, skipping big text notification');
        return;
      }
    }

    try {
      final BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        bigText,
        contentTitle: title,
        summaryText: 'Summary Text',
      );

      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        styleInformation: bigTextStyleInformation,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
    } catch (e) {
      debugPrint('NotificationHelper: Big text notification error: $e');
    }
  }

  /// 🎯 **Show Notification with Action Buttons**
  ///
  /// Displays an interactive notification with custom action buttons.
  /// Users can respond directly from the notification without opening the app.
  ///
  /// **Parameters:**
  /// - `id`: Unique notification identifier
  /// - `title`: Notification title
  /// - `body`: Notification body text
  /// - `actions`: List of action buttons to display
  /// - `payload`: Custom data for tap callbacks (optional)
  /// - `channelId`: Android notification channel ID
  /// - `channelName`: Android notification channel name
  ///
  /// **Returns:** Void (async operation)
  ///
  /// **Action Button Properties:**
  /// - `id`: Unique action identifier (passed to callback)
  /// - `title`: Button text displayed to user
  /// - `cancelNotification`: Whether to dismiss notification when tapped
  /// - `showsUserInterface`: Whether to bring app to foreground
  ///
  /// **Platform Support:**
  /// - Android: Full support for action buttons
  /// - iOS: Limited support, requires category setup
  ///
  /// Example: 
  /// ```dart
  /// await NotificationHelper.showNotificationWithActions(
  ///   id: 500,
  ///   title: 'New Message',
  ///   body: 'John sent you a message',
  ///   actions: [
  ///     NotificationAction(
  ///       id: 'reply',
  ///       title: 'Reply',
  ///       showsUserInterface: true,
  ///     ),
  ///     NotificationAction(
  ///       id: 'mark_read',
  ///       title: 'Mark as Read',
  ///       cancelNotification: true,
  ///     ),
  ///   ],
  /// );
  /// ```
  static Future<void> showNotificationWithActions({
    required int id,
    required String title,
    required String body,
    required List<NotificationAction> actions,
    String? payload,
    String channelId = 'action_channel',
    String channelName = 'Action Notifications',
    bool checkPermissions = true,
  }) async {
    if (!_isInitialized) return;

    // Check notification permissions if requested
    if (checkPermissions) {
      final hasPermission = await checkNotificationPermissions();
      if (!hasPermission) {
        debugPrint('🔔 Notification permission not granted, skipping action notification');
        return;
      }
    }

    try {
      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        actions: actions.map((action) => AndroidNotificationAction(
          action.id,
          action.title,
          cancelNotification: action.cancelNotification,
          showsUserInterface: action.showsUserInterface,
        )).toList(),
      );

      final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        categoryIdentifier: 'actionCategory',
      );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
    } catch (e) {
      debugPrint('NotificationHelper: Action notification error: $e');
    }
  }

  // ============================================================================
  // 🗑️ NOTIFICATION MANAGEMENT METHODS
  // ============================================================================

  /// 🗑️ **Cancel Notification by ID**
  ///
  /// Cancels a specific notification by its unique identifier.
  /// Removes both pending scheduled notifications and currently displayed ones.
  ///
  /// **Parameters:**
  /// - `id`: Notification ID to cancel
  ///
  /// **Returns:** Void (async operation)
  ///
  /// **Behavior:**
  /// - Cancels scheduled notifications before they're shown
  /// - Removes displayed notifications from notification tray
  /// - Safe to call with non-existent IDs (no error thrown)
  ///
  /// Example: 
  /// ```dart
  /// // Cancel a specific notification
  /// await NotificationHelper.cancelNotification(100);
  /// ```
  static Future<void> cancelNotification(int id) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(id);
    } catch (e) {
      debugPrint('NotificationHelper: Cancel notification error: $e');
    }
  }

  /// 🧹 **Cancel All Notifications**
  ///
  /// Cancels all notifications (both pending and displayed).
  /// Useful for app logout, settings changes, or clearing all alerts.
  ///
  /// **Returns:** Void (async operation)
  ///
  /// **Behavior:**
  /// - Cancels all scheduled future notifications
  /// - Removes all displayed notifications from tray
  /// - Clears all repeating notifications
  /// - Atomic operation (all or nothing)
  ///
  /// Example: 
  /// ```dart
  /// // Clear all notifications (e.g., on user logout)
  /// await NotificationHelper.cancelAllNotifications();
  /// ```
  static Future<void> cancelAllNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
    } catch (e) {
      debugPrint('NotificationHelper: Cancel all notifications error: $e');
    }
  }

  // ============================================================================
  // 📊 NOTIFICATION MONITORING METHODS
  // ============================================================================

  /// 📊 **Get Pending Notifications**
  ///
  /// Retrieves a list of all scheduled notifications that haven't been delivered yet.
  /// Useful for displaying upcoming reminders or managing scheduled content.
  ///
  /// **Returns:** List of PendingNotificationRequest objects
  ///
  /// **PendingNotificationRequest Properties:**
  /// - `id`: Notification identifier
  /// - `title`: Notification title
  /// - `body`: Notification body
  /// - `payload`: Custom payload data
  ///
  /// **Use Cases:**
  /// - Show user their upcoming reminders
  /// - Debug scheduling issues
  /// - Prevent duplicate scheduling
  /// - Manage notification queue
  ///
  /// Example: 
  /// ```dart
  /// List<PendingNotificationRequest> pending = await NotificationHelper.getPendingNotifications();
  /// print('You have ${pending.length} upcoming notifications');
  /// for (var notification in pending) {
  ///   print('ID: ${notification.id}, Title: ${notification.title}');
  /// }
  /// ```
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    } catch (e) {
      debugPrint('NotificationHelper: Get pending notifications error: $e');
      return [];
    }
  }

  /// 📱 **Get Active Notifications (Android Only)**
  ///
  /// Retrieves a list of notifications currently displayed in the notification tray.
  /// Only available on Android platform.
  ///
  /// **Returns:** List of ActiveNotification objects (Android) or empty list (iOS)
  ///
  /// **ActiveNotification Properties:**
  /// - `id`: Notification identifier
  /// - `channelId`: Android notification channel
  /// - `tag`: Optional notification tag
  ///
  /// **Platform Support:**
  /// - Android: Returns actual active notifications
  /// - iOS: Always returns empty list (not supported)
  ///
  /// **Use Cases:**
  /// - Check if specific notification is still visible
  /// - Monitor notification tray status
  /// - Implement custom notification management
  /// - Debug notification display issues
  ///
  /// Example: 
  /// ```dart
  /// if (Platform.isAndroid) {
  ///   List<ActiveNotification> active = await NotificationHelper.getActiveNotifications();
  ///   print('Currently showing ${active.length} notifications');
  ///   for (var notification in active) {
  ///     print('Active ID: ${notification.id}, Channel: ${notification.channelId}');
  ///   }
  /// }
  /// ```
  static Future<List<ActiveNotification>> getActiveNotifications() async {
    try {
      if (Platform.isAndroid) {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        
        if (androidImplementation != null) {
          return await androidImplementation.getActiveNotifications();
        }
      }
      return [];
    } catch (e) {
      debugPrint('NotificationHelper: Get active notifications error: $e');
      return [];
    }
  }

  // ============================================================================
  // 🔧 PRIVATE HELPER METHODS
  // ============================================================================

  /// 🔧 **Private Importance Mapper**
  ///
  /// Internal method to convert custom NotificationImportance enum to 
  /// flutter_local_notifications Importance enum.
  static Importance _mapImportance(NotificationImportance importance) {
    switch (importance) {
      case NotificationImportance.min:
        return Importance.min;
      case NotificationImportance.low:
        return Importance.low;
      case NotificationImportance.defaultImportance:
        return Importance.defaultImportance;
      case NotificationImportance.high:
        return Importance.high;
      case NotificationImportance.max:
        return Importance.max;
    }
  }

  /// 🔧 **Private Priority Mapper**
  ///
  /// Internal method to convert custom NotificationPriority enum to 
  /// flutter_local_notifications Priority enum.
  static Priority _mapPriority(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.min:
        return Priority.min;
      case NotificationPriority.low:
        return Priority.low;
      case NotificationPriority.defaultPriority:
        return Priority.defaultPriority;
      case NotificationPriority.high:
        return Priority.high;
      case NotificationPriority.max:
        return Priority.max;
    }
  }
}

// ============================================================================
// 📊 NOTIFICATION CONFIGURATION ENUMS
// ============================================================================

/// 📊 **Notification Importance Levels**
///
/// Defines the importance level of notifications on Android.
/// Controls sound, vibration, and display behavior.
///
/// **Levels:**
/// - `min`: Minimal importance, silent notifications
/// - `low`: Low importance, no sound or vibration
/// - `defaultImportance`: Standard importance with sound
/// - `high`: High importance, sound + vibration + heads-up
/// - `max`: Maximum importance, critical alerts
enum NotificationImportance {
  min,
  low,
  defaultImportance,
  high,
  max,
}

/// 📊 **Notification Priority Levels**
///
/// Defines the display priority of notifications in the notification tray.
/// Controls ordering and visibility behavior.
///
/// **Levels:**
/// - `min`: Lowest priority, hidden by default
/// - `low`: Low priority, shown at bottom
/// - `defaultPriority`: Standard priority
/// - `high`: High priority, shown at top
/// - `max`: Maximum priority, always visible
enum NotificationPriority {
  min,
  low,
  defaultPriority,
  high,
  max,
}

// ============================================================================
// 🎯 NOTIFICATION ACTION MODEL
// ============================================================================

/// 🎯 **Notification Action Button Model**
///
/// Represents an interactive button that can be added to notifications.
/// Allows users to take actions directly from the notification.
///
/// **Properties:**
/// - `id`: Unique identifier for the action (passed to callbacks)
/// - `title`: Text displayed on the button
/// - `cancelNotification`: Whether to dismiss notification when tapped
/// - `showsUserInterface`: Whether to bring app to foreground when tapped
class NotificationAction {
  final String id;
  final String title;
  final bool cancelNotification;
  final bool showsUserInterface;

  const NotificationAction({
    required this.id,
    required this.title,
    this.cancelNotification = false,
    this.showsUserInterface = false,
  });
}

// ============================================================================
// 📖 COMPREHENSIVE USAGE DOCUMENTATION
// ============================================================================

/// **📖 COMPREHENSIVE USAGE EXAMPLES**
///
/// This section provides extensive examples for all notification functionality:
///
/// ## **Basic Setup (Required)**
/// ```dart
/// // 1. Initialize in main.dart (before runApp)
/// await NotificationHelper.initialize(
///   androidIcon: '@mipmap/ic_launcher', // Your app icon
///   onNotificationTap: (NotificationResponse response) {
///     print('Notification tapped: ${response.payload}');
///     // Navigate to specific screen based on payload
///     handleNotificationNavigation(response.payload);
///   },
/// );
///
/// // 2. Request permissions using integrated PermissionHandlerHelper (important for iOS and Android 13+)
/// bool granted = await NotificationHelper.requestPermissions();
/// if (!granted) {
///   print('Notification permissions denied');
///   // Check detailed permission status
///   final status = await NotificationHelper.getNotificationPermissionStatus();
///   if (status.isPermanentlyDenied) {
///     // Show dialog explaining the permission and offer to open settings
///     final shouldOpenSettings = await showPermissionDialog();
///     if (shouldOpenSettings) {
///       await NotificationHelper.openAppSettings();
///     }
///   } else {
///     // Show explanation dialog or disable notifications
///     showPermissionExplanationDialog();
///   }
///   return;
/// }
/// ```
///
/// ## **Permission Management**
/// ```dart
/// // Check notification permissions
/// bool hasPermission = await NotificationHelper.checkNotificationPermissions();
/// if (!hasPermission) {
///   // Request permissions
///   bool granted = await NotificationHelper.requestPermissions();
///   if (!granted) {
///     // Handle permission denial
///     return;
///   }
/// }
///
/// // Get detailed permission status
/// final status = await NotificationHelper.getNotificationPermissionStatus();
/// if (status.isPermanentlyDenied) {
///   // Redirect to settings
///   await NotificationHelper.openAppSettings();
/// } else if (status.isGranted) {
///   // Proceed with notifications
///   await NotificationHelper.showNotification(
///     id: 1,
///     title: 'Permission Granted',
///     body: 'You can now receive notifications',
///   );
/// }
/// ```
///
/// ## **Simple Notifications**
/// ```dart
/// // Basic notification (automatically checks permissions by default)
/// await NotificationHelper.showNotification(
///   id: 1,
///   title: 'Welcome!',
///   body: 'Thanks for downloading our app',
/// );
///
/// // Notification without permission check (for internal use)
/// await NotificationHelper.showNotification(
///   id: 2,
///   title: 'System Message',
///   body: 'This is a system notification',
///   checkPermissions: false, // Skip permission check
/// );
///
/// // Notification with custom styling
/// await NotificationHelper.showNotification(
///   id: 2,
///   title: 'Order Complete',
///   body: 'Your order #12345 has been delivered',
///   payload: 'order_12345',
///   importance: NotificationImportance.high,
///   priority: NotificationPriority.high,
///   color: Colors.green,
///   enableVibration: true,
/// );
///
/// // Silent notification (no sound/vibration)
/// await NotificationHelper.showNotification(
///   id: 3,
///   title: 'Background Update',
///   body: 'App data has been synced',
///   importance: NotificationImportance.low,
///   playSound: false,
///   enableVibration: false,
/// );
/// ```
///
/// ## **Scheduled Notifications**
/// ```dart
/// // Schedule notification for specific time
/// await NotificationHelper.scheduleNotification(
///   id: 100,
///   title: 'Meeting Reminder',
///   body: 'Team meeting starts in 15 minutes',
///   scheduledDate: DateTime(2025, 12, 25, 10, 30), // Christmas 10:30 AM
///   payload: 'meeting_reminder',
/// );
///
/// // Schedule notification relative to now
/// await NotificationHelper.scheduleNotification(
///   id: 101,
///   title: 'Take a Break',
///   body: 'You\'ve been working for 2 hours',
///   scheduledDate: DateTime.now().add(Duration(hours: 2)),
///   importance: NotificationImportance.defaultImportance,
/// );
///
/// // Daily reminder
/// await NotificationHelper.scheduleRepeatingNotification(
///   id: 200,
///   title: 'Daily Standup',
///   body: 'Team standup starts now',
///   repeatInterval: RepeatInterval.daily,
///   importance: NotificationImportance.high,
/// );
///
/// // Weekly reminder
/// await NotificationHelper.scheduleRepeatingNotification(
///   id: 201,
///   title: 'Weekly Report',
///   body: 'Time to submit your weekly report',
///   repeatInterval: RepeatInterval.weekly,
/// );
/// ```
///
/// ## **Rich Notifications**
/// ```dart
/// // Custom sound notification
/// await NotificationHelper.showNotificationWithCustomSound(
///   id: 300,
///   title: 'New Message',
///   body: 'You have received a message from John',
///   soundFileName: 'message_sound', // message_sound.mp3 (Android) / message_sound.aiff (iOS)
///   importance: NotificationImportance.high,
/// );
///
/// // Big text notification (Android)
/// await NotificationHelper.showBigTextNotification(
///   id: 400,
///   title: 'Article Published',
///   body: 'New article available...',
///   bigText: 'Full article content here. This is a very long text that will be '
///            'displayed when the user expands the notification. Perfect for '
///            'articles, detailed messages, or any content that needs more space.',
/// );
///
/// // Interactive notification with action buttons
/// await NotificationHelper.showNotificationWithActions(
///   id: 500,
///   title: 'New Message',
///   body: 'John: Hey, are you available for a call?',
///   actions: [
///     NotificationAction(
///       id: 'reply',
///       title: 'Reply',
///       showsUserInterface: true,
///     ),
///     NotificationAction(
///       id: 'call',
///       title: 'Call',
///       showsUserInterface: true,
///     ),
///     NotificationAction(
///       id: 'dismiss',
///       title: 'Dismiss',
///       cancelNotification: true,
///     ),
///   ],
/// );
/// ```
///
/// ## **Notification Management**
/// ```dart
/// // Cancel specific notification
/// await NotificationHelper.cancelNotification(100);
///
/// // Cancel all notifications
/// await NotificationHelper.cancelAllNotifications();
///
/// // Check pending notifications
/// List<PendingNotificationRequest> pending = await NotificationHelper.getPendingNotifications();
/// print('Pending notifications: ${pending.length}');
/// for (var notification in pending) {
///   print('ID: ${notification.id}, Title: ${notification.title}');
/// }
///
/// // Check active notifications (Android only)
/// if (Platform.isAndroid) {
///   List<ActiveNotification> active = await NotificationHelper.getActiveNotifications();
///   print('Active notifications: ${active.length}');
/// }
/// ```
///
/// ## **E-commerce Integration Examples**
/// ```dart
/// // Order status notifications
/// class OrderNotificationService {
///   static Future<void> notifyOrderPlaced(String orderId) async {
///     await NotificationHelper.showNotification(
///       id: orderId.hashCode,
///       title: 'Order Placed',
///       body: 'Your order #$orderId has been placed successfully',
///       payload: 'order:$orderId',
///       importance: NotificationImportance.high,
///       color: Colors.green,
///     );
///   }
///
///   static Future<void> notifyOrderShipped(String orderId, String trackingNumber) async {
///     await NotificationHelper.showNotificationWithActions(
///       id: orderId.hashCode,
///       title: 'Order Shipped',
///       body: 'Your order #$orderId is on the way!',
///       actions: [
///         NotificationAction(
///           id: 'track',
///           title: 'Track Package',
///           showsUserInterface: true,
///         ),
///         NotificationAction(
///           id: 'view_order',
///           title: 'View Order',
///           showsUserInterface: true,
///         ),
///       ],
///       payload: 'shipping:$orderId:$trackingNumber',
///     );
///   }
///
///   static Future<void> scheduleDeliveryReminder(String orderId, DateTime deliveryDate) async {
///     await NotificationHelper.scheduleNotification(
///       id: orderId.hashCode + 1000,
///       title: 'Delivery Today',
///       body: 'Your order #$orderId will be delivered today',
///       scheduledDate: deliveryDate.subtract(Duration(hours: 2)),
///       payload: 'delivery:$orderId',
///       importance: NotificationImportance.high,
///     );
///   }
/// }
/// ```
///
/// ## **Error Handling & Best Practices**
/// ```dart
/// // Safe notification with error handling
/// Future<void> safeShowNotification({
///   required int id,
///   required String title,
///   required String body,
///   String? payload,
/// }) async {
///   try {
///     // Check if service is initialized
///     if (!NotificationHelper._isInitialized) {
///       print('NotificationHelper not initialized');
///       return;
///     }
///
///     // Check permissions
///     bool hasPermission = await NotificationHelper.requestPermissions();
///     if (!hasPermission) {
///       print('No notification permissions');
///       return;
///     }
///
///     // Show notification
///     await NotificationHelper.showNotification(
///       id: id,
///       title: title,
///       body: body,
///       payload: payload,
///     );
///   } catch (e) {
///     print('Failed to show notification: $e');
///   }
/// }
///
/// // Prevent duplicate notifications
/// Set<int> _activeNotificationIds = {};
///
/// Future<void> showUniqueNotification(int id, String title, String body) async {
///   if (_activeNotificationIds.contains(id)) {
///     print('Notification $id already active');
///     return;
///   }
///
///   _activeNotificationIds.add(id);
///   await NotificationHelper.showNotification(id: id, title: title, body: body);
///
///   // Remove from active set after some time
///   Timer(Duration(seconds: 10), () => _activeNotificationIds.remove(id));
/// }
/// ```