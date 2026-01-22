import 'package:flutter/material.dart';

import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
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
          _buildSummary(context, state.totalPrice),
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
                OsmeaComponents.text(
                  '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),
                OsmeaComponents.sizedBox(height: 4),
                OsmeaComponents.textButton(
                  onPressed: () => viewModel.removeItem(item.id),
                  text: context.resources.remove, 
                  // variant: ButtonVariant.ghost, // TextButton default variant usually
                  // style: const TextStyle(color: Colors.red), // Need to check if textButton supports style
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context, double totalPrice) {
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
          OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OsmeaComponents.text('${context.resources.total}:', textStyle: Theme.of(context).textTheme.headlineSmall),
              OsmeaComponents.text('\$${totalPrice.toStringAsFixed(2)}',
                  textStyle: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.button(
            text: context.resources.proceedToCheckout,
            onPressed: () {
              // TODO: Implement checkout flow
            },
            variant: ButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}