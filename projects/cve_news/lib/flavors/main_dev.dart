
import 'package:cve_news/starter.dart';
import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize flavor with development environment
    const environment = Environment.dev;
    Flavor.create(
      environment,
      name: environment.toString().split('.').last.toUpperCase(),
      color: Colors.green,
    );

    debugPrint(
      'Flavor set at startup: ${environment.toString().split('.').last.toUpperCase()}',
    );

    // Launch the app using the starter pattern
    await launchApp(environment: 'dev');
  } catch (e, stackTrace) {
    debugPrint('Error in main: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
}
