import 'package:flutter/material.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:sub_serve/app/routes/app_routes.dart';
import 'package:sub_serve/app/core/config/config_di.dart' as di;

/// Launches MasterFabric SubServe. Same structure as storefront_woo (no lib/flavor).
/// Loads config, GoRouter (splash → onboarding → home), runs [MasterApp].
///
/// [environment]: 'dev' | 'staging' | 'prod'
Future<void> launchApp({String environment = 'dev'}) async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('🚀 MasterFabric SubServe starting (environment: $environment)');

  await MasterApp.runBefore(
    assetConfigPath: 'assets/app_config.json',
    hydrated: true,
  );

  final configHelper = AssetConfigHelper();
  await configHelper.loadConfig('assets/app_config.json', false);

  await di.configureDependencies(environment: environment);

  runApp(
    MasterApp(
      router: appRouter,
      themeMode: ThemeMode.light,
      fontScale: 1.0,
    ),
  );
}
