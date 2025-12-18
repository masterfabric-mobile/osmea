import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:storefront_supabase/app/models/app_user.dart';
import 'package:storefront_supabase/app/views/admin/settings/models/states.dart';
import 'package:storefront_supabase/app/views/admin/settings/models/view_model.dart';

class AdminSettingsView
    extends MasterViewCubit<AdminSettingsViewModel, AdminSettingsState> {
  AdminSettingsView({
    super.key,
    required super.goRoute,
    super.arguments = const {'init': true},
  }) : super(
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text('Admin Settings'),
            variant: AppBarVariant.primary,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            leading: OsmeaComponents.iconButton(
              onPressed: () => goRoute('/profile'),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        );

  @override
  void initialContent(AdminSettingsViewModel viewModel, BuildContext context) {
    viewModel.fetchAdminInfo();
  }

  @override
  Widget viewContent(
      BuildContext context, AdminSettingsViewModel viewModel, AdminSettingsState state) {
    if (state is AdminSettingsLoading || state is AdminSettingsInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AdminSettingsError) {
      return Center(child: Text(state.message));
    }

    if (state is AdminSettingsLoaded) {
      final AppUser adminUser = state.adminUser;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Admin Information', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildInfoRow('Email:', adminUser.email ?? 'N/A'),
            _buildInfoRow('Full Name:', adminUser.fullName ?? 'N/A'),
            _buildInfoRow('Role:', adminUser.role ?? 'N/A'),
            _buildInfoRow('Member Since:', adminUser.createdAt.toLocal().toString().split(' ')[0]),
            // Add more admin-specific settings or information here
          ],
        ),
      );
    }
    return const Center(child: Text('An unexpected error occurred.'));
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
