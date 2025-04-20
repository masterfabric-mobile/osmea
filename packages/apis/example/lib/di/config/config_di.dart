import 'package:apis/apis.dart';
import 'package:example/di/config/config_di.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';


GetIt getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
Future<GetIt> configureDependencies() async {
  // Use initFromConfig to load values from config.json instead of passing empty string
  getIt = await ApiNetwork.initFromConfig(getIt);
  return getIt.init();
}
