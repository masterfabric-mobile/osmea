// Define the GoRouter
import 'package:admin_dashboard/app/views/view_splash/splash_view.dart';
import 'package:admin_dashboard/app/views/view_onboarding/onboarding_view.dart';
import 'package:admin_dashboard/app/views/view_welcome/welcome_view.dart';
import 'package:core/core.dart'
    hide SplashView, OnboardingView, SplashState, OnboardingState;
import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// network page  configs serive
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  // Global route configuration
  routes: <RouteBase>[
    // Splash Screen Route
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        final flavor = Flavor.I;
        final isDev = flavor.environment == Environment.dev;

        return SplashView(
          arguments: {
            "title": "Splash View",
            "isDev": isDev,
            "environment": flavor.environment.toString(),
          },
          currentView: MasterViewTypes.content,
        );
      },
    ),

    // Onboarding Route
    GoRoute(
      path: '/onboarding',
      builder: (BuildContext context, GoRouterState state) {
        return OnboardingView(
          arguments: {
            "title": "Onboarding View",
            "description": "Welcome to OSMEA Dashboard onboarding flow",
          },
          currentView: MasterViewTypes.content,
        );
      },
    ),

    // Welcome Route
    GoRoute(
      path: '/welcome',
      builder: (BuildContext context, GoRouterState state) {
        final flavor = Flavor.I;
        final isDev = flavor.environment == Environment.dev;

        return WelcomeView(
          arguments: {
            "title": "Welcome View",
            "description": "Welcome to OSMEA Admin Dashboard",
            "isDev": isDev,
            "environment": flavor.environment.toString(),
          },
          currentView: MasterViewTypes.content,
        );
      },
    ),
  ],
);
