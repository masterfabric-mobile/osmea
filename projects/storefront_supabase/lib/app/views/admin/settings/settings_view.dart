import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter/material.dart';
import 'package:storefront_supabase/app/api/admin/admin_routes.dart';
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
              onPressed: () => goRoute(AdminRoutes.profile),
              icon: Icon(Icons.arrow_back, color: OsmeaColors.black),
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
      return OsmeaComponents.center(
        child: OsmeaComponents.loading(
          type: LoadingType.circularFade,
          size: 36,
          color: OsmeaColors.black,
        ),
      );
    }

    if (state is AdminSettingsError) {
      return OsmeaComponents.center(
        child: OsmeaComponents.text(
          state.message,
          textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.thunder),
        ),
      );
    }

    if (state is AdminSettingsLoaded) {
      final AppUser adminUser = state.adminUser;
      return RefreshIndicator(
        onRefresh: viewModel.fetchAdminInfo,
        child: OsmeaComponents.singleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: context.paddingNormal,
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle(context, resources.adminInformation),
              OsmeaComponents.sizedBox(height: context.spacing8),
              _buildAdminInfoCard(context, resources, adminUser),
            ],
          ),
        ),
      );
    }

    return OsmeaComponents.center(
      child: OsmeaComponents.text(
        resources.unexpectedError,
        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.thunder),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return OsmeaComponents.text(
      title,
      textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: OsmeaColors.black,
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildAdminInfoCard(BuildContext context, dynamic resources, AppUser adminUser) {
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: context.borderRadiusNormal,
        border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
      ),
      padding: context.paddingNormal,
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(context, resources.emailLabel, adminUser.email ?? 'N/A'),
          _buildInfoRow(context, resources.fullNameLabel, adminUser.fullName ?? 'N/A'),
          _buildInfoRow(context, resources.roleLabel, adminUser.role ?? 'N/A'),
          _buildInfoRow(
            context,
            resources.memberSinceLabel,
            adminUser.createdAt.toLocal().toString().split(' ').first,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return OsmeaComponents.padding(
      padding: context.verticalPaddingLow,
      child: OsmeaComponents.row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            label,
            textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: OsmeaColors.black,
                ),
          ),
          OsmeaComponents.sizedBox(width: context.spacing8),
          OsmeaComponents.expanded(
            child: OsmeaComponents.text(
              value,
              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.thunder),
            ),
          ),
        ],
      ),
    );
  }

}
