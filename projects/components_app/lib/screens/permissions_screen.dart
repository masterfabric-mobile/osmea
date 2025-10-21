import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('🔍 [PermissionsScreen] build() called');
    final state = GoRouterState.of(context);
    final previous = state.extra is String ? state.extra as String : null;
    
    try {
      return PermissionsView(
        goRoute: (name) {
          final path = name.startsWith('/') ? name : '/$name';
          context.go(path);
        },
        coreAppBar: (ctx, vm) {
          return AppBar(
            title: const Text('Permissions'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                final prev = previous;
                if (prev != null && prev.isNotEmpty && prev != '/permissions') {
                  final path = prev.startsWith('/') ? prev : '/$prev';
                  context.go(path);
                } else if (Navigator.of(ctx).canPop()) {
                  Navigator.of(ctx).pop();
                } else {
                  context.go('/');
                }
              },
            ),
          );
        },
        arguments: {'previousRoute': previous},
      );
    } catch (e) {
      debugPrint('🔴 [PermissionsScreen] Error in PermissionsScreen: $e');
      debugPrintStack();
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $e'),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: Text('Go Home'),
              ),
            ],
          ),
        ),
      );
    }
  }
}
