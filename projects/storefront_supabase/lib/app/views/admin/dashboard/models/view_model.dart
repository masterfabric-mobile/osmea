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

  Future<void> initial() async {
    stateChanger(AdminDashboardLoadingState());
    try {
      // Fetch all data in parallel
      final results = await Future.wait<dynamic>([
        _supabaseClient.from('users').count(),
        _supabaseClient.from('products').count(),
        _supabaseClient.from('orders').count(),
        _supabaseClient
            .from('orders')
            .select('total')
            .eq('status', 'completed'), // Assuming 'completed' is a valid status
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

      stateChanger(AdminDashboardLoadedState(
        userCount: userCount,
        productCount: productCount,
        orderCount: orderCount,
        totalRevenue: totalRevenue,
        recentOrders: recentOrders,
        recentUsers: recentUsers,
      ));
    } catch (e) {
      stateChanger(AdminDashboardErrorState('Failed to load dashboard data: $e'));
    }
  }
}
