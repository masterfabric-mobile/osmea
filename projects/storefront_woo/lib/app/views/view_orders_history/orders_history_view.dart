import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_orders_history/models/orders_history_view_model.dart';
import 'package:storefront_woo/app/views/view_orders_history/models/module/states.dart';
import 'package:storefront_woo/app/utils/unified_loading_widget.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_dashboard_response.dart';
import 'package:intl/intl.dart';

/// Orders History View - Displays user's order history from OSMEA Users Manager plugin
class OrdersHistoryView
    extends MasterViewHydratedCubit<OrdersHistoryViewModel, OrdersHistoryState> {
  OrdersHistoryView({
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
  void initialContent(OrdersHistoryViewModel viewModel, BuildContext context) {
    viewModel.setArguments(arguments);
    viewModel.loadOrders();
  }

  @override
  Widget viewContent(
    BuildContext context,
    OrdersHistoryViewModel viewModel,
    OrdersHistoryState state,
  ) {
    debugPrint('📦 OrdersHistoryView: viewContent called with state: ${state.runtimeType}');
    
    if (state is OrdersHistoryInitialState) {
      debugPrint('📦 OrdersHistoryView: Initial state, triggering load...');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadOrders();
      });
      return UnifiedLoadingWidget(goRoute: goRoute);
    }

    if (state is OrdersHistoryLoadingState) {
      debugPrint('📦 OrdersHistoryView: Loading state');
      return UnifiedLoadingWidget(goRoute: goRoute);
    }

    if (state is OrdersHistoryErrorState) {
      debugPrint('📦 OrdersHistoryView: Error state: ${state.message}');
      return buildError(
        state.message,
        onRetry: () => viewModel.loadOrders(),
      );
    }

    if (state is OrdersHistoryLoadedState) {
      debugPrint('📦 OrdersHistoryView: Loaded state with ${state.orders.length} orders');
      return _buildOrdersList(context, state.orders, viewModel);
    }

    debugPrint('📦 OrdersHistoryView: Unknown state, showing loading');
    return UnifiedLoadingWidget(goRoute: goRoute);
  }

  Widget _buildOrdersList(
    BuildContext context,
    List<UserOrder> orders,
    OrdersHistoryViewModel viewModel,
  ) {
    final configHelper = AssetConfigHelper();
    final horizontalPadding = configHelper.getDouble(
      'orders_history_view.component_spacing.horizontal',
      context.spacing16,
    );
    
    if (orders.isEmpty) {
      final emptyIconColor = _getColorFromConfig(
        'orders_history_view.empty_state.icon_color',
        OsmeaColors.pewter,
      );
      final emptyIconSize = configHelper.getDouble(
        'orders_history_view.empty_state.icon_size',
        64.0,
      );
      final emptyTitleColor = _getColorFromConfig(
        'orders_history_view.empty_state.title_color',
        OsmeaColors.thunder,
      );
      final emptySubtitleColor = _getColorFromConfig(
        'orders_history_view.empty_state.subtitle_color',
        OsmeaColors.pewter,
      );
      
      return Center(
        child: Padding(
          padding: EdgeInsets.all(context.spacing16),
          child: OsmeaComponents.column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: emptyIconSize,
                color: emptyIconColor,
              ),
              OsmeaComponents.sizedBox(height: context.spacing12),
              OsmeaComponents.text(
                'No orders yet',
                textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                  color: emptyTitleColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              OsmeaComponents.sizedBox(height: context.spacing6),
              OsmeaComponents.text(
                'Your order history will appear here',
                textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                  color: emptySubtitleColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.loadOrders(),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: context.spacing8,
        ),
        itemCount: orders.length,
        separatorBuilder: (context, index) => SizedBox(height: context.spacing8),
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(context, order);
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, UserOrder order) {
    final date = _formatDate(order.dateCreated);
    final status = _formatStatus(order.status);
    final total = '${order.currency} ${order.total.toStringAsFixed(2)}';
    
    // Get status badge config
    final statusConfig = _getStatusBadgeConfig(context, order.status);
    
    return OsmeaComponents.basicCard(
      variant: ComponentAppearance.outlined,
      size: ComponentSize.medium,
      backgroundColor: OsmeaColors.white,
      borderColor: OsmeaColors.black.withOpacity(0.1),
      borderWidth: 0.5,
      borderRadius: BorderRadius.circular(8),
      onTap: () => context.go('/order-detail/${order.id}'),
      customContent: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // First Row: Order Number and Status
          OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OsmeaComponents.text(
                      'Order #${order.orderNumber}',
                      textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: OsmeaColors.black,
                      ),
                    ),
                    OsmeaComponents.sizedBox(height: context.spacing4),
                    OsmeaComponents.text(
                      date,
                      textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                        color: OsmeaColors.black.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              OsmeaComponents.sizedBox(width: context.spacing8),
              OsmeaComponents.chips(
                text: status,
                variant: ChipsVariant.custom,
                style: ChipsStyle.outlined,
                size: ChipsSize.small,
                backgroundColor: OsmeaColors.transparent,
                textColor: OsmeaColors.black.withOpacity(0.8),
                borderColor: OsmeaColors.black.withOpacity(0.2),
                borderWidth: 0.5,
              ),
            ],
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          Divider(
            color: OsmeaColors.black.withOpacity(0.1),
            height: 1,
            thickness: 0.5,
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          // Second Row: Payment Method, Total, and Chevron
          OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (order.paymentMethod != null)
                      OsmeaComponents.text(
                        order.paymentMethod!,
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: OsmeaColors.black.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (order.paymentMethod != null)
                      OsmeaComponents.sizedBox(height: context.spacing4),
                    OsmeaComponents.text(
                      total,
                      textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: OsmeaColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              OsmeaComponents.sizedBox(width: context.spacing8),
              Icon(
                Icons.chevron_right,
                color: OsmeaColors.black.withOpacity(0.4),
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusBadgeConfig(BuildContext context, String status) {
    final configHelper = AssetConfigHelper();
    final statusLower = status.toLowerCase();
    
    // Get status-specific colors or default
    final statusKey = statusLower.replaceAll('-', '_');
    final bgColorKey = 'orders_history_view.status_badge.colors.$statusKey.background';
    final textColorKey = 'orders_history_view.status_badge.colors.$statusKey.text';
    
    Color bgColor = _getColorFromConfig(bgColorKey, _getDefaultStatusColor(statusLower).withOpacity(0.1));
    Color textColor = _getColorFromConfig(textColorKey, _getDefaultStatusColor(statusLower));
    
    // If status-specific config not found, try default
    if (bgColor == _getDefaultStatusColor(statusLower).withOpacity(0.1)) {
      bgColor = _getColorFromConfig(
        'orders_history_view.status_badge.colors.default.background',
        bgColor,
      );
    }
    if (textColor == _getDefaultStatusColor(statusLower)) {
      textColor = _getColorFromConfig(
        'orders_history_view.status_badge.colors.default.text',
        textColor,
      );
    }
    
    return {
      'background_color': bgColor,
      'text_color': textColor,
      'border_radius': configHelper.getDouble(
        'orders_history_view.status_badge.borderRadius',
        8.0,
      ),
      'padding_horizontal': configHelper.getDouble(
        'orders_history_view.status_badge.padding_horizontal',
        8.0,
      ),
      'padding_vertical': configHelper.getDouble(
        'orders_history_view.status_badge.padding_vertical',
        4.0,
      ),
      'font_size': configHelper.getDouble(
        'orders_history_view.status_badge.fontSize',
        12.0,
      ),
    };
  }

  Color _getDefaultStatusColor(String status) {
    switch (status) {
      case 'completed':
      case 'processing':
        return OsmeaColors.forestHeart;
      case 'pending':
      case 'on-hold':
        return OsmeaColors.sunsetGlow;
      case 'cancelled':
      case 'refunded':
      case 'failed':
        return OsmeaColors.amberFlame;
      default:
        return OsmeaColors.pewter;
    }
  }

  Color _getColorFromConfig(String key, Color fallback) {
    try {
      final configHelper = AssetConfigHelper();
      final colorString = configHelper.getString(key);
      if (colorString.isNotEmpty && colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load color $key: $e');
    }
    return fallback;
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
    // Convert status to readable format
    return status.split('_').map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

}

PreferredSizeWidget _buildAppBar(BuildContext context) {
  final configHelper = AssetConfigHelper();
  
  Color getColor(String key, Color fallback) {
    try {
      final colorString = configHelper.getString('orders_history_view.app_bar.$key');
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
    'orders_history_view.app_bar.title',
    'Order History',
  );
  final backgroundColor = getColor('backgroundColor', OsmeaColors.paperWhite);
  final foregroundColor = getColor('foregroundColor', OsmeaColors.thunder);
  final titleColor = getColor('titleColor', OsmeaColors.thunder);
  final iconColor = getColor('iconColor', OsmeaColors.thunder);
  final elevation = configHelper.getDouble('orders_history_view.app_bar.elevation', 0.0);
  
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
          context.go('/profile');
        }
      },
      icon: Icon(Icons.arrow_back, color: iconColor),
      backgroundColor: OsmeaColors.transparent,
    ),
  );
}
