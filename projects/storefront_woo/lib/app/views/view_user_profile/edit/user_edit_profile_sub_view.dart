import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// User Edit Profile View - Simple edit profile page
class UserEditProfileView extends StatelessWidget {
  final Function(String) goRoute;
  final Map<String, dynamic> arguments;

  const UserEditProfileView({
    super.key,
    required this.goRoute,
    this.arguments = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListView(
        padding: EdgeInsets.all(context.spacing16),
        children: [
          OsmeaComponents.text(
            'Edit Profile',
            textStyle: OsmeaTextStyle.titleLarge(context),
          ),
          OsmeaComponents.sizedBox(height: context.spacing16),
          OsmeaComponents.text(
            'Profile editing functionality will be implemented here.',
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: OsmeaColors.pewter,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return OsmeaComponents.appBar(
      title: OsmeaComponents.text(
        'Edit Profile',
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
}
