// 📦 Importing core module dependencies
import 'package:core/src/di/config/config_di.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// 🏗️ Creating a singleton instance of GetIt for dependency injection
GetIt getIt = GetIt.instance;

// 🛠️ This annotation generates the dependency injection initialization code
@InjectableInit(preferRelativeImports: false)
Future<GetIt> configureDependencies() async {
  // 🔄 Run the generated initialization (includes all @injectable annotated classes)
  // All cubits including AccountCubit and SearchCubit are now registered automatically via @injectable annotation
  // AccountCubit will automatically inject AuthCubit from GetIt if available
  // SearchCubit uses nullable parameters with default values, so injectable will ignore them
  // Logger is provided via CommonLoggerModule
  // Note: getUsersMe callback should be injected in project-specific DI configuration
  // (e.g., storefront_woo) to avoid core package dependency on apis package
  await getIt.init();

  return getIt;
}
