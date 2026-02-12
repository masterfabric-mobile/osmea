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
    return OsmeaComponents.appBar(
      backgroundColor: OsmeaColors.white,
      foregroundColor: OsmeaColors.black,
      elevation: 0,
      leading: OsmeaComponents.iconButton(
        icon: const Icon(Icons.arrow_back, color: OsmeaColors.black),
        backgroundColor: OsmeaColors.transparent,
        onPressed: () => context.go('/cart'),
      ),
      title: OsmeaComponents.text(
        context.resources.checkoutTitle,
        textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
          color: OsmeaColors.black,
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
      return OsmeaComponents.center(
        child: OsmeaComponents.padding(
          padding: EdgeInsets.all(context.spacing20),
          child: OsmeaComponents.column(
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
      return OsmeaComponents.center(
        child: OsmeaComponents.column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OsmeaComponents.loading(
              type: LoadingType.circularFade,
              size: 48,
              color: OsmeaColors.black,
            ),
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

    return OsmeaComponents.singleChildScrollView(
      padding: EdgeInsets.all(context.spacing20),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OsmeaComponents.sizedBox(height: context.spacing24),
          Icon(Icons.check_circle_rounded, color: OsmeaColors.green, size: 64),
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
          OsmeaComponents.container(
            padding: EdgeInsets.all(context.spacing16),
            decoration: BoxDecoration(
              color: OsmeaColors.paperWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: OsmeaColors.pewter.withValues(alpha: 0.3)),
            ),
            child: OsmeaComponents.row(
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
