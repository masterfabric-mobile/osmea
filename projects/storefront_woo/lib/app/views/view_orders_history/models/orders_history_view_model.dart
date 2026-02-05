import 'dart:convert';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:apis/network/remote/woocommerce/users_manager/abstract/osmea_users_manager_service.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_dashboard_response.dart';
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
  
  // 🔐 SECURITY: Current user ID for user-specific cache
  int? _currentUserId;

  // Public trigger functions
  Future<void> loadOrders({bool showCached = true}) => _loadOrders(showCached: showCached);

  Future<void> _loadOrders({bool showCached = true}) async {
    try {
      // 🔐 SECURITY: Get current user ID first
      await _loadCurrentUserId();
      
      if (_currentUserId == null) {
        debugPrint('⚠️ [ORDERS CACHE] No user ID, cannot load orders safely');
        stateChanger(OrdersHistoryLoadingState());
      }

      // Try to load from cache first
      debugPrint('📦 [ORDERS CACHE] Checking cache for orders...');
      final cachedOrders = await _loadOrdersFromCache();

      // If cache exists, use it first to avoid unnecessary API calls
      if (cachedOrders != null && cachedOrders.isNotEmpty) {
        debugPrint('✅ [ORDERS CACHE] Loaded ${cachedOrders.length} orders from cache');
        debugPrint('   💾 Using cached data - no API call needed');
        
        // Get user profile from cache or load it
        UserProfile? userProfile;
        try {
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
          debugPrint('⚠️ [ORDERS CACHE] Could not load user profile: $e');
        }
        
        final loadedState = OrdersHistoryLoadedState(
          orders: cachedOrders,
          userProfile: userProfile,
        );
        
        _cachedLoadedState = loadedState;
        stateChanger(loadedState);

        // Refresh orders from API in background to update cache
        debugPrint('🔄 [ORDERS CACHE] Refreshing cache in background...');
        _refreshOrdersFromApi();
        return;
      }

      // If no cache, load from API
      debugPrint('⚠️ [ORDERS CACHE] No cache found, loading from API...');
      stateChanger(OrdersHistoryLoadingState());

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

      // Cache the orders
      await _saveOrdersToCache(orders);

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
      debugPrint('❌ [ORDERS CACHE] Error loading orders: $e');
      debugPrint('❌ Stack trace: $stackTrace');

      // Try to load from cache as fallback
      debugPrint('🔄 [ORDERS CACHE] Trying cache as fallback...');
      final cachedOrders = await _loadOrdersFromCache();
      if (cachedOrders != null && cachedOrders.isNotEmpty) {
        debugPrint('✅ [ORDERS CACHE] Using cached orders as fallback (${cachedOrders.length} orders)');
        
        UserProfile? userProfile;
        try {
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
        } catch (profileError) {
          debugPrint('⚠️ Could not load user profile: $profileError');
        }
        
        final loadedState = OrdersHistoryLoadedState(
          orders: cachedOrders,
          userProfile: userProfile,
        );
        _cachedLoadedState = loadedState;
        stateChanger(loadedState);
      } else {
        debugPrint('❌ [ORDERS CACHE] No cache available as fallback');
        stateChanger(
          OrdersHistoryErrorState(
            message: 'Failed to load orders. Please try again.',
          ),
        );
      }
    }
  }

  /// 🔐 SECURITY: Get current user ID from API
  Future<void> _loadCurrentUserId() async {
    try {
      if (_currentUserId != null) return;

      final profile = await _usersManagerService.getUserProfile();
      _currentUserId = profile.userId;
      debugPrint('👤 [ORDERS CACHE] Current user ID: $_currentUserId');
    } catch (e) {
      debugPrint('❌ [ORDERS CACHE] Error loading user ID: $e');
    }
  }

  /// Load orders from local storage cache
  Future<List<UserOrder>?> _loadOrdersFromCache() async {
    try {
      if (_currentUserId == null) {
        debugPrint('⚠️ [ORDERS CACHE] No user ID, skipping cache');
        return null;
      }

      final storage = LocalStorageHelper();
      final cacheKey = 'user_orders_history_cache_$_currentUserId';
      final timestampKey = 'user_orders_history_cache_timestamp_$_currentUserId';
      final cachedJson = await storage.getItem(cacheKey);
      final timestamp = await storage.getItem(timestampKey);

      if (cachedJson == null || cachedJson.isEmpty) {
        debugPrint('   ⚠️ [ORDERS CACHE] Cache is empty');
        return null;
      }

      debugPrint('   ✅ [ORDERS CACHE] Cache found');
      debugPrint('   🕐 Cache timestamp: ${timestamp ?? "unknown"}');

      final List<dynamic> ordersList = jsonDecode(cachedJson);
      final orders = ordersList
          .map((json) => UserOrder.fromJson(json as Map<String, dynamic>))
          .toList();

      debugPrint('   📦 Parsed ${orders.length} orders from cache');
      return orders;
    } catch (e) {
      debugPrint('   ❌ [ORDERS CACHE] Error loading orders from cache: $e');
      return null;
    }
  }

  /// Save orders to local storage cache
  Future<void> _saveOrdersToCache(List<UserOrder> orders) async {
    try {
      if (_currentUserId == null) {
        debugPrint('⚠️ [ORDERS CACHE] No user ID, skipping cache save');
        return;
      }

      final storage = LocalStorageHelper();
      final cacheKey = 'user_orders_history_cache_$_currentUserId';
      final timestampKey = 'user_orders_history_cache_timestamp_$_currentUserId';
      final ordersJson = jsonEncode(
        orders.map((order) => order.toJson()).toList(),
      );
      await storage.setItem(cacheKey, ordersJson);
      final timestamp = DateTime.now().toIso8601String();
      await storage.setItem(timestampKey, timestamp);
      debugPrint('✅ [ORDERS CACHE] Orders cached successfully');
      debugPrint('   📦 Cached ${orders.length} orders');
      debugPrint('   🕐 Cache timestamp: $timestamp');
    } catch (e) {
      debugPrint('❌ [ORDERS CACHE] Error saving orders to cache: $e');
    }
  }

  /// Check if cache needs refresh (older than specified duration)
  bool _shouldRefreshCache(
    String? timestamp, {
    Duration maxAge = const Duration(minutes: 10),
  }) {
    if (timestamp == null || timestamp.isEmpty) {
      return true; // No timestamp, should refresh
    }

    try {
      final cacheTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final age = now.difference(cacheTime);

      if (age > maxAge) {
        debugPrint('   ⏰ Cache is ${age.inMinutes} minutes old, needs refresh');
        return true;
      } else {
        debugPrint(
          '   ✅ Cache is fresh (${age.inMinutes} minutes old), skipping refresh',
        );
        return false;
      }
    } catch (e) {
      debugPrint('   ⚠️ Error parsing cache timestamp: $e');
      return true; // On error, refresh to be safe
    }
  }

  /// Refresh orders from API in background (non-blocking)
  /// Only refreshes if cache is older than 10 minutes
  Future<void> _refreshOrdersFromApi() async {
    try {
      if (_currentUserId == null) {
        debugPrint('⚠️ [ORDERS CACHE] No user ID, skipping refresh');
        return;
      }

      // Check cache timestamp before refreshing
      final storage = LocalStorageHelper();
      final timestampKey = 'user_orders_history_cache_timestamp_$_currentUserId';
      final timestamp = await storage.getItem(timestampKey);

      if (!_shouldRefreshCache(timestamp)) {
        debugPrint(
          '⏭️ [ORDERS CACHE] Skipping refresh - cache is still fresh',
        );
        return;
      }

      debugPrint(
        '🔄 [ORDERS CACHE] Refreshing orders from API in background...',
      );

      List<UserOrder> orders;
      UserProfile? userProfile;

      // Try getUserOrders first
      try {
        final ordersResponse = await _usersManagerService.getUserOrders(
          page: 1,
          perPage: 100,
          status: null,
        );

        orders = await _enrichOrdersWithLineItems(ordersResponse.orders);

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
        // Fallback to getUserDashboard
        debugPrint('⚠️ getUserOrders failed in background refresh: $e');
        final dashboard = await _usersManagerService.getUserDashboard(
          includeOrders: true,
          ordersLimit: 100,
          includeActivity: false,
          activityLimit: 0,
        );
        orders = await _enrichOrdersWithLineItems(dashboard.orders);
        userProfile = dashboard.profile;
      }

      await _saveOrdersToCache(orders);

      debugPrint(
        '✅ [ORDERS CACHE] Orders refreshed from API (${orders.length} orders)',
      );

      // Update UI if still mounted
      final loadedState = OrdersHistoryLoadedState(
        orders: orders,
        userProfile: userProfile,
      );
      _cachedLoadedState = loadedState;
      stateChanger(loadedState);
    } catch (e) {
      debugPrint('⚠️ [ORDERS CACHE] Error refreshing orders from API: $e');
      // Don't show error, just log it
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
    // 🔐 SECURITY: Disable HydratedCubit cache to prevent cross-user data leakage
    // We use LocalStorageHelper with user-specific cache keys instead
    debugPrint('💾 [HYDRATED CACHE] Disabled - using LocalStorageHelper');
    return null;
  }

  @override
  OrdersHistoryState? fromJson(Map<String, dynamic> json) {
    // 🔐 SECURITY: Disable HydratedCubit cache to prevent cross-user data leakage
    // We use LocalStorageHelper with user-specific cache keys instead
    debugPrint('💾 [HYDRATED CACHE] Disabled - using LocalStorageHelper');
    return null;
  }

  /// Get cached loaded state (for showing while loading)
  OrdersHistoryLoadedState? get cachedLoadedState => _cachedLoadedState;
}
