/*
 * CheckoutView
 * ------------
 * Checkout view with address forms for the storefront app.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_checkout/models/checkout_view_model.dart';
import 'package:storefront_woo/app/views/view_checkout/models/module/states.dart';
import 'package:storefront_woo/app/views/view_checkout/widgets/checkout_content_widget.dart';
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
        onPressed: () => Navigator.of(context).pop(),
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

    if (state is CheckoutLoadingState ||
        state is CheckoutProcessingOrderState) {
      return UnifiedLoadingWidget(
        goRoute: goRoute,
        loadingSteps: state is CheckoutProcessingOrderState
            ? [context.t.checkoutView.loading.processingOrder, context.t.checkoutView.loading.creatingOrder]
            : [context.t.checkoutView.loading.loadingCheckout],
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
          OsmeaComponents.sizedBox(height: 48),
          // Success Icon
          OsmeaComponents.container(
            alignment: Alignment.center,
            child: OsmeaComponents.container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    iconBgStart.withOpacity(0.1),
                    iconBgEnd.withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: iconColor,
                size: iconSize,
              ),
            ),
          ),
          OsmeaComponents.sizedBox(height: 28),
          // Success Message
          OsmeaComponents.container(
            margin: EdgeInsets.symmetric(horizontal: context.spacing24),
            child: OsmeaComponents.text(
              context.t.checkoutView.orderSuccess.title,
              textStyle: OsmeaTextStyle.headlineSmall(
                context,
              ).copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.3),
              textAlign: TextAlign.center,
              color: titleColor,
            ),
          ),
          OsmeaComponents.sizedBox(height: 12),
          OsmeaComponents.container(
            margin: EdgeInsets.symmetric(horizontal: context.spacing24),
            child: OsmeaComponents.text(
              context.t.checkoutView.orderSuccess.description,
              textStyle: OsmeaTextStyle.bodyMedium(context),
              textAlign: TextAlign.center,
              color: descriptionColor,
            ),
          ),
          OsmeaComponents.sizedBox(height: 40),
          // Order Details Card
          OsmeaComponents.container(
            margin: EdgeInsets.symmetric(horizontal: context.spacing16),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: cardBorderColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total Amount - Highlighted
                Center(
                  child: OsmeaComponents.container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          totalAmountBgStart.withOpacity(0.08),
                          totalAmountBgEnd.withOpacity(0.03),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: OsmeaComponents.column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OsmeaComponents.text(
                          context.t.checkoutView.orderSuccess.totalAmount,
                          textStyle: OsmeaTextStyle.bodySmall(context),
                          color: totalLabelColor,
                        ),
                        OsmeaComponents.sizedBox(height: 8),
                        OsmeaComponents.text(
                          formattedTotal,
                          textStyle: OsmeaTextStyle.headlineMedium(context)
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                          color: totalAmountColor,
                        ),
                      ],
                    ),
                  ),
                ),
                OsmeaComponents.sizedBox(height: 20),
                _buildOrderDetailRow(context, context.t.checkoutView.orderSuccess.orderId, '#${state.orderId}'),
                // _buildOrderDetailRow(context, 'Order Key', state.orderKey),
                _buildOrderDetailRow(
                  context,
                  context.t.checkoutView.orderSuccess.status,
                  state.status.toUpperCase(),
                  isStatus: true,
                ),
              ],
            ),
          ),
          OsmeaComponents.sizedBox(height: 32),
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
                    color: statusBgColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: statusBorderColor.withOpacity(0.3),
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
}
