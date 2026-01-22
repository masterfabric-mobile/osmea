import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:apis/network/remote/woocommerce/users_manager/abstract/osmea_users_manager_service.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_dashboard_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_orders_response.dart';
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

  // Cache for previous loaded state (to show while loading)
  OrdersHistoryLoadedState? _cachedLoadedState;

  // Public trigger functions
  Future<void> loadOrders({bool showCached = true}) => _loadOrders(showCached: showCached);

  Future<void> _loadOrders({bool showCached = true}) async {
    try {
      // Keep cached state if available and showCached is true
      if (!showCached || _cachedLoadedState == null) {
        stateChanger(OrdersHistoryLoadingState());
      }

      debugPrint('📦 OrdersHistoryViewModel: Loading orders...');

      List<UserOrder> orders;
      UserProfile userProfile;

      // Try getUserOrders first (includes lineItems with product images)
      try {
        final ordersResponse = await _usersManagerService.getUserOrders(
          page: 1,
          perPage: 100,
          status: null,
        );

        debugPrint(
          '✅ OrdersHistoryViewModel: getUserOrders loaded successfully',
        );
        debugPrint(
          '📦 OrdersHistoryViewModel: Orders count: ${ordersResponse.orders.length}',
        );

        // Check if orders have lineItems, if not, fetch them individually
        orders = await _enrichOrdersWithLineItems(ordersResponse.orders);

        // Debug: Check if lineItems exist after enrichment
        for (final order in orders.take(3)) {
          debugPrint(
            '📦 Order #${order.orderNumber}: lineItems = ${order.lineItems?.length ?? 0}',
          );
          if (order.lineItems != null && order.lineItems!.isNotEmpty) {
            debugPrint(
              '📦 Order #${order.orderNumber}: First item image = ${order.lineItems!.first.productImage}',
            );
          }
        }

        // Get user profile
        final profileResponse = await _usersManagerService.getUserProfile();
        userProfile = UserProfile(
          userId: profileResponse.userId,
          username: profileResponse.username,
          email: profileResponse.email,
          displayName: profileResponse.displayName,
          firstName: profileResponse.firstName,
          lastName: profileResponse.lastName,
          nickname: null,
          roles: null,
          registeredAt: profileResponse.registeredAt,
        );
      } catch (e) {
        // Fallback to getUserDashboard if getUserOrders fails
        debugPrint(
          '⚠️ getUserOrders failed, falling back to getUserDashboard: $e',
        );

        final dashboard = await _usersManagerService.getUserDashboard(
          includeOrders: true,
          ordersLimit: 100,
          includeActivity: false,
          activityLimit: 0,
        );

        debugPrint(
          '✅ OrdersHistoryViewModel: getUserDashboard loaded successfully',
        );
        debugPrint(
          '📦 OrdersHistoryViewModel: Orders count: ${dashboard.orders.length}',
        );

        // Enrich orders with lineItems if missing
        orders = await _enrichOrdersWithLineItems(dashboard.orders);
        userProfile = dashboard.profile;
      }

      final loadedState = OrdersHistoryLoadedState(
        orders: orders,
        userProfile: userProfile,
      );
      
      // Cache the loaded state
      _cachedLoadedState = loadedState;
      
      stateChanger(loadedState);

      debugPrint(
        '✅ OrdersHistoryViewModel: State changed to OrdersHistoryLoadedState',
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading orders: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      stateChanger(
        OrdersHistoryErrorState(
          message: 'Failed to load orders. Please try again.',
        ),
      );
    }
  }

  /// Enrich orders with lineItems by fetching detailed order data if lineItems are missing
  Future<List<UserOrder>> _enrichOrdersWithLineItems(
    List<UserOrder> orders,
  ) async {
    final enrichedOrders = <UserOrder>[];

    for (final order in orders) {
      // If order already has lineItems, use it as is
      if (order.lineItems != null && order.lineItems!.isNotEmpty) {
        enrichedOrders.add(order);
        continue;
      }

      // Otherwise, fetch detailed order data to get lineItems
      try {
        debugPrint(
          '🔄 Fetching detailed order data for Order #${order.orderNumber} (ID: ${order.id})',
        );
        final detailedOrder = await _usersManagerService.getUserOrder(order.id);

        // Create enriched UserOrder with lineItems from detailed order
        final enrichedOrder = order.copyWith(
          lineItems: detailedOrder.lineItems,
        );

        enrichedOrders.add(enrichedOrder);
        debugPrint(
          '✅ Order #${order.orderNumber}: Enriched with ${detailedOrder.lineItems?.length ?? 0} lineItems',
        );
      } catch (e) {
        debugPrint(
          '⚠️ Failed to fetch lineItems for Order #${order.orderNumber}: $e',
        );
        // Use original order if fetch fails
        enrichedOrders.add(order);
      }
    }

    return enrichedOrders;
  }

  @override
  Map<String, dynamic>? toJson(OrdersHistoryState state) {
    if (state is OrdersHistoryLoadedState) {
      return {
        'type': 'loaded',
        'orders': state.orders.map((order) => order.toJson()).toList(),
        'userProfile': state.userProfile?.toJson(),
      };
    }
    return null;
  }

  @override
  OrdersHistoryState? fromJson(Map<String, dynamic> json) {
    try {
      if (json['type'] == 'loaded') {
        final ordersJson = json['orders'] as List<dynamic>;
        final orders = ordersJson
            .map((orderJson) => UserOrder.fromJson(orderJson as Map<String, dynamic>))
            .toList();
        
        UserProfile? userProfile;
        if (json['userProfile'] != null) {
          userProfile = UserProfile.fromJson(
            json['userProfile'] as Map<String, dynamic>,
          );
        }
        
        final loadedState = OrdersHistoryLoadedState(
          orders: orders,
          userProfile: userProfile,
        );
        
        // Cache the restored state
        _cachedLoadedState = loadedState;
        
        return loadedState;
      }
    } catch (e) {
      debugPrint('⚠️ Failed to restore orders from cache: $e');
    }
    return OrdersHistoryInitialState();
  }

  /// Get cached loaded state (for showing while loading)
  OrdersHistoryLoadedState? get cachedLoadedState => _cachedLoadedState;
}
