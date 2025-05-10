// Define the GoRouter
import 'package:core/core.dart';
import 'package:example/views/view_home/home_view.dart';
import 'package:example/views/view_splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// network page  configs serive
final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return HomeView(
          appBar: AppBar(
            title: Text("Home View"),
          ),
          arguments: {
            "productTitle": "Products (Encrypted Storage)",
            "cardType": "Content Card",
            "description": "Home View Description"
          },
          currentView: MasterViewTypes.content,
        );
      },
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return SplashView(
          arguments: {"title": "Splash View"},
          currentView: MasterViewTypes.content,
         
        );
      },
    ),
  ],
);
