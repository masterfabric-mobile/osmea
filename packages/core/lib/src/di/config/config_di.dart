// 📦 Importing core module dependencies
import 'package:core/src/di/config/config_di.config.dart';
import 'package:core/src/views/auth/sign_in/cubit/sign_in_cubit.dart';
import 'package:core/src/views/auth/sign_up/cubit/sign_up_cubit.dart';
import 'package:core/src/views/onboarding/cubit/onboarding_cubit.dart';
import 'package:core/src/views/splash/cubit/splash_cubit.dart';
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

  if (!getIt.isRegistered<SignInCubit>()) {
    getIt.registerFactory<SignInCubit>(() => SignInCubit());
  }

  if (!getIt.isRegistered<SignUpCubit>()) {
    getIt.registerFactory<SignUpCubit>(() => SignUpCubit());
  }

  return getIt;
}
