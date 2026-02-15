import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter/material.dart';
import 'package:storefront_supabase/app/models/app_user.dart';
import 'package:storefront_supabase/app/views/admin/settings/models/module/states.dart';
import 'package:storefront_supabase/app/views/admin/settings/models/admin_settings_view_model.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class AdminSettingsView
    extends MasterViewCubit<AdminSettingsViewModel, AdminSettingsState> {
  AdminSettingsView({
    super.key,
    required super.goRoute,
    super.arguments = const {'init': true},
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.horizontalPadding = const PaddingVisibility.disabled(),
  }) : super(
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(
              context.resources.adminSettings,
              color: OsmeaColors.black,
            ),
            variant: AppBarVariant.primary,
            backgroundColor: OsmeaColors.white,
            foregroundColor: OsmeaColors.black,
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
      return Center(
      child: OsmeaComponents.loading(
        type: LoadingType.circularFade,
        size: 36,
        color: OsmeaColors.black,
      ),
    );
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
            OsmeaComponents.text(
              resources.adminInformation,
              textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: OsmeaColors.black),
            ),
            OsmeaComponents.sizedBox(height: 16),
            _buildInfoRow(resources.emailLabel, adminUser.email ?? 'N/A'),
            _buildInfoRow(resources.fullNameLabel, adminUser.fullName ?? 'N/A'),
            _buildInfoRow(resources.roleLabel, adminUser.role ?? 'N/A'),
            _buildInfoRow(resources.memberSinceLabel, adminUser.createdAt.toLocal().toString().split(' ')[0]),
            OsmeaComponents.sizedBox(height: 24),
            OsmeaComponents.text(
              resources.coupons,
              textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: OsmeaColors.black),
            ),
            OsmeaComponents.sizedBox(height: 8),
            _buildSettingsTile(
              context,
              icon: Icons.confirmation_number_outlined,
              title: resources.coupons,
              subtitle: 'Kupon listesi ve kupon ekleme',
              onTap: () => goRoute('/admin/coupons'),
            ),
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
            textStyle: TextStyle(fontWeight: FontWeight.bold, color: OsmeaColors.black),
          ),
          OsmeaComponents.sizedBox(width: 8),
          OsmeaComponents.expanded(
            child: OsmeaComponents.text(value, textStyle: TextStyle(color: OsmeaColors.black)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: OsmeaColors.white,
      child: InkWell(
        onTap: onTap,
        child: OsmeaComponents.padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: OsmeaComponents.row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: OsmeaColors.black, size: 24),
              OsmeaComponents.sizedBox(width: 16),
              OsmeaComponents.expanded(
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OsmeaComponents.text(
                      title,
                      textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: OsmeaColors.black,
                      ),
                    ),
                    OsmeaComponents.sizedBox(height: 2),
                    OsmeaComponents.text(
                      subtitle,
                      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: OsmeaColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: OsmeaColors.black, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}