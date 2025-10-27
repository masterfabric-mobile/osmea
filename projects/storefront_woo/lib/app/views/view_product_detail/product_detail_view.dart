/*
 * ProductDetailView
 * -----------------
 * A product detail view following OSMEA architecture.
 * Uses MasterViewHydratedCubit pattern with HydratedBloc state management.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/product_detail_view_model.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/product_detail_widgets.dart';
import 'package:storefront_woo/app/services/cart_service.dart';

/// ProductDetailView displays detailed information about a single product
class ProductDetailView
    extends
        MasterViewHydratedCubit<ProductDetailViewModel, ProductDetailState> {
  final int productId;

  ProductDetailView({
    super.key,
    required this.productId,
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.arguments,
    required super.goRoute,
  }) : super(
         coreAppBar: (context, viewModel) =>
             productDetailCoreAppBar(context, viewModel, arguments),
       );

  @override
  void initialContent(ProductDetailViewModel viewModel, BuildContext context) {
    viewModel.loadProduct(productId);
  }

  @override
  Widget viewContent(
    BuildContext context,
    ProductDetailViewModel viewModel,
    ProductDetailState state,
  ) {
    return _buildBody(context, viewModel, state);
  }

  Widget _buildBody(
    BuildContext context,
    ProductDetailViewModel viewModel,
    ProductDetailState state,
  ) {
    // ✅ Auth required state - navigate to auth screen
    if (state is ProductDetailAuthRequiredState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint('🔒 Auth required, navigating to auth screen');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: OsmeaColors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
        // Reset to previous state to prevent infinite loop
        viewModel.loadProduct(productId);
        // Navigate to auth
        context.push('/auth');
      });
      // Show previous state while navigating
      if (state.previousState != null) {
        return ProductDetailContentWidget(
          viewModel: viewModel,
          state: state.previousState!,
        );
      }
      // Fallback to loading
      return const ProductDetailLoadingWidget();
    }

    // Error state
    if (state is ProductDetailErrorState) {
      return ProductDetailErrorWidget(
        message: state.message,
        onRetry: () => viewModel.loadProduct(productId),
      );
    }

    // Loading state
    if (state is ProductDetailLoadingState) {
      return const ProductDetailLoadingWidget();
    }

    // Loaded state
    if (state is ProductDetailLoadedState) {
      return ProductDetailContentWidget(viewModel: viewModel, state: state);
    }

    // Initial state
    return const ProductDetailLoadingWidget();
  }
}

/// Returns a coreAppBar for the product detail view following OSMEA standards
AppBar productDetailCoreAppBar(
  BuildContext context, [
  ProductDetailViewModel? viewModel,
  Map<String, dynamic>? arguments,
]) {
  return AppBar(
    title: OsmeaComponents.text(
      'Product Details',
      color: OsmeaColors.thunder,
      textStyle: OsmeaTextStyle.titleLarge(context),
    ),
    backgroundColor: OsmeaColors.paperWhite,
    elevation: 0,
    leading: OsmeaComponents.iconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: Icon(Icons.arrow_back, color: OsmeaColors.thunder),
    ),
    actions: [
      // Cart button with badge
      ListenableBuilder(
        listenable: CartService(),
        builder: (context, child) {
          final cartService = CartService();
          return OsmeaComponents.stack(
            children: [
              OsmeaComponents.iconButton(
                onPressed: () => _showCartModal(context, cartService),
                icon: Icon(Icons.shopping_cart, color: OsmeaColors.thunder),
                backgroundColor: OsmeaColors.transparent,
                tooltip: 'Cart (${cartService.itemCount})',
              ),
              if (cartService.itemCount > 0)
                OsmeaComponents.positioned(
                  right: 8,
                  top: 8,
                  child: OsmeaComponents.container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: OsmeaColors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: OsmeaComponents.text(
                      '${cartService.itemCount}',
                      color: OsmeaColors.white,
                      textStyle: OsmeaTextStyle.bodySmall(
                        context,
                      ).copyWith(fontSize: 10, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    ],
  );
}

/// Shows clean cart success dialog
void _showCartSuccessDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(20),
        content: OsmeaComponents.column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            OsmeaComponents.container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: OsmeaColors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: OsmeaComponents.center(
                child: Icon(
                  Icons.check_circle,
                  size: 24,
                  color: OsmeaColors.green,
                ),
              ),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Title
            OsmeaComponents.text(
              'Success!',
              textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                color: OsmeaColors.thunder,
                fontWeight: FontWeight.bold,
              ),
            ),
            OsmeaComponents.sizedBox(height: 8),

            // Message
            OsmeaComponents.text(
              'Product added to cart successfully!',
              textStyle: OsmeaTextStyle.bodyMedium(
                context,
              ).copyWith(color: OsmeaColors.grayMaterial[600]),
              textAlign: TextAlign.center,
            ),
            OsmeaComponents.sizedBox(height: 20),

            // Action Buttons
            OsmeaComponents.row(
              children: [
                // Continue Shopping
                OsmeaComponents.expanded(
                  child: OsmeaComponents.button(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Go back to home
                    },
                    backgroundColor: OsmeaColors.grayMaterial[100],
                    textColor: OsmeaColors.thunder,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    borderRadius: 8,
                    text: 'Continue',
                    textStyle: OsmeaTextStyle.bodyMedium(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                OsmeaComponents.sizedBox(width: 12),

                // Go to Cart
                OsmeaComponents.expanded(
                  child: OsmeaComponents.button(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog first
                      context.push('/cart'); // Then navigate to cart
                    },
                    backgroundColor: OsmeaColors.blue,
                    textColor: OsmeaColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    borderRadius: 8,
                    text: 'View Cart',
                    textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                      color: OsmeaColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

/// Shows cart modal
void _showCartModal(BuildContext context, CartService cartService) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: OsmeaColors.transparent,
    builder: (context) => CartModal(cartService: cartService),
  );
}

/// Cart modal widget
class CartModal extends StatelessWidget {
  final CartService cartService;

  const CartModal({super.key, required this.cartService});

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: OsmeaComponents.column(
        children: [
          // Handle bar
          OsmeaComponents.container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: OsmeaColors.grayMaterial[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          OsmeaComponents.padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OsmeaComponents.row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OsmeaComponents.text(
                  'Shopping Cart',
                  textStyle: OsmeaTextStyle.titleLarge(context),
                ),
                OsmeaComponents.iconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close),
                  backgroundColor: OsmeaColors.transparent,
                  tooltip: 'Close',
                ),
              ],
            ),
          ),
          OsmeaComponents.divider(),
          // Cart content
          OsmeaComponents.expanded(
            child: CartContentWidget(cartService: cartService),
          ),
        ],
      ),
    );
  }
}

/// Cart content widget
class CartContentWidget extends StatelessWidget {
  final CartService cartService;

  const CartContentWidget({super.key, required this.cartService});

  @override
  Widget build(BuildContext context) {
    final cartService = CartService();

    if (cartService.itemCount == 0) {
      return OsmeaComponents.center(
        child: OsmeaComponents.column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 100),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.text('Your cart is empty'),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.text('Add some products to get started'),
          ],
        ),
      );
    }

    return OsmeaComponents.column(
      children: [
        // Cart items
        OsmeaComponents.expanded(
          child: OsmeaComponents.singleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: OsmeaComponents.column(
              children: List.generate(cartService.itemCount, (index) {
                final item = cartService.items[index];
                return _buildCartItem(item, cartService, context);
              }),
            ),
          ),
        ),
        // Cart summary
        OsmeaComponents.basicCard(
          padding: const EdgeInsets.all(16.0),
          backgroundColor: OsmeaColors.white,
          customContent: OsmeaComponents.column(
            children: [
              OsmeaComponents.row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OsmeaComponents.text(
                    'Total:',
                    textStyle: OsmeaTextStyle.titleLarge(context),
                  ),
                  OsmeaComponents.text(
                    PriceInfoCurrencyHelper.formatPrice(cartService.totalPrice),
                    textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                      color: OsmeaColors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.button(
                onPressed: () {
                  // TODO: Implement checkout functionality
                  Navigator.of(context).pop();
                },
                backgroundColor: OsmeaColors.blue,
                textColor: OsmeaColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                text: 'Checkout',
                textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                  color: OsmeaColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds a cart item widget
  Widget _buildCartItem(
    CartItem item,
    CartService cartService,
    BuildContext context,
  ) {
    return OsmeaComponents.basicCard(
      margin: const EdgeInsets.only(bottom: 8.0),
      customContent: OsmeaComponents.padding(
        padding: const EdgeInsets.all(16.0),
        child: OsmeaComponents.row(
          children: [
            // Product image
            OsmeaComponents.image(
              imageUrl: item.imageUrl,
              width: 60,
              height: 60,
              borderRadius: BorderRadius.circular(8),
              fit: BoxFit.cover,
              placeholder: Icon(Icons.image),
            ),
            OsmeaComponents.sizedBox(width: 16),
            // Product info
            OsmeaComponents.expanded(
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.text(
                    item.productName,
                    textStyle: OsmeaTextStyle.titleMedium(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  OsmeaComponents.sizedBox(height: 4),
                  OsmeaComponents.text(
                    PriceInfoCurrencyHelper.formatPrice(item.price),
                    textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                      color: OsmeaColors.nordicBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Quantity controls
            OsmeaComponents.row(
              children: [
                OsmeaComponents.iconButton(
                  onPressed: item.quantity > 1
                      ? () => cartService.updateQuantity(
                          item.productId,
                          item.quantity - 1,
                        )
                      : null,
                  icon: Icon(Icons.remove),
                  backgroundColor: OsmeaColors.grayMaterial[200],
                  tooltip: 'Decrease quantity',
                ),
                OsmeaComponents.sizedBox(width: 8),
                OsmeaComponents.text(
                  '${item.quantity}',
                  textStyle: OsmeaTextStyle.titleMedium(context),
                ),
                OsmeaComponents.sizedBox(width: 8),
                OsmeaComponents.iconButton(
                  onPressed: () => cartService.updateQuantity(
                    item.productId,
                    item.quantity + 1,
                  ),
                  icon: Icon(Icons.add),
                  backgroundColor: OsmeaColors.grayMaterial[200],
                  tooltip: 'Increase quantity',
                ),
              ],
            ),
            OsmeaComponents.sizedBox(width: 16),
            // Remove button
            OsmeaComponents.iconButton(
              onPressed: () => cartService.removeItem(item.productId),
              icon: Icon(Icons.delete_outline, color: OsmeaColors.red),
              tooltip: 'Remove item',
            ),
          ],
        ),
      ),
    );
  }
}
