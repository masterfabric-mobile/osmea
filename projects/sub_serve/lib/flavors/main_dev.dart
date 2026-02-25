import 'package:sub_serve/starter.dart';
import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    const environment = Environment.dev;
    Flavor.create(
      environment,
      name: environment.toString().split('.').last.toUpperCase(),
      color: Colors.grey,
      properties: {'apiUrl': 'https://api-dev.example.com'},
    );

    debugPrint(
      'Flavor set at startup: ${environment.toString().split('.').last.toUpperCase()}',
    );

    await launchApp(environment: 'dev');
  } catch (e, stackTrace) {
    debugPrint('Error in main: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
}
