import 'dart:convert';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:storefront_supabase/app/api/admin/admin_routes.dart';

/// Admin view: full-screen App Config (app_config.json) read-only display with copy/export.
/// Adapted for admin section as a dedicated view (apis-style admin screens).
const List<String> _appConfigSectionKeys = [
  'app_settings',
  'api_configuration',
  'supabase_configuration',
  'ui_configuration',
  'feature_flags',
  'splash_configuration',
  'localization_configuration',
  'auth_configuration',
  'onboarding_configuration',
  'account_configuration',
];

class AdminAppConfigView extends StatefulWidget {
  const AdminAppConfigView({
    super.key,
    required this.goRoute,
  });

  final void Function(String path) goRoute;

  @override
  State<AdminAppConfigView> createState() => _AdminAppConfigViewState();
}

class _AdminAppConfigViewState extends State<AdminAppConfigView> {
  final AssetConfigHelper _configHelper = AssetConfigHelper();

  String _formatSectionKey(String key) {
    return key
        .split('_')
        .map((e) => e.isEmpty ? e : '${e[0].toUpperCase()}${e.substring(1)}')
        .join(' ');
  }

  Map<String, dynamic> _collectFullConfig() {
    final map = <String, dynamic>{};
    for (final key in _appConfigSectionKeys) {
      final obj = _configHelper.getObject(key);
      if (obj != null && obj.isNotEmpty) map[key] = obj;
    }
    return map;
  }

  Future<void> _copyFullConfig() async {
    final map = _collectFullConfig();
    final json = const JsonEncoder.withIndent('  ').convert(map);
    await Clipboard.setData(ClipboardData(text: json));
    if (mounted) {
      context.snackbarWarning('App config copied to clipboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.paperWhite,
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text(
          'App config',
          color: OsmeaColors.black,
        ),
        variant: AppBarVariant.primary,
        backgroundColor: OsmeaColors.white,
        foregroundColor: OsmeaColors.black,
        leading: OsmeaComponents.iconButton(
          onPressed: () => widget.goRoute(AdminRoutes.settings),
          icon: Icon(Icons.arrow_back, color: OsmeaColors.black),
        ),
        actions: [
          AppBarAction(
            type: AppBarActionType.secondary,
            icon: Icon(Icons.copy, color: OsmeaColors.black),
            tooltip: 'Copy full config (JSON)',
            onPressed: _copyFullConfig,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OsmeaComponents.text(
              'Read-only app_config.json content. Use Copy to clipboard to export.',
              textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: OsmeaColors.slate,
                  ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),
            for (final sectionKey in _appConfigSectionKeys) ...[
              _buildSectionCard(context, sectionKey),
              OsmeaComponents.sizedBox(height: context.spacing12),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, String sectionKey) {
    final section = _configHelper.getObject(sectionKey);
    final sectionTitle = _formatSectionKey(sectionKey);
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
            _buildKeyValues(context, section, sectionKey),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyValues(
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
