import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:tiny_plates/app/core/config/app_config_service.dart';
import 'package:tiny_plates/app/core/config/config_di.config.dart';

GetIt getIt = GetIt.instance;

/// Dependency injection setup. Same structure as storefront_woo.
/// - Generated config (config_di.config.dart): HomeViewModel etc. via @injectable.
/// - Core views (SplashView) need their Cubits registered here.
/// - Onboarding: only tiny_plates view_onboarding (OnboardingViewModel from generated config).
@InjectableInit(preferRelativeImports: false)
Future<GetIt> configureDependencies({String? environment}) async {
  try {
    debugPrint('🔧 Configuring dependencies for environment: $environment');

    // App ViewModels from generated config (HomeViewModel etc.)
    final result = getIt.init(environment: environment);

    // masterfabric_core views used in routes need their Cubits in GetIt
    _registerMasterFabricCoreCubits();
    // App-level services
    _registerAppServices();
    debugPrint('✅ Dependencies configured');

    return result;
  } catch (e, stackTrace) {
    debugPrint('❌ Error configuring dependencies: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
}

void _registerMasterFabricCoreCubits() {
  if (!getIt.isRegistered<SplashCubit>()) {
    getIt.registerFactory<SplashCubit>(() => SplashCubit());
    debugPrint('✅ SplashCubit registered');
  }
}

void _registerAppServices() {
  if (!getIt.isRegistered<AppConfigService>()) {
    getIt.registerSingleton<AppConfigService>(AppConfigService());
    debugPrint('✅ AppConfigService registered');
  }
}
