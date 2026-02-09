
import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:storefront_supabase/starter.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize flavor with production environment
    const environment = Environment.production;
    Flavor.create(
      environment,
      name: environment.toString().split('.').last.toUpperCase(),
      color: Colors.black,
    );

    debugPrint(
      'Flavor set at startup: ${environment.toString().split('.').last.toUpperCase()}',
    );

    // Launch the app using the starter pattern
    await launchApp(environment: 'prod');
  } catch (e, stackTrace) {
    debugPrint('Error in main: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
}