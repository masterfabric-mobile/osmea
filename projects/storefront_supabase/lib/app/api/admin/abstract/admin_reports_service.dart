import 'package:storefront_supabase/app/models/app_user.dart';
import 'package:storefront_supabase/app/models/order.dart';

/// Dashboard chart point: day, revenue, order count.
class DailyChartPoint {
  final DateTime day;
  final double revenue;
  final int orderCount;
  DailyChartPoint({
    required this.day,
    required this.revenue,
    required this.orderCount,
  });
}

/// Orders grouped by status for pie chart.
class OrdersByStatusPoint {
  final String status;
  final int count;
  final double share;
  OrdersByStatusPoint({
    required this.status,
    required this.count,
    required this.share,
  });
}

/// Admin Reports/Dashboard API contract (adapted from packages/apis reports style).
abstract class AdminReportsService {
  /// Count of users.
  Future<int> getUserCount();

  /// Count of products.
  Future<int> getProductCount();

  /// Count of orders.
  Future<int> getOrderCount();

  /// Total revenue (e.g. sum of completed order totals).
  Future<double> getTotalRevenue();

  /// Recent orders for dashboard list.
  Future<List<Order>> getRecentOrders({int limit = 5});

  /// Recent users for dashboard list.
  Future<List<AppUser>> getRecentUsers({int limit = 5});

  /// Daily revenue and order count for the last N days (chart).
  Future<List<DailyChartPoint>> getDailyChartData(int days);

  /// Order counts by status (pie chart).
  Future<List<OrdersByStatusPoint>> getOrdersByStatus();

  /// Daily new user counts for the last N days.
  Future<List<int>> getDailyUserCounts(int days);

  /// Daily new product counts for the last N days.
  Future<List<int>> getDailyProductCounts(int days);
}
