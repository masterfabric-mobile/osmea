// 📦 Importing core module dependencies
import 'package:core/src/di/config/config_di.config.dart';
import 'package:core/src/views/search/cubit/search_cubit.dart';
import 'package:core/src/views/onboarding/cubit/onboarding_cubit.dart';
import 'package:core/src/views/splash/cubit/splash_cubit.dart';
import 'package:core/src/views/empty_view/cubit/empty_view_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

// 🏗️ Creating a singleton instance of GetIt for dependency injection
GetIt getIt = GetIt.instance;

// 🛠️ This annotation generates the dependency injection initialization code
@InjectableInit(preferRelativeImports: false)
Future<GetIt> configureDependencies() async {
  // Register Logger first (needed by ICommonLogger)
  if (!getIt.isRegistered<Logger>()) {
    getIt.registerFactory<Logger>(() => Logger());
  }

  // 🔄 Run the generated initialization (includes ICommonLogger registration)
  await getIt.init();

  // Register Cubits manually (not using @injectable annotation on Cubits)
  // These are registered after init to avoid conflicts
  if (!getIt.isRegistered<SplashCubit>()) {
    getIt.registerFactory<SplashCubit>(() => SplashCubit());
  }

  if (!getIt.isRegistered<OnboardingCubit>()) {
    getIt.registerFactory<OnboardingCubit>(() => OnboardingCubit());
  }

  if (!getIt.isRegistered<EmptyViewCubit>()) {
    getIt.registerFactory<EmptyViewCubit>(() => EmptyViewCubit());
  }

  // AuthCubit should be registered as singleton in starter.dart
  // Don't register here to avoid conflicts - let starter.dart handle it
  // If not registered, it will be registered in starter.dart

  getIt.registerFactory<SearchCubit>(() => SearchCubit());
  return getIt;
}
