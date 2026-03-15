import 'package:injectable/injectable.dart' hide Order;
import 'package:storefront_supabase/app/api/admin/abstract/admin_reports_service.dart';
import 'package:storefront_supabase/app/models/app_user.dart';
import 'package:storefront_supabase/app/models/order.dart' as models;
import 'package:supabase_flutter/supabase_flutter.dart';

@Injectable(as: AdminReportsService)
class SupabaseAdminReportsService implements AdminReportsService {
  final SupabaseClient _client;

  SupabaseAdminReportsService(this._client);

  @override
  Future<int> getUserCount() async {
    return _client.from('users').count();
  }

  @override
  Future<int> getProductCount() async {
    return _client.from('products').count();
  }

  @override
  Future<int> getOrderCount() async {
    return _client.from('orders').count();
  }

  @override
  Future<double> getTotalRevenue() async {
    final res = await _client
        .from('orders')
        .select('total')
        .eq('status', 'completed');
    return (res as List).fold<double>(
      0,
      (sum, item) => sum + (item['total'] as num).toDouble(),
    );
  }

  @override
  Future<List<models.Order>> getRecentOrders({int limit = 5}) async {
    final res = await _client
        .from('orders')
        .select('*, users(*)')
        .order('created_at', ascending: false)
        .limit(limit);
    return (res as List).map((e) => models.Order.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<AppUser>> getRecentUsers({int limit = 5}) async {
    final res = await _client
        .from('users')
        .select()
        .order('created_at', ascending: false)
        .limit(limit);
    return (res as List).map((e) => AppUser.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<DailyChartPoint>> getDailyChartData(int days) async {
    final now = DateTime.now().toUtc();
    final from = now.subtract(Duration(days: days));
    final res = await _client
        .from('orders')
        .select('created_at, total')
        .gte('created_at', from.toIso8601String())
        .lte('created_at', now.toIso8601String());

    final byDay = <DateTime, ({double revenue, int count})>{};
    for (var d = 0; d < days; d++) {
      final day = DateTime(from.year, from.month, from.day).add(Duration(days: d));
      byDay[day] = (revenue: 0.0, count: 0);
    }
    for (final item in res as List) {
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

  @override
  Future<List<OrdersByStatusPoint>> getOrdersByStatus() async {
    final res = await _client.from('orders').select('status');
    final byStatus = <String, int>{};
    for (final item in res as List) {
      final s = item['status'] as String? ?? 'unknown';
      byStatus[s] = (byStatus[s] ?? 0) + 1;
    }
    final total = res.isEmpty ? 1 : res.length;
    return byStatus.entries
        .map((e) => OrdersByStatusPoint(
              status: e.key,
              count: e.value,
              share: e.value / total,
            ))
        .toList();
  }

  @override
  Future<List<int>> getDailyUserCounts(int days) async {
    return _dailyCounts('users', days);
  }

  @override
  Future<List<int>> getDailyProductCounts(int days) async {
    return _dailyCounts('products', days);
  }

  Future<List<int>> _dailyCounts(String table, int days) async {
    final now = DateTime.now().toUtc();
    final from = now.subtract(Duration(days: days));
    final res = await _client
        .from(table)
        .select('created_at')
        .gte('created_at', from.toIso8601String())
        .lte('created_at', now.toIso8601String());

    final byDay = <DateTime, int>{};
    for (var d = 0; d < days; d++) {
      final day = DateTime(from.year, from.month, from.day).add(Duration(days: d));
      byDay[day] = 0;
    }
    for (final item in res as List) {
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
