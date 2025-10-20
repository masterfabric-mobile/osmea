// ignore_for_file: await_only_futures

import 'package:core/core.dart';
import 'package:apis/apis.dart';
import 'package:apis/di/config/config_di.config.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

GetIt getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
Future<GetIt> configureDependencies() async {
  try {
    debugPrint('🔧 Configuring dependencies for API Explorer (Wizard-based)');

    // Initialize core dependencies first
    getIt = await Core().init(getIt);
    debugPrint('✅ Core dependencies initialized');

    // Initialize wizard helper and storage for API Explorer
    await ApiNetwork.initWizard();
    debugPrint('✅ Wizard system initialized');

    // Try to initialize networks from wizard configuration
    // This will be empty initially until user completes wizard
    try {
      await initNetworksFromWizard(getIt);
      debugPrint('✅ Networks initialized from wizard configuration');
    } catch (e) {
      debugPrint(
          '⚠️ No networks initialized from wizard. User needs to complete setup wizard first.');
      // This is expected for first-time users
    }

    // Initialize dependency injection
    final result = await getIt.init();
    debugPrint('✅ Dependency injection initialized successfully');
    return result;
  } catch (e) {
    debugPrint('❌ Error in dependency injection: $e');

    // If there's a duplicate registration error, try to reset and reinitialize
    if (e.toString().contains('already registered')) {
      debugPrint('🔄 Attempting to reset and reinitialize GetIt...');
      try {
        getIt.reset();
        final result = await getIt.init();
        debugPrint('✅ GetIt reset and reinitialized successfully');
        return result;
      } catch (resetError) {
        debugPrint('❌ Failed to reset GetIt: $resetError');
        rethrow;
      }
    }

    rethrow;
  }
}
