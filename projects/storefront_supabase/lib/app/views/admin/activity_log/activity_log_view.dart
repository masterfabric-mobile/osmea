import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:intl/intl.dart';
import 'package:storefront_supabase/app/api/admin/admin_routes.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_activity_log_service.dart';
import 'package:storefront_supabase/app/core/config/config_di.dart';
import 'package:storefront_supabase/app/models/admin_activity_log_entry.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class AdminActivityLogView extends StatefulWidget {
  const AdminActivityLogView({
    super.key,
    required this.goRoute,
  });

  final void Function(String path) goRoute;

  @override
  State<AdminActivityLogView> createState() => _AdminActivityLogViewState();
}

class _AdminActivityLogViewState extends State<AdminActivityLogView> {
  late Future<List<AdminActivityLogEntry>> _logs;

  AdminActivityLogService get _service => getIt<AdminActivityLogService>();

  @override
  void initState() {
    super.initState();
    _logs = _service.listLogs();
  }

  Future<void> _refresh() async {
    setState(() {
      _logs = _service.listLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.paperWhite,
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text(resources.activityLog, color: OsmeaColors.black),
        variant: AppBarVariant.primary,
        backgroundColor: OsmeaColors.white,
        foregroundColor: OsmeaColors.black,
        leading: OsmeaComponents.iconButton(
          onPressed: () => widget.goRoute(AdminRoutes.dashboard),
          icon: Icon(Icons.arrow_back, color: OsmeaColors.black),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<AdminActivityLogEntry>>(
          future: _logs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return OsmeaComponents.center(
                child: OsmeaComponents.loading(
                  type: LoadingType.circularFade,
                  size: 36,
                  color: OsmeaColors.black,
                ),
              );
            }
            if (snapshot.hasError) {
              return OsmeaComponents.center(
                child: OsmeaComponents.text(
                  '${resources.errorPrefix}${snapshot.error}',
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.thunder),
                ),
              );
            }
            final list = snapshot.data ?? [];
            if (list.isEmpty) {
              return OsmeaComponents.center(
                child: OsmeaComponents.text(
                  'No log entries found.',
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.thunder),
                ),
              );
            }
            return ListView.builder(
              padding: context.paddingNormal,
              itemCount: list.length,
              itemBuilder: (context, i) {
                final e = list[i];
                final time = DateFormat.yMMMd().add_Hm().format(e.createdAt.toLocal());
                return OsmeaComponents.container(
                  margin: EdgeInsets.only(bottom: context.spacing12),
                  decoration: BoxDecoration(
                    color: OsmeaColors.white,
                    borderRadius: context.borderRadiusNormal,
                    border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
                  ),
                  padding: context.paddingNormal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OsmeaComponents.text(
                        e.action,
                        textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: OsmeaColors.black,
                            ),
                      ),
                      OsmeaComponents.sizedBox(height: context.spacing4),
                      OsmeaComponents.text(
                        '${e.adminEmail ?? e.adminId ?? 'Unknown'} · $time',
                        textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.slate),
                      ),
                      if ((e.targetTable != null && e.targetTable!.isNotEmpty) || (e.targetId != null && e.targetId!.isNotEmpty)) ...[
                        OsmeaComponents.sizedBox(height: context.spacing4),
                        OsmeaComponents.text(
                          'Target: ${e.targetTable ?? '-'} / ${e.targetId ?? '-'}',
                          textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.thunder),
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
