import 'package:core/src/views/loading/cubit/loading_cubit.dart';
import 'package:core/src/views/search/cubit/search_cubit.dart';

import 'config_di.config.dart';
import 'package:core/src/views/onboarding/cubit/onboarding_cubit.dart';
import 'package:core/src/views/splash/cubit/splash_cubit.dart';
import 'package:core/src/views/error_handling/cubit/error_handling_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

GetIt getIt = GetIt.instance;

@InjectableInit()
Future<GetIt> configureDependencies() async {
  getIt.registerFactory<Logger>(() => Logger());
  final result = getIt.init();
  getIt.registerFactory<SplashCubit>(() => SplashCubit());
  getIt.registerFactory<OnboardingCubit>(() => OnboardingCubit());
  getIt.registerFactory<LoadingViewCubit>(() => LoadingViewCubit());
  getIt.registerFactory<ErrorHandlingCubit>(() => ErrorHandlingCubit());
  getIt.registerFactory<SearchCubit>(() => SearchCubit());
  return result;
}
