import 'package:apis/apis.dart';
import 'package:example/di/config/config_di.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

GetIt getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
Future<GetIt> configureDependencies() async {
  getIt = ApiNetwork.init(
    getIt,
    storeName:'<store_name>',
    shopifyAccessToken: '<shopify_access_token>',
  );

  return getIt.init();
}
