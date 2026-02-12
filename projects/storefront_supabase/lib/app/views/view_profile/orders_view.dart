import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/app/models/order.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';
import 'package:intl/intl.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({
    super.key,
    required this.goRoute,
  });

  final Function(String) goRoute;

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  List<Order> _orders = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        setState(() {
          _isLoading = false;
          _error = 'Please sign in to view orders.';
        });
        return;
      }

      final response = await _supabaseClient
          .from('orders')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final orders = (response as List)
          .map((json) => Order.fromJson(json as Map<String, dynamic>))
          .toList();

      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading orders: $e');
      setState(() {
        _error = 'Failed to load orders. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;

    return Scaffold(
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text(
          resources.myOrders,
          textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
            fontWeight: FontWeight.w600,
            color: OsmeaColors.black,
          ),
        ),
        variant: AppBarVariant.primary,
        backgroundColor: OsmeaColors.white,
        foregroundColor: OsmeaColors.black,
        elevation: 0,
        leading: OsmeaComponents.iconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: OsmeaColors.black),
          backgroundColor: OsmeaColors.transparent,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadOrders,
        child: _buildBody(context, resources),
      ),
    );
  }

  Widget _buildBody(BuildContext context, dynamic resources) {
    if (_isLoading) {
      return OsmeaComponents.center(
        child: OsmeaComponents.loading(
          type: LoadingType.circularFade,
          size: 48,
          color: OsmeaColors.black,
        ),
      );
    }

    if (_error != null) {
      return OsmeaComponents.center(
        child: Padding(
          padding: EdgeInsets.all(context.spacing24),
          child: OsmeaComponents.column(
            children: [
              Icon(Icons.error_outline, size: 64, color: OsmeaColors.pewter),
              OsmeaComponents.sizedBox(height: context.spacing16),
              OsmeaComponents.text(
                _error!,
                textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                  color: OsmeaColors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (_orders.isEmpty) {
      return OsmeaComponents.center(
        child: Padding(
          padding: EdgeInsets.all(context.spacing24),
          child: OsmeaComponents.column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: OsmeaColors.pewter,
              ),
              OsmeaComponents.sizedBox(height: context.spacing16),
              OsmeaComponents.text(
                'Siparişleriniz eklenince gözükecek',
                textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: OsmeaColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              OsmeaComponents.sizedBox(height: context.spacing8),
              OsmeaComponents.text(
                'Henüz siparişiniz bulunmamaktadır. Siparişleriniz burada görüntülenecektir.',
                textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                  color: OsmeaColors.pewter,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(context.spacing16),
      itemCount: _orders.length,
      separatorBuilder: (context, index) => OsmeaComponents.sizedBox(height: context.spacing12),
      itemBuilder: (context, index) {
        final order = _orders[index];
        return _buildOrderCard(context, order, resources);
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order, dynamic resources) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    final formattedDate = dateFormat.format(order.createdAt);

    return OsmeaComponents.container(
      padding: EdgeInsets.all(context.spacing16),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OsmeaColors.silver, width: 1),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OsmeaComponents.expanded(
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OsmeaComponents.text(
                      order.orderNumber,
                      textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: OsmeaColors.black,
                      ),
                    ),
                    OsmeaComponents.sizedBox(height: context.spacing4),
                    OsmeaComponents.text(
                      formattedDate,
                      textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                        color: OsmeaColors.pewter,
                      ),
                    ),
                  ],
                ),
              ),
              OsmeaComponents.container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: OsmeaComponents.text(
                  order.status.toUpperCase(),
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(order.status),
                  ),
                ),
              ),
            ],
          ),
          OsmeaComponents.sizedBox(height: context.spacing12),
          OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OsmeaComponents.text(
                'Total',
                textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                  color: OsmeaColors.thunder,
                ),
              ),
              OsmeaComponents.text(
                '${order.total.toStringAsFixed(2)} ₺',
                textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: OsmeaColors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'processing':
        return Colors.blue;
      default:
        return OsmeaColors.pewter;
    }
  }
}
