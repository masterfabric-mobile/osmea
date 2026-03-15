import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:storefront_supabase/app/api/admin/admin_routes.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_staff_service.dart';
import 'package:storefront_supabase/app/core/config/config_di.dart';
import 'package:storefront_supabase/app/models/admin_staff_user.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class AdminStaffView extends StatefulWidget {
  const AdminStaffView({
    super.key,
    required this.goRoute,
  });

  final void Function(String path) goRoute;

  @override
  State<AdminStaffView> createState() => _AdminStaffViewState();
}

class _AdminStaffViewState extends State<AdminStaffView> {
  late Future<List<AdminStaffUser>> _staff;
  final Map<String, bool> _optimisticActive = {};

  AdminStaffService get _staffService => getIt<AdminStaffService>();

  bool _isActive(AdminStaffUser u) => _optimisticActive[u.id] ?? u.isActive;

  @override
  void initState() {
    super.initState();
    _staff = _staffService.listStaff();
  }

  Future<void> _refresh() async {
    setState(() {
      _staff = _staffService.listStaff();
      _optimisticActive.clear();
    });
  }

  Future<void> _toggleActive(AdminStaffUser user) async {
    final nextActive = !_isActive(user);
    setState(() => _optimisticActive[user.id] = nextActive);
    try {
      await _staffService.setActive(user.id, nextActive);
      if (mounted) {
        setState(() {
          _optimisticActive.remove(user.id);
          _staff = _staffService.listStaff();
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _optimisticActive.remove(user.id));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: OsmeaComponents.text(
            '${context.resources.errorPrefix}$e',
            color: OsmeaColors.white,
          ),
          backgroundColor: OsmeaColors.amberFlame,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.paperWhite,
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text(resources.staff, color: OsmeaColors.black),
        variant: AppBarVariant.primary,
        backgroundColor: OsmeaColors.white,
        foregroundColor: OsmeaColors.black,
        leading: OsmeaComponents.iconButton(
          onPressed: () => widget.goRoute(AdminRoutes.dashboard),
          icon: Icon(Icons.arrow_back, color: OsmeaColors.black),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<AdminStaffUser>>(
          future: _staff,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return OsmeaComponents.center(
                child: OsmeaComponents.loading(
                  type: LoadingType.circularFade,
                  size: 36,
                  color: OsmeaColors.black,
                ),
              );
            }
            if (snapshot.hasError) {
              return OsmeaComponents.center(
                child: OsmeaComponents.text(
                  '${resources.errorPrefix}${snapshot.error}',
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.thunder),
                ),
              );
            }
            final list = snapshot.data ?? [];
            if (list.isEmpty) {
              return OsmeaComponents.center(
                child: OsmeaComponents.text(
                  resources.noStaffUsersFound,
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.thunder),
                ),
              );
            }
            return ListView.builder(
              padding: context.paddingNormal,
              itemCount: list.length,
              itemBuilder: (context, i) {
                final u = list[i];
                final isActive = _isActive(u);
                return OsmeaComponents.container(
                  margin: EdgeInsets.only(bottom: context.spacing12),
                  decoration: BoxDecoration(
                    color: OsmeaColors.white,
                    borderRadius: context.borderRadiusNormal,
                    border: Border.all(color: OsmeaColors.silver.withValues(alpha: 0.5)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: OsmeaComponents.listItem(
                    leading: OsmeaComponents.avatar(
                      size: ComponentSize.medium,
                      text: (u.email.isNotEmpty ? u.email.substring(0, 1).toUpperCase() : '?'),
                      backgroundColor: OsmeaColors.black,
                    ),
                    title: OsmeaComponents.text(
                      u.fullName != null && u.fullName!.isNotEmpty
                          ? '${u.fullName} (${u.email})'
                          : u.email,
                      textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: OsmeaColors.black,
                          ),
                    ),
                    subtitle: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: OsmeaComponents.text(
                        '${u.role} · ${isActive ? context.resources.active : context.resources.inactive}',
                        key: ValueKey(isActive),
                        textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.slate),
                      ),
                    ),
                    trailing: Tooltip(
                      message: isActive ? context.resources.deactivate : context.resources.activate,
                      child: Switch(
                        value: isActive,
                        onChanged: (_) => _toggleActive(u),
                        activeThumbColor: OsmeaColors.black,
                        activeTrackColor: OsmeaColors.black.withValues(alpha: 0.3),
                        inactiveThumbColor: OsmeaColors.thunder,
                        inactiveTrackColor: OsmeaColors.silver.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
