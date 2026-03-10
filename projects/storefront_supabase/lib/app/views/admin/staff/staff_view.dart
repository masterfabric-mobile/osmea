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

  AdminStaffService get _staffService => getIt<AdminStaffService>();

  @override
  void initState() {
    super.initState();
    _staff = _staffService.listStaff();
  }

  Future<void> _refresh() async {
    setState(() {
      _staff = _staffService.listStaff();
    });
  }

  Future<void> _toggleActive(AdminStaffUser user) async {
    try {
      await _staffService.setActive(user.id, !user.isActive);
      _refresh();
    } catch (e) {
      if (!mounted) return;
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
        title: OsmeaComponents.text('Staff', color: OsmeaColors.black),
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
                  'No staff users found.',
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.thunder),
                ),
              );
            }
            return ListView.builder(
              padding: context.paddingNormal,
              itemCount: list.length,
              itemBuilder: (context, i) {
                final u = list[i];
                return OsmeaComponents.container(
                  margin: EdgeInsets.only(bottom: context.spacing12),
                  decoration: BoxDecoration(
                    color: OsmeaColors.white,
                    borderRadius: context.borderRadiusNormal,
                    border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
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
                    subtitle: OsmeaComponents.text(
                      '${u.role} · ${u.isActive ? 'Active' : 'Inactive'}',
                      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.slate),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        u.isActive ? Icons.toggle_on : Icons.toggle_off,
                        color: u.isActive ? OsmeaColors.black : OsmeaColors.thunder,
                        size: 28,
                      ),
                      onPressed: () => _toggleActive(u),
                      tooltip: u.isActive ? 'Deactivate' : 'Activate',
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
