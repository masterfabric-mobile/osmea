// 📦 Importing the core package for core functionalities
import 'package:core/core.dart';
// 📦 Importing generated dependency injection config
import 'package:core/src/di/config/config_di.config.dart';
// 🛠️ Importing GetIt for service locator pattern
import 'package:get_it/get_it.dart';
// 🧩 Importing Injectable for dependency injection annotations
import 'package:injectable/injectable.dart';

// 🏗️ Creating a singleton instance of GetIt for dependency management
GetIt getIt = GetIt.instance;

// 🚀 This annotation generates the code for dependency injection initialization
@InjectableInit(preferRelativeImports: false)
Future<GetIt> configureDependencies() async {
  // 🔄 Initialize core dependencies and assign to getIt
  getIt = await Core().init(getIt);
  // ⚙️ Initialize and return all registered dependencies
  return getIt.init();
}
