import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';
import 'package:storefront_woo/app/views/view_product_list/models/module/states.dart';

/// Debug widget to show filter data source and content
/// Only visible in debug mode
class DebugFilterInfoWidget extends StatelessWidget {
  final ProductListViewModel viewModel;

  const DebugFilterInfoWidget({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();

    return BlocBuilder<ProductListViewModel, ProductListState>(
      bloc: viewModel,
      builder: (context, state) {
        final filterOptions = state is ProductListLoadedState 
            ? state.filterOptions 
            : null;

        return ExpansionTile(
          title: OsmeaComponents.text(
            '🔍 Debug Filter Info',
            textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
          children: [
            Container(
              width: double.infinity,
              padding: context.paddingMedium,
              margin: context.paddingLow,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(context.radiusLow),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDebugRow('Data Source', 
                    filterOptions != null ? '🌐 Dynamic (API/Mock)' : '📱 Static Fallback'),
                  _buildDebugRow('Sort Options Count', 
                    filterOptions?.sortOptions != null ? '${filterOptions!.sortOptions.length}' : "Static: 6"),
                  _buildDebugRow('Stock Statuses Count', 
                    filterOptions?.stockStatuses != null ? '${filterOptions!.stockStatuses.length}' : "Static: 3"),
                  _buildDebugRow('Price Range', _getPriceRangeText(filterOptions)),
                  if (filterOptions?.categories != null)
                    _buildDebugRow('Categories', '${filterOptions!.categories!.length} available'),
                  if (filterOptions?.tags != null)
                    _buildDebugRow('Tags', '${filterOptions!.tags!.length} available'),
                  if (filterOptions?.availableAttributes != null)
                    _buildDebugRow('Attributes', '${filterOptions!.availableAttributes!.length} available'),
                ],
              ),
            ),
            // Test Real API Button
            Padding(
              padding: context.paddingLow,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => viewModel.testRealApiFilterOptions(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                  ),
                  child: OsmeaComponents.text(
                    '🧪 Test Real API',
                    textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getPriceRangeText(dynamic filterOptions) {
    if (filterOptions?.priceRange == null) return 'No API data';
    final priceRange = filterOptions!.priceRange;
    final symbol = priceRange.currencySymbol ?? '\$';
    return '$symbol${priceRange.minPrice} - $symbol${priceRange.maxPrice}';
  }

  Widget _buildDebugRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}