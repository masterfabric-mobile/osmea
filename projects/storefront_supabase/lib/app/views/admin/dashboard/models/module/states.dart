import 'package:storefront_supabase/app/models/app_user.dart';
import 'package:storefront_supabase/app/models/order.dart';

abstract class AdminDashboardState {}

class AdminDashboardInitialState extends AdminDashboardState {}

class AdminDashboardLoadingState extends AdminDashboardState {}

class AdminDashboardErrorState extends AdminDashboardState {
  final String message;
  AdminDashboardErrorState(this.message);
}

/// Günlük özet: tarih, gelir, sipariş sayısı (grafik için).
class DailyChartPoint {
  final DateTime day;
  final double revenue;
  final int orderCount;
  DailyChartPoint({required this.day, required this.revenue, required this.orderCount});
}

/// Duruma göre sipariş sayısı (pasta grafik için).
class OrdersByStatusPoint {
  final String status;
  final int count;
  final double share; // 0..1
  OrdersByStatusPoint({required this.status, required this.count, required this.share});
}

class AdminDashboardLoadedState extends AdminDashboardState {
  final int userCount;
  final int productCount;
  final int orderCount;
  final double totalRevenue;
  final List<Order> recentOrders;
  final List<AppUser> recentUsers;
  /// Son 7 gün günlük gelir ve sipariş sayısı (grafik için).
  final List<DailyChartPoint> dailyChartData;
  /// Duruma göre sipariş dağılımı (pasta grafik için).
  final List<OrdersByStatusPoint> ordersByStatus;
  /// Son 7 gün günlük yeni kullanıcı sayısı (grafik için).
  final List<int> dailyUserCounts;
  /// Son 7 gün günlük yeni ürün sayısı (grafik için).
  final List<int> dailyProductCounts;

  AdminDashboardLoadedState({
    required this.userCount,
    required this.productCount,
    required this.orderCount,
    required this.totalRevenue,
    required this.recentOrders,
    required this.recentUsers,
    this.dailyChartData = const [],
    this.ordersByStatus = const [],
    this.dailyUserCounts = const [],
    this.dailyProductCounts = const [],
  });
}
