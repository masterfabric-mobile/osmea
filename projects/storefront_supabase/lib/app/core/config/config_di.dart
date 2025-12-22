import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter/foundation.dart';
import 'package:storefront_supabase/app/core/config/config_di.config.dart';


GetIt getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
Future<GetIt> configureDependencies({String? environment}) async {
  try {
    debugPrint('🔧 Configuring dependencies for environment: $environment');

    // Initialize core dependencies
    getIt = await Core().init(getIt);
    debugPrint('✅ Core dependencies initialized');


    // Register Supabase client
    if (!getIt.isRegistered<SupabaseClient>()) {
      getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);
      debugPrint('✅ SupabaseClient registered manually in GetIt');
    }


    // Initialize app-specific dependencies
    final result = getIt.init(environment: environment);
    debugPrint('✅ App dependencies initialized');

    return result;
  } catch (e, stackTrace) {
    debugPrint('❌ Error configuring dependencies: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
}
