/*
 * CheckoutView
 * ------------
 * Checkout view with address forms for the storefront app.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_checkout/models/checkout_view_model.dart';
import 'package:storefront_woo/app/views/view_checkout/models/module/states.dart';
import 'package:storefront_woo/app/views/view_checkout/widgets/checkout_content_widget.dart';
import 'package:storefront_woo/app/views/view_checkout/widgets/checkout_processing_widget.dart';
import 'package:storefront_woo/app/utils/unified_loading_widget.dart';
import 'package:storefront_woo/gen/translations.g.dart';

/// CheckoutView displays checkout form with billing and shipping addresses
class CheckoutView
    extends MasterViewHydratedCubit<CheckoutViewModel, CheckoutState> {
  CheckoutView({
    super.key,
    super.arguments,
    super.currentView,
    super.snackBarFunction,
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.verticalPadding = const PaddingVisibility.enabled(),
    super.horizontalPadding = const PaddingVisibility.enabled(),
    required super.goRoute,
  }) : super(
         coreAppBar: (context, viewModel) => _buildAppBar(context),
       ) {
    debugPrint('🛒 CheckoutView: Constructor called');
  }

  /// Build app bar with config colors
  static PreferredSizeWidget _buildAppBar(BuildContext context) {
    final configHelper = AssetConfigHelper();
    
    Color getColor(String key, Color fallback) {
      try {
        final colorString = configHelper.getString('checkout_view_configuration.app_bar.$key');
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
    
    final title = context.t.checkoutView.appBar.title;
    final backgroundColor = getColor('backgroundColor', OsmeaColors.white);
    final foregroundColor = getColor('foregroundColor', OsmeaColors.black);
    final titleColor = getColor('titleColor', OsmeaColors.black);
    final iconColor = getColor('iconColor', OsmeaColors.black);
    final elevation = configHelper.getDouble('checkout_view_configuration.app_bar.elevation', 0.0);
    
    return OsmeaComponents.appBar(
      title: OsmeaComponents.text(
        title,
        color: titleColor,
        textStyle: OsmeaTextStyle.titleLarge(
          context,
        ).copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.3),
      ),
      backgroundColor: backgroundColor,
      elevation: elevation,
      foregroundColor: foregroundColor,
      variant: AppBarVariant.standard,
      size: AppBarSize.standard,
      leading: OsmeaComponents.iconButton(
        onPressed: () {
          // Navigate back to cart
          context.go('/cart');
        },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: iconColor,
          size: 20,
        ),
      ),
    );
  }

  @override
  void initialContent(CheckoutViewModel viewModel, BuildContext context) {
    debugPrint('🛒 CheckoutView: initialContent called');
    viewModel.setArguments(arguments);
    viewModel.loadCheckout();
  }

  @override
  Widget viewContent(
    BuildContext context,
    CheckoutViewModel viewModel,
    CheckoutState state,
  ) {
    debugPrint(
      '🛒 CheckoutView: viewContent called with state: ${state.runtimeType}',
    );
    return _buildBody(context, viewModel, state);
  }

  Widget _buildBody(
    BuildContext context,
    CheckoutViewModel viewModel,
    CheckoutState state,
  ) {
    if (state is CheckoutErrorState) {
      return ErrorHandlingView(
        goRoute: goRoute,
        customRetryFunction: () async {
          viewModel.loadCheckout();
          return true;
        },
      );
    }

    if (state is CheckoutProcessingOrderState) {
      return const CheckoutProcessingWidget();
    }

    if (state is CheckoutLoadingState) {
      return UnifiedLoadingWidget(
        goRoute: goRoute,
        loadingSteps: [context.t.checkoutView.loading.loadingCheckout],
      );
    }

    if (state is CheckoutOrderCompletedState) {
      return _buildOrderSuccess(context, state);
    }

    if (state is CheckoutLoadedState) {
      return CheckoutContentWidget(viewModel: viewModel, state: state);
    }

    return UnifiedLoadingWidget(
      goRoute: goRoute,
      loadingSteps: [context.t.checkoutView.loading.loadingCheckout],
    );
  }

  /// Get color from config
  Color _getColorFromConfig(String key, Color fallback) {
    try {
      final configHelper = AssetConfigHelper();
      final colorString = configHelper.getString('checkout_view_configuration.$key');
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

  Widget _buildOrderSuccess(
    BuildContext context,
    CheckoutOrderCompletedState state,
  ) {
    final configHelper = AssetConfigHelper();
    final formattedTotal = PriceInfoCurrencyHelper.formatPrice(
      state.totalAmount,
      currencyCode: state.currencyCode,
    );

    // Get order success colors from config
    final iconBgStart = _getColorFromConfig('order_success.icon_background_gradient_start', OsmeaColors.black);
    final iconBgEnd = _getColorFromConfig('order_success.icon_background_gradient_end', OsmeaColors.black);
    final iconColor = _getColorFromConfig('order_success.icon_color', OsmeaColors.black);
    final iconSize = configHelper.getDouble('checkout_view_configuration.order_success.icon_size', 64.0);
    final titleColor = _getColorFromConfig('order_success.title_color', OsmeaColors.black);
    final descriptionColor = _getColorFromConfig('order_success.description_color', OsmeaColors.grayMaterial[400]!);
    final cardBgColor = _getColorFromConfig('order_success.card_background_color', OsmeaColors.white);
    final cardBorderColor = _getColorFromConfig('order_success.card_border_color', OsmeaColors.silver);
    final totalLabelColor = _getColorFromConfig('order_success.total_label_color', OsmeaColors.grayMaterial[400]!);
    final totalAmountBgStart = _getColorFromConfig('order_success.total_amount_background_start', OsmeaColors.black);
    final totalAmountBgEnd = _getColorFromConfig('order_success.total_amount_background_end', OsmeaColors.black);
    final totalAmountColor = _getColorFromConfig('order_success.total_amount_color', OsmeaColors.black);
    final buttonBgColor = _getColorFromConfig('order_success.button_background_color', OsmeaColors.black);
    final buttonTextColor = _getColorFromConfig('order_success.button_text_color', OsmeaColors.white);
    final buttonIconColor = _getColorFromConfig('order_success.button_icon_color', OsmeaColors.white);
    final buttonBorderRadius = configHelper.getDouble('checkout_view_configuration.order_success.button_border_radius', 12.0);

    return SingleChildScrollView(
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OsmeaComponents.sizedBox(height: 32),
          // Success Icon and Title - Side by Side
          OsmeaComponents.container(
            margin: EdgeInsets.symmetric(horizontal: context.spacing24),
            child: OsmeaComponents.row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Success Icon - Smaller
                OsmeaComponents.container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        iconBgStart.withValues(alpha: 0.1),
                        iconBgEnd.withValues(alpha: 0.05),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: iconColor,
                    size: 32,
                  ),
                ),
                OsmeaComponents.sizedBox(width: 12),
                // Success Message
                Expanded(
                  child: OsmeaComponents.text(
                    context.t.checkoutView.orderSuccess.title,
                    textStyle: OsmeaTextStyle.headlineSmall(
                      context,
                    ).copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.3),
                    color: titleColor,
                  ),
                ),
              ],
            ),
          ),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.container(
            margin: EdgeInsets.symmetric(horizontal: context.spacing24),
            child: OsmeaComponents.text(
              context.t.checkoutView.orderSuccess.description,
              textStyle: OsmeaTextStyle.bodyMedium(context),
              textAlign: TextAlign.center,
              color: descriptionColor,
            ),
          ),
          OsmeaComponents.sizedBox(height: 24),
          // Order Details Card
          OsmeaComponents.container(
            margin: EdgeInsets.symmetric(horizontal: context.spacing16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: cardBorderColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Products Section
                if (state.lineItems.isNotEmpty) ...[
                  OsmeaComponents.text(
                    'Products',
                    textStyle: OsmeaTextStyle.bodySmall(context),
                    color: _getColorFromConfig('order_success.detail_label_color', OsmeaColors.grayMaterial[400]!),
                  ),
                  OsmeaComponents.sizedBox(height: 12),
                  ...state.lineItems.map((item) => _buildProductItem(context, item)),
                ],
                
                // Shipping Address Section
                if (state.shippingAddress != null) ...[
                  OsmeaComponents.sizedBox(height: 20),
                  _buildShippingAddress(context, state.shippingAddress!),
                ],
              ],
            ),
          ),
          OsmeaComponents.sizedBox(height: 20),
          // Total Amount - Small at bottom
          OsmeaComponents.container(
            margin: EdgeInsets.symmetric(horizontal: context.spacing16),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  totalAmountBgStart.withValues(alpha: 0.08),
                  totalAmountBgEnd.withValues(alpha: 0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: OsmeaComponents.row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OsmeaComponents.text(
                  context.t.checkoutView.orderSuccess.totalAmount,
                  textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  color: totalLabelColor,
                ),
                OsmeaComponents.text(
                  formattedTotal,
                  textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  color: totalAmountColor,
                ),
              ],
            ),
          ),
          OsmeaComponents.sizedBox(height: 24),
          // Action Button
          OsmeaComponents.container(
            margin: EdgeInsets.symmetric(horizontal: context.spacing16),
            child: ElevatedButton(
              onPressed: () => goRoute('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBgColor,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(buttonBorderRadius),
                ),
                elevation: 0,
              ),
              child: OsmeaComponents.row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home_rounded, color: buttonIconColor, size: 20),
                  OsmeaComponents.sizedBox(width: 8),
                  OsmeaComponents.text(
                    context.t.checkoutView.orderSuccess.backToHome,
                    textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                      color: buttonTextColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          OsmeaComponents.sizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildOrderDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isStatus = false,
  }) {
    final detailLabelColor = _getColorFromConfig('order_success.detail_label_color', OsmeaColors.grayMaterial[400]!);
    final detailValueColor = _getColorFromConfig('order_success.detail_value_color', OsmeaColors.black);
    final statusBgColor = _getColorFromConfig('order_success.status_background_color', OsmeaColors.black);
    final statusBorderColor = _getColorFromConfig('order_success.status_border_color', OsmeaColors.black);
    final statusTextColor = _getColorFromConfig('order_success.status_text_color', OsmeaColors.black);
    
    return OsmeaComponents.container(
      margin: EdgeInsets.only(bottom: 14),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            label,
            textStyle: OsmeaTextStyle.bodySmall(context),
            color: detailLabelColor,
          ),
          OsmeaComponents.sizedBox(height: 6),
          isStatus
              ? OsmeaComponents.container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusBgColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: statusBorderColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: OsmeaComponents.text(
                    value,
                    textStyle: OsmeaTextStyle.bodySmall(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                    color: statusTextColor,
                  ),
                )
              : OsmeaComponents.text(
                  value,
                  textStyle: OsmeaTextStyle.bodyMedium(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600),
                  color: detailValueColor,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
        ],
      ),
    );
  }

  Widget _buildProductItem(BuildContext context, CheckoutLineItem item) {
    final productBgColor = _getColorFromConfig('order_success.product_background_color', OsmeaColors.grayMaterial[50]!);
    final productTextColor = _getColorFromConfig('order_success.product_text_color', OsmeaColors.black);
    final productLabelColor = _getColorFromConfig('order_success.product_label_color', OsmeaColors.grayMaterial[400]!);
    
    return OsmeaComponents.container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: productBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: OsmeaColors.silver.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: OsmeaComponents.row(
        children: [
          // Product Image
          OsmeaComponents.container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: OsmeaColors.grayMaterial[100],
            ),
            child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                ? OsmeaComponents.image(
                    imageUrl: item.imageUrl!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(8),
                    variant: ImageVariant.normal,
                    cacheWidth: 120,
                    showLoadingIndicator: true,
                    errorWidget: OsmeaComponents.center(
                      child: Icon(
                        Icons.image_outlined,
                        color: OsmeaColors.grayMaterial[400],
                        size: 24,
                      ),
                    ),
                  )
                : OsmeaComponents.center(
                    child: Icon(
                      Icons.image_outlined,
                      color: OsmeaColors.grayMaterial[400],
                      size: 24,
                    ),
                  ),
          ),
          OsmeaComponents.sizedBox(width: 12),
          // Product Info
          OsmeaComponents.expanded(
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                OsmeaComponents.text(
                  item.name ?? 'Product',
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: productTextColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                OsmeaComponents.sizedBox(height: 4),
                OsmeaComponents.text(
                  'Quantity: ${item.quantity}',
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    color: productLabelColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingAddress(BuildContext context, Map<String, dynamic> address) {
    final addressLabelColor = _getColorFromConfig('order_success.detail_label_color', OsmeaColors.grayMaterial[400]!);
    final addressValueColor = _getColorFromConfig('order_success.detail_value_color', OsmeaColors.black);
    
    final firstName = address['first_name'] as String? ?? '';
    final lastName = address['last_name'] as String? ?? '';
    final address1 = address['address_1'] as String? ?? '';
    final address2 = address['address_2'] as String? ?? '';
    final city = address['city'] as String? ?? '';
    final state = address['state'] as String? ?? '';
    final postcode = address['postcode'] as String? ?? '';
    final country = address['country'] as String? ?? '';
    
    final fullAddress = [
      if (firstName.isNotEmpty || lastName.isNotEmpty) '$firstName $lastName'.trim(),
      if (address1.isNotEmpty) address1,
      if (address2.isNotEmpty) address2,
      if (city.isNotEmpty || state.isNotEmpty) [city, state].where((e) => e.isNotEmpty).join(', '),
      if (postcode.isNotEmpty) postcode,
      if (country.isNotEmpty) country,
    ].where((e) => e.isNotEmpty).join('\n');
    
    return OsmeaComponents.container(
      margin: EdgeInsets.only(bottom: 14),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            'Shipping Address',
            textStyle: OsmeaTextStyle.bodySmall(context),
            color: addressLabelColor,
          ),
          OsmeaComponents.sizedBox(height: 6),
          OsmeaComponents.text(
            fullAddress,
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              fontWeight: FontWeight.w500,
              color: addressValueColor,
              height: 1.4,
            ),
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
