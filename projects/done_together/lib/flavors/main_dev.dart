import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:done_together/starter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const environment = Environment.dev;
  Flavor.create(
    environment,
    name: environment.toString().split('.').last.toUpperCase(),
    color: Colors.green,
  );
  debugPrint('Flavor: DEV');
  await launchApp(environment: 'dev');
}
