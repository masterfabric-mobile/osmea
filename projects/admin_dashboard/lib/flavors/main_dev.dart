import 'package:admin_dashboard/core/config/config_di.dart';
import 'package:admin_dashboard/app/routes/app_routes.dart';
import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize flavor with development environment
  const environment = Environment.dev;
  Flavor.create(
    environment,
    name: environment.toString().split('.').last.toUpperCase(),
    color: Colors.green,
    properties: {'apiUrl': 'https://api.example.com.dev'},
  );

  debugPrint(
    'Flavor set at startup: ${environment.toString().split('.').last.toUpperCase()}',
  );
  await configureDependencies(environment: 'dev');

  await MasterApp.runBefore(allowCollectDataTelemetry: false);

  runApp(MasterApp(router: appRouter, devModeGrid: true, devModeSpacer: true));
}
