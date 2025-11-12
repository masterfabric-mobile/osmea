/*
 * OrdersListWidget
 * ----------------
 * Widget for displaying user orders list.
 * This is an example implementation showing how to create custom widgets
 * for account sub-routes that can be configured via app_config.json
 *
 * Copyright (c) 2025, OSMEA Team
 * https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
 *
 * {@category Widgets}
 * {@subCategory AccountWidget}
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// OrdersListWidget displays a list of user orders
/// This widget is used when widget_type is set to "orders_list" in app_config.json
class OrdersListWidget extends StatelessWidget {
  const OrdersListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Example orders data - in real implementation, this would come from API/state
    final List<OrderItem> exampleOrders = [
      OrderItem(
        id: '#ORD-001',
        date: '2024-01-15',
        status: 'Delivered',
        total: 299.99,
        itemsCount: 3,
      ),
      OrderItem(
        id: '#ORD-002',
        date: '2024-01-10',
        status: 'Processing',
        total: 149.50,
        itemsCount: 2,
      ),
      OrderItem(
        id: '#ORD-003',
        date: '2024-01-05',
        status: 'Shipped',
        total: 89.99,
        itemsCount: 1,
      ),
    ];

    if (exampleOrders.isEmpty) {
      return _buildEmptyState(context);
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: OsmeaComponents.singleChildScrollView(
          child: OsmeaComponents.column(
            children: [
              // Header info
              OsmeaComponents.container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: OsmeaColors.nordicBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: OsmeaComponents.row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OsmeaComponents.text(
                      'Total Orders',
                      textStyle: OsmeaTextStyle.bodyMedium(context),
                      color: OsmeaColors.thunder,
                    ),
                    OsmeaComponents.text(
                      '${exampleOrders.length}',
                      textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: OsmeaColors.nordicBlue,
                      ),
                    ),
                  ],
                ),
              ),

              OsmeaComponents.sizedBox(height: 8),

              // Orders list
              ...exampleOrders.map((order) => _buildOrderCard(context, order)),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds individual order card
  Widget _buildOrderCard(BuildContext context, OrderItem order) {
    return OsmeaComponents.container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: OsmeaColors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(16),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header
            OsmeaComponents.row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OsmeaComponents.text(
                      order.id,
                      textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: OsmeaColors.thunder,
                      ),
                    ),
                    OsmeaComponents.sizedBox(height: 4),
                    OsmeaComponents.text(
                      order.date,
                      textStyle: OsmeaTextStyle.bodySmall(context),
                      color: OsmeaColors.pewter,
                    ),
                  ],
                ),
                _buildStatusBadge(context, order.status),
              ],
            ),

            OsmeaComponents.sizedBox(height: 12),

            // Order details
            OsmeaComponents.row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OsmeaComponents.text(
                  '${order.itemsCount} item${order.itemsCount > 1 ? 's' : ''}',
                  textStyle: OsmeaTextStyle.bodyMedium(context),
                  color: OsmeaColors.pewter,
                ),
                OsmeaComponents.text(
                  PriceInfoCurrencyHelper.formatPrice(
                    order.total,
                    currencyCode: PriceInfoCurrencyHelper.currentCurrency,
                  ),
                  textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: OsmeaColors.nordicBlue,
                  ),
                ),
              ],
            ),

            OsmeaComponents.sizedBox(height: 12),

            // Action button
            OsmeaComponents.container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: OsmeaColors.grayMaterial[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Navigate to order detail
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Order detail for ${order.id} coming soon!'),
                        backgroundColor: OsmeaColors.nordicBlue,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: OsmeaComponents.text(
                      'View Details',
                      textAlign: TextAlign.center,
                      textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: OsmeaColors.nordicBlue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds status badge
  Widget _buildStatusBadge(BuildContext context, String status) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'delivered':
        statusColor = OsmeaColors.green;
        break;
      case 'shipped':
        statusColor = OsmeaColors.blue;
        break;
      case 'processing':
        statusColor = OsmeaColors.orange;
        break;
      default:
        statusColor = OsmeaColors.pewter;
    }

    return OsmeaComponents.container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: OsmeaComponents.text(
        status,
        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
          fontWeight: FontWeight.w600,
          color: statusColor,
        ),
      ),
    );
  }

  /// Builds empty state
  Widget _buildEmptyState(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: OsmeaComponents.center(
          child: OsmeaComponents.column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OsmeaComponents.container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: OsmeaColors.pewter.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 60,
                  color: OsmeaColors.pewter,
                ),
              ),
              OsmeaComponents.sizedBox(height: 24),
              OsmeaComponents.text(
                'No orders yet',
                textStyle: OsmeaTextStyle.headlineSmall(context).copyWith(
                  color: OsmeaColors.thunder,
                  fontWeight: FontWeight.w500,
                ),
              ),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.text(
                'Your order history will appear here',
                textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                  color: OsmeaColors.pewter,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Order item model (example - in real app this would come from API)
class OrderItem {
  final String id;
  final String date;
  final String status;
  final double total;
  final int itemsCount;

  OrderItem({
    required this.id,
    required this.date,
    required this.status,
    required this.total,
    required this.itemsCount,
  });
}

