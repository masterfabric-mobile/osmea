import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:storefront_supabase/app/api/admin/admin_routes.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_orders_service.dart';
import 'package:storefront_supabase/app/core/config/config_di.dart';
import 'package:storefront_supabase/app/models/order.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class AdminOrdersView extends StatefulWidget {
  const AdminOrdersView({super.key});

  @override
  State<AdminOrdersView> createState() => _AdminOrdersViewState();
}

class _AdminOrdersViewState extends State<AdminOrdersView> {
  late Future<List<Order>> _orders;

  AdminOrdersService get _ordersService => getIt<AdminOrdersService>();

  @override
  void initState() {
    super.initState();
    _orders = _ordersService.listOrders(includeUser: true);
  }

  Future<void> _refresh() async {
    setState(() {
      _orders = _ordersService.listOrders(includeUser: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.paperWhite,
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text(
          resources.orders,
          color: OsmeaColors.black,
        ),
        variant: AppBarVariant.primary,
        backgroundColor: OsmeaColors.white,
        foregroundColor: OsmeaColors.black,
        leading: OsmeaComponents.iconButton(
          onPressed: () => context.go(AdminRoutes.dashboard),
          icon: Icon(Icons.arrow_back, color: OsmeaColors.black),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refresh(),
        child: FutureBuilder<List<Order>>(
          future: _orders,
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
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return OsmeaComponents.center(
                child: OsmeaComponents.text(
                  resources.noOrdersFound,
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.thunder),
                ),
              );
            }
            final orders = snapshot.data!;
            return ListView.builder(
              padding: context.paddingNormal,
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OsmeaComponents.container(
                  margin: EdgeInsets.only(bottom: context.spacing12),
                  decoration: BoxDecoration(
                    color: OsmeaColors.white,
                    borderRadius: context.borderRadiusNormal,
                    border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: OsmeaComponents.listItem(
                    title: OsmeaComponents.text(
                      '${resources.orderNumber}${order.orderNumber}',
                      textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: OsmeaColors.black,
                          ),
                    ),
                    subtitle: OsmeaComponents.text(
                      '${resources.userPrefix}${order.user?.username != null ? '@${order.user!.username}' : (order.user?.fullName ?? 'N/A')} - ${resources.totalPrefix}\$${order.total.toStringAsFixed(2)}',
                      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.slate),
                    ),
                    trailing: OsmeaComponents.text(
                      order.status,
                      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: OsmeaColors.thunder,
                          ),
                    ),
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
