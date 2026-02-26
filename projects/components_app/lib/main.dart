import 'package:core/core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get_it/get_it.dart';
import './bootstrap_web.dart';
import './routes/app_routes.dart';
import './widgets/device_frame_wrapper.dart';

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await runBeforeWeb();
  } else {
    await MasterApp.runBefore(allowCollectDataTelemetry: true);
  }
  await Core().init(GetIt.instance);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DeviceFrameWrapper(
      child: MasterApp(
        router: AppRoutes.router,
        shouldSetOrientation: true,
        showPerformanceOverlay: false,
        textDirection: TextDirection.ltr,
        themeMode: ThemeMode.light,
        devModeGrid: false,
        devModeSpacer: false,
      ),
    );
  }
}
