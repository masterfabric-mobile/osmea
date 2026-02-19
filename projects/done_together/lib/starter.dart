import 'package:core/core.dart'
    hide
        BuildContextTranslationsExtension,
        AppLocaleUtils,
        LocaleSettings,
        TranslationProvider;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:done_together/app/core/config/config_di.dart';
import 'package:done_together/app/routes/app_routes.dart';

/// Launches the Done Together app with the given [environment] (dev / prod).
Future<void> launchApp({String environment = 'dev'}) async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('Starting Done Together — environment: $environment');

  final assetConfigHelper = AssetConfigHelper();
  final configLoaded = await assetConfigHelper.loadConfig('assets/app_config.json');

  final supabaseUrl = configLoaded
      ? assetConfigHelper.getString('supabase_configuration.url')
      : '';
  final supabaseAnonKey = configLoaded
      ? assetConfigHelper.getString('supabase_configuration.anon_key')
      : '';

  if (supabaseUrl.isNotEmpty &&
      supabaseAnonKey.isNotEmpty &&
      supabaseUrl != 'YOUR_SUPABASE_URL') {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
    debugPrint('Supabase initialized');
  } else {
    debugPrint('Supabase URL/anon_key not set; skipping Supabase init.');
  }

  await configureDependencies(environment: environment);

  runApp(
    MaterialApp.router(
      title: configLoaded
          ? assetConfigHelper.getString('app_settings.app_name', 'Done Together')
          : 'Done Together',
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('tr'),
      ],
    ),
  );
}
