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
import 'package:storefront_woo/app/views/view_product_detail/widgets/cart_content.dart';
import 'package:storefront_woo/app/services/cart_service.dart';
import 'package:osmea_components/src/utils/toast_extensions.dart';

/// ProductDetailView displays detailed information about a single product
class ProductDetailView
    extends
        MasterViewHydratedCubit<ProductDetailViewModel, ProductDetailState> {
  final int productId;

  ProductDetailView({
    super.key,
    required this.productId,
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.horizontalPadding = const PaddingVisibility.disabled(),
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.extendBody = false,
    super.extendBodyBehindAppBar = false,
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
    // Success state (e.g., wishlist added)
    if (state is ProductDetailSuccessState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.toastSuccess(state.message);
      });
      return ProductDetailContentWidget(
        viewModel: viewModel,
        state: state.previousState,
      );
    }
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
PreferredSizeWidget productDetailCoreAppBar(
  BuildContext context, [
  ProductDetailViewModel? viewModel,
  Map<String, dynamic>? arguments,
]) {
  return OsmeaComponents.appBar(
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
      AppBarAction(
        icon: Icon(Icons.shopping_cart, color: OsmeaColors.thunder),
        tooltip: 'Cart',
        onPressed: () => _showCartModal(context, CartService()),
      ),
    ],
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
            padding: const EdgeInsets.symmetric(horizontal: 2),
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
