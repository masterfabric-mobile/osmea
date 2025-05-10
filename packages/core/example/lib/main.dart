import 'package:core/core.dart';
import 'package:example/config/config_di.dart';
import 'package:example/routes/app_routes.dart';
import 'package:flutter/material.dart';

void main() async {
  
  /// Initializes necessary components before the app starts.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Perform any necessary setup before the app starts
  await MasterApp.runBefore();
  // Configure dependency injection for the application
  configureDependencies();

  // Run the main application with the specified router
  runApp(MasterApp(
    router: appRouter, // The router handles navigation within the app
  ));
}
