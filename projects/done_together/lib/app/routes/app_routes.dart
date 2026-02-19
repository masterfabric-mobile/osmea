import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:done_together/app/views/view_home/home_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) =>
          const HomeView(),
    ),
  ],
);
