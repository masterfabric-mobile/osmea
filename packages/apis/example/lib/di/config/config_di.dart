import 'package:apis/apis.dart';
import 'package:example/di/config/config_di.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';


GetIt getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
Future<GetIt> configureDependencies() async {
  getIt = await ApiNetwork.init(getIt);
  return getIt.init();
}
