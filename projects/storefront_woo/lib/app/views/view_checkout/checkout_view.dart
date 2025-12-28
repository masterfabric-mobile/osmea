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
         coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
           title: OsmeaComponents.text(
             'Checkout',
             color: OsmeaColors.thunder,
             textStyle: OsmeaTextStyle.titleLarge(
               context,
             ).copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.3),
           ),
           backgroundColor: OsmeaColors.paperWhite,
           elevation: 0,
           foregroundColor: OsmeaColors.thunder,
           variant: AppBarVariant.standard,
           size: AppBarSize.standard,
           leading: OsmeaComponents.iconButton(
             onPressed: () => goRoute('/cart'),
             icon: Icon(
               Icons.arrow_back_ios_new_rounded,
               color: OsmeaColors.thunder,
               size: 20,
             ),
           ),
         ),
       ) {
    debugPrint('🛒 CheckoutView: Constructor called');
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
            ? ['Processing order...', 'Creating order...']
            : ['Loading checkout...'],
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
      loadingSteps: ['Loading checkout...'],
    );
  }

  Widget _buildOrderSuccess(
    BuildContext context,
    CheckoutOrderCompletedState state,
  ) {
    final formattedTotal = PriceInfoCurrencyHelper.formatPrice(
      state.totalAmount,
      currencyCode: state.currencyCode,
    );

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
                    OsmeaColors.forestHeart.withOpacity(0.1),
                    OsmeaColors.meadow.withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: OsmeaColors.forestHeart,
                size: 64,
              ),
            ),
          ),
          OsmeaComponents.sizedBox(height: 28),
          // Success Message
          OsmeaComponents.container(
            margin: EdgeInsets.symmetric(horizontal: context.spacing24),
            child: OsmeaComponents.text(
              'Order Placed Successfully!',
              textStyle: OsmeaTextStyle.headlineSmall(
                context,
              ).copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.3),
              textAlign: TextAlign.center,
              color: OsmeaColors.thunder,
            ),
          ),
          OsmeaComponents.sizedBox(height: 12),
          OsmeaComponents.container(
            margin: EdgeInsets.symmetric(horizontal: context.spacing24),
            child: OsmeaComponents.text(
              'Your order has been received and is being processed.',
              textStyle: OsmeaTextStyle.bodyMedium(context),
              textAlign: TextAlign.center,
              color: OsmeaColors.pewter,
            ),
          ),
          OsmeaComponents.sizedBox(height: 40),
          // Order Details Card
          OsmeaComponents.container(
            margin: EdgeInsets.symmetric(horizontal: context.spacing16),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: OsmeaColors.paperWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: OsmeaColors.silver.withOpacity(0.3),
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
                          OsmeaColors.nordicBlue.withOpacity(0.08),
                          OsmeaColors.nordicBlue.withOpacity(0.03),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: OsmeaComponents.column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OsmeaComponents.text(
                          'Total Amount',
                          textStyle: OsmeaTextStyle.bodySmall(context),
                          color: OsmeaColors.pewter,
                        ),
                        OsmeaComponents.sizedBox(height: 8),
                        OsmeaComponents.text(
                          formattedTotal,
                          textStyle: OsmeaTextStyle.headlineMedium(context)
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                          color: OsmeaColors.nordicBlue,
                        ),
                      ],
                    ),
                  ),
                ),
                OsmeaComponents.sizedBox(height: 20),
                _buildOrderDetailRow(context, 'Order ID', '#${state.orderId}'),
                // _buildOrderDetailRow(context, 'Order Key', state.orderKey),
                _buildOrderDetailRow(
                  context,
                  'Status',
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
                backgroundColor: OsmeaColors.nordicBlue,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: OsmeaComponents.row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home_rounded, color: OsmeaColors.white, size: 20),
                  OsmeaComponents.sizedBox(width: 8),
                  OsmeaComponents.text(
                    'Back to Home',
                    textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                      color: OsmeaColors.white,
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
    return OsmeaComponents.container(
      margin: EdgeInsets.only(bottom: 14),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            label,
            textStyle: OsmeaTextStyle.bodySmall(context),
            color: OsmeaColors.pewter,
          ),
          OsmeaComponents.sizedBox(height: 6),
          isStatus
              ? OsmeaComponents.container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: OsmeaColors.forestHeart.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: OsmeaColors.forestHeart.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: OsmeaComponents.text(
                    value,
                    textStyle: OsmeaTextStyle.bodySmall(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                    color: OsmeaColors.forestHeart,
                  ),
                )
              : OsmeaComponents.text(
                  value,
                  textStyle: OsmeaTextStyle.bodyMedium(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600),
                  color: OsmeaColors.thunder,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
        ],
      ),
    );
  }
}
