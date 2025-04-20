
import 'package:core/core.dart';
import 'package:example/config/config_di.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';


GetIt getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
Future<GetIt> configureDependencies() async {
  getIt = await Core().init(getIt);
  return getIt.init();
}
