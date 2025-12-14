import 'package:flutter/material.dart';
import 'package:core/core.dart';

class AdminSettingsView extends StatelessWidget {
  const AdminSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text('Admin Settings'),
        variant: AppBarVariant.primary,
      ),
      body: Center(
        child: OsmeaComponents.text('Admin Settings View'),
      ),
    );
  }
}
