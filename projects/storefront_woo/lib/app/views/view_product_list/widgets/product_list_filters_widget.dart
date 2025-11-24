/*
 * ProductListFiltersWidget
 * ------------------------
 * Bottom sheet widget for product filtering.
 * Stateless widget - all state managed in ViewModel.
 */

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';
import 'package:storefront_woo/app/views/view_product_list/models/module/states.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/get_filter_options_response_model.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/debug_filter_info_widget.dart';

class ProductListFiltersWidget extends StatelessWidget {
  final ProductListViewModel viewModel;

  const ProductListFiltersWidget({super.key, required this.viewModel});

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
            // Debug info widget (only in debug mode)
            DebugFilterInfoWidget(viewModel: viewModel),
            
            // Header with actions
            OsmeaComponents.padding(
              padding: context.paddingNormal,
              child: OsmeaComponents.row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox.shrink(),
                  OsmeaComponents.row(
                    children: [
                      if (viewModel.filters.hasActiveFilters)
                        OsmeaComponents.button(
                          text: 'Clear all',
                          onPressed: () {
                            viewModel.clearFilters();
                            Navigator.pop(context);
                          },
                          variant: ButtonVariant.outlined,
                          size: ButtonSize.medium,
                        ),
                      if (viewModel.filters.hasActiveFilters)
                        OsmeaComponents.sizedBox(width: context.spacing8),
                      OsmeaComponents.button(
                        text: 'Apply',
                        onPressed: () {
                          viewModel.applyFilters();
                          Navigator.pop(context);
                        },
                        variant: ButtonVariant.primary,
                        size: ButtonSize.medium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Filters content
            Flexible(
              child: SingleChildScrollView(
                padding: context.paddingNormal,
                child: OsmeaComponents.column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sort by
                    _buildSectionTitle(context, 'Sort by'),
                    OsmeaComponents.sizedBox(height: context.spacing8),
                    _buildSortOptions(context, selectedSortBy, selectedOrder),
                    OsmeaComponents.sizedBox(height: context.spacing24),

                    // Price range
                    _buildSectionTitle(context, 'Price range'),
                    OsmeaComponents.sizedBox(height: context.spacing8),
                    _buildPriceRangeFilter(context),
                    OsmeaComponents.sizedBox(height: context.spacing24),

                    // On sale filter
                    _buildSectionTitle(context, 'Special offers'),
                    OsmeaComponents.sizedBox(height: context.spacing8),
                    _buildOnSaleFilter(context, tempFilters.onSale == true),
                    OsmeaComponents.sizedBox(height: context.spacing24),

                    // Stock status
                    _buildSectionTitle(context, 'Availability'),
                    OsmeaComponents.sizedBox(height: context.spacing8),
                    _buildStockStatusFilter(context, tempFilters.stockStatus),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return OsmeaComponents.text(
      title,
      textStyle: OsmeaTextStyle.titleMedium(
        context,
      ).copyWith(fontWeight: FontWeight.w600, color: OsmeaColors.thunder),
    );
  }

  Widget _buildSortOptions(
    BuildContext context,
    String selectedSortBy,
    String selectedOrder,
  ) {
    return BlocBuilder<ProductListViewModel, ProductListState>(
      bloc: viewModel,
      builder: (context, state) {
        // Get filter options from state
        final filterOptions = state is ProductListLoadedState 
            ? state.filterOptions 
            : null;

        // Debug info for data source
        Widget dataSourceIndicator = Container();
        if (kDebugMode) {
          dataSourceIndicator = Padding(
            padding: EdgeInsets.only(bottom: context.spacing8),
            child: Container(
              padding: context.paddingLow,
              decoration: BoxDecoration(
                color: filterOptions?.sortOptions != null 
                    ? Colors.green.withOpacity(0.1) 
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: filterOptions?.sortOptions != null 
                      ? Colors.green 
                      : Colors.orange,
                  width: 1,
                ),
              ),
              child: OsmeaComponents.text(
                filterOptions?.sortOptions != null 
                    ? '🌐 Dynamic Data (API)' 
                    : '📱 Static Fallback',
                textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                  color: filterOptions?.sortOptions != null 
                      ? Colors.green.shade700 
                      : Colors.orange.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }

        if (filterOptions?.sortOptions == null) {
          return OsmeaComponents.column(
            children: [
              dataSourceIndicator,
              _buildStaticSortOptions(context, selectedSortBy, selectedOrder),
            ],
          );
        }

        return OsmeaComponents.column(
          children: [
            dataSourceIndicator,
            ...filterOptions!.sortOptions
              .where((sortOption) => sortOption.enabled)
              .expand((sortOption) => sortOption.orders.map((orderOption) =>
                  _buildSortOption(
                    context,
                    '${sortOption.label} (${orderOption.label})',
                    sortOption.key,
                    orderOption.key,
                    selectedSortBy,
                    selectedOrder,
                  )))
              .toList(),
          ]
        );
      },
    );
  }

  Widget _buildStaticSortOptions(
    BuildContext context,
    String selectedSortBy,
    String selectedOrder,
  ) {
    return OsmeaComponents.column(
      children: [
        _buildSortOption(
          context,
          'Date (Newest)',
          'date',
          'desc',
          selectedSortBy,
          selectedOrder,
        ),
        _buildSortOption(
          context,
          'Date (Oldest)',
          'date',
          'asc',
          selectedSortBy,
          selectedOrder,
        ),
        _buildSortOption(
          context,
          'Price (Low to High)',
          'price',
          'asc',
          selectedSortBy,
          selectedOrder,
        ),
        _buildSortOption(
          context,
          'Price (High to Low)',
          'price',
          'desc',
          selectedSortBy,
          selectedOrder,
        ),
        _buildSortOption(
          context,
          'Name (A-Z)',
          'title',
          'asc',
          selectedSortBy,
          selectedOrder,
        ),
        _buildSortOption(
          context,
          'Name (Z-A)',
          'title',
          'desc',
          selectedSortBy,
          selectedOrder,
        ),
      ],
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String label,
    String orderBy,
    String order,
    String selectedSortBy,
    String selectedOrder,
  ) {
    final isSelected = selectedSortBy == orderBy && selectedOrder == order;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          viewModel.updateTempFilter(orderBy: orderBy, order: order);
        },
        borderRadius: BorderRadius.circular(context.radiusLow),
        child: OsmeaComponents.container(
          padding: context.paddingLow,
          margin: EdgeInsets.only(bottom: context.spacing8),
          decoration: BoxDecoration(
            color: isSelected
                ? OsmeaColors.nordicBlue.withOpacity(0.1)
                : OsmeaColors.transparent,
            border: Border.all(
              color: isSelected
                  ? OsmeaColors.nordicBlue
                  : OsmeaColors.silver.withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(context.radiusLow),
          ),
          child: OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OsmeaComponents.text(
                label,
                textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                  color: isSelected
                      ? OsmeaColors.nordicBlue
                      : OsmeaColors.thunder,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: OsmeaColors.nordicBlue,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRangeFilter(BuildContext context) {
    return BlocBuilder<ProductListViewModel, ProductListState>(
      bloc: viewModel,
      builder: (context, state) {
        // Get filter options from state
        final filterOptions = state is ProductListLoadedState 
            ? state.filterOptions 
            : null;

        final priceRange = filterOptions?.priceRange;
        final currencySymbol = priceRange?.currencySymbol ?? '\$';
        
        return OsmeaComponents.column(
          children: [
            if (priceRange != null) ...[
              // Show price range hint
              OsmeaComponents.padding(
                padding: EdgeInsets.only(bottom: context.spacing8),
                child: OsmeaComponents.text(
                  'Range: $currencySymbol${priceRange.minPrice.toStringAsFixed(2)} - $currencySymbol${priceRange.maxPrice.toStringAsFixed(2)}',
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    color: OsmeaColors.pewter,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
            OsmeaComponents.row(
              children: [
                Expanded(
                  child: _buildPriceInput(
                    context,
                    'Min price',
                    viewModel.minPriceController,
                    (value) {
                      viewModel.updateTempFilter(minPrice: value);
                    },
                    placeholder: priceRange?.minPrice.toString(),
                  ),
                ),
                OsmeaComponents.sizedBox(width: context.spacing12),
                Expanded(
                  child: _buildPriceInput(
                    context,
                    'Max price',
                    viewModel.maxPriceController,
                    (value) {
                      viewModel.updateTempFilter(maxPrice: value);
                    },
                    placeholder: priceRange?.maxPrice.toString(),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildPriceInput(
    BuildContext context,
    String label,
    TextEditingController controller,
    Function(String?) onChanged, {
    String? placeholder,
  }) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          label,
          textStyle: OsmeaTextStyle.bodySmall(
            context,
          ).copyWith(color: OsmeaColors.pewter),
        ),
        OsmeaComponents.sizedBox(height: context.spacing4),
        OsmeaComponents.textField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          hint: placeholder ?? (label == 'Min price' ? 'Min' : 'Max'),
          variant: TextFieldVariant.outlined,
          size: TextFieldSize.medium,
          onChanged: (value) {
            // Clean the input - only allow numbers and decimal point
            final cleaned = value.replaceAll(RegExp(r'[^\d.]'), '');
            // Ensure only one decimal point
            final parts = cleaned.split('.');
            final sanitized = parts.length > 2
                ? '${parts[0]}.${parts.sublist(1).join()}'
                : cleaned;

            // Update controller text if it changed
            if (controller.text != sanitized) {
              controller.value = TextEditingValue(
                text: sanitized,
                selection: TextSelection.collapsed(offset: sanitized.length),
              );
            }

            // Pass null if empty, otherwise pass the sanitized value
            final finalValue = sanitized.isEmpty ? null : sanitized;
            debugPrint('🔍 Price input changed - Label: $label, Raw: $value, Sanitized: $sanitized, Final: $finalValue');
            onChanged(finalValue);
          },
        ),
      ],
    );
  }

  Widget _buildOnSaleFilter(BuildContext context, bool isOnSale) {
    return GestureDetector(
      onTap: () {
        viewModel.updateTempFilter(onSale: isOnSale ? null : true);
      },
      child: OsmeaComponents.container(
        padding: context.paddingLow,
        decoration: BoxDecoration(
          color: isOnSale
              ? OsmeaColors.nordicBlue.withOpacity(0.1)
              : OsmeaColors.transparent,
          border: Border.all(
            color: isOnSale
                ? OsmeaColors.nordicBlue
                : OsmeaColors.silver.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(context.radiusLow),
        ),
        child: OsmeaComponents.row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OsmeaComponents.text(
              'On sale only',
              textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                color: isOnSale ? OsmeaColors.nordicBlue : OsmeaColors.thunder,
                fontWeight: isOnSale ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            OsmeaComponents.checkbox(
              value: isOnSale,
              onChanged: (value) {
                viewModel.updateTempFilter(onSale: value == true ? true : null);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockStatusFilter(BuildContext context, String? selectedStatus) {
    return BlocBuilder<ProductListViewModel, ProductListState>(
      bloc: viewModel,
      builder: (context, state) {
        // Get filter options from state
        final filterOptions = state is ProductListLoadedState 
            ? state.filterOptions 
            : null;

        if (filterOptions?.stockStatuses == null) {
          // Fallback to static options if API data not available
          return _buildStaticStockStatusFilter(context, selectedStatus);
        }

        return OsmeaComponents.column(
          children: filterOptions!.stockStatuses
              .where((stockStatus) => stockStatus.enabled)
              .map((stockStatus) => _buildStockStatusOption(
                    context,
                    stockStatus.label,
                    stockStatus.key,
                    selectedStatus,
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _buildStaticStockStatusFilter(BuildContext context, String? selectedStatus) {
    return OsmeaComponents.column(
      children: [
        _buildStockStatusOption(context, 'In stock', 'instock', selectedStatus),
        _buildStockStatusOption(
          context,
          'Out of stock',
          'outofstock',
          selectedStatus,
        ),
        _buildStockStatusOption(
          context,
          'On backorder',
          'onbackorder',
          selectedStatus,
        ),
      ],
    );
  }

  Widget _buildStockStatusOption(
    BuildContext context,
    String label,
    String value,
    String? selectedStatus,
  ) {
    final isSelected = selectedStatus == value;
    return GestureDetector(
      onTap: () {
        viewModel.updateTempFilter(stockStatus: isSelected ? null : value);
      },
      child: OsmeaComponents.container(
        padding: context.paddingLow,
        margin: EdgeInsets.only(bottom: context.spacing8),
        decoration: BoxDecoration(
          color: isSelected
              ? OsmeaColors.nordicBlue.withOpacity(0.1)
              : OsmeaColors.transparent,
          border: Border.all(
            color: isSelected
                ? OsmeaColors.nordicBlue
                : OsmeaColors.silver.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(context.radiusLow),
        ),
        child: OsmeaComponents.row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OsmeaComponents.text(
              label,
              textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                color: isSelected
                    ? OsmeaColors.nordicBlue
                    : OsmeaColors.thunder,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: OsmeaColors.nordicBlue, size: 20),
          ],
        ),
      ),
    );
  }
}
