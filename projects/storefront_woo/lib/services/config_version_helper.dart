import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

/// Helper to track last seen WordPress config plugin_version
/// and detect version changes between app launches.
class ConfigVersionHelper {
  static const String _storageKey = 'osmea_config_plugin_version';

  final LocalStorageHelper _storage = LocalStorageHelper();

  /// Returns true if the plugin_version changed since last launch.
  /// Also stores the new version for future comparisons.
  Future<bool> hasPluginVersionChanged(String? currentVersion) async {
    try {
      await _storage.init();

      final stored = await _storage.getItem(_storageKey);
      final storedString = stored?.toString();
      final currentString = currentVersion?.toString();

      debugPrint(
        '🔍 ConfigVersionHelper: storedVersion=$storedString, currentVersion=$currentString',
      );

      final changed = storedString != null &&
          currentString != null &&
          storedString.isNotEmpty &&
          currentString.isNotEmpty &&
          storedString != currentString;

      // Always persist the latest version (even if null/empty, we just skip storing)
      if (currentString != null && currentString.isNotEmpty) {
        await _storage.setItem(_storageKey, currentString);
        debugPrint(
          '💾 ConfigVersionHelper: stored new plugin_version=$currentString',
        );
      }

      if (changed) {
        debugPrint(
          '⚡ ConfigVersionHelper: plugin_version changed (will trigger soft restart logic)',
        );
      }

      return changed;
    } catch (e) {
      debugPrint('❌ ConfigVersionHelper error: $e');
      return false;
    }
  }
}

