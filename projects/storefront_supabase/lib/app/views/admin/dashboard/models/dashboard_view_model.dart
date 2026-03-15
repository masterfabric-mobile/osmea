import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:injectable/injectable.dart' hide Order;
import 'package:storefront_supabase/app/api/admin/abstract/admin_reports_service.dart' as reports;
import 'package:storefront_supabase/app/core/config/config_di.dart';
import 'package:storefront_supabase/app/models/app_user.dart';
import 'package:storefront_supabase/app/models/order.dart';
import 'module/states.dart';

@injectable
class AdminDashboardViewModel extends BaseViewModelCubit<AdminDashboardState> {
  AdminDashboardViewModel() : super(AdminDashboardInitialState());

  static const int _chartDays = 7;

  reports.AdminReportsService get _reports => getIt<reports.AdminReportsService>();

  Future<void> initial() async {
    stateChanger(AdminDashboardLoadingState());
    try {
      final results = await Future.wait<dynamic>([
        _reports.getUserCount(),
        _reports.getProductCount(),
        _reports.getOrderCount(),
        _reports.getTotalRevenue(),
        _reports.getRecentOrders(limit: 5),
        _reports.getRecentUsers(limit: 5),
        _reports.getDailyChartData(_chartDays),
        _reports.getOrdersByStatus(),
        _reports.getDailyUserCounts(_chartDays),
        _reports.getDailyProductCounts(_chartDays),
      ]);

      final userCount = results[0] as int;
      final productCount = results[1] as int;
      final orderCount = results[2] as int;
      final totalRevenue = results[3] as double;
      final recentOrders = results[4] as List<Order>;
      final recentUsers = results[5] as List<AppUser>;
      final dailyChartDataRaw = results[6] as List<reports.DailyChartPoint>;
      final ordersByStatusRaw = results[7] as List<reports.OrdersByStatusPoint>;
      final dailyUserCounts = results[8] as List<int>;
      final dailyProductCounts = results[9] as List<int>;

      final dailyChartData = dailyChartDataRaw
          .map((e) => DailyChartPoint(day: e.day, revenue: e.revenue, orderCount: e.orderCount))
          .toList();
      final ordersByStatus = ordersByStatusRaw
          .map((e) => OrdersByStatusPoint(status: e.status, count: e.count, share: e.share))
          .toList();

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
}
