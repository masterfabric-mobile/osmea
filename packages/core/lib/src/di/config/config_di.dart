// 📦 Importing core module dependencies
import 'package:core/src/di/config/config_di.config.dart';
import 'package:core/src/helper/common_logger_helper/abstract/common_logger.dart';
import 'package:core/src/helper/common_logger_helper/common_logger_helper.dart';
import 'package:core/src/views/auth/sign_in/cubit/sign_in_cubit.dart';
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
  // Register Logger first
  getIt.registerFactory<Logger>(() => Logger());

  // ⭐ Register ICommonLogger (CRITICAL - needed by BaseViewModelCubit)
  getIt.registerLazySingleton<ICommonLogger>(
    () => CommonLogger(logger: Logger()),
  );

  // Register SplashCubit in core package
  getIt.registerFactory<SplashCubit>(() => SplashCubit());

  // Register OnboardingCubit in core package
  getIt.registerFactory<OnboardingCubit>(() => OnboardingCubit());

  // Register SignInCubit in core package
  getIt.registerFactory<SignInCubit>(() => SignInCubit());

  // 🔄 Run the generated initialization and return the configured GetIt instance
  await getIt.init();

  return getIt;
}
