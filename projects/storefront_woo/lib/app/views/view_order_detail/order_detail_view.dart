import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_order_detail/models/order_detail_view_model.dart';
import 'package:storefront_woo/app/views/view_order_detail/models/module/states.dart';
import 'package:storefront_woo/app/utils/unified_loading_widget.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_orders_response.dart';
import 'package:intl/intl.dart';

/// Order Detail View - Displays detailed order information with line items
class OrderDetailView
    extends MasterViewHydratedCubit<OrderDetailViewModel, OrderDetailState> {
  OrderDetailView({
    super.key,
    super.arguments,
    super.currentView,
    super.snackBarFunction,
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.horizontalPadding = const PaddingVisibility.disabled(),
    required super.goRoute,
  }) : super(
         coreAppBar: (context, viewModel) => _buildAppBar(context),
       );

  @override
  void initialContent(OrderDetailViewModel viewModel, BuildContext context) {
    viewModel.setArguments(arguments);
    final orderId = arguments['orderId'] as int?;
    if (orderId != null) {
      viewModel.loadOrder(orderId);
    }
  }

  @override
  Widget viewContent(
    BuildContext context,
    OrderDetailViewModel viewModel,
    OrderDetailState state,
  ) {
    debugPrint('📦 OrderDetailView: viewContent called with state: ${state.runtimeType}');
    
    if (state is OrderDetailInitialState) {
      debugPrint('📦 OrderDetailView: Initial state, triggering load...');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final orderId = arguments['orderId'] as int?;
        if (orderId != null) {
          viewModel.loadOrder(orderId);
        }
      });
      return UnifiedLoadingWidget(goRoute: goRoute);
    }

    if (state is OrderDetailLoadingState) {
      debugPrint('📦 OrderDetailView: Loading state');
      return UnifiedLoadingWidget(goRoute: goRoute);
    }

    if (state is OrderDetailErrorState) {
      debugPrint('📦 OrderDetailView: Error state: ${state.message}');
      return buildError(
        state.message,
        onRetry: () {
          final orderId = arguments['orderId'] as int?;
          if (orderId != null) {
            viewModel.loadOrder(orderId);
          }
        },
      );
    }

    if (state is OrderDetailLoadedState) {
      debugPrint('📦 OrderDetailView: Loaded state');
      return _buildOrderDetail(context, state.order, viewModel);
    }

    debugPrint('📦 OrderDetailView: Unknown state, showing loading');
    return UnifiedLoadingWidget(goRoute: goRoute);
  }

  Widget _buildOrderDetail(
    BuildContext context,
    DetailedUserOrder order,
    OrderDetailViewModel viewModel,
  ) {
    final horizontalPadding = context.spacing16;
    final verticalPadding = context.spacing12;
    
    return RefreshIndicator(
      onRefresh: () {
        final orderId = arguments['orderId'] as int?;
        if (orderId != null) {
          return viewModel.loadOrder(orderId);
        }
        return Future.value();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mediaQuery = MediaQuery.of(context);
          final safeAreaPadding = mediaQuery.padding;
          
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.only(
              left: horizontalPadding,
              right: horizontalPadding,
              top: verticalPadding,
              bottom: verticalPadding + safeAreaPadding.bottom,
            ),
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Order Header
                _buildOrderHeader(context, order),
                
                // Order Items
                if (order.lineItems != null && order.lineItems!.isNotEmpty) ...[
                  OsmeaComponents.sizedBox(height: context.spacing24),
                  Divider(color: OsmeaColors.silver, height: 1),
                  OsmeaComponents.sizedBox(height: context.spacing24),
                  _buildOrderItemsSection(context, order.lineItems!, order.currency),
                ],
                
                // Order Totals
                if (order.totals != null) ...[
                  OsmeaComponents.sizedBox(height: context.spacing24),
                  Divider(color: OsmeaColors.silver, height: 1),
                  OsmeaComponents.sizedBox(height: context.spacing24),
                  _buildOrderTotalsSection(context, order.totals!, order.currency),
                ],
                
                // Addresses - Collapsible
                if (order.billing != null || order.shipping != null) ...[
                  OsmeaComponents.sizedBox(height: context.spacing24),
                  Divider(color: OsmeaColors.silver, height: 1),
                  OsmeaComponents.sizedBox(height: context.spacing24),
                  _buildCollapsibleAddresses(context, order),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderHeader(BuildContext context, DetailedUserOrder order) {
    final date = _formatDate(order.dateCreated);
    final status = _formatStatus(order.status);
    final statusConfig = _getStatusBadgeConfig(context, order.status);
    
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        OsmeaComponents.row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  OsmeaComponents.text(
                    'Order #${order.orderNumber}',
                    textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing8),
                  OsmeaComponents.row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: OsmeaColors.pewter,
                      ),
                      OsmeaComponents.sizedBox(width: context.spacing6),
                      OsmeaComponents.text(
                        date,
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: OsmeaColors.pewter,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            OsmeaComponents.sizedBox(width: context.spacing12),
            // Status Badge with color - same styling as order history
            OsmeaComponents.container(
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing10,
                vertical: context.spacing6,
              ),
              decoration: BoxDecoration(
                color: statusConfig['background_color'] as Color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: OsmeaComponents.text(
                status,
                textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                  color: statusConfig['text_color'] as Color,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        if (order.paymentMethod != null) ...[
          OsmeaComponents.sizedBox(height: context.spacing16),
          OsmeaComponents.row(
            children: [
              Icon(
                Icons.payment_outlined,
                size: 16,
                color: OsmeaColors.pewter,
              ),
              OsmeaComponents.sizedBox(width: context.spacing8),
              OsmeaComponents.text(
                order.paymentMethod!,
                textStyle: OsmeaTextStyle.bodySmall(context),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildOrderItemsSection(
    BuildContext context,
    List<OrderLineItem> lineItems,
    String currency,
  ) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        OsmeaComponents.text(
          'Items',
          textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        OsmeaComponents.sizedBox(height: context.spacing16),
        ...lineItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            key: ValueKey('order_item_${item.id}_$index'),
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOrderItem(context, item, currency),
              if (index < lineItems.length - 1) ...[
                OsmeaComponents.sizedBox(height: context.spacing12),
                Divider(color: OsmeaColors.silver, height: 1),
                OsmeaComponents.sizedBox(height: context.spacing12),
              ],
            ],
          );
        }),
      ],
    );
  }

  Widget _buildOrderItem(
    BuildContext context,
    OrderLineItem item,
    String currency,
  ) {
    return OsmeaComponents.row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: OsmeaColors.silver,
              width: 1,
            ),
            color: OsmeaColors.grayMaterial[50],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: item.productImage != null && item.productImage!.isNotEmpty
                ? OsmeaComponents.image(
                    imageUrl: item.productImage!,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    variant: ImageVariant.normal,
                    cacheWidth: 200,
                    showLoadingIndicator: true,
                    errorWidget: OsmeaComponents.center(
                      child: Icon(
                        Icons.image_outlined,
                        color: OsmeaColors.grayMaterial[400],
                        size: 20,
                      ),
                    ),
                  )
                : OsmeaComponents.center(
                    child: Icon(
                      Icons.image_outlined,
                      color: OsmeaColors.grayMaterial[400],
                      size: 20,
                    ),
                  ),
          ),
        ),
        OsmeaComponents.sizedBox(width: context.spacing12),
        Expanded(
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              OsmeaComponents.text(
                item.name,
                textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              OsmeaComponents.sizedBox(height: context.spacing4),
              OsmeaComponents.text(
                '${item.quantity}x • $currency ${item.total.toStringAsFixed(2)}',
                textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                  color: OsmeaColors.pewter,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderTotalsSection(
    BuildContext context,
    OrderTotals totals,
    String currency,
  ) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        OsmeaComponents.text(
          'Summary',
          textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        OsmeaComponents.sizedBox(height: context.spacing16),
        _buildTotalRow(context, 'Subtotal', totals.subtotal, currency),
        OsmeaComponents.sizedBox(height: context.spacing12),
        _buildTotalRow(context, 'Shipping', totals.shipping, currency),
        OsmeaComponents.sizedBox(height: context.spacing12),
        _buildTotalRow(context, 'Tax', totals.tax, currency),
        OsmeaComponents.sizedBox(height: context.spacing16),
        Divider(color: OsmeaColors.silver, height: 1),
        OsmeaComponents.sizedBox(height: context.spacing16),
        _buildTotalRow(
          context,
          'Total',
          totals.total,
          currency,
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildTotalRow(
    BuildContext context,
    String label,
    double value,
    String currency, {
    bool isTotal = false,
  }) {
    return OsmeaComponents.row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        OsmeaComponents.text(
          label,
          textStyle: isTotal
              ? OsmeaTextStyle.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                )
              : OsmeaTextStyle.bodySmall(context).copyWith(
                  color: OsmeaColors.pewter,
                ),
        ),
        OsmeaComponents.text(
          '$currency ${value.toStringAsFixed(2)}',
          textStyle: isTotal
              ? OsmeaTextStyle.titleMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                )
              : OsmeaTextStyle.bodySmall(context).copyWith(
                  fontWeight: FontWeight.w500,
                ),
        ),
      ],
    );
  }

  Widget _buildCollapsibleAddresses(
    BuildContext context,
    DetailedUserOrder order,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme: IconThemeData(
          color: OsmeaColors.transparent,
          size: 0,
        ),
        expansionTileTheme: ExpansionTileThemeData(
          iconColor: OsmeaColors.transparent,
          collapsedIconColor: OsmeaColors.transparent,
        ),
      ),
      child: OsmeaComponents.collapse(
        size: CollapseSize.small,
        variant: CollapseVariant.ghost,
        mode: CollapseBehaviorMode.multiple,
        padding: EdgeInsets.zero,
        children: [
          if (order.billing != null)
            OsmeaCollapsePanel(
              header: OsmeaComponents.row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.payment_outlined,
                    size: 18,
                    color: OsmeaColors.thunder,
                  ),
                  OsmeaComponents.sizedBox(width: context.spacing8),
                  Expanded(
                    child: OsmeaComponents.text(
                      'Billing Address',
                      textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: const SizedBox.shrink(),
              value: 'billing',
              body: _buildBillingAddressContent(context, order.billing!),
            ),
          if (order.shipping != null)
            OsmeaCollapsePanel(
              header: OsmeaComponents.row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_shipping_outlined,
                    size: 18,
                    color: OsmeaColors.thunder,
                  ),
                  OsmeaComponents.sizedBox(width: context.spacing8),
                  Expanded(
                    child: OsmeaComponents.text(
                      'Shipping Address',
                      textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: const SizedBox.shrink(),
              value: 'shipping',
              body: _buildShippingAddressContent(context, order.shipping!),
            ),
        ],
      ),
    );
  }

  Widget _buildBillingAddressContent(
    BuildContext context,
    UserBillingAddress address,
  ) {
    final addressLines = <String>[];
    if (address.firstName != null || address.lastName != null) {
      addressLines.add('${address.firstName ?? ''} ${address.lastName ?? ''}'.trim());
    }
    if (address.company != null && address.company!.isNotEmpty) {
      addressLines.add(address.company!);
    }
    if (address.address1 != null && address.address1!.isNotEmpty) {
      addressLines.add(address.address1!);
    }
    if (address.address2 != null && address.address2!.isNotEmpty) {
      addressLines.add(address.address2!);
    }
    final cityState = [
      if (address.city != null) address.city,
      if (address.state != null) address.state,
      if (address.postcode != null) address.postcode,
    ].where((e) => e != null && e.isNotEmpty).join(', ');
    if (cityState.isNotEmpty) {
      addressLines.add(cityState);
    }
    if (address.country != null && address.country!.isNotEmpty) {
      addressLines.add(address.country!);
    }
    
    return Padding(
      padding: EdgeInsets.only(top: context.spacing8),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...addressLines.map((line) => OsmeaComponents.text(
            line,
            textStyle: OsmeaTextStyle.bodySmall(context),
          )).toList(),
          if (address.email != null && address.email!.isNotEmpty) ...[
            OsmeaComponents.sizedBox(height: context.spacing8),
            Divider(color: OsmeaColors.silver, height: 1),
            OsmeaComponents.sizedBox(height: context.spacing8),
            OsmeaComponents.listItem(
              leading: Icon(Icons.email_outlined, size: 16, color: OsmeaColors.pewter),
              title: OsmeaComponents.text(
                address.email!,
                textStyle: OsmeaTextStyle.bodySmall(context),
              ),
              variant: ListItemVariant.dense,
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
            ),
          ],
          if (address.phone != null && address.phone!.isNotEmpty) ...[
            OsmeaComponents.sizedBox(height: context.spacing4),
            OsmeaComponents.listItem(
              leading: Icon(Icons.phone_outlined, size: 16, color: OsmeaColors.pewter),
              title: OsmeaComponents.text(
                address.phone!,
                textStyle: OsmeaTextStyle.bodySmall(context),
              ),
              variant: ListItemVariant.dense,
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShippingAddressContent(
    BuildContext context,
    UserShippingAddress address,
  ) {
    final addressLines = <String>[];
    if (address.firstName != null || address.lastName != null) {
      addressLines.add('${address.firstName ?? ''} ${address.lastName ?? ''}'.trim());
    }
    if (address.company != null && address.company!.isNotEmpty) {
      addressLines.add(address.company!);
    }
    if (address.address1 != null && address.address1!.isNotEmpty) {
      addressLines.add(address.address1!);
    }
    if (address.address2 != null && address.address2!.isNotEmpty) {
      addressLines.add(address.address2!);
    }
    final cityState = [
      if (address.city != null) address.city,
      if (address.state != null) address.state,
      if (address.postcode != null) address.postcode,
    ].where((e) => e != null && e.isNotEmpty).join(', ');
    if (cityState.isNotEmpty) {
      addressLines.add(cityState);
    }
    if (address.country != null && address.country!.isNotEmpty) {
      addressLines.add(address.country!);
    }
    
    return Padding(
      padding: EdgeInsets.only(top: context.spacing8),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: addressLines.map<Widget>((line) => OsmeaComponents.text(
          line,
          textStyle: OsmeaTextStyle.bodySmall(context),
        )).toList(),
      ),
    );
  }


  Map<String, dynamic> _getStatusBadgeConfig(BuildContext context, String status) {
    // Use the same color logic as order history view
    final statusColors = _getStatusColors(status);
    
    return {
      'background_color': statusColors['background'] as Color,
      'text_color': statusColors['text'] as Color,
    };
  }

  /// Get status colors based on order status - same as order history view
  Map<String, Color> _getStatusColors(String status) {
    // Normalize status - handle both 'on-hold' and 'on_hold' formats
    final statusLower = status.toLowerCase().replaceAll('_', '-');

    // Get default colors directly - same as order history view
    Color bgColor = _getDefaultStatusBackgroundColor(statusLower);
    Color textColor = _getDefaultStatusTextColor(statusLower);

    return {'background': bgColor, 'text': textColor};
  }

  /// Get default background color for status - same as order history view
  Color _getDefaultStatusBackgroundColor(String status) {
    switch (status) {
      case 'completed':
        return OsmeaColors.forestHeart.withValues(alpha: 0.15);
      case 'processing':
        return OsmeaColors.blue.withValues(alpha: 0.15);
      case 'pending':
        return OsmeaColors.sunsetGlow.withValues(alpha: 0.15);
      case 'on-hold':
        return OsmeaColors.amberFlame.withValues(alpha: 0.15);
      case 'cancelled':
      case 'refunded':
      case 'failed':
        return OsmeaColors.red.withValues(alpha: 0.15);
      default:
        return OsmeaColors.grayMaterial[100] ??
            OsmeaColors.pewter.withValues(alpha: 0.1);
    }
  }

  /// Get default text color for status - same as order history view
  Color _getDefaultStatusTextColor(String status) {
    switch (status) {
      case 'completed':
        return OsmeaColors.forestHeart;
      case 'processing':
        return OsmeaColors.blue;
      case 'pending':
        return OsmeaColors.sunsetGlow;
      case 'on-hold':
        return OsmeaColors.amberFlame;
      case 'cancelled':
      case 'refunded':
      case 'failed':
        return OsmeaColors.red;
      default:
        return OsmeaColors.pewter;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      // Use DateTimeHelper for better formatting
      return DateTimeHelper.formatDateTimeWithoutClock(date);
    } catch (e) {
      // Fallback to simple format
      try {
        final date = DateTime.parse(dateString);
        return DateFormat('MMM dd, yyyy').format(date);
      } catch (e2) {
        return dateString;
      }
    }
  }

  String _formatStatus(String status) {
    // Convert status to readable format - same as order history view
    // Handle both underscore and hyphen separators
    final parts = status.contains('_') ? status.split('_') : status.split('-');
    return parts
        .map((word) {
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

}

PreferredSizeWidget _buildAppBar(BuildContext context) {
  final configHelper = AssetConfigHelper();
  
  Color getColor(String key, Color fallback) {
    try {
      final colorString = configHelper.getString('order_detail_view.app_bar.$key');
      if (colorString.isNotEmpty && colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load app bar color $key: $e');
    }
    return fallback;
  }
  
  final title = configHelper.getString(
    'order_detail_view.app_bar.title',
    'Order Details',
  );
  final backgroundColor = getColor('backgroundColor', OsmeaColors.paperWhite);
  final foregroundColor = getColor('foregroundColor', OsmeaColors.thunder);
  final titleColor = getColor('titleColor', OsmeaColors.thunder);
  final iconColor = getColor('iconColor', OsmeaColors.thunder);
  final elevation = configHelper.getDouble('order_detail_view.app_bar.elevation', 0.0);
  
  return OsmeaComponents.appBar(
    title: OsmeaComponents.text(
      title,
      color: titleColor,
      textStyle: OsmeaTextStyle.titleLarge(context),
    ),
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    elevation: elevation,
    leading: OsmeaComponents.iconButton(
      onPressed: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/orders-history');
        }
      },
      icon: Icon(Icons.arrow_back, color: iconColor),
      backgroundColor: OsmeaColors.transparent,
    ),
  );
}
