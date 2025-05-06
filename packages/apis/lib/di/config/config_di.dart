// 🌐 API Dependency Injection Configuration
// This file sets up dependency injection for the APIs package using GetIt and Injectable.

import 'package:apis/apis.dart'; // 📦 Main APIs package
import 'package:apis/di/config/config_di.config.dart'; // ⚙️ Generated DI config
import 'package:get_it/get_it.dart'; // 🛠️ Service locator
import 'package:injectable/injectable.dart'; // 💉 Dependency injection
import 'package:logger/logger.dart'; // 📜 Logger for error handling
import 'package:flutter/foundation.dart'; // For FlutterError

// Create a logger instance for logging errors
final Logger logger = Logger();

/// 🚀 Initializes and configures all dependencies for the APIs package.
/// 
/// Call this function at app startup to ensure all services are ready to use.
/// 
/// Returns the configured [GetIt] instance for service locator.
@InjectableInit(preferRelativeImports: false)
GetIt configureDependencies() {
  try {
    // 🏗️ Initialize dependencies using the generated config
    return ApiNetwork.getIt.init();
  } catch (e) {
    // Log the error if dependency initialization fails
    logger.e('Failed to configure dependencies: $e');

    // Handle specific exceptions
    if (e is FlutterError) {
      logger.e('Flutter error occurred: ${e.message}');
    } else if (e is Exception) {
      logger.e('General exception occurred: ${e.toString()}');
    } else {
      logger.e('An unknown error occurred: ${e.toString()}');
    }

    rethrow; // Rethrow the error after logging
  }
}