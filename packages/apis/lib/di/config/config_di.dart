// 🌐 API Dependency Injection Configuration
// This file sets up dependency injection for the APIs package using GetIt and Injectable.

import 'package:apis/apis.dart'; // 📦 Main APIs package
import 'package:apis/di/config/config_di.config.dart'; // ⚙️ Generated DI config
import 'package:get_it/get_it.dart'; // 🛠️ Service locator
import 'package:injectable/injectable.dart'; // 💉 Dependency injection

// 🚀 Initializes and configures all dependencies for the APIs package.
// Call this function at app startup to ensure all services are ready to use.
@InjectableInit(preferRelativeImports: false)
GetIt configureDependencies() {
  // 🏗️ Initialize dependencies using the generated config
  return ApiNetwork.getIt.init();
}
