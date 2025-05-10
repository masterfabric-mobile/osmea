// 📦 Importing the core package for core functionalities
import 'package:core/core.dart';
// 📦 Importing generated dependency injection config
import 'package:core/src/di/config/config_di.config.dart';
import 'package:core/src/helper/common_logger_helper/abstract/common_logger.dart';
import 'package:core/src/helper/common_logger_helper/common_logger_helper.dart';
// 🛠️ Importing GetIt for service locator pattern
import 'package:get_it/get_it.dart';
// 🧩 Importing Injectable for dependency injection annotations
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

// 🏗️ Creating a singleton instance of GetIt for dependency management
GetIt getIt = GetIt.instance;

// 🚀 This annotation generates the code for dependency injection initialization
@InjectableInit(preferRelativeImports: false)
Future<GetIt> configureDependencies() async {
  // 🔄 Initialize core dependencies and assign to getIt
  
  // ⚙️ Initialize and return all registered dependencies
  getIt.registerLazySingleton<ICommonLogger>(() => CommonLogger(logger: Logger()));
  return getIt.init();
}
