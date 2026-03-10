import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter/material.dart';
import 'package:storefront_supabase/app/api/admin/admin_routes.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_store_settings_service.dart';
import 'package:storefront_supabase/app/core/config/config_di.dart';
import 'package:storefront_supabase/app/models/admin_setting.dart';
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
              OsmeaComponents.sizedBox(height: context.spacing24),
              _buildSectionTitle(context, 'Store settings'),
              OsmeaComponents.sizedBox(height: context.spacing8),
              _StoreSettingsSection(service: getIt<AdminStoreSettingsService>()),
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

class _StoreSettingsSection extends StatefulWidget {
  const _StoreSettingsSection({required this.service});

  final AdminStoreSettingsService service;

  @override
  State<_StoreSettingsSection> createState() => _StoreSettingsSectionState();
}

class _StoreSettingsSectionState extends State<_StoreSettingsSection> {
  late Future<List<AdminSetting>> _settingsFuture;

  @override
  void initState() {
    super.initState();
    _settingsFuture = widget.service.listSettings();
  }

  void _refresh() {
    setState(() {
      _settingsFuture = widget.service.listSettings();
    });
  }

  Future<void> _addSetting(BuildContext context) async {
    final keyController = TextEditingController();
    final valueController = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: OsmeaComponents.text('Add setting', color: OsmeaColors.black),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: keyController,
              decoration: const InputDecoration(
                labelText: 'Key',
                border: OutlineInputBorder(),
                hintText: 'e.g. maintenance_mode',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: OsmeaComponents.text('Cancel', color: OsmeaColors.thunder),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: OsmeaComponents.text('Add', color: OsmeaColors.black),
          ),
        ],
      ),
    );
    if (saved == true && keyController.text.trim().isNotEmpty && context.mounted) {
      await widget.service.setSetting(
        keyController.text.trim(),
        valueController.text.trim(),
      );
      _refresh();
    }
  }

  Future<void> _editSetting(BuildContext context, AdminSetting setting) async {
    final controller = TextEditingController(text: setting.value ?? '');
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: OsmeaComponents.text(setting.key, color: OsmeaColors.black),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Value',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: OsmeaComponents.text('Cancel', color: OsmeaColors.thunder),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: OsmeaComponents.text('Save', color: OsmeaColors.black),
          ),
        ],
      ),
    );
    if (saved == true && context.mounted) {
      await widget.service.setSetting(setting.key, controller.text.trim());
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AdminSetting>>(
      future: _settingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return OsmeaComponents.center(
            child: Padding(
              padding: context.paddingNormal,
              child: OsmeaComponents.loading(
                type: LoadingType.circularFade,
                size: 28,
                color: OsmeaColors.black,
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return OsmeaComponents.container(
            padding: context.paddingNormal,
            decoration: BoxDecoration(
              color: OsmeaColors.white,
              borderRadius: context.borderRadiusNormal,
              border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
            ),
            child: OsmeaComponents.text(
              '${context.resources.errorPrefix}${snapshot.error}',
              textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.thunder),
            ),
          );
        }
        final settings = snapshot.data ?? [];
        if (settings.isEmpty) {
          return OsmeaComponents.container(
            padding: context.paddingNormal,
            decoration: BoxDecoration(
              color: OsmeaColors.white,
              borderRadius: context.borderRadiusNormal,
              border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
            ),
            child: OsmeaComponents.column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OsmeaComponents.text(
                  'No store settings yet.',
                  textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.slate),
                ),
                OsmeaComponents.sizedBox(height: context.spacing12),
                TextButton.icon(
                  onPressed: () => _addSetting(context),
                  icon: Icon(Icons.add, size: 20, color: OsmeaColors.black),
                  label: OsmeaComponents.text('Add setting', color: OsmeaColors.black),
                ),
              ],
            ),
          );
        }
        return OsmeaComponents.container(
          decoration: BoxDecoration(
            color: OsmeaColors.white,
            borderRadius: context.borderRadiusNormal,
            border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < settings.length; i++) ...[
                if (i > 0) Divider(height: 1, color: OsmeaColors.silver.withOpacity(0.4)),
                Material(
                  color: OsmeaColors.white,
                  child: InkWell(
                    onTap: () => _editSetting(context, settings[i]),
                    child: Padding(
                      padding: context.verticalPaddingNormal + context.horizontalPaddingNormal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: OsmeaComponents.column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                OsmeaComponents.text(
                                  settings[i].key,
                                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: OsmeaColors.black,
                                      ),
                                ),
                                OsmeaComponents.sizedBox(height: 2),
                                OsmeaComponents.text(
                                  settings[i].value ?? '(empty)',
                                  textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: OsmeaColors.slate,
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.edit_outlined, size: 20, color: OsmeaColors.thunder),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              Divider(height: 1, color: OsmeaColors.silver.withOpacity(0.4)),
              Material(
                color: OsmeaColors.white,
                child: InkWell(
                  onTap: () => _addSetting(context),
                  child: Padding(
                    padding: context.verticalPaddingNormal + context.horizontalPaddingNormal,
                    child: Row(
                      children: [
                        Icon(Icons.add_circle_outline, size: 22, color: OsmeaColors.black),
                        OsmeaComponents.sizedBox(width: context.spacing8),
                        OsmeaComponents.text(
                          'Add setting',
                          textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: OsmeaColors.black,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
