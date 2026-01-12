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
import 'package:storefront_woo/app/views/view_product_list/widgets/product_list_skeleton_widget.dart';
import 'package:storefront_woo/gen/translations.g.dart';

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
    
    // Load categories first so category names are available for filter chips
    viewModel.loadCategories().then((_) {
      debugPrint('🚀 Categories loaded, now loading products');
      viewModel.loadProducts(refresh: true);
    });
    
    // Load attributes early so they're available when filter dialog opens
    viewModel.loadAttributes();
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
      // Show skeleton loading instead of unified loading
      return const ProductListSkeletonWidget(isGridView: true);
    }

    if (state is ProductListLoadedState) {
      return ProductListContentWidget(state: state, viewModel: viewModel);
    }

    // Initial state - show skeleton loading
    return const ProductListSkeletonWidget(isGridView: true);
  }
}

/// Builds product list app bar
PreferredSizeWidget _buildProductListAppBar(
  BuildContext context,
  ProductListViewModel? viewModel,
) {
  final configHelper = AssetConfigHelper();
  final appBarConfig = configHelper.getObject('product_list_view.app_bar');
  
  final title = appBarConfig?['title'] as String? ?? context.t.productListView.appBar.title;
  final backgroundColor = configHelper.getColor(
    'product_list_view.app_bar.backgroundColor',
    OsmeaColors.white,
  );
  final foregroundColor = configHelper.getColor(
    'product_list_view.app_bar.foregroundColor',
    OsmeaColors.thunder,
  );
  final titleColor = configHelper.getColor(
    'product_list_view.app_bar.titleColor',
    OsmeaColors.thunder,
  );
  final iconColor = configHelper.getColor(
    'product_list_view.app_bar.iconColor',
    OsmeaColors.thunder,
  );

  return OsmeaComponents.appBar(
    title: OsmeaComponents.text(
      title,
      color: titleColor,
      textStyle: OsmeaTextStyle.titleLarge(
        context,
      ).copyWith(fontWeight: FontWeight.w700),
    ),
    variant: AppBarVariant.standard,
    size: AppBarSize.standard,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    leading: OsmeaComponents.iconButton(
      icon: Icon(Icons.arrow_back, color: iconColor),
      onPressed: () {
        // Check if we can pop, otherwise navigate to home
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/home');
        }
      },
      backgroundColor: OsmeaColors.transparent,
      tooltip: context.t.productListView.appBar.backTooltip,
    ),
  );
}
