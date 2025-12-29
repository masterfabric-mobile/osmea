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
import 'package:storefront_woo/app/views/view_product_list/widgets/sort_options_widget.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/price_range_filter_widget.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/on_sale_filter_widget.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/stock_status_filter_widget.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/categories_filter_widget.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/tags_filter_widget.dart';
// import 'package:storefront_woo/app/views/view_product_list/widgets/attributes_filter_widget.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/collapsible_section_widget.dart';

class ProductListFiltersWidget extends StatefulWidget {
  final ProductListViewModel viewModel;
  final bool showOnlySort;

  const ProductListFiltersWidget({
    super.key,
    required this.viewModel,
    this.showOnlySort = false,
  });

  @override
  State<ProductListFiltersWidget> createState() =>
      _ProductListFiltersWidgetState();
}

class _ProductListFiltersWidgetState extends State<ProductListFiltersWidget> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize filter dialog when opened - only once per widget lifecycle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized && mounted) {
        _initialized = true;
        widget.viewModel.initFilterDialog();
      }
    });
  }

  @override
  void dispose() {
    // Reset initialization flag when widget is disposed
    _initialized = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListViewModel, ProductListState>(
      bloc: widget.viewModel,
      builder: (context, state) {
        // Get temp filters after initialization
        final tempFilters = widget.viewModel.tempFilters;
        final selectedSortBy = tempFilters.orderBy ?? 'date';
        final selectedOrder = tempFilters.order ?? 'desc';

        return widget.showOnlySort
            ? _buildSortingContent(
                context,
                selectedSortBy,
                selectedOrder,
              )
            : _buildFilteringContent(context, tempFilters);
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
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing20,
        vertical: context.spacing12,
      ),
      child: SortOptionsWidget(
        viewModel: widget.viewModel,
        selectedSortBy: selectedSortBy,
        selectedOrder: selectedOrder,
      ),
    );
  }

  /// Build filtering tab content
  Widget _buildFilteringContent(BuildContext context, dynamic tempFilters) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing20,
        vertical: context.spacing12,
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: context.crossStart,
        children: [
          // Price Range - Always visible (not collapsible)
          PriceRangeFilterWidget(viewModel: widget.viewModel),
          OsmeaComponents.sizedBox(height: context.spacing16),

          // Attributes - Collapsible (each attribute as separate panel)
          // AttributesFilterWidget(viewModel: widget.viewModel),

          // Categories - Collapsible
          CollapsibleSectionWidget(
            viewModel: widget.viewModel,
            title: 'Categories',
            sectionKey: 'categories',
            child: CategoriesFilterWidget(viewModel: widget.viewModel),
          ),

          // Tags - Collapsible
          CollapsibleSectionWidget(
            viewModel: widget.viewModel,
            title: 'Tags',
            sectionKey: 'tags',
            child: TagsFilterWidget(
              viewModel: widget.viewModel,
              selectedTags: tempFilters.selectedTags ?? [],
            ),
          ),

          // Sale Status - Collapsible (at the bottom)
          CollapsibleSectionWidget(
            viewModel: widget.viewModel,
            title: 'Sale Status',
            sectionKey: 'sale_status',
            child: OnSaleFilterWidget(
              viewModel: widget.viewModel,
              isOnSale: tempFilters.onSale == true,
            ),
          ),

          // Stock Status - Collapsible (at the bottom, using chips)
          CollapsibleSectionWidget(
            viewModel: widget.viewModel,
            title: 'Stock Status',
            sectionKey: 'stock_status',
            child: StockStatusFilterWidget(
              viewModel: widget.viewModel,
              selectedStatus: tempFilters.stockStatus,
            ),
          ),
        ],
      ),
    );
  }
}
