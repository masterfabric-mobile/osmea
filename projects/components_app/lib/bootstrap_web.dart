import 'package:core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:core/firebase_options.dart';

/// Web-only bootstrap: Firebase, asset config from core package, localStorage.
/// Avoids MasterApp.runBefore() so we never touch dart:io (DeviceInfoHelper, PermissionHandler).
/// Call this from main() when kIsWeb is true.
Future<void> runBeforeWeb() async {
  final localStorageHelper = LocalStorageHelper();
  final assetConfigHelper = AssetConfigHelper();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const fallbackConfigPath = 'packages/core/assets/app_config.json';
  bool assetConfigLoaded = false;
  try {
    assetConfigLoaded = await assetConfigHelper.loadConfig(
      fallbackConfigPath,
      false,
    );
    if (assetConfigLoaded) {
      debugPrint(
        '✅ Web: config loaded from $fallbackConfigPath',
      );
    }
  } catch (e) {
    debugPrint('⚠️ Web: config load failed: $e');
  }

  await localStorageHelper.init();
  await localStorageHelper.setItem('osmea_config_loaded', assetConfigLoaded);
  await localStorageHelper.setItem('osmea_config_source', fallbackConfigPath);
  await localStorageHelper.setItem('osmea_config_is_fallback', true);
}
