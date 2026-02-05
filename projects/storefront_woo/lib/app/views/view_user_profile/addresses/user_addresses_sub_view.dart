import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/utils/unified_loading_widget.dart';
import 'package:apis/network/remote/woocommerce/users_manager/abstract/osmea_users_manager_service.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_dashboard_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_orders_response.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart' as core;

/// User Addresses View - Displays user addresses with minimal design
class UserAddressesView extends StatefulWidget {
  final Function(String) goRoute;
  final Map<String, dynamic> arguments;

  const UserAddressesView({
    super.key,
    required this.goRoute,
    this.arguments = const {},
  });

  @override
  State<UserAddressesView> createState() => _UserAddressesViewState();
}

class _UserAddressesViewState extends State<UserAddressesView> {
  final OsmeaUsersManagerService _usersManagerService =
      GetIt.I<OsmeaUsersManagerService>();

  bool _isLoading = true;
  bool _isLoadingOrders = true;
  List<UserAddress> _savedAddresses = [];
  List<UserAddress> _orderAddresses = [];
  String? _errorMessage;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get current user ID first
      await _loadCurrentUserId();

      // Try to load from cache first
      debugPrint('📍 [ADDRESS CACHE] Checking cache for addresses...');
      List<UserAddress>? cachedAddresses = await _loadAddressesFromCache();

      // If cache exists (even if empty), use it first to avoid unnecessary API calls
      if (cachedAddresses != null) {
        debugPrint(
          '✅ [ADDRESS CACHE] Loaded ${cachedAddresses.length} addresses from cache',
        );
        debugPrint('   💾 Using cached data - no API call needed');
        setState(() {
          _savedAddresses = cachedAddresses;
          _isLoading = false;
        });

        // Load order addresses
        await _loadOrderAddresses();

        // Refresh addresses from API in background to update cache
        debugPrint('🔄 [ADDRESS CACHE] Refreshing cache in background...');
        _refreshAddressesFromApi();
        return;
      }

      // If no cache, load from API
      debugPrint(
        '⚠️ [ADDRESS CACHE] No cache found, loading addresses from API...',
      );
      final savedResponse = await _usersManagerService.getUserAddresses();

      debugPrint(
        '✅ [ADDRESS CACHE] API Response: ${savedResponse.addresses.length} addresses received',
      );

      // Cache the addresses
      await _saveAddressesToCache(savedResponse.addresses);

      // Load order addresses
      await _loadOrderAddresses();

      setState(() {
        _savedAddresses = savedResponse.addresses;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ [ADDRESS CACHE] Error loading addresses: $e');

      // Try to load from cache as fallback
      debugPrint('🔄 [ADDRESS CACHE] Trying cache as fallback...');
      final cachedAddresses = await _loadAddressesFromCache();
      if (cachedAddresses != null) {
        debugPrint(
          '✅ [ADDRESS CACHE] Using cached addresses as fallback (${cachedAddresses.length} addresses)',
        );
        setState(() {
          _savedAddresses = cachedAddresses;
          _isLoading = false;
        });
        await _loadOrderAddresses();
      } else {
        debugPrint('❌ [ADDRESS CACHE] No cache available as fallback');
        setState(() {
          _errorMessage = 'Failed to load addresses. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  /// Get current user ID from API
  Future<void> _loadCurrentUserId() async {
    try {
      if (_currentUserId != null) return;

      final profile = await _usersManagerService.getUserProfile();
      _currentUserId = profile.userId;
      debugPrint('👤 Current user ID: $_currentUserId');
    } catch (e) {
      debugPrint('❌ Error loading user ID: $e');
    }
  }

  /// Load addresses from local storage cache
  Future<List<UserAddress>?> _loadAddressesFromCache() async {
    try {
      if (_currentUserId == null) {
        debugPrint('⚠️ [ADDRESS CACHE] No user ID, skipping cache');
        return null;
      }

      final storage = LocalStorageHelper();
      final cacheKey = 'user_addresses_cache_$_currentUserId';
      final timestampKey = 'user_addresses_cache_timestamp_$_currentUserId';
      final cachedJson = await storage.getItem(cacheKey);
      final timestamp = await storage.getItem(timestampKey);

      if (cachedJson == null || cachedJson.isEmpty) {
        debugPrint('   ⚠️ [ADDRESS CACHE] Cache is empty');
        return null;
      }

      debugPrint('   ✅ [ADDRESS CACHE] Cache found');
      debugPrint('   🕐 Cache timestamp: ${timestamp ?? "unknown"}');

      final List<dynamic> addressesList = jsonDecode(cachedJson);
      final addresses = addressesList
          .map((json) => UserAddress.fromJson(json as Map<String, dynamic>))
          .toList();

      debugPrint('   📦 Parsed ${addresses.length} addresses from cache');
      return addresses;
    } catch (e) {
      debugPrint('   ❌ [ADDRESS CACHE] Error loading addresses from cache: $e');
      return null;
    }
  }

  /// Load order addresses from cache
  Future<List<UserAddress>?> _loadOrderAddressesFromCache() async {
    try {
      if (_currentUserId == null) {
        debugPrint('⚠️ [ORDER CACHE] No user ID, skipping cache');
        return null;
      }

      final storage = LocalStorageHelper();
      final cacheKey = 'user_orders_cache_$_currentUserId';
      final timestampKey = 'user_orders_cache_timestamp_$_currentUserId';
      final cachedOrdersJson = await storage.getItem(cacheKey);
      final timestamp = await storage.getItem(timestampKey);

      if (cachedOrdersJson == null || cachedOrdersJson.isEmpty) {
        debugPrint('   ⚠️ [ORDER CACHE] Cache is empty');
        return null;
      }

      debugPrint('   ✅ [ORDER CACHE] Cache found');
      debugPrint('   🕐 Cache timestamp: ${timestamp ?? "unknown"}');

      // Parse orders from cache
      final List<dynamic> ordersList = jsonDecode(cachedOrdersJson);
      final orders = ordersList
          .map(
            (json) => DetailedUserOrder.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      debugPrint('   📦 Parsed ${orders.length} orders from cache');

      // Extract addresses from cached orders
      return _extractAddressesFromOrders(orders);
    } catch (e) {
      debugPrint('   ❌ [ORDER CACHE] Error loading orders from cache: $e');
      return null;
    }
  }

  /// Extract unique addresses from orders
  List<UserAddress> _extractAddressesFromOrders(
    List<DetailedUserOrder> orders,
  ) {
    final Set<String> seenAddresses = {};
    final List<UserAddress> uniqueOrderAddresses = [];

    for (final order in orders) {
      // Process billing address
      if (order.billing != null) {
        final billing = order.billing!;
        final addressKey = _getAddressKey(
          billing.address1,
          billing.city,
          billing.postcode,
        );

        if (!seenAddresses.contains(addressKey) &&
            billing.address1 != null &&
            billing.address1!.isNotEmpty) {
          seenAddresses.add(addressKey);
          uniqueOrderAddresses.add(
            UserAddress(
              id: order.id,
              addressType: 'billing',
              label: 'Billing Address',
              firstName: billing.firstName,
              lastName: billing.lastName,
              company: billing.company,
              address1: billing.address1,
              address2: billing.address2,
              city: billing.city,
              state: billing.state,
              postcode: billing.postcode,
              country: billing.country,
              email: billing.email,
              phone: billing.phone,
              isDefault: false,
              createdAt: order.dateCreated,
              updatedAt: order.dateCreated,
            ),
          );
        }
      }

      // Process shipping address
      if (order.shipping != null) {
        final shipping = order.shipping!;
        final addressKey = _getAddressKey(
          shipping.address1,
          shipping.city,
          shipping.postcode,
        );

        if (!seenAddresses.contains(addressKey) &&
            shipping.address1 != null &&
            shipping.address1!.isNotEmpty) {
          seenAddresses.add(addressKey);
          uniqueOrderAddresses.add(
            UserAddress(
              id: order.id + 1000000,
              addressType: 'shipping',
              label: 'Shipping Address',
              firstName: shipping.firstName,
              lastName: shipping.lastName,
              company: shipping.company,
              address1: shipping.address1,
              address2: shipping.address2,
              city: shipping.city,
              state: shipping.state,
              postcode: shipping.postcode,
              country: shipping.country,
              email: null,
              phone: null,
              isDefault: false,
              createdAt: order.dateCreated,
              updatedAt: order.dateCreated,
            ),
          );
        }
      }
    }

    debugPrint(
      '   ✅ Extracted ${uniqueOrderAddresses.length} unique addresses from ${orders.length} orders',
    );
    return uniqueOrderAddresses;
  }

  /// Save addresses to local storage cache
  Future<void> _saveAddressesToCache(List<UserAddress> addresses) async {
    try {
      if (_currentUserId == null) {
        debugPrint('⚠️ [ADDRESS CACHE] No user ID, skipping cache save');
        return;
      }

      final storage = LocalStorageHelper();
      final cacheKey = 'user_addresses_cache_$_currentUserId';
      final timestampKey = 'user_addresses_cache_timestamp_$_currentUserId';
      final addressesJson = jsonEncode(
        addresses.map((addr) => addr.toJson()).toList(),
      );
      await storage.setItem(cacheKey, addressesJson);
      final timestamp = DateTime.now().toIso8601String();
      await storage.setItem(timestampKey, timestamp);
      debugPrint('✅ [ADDRESS CACHE] Addresses cached successfully');
      debugPrint('   📦 Cached ${addresses.length} addresses');
      debugPrint('   🕐 Cache timestamp: $timestamp');
    } catch (e) {
      debugPrint('❌ [ADDRESS CACHE] Error saving addresses to cache: $e');
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

  /// Refresh addresses from API in background (non-blocking)
  /// Only refreshes if cache is older than 10 minutes
  Future<void> _refreshAddressesFromApi() async {
    try {
      if (_currentUserId == null) {
        debugPrint('⚠️ [ADDRESS CACHE] No user ID, skipping refresh');
        return;
      }

      // Check cache timestamp before refreshing
      final storage = LocalStorageHelper();
      final timestampKey = 'user_addresses_cache_timestamp_$_currentUserId';
      final timestamp = await storage.getItem(timestampKey);

      if (!_shouldRefreshCache(timestamp)) {
        debugPrint(
          '⏭️ [ADDRESS CACHE] Skipping refresh - cache is still fresh',
        );
        return;
      }

      debugPrint(
        '🔄 [ADDRESS CACHE] Refreshing addresses from API in background...',
      );
      final savedResponse = await _usersManagerService.getUserAddresses();
      await _saveAddressesToCache(savedResponse.addresses);

      debugPrint(
        '✅ [ADDRESS CACHE] Addresses refreshed from API (${savedResponse.addresses.length} addresses)',
      );

      // Update UI if still mounted
      if (mounted) {
        setState(() {
          _savedAddresses = savedResponse.addresses;
        });
      }
    } catch (e) {
      debugPrint('⚠️ [ADDRESS CACHE] Error refreshing addresses from API: $e');
      // Don't show error, just log it
    }
  }

  Future<void> _loadOrderAddresses() async {
    setState(() {
      _isLoadingOrders = true;
    });

    try {
      debugPrint('📍 [ORDER CACHE] Starting to load order addresses...');

      // Try to load from order cache first
      final cachedOrderAddresses = await _loadOrderAddressesFromCache();
      if (cachedOrderAddresses != null) {
        debugPrint(
          '✅ [ORDER CACHE] Loaded ${cachedOrderAddresses.length} order addresses from cache',
        );
        debugPrint('   💾 Using cached orders - no API calls needed');
        if (mounted) {
          setState(() {
            _orderAddresses = cachedOrderAddresses;
            _isLoadingOrders = false;
          });
        }

        // Refresh in background
        _refreshOrderAddressesFromApi();
        return;
      }

      debugPrint('⚠️ [ORDER CACHE] No cache found, loading from API...');

      // Get order IDs from getUserDashboard
      List<int> orderIds = [];
      try {
        final dashboard = await _usersManagerService.getUserDashboard(
          includeOrders: true,
          ordersLimit: 100, // Get up to 100 orders
        );
        orderIds = dashboard.orders.map((o) => o.id).toList();
        debugPrint('✅ Got ${orderIds.length} order IDs from getUserDashboard');
      } catch (e) {
        debugPrint('⚠️ Failed to get orders from getUserDashboard: $e');
        if (mounted) {
          setState(() {
            _isLoadingOrders = false;
          });
        }
        return;
      }

      if (orderIds.isEmpty) {
        debugPrint('⚠️ No orders found, skipping address extraction');
        if (mounted) {
          setState(() {
            _isLoadingOrders = false;
          });
        }
        return;
      }

      debugPrint('📦 Fetching order details for ${orderIds.length} orders...');

      // Fetch detailed order information using getUserOrder endpoint
      final List<DetailedUserOrder> detailedOrders = [];
      // Limit to first 50 orders to avoid too many API calls
      final limitedOrderIds = orderIds.take(50).toList();

      for (final orderId in limitedOrderIds) {
        try {
          final detailedOrder = await _usersManagerService.getUserOrder(
            orderId,
          );
          detailedOrders.add(detailedOrder);
          debugPrint('  ✅ Retrieved order ID: $orderId');
        } catch (e) {
          debugPrint('  ⚠️ Failed to retrieve order ID $orderId: $e');
        }
      }

      debugPrint('✅ Retrieved ${detailedOrders.length} detailed orders');

      // Extract addresses from orders
      final uniqueOrderAddresses = _extractAddressesFromOrders(detailedOrders);

      // Cache the orders (not just addresses) for future use
      await _saveOrdersToCache(detailedOrders);

      if (mounted) {
        setState(() {
          _orderAddresses = uniqueOrderAddresses;
          _isLoadingOrders = false;
        });
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [ORDER CACHE] Error loading order addresses: $e');
      debugPrint('❌ Stack trace: $stackTrace');

      // Try to load from cache as fallback
      final cachedOrderAddresses = await _loadOrderAddressesFromCache();
      if (cachedOrderAddresses != null) {
        debugPrint('✅ [ORDER CACHE] Using cached order addresses as fallback');
        if (mounted) {
          setState(() {
            _orderAddresses = cachedOrderAddresses;
            _isLoadingOrders = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoadingOrders = false;
          });
        }
      }
    }
  }

  /// Save orders to cache
  Future<void> _saveOrdersToCache(List<DetailedUserOrder> orders) async {
    try {
      if (_currentUserId == null) {
        debugPrint('⚠️ [ORDER CACHE] No user ID, skipping cache save');
        return;
      }

      final storage = LocalStorageHelper();
      final cacheKey = 'user_orders_cache_$_currentUserId';
      final timestampKey = 'user_orders_cache_timestamp_$_currentUserId';
      final ordersJson = jsonEncode(
        orders.map((order) => order.toJson()).toList(),
      );
      await storage.setItem(cacheKey, ordersJson);
      final timestamp = DateTime.now().toIso8601String();
      await storage.setItem(timestampKey, timestamp);
      debugPrint('✅ [ORDER CACHE] Orders cached successfully');
      debugPrint('   📦 Cached ${orders.length} orders');
      debugPrint('   🕐 Cache timestamp: $timestamp');
    } catch (e) {
      debugPrint('❌ [ORDER CACHE] Error saving orders to cache: $e');
    }
  }

  /// Refresh order addresses from API in background
  /// Only refreshes if cache is older than 10 minutes
  Future<void> _refreshOrderAddressesFromApi() async {
    try {
      if (_currentUserId == null) {
        debugPrint('⚠️ [ORDER CACHE] No user ID, skipping refresh');
        return;
      }

      // Check cache timestamp before refreshing
      final storage = LocalStorageHelper();
      final timestampKey = 'user_orders_cache_timestamp_$_currentUserId';
      final timestamp = await storage.getItem(timestampKey);

      if (!_shouldRefreshCache(timestamp)) {
        debugPrint('⏭️ [ORDER CACHE] Skipping refresh - cache is still fresh');
        return;
      }

      debugPrint(
        '🔄 [ORDER CACHE] Refreshing orders from API in background...',
      );

      // Get order IDs
      final dashboard = await _usersManagerService.getUserDashboard(
        includeOrders: true,
        ordersLimit: 100,
      );
      final orderIds = dashboard.orders.map((o) => o.id).toList();

      if (orderIds.isEmpty) {
        debugPrint('⚠️ [ORDER CACHE] No orders found');
        return;
      }

      // Fetch detailed orders
      final List<DetailedUserOrder> detailedOrders = [];
      final limitedOrderIds = orderIds.take(50).toList();

      for (final orderId in limitedOrderIds) {
        try {
          final detailedOrder = await _usersManagerService.getUserOrder(
            orderId,
          );
          detailedOrders.add(detailedOrder);
        } catch (e) {
          debugPrint('⚠️ [ORDER CACHE] Failed to retrieve order $orderId: $e');
        }
      }

      // Cache the orders
      await _saveOrdersToCache(detailedOrders);

      // Extract addresses and update UI
      final addresses = _extractAddressesFromOrders(detailedOrders);

      if (mounted) {
        setState(() {
          _orderAddresses = addresses;
        });
      }

      debugPrint(
        '✅ [ORDER CACHE] Orders refreshed from API (${detailedOrders.length} orders, ${addresses.length} addresses)',
      );
    } catch (e) {
      debugPrint('⚠️ [ORDER CACHE] Error refreshing orders: $e');
    }
  }

  String _getAddressKey(String? address1, String? city, String? postcode) {
    return '${address1 ?? ''}_${city ?? ''}_${postcode ?? ''}';
  }

  @override
  Widget build(BuildContext context) {
    // Show loading only if both saved addresses and orders are loading
    final isFullyLoading = _isLoading && _isLoadingOrders;

    return Scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: _buildAppBar(context),
      body: isFullyLoading
          ? UnifiedLoadingWidget(goRoute: widget.goRoute)
          : _errorMessage != null
          ? _buildError(context)
          : _buildContent(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return OsmeaComponents.appBar(
      title: OsmeaComponents.text(
        'Addresses',
        textStyle: OsmeaTextStyle.titleLarge(context),
      ),
      backgroundColor: OsmeaColors.white,
      foregroundColor: OsmeaColors.thunder,
      elevation: 0,
      leading: OsmeaComponents.iconButton(
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/user-profile');
          }
        },
        icon: Icon(Icons.arrow_back, color: OsmeaColors.thunder),
        backgroundColor: OsmeaColors.transparent,
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.spacing16),
        child: OsmeaComponents.column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: OsmeaColors.amberFlame),
            OsmeaComponents.sizedBox(height: context.spacing12),
            OsmeaComponents.text(
              _errorMessage ?? 'An error occurred',
              textStyle: OsmeaTextStyle.titleMedium(context),
              textAlign: TextAlign.center,
            ),
            OsmeaComponents.sizedBox(height: context.spacing12),
            OsmeaComponents.button(text: 'Retry', onPressed: _loadAddresses),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    // Show empty view only when not loading and no addresses found
    final allAddresses = [..._savedAddresses, ..._orderAddresses];

    if (allAddresses.isEmpty && !_isLoadingOrders) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(context.spacing16),
          child: OsmeaComponents.column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 64,
                color: OsmeaColors.pewter,
              ),
              OsmeaComponents.sizedBox(height: context.spacing12),
              OsmeaComponents.text(
                'No addresses yet',
                textStyle: OsmeaTextStyle.titleMedium(
                  context,
                ).copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              OsmeaComponents.sizedBox(height: context.spacing6),
              OsmeaComponents.text(
                'Your addresses from orders will appear here',
                textStyle: OsmeaTextStyle.bodySmall(
                  context,
                ).copyWith(color: OsmeaColors.pewter),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAddresses,
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing16,
          vertical: context.spacing8,
        ),
        children: [
          // Saved Addresses Section
          if (_savedAddresses.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.only(
                top: context.spacing8,
                bottom: context.spacing8,
              ),
              child: OsmeaComponents.text(
                'Saved Addresses',
                textStyle: OsmeaTextStyle.titleMedium(
                  context,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            ..._savedAddresses.map(
              (address) =>
                  _buildAddressCard(context, address, isFromOrder: false),
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),
          ],

          // Order Addresses Section
          if (_orderAddresses.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.only(
                top: context.spacing8,
                bottom: context.spacing8,
              ),
              child: OsmeaComponents.text(
                'Addresses from Orders',
                textStyle: OsmeaTextStyle.titleMedium(
                  context,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            ..._orderAddresses.map(
              (address) =>
                  _buildAddressCard(context, address, isFromOrder: true),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddressCard(
    BuildContext context,
    UserAddress address, {
    bool isFromOrder = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: context.spacing8),
      padding: EdgeInsets.all(context.spacing12),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: OsmeaColors.silver, width: 1),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row with label and badges
          OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: OsmeaComponents.text(
                  address.label ?? address.addressType,
                  textStyle: OsmeaTextStyle.bodyMedium(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              OsmeaComponents.row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (address.isDefault) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.spacing8,
                        vertical: context.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: OsmeaColors.nordicBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: OsmeaComponents.text(
                        'Default',
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: OsmeaColors.nordicBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    OsmeaComponents.sizedBox(width: context.spacing4),
                  ],
                  if (isFromOrder)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.spacing8,
                        vertical: context.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: OsmeaColors.pewter.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: OsmeaComponents.text(
                        'From Order',
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: OsmeaColors.pewter,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          // Name
          if (address.firstName != null || address.lastName != null)
            OsmeaComponents.text(
              [
                address.firstName,
                address.lastName,
              ].where((e) => e != null && e.isNotEmpty).join(' '),
              textStyle: OsmeaTextStyle.bodySmall(
                context,
              ).copyWith(fontWeight: FontWeight.w500),
            ),
          if (address.firstName != null || address.lastName != null)
            OsmeaComponents.sizedBox(height: context.spacing4),
          // Address lines
          if (address.address1 != null && address.address1!.isNotEmpty)
            OsmeaComponents.text(
              address.address1!,
              textStyle: OsmeaTextStyle.bodySmall(context),
            ),
          if (address.address2 != null && address.address2!.isNotEmpty) ...[
            OsmeaComponents.sizedBox(height: context.spacing2),
            OsmeaComponents.text(
              address.address2!,
              textStyle: OsmeaTextStyle.bodySmall(context),
            ),
          ],
          OsmeaComponents.sizedBox(height: context.spacing4),
          // City, State, Postcode
          OsmeaComponents.text(
            [
              address.city,
              address.state,
              address.postcode,
            ].where((e) => e != null && e.isNotEmpty).join(', '),
            textStyle: OsmeaTextStyle.bodySmall(
              context,
            ).copyWith(color: OsmeaColors.pewter),
          ),
          if (address.country != null && address.country!.isNotEmpty) ...[
            OsmeaComponents.sizedBox(height: context.spacing2),
            OsmeaComponents.text(
              address.country!,
              textStyle: OsmeaTextStyle.bodySmall(
                context,
              ).copyWith(color: OsmeaColors.pewter),
            ),
          ],
          // Phone and Email
          if (address.phone != null && address.phone!.isNotEmpty) ...[
            OsmeaComponents.sizedBox(height: context.spacing4),
            OsmeaComponents.text(
              'Phone: ${address.phone}',
              textStyle: OsmeaTextStyle.bodySmall(
                context,
              ).copyWith(color: OsmeaColors.pewter),
            ),
          ],
          if (address.email != null && address.email!.isNotEmpty) ...[
            OsmeaComponents.sizedBox(height: context.spacing2),
            OsmeaComponents.text(
              'Email: ${address.email}',
              textStyle: OsmeaTextStyle.bodySmall(
                context,
              ).copyWith(color: OsmeaColors.pewter),
            ),
          ],
        ],
      ),
    );
  }
}
