import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:storefront_supabase/app/models/order.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class AdminOrdersView extends StatefulWidget {
  const AdminOrdersView({super.key});

  @override
  State<AdminOrdersView> createState() => _AdminOrdersViewState();
}

class _AdminOrdersViewState extends State<AdminOrdersView> {
  late final Future<List<Order>> _orders;

  @override
  void initState() {
    super.initState();
    _orders = _fetchOrders();
  }

  Future<List<Order>> _fetchOrders() async {
    final response =
        await Supabase.instance.client.from('orders').select('*, users(*)');
    return (response as List)
        .map((e) => Order.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return OsmeaComponents.scaffold(
      backgroundColor: Colors.white,
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text(
          resources.orders,
          color: Colors.black,
        ),
        variant: AppBarVariant.primary,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: OsmeaComponents.iconButton(
          onPressed: () => context.go('/profile'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: FutureBuilder<List<Order>>(
        future: _orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return OsmeaComponents.center(child: OsmeaComponents.text('${resources.errorPrefix}${snapshot.error}'));
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return OsmeaComponents.center(child: OsmeaComponents.text(resources.noOrdersFound));
          }
          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return OsmeaComponents.listItem(
                title: OsmeaComponents.text('${resources.orderNumber}${order.orderNumber}'),
                subtitle: OsmeaComponents.text(
                    '${resources.userPrefix}${order.user?.username != null ? '@${order.user!.username}' : (order.user?.fullName ?? 'N/A')} - ${resources.totalPrefix}\$${order.total.toStringAsFixed(2)}'),
                trailing: OsmeaComponents.text(order.status),
              );
            },
          );
        },
      ),
    );
  }
}