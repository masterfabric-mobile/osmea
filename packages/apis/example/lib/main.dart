// 🎨 Import for app theme styles
import 'package:example/styles/app_theme.dart';
// 🏠 Import for the home view widget
import 'package:example/views/home_view.dart';
// 🌐 Import for API client configuration
import 'package:apis/dio_config/api_dio_client.dart';
// 🧩 Import for Flutter material design widgets
import 'package:flutter/material.dart';
// 💻 Import for checking if the platform is web
import 'package:flutter/foundation.dart' show kIsWeb;

// 🛠️ Import for dependency injection configuration
import 'di/config/config_di.dart';

// 🚀 Main entry point of the application
Future<void> main() async {
  // 🪄 Ensures Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // 🔗 Set up dependency injection
  configureDependencies();
  // 🍪 Prepare cookies storage if not running on web
  if (!kIsWeb) await ApiDioClient.prepareCookiesJar();
  // 🏁 Start the app
  runApp(const MyApp());
}

// 🏗️ Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 🏷️ App title
      title: 'OSMEA APIs Package',
      // 🚫 Hide debug banner
      debugShowCheckedModeBanner: false,
      // 🎨 Set the app theme
      theme: AppTheme.getTheme(),
      // 🏠 Set the home screen
      home: const HomeView(),
    );
  }
}
