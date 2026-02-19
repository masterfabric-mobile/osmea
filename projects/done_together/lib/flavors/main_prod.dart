import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:done_together/starter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const environment = Environment.production;
  Flavor.create(
    environment,
    name: environment.toString().split('.').last.toUpperCase(),
    color: Colors.blue,
  );
  debugPrint('Flavor: PROD');
  await launchApp(environment: 'prod');
}
