import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import './routes/app_routes.dart';
import './widgets/device_frame_wrapper.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize core components before running the app
  await MasterApp.runBefore(allowCollectDataTelemetry: true);
  
  // Initialize dependency injection
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
