import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// User Settings View - Simple settings page
class UserSettingsView extends StatelessWidget {
  final Function(String) goRoute;
  final Map<String, dynamic> arguments;

  const UserSettingsView({
    super.key,
    required this.goRoute,
    this.arguments = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildSectionHeader(context, 'General'),
          OsmeaComponents.listItem(
            title: OsmeaComponents.text('Notifications'),
            leading: Icon(Icons.notifications_outlined),
            trailing: Icon(Icons.chevron_right),
            onTap: () {},
          ),
          OsmeaComponents.listItem(
            title: OsmeaComponents.text('Language'),
            subtitle: OsmeaComponents.text('English'),
            leading: Icon(Icons.language_outlined),
            trailing: Icon(Icons.chevron_right),
            onTap: () {},
          ),
          _buildSectionHeader(context, 'Privacy'),
          OsmeaComponents.listItem(
            title: OsmeaComponents.text('Privacy Policy'),
            leading: Icon(Icons.privacy_tip_outlined),
            trailing: Icon(Icons.chevron_right),
            onTap: () {},
          ),
          OsmeaComponents.listItem(
            title: OsmeaComponents.text('Terms of Service'),
            leading: Icon(Icons.description_outlined),
            trailing: Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return OsmeaComponents.appBar(
      title: OsmeaComponents.text(
        'Settings',
        textStyle: OsmeaTextStyle.titleLarge(context),
      ),
      backgroundColor: OsmeaColors.paperWhite,
      foregroundColor: OsmeaColors.thunder,
      elevation: 0,
      leading: OsmeaComponents.iconButton(
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/user-profile');
          }
        },
        icon: Icon(Icons.arrow_back, color: OsmeaColors.thunder),
        backgroundColor: OsmeaColors.transparent,
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.spacing16,
        context.spacing16,
        context.spacing16,
        context.spacing8,
      ),
      child: OsmeaComponents.text(
        title,
        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
          color: OsmeaColors.pewter,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
