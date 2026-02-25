import 'package:core/core.dart' show Core;
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:done_together/app/views/view_home/models/home_view_model.dart';

final GetIt getIt = GetIt.instance;

/// Configures dependencies for the app. Call once at startup after flavor is set.
Future<GetIt> configureDependencies({String? environment}) async {
  try {
    debugPrint('Configuring dependencies for environment: $environment');
    await Core().init(getIt);
    getIt.registerLazySingleton<HomeViewModel>(() => HomeViewModel());
    debugPrint('Core dependencies initialized');
    return getIt;
  } catch (e, stackTrace) {
    debugPrint('Error configuring dependencies: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
}
