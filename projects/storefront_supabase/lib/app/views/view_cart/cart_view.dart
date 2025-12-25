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
              color: Theme.of(context)
                  .colorScheme
                  .onPrimary, // Text color matches onPrimary
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message, textAlign: TextAlign.center),
            const SizedBox(height: 20),
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
        return Center(
          child: OsmeaComponents.text(resources.emptyCart),
        );
      }

      return Column(
        children: [
          Expanded(
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

    return Center(child: Text(resources.somethingWentWrong));
  }

  Widget _buildCartItemCard(
      BuildContext context, CartItem item, CartViewModel viewModel) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.network(
              item.product.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, size: 40),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: OsmeaComponents.iconButton(
                          onPressed: () => viewModel.updateQuantity(
                              item.id, item.quantity - 1),
                          icon: const Icon(Icons.remove, size: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('${item.quantity}',
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      SizedBox(
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
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () => viewModel.removeItem(item.id),
                  child: Text(context.resources.remove, style: const TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context, double totalPrice) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${context.resources.total}:', style: Theme.of(context).textTheme.headlineSmall),
              Text('\$${totalPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          const SizedBox(height: 16),
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
