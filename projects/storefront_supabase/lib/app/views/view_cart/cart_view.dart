import 'package:flutter/material.dart';

import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';
import 'package:storefront_supabase/app/models/cart_item.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';
import 'models/view_model.dart';
import 'models/states.dart';

class CartView extends MasterViewCubit<CartViewModel, CartState> {
  CartView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  }) : super(
          horizontalPadding: const PaddingVisibility.enabled(value: 16.0),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(
              context.resources.cart,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            size: AppBarSize.large,
            elevation: 0,
            titleSpacing: 0.0,
          ),
        );

  @override
  void initialContent(CartViewModel viewModel, BuildContext context) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
      BuildContext context, CartViewModel viewModel, CartState state) {
    final resources = context.resources;
    if (state is CartLoadingState || state is CartInitialState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is CartErrorState) {
      return OsmeaComponents.center(
        child: OsmeaComponents.column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OsmeaComponents.text(state.message, textAlign: TextAlign.center),
            OsmeaComponents.sizedBox(height: 20),
            OsmeaComponents.button(
              text: resources.loginSignup,
              onPressed: () => goRoute('/profile'),
              variant: ButtonVariant.primary,
            ),
          ],
        ),
      );
    }

    if (state is CartLoadedState) {
      if (state.cartItems.isEmpty) {
        return OsmeaComponents.center(
          child: OsmeaComponents.text(resources.emptyCart),
        );
      }

      return OsmeaComponents.column(
        children: [
          OsmeaComponents.expanded(
            child: ListView.builder(
              itemCount: state.cartItems.length,
              itemBuilder: (context, index) {
                final item = state.cartItems[index];
                return _buildCartItemCard(context, item, viewModel);
              },
            ),
          ),
          _buildCouponSection(context, viewModel, state), // New coupon section
          _buildSummary(context, state), // Pass the whole state for discount details
        ],
      );
    }

    return OsmeaComponents.center(child: OsmeaComponents.text(resources.somethingWentWrong));
  }

  Widget _buildCartItemCard(
      BuildContext context, CartItem item, CartViewModel viewModel) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(8.0),
        child: OsmeaComponents.row(
          children: [
            OsmeaComponents.image(
              imageUrl: item.product.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorWidget: const Icon(Icons.error, size: 40),
            ),
            OsmeaComponents.sizedBox(width: 12),
            OsmeaComponents.expanded(
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.text(
                    item.product.name,
                    textStyle: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  OsmeaComponents.sizedBox(height: 8),
                  OsmeaComponents.row(
                    children: [
                      OsmeaComponents.sizedBox(
                        height: 30,
                        width: 30,
                        child: OsmeaComponents.iconButton(
                          onPressed: () => viewModel.updateQuantity(
                              item.id, item.quantity - 1),
                          icon: const Icon(Icons.remove, size: 16),
                        ),
                      ),
                      OsmeaComponents.padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: OsmeaComponents.text('${item.quantity}',
                            textStyle: Theme.of(context).textTheme.titleMedium),
                      ),
                      OsmeaComponents.sizedBox(
                        height: 30,
                        width: 30,
                        child: OsmeaComponents.iconButton(
                          onPressed: () => viewModel.updateQuantity(
                              item.id, item.quantity + 1),
                          icon: const Icon(Icons.add, size: 16),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            OsmeaComponents.sizedBox(width: 12),
            OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BlocBuilder<CurrencyCubit, String>(
                  builder: (context, currency) {
                    return OsmeaComponents.text(
                      PriceHelper.format(
                          item.product.price * item.quantity,
                          currency,
                          Localizations.localeOf(context).toString()),
                      textStyle: Theme.of(context).textTheme.titleMedium,
                    );
                  },
                ),
                OsmeaComponents.sizedBox(height: 4),
                OsmeaComponents.button(
                  onPressed: () => viewModel.removeItem(item.id),
                  text: context.resources.remove,
                  variant: ButtonVariant.ghost,
                  textColor: Colors.black,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponSection(BuildContext context, CartViewModel viewModel, CartLoadedState state) {
    return OsmeaComponents.container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text('Have a coupon?', textStyle: Theme.of(context).textTheme.titleMedium),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.row(
            children: [
              OsmeaComponents.expanded(
                child: OsmeaComponents.textField(
                  controller: viewModel.couponCodeController,
                  hint: 'Enter coupon code',
                  variant: TextFieldVariant.outlined,
                ),
              ),
              OsmeaComponents.sizedBox(width: 8),
              OsmeaComponents.button(
                text: 'Apply',
                onPressed: () => viewModel.applyCoupon(viewModel.couponCodeController.text),
                variant: ButtonVariant.primary,
                backgroundColor: Colors.black,
                textColor: Colors.white,
              ),
            ],
          ),
          if (state.couponMessage != null) ...[
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.text(
              state.couponMessage!,
              textStyle: TextStyle(
                color: state.appliedCoupon != null ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (state.appliedCoupon != null)
              OsmeaComponents.textButton(
                text: 'Remove Coupon',
                onPressed: viewModel.removeCoupon,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context, CartLoadedState state) { // Changed to take CartLoadedState
    return OsmeaComponents.container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.1).round()),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSummaryRow(context, 'Subtotal', state.totalPrice),
          if (state.discountAmount != null && state.discountAmount! > 0) ...[
            _buildSummaryRow(context, 'Discount', -state.discountAmount!, textColor: Colors.green),
            OsmeaComponents.sizedBox(height: 8),
            Divider(color: Colors.grey.shade300),
            OsmeaComponents.sizedBox(height: 8),
          ],
          _buildSummaryRow(context, context.resources.total, state.discountedTotal, isBold: true),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.button(
            text: context.resources.proceedToCheckout,
            onPressed: () {
              // TODO: Implement checkout flow
            },
            variant: ButtonVariant.primary,
            backgroundColor: Colors.black, // Set background color to black
            textColor: Colors.white,       // Set text color to white
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, double amount, {Color? textColor, bool isBold = false}) {
    return OsmeaComponents.row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OsmeaComponents.text(
          label,
          textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: textColor ?? Colors.black,
          ),
        ),
        BlocBuilder<CurrencyCubit, String>(
          builder: (context, currency) {
            return OsmeaComponents.text(
              PriceHelper.format(amount, currency, Localizations.localeOf(context).toString()),
              textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: textColor ?? Colors.black,
              ),
            );
          },
        ),
      ],
    );
  }
}