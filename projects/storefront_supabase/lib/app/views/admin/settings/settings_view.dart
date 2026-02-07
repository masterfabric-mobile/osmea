import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter/material.dart';
import 'package:storefront_supabase/app/models/app_user.dart';
import 'package:storefront_supabase/app/views/admin/settings/models/states.dart';
import 'package:storefront_supabase/app/views/admin/settings/models/view_model.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class AdminSettingsView
    extends MasterViewCubit<AdminSettingsViewModel, AdminSettingsState> {
  AdminSettingsView({
    super.key,
    required super.goRoute,
    super.arguments = const {'init': true},
  }) : super(
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(
              context.resources.adminSettings,
              color: Colors.black,
            ),
            variant: AppBarVariant.primary,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
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
    final resources = context.resources;
    if (state is AdminSettingsLoading || state is AdminSettingsInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AdminSettingsError) {
      return OsmeaComponents.center(child: OsmeaComponents.text(state.message));
    }

    if (state is AdminSettingsLoaded) {
      final AppUser adminUser = state.adminUser;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.text(resources.adminInformation, textStyle: Theme.of(context).textTheme.titleLarge),
            OsmeaComponents.sizedBox(height: 16),
            _buildInfoRow(resources.emailLabel, adminUser.email ?? 'N/A'),
            _buildInfoRow(resources.fullNameLabel, adminUser.fullName ?? 'N/A'),
            _buildInfoRow(resources.roleLabel, adminUser.role ?? 'N/A'),
            _buildInfoRow(resources.memberSinceLabel, adminUser.createdAt.toLocal().toString().split(' ')[0]),
            // Add more admin-specific settings or information here
          ],
        ),
      );
    }
    return OsmeaComponents.center(child: OsmeaComponents.text(resources.unexpectedError));
  }

  Widget _buildInfoRow(String label, String value) {
    return OsmeaComponents.padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: OsmeaComponents.row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            label,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
          OsmeaComponents.sizedBox(width: 8),
          OsmeaComponents.expanded(child: OsmeaComponents.text(value)),
        ],
      ),
    );
  }
}