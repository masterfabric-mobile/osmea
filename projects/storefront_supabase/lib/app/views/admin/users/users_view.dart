import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:storefront_supabase/app/models/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class AdminUsersView extends StatefulWidget {
  const AdminUsersView({super.key});

  @override
  State<AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<AdminUsersView> {
  late final Future<List<AppUser>> _users;

  @override
  void initState() {
    super.initState();
    _users = _fetchUsers();
  }

  Future<List<AppUser>> _fetchUsers() async {
    final response = await Supabase.instance.client.from('users').select();
    final users =
        (response as List).map((e) => AppUser.fromJson(e)).toList();
    return users;
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return OsmeaComponents.scaffold(
      backgroundColor: Colors.white,
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text(
          resources.users,
          color: Colors.black,
        ),
        variant: AppBarVariant.primary,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: OsmeaComponents.iconButton(
          onPressed: () => context.go('/profile'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: FutureBuilder<List<AppUser>>(
        future: _users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return OsmeaComponents.center(child: OsmeaComponents.text('${resources.errorPrefix}${snapshot.error}'));
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return OsmeaComponents.center(child: OsmeaComponents.text(resources.noUsersFound));
          }
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return OsmeaComponents.listItem(
                leading: OsmeaComponents.avatar(
                  size: ComponentSize.medium,
                  imageUrl: (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) ? user.avatarUrl : null,
                  text: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                      ? (user.fullName?.substring(0, 1) ??
                          user.email?.substring(0, 1) ??
                          '?')
                      : null,
                ),
                title: OsmeaComponents.text(user.username != null
                    ? '${user.fullName ?? resources.unnamed} (@${user.username})'
                    : user.fullName ?? user.email ?? resources.unnamedUser),
                subtitle: OsmeaComponents.text(
                    '${user.email ?? resources.noEmail} - ${resources.rolePrefix}${user.role ?? 'N/A'}'),
              );
            },
          );
        },
      ),
    );
  }
}