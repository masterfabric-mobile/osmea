import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter/foundation.dart';
import 'package:storefront_supabase/app/core/config/config_di.config.dart';
import 'package:storefront_supabase/app/views/view_home/models/home_view_model.dart';

GetIt getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
Future<GetIt> configureDependencies({String? environment}) async {
  try {
    debugPrint('🔧 Configuring dependencies for environment: $environment');

    // Initialize core dependencies
    getIt = await Core().init(getIt);
    debugPrint('✅ Core dependencies initialized');

    // Initialize app-specific dependencies
    final result = getIt.init(environment: environment);
    debugPrint('✅ App dependencies initialized');

    // Ensure SupabaseHomeViewModel is registered (safety net in case
    // code generation is not up to date).
    if (!getIt.isRegistered<SupabaseHomeViewModel>()) {
      getIt.registerFactory<SupabaseHomeViewModel>(
        () => SupabaseHomeViewModel(),
      );
      debugPrint('✅ SupabaseHomeViewModel registered manually in GetIt');
    }

    return result;
  } catch (e, stackTrace) {
    debugPrint('❌ Error configuring dependencies: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
}
