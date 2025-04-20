import 'package:example/styles/app_theme.dart';
import 'package:example/views/home_view.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'di/config/config_di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  configureDependencies();

  if (!kIsWeb) await ApiDioClient.prepareCookiesJar();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APIS Package',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(),
      home: const HomeView(),
    );
  }
}
