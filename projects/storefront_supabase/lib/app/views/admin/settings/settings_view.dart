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
              _buildSectionTitle(context, 'General settings'),
              OsmeaComponents.sizedBox(height: 4),
              OsmeaComponents.text(
                'Common store options. Values are saved in admin_settings table.',
                textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.slate),
              ),
              OsmeaComponents.sizedBox(height: context.spacing8),
              _GeneralSettingsCard(service: getIt<AdminStoreSettingsService>()),
              OsmeaComponents.sizedBox(height: context.spacing24),
              _buildSectionTitle(context, 'Store settings (key-value)'),
              OsmeaComponents.sizedBox(height: 4),
              OsmeaComponents.text(
                'All key-value pairs from admin_settings. Tap a row to edit value, or add a new key (e.g. maintenance_mode, guest_checkout_enabled).',
                textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.slate),
              ),
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

/// Predefined general options (maintenance_mode, guest_checkout_enabled, default_currency).
class _GeneralSettingsCard extends StatefulWidget {
  const _GeneralSettingsCard({required this.service});

  final AdminStoreSettingsService service;

  @override
  State<_GeneralSettingsCard> createState() => _GeneralSettingsCardState();
}

class _GeneralSettingsCardState extends State<_GeneralSettingsCard> {
  static const String _keyMaintenance = 'maintenance_mode';
  static const String _keyGuestCheckout = 'guest_checkout_enabled';
  static const String _keyDefaultCurrency = 'default_currency';

  late Future<Map<String, String?>> _valuesFuture;

  @override
  void initState() {
    super.initState();
    _valuesFuture = _loadValues();
  }

  Future<Map<String, String?>> _loadValues() async {
    final list = await widget.service.listSettings();
    final map = <String, String?>{};
    for (final s in list) {
      map[s.key] = s.value;
    }
    return map;
  }

  bool _boolValue(Map<String, String?> map, String key) {
    final v = map[key]?.toLowerCase();
    return v == 'true' || v == '1' || v == 'yes';
  }

  Future<void> _setBool(String key, bool value) async {
    await widget.service.setSetting(key, value.toString());
    setState(() {
      _valuesFuture = _loadValues();
    });
  }

  Future<void> _setString(String key, String value) async {
    await widget.service.setSetting(key, value);
    setState(() {
      _valuesFuture = _loadValues();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: _valuesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return OsmeaComponents.container(
            padding: context.paddingNormal,
            decoration: BoxDecoration(
              color: OsmeaColors.white,
              borderRadius: context.borderRadiusNormal,
              border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
            ),
            child: OsmeaComponents.center(
              child: OsmeaComponents.loading(
                type: LoadingType.circularFade,
                size: 24,
                color: OsmeaColors.black,
              ),
            ),
          );
        }
        final values = snapshot.data ?? {};
        final maintenance = _boolValue(values, _keyMaintenance);
        final guestCheckout = _boolValue(values, _keyGuestCheckout);
        final defaultCurrency = values[_keyDefaultCurrency] ?? '';

        return OsmeaComponents.container(
          decoration: BoxDecoration(
            color: OsmeaColors.white,
            borderRadius: context.borderRadiusNormal,
            border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _buildGeneralRow(
                context,
                title: 'Maintenance mode',
                subtitle: 'When on, store can show a maintenance message to customers.',
                value: maintenance,
                onChanged: (v) => _setBool(_keyMaintenance, v),
              ),
              Divider(height: 1, color: OsmeaColors.silver.withOpacity(0.4)),
              _buildGeneralRow(
                context,
                title: 'Guest checkout',
                subtitle: 'Allow checkout without creating an account.',
                value: guestCheckout,
                onChanged: (v) => _setBool(_keyGuestCheckout, v),
              ),
              Divider(height: 1, color: OsmeaColors.silver.withOpacity(0.4)),
              _buildCurrencyRow(context, defaultCurrency),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGeneralRow(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: context.verticalPaddingNormal + context.horizontalPaddingNormal,
      child: Row(
        children: [
          Expanded(
            child: Column(
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
                  textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.slate),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: OsmeaColors.black,
          ),
        ],
      ),
    );
  }

  static const List<String> _currencyOptions = ['USD', 'EUR', 'TRY', 'GBP'];

  Widget _buildCurrencyRow(BuildContext context, String currentValue) {
    final selected = currentValue.trim().isEmpty
        ? 'USD'
        : currentValue.trim().toUpperCase();
    return Padding(
      padding: context.verticalPaddingNormal + context.horizontalPaddingNormal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          OsmeaComponents.text(
            'Default currency',
            textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: OsmeaColors.black,
                ),
          ),
          OsmeaComponents.sizedBox(height: 2),
          OsmeaComponents.text(
            'Shown as store default on the main app. Used when user has not chosen a currency.',
            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.slate),
          ),
          OsmeaComponents.sizedBox(height: context.spacing12),
          Wrap(
            spacing: context.spacing8,
            runSpacing: context.spacing8,
            children: _currencyOptions.map((code) {
              final isSelected = selected == code;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _setString(_keyDefaultCurrency, code),
                  borderRadius: context.borderRadiusNormal,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.spacing16,
                      vertical: context.spacing10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? OsmeaColors.black : OsmeaColors.white,
                      borderRadius: context.borderRadiusNormal,
                      border: Border.all(
                        color: isSelected ? OsmeaColors.black : OsmeaColors.silver,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: OsmeaComponents.text(
                      code,
                      textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected ? OsmeaColors.white : OsmeaColors.black,
                          ),
                    ),
                  ),
                ),
              );
            }).toList(),
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

  static const List<({String key, String hint})> _suggestedKeys = [
    (key: 'maintenance_mode', hint: 'true / false'),
    (key: 'guest_checkout_enabled', hint: 'true / false'),
    (key: 'default_currency', hint: 'USD, EUR, TRY'),
    (key: 'order_auto_confirm', hint: 'true / false'),
    (key: 'max_cart_items', hint: 'number'),
  ];

  Future<void> _addSetting(BuildContext context) async {
    final keyController = TextEditingController();
    final valueController = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: OsmeaComponents.text('Add key-value setting', color: OsmeaColors.black),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OsmeaComponents.text(
                'Add a new setting stored in admin_settings. Key is unique (e.g. maintenance_mode). Value can be text or true/false.',
                textStyle: Theme.of(ctx).textTheme.bodySmall?.copyWith(color: OsmeaColors.slate),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: keyController,
                decoration: InputDecoration(
                  labelText: 'Key',
                  border: const OutlineInputBorder(),
                  hintText: 'e.g. maintenance_mode',
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  for (final s in _suggestedKeys)
                    ActionChip(
                      label: OsmeaComponents.text(s.key, color: OsmeaColors.black),
                      onPressed: () {
                        keyController.text = s.key;
                        valueController.text = s.hint.startsWith('true') ? 'false' : (s.hint == 'number' ? '99' : s.hint.split(', ').first);
                      },
                    ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: valueController,
                decoration: const InputDecoration(
                  labelText: 'Value',
                  border: OutlineInputBorder(),
                  hintText: 'e.g. true, false, USD, 100',
                ),
                maxLines: 2,
              ),
            ],
          ),
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
