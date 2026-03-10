import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:intl/intl.dart';
import 'package:storefront_supabase/app/api/admin/admin_routes.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_sessions_service.dart';
import 'package:storefront_supabase/app/core/config/config_di.dart';
import 'package:storefront_supabase/app/models/admin_session.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class AdminSessionsView extends StatefulWidget {
  const AdminSessionsView({
    super.key,
    required this.goRoute,
  });

  final void Function(String path) goRoute;

  @override
  State<AdminSessionsView> createState() => _AdminSessionsViewState();
}

class _AdminSessionsViewState extends State<AdminSessionsView> {
  late Future<List<AdminSession>> _sessions;

  AdminSessionsService get _service => getIt<AdminSessionsService>();

  @override
  void initState() {
    super.initState();
    _sessions = _service.listSessions();
  }

  Future<void> _refresh() async {
    setState(() {
      _sessions = _service.listSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.paperWhite,
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text('Sessions', color: OsmeaColors.black),
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
        child: FutureBuilder<List<AdminSession>>(
          future: _sessions,
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
                  'No sessions found.',
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.thunder),
                ),
              );
            }
            return ListView.builder(
              padding: context.paddingNormal,
              itemCount: list.length,
              itemBuilder: (context, i) {
                final s = list[i];
                final time = DateFormat.yMMMd().add_Hm().format(s.createdAt.toLocal());
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
                        s.adminEmail ?? s.adminId ?? 'Unknown admin',
                        textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: OsmeaColors.black,
                            ),
                      ),
                      OsmeaComponents.sizedBox(height: context.spacing4),
                      OsmeaComponents.text(
                        'IP: ${s.ipAddress ?? '-'} · $time',
                        textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.slate),
                      ),
                      if (s.userAgent != null && s.userAgent!.isNotEmpty) ...[
                        OsmeaComponents.sizedBox(height: context.spacing4),
                        OsmeaComponents.text(
                          s.userAgent!,
                          textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.thunder),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
