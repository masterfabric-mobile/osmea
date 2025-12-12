import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_supabase/app/models/order.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    final response = await Supabase.instance.client.from('orders').select();
    return (response as List)
        .map((e) => Order.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text('Orders'),
        variant: AppBarVariant.primary,
      ),
      body: FutureBuilder<List<Order>>(
        future: _orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }
          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text('Order #${order.orderNumber}'),
                subtitle: Text('Total: \$${order.total.toStringAsFixed(2)}'),
                trailing: Text(order.status),
              );
            },
          );
        },
      ),
    );
  }
}
