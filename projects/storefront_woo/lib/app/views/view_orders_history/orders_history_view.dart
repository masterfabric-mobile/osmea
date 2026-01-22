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
    extends
        MasterViewHydratedCubit<OrdersHistoryViewModel, OrdersHistoryState> {
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
  }) : super(coreAppBar: (context, viewModel) => _buildAppBar(context));

  @override
  void initialContent(OrdersHistoryViewModel viewModel, BuildContext context) {
    viewModel.setArguments(arguments);
    // If state is already loaded from cache, refresh in background
    // Otherwise, load orders normally
    final currentState = viewModel.state;
    if (currentState is OrdersHistoryLoadedState) {
      // Cache'den yüklendi, arka planda refresh yap
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadOrders(showCached: true);
      });
    } else {
      // Cache yok, normal yükleme
      viewModel.loadOrders(showCached: false);
    }
  }

  @override
  Widget viewContent(
    BuildContext context,
    OrdersHistoryViewModel viewModel,
    OrdersHistoryState state,
  ) {
    debugPrint(
      '📦 OrdersHistoryView: viewContent called with state: ${state.runtimeType}',
    );

    if (state is OrdersHistoryInitialState) {
      debugPrint('📦 OrdersHistoryView: Initial state, triggering load...');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadOrders(showCached: false);
      });
      return UnifiedLoadingWidget(goRoute: goRoute);
    }

    if (state is OrdersHistoryLoadingState) {
      debugPrint('📦 OrdersHistoryView: Loading state');
      // Eğer cache'de veri varsa, loading gösterirken cache'deki veriyi göster
      final cachedState = viewModel.cachedLoadedState;
      if (cachedState != null) {
        return _buildOrdersList(context, cachedState.orders, viewModel);
      }
      return UnifiedLoadingWidget(goRoute: goRoute);
    }

    if (state is OrdersHistoryErrorState) {
      debugPrint('📦 OrdersHistoryView: Error state: ${state.message}');
      return buildError(state.message, onRetry: () => viewModel.loadOrders(showCached: false));
    }

    if (state is OrdersHistoryLoadedState) {
      debugPrint(
        '📦 OrdersHistoryView: Loaded state with ${state.orders.length} orders',
      );
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
      )!;
      final emptyIconSize = configHelper.getDouble(
        'orders_history_view.empty_state.icon_size',
        64.0,
      );
      final emptyTitleColor = _getColorFromConfig(
        'orders_history_view.empty_state.title_color',
        OsmeaColors.thunder,
      )!;
      final emptySubtitleColor = _getColorFromConfig(
        'orders_history_view.empty_state.subtitle_color',
        OsmeaColors.pewter,
      )!;

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
                textStyle: OsmeaTextStyle.titleMedium(
                  context,
                ).copyWith(color: emptyTitleColor, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              OsmeaComponents.sizedBox(height: context.spacing6),
              OsmeaComponents.text(
                'Your order history will appear here',
                textStyle: OsmeaTextStyle.bodySmall(
                  context,
                ).copyWith(color: emptySubtitleColor),
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
        separatorBuilder: (context, index) =>
            SizedBox(height: context.spacing8),
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

    // Get status badge colors
    final statusColors = _getStatusColors(order.status);

    return OsmeaComponents.container(
      margin: EdgeInsets.only(bottom: context.spacing8),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              OsmeaColors.grayMaterial[100] ??
              OsmeaColors.pewter.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/order-detail/${order.id}'),
          borderRadius: BorderRadius.circular(20),
          child: OsmeaComponents.padding(
            padding: EdgeInsets.all(context.spacing16),
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header: Order Number with icon
                OsmeaComponents.row(
                  children: [
                    OsmeaComponents.container(
                      padding: EdgeInsets.all(context.spacing8),
                      decoration: BoxDecoration(
                        color:
                            OsmeaColors.grayMaterial[50] ??
                            OsmeaColors.pewter.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.receipt_long_rounded,
                        size: 20,
                        color: OsmeaColors.thunder,
                      ),
                    ),
                    OsmeaComponents.sizedBox(width: context.spacing12),
                    Expanded(
                      child: OsmeaComponents.column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OsmeaComponents.text(
                            'Order #${order.orderNumber}',
                            textStyle: OsmeaTextStyle.titleMedium(context)
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: OsmeaColors.thunder,
                                ),
                          ),
                          OsmeaComponents.sizedBox(height: context.spacing2),
                          OsmeaComponents.row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 12,
                                color: OsmeaColors.pewter,
                              ),
                              OsmeaComponents.sizedBox(width: context.spacing4),
                              OsmeaComponents.text(
                                date,
                                textStyle: OsmeaTextStyle.bodySmall(context)
                                    .copyWith(
                                      color: OsmeaColors.pewter,
                                      fontSize: 12,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Status Badge with color
                    OsmeaComponents.container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.spacing10,
                        vertical: context.spacing6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColors['background'],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: OsmeaComponents.text(
                        status,
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: statusColors['text'],
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                OsmeaComponents.sizedBox(height: context.spacing16),
                // Product Images - Stacked overlapping thumbnails
                _buildProductImages(context, order),
                OsmeaComponents.sizedBox(height: context.spacing16),
                // Total Price with icon - Minimal style
                OsmeaComponents.row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OsmeaComponents.row(
                      children: [
                        Icon(
                          Icons.payments_rounded,
                          size: 20,
                          color: OsmeaColors.thunder,
                        ),
                        OsmeaComponents.sizedBox(width: context.spacing8),
                        OsmeaComponents.text(
                          '${order.currency} ${order.total.toStringAsFixed(2)}',
                          textStyle: OsmeaTextStyle.titleMedium(context)
                              .copyWith(
                                fontWeight: FontWeight.w700,
                                color: OsmeaColors.thunder,
                              ),
                        ),
                      ],
                    ),
                    OsmeaComponents.container(
                      padding: EdgeInsets.all(context.spacing6),
                      decoration: BoxDecoration(
                        color:
                            OsmeaColors.grayMaterial[50] ??
                            OsmeaColors.pewter.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: OsmeaColors.pewter,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build product images row (stacked overlapping thumbnails + count if more)
  Widget _buildProductImages(BuildContext context, UserOrder order) {
    final lineItems = order.lineItems;

    // Debug
    debugPrint(
      '🖼️ Order #${order.orderNumber}: lineItems = ${lineItems?.length ?? 0}',
    );
    if (lineItems != null && lineItems.isNotEmpty) {
      debugPrint(
        '🖼️ Order #${order.orderNumber}: First item = ${lineItems.first.name}, image = ${lineItems.first.productImage}',
      );
    }

    if (lineItems == null || lineItems.isEmpty) {
      debugPrint('⚠️ Order #${order.orderNumber}: No lineItems available');
      return const SizedBox.shrink();
    }

    // Get all items with images
    final allItemsWithImages = lineItems.where((item) {
      final hasImage =
          item.productImage != null &&
          item.productImage!.isNotEmpty &&
          item.productImage!.trim().isNotEmpty;
      return hasImage;
    }).toList();

    debugPrint(
      '🖼️ Order #${order.orderNumber}: itemsWithImages = ${allItemsWithImages.length}',
    );

    if (allItemsWithImages.isEmpty) {
      debugPrint('⚠️ Order #${order.orderNumber}: No items with images');
      return const SizedBox.shrink();
    }

    // Take first 3 items to display in stack
    final itemsToShow = allItemsWithImages.take(3).toList();
    final remainingCount = allItemsWithImages.length > 3
        ? allItemsWithImages.length - 3
        : 0;
    final totalCount = allItemsWithImages.length;

    // Stack width calculation: first image + overlapping offset for each subsequent image
    final imageSize = 48.0;
    final overlapOffset = 20.0; // How much each image overlaps
    final stackWidth =
        imageSize +
        (itemsToShow.length > 1
            ? (itemsToShow.length - 1) * overlapOffset
            : 0) +
        (remainingCount > 0 ? overlapOffset : 0);

    return OsmeaComponents.row(
      children: [
        OsmeaComponents.container(
          width: stackWidth,
          height: imageSize,
          child: Stack(
            children: [
              // Stacked product images (overlapping)
              ...itemsToShow.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                debugPrint(
                  '✅ Order #${order.orderNumber}: Showing image ${index + 1} = ${item.productImage}',
                );

                return Positioned(
                  left: index * overlapOffset,
                  child: OsmeaComponents.container(
                    width: imageSize,
                    height: imageSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: OsmeaColors.grayMaterial[50],
                      border: Border.all(color: OsmeaColors.white, width: 2.5),
                    ),
                    child: ClipOval(
                      child: _buildShimmerImage(
                        imageUrl: item.productImage!,
                        width: imageSize,
                        height: imageSize,
                      ),
                    ),
                  ),
                );
              }).toList(),
              // Show count indicator if there are more than 3 items (4th circle)
              if (remainingCount > 0)
                Positioned(
                  left: itemsToShow.length * overlapOffset,
                  child: OsmeaComponents.container(
                    width: imageSize,
                    height: imageSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          OsmeaColors.grayMaterial[100] ??
                          OsmeaColors.pewter.withValues(alpha: 0.15),
                      border: Border.all(color: OsmeaColors.white, width: 2.5),
                    ),
                    child: OsmeaComponents.center(
                      child: OsmeaComponents.text(
                        '+$remainingCount',
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          fontWeight: FontWeight.w700,
                          color: OsmeaColors.thunder,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        OsmeaComponents.sizedBox(width: context.spacing12),
        // Product count text
        Expanded(
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              OsmeaComponents.text(
                '$totalCount ${totalCount == 1 ? 'product' : 'products'}',
                textStyle: OsmeaTextStyle.bodySmall(
                  context,
                ).copyWith(color: OsmeaColors.pewter, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build image with shimmer effect
  Widget _buildShimmerImage({
    required String imageUrl,
    required double width,
    required double height,
  }) {
    return OsmeaComponents.image(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      variant: ImageVariant.normal,
      cacheWidth: 200,
      showLoadingIndicator: true,
      placeholder: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: OsmeaColors.grayMaterial[200],
          shape: BoxShape.circle,
        ),
        child: _ShimmerPlaceholder(width: width, height: height),
      ),
      errorWidget: OsmeaComponents.center(
        child: Icon(
          Icons.image_outlined,
          color: OsmeaColors.grayMaterial[400],
          size: 20,
        ),
      ),
    );
  }

  /// Get status colors based on order status
  Map<String, Color> _getStatusColors(String status) {
    // Normalize status - handle both 'on-hold' and 'on_hold' formats
    final statusLower = status.toLowerCase().replaceAll('_', '-');

    // Get default colors directly - don't check config for now
    Color bgColor = _getDefaultStatusBackgroundColor(statusLower);
    Color textColor = _getDefaultStatusTextColor(statusLower);

    return {'background': bgColor, 'text': textColor};
  }

  /// Get default background color for status
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

  /// Get default text color for status
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

  Color _getColorFromConfig(String key, Color? fallback) {
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
    return fallback ?? OsmeaColors.pewter;
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
    // Handle both underscore and hyphen separators
    final parts = status.contains('_') ? status.split('_') : status.split('-');
    return parts
        .map((word) {
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }
}

/// Shimmer placeholder widget for image loading
class _ShimmerPlaceholder extends StatefulWidget {
  final double width;
  final double height;

  const _ShimmerPlaceholder({required this.width, required this.height});

  @override
  State<_ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<_ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ClipRect(
          child: Stack(
            children: [
              Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: OsmeaColors.grayMaterial[200],
                  shape: BoxShape.circle,
                ),
              ),
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final value = _controller.value;
                    final shimmerWidth = constraints.maxWidth * 0.6;
                    final shimmerPosition =
                        (value * 2 - 1) *
                            (constraints.maxWidth + shimmerWidth) -
                        shimmerWidth;

                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.transparent,
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.5),
                            Colors.white.withOpacity(0.3),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                        ),
                      ),
                      transform: Matrix4.translationValues(
                        shimmerPosition,
                        0,
                        0,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

PreferredSizeWidget _buildAppBar(BuildContext context) {
  final configHelper = AssetConfigHelper();

  Color getColor(String key, Color fallback) {
    try {
      final colorString = configHelper.getString(
        'orders_history_view.app_bar.$key',
      );
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
  final elevation = configHelper.getDouble(
    'orders_history_view.app_bar.elevation',
    0.0,
  );

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
