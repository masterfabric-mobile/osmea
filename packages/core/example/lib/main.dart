import 'package:core/core.dart';
import 'package:example/config/config_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

// Define the GoRouter
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return  SplashView();
      },
      
    ),
    
  ],
);

void main() {
  
  MasterApp.runBefore();

  configureDependencies();
  
  runApp(MasterApp(
    router: _router,
    shouldSetOrientation: false,
    preferredOrientations: const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
    showPerformanceOverlay: false,
    textDirection: TextDirection.ltr,
    fontScale: 1.0,
  ));
}
