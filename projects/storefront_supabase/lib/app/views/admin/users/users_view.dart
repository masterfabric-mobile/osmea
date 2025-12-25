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
    return Scaffold(
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text(resources.users),
        variant: AppBarVariant.primary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
            return Center(child: Text('${resources.errorPrefix}${snapshot.error}'));
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text(resources.noUsersFound));
          }
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(user.avatarUrl!),
                      )
                    : CircleAvatar(
                        child: Text(user.fullName?.substring(0, 1) ??
                            user.email?.substring(0, 1) ??
                            '?'),
                      ),
                title: Text(user.username != null
                    ? '${user.fullName ?? resources.unnamed} (@${user.username})'
                    : user.fullName ?? user.email ?? resources.unnamedUser),
                subtitle: Text(
                    '${user.email ?? resources.noEmail} - ${resources.rolePrefix}${user.role ?? 'N/A'}'),
              );
            },
          );
        },
      ),
    );
  }
}
