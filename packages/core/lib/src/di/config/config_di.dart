// 📦 Importing core module dependencies
import 'package:core/src/di/config/config_di.config.dart';
import 'package:core/src/views/auth/cubit/auth_cubit.dart';
import 'package:core/src/views/search/cubit/search_cubit.dart';
import 'package:core/src/views/onboarding/cubit/onboarding_cubit.dart';
import 'package:core/src/views/permissions/cubit/permissions_cubit.dart';
import 'package:core/src/views/splash/cubit/splash_cubit.dart';
import 'package:core/src/views/error_handling/cubit/error_handling_cubit.dart';
import 'package:core/src/views/image_detail/cubit/image_detail_cubit.dart';
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

  if (!getIt.isRegistered<AuthCubit>()) {
    getIt.registerFactory<AuthCubit>(() => AuthCubit());
  }

  getIt.registerFactory<SearchCubit>(() => SearchCubit());
  return getIt;
}
