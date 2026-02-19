import 'package:flutter/material.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide LocaleSettings, TranslationProvider;
import 'package:tiny_plates/app/routes/app_routes.dart';
import 'package:tiny_plates/app/core/config/config_di.dart' as di;
import 'package:tiny_plates/gen/strings.g.dart';

/// Launches Tiny Plates.
/// Loads config, GoRouter (splash → onboarding → home), runs [MasterApp].
///
/// [environment]: 'dev' | 'prod'
Future<void> launchApp({String environment = 'dev'}) async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('🚀 Tiny Plates starting (environment: $environment)');

  await MasterApp.runBefore(
    assetConfigPath: 'assets/app_config.json',
    hydrated: true,
  );

  final configHelper = AssetConfigHelper();
  await configHelper.loadConfig('assets/app_config.json', false);

  await di.configureDependencies(environment: environment);

  await LocaleSettings.useDeviceLocale();

  runApp(
    TranslationProvider(
      child: MasterApp(
        router: appRouter,
        themeMode: ThemeMode.light,
        fontScale: 1.0,
      ),
    ),
  );
}
