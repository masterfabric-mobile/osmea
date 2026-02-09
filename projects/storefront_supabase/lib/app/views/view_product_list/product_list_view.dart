/*
 * ProductListView - Product List Page with Filters
 * ------------------------------------------------
 * A comprehensive product listing page with e-commerce filtering capabilities.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:storefront_supabase/app/views/view_product_list/models/product_list_view_model.dart';
import 'package:storefront_supabase/app/views/view_product_list/models/module/states.dart';
import 'package:storefront_supabase/app/views/view_product_list/widgets/product_list_content_widget.dart';
import 'package:storefront_supabase/app/views/view_home/widgets/home_skeleton_widget.dart'; // Reusing skeleton
import 'package:storefront_supabase/src/resources/resources.g.dart';

/// ProductListView displays a filtered list of products
class ProductListView
    extends MasterViewHydratedCubit<ProductListViewModel, ProductListState> {
  ProductListView({
    super.key,
    super.arguments,
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.horizontalPadding = const PaddingVisibility.disabled(),
    required super.goRoute,
  }) : super(
         coreAppBar: (context, viewModel) =>
             _buildProductListAppBar(context, viewModel),
       );

  @override
  void initialContent(ProductListViewModel viewModel, BuildContext context) {
    viewModel.setArguments(arguments);
    viewModel.loadCategories();
    viewModel.loadProducts(refresh: true);
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.loadProducts(refresh: true),
              child: const Text('Retry'),
            )
          ],
        ),
      );
    }

    if (state is ProductListLoadingState) {
      return const HomeSkeletonWidget(); // Reuse skeleton
    }

    if (state is ProductListLoadedState) {
      return ProductListContentWidget(state: state, viewModel: viewModel);
    }

    return const HomeSkeletonWidget();
  }
}

PreferredSizeWidget _buildProductListAppBar(
  BuildContext context,
  ProductListViewModel? viewModel,
) {
  return OsmeaComponents.appBar(
    title: OsmeaComponents.text(
      context.resources.products,
      color: OsmeaColors.black,
      textStyle: OsmeaTextStyle.titleLarge(
        context,
      ).copyWith(fontWeight: FontWeight.w700),
    ),
    variant: AppBarVariant.standard,
    size: AppBarSize.standard,
    backgroundColor: OsmeaColors.white,
    foregroundColor: OsmeaColors.black,
    actions: [
      AppBarAction(
        type: AppBarActionType.search,
        icon: const Icon(Icons.search, color: OsmeaColors.black),
        onPressed: () {
          // context.push('/search?fromHome=true');
        },
        tooltip: 'Search',
      ),
    ],
    leading: OsmeaComponents.iconButton(
      icon: const Icon(Icons.arrow_back, color: OsmeaColors.black),
      onPressed: () => Navigator.of(context).pop(),
      backgroundColor: OsmeaColors.transparent,
    ),
  );
}
