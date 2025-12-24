import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:storefront_supabase/app/models/app_user.dart';
import 'package:storefront_supabase/app/views/admin/settings/models/states.dart';
import 'package:storefront_supabase/app/views/admin/settings/models/view_model.dart';
import 'package:storefront_supabase/l10n/app_localizations.dart';

class AdminSettingsView
    extends MasterViewCubit<AdminSettingsViewModel, AdminSettingsState> {
  AdminSettingsView({
    super.key,
    required super.goRoute,
    super.arguments = const {'init': true},
  }) : super(
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(AppLocalizations.of(context)!.adminSettings),
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
    final l10n = AppLocalizations.of(context)!;
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
            Text(l10n.adminInformation, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildInfoRow(l10n.emailLabel, adminUser.email ?? 'N/A'),
            _buildInfoRow(l10n.fullNameLabel, adminUser.fullName ?? 'N/A'),
            _buildInfoRow(l10n.roleLabel, adminUser.role ?? 'N/A'),
            _buildInfoRow(l10n.memberSinceLabel, adminUser.createdAt.toLocal().toString().split(' ')[0]),
            // Add more admin-specific settings or information here
          ],
        ),
      );
    }
    return Center(child: Text(l10n.unexpectedError));
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
