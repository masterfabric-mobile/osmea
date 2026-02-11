import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:injectable/injectable.dart' hide Order;
import 'package:storefront_supabase/app/models/app_user.dart';
import 'package:storefront_supabase/app/models/order.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'states.dart';

@injectable
class AdminDashboardViewModel extends BaseViewModelCubit<AdminDashboardState> {
  final SupabaseClient _supabaseClient;

  AdminDashboardViewModel(this._supabaseClient)
      : super(AdminDashboardInitialState());

  static const int _chartDays = 7;

  Future<void> initial() async {
    stateChanger(AdminDashboardLoadingState());
    try {
      final now = DateTime.now().toUtc();
      final from = now.subtract(Duration(days: _chartDays));

      // Fetch all data in parallel (including chart data)
      final results = await Future.wait<dynamic>([
        _supabaseClient.from('users').count(),
        _supabaseClient.from('products').count(),
        _supabaseClient.from('orders').count(),
        _supabaseClient
            .from('orders')
            .select('total')
            .eq('status', 'completed'),
        _supabaseClient
            .from('orders')
            .select('*, users(*)')
            .order('created_at', ascending: false)
            .limit(5),
        _supabaseClient
            .from('users')
            .select('*')
            .order('created_at', ascending: false)
            .limit(5),
        // Son 7 gün siparişler (grafik için)
        _supabaseClient
            .from('orders')
            .select('created_at, total')
            .gte('created_at', from.toIso8601String())
            .lte('created_at', now.toIso8601String()),
        // Sipariş durumlarına göre sayı (pasta grafik için)
        _supabaseClient.from('orders').select('status'),
        // Son 7 gün yeni kullanıcılar (grafik için)
        _supabaseClient
            .from('users')
            .select('created_at')
            .gte('created_at', from.toIso8601String())
            .lte('created_at', now.toIso8601String()),
        // Son 7 gün eklenen ürünler (grafik için)
        _supabaseClient
            .from('products')
            .select('created_at')
            .gte('created_at', from.toIso8601String())
            .lte('created_at', now.toIso8601String()),
      ]);

      final userCount = results[0] as int;
      final productCount = results[1] as int;
      final orderCount = results[2] as int;

      final revenueData = results[3] as List;
      final totalRevenue = revenueData.fold<double>(
          0, (sum, item) => sum + (item['total'] as num).toDouble());

      final recentOrdersData = results[4] as List;
      final recentOrders =
          recentOrdersData.map((data) => Order.fromJson(data)).toList();

      final recentUsersData = results[5] as List;
      final recentUsers =
          recentUsersData.map((data) => AppUser.fromJson(data)).toList();

      final ordersLast7Data = results[6] as List;
      final dailyChartData = _buildDailyChartData(ordersLast7Data, from);

      final allOrdersStatusData = results[7] as List;
      final ordersByStatus = _buildOrdersByStatus(allOrdersStatusData);

      final usersLast7Data = results[8] as List;
      final dailyUserCounts = _buildDailyCounts(usersLast7Data, from);
      final productsLast7Data = results[9] as List;
      final dailyProductCounts = _buildDailyCounts(productsLast7Data, from);

      stateChanger(AdminDashboardLoadedState(
        userCount: userCount,
        productCount: productCount,
        orderCount: orderCount,
        totalRevenue: totalRevenue,
        recentOrders: recentOrders,
        recentUsers: recentUsers,
        dailyChartData: dailyChartData,
        ordersByStatus: ordersByStatus,
        dailyUserCounts: dailyUserCounts,
        dailyProductCounts: dailyProductCounts,
      ));
    } catch (e) {
      stateChanger(AdminDashboardErrorState('Failed to load dashboard data: $e'));
    }
  }

  List<DailyChartPoint> _buildDailyChartData(List<dynamic> ordersRaw, DateTime from) {
    final byDay = <DateTime, ({double revenue, int count})>{};
    for (var d = 0; d < _chartDays; d++) {
      final day = DateTime(from.year, from.month, from.day).add(Duration(days: d));
      byDay[day] = (revenue: 0.0, count: 0);
    }
    for (final item in ordersRaw) {
      final createdAt = DateTime.parse(item['created_at'] as String);
      final day = DateTime(createdAt.year, createdAt.month, createdAt.day);
      final total = (item['total'] as num).toDouble();
      if (byDay.containsKey(day)) {
        final cur = byDay[day]!;
        byDay[day] = (revenue: cur.revenue + total, count: cur.count + 1);
      }
    }
    final sorted = byDay.keys.toList()..sort();
    return sorted
        .map((day) => DailyChartPoint(
              day: day,
              revenue: byDay[day]!.revenue,
              orderCount: byDay[day]!.count,
            ))
        .toList();
  }

  List<OrdersByStatusPoint> _buildOrdersByStatus(List<dynamic> ordersRaw) {
    final byStatus = <String, int>{};
    for (final item in ordersRaw) {
      final s = item['status'] as String? ?? 'unknown';
      byStatus[s] = (byStatus[s] ?? 0) + 1;
    }
    final total = ordersRaw.isEmpty ? 1 : ordersRaw.length;
    return byStatus.entries
        .map((e) => OrdersByStatusPoint(
              status: e.key,
              count: e.value,
              share: e.value / total,
            ))
        .toList();
  }

  /// Son 7 gün günlük kayıt sayısı (users veya products için).
  List<int> _buildDailyCounts(List<dynamic> raw, DateTime from) {
    final byDay = <DateTime, int>{};
    for (var d = 0; d < _chartDays; d++) {
      final day = DateTime(from.year, from.month, from.day).add(Duration(days: d));
      byDay[day] = 0;
    }
    for (final item in raw) {
      final createdAt = DateTime.parse(item['created_at'] as String);
      final day = DateTime(createdAt.year, createdAt.month, createdAt.day);
      if (byDay.containsKey(day)) {
        byDay[day] = byDay[day]! + 1;
      }
    }
    final sorted = byDay.keys.toList()..sort();
    return sorted.map((day) => byDay[day]!).toList();
  }
}
