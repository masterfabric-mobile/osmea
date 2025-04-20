// 📦 Importing core module dependencies
import 'package:core/src/core.dart';
import 'package:core/src/di/config/config_di.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// 🏗️ Creating a singleton instance of GetIt for dependency injection
GetIt getIt = GetIt.instance;

// 🛠️ This annotation generates the dependency injection initialization code
@InjectableInit(preferRelativeImports: false)
Future<GetIt> configureDependencies() async {
  // 🚀 Initialize core dependencies and assign to getIt
  getIt = await Core().init(getIt);
  // 🔄 Run the generated initialization and return the configured GetIt instance
  return getIt.init();
}
