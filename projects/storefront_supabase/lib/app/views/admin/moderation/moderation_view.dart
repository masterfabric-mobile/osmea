import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:intl/intl.dart';
import 'package:storefront_supabase/app/api/admin/admin_routes.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_moderation_service.dart';
import 'package:storefront_supabase/app/core/config/config_di.dart';
import 'package:storefront_supabase/app/models/product_moderation_entry.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class AdminModerationView extends StatefulWidget {
  const AdminModerationView({
    super.key,
    required this.goRoute,
  });

  final void Function(String path) goRoute;

  @override
  State<AdminModerationView> createState() => _AdminModerationViewState();
}

class _AdminModerationViewState extends State<AdminModerationView> {
  late Future<List<ProductModerationEntry>> _items;
  String? _status;

  AdminModerationService get _service => getIt<AdminModerationService>();

  @override
  void initState() {
    super.initState();
    _items = _service.listModeration(status: _status);
  }

  Future<void> _refresh() async {
    setState(() {
      _items = _service.listModeration(status: _status);
    });
  }

  Future<void> _setStatus(ProductModerationEntry item, String status) async {
    try {
      await _service.updateModeration(item.id, {'status': status});
      _refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: OsmeaComponents.text(
            '${context.resources.errorPrefix}$e',
            color: OsmeaColors.white,
          ),
          backgroundColor: OsmeaColors.amberFlame,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.paperWhite,
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text(resources.moderation, color: OsmeaColors.black),
        variant: AppBarVariant.primary,
        backgroundColor: OsmeaColors.white,
        foregroundColor: OsmeaColors.black,
        leading: OsmeaComponents.iconButton(
          onPressed: () => widget.goRoute(AdminRoutes.dashboard),
          icon: Icon(Icons.arrow_back, color: OsmeaColors.black),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: context.horizontalPaddingNormal + context.verticalPaddingLow,
            child: Wrap(
              spacing: context.spacing8,
              children: [
                _statusChip(context, 'All', null),
                _statusChip(context, resources.pending, 'pending'),
                _statusChip(context, resources.approved, 'approved'),
                _statusChip(context, resources.rejected, 'rejected'),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<List<ProductModerationEntry>>(
                future: _items,
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
                        'No moderation items found.',
                        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.thunder),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: context.paddingNormal,
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final item = list[i];
                      final time = DateFormat.yMMMd().add_Hm().format(item.createdAt.toLocal());
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
                              item.productName ?? item.productId ?? context.resources.unknownProduct,
                              textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: OsmeaColors.black,
                                  ),
                            ),
                            OsmeaComponents.sizedBox(height: context.spacing4),
                            OsmeaComponents.text(
                              'Status: ${item.status} · $time',
                              textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.slate),
                            ),
                            if (item.note != null && item.note!.isNotEmpty) ...[
                              OsmeaComponents.sizedBox(height: context.spacing4),
                              OsmeaComponents.text(
                                item.note!,
                                textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.thunder),
                              ),
                            ],
                            OsmeaComponents.sizedBox(height: context.spacing8),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () => _setStatus(item, 'approved'),
                                  child: OsmeaComponents.text(context.resources.approve, color: OsmeaColors.black),
                                ),
                                TextButton(
                                  onPressed: () => _setStatus(item, 'rejected'),
                                  child: OsmeaComponents.text(context.resources.reject, color: OsmeaColors.amberFlame),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(BuildContext context, String label, String? value) {
    final selected = _status == value;
    return FilterChip(
      label: OsmeaComponents.text(label, color: OsmeaColors.black),
      selected: selected,
      onSelected: (_) {
        setState(() {
          _status = value;
          _items = _service.listModeration(status: _status);
        });
      },
    );
  }
}
