/*
 * OrdersWidgets
 * -------------
 * Widgets for the orders view.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_orders/models/module/states.dart';

/// Orders list widget
class OrdersListWidget extends StatelessWidget {
  final List<OrderItem> orders;
  final Function(String orderKey) onOrderTap;

  const OrdersListWidget({
    super.key,
    required this.orders,
    required this.onOrderTap,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: OsmeaComponents.column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: context.iconSizeLarge,
              color: OsmeaColors.pewter,
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),
            OsmeaComponents.text(
              'No orders yet',
              textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                color: OsmeaColors.pewter,
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing8),
            OsmeaComponents.text(
              'Your orders will appear here',
              textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                color: OsmeaColors.pewter,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(context.spacing16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderListItem(
          order: order,
          onTap: () => onOrderTap(order.orderKey),
        );
      },
    );
  }
}

/// Order list item widget
class OrderListItem extends StatelessWidget {
  final OrderItem order;
  final VoidCallback onTap;

  const OrderListItem({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: context.spacing12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(context.spacing16),
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OsmeaComponents.row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OsmeaComponents.text(
                    'Order #${order.orderNumber ?? order.orderKey.substring(0, 8)}',
                    textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  _buildStatusChip(context, order.status),
                ],
              ),
              OsmeaComponents.sizedBox(height: context.spacing8),
              if (order.dateCreated != null)
                OsmeaComponents.text(
                  'Date: ${_formatDate(order.dateCreated!)}',
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    color: OsmeaColors.pewter,
                  ),
                ),
              OsmeaComponents.sizedBox(height: context.spacing8),
              OsmeaComponents.row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OsmeaComponents.text(
                    'Total',
                    textStyle: OsmeaTextStyle.bodyMedium(context),
                  ),
                  OsmeaComponents.text(
                    '${order.currencySymbol ?? ''}${order.total?.toStringAsFixed(2) ?? '0.00'}',
                    textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                      fontWeight: FontWeight.w700,
                      color: OsmeaColors.nordicBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String? status) {
    final statusColor = _getStatusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing8,
        vertical: context.spacing4,
      ),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: OsmeaComponents.text(
        status?.toUpperCase() ?? 'UNKNOWN',
        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
          color: statusColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return OsmeaColors.green;
      case 'processing':
        return OsmeaColors.nordicBlue;
      case 'pending':
        return OsmeaColors.orange;
      case 'cancelled':
        return OsmeaColors.red;
      case 'refunded':
        return OsmeaColors.pewter;
      default:
        return OsmeaColors.pewter;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

/// Order detail widget
class OrderDetailWidget extends StatelessWidget {
  final OrderItem order;

  const OrderDetailWidget({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.spacing16),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Order Summary Card
          _buildCard(
            context,
            title: 'Order Summary',
            children: [
              _buildDetailRow(
                context,
                label: 'Order Number',
                value: order.orderNumber ?? order.orderKey.substring(0, 8),
              ),
              _buildDetailRow(
                context,
                label: 'Status',
                value: order.status?.toUpperCase() ?? 'UNKNOWN',
              ),
              if (order.dateCreated != null)
                _buildDetailRow(
                  context,
                  label: 'Date',
                  value: _formatDate(order.dateCreated!),
                ),
              _buildDetailRow(
                context,
                label: 'Total',
                value: '${order.currencySymbol ?? ''}${order.total?.toStringAsFixed(2) ?? '0.00'}',
                isHighlighted: true,
              ),
            ],
          ),
          OsmeaComponents.sizedBox(height: context.spacing16),

          // Order Items Card
          if (order.lineItems != null && order.lineItems!.isNotEmpty)
            _buildCard(
              context,
              title: 'Order Items',
              children: [
                for (final item in order.lineItems!)
                  _buildOrderItemRow(context, item),
              ],
            ),
          if (order.lineItems != null && order.lineItems!.isNotEmpty)
            OsmeaComponents.sizedBox(height: context.spacing16),

          // Billing Address Card
          if (order.billingAddress != null)
            _buildCard(
              context,
              title: 'Billing Address',
              children: [
                _buildAddress(context, order.billingAddress),
              ],
            ),
          if (order.billingAddress != null)
            OsmeaComponents.sizedBox(height: context.spacing16),

          // Shipping Address Card
          if (order.shippingAddress != null)
            _buildCard(
              context,
              title: 'Shipping Address',
              children: [
                _buildAddress(context, order.shippingAddress),
              ],
            ),
          if (order.shippingAddress != null)
            OsmeaComponents.sizedBox(height: context.spacing16),

          // Payment Method Card
          if (order.paymentMethod != null)
            _buildCard(
              context,
              title: 'Payment Method',
              children: [
                _buildDetailRow(
                  context,
                  label: 'Method',
                  value: order.paymentMethod?.toUpperCase() ?? 'UNKNOWN',
                ),
              ],
            ),
          if (order.paymentMethod != null)
            OsmeaComponents.sizedBox(height: context.spacing16),

          // Customer Notes Card
          if (order.customerNote != null && order.customerNote!.isNotEmpty)
            _buildCard(
              context,
              title: 'Customer Notes',
              children: [
                OsmeaComponents.text(
                  order.customerNote!,
                  textStyle: OsmeaTextStyle.bodyMedium(context),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(context.spacing16),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.text(
              title,
              textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing8),
      child: OsmeaComponents.row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OsmeaComponents.text(
            label,
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: OsmeaColors.pewter,
            ),
          ),
          OsmeaComponents.text(
            value,
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.normal,
              color: isHighlighted ? OsmeaColors.nordicBlue : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemRow(BuildContext context, dynamic item) {
    final name = item['name'] ?? 'Unknown Product';
    final quantity = item['quantity'] ?? 1;
    final price = item['price'] ?? 0.0;
    final total = (price * quantity).toStringAsFixed(2);

    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing12),
      child: OsmeaComponents.row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.text(
                  name,
                  textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                OsmeaComponents.sizedBox(height: context.spacing4),
                OsmeaComponents.text(
                  'Qty: $quantity',
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    color: OsmeaColors.pewter,
                  ),
                ),
              ],
            ),
          ),
          OsmeaComponents.text(
            '${order.currencySymbol ?? ''}$total',
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddress(BuildContext context, dynamic address) {
    final firstName = address['first_name'] ?? '';
    final lastName = address['last_name'] ?? '';
    final address1 = address['address_1'] ?? '';
    final address2 = address['address_2'] ?? '';
    final city = address['city'] ?? '';
    final state = address['state'] ?? '';
    final postcode = address['postcode'] ?? '';
    final country = address['country'] ?? '';
    final email = address['email'] ?? '';
    final phone = address['phone'] ?? '';

    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (firstName.isNotEmpty || lastName.isNotEmpty)
          OsmeaComponents.text(
            '$firstName $lastName'.trim(),
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        if (address1.isNotEmpty) ...[
          OsmeaComponents.sizedBox(height: context.spacing4),
          OsmeaComponents.text(
            address1,
            textStyle: OsmeaTextStyle.bodyMedium(context),
          ),
        ],
        if (address2.isNotEmpty) ...[
          OsmeaComponents.sizedBox(height: context.spacing4),
          OsmeaComponents.text(
            address2,
            textStyle: OsmeaTextStyle.bodyMedium(context),
          ),
        ],
        if (city.isNotEmpty || state.isNotEmpty || postcode.isNotEmpty) ...[
          OsmeaComponents.sizedBox(height: context.spacing4),
          OsmeaComponents.text(
            '${city.isNotEmpty ? '$city, ' : ''}${state.isNotEmpty ? '$state ' : ''}${postcode.isNotEmpty ? postcode : ''}'.trim(),
            textStyle: OsmeaTextStyle.bodyMedium(context),
          ),
        ],
        if (country.isNotEmpty) ...[
          OsmeaComponents.sizedBox(height: context.spacing4),
          OsmeaComponents.text(
            country,
            textStyle: OsmeaTextStyle.bodyMedium(context),
          ),
        ],
        if (email.isNotEmpty) ...[
          OsmeaComponents.sizedBox(height: context.spacing8),
          OsmeaComponents.text(
            'Email: $email',
            textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.pewter,
            ),
          ),
        ],
        if (phone.isNotEmpty) ...[
          OsmeaComponents.sizedBox(height: context.spacing4),
          OsmeaComponents.text(
            'Phone: $phone',
            textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.pewter,
            ),
          ),
        ],
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

