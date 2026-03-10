import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:storefront_supabase/app/api/admin/admin_routes.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_users_service.dart';
import 'package:storefront_supabase/app/core/config/config_di.dart';
import 'package:storefront_supabase/app/models/app_user.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class AdminUsersView extends StatefulWidget {
  const AdminUsersView({super.key});

  @override
  State<AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<AdminUsersView> {
  late Future<List<AppUser>> _users;

  AdminUsersService get _usersService => getIt<AdminUsersService>();

  @override
  void initState() {
    super.initState();
    _users = _usersService.listUsers();
  }

  Future<void> _refresh() async {
    setState(() {
      _users = _usersService.listUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.paperWhite,
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text(
          resources.users,
          color: OsmeaColors.black,
        ),
        variant: AppBarVariant.primary,
        backgroundColor: OsmeaColors.white,
        foregroundColor: OsmeaColors.black,
        leading: OsmeaComponents.iconButton(
          onPressed: () => context.go(AdminRoutes.profile),
          icon: Icon(Icons.arrow_back, color: OsmeaColors.black),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<AppUser>>(
          future: _users,
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
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return OsmeaComponents.center(
                child: OsmeaComponents.text(
                  resources.noUsersFound,
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.thunder),
                ),
              );
            }
            final users = snapshot.data!;
            return ListView.builder(
              padding: context.paddingNormal,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final hasAvatar = user.avatarUrl != null && user.avatarUrl!.isNotEmpty;
                final initial = (user.fullName?.substring(0, 1) ??
                        user.email?.substring(0, 1) ??
                        '?')
                    .toUpperCase();
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
                      imageUrl: hasAvatar ? user.avatarUrl : null,
                      text: hasAvatar ? null : initial,
                      backgroundColor: hasAvatar ? null : OsmeaColors.black,
                    ),
                    title: OsmeaComponents.text(
                      user.username != null
                          ? '${user.fullName ?? resources.unnamed} (@${user.username})'
                          : user.fullName ?? user.email ?? resources.unnamedUser,
                      textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: OsmeaColors.black,
                          ),
                    ),
                    subtitle: OsmeaComponents.text(
                      '${user.email ?? resources.noEmail} - ${resources.rolePrefix}${user.role ?? 'N/A'}',
                      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.slate),
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
