/*
 * CheckoutView
 * ------------
 * Full checkout flow: Address -> Shipping -> Payment -> Summary -> Place order in Supabase.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:storefront_supabase/app/views/view_checkout/models/checkout_view_model.dart';
import 'package:storefront_supabase/app/views/view_checkout/models/states.dart';
import 'package:storefront_supabase/app/views/view_checkout/widgets/checkout_content_widget.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';
import 'package:storefront_supabase/app/utils/unified_loading_widget.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class CheckoutView extends MasterViewCubit<CheckoutViewModel, CheckoutState> {
  CheckoutView({
    super.key,
    super.arguments,
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.horizontalPadding = const PaddingVisibility.disabled(),
    required super.goRoute,
  }) : super(
          coreAppBar: (context, viewModel) => _buildAppBar(context),
        );

  static PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: OsmeaColors.white,
      foregroundColor: OsmeaColors.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: OsmeaColors.black),
        onPressed: () => context.go('/cart'),
      ),
      title: Text(
        context.resources.checkoutTitle,
        style: const TextStyle(
          color: OsmeaColors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  void initialContent(CheckoutViewModel viewModel, BuildContext context) {
    viewModel.setArguments(arguments);
    viewModel.loadCheckout();
  }

  @override
  Widget viewContent(
    BuildContext context,
    CheckoutViewModel viewModel,
    CheckoutState state,
  ) {
    if (state is CheckoutErrorState) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(context.spacing20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OsmeaComponents.text(
                state.message,
                textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(color: OsmeaColors.thunder),
                textAlign: TextAlign.center,
              ),
              OsmeaComponents.sizedBox(height: context.spacing16),
              OsmeaComponents.button(
                onPressed: () => viewModel.loadCheckout(),
                backgroundColor: OsmeaColors.black,
                textColor: OsmeaColors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                text: context.resources.retry,
                textStyle: OsmeaTextStyle.titleSmall(context).copyWith(color: OsmeaColors.white, fontWeight: FontWeight.w600),
              ),
              OsmeaComponents.sizedBox(height: context.spacing12),
              OsmeaComponents.button(
                onPressed: () => goRoute('/cart'),
                backgroundColor: OsmeaColors.white,
                textColor: OsmeaColors.black,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                text: '${context.resources.backButton} ${context.resources.cart}',
                textStyle: OsmeaTextStyle.titleSmall(context).copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );
    }

    if (state is CheckoutProcessingOrderState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: OsmeaColors.black),
            OsmeaComponents.sizedBox(height: context.spacing16),
            OsmeaComponents.text(
              'Processing order...',
              textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(color: OsmeaColors.pewter),
            ),
          ],
        ),
      );
    }

    if (state is CheckoutOrderCompletedState) {
      return _buildOrderSuccess(context, state);
    }

    if (state is CheckoutLoadingState) {
      return UnifiedLoadingWidget(
        goRoute: goRoute,
        loadingSteps: ['Loading checkout...'],
      );
    }

    if (state is CheckoutLoadedState) {
      return CheckoutContentWidget(viewModel: viewModel, state: state);
    }

    return UnifiedLoadingWidget(goRoute: goRoute, loadingSteps: ['Loading...']);
  }

  Widget _buildOrderSuccess(BuildContext context, CheckoutOrderCompletedState state) {
    final locale = Localizations.localeOf(context).toString();
    final totalStr = PriceHelper.format(state.totalAmount, state.currencyCode ?? 'USD', locale);

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OsmeaComponents.sizedBox(height: context.spacing24),
          Icon(Icons.check_circle_rounded, color: const Color(0xFF2E7D32), size: 64),
          OsmeaComponents.sizedBox(height: context.spacing16),
          OsmeaComponents.text(
            context.resources.orderPlacedTitle,
            textStyle: OsmeaTextStyle.headlineSmall(context).copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          OsmeaComponents.text(
            context.resources.orderPlacedDescription,
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(color: OsmeaColors.pewter),
            textAlign: TextAlign.center,
          ),
          OsmeaComponents.sizedBox(height: context.spacing24),
          Container(
            padding: EdgeInsets.all(context.spacing16),
            decoration: BoxDecoration(
              color: OsmeaColors.paperWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: OsmeaColors.pewter.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OsmeaComponents.text(
                  context.resources.total,
                  textStyle: OsmeaTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.w600),
                ),
                OsmeaComponents.text(
                  totalStr,
                  textStyle: OsmeaTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing24),
          OsmeaComponents.button(
            onPressed: () => goRoute('/home'),
            backgroundColor: OsmeaColors.black,
            textColor: OsmeaColors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            text: context.resources.backToHome,
            textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
              color: OsmeaColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
