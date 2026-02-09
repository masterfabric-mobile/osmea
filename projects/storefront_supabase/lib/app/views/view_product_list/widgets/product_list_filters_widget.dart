/*
 * ProductListFiltersWidget
 * ------------------------
 * Bottom sheet widget for product filtering.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/views/view_product_list/models/product_list_view_model.dart';
import 'package:storefront_supabase/app/views/view_product_list/models/module/states.dart';
import 'package:storefront_supabase/app/views/view_product_list/widgets/sort_options_widget.dart';
import 'package:storefront_supabase/app/views/view_product_list/widgets/price_range_filter_widget.dart';
import 'package:storefront_supabase/app/views/view_product_list/widgets/on_sale_filter_widget.dart';
import 'package:storefront_supabase/app/views/view_product_list/widgets/categories_filter_widget.dart';
import 'package:storefront_supabase/app/views/view_product_list/widgets/collapsible_section_widget.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized && mounted) {
        _initialized = true;
        widget.viewModel.initFilterDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListViewModel, ProductListState>(
      bloc: widget.viewModel,
      builder: (context, state) {
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

  Widget _buildSortingContent(
    BuildContext context,
    String selectedSortBy,
    String selectedOrder,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: context.spacing8,
      ),
      child: SortOptionsWidget(
        viewModel: widget.viewModel,
        selectedSortBy: selectedSortBy,
        selectedOrder: selectedOrder,
      ),
    );
  }

  Widget _buildFilteringContent(BuildContext context, dynamic tempFilters) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: context.spacing12,
        bottom: context.spacing12,
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: context.crossStart,
        children: [
          // Price Range
          PriceRangeFilterWidget(viewModel: widget.viewModel),
          OsmeaComponents.sizedBox(height: context.spacing16),

          // Categories
          CollapsibleSectionWidget(
            viewModel: widget.viewModel,
            title: 'Categories',
            sectionKey: 'categories',
            child: CategoriesFilterWidget(viewModel: widget.viewModel),
          ),

          // Sale Status
          CollapsibleSectionWidget(
            viewModel: widget.viewModel,
            title: 'Sale Status',
            sectionKey: 'sale_status',
            child: OnSaleFilterWidget(
              viewModel: widget.viewModel,
              isOnSale: tempFilters.onSale == true,
            ),
          ),
        ],
      ),
    );
  }
}
