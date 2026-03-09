import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter/material.dart';
import 'package:storefront_supabase/app/models/app_user.dart';
import 'package:storefront_supabase/app/views/admin/settings/models/module/states.dart';
import 'package:storefront_supabase/app/views/admin/settings/models/admin_settings_view_model.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

/// Top-level config keys to show in App Config (read-only from app_config.json).
const List<String> _appConfigSectionKeys = [
  'app_settings',
  'api_configuration',
  'ui_configuration',
  'feature_flags',
  'splash_configuration',
  'localization_configuration',
  'auth_configuration',
];

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
              OsmeaComponents.sizedBox(height: context.spacing24),
              _buildSectionTitle(context, 'Admin shortcuts'),
              OsmeaComponents.sizedBox(height: context.spacing8),
              _buildShortcutsCard(context),
              OsmeaComponents.sizedBox(height: context.spacing24),
              _buildSectionTitle(context, 'App config'),
              OsmeaComponents.sizedBox(height: context.spacing8),
              _buildAppConfigSection(context),
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

  Widget _buildShortcutsCard(BuildContext context) {
    final res = context.resources;
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: context.borderRadiusNormal,
        border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: OsmeaComponents.column(
        children: [
          _buildSettingsTile(context, icon: Icons.dashboard_outlined, title: 'Dashboard', subtitle: '', onTap: () => goRoute('/admin/dashboard')),
          Divider(height: 1, color: OsmeaColors.silver.withOpacity(0.4)),
          _buildSettingsTile(context, icon: Icons.inventory_2_outlined, title: res.products, subtitle: '', onTap: () => goRoute('/admin/products')),
          Divider(height: 1, color: OsmeaColors.silver.withOpacity(0.4)),
          _buildSettingsTile(context, icon: Icons.shopping_bag_outlined, title: res.orders, subtitle: '', onTap: () => goRoute('/admin/orders')),
          Divider(height: 1, color: OsmeaColors.silver.withOpacity(0.4)),
          _buildSettingsTile(context, icon: Icons.people_outline, title: res.users, subtitle: '', onTap: () => goRoute('/admin/users')),
          Divider(height: 1, color: OsmeaColors.silver.withOpacity(0.4)),
          _buildSettingsTile(context, icon: Icons.confirmation_number_outlined, title: res.coupons, subtitle: '', onTap: () => goRoute('/admin/coupons')),
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
          padding: context.verticalPaddingNormal + context.horizontalPaddingNormal,
          child: OsmeaComponents.row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: OsmeaColors.black, size: context.iconSizeNormal),
              OsmeaComponents.sizedBox(width: context.spacing16),
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
                    if (subtitle.isNotEmpty) ...[
                      OsmeaComponents.sizedBox(height: 2),
                      OsmeaComponents.text(
                        subtitle,
                        textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: OsmeaColors.slate,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: OsmeaColors.thunder, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppConfigSection(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final sectionKey in _appConfigSectionKeys) ...[
          _buildConfigExpansionTile(context, configHelper, sectionKey),
          OsmeaComponents.sizedBox(height: context.spacing8),
        ],
      ],
    );
  }

  Widget _buildConfigExpansionTile(
    BuildContext context,
    AssetConfigHelper configHelper,
    String sectionKey,
  ) {
    final section = configHelper.getObject(sectionKey);
    final sectionTitle = _formatConfigKey(sectionKey);
    if (section == null || section.isEmpty) {
      return const SizedBox.shrink();
    }
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: context.borderRadiusNormal,
        border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: OsmeaComponents.text(
            sectionTitle,
            textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: OsmeaColors.black,
                ),
          ),
          iconColor: OsmeaColors.black,
          collapsedIconColor: OsmeaColors.thunder,
          childrenPadding: EdgeInsets.only(
            left: context.spacing16,
            right: context.spacing16,
            bottom: context.spacing16,
          ),
          children: [
            _buildConfigKeyValues(context, section, sectionKey),
          ],
        ),
      ),
    );
  }

  String _formatConfigKey(String key) {
    return key
        .split('_')
        .map((e) => e.isEmpty ? e : '${e[0].toUpperCase()}${e.substring(1)}')
        .join(' ');
  }

  Widget _buildConfigKeyValues(
    BuildContext context,
    Map<String, dynamic> section,
    String sectionPrefix,
  ) {
    final entries = <Widget>[];
    void addEntries(Map<String, dynamic> map, [String prefix = '']) {
      for (final e in map.entries) {
        final k = e.key;
        final v = e.value;
        final fullKey = prefix.isEmpty ? k : '$prefix.$k';
        if (v is Map<String, dynamic>) {
          addEntries(v, fullKey);
        } else {
          final displayValue = _maskSensitive(fullKey, v);
          entries.add(
            OsmeaComponents.padding(
              padding: context.verticalPaddingLow,
              child: OsmeaComponents.row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.text(
                    k,
                    textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: OsmeaColors.thunder,
                        ),
                  ),
                  OsmeaComponents.sizedBox(width: context.spacing8),
                  OsmeaComponents.expanded(
                    child: OsmeaComponents.text(
                      displayValue,
                      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: OsmeaColors.slate,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
    }

    addEntries(section, sectionPrefix);
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: entries.isEmpty
          ? [
              OsmeaComponents.text(
                'No keys',
                textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.slate),
              ),
            ]
          : entries,
    );
  }

  String _maskSensitive(String key, dynamic value) {
    final str = value?.toString() ?? '';
    if (key == 'anon_key' || key.contains('secret')) {
      return str.isEmpty ? '' : '${str.substring(0, str.length > 8 ? 8 : str.length)}***';
    }
    if (value is List) return value.toString();
    if (value is Map) return value.toString();
    return str;
  }
}
