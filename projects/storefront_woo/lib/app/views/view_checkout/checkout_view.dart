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

/// CheckoutView displays checkout form with billing and shipping addresses
class CheckoutView extends MasterViewHydratedCubit<CheckoutViewModel, CheckoutState> {
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
             textStyle: OsmeaTextStyle.titleLarge(context),
           ),
           backgroundColor: OsmeaColors.paperWhite,
           elevation: 0,
           foregroundColor: OsmeaColors.thunder,
           variant: AppBarVariant.standard,
           size: AppBarSize.standard,
           leading: OsmeaComponents.iconButton(
             onPressed: () => context.pop(),
             icon: Icon(
               Icons.arrow_back,
               color: OsmeaColors.thunder,
               size: context.iconSizeNormal,
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
    debugPrint('🛒 CheckoutView: viewContent called with state: ${state.runtimeType}');
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

    if (state is CheckoutLoadingState || state is CheckoutProcessingOrderState) {
      return LoadingScreen(
        goRoute: goRoute,
        loadingType: LoadingModelType.dataLoading,
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

    return LoadingScreen(
      goRoute: goRoute,
      loadingType: LoadingModelType.dataLoading,
      loadingSteps: ['Loading checkout...'],
    );
  }

  Widget _buildOrderSuccess(BuildContext context, CheckoutOrderCompletedState state) {
    final formattedTotal = PriceInfoCurrencyHelper.formatPrice(
      state.totalAmount,
      currencyCode: state.currencyCode,
    );

    return SingleChildScrollView(
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OsmeaComponents.sizedBox(height: 40),
          // Success Icon
          OsmeaComponents.container(
            alignment: Alignment.center,
            child: OsmeaComponents.container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: OsmeaColors.forestHeart.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: OsmeaColors.forestHeart,
                size: 60,
              ),
            ),
          ),
          OsmeaComponents.sizedBox(height: 24),
          // Success Message
          OsmeaComponents.container(
            margin: EdgeInsets.symmetric(horizontal: context.spacing16),
            child: OsmeaComponents.text(
              'Order Placed Successfully!',
              textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              color: OsmeaColors.thunder,
            ),
          ),
          OsmeaComponents.sizedBox(height: 12),
          OsmeaComponents.container(
            margin: EdgeInsets.symmetric(horizontal: context.spacing16),
            child: OsmeaComponents.text(
              'Your order has been received and is being processed.',
              textStyle: OsmeaTextStyle.bodyMedium(context),
              textAlign: TextAlign.center,
              color: OsmeaColors.pewter,
            ),
          ),
          OsmeaComponents.sizedBox(height: 32),
          // Order Details
          OsmeaComponents.container(
            margin: EdgeInsets.symmetric(horizontal: context.spacing16),
            padding: context.paddingNormal,
            decoration: BoxDecoration(
              color: OsmeaColors.paperWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: OsmeaColors.silver, width: 1),
            ),
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.text(
                  'Order Details',
                  textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  color: OsmeaColors.thunder,
                ),
                OsmeaComponents.sizedBox(height: 16),
                _buildOrderDetailRow(context, 'Order ID', '#${state.orderId}'),
                _buildOrderDetailRow(context, 'Order Key', state.orderKey),
                _buildOrderDetailRow(context, 'Status', state.status.toUpperCase()),
                OsmeaComponents.sizedBox(height: 12),
                OsmeaComponents.container(
                  height: 1,
                  color: OsmeaColors.silver,
                ),
                OsmeaComponents.sizedBox(height: 12),
                OsmeaComponents.row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OsmeaComponents.text(
                      'Total Amount',
                      textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      color: OsmeaColors.thunder,
                    ),
                    OsmeaComponents.text(
                      formattedTotal,
                      textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: OsmeaColors.nordicBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          OsmeaComponents.sizedBox(height: 32),
          // Action Buttons
          OsmeaComponents.container(
            margin: EdgeInsets.symmetric(horizontal: context.spacing16),
            child: ElevatedButton(
              onPressed: () => goRoute('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: OsmeaColors.nordicBlue,
                padding: context.paddingNormal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              child: OsmeaComponents.text(
                'Back to Home',
                textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                  color: OsmeaColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          OsmeaComponents.sizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildOrderDetailRow(BuildContext context, String label, String value) {
    return OsmeaComponents.container(
      margin: EdgeInsets.only(bottom: 12),
      child: OsmeaComponents.row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OsmeaComponents.text(
            label,
            textStyle: OsmeaTextStyle.bodyMedium(context),
            color: OsmeaColors.pewter,
          ),
          OsmeaComponents.text(
            value,
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
            color: OsmeaColors.thunder,
          ),
        ],
      ),
    );
  }
}

