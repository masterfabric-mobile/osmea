/*
 * ProductListFiltersWidget
 * ------------------------
 * Bottom sheet widget for product filtering.
 * Stateless widget - all state managed in ViewModel.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';
import 'package:storefront_woo/app/views/view_product_list/models/module/states.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/filter_header_widget.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/sort_options_widget.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/price_range_filter_widget.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/on_sale_filter_widget.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/stock_status_filter_widget.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/categories_filter_widget.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/tags_filter_widget.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/attributes_filter_widget.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/collapsible_section_widget.dart';

class ProductListFiltersWidget extends StatelessWidget {
  final ProductListViewModel viewModel;
  final bool showOnlySort;

  const ProductListFiltersWidget({
    super.key,
    required this.viewModel,
    this.showOnlySort = false,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize filter dialog when opened - only once per dialog session
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.initFilterDialog();
    });

    return BlocBuilder<ProductListViewModel, ProductListState>(
      bloc: viewModel,
      builder: (context, state) {
        // Get temp filters after initialization
        final tempFilters = viewModel.tempFilters;
        final selectedSortBy = tempFilters.orderBy ?? 'date';
        final selectedOrder = tempFilters.order ?? 'desc';

        return OsmeaComponents.column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilterHeaderWidget(
              viewModel: viewModel,
              showOnlySort: showOnlySort,
            ),
            Flexible(
              child: showOnlySort
                  ? _buildSortingContent(context, selectedSortBy, selectedOrder)
                  : _buildFilteringContent(context, tempFilters),
            ),
          ],
        );
      },
    );
  }

  /// Build sorting tab content
  Widget _buildSortingContent(
    BuildContext context,
    String selectedSortBy,
    String selectedOrder,
  ) {
    return SingleChildScrollView(
      padding: context.paddingNormal,
      child: OsmeaComponents.column(
        crossAxisAlignment: context.crossStart,
        children: [
          SortOptionsWidget(
            viewModel: viewModel,
            selectedSortBy: selectedSortBy,
            selectedOrder: selectedOrder,
          ),
        ],
      ),
    );
  }

  /// Build filtering tab content
  Widget _buildFilteringContent(BuildContext context, dynamic tempFilters) {
    return SingleChildScrollView(
      padding: context.paddingNormal,
      child: OsmeaComponents.column(
        crossAxisAlignment: context.crossStart,
        children: [
          // Price Range - Always visible (not collapsible)
          PriceRangeFilterWidget(viewModel: viewModel),
          OsmeaComponents.sizedBox(height: context.spacing16),

          // Attributes - Collapsible (each attribute as separate panel)
          AttributesFilterWidget(
            viewModel: viewModel,
            selectedAttributes: tempFilters.selectedAttributes ?? {},
          ),

          // Categories - Collapsible
          CollapsibleSectionWidget(
            viewModel: viewModel,
            title: 'Categories',
            sectionKey: 'categories',
            child: CategoriesFilterWidget(
              viewModel: viewModel,
              selectedCategories: tempFilters.selectedCategories ?? [],
            ),
          ),

          // Tags - Collapsible
          CollapsibleSectionWidget(
            viewModel: viewModel,
            title: 'Tags',
            sectionKey: 'tags',
            child: TagsFilterWidget(
              viewModel: viewModel,
              selectedTags: tempFilters.selectedTags ?? [],
            ),
          ),

          // Sale Status - Collapsible (at the bottom)
          CollapsibleSectionWidget(
            viewModel: viewModel,
            title: 'Sale Status',
            sectionKey: 'sale_status',
            child: OnSaleFilterWidget(
              viewModel: viewModel,
              isOnSale: tempFilters.onSale == true,
            ),
          ),

          // Stock Status - Collapsible (at the bottom, using chips)
          CollapsibleSectionWidget(
            viewModel: viewModel,
            title: 'Stock Status',
            sectionKey: 'stock_status',
            child: StockStatusFilterWidget(
              viewModel: viewModel,
              selectedStatus: tempFilters.stockStatus,
            ),
          ),
        ],
      ),
    );
  }
}
