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
  List<UserAddress> _savedAddresses = [];
  List<UserAddress> _orderAddresses = [];
  String? _errorMessage;

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
      // Load saved addresses
      final savedResponse = await _usersManagerService.getUserAddresses();
      
      // Load order addresses
      await _loadOrderAddresses();
      
      setState(() {
        _savedAddresses = savedResponse.addresses;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading addresses: $e');
      setState(() {
        _errorMessage = 'Failed to load addresses. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadOrderAddresses() async {
    try {
      debugPrint('📍 Starting to load order addresses...');
      
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
        return;
      }

      if (orderIds.isEmpty) {
        debugPrint('⚠️ No orders found, skipping address extraction');
        return;
      }

      debugPrint('📦 Fetching order details for ${orderIds.length} orders...');

      // Fetch detailed order information using getUserOrder endpoint
      final List<DetailedUserOrder> detailedOrders = [];
      // Limit to first 50 orders to avoid too many API calls
      final limitedOrderIds = orderIds.take(50).toList();
      
      for (final orderId in limitedOrderIds) {
        try {
          final detailedOrder = await _usersManagerService.getUserOrder(orderId);
          detailedOrders.add(detailedOrder);
          debugPrint('  ✅ Retrieved order ID: $orderId');
        } catch (e) {
          debugPrint('  ⚠️ Failed to retrieve order ID $orderId: $e');
        }
      }

      debugPrint('✅ Retrieved ${detailedOrders.length} detailed orders');

      // Extract unique addresses from detailed orders
      final Set<String> seenAddresses = {};
      final List<UserAddress> uniqueOrderAddresses = [];

      debugPrint('🔄 Processing ${detailedOrders.length} orders to extract addresses...');

      for (final order in detailedOrders) {
        debugPrint('📋 Processing order ID: ${order.id}, billing: ${order.billing != null}, shipping: ${order.shipping != null}');
        
        // Process billing address
        if (order.billing != null) {
          final billing = order.billing!;
          final addressKey = _getAddressKey(billing.address1, billing.city, billing.postcode);
          
          debugPrint('  💳 Billing address: ${billing.address1}, city: ${billing.city}, key: $addressKey');
          
          if (!seenAddresses.contains(addressKey) && 
              billing.address1 != null && 
              billing.address1!.isNotEmpty) {
            seenAddresses.add(addressKey);
            uniqueOrderAddresses.add(UserAddress(
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
            ));
            debugPrint('  ✅ Added billing address');
          } else {
            debugPrint('  ⏭️ Skipped duplicate billing address');
          }
        }

        // Process shipping address
        if (order.shipping != null) {
          final shipping = order.shipping!;
          final addressKey = _getAddressKey(shipping.address1, shipping.city, shipping.postcode);
          
          debugPrint('  📦 Shipping address: ${shipping.address1}, city: ${shipping.city}, key: $addressKey');
          
          if (!seenAddresses.contains(addressKey) && 
              shipping.address1 != null && 
              shipping.address1!.isNotEmpty) {
            seenAddresses.add(addressKey);
            uniqueOrderAddresses.add(UserAddress(
              id: order.id + 1000000, // Offset to avoid conflicts with saved addresses
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
              phone: null, // Shipping address doesn't have phone in UserShippingAddress
              isDefault: false,
              createdAt: order.dateCreated,
              updatedAt: order.dateCreated,
            ));
            debugPrint('  ✅ Added shipping address');
          } else {
            debugPrint('  ⏭️ Skipped duplicate shipping address');
          }
        }
      }

      debugPrint('✅ Extracted ${uniqueOrderAddresses.length} unique addresses from orders');

      setState(() {
        _orderAddresses = uniqueOrderAddresses;
      });
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading order addresses: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      // Don't show error for order addresses, just log it
    }
  }

  String _getAddressKey(String? address1, String? city, String? postcode) {
    return '${address1 ?? ''}_${city ?? ''}_${postcode ?? ''}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _isLoading
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
      backgroundColor: OsmeaColors.paperWhite,
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
            Icon(
              Icons.error_outline,
              size: 64,
              color: OsmeaColors.amberFlame,
            ),
            OsmeaComponents.sizedBox(height: context.spacing12),
            OsmeaComponents.text(
              _errorMessage ?? 'An error occurred',
              textStyle: OsmeaTextStyle.titleMedium(context),
              textAlign: TextAlign.center,
            ),
            OsmeaComponents.sizedBox(height: context.spacing12),
            OsmeaComponents.button(
              text: 'Retry',
              onPressed: _loadAddresses,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final allAddresses = [..._savedAddresses, ..._orderAddresses];
    
    if (allAddresses.isEmpty) {
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
                textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              OsmeaComponents.sizedBox(height: context.spacing6),
              OsmeaComponents.text(
                'Add your first address to get started',
                textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                  color: OsmeaColors.pewter,
                ),
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
                textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ..._savedAddresses.map((address) => _buildAddressCard(context, address, isFromOrder: false)),
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
                textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ..._orderAddresses.map((address) => _buildAddressCard(context, address, isFromOrder: true)),
          ],
        ],
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, UserAddress address, {bool isFromOrder = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: context.spacing8),
      padding: EdgeInsets.all(context.spacing12),
      decoration: BoxDecoration(
        color: OsmeaColors.paperWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: OsmeaColors.silver,
          width: 1,
        ),
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
                  textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
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
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                fontWeight: FontWeight.w500,
              ),
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
            textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.pewter,
            ),
          ),
          if (address.country != null && address.country!.isNotEmpty) ...[
            OsmeaComponents.sizedBox(height: context.spacing2),
            OsmeaComponents.text(
              address.country!,
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                color: OsmeaColors.pewter,
              ),
            ),
          ],
          // Phone and Email
          if (address.phone != null && address.phone!.isNotEmpty) ...[
            OsmeaComponents.sizedBox(height: context.spacing4),
            OsmeaComponents.text(
              'Phone: ${address.phone}',
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                color: OsmeaColors.pewter,
              ),
            ),
          ],
          if (address.email != null && address.email!.isNotEmpty) ...[
            OsmeaComponents.sizedBox(height: context.spacing2),
            OsmeaComponents.text(
              'Email: ${address.email}',
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                color: OsmeaColors.pewter,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
