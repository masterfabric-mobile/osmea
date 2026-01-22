import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:apis/network/remote/woocommerce/users_manager/abstract/osmea_users_manager_service.dart';
import 'package:storefront_woo/app/views/view_orders_history/models/module/states.dart';

@injectable
class OrdersHistoryViewModel
    extends BaseViewModelHydratedCubit<OrdersHistoryState> {
  OrdersHistoryViewModel() : super(OrdersHistoryInitialState());

  // Dependencies
  final OsmeaUsersManagerService _usersManagerService =
      GetIt.I<OsmeaUsersManagerService>();

  // Arguments holder
  final Map<String, dynamic> _arguments = {};
  void setArguments(Map<String, dynamic> args) {
    _arguments
      ..clear()
      ..addAll(args);
  }

  Map<String, dynamic> get arguments => Map.unmodifiable(_arguments);

  // Hydrated storage key
  @override
  String get id => 'orders_history_view_model_v1';

  // Public trigger functions
  Future<void> loadOrders() => _loadOrders();

  Future<void> _loadOrders() async {
    try {
      stateChanger(OrdersHistoryLoadingState());

      debugPrint('📦 OrdersHistoryViewModel: Loading orders...');
      
      // Get dashboard with all orders (set high limit to get all)
      final dashboard = await _usersManagerService.getUserDashboard(
        includeOrders: true,
        ordersLimit: 100, // Get up to 100 orders
        includeActivity: false,
        activityLimit: 0,
      );

      debugPrint('✅ OrdersHistoryViewModel: Dashboard loaded successfully');
      debugPrint('📦 OrdersHistoryViewModel: Orders count: ${dashboard.orders.length}');
      debugPrint('👤 OrdersHistoryViewModel: Profile: ${dashboard.profile.displayName}');

      stateChanger(OrdersHistoryLoadedState(
        orders: dashboard.orders,
        userProfile: dashboard.profile,
      ));
      
      debugPrint('✅ OrdersHistoryViewModel: State changed to OrdersHistoryLoadedState');
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading orders: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      stateChanger(OrdersHistoryErrorState(
        message: 'Failed to load orders. Please try again.',
      ));
    }
  }

  @override
  Map<String, dynamic>? toJson(OrdersHistoryState state) {
    // Don't persist state - always fetch fresh data from API
    return null;
  }

  @override
  OrdersHistoryState? fromJson(Map<String, dynamic> json) {
    // Don't restore state - always start fresh
    return OrdersHistoryInitialState();
  }
}
