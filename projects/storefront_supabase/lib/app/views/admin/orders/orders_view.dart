import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_supabase/app/models/order.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text(l10n.orders),
        variant: AppBarVariant.primary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
            return Center(child: Text('${l10n.errorPrefix}${snapshot.error}'));
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text(l10n.noOrdersFound));
          }
          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text('${l10n.orderNumber}${order.orderNumber}'),
                subtitle: Text(
                    '${l10n.userPrefix}${order.user?.username != null ? '@${order.user!.username}' : (order.user?.fullName ?? 'N/A')} - ${l10n.totalPrefix}\$${order.total.toStringAsFixed(2)}'),
                trailing: Text(order.status),
              );
            },
          );
        },
      ),
    );
  }
}
