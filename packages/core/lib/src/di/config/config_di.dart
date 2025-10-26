// 📦 Importing generated dependency injection config
import 'package:core/src/di/config/config_di.config.dart';
import 'package:core/src/helper/common_logger_helper/abstract/common_logger.dart';
import 'package:core/src/helper/common_logger_helper/common_logger_helper.dart';
import 'package:core/src/views/auth/sign_in/cubit/sign_in_cubit.dart';
import 'package:core/src/views/error_handling/cubit/error_handling_cubit.dart';
import 'package:core/src/views/loading/cubit/loading_cubit.dart';

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
@InjectableInit()
Future<GetIt> configureDependencies() async {
  // Register Logger first
  getIt.registerFactory<Logger>(() => Logger());

  // Register ICommonLogger
  // getIt.registerLazySingleton<ICommonLogger>(
  //   () => CommonLogger(logger: Logger()),
  // );

  // Register SplashCubit in core package
  getIt.registerFactory<SplashCubit>(() => SplashCubit());

  // Register OnboardingCubit in core package
  getIt.registerFactory<OnboardingCubit>(() => OnboardingCubit());

  // Register SignInCubit in core package
  getIt.registerFactory<SignInCubit>(() => SignInCubit());
  getIt.registerFactory<LoadingViewCubit>(() => LoadingViewCubit());
  getIt.registerFactory<ErrorHandlingCubit>(() => ErrorHandlingCubit());
  getIt.registerFactory<ImageDetailCubit>(() => ImageDetailCubit());
  // Register PermissionsCubit in core package
  getIt.registerFactory<PermissionsCubit>(() => PermissionsCubit());

  // 🔄 Run the generated initialization and return the configured GetIt instance
  await getIt.init();

  return getIt;
}
