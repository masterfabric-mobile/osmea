import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:tiny_plates/app/core/config/app_config_service.dart';
import 'package:tiny_plates/app/core/config/config_di.dart';
import 'package:tiny_plates/app/core/theme/theme_factory.dart';
import 'package:tiny_plates/gen/strings.g.dart';

/// Main navigation shell: wraps active route with OsmeaScaffold + OsmeaNavbar.
/// Theme is driven by [ThemeFactory] which reads [AppConfigService].
class DashboardShell extends StatelessWidget {
  const DashboardShell({super.key, required this.child});

  final Widget child;

  static const _routes = ['/home', '/diary', '/settings'];

  int _currentIndex(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final idx = _routes.indexWhere((r) => path.startsWith(r));
    return idx < 0 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final config = getIt<AppConfigService>();
    final themeData = ThemeFactory.fromConfig(config);
    final currentIndex = _currentIndex(context);

    final tabTitles = [t.home, t.diary, t.settings];

    return Theme(
      data: themeData,
      child: OsmeaComponents.scaffold(
        appBar: OsmeaComponents.appBar(
          title: OsmeaComponents.text(
            tabTitles[currentIndex],
            fontSize: context.fontSizeLarge,
            fontWeight: context.bold,
            color: themeData.colorScheme.onSurface,
          ),
          backgroundColor: themeData.colorScheme.surface,
          foregroundColor: themeData.colorScheme.onSurface,
          elevation: 0,
          centerTitle: false,
        ),
        bottomNavigationBar: OsmeaNavbar(
          position: NavbarPosition.bottom,
          variant: NavbarVariant.healthcareMinimal,
          currentIndex: currentIndex,
          onItemTap: (index) => context.go(_routes[index]),
          backgroundColor: themeData.colorScheme.surface,
          activeColor: themeData.colorScheme.primary,
          inactiveColor: themeData.colorScheme.primary.withValues(alpha: 0.4),
          items: [
            NavbarItem(
              text: t.home,
              icon: const Icon(Icons.home_outlined),
            ),
            NavbarItem(
              text: t.diary,
              icon: const Icon(Icons.menu_book_outlined),
            ),
            NavbarItem(
              text: t.settings,
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
        ),
        body: child,
      ),
    );
  }
}
