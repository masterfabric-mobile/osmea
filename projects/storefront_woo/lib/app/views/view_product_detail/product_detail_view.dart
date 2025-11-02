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
    actions: const [], // Sepet ikonu kaldırıldı
  );
}

