/*
 * ProductListView - Product List Page with Filters
 * ------------------------------------------------
 * A comprehensive product listing page with e-commerce filtering capabilities.
 * Supports category, price range, sort, on sale, and stock status filters.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';
import 'package:storefront_woo/app/views/view_product_list/models/module/states.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/product_list_content_widget.dart';
import 'package:storefront_woo/app/utils/unified_loading_widget.dart';

/// ProductListView displays a filtered list of products
class ProductListView
    extends MasterViewHydratedCubit<ProductListViewModel, ProductListState> {
  ProductListView({
    super.key,
    super.arguments,
    super.currentView,
    super.snackBarFunction,
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.horizontalPadding = const PaddingVisibility.disabled(),
    super.useSafeArea = false,
    required super.goRoute,
  }) : super(
         coreAppBar: (context, viewModel) =>
             _buildProductListAppBar(context, viewModel),
       );

  @override
  void initialContent(ProductListViewModel viewModel, BuildContext context) {
    debugPrint('🚀 ProductListView.initialContent called');
    debugPrint('🚀 Arguments: $arguments');
    viewModel.setArguments(arguments);
    debugPrint('🚀 Calling loadProducts(refresh: true)');
    viewModel.loadProducts(refresh: true);
    // Load attributes early so they're available when filter dialog opens
    viewModel.loadAttributes();
    debugPrint('🚀 loadProducts call completed');
  }

  @override
  Widget viewContent(
    BuildContext context,
    ProductListViewModel viewModel,
    ProductListState state,
  ) {
    return _buildBody(context, viewModel, state);
  }

  Widget _buildBody(
    BuildContext context,
    ProductListViewModel viewModel,
    ProductListState state,
  ) {
    if (state is ProductListErrorState) {
      return buildError(
        state.message,
        onRetry: () => viewModel.loadProducts(refresh: true),
      );
    }

    if (state is ProductListLoadingState) {
      return buildUnifiedLoading(goRoute: goRoute);
    }

    if (state is ProductListLoadedState) {
      return ProductListContentWidget(state: state, viewModel: viewModel);
    }

    // Initial state - show loading
    return buildUnifiedLoading(goRoute: goRoute);
  }
}

/// Builds product list app bar
PreferredSizeWidget _buildProductListAppBar(
  BuildContext context,
  ProductListViewModel? viewModel,
) {
  return OsmeaComponents.appBar(
    title: OsmeaComponents.text(
      'Products',
      color: OsmeaColors.thunder,
      textStyle: OsmeaTextStyle.titleLarge(
        context,
      ).copyWith(fontWeight: FontWeight.w700),
    ),
    variant: AppBarVariant.standard,
    size: AppBarSize.standard,
    backgroundColor: OsmeaColors.white,
    foregroundColor: OsmeaColors.thunder,
    leading: OsmeaComponents.iconButton(
      icon: Icon(Icons.arrow_back, color: OsmeaColors.thunder),
      onPressed: () {
        // Check if we can pop, otherwise navigate to home
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/home');
        }
      },
      backgroundColor: OsmeaColors.transparent,
      tooltip: 'Back',
    ),
  );
}
