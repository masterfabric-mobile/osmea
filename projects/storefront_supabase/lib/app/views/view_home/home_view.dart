import 'package:flutter/material.dart';

import 'package:core/core.dart';
import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/models/product_filters.dart';

import 'models/home_view_model.dart';
import 'models/states.dart';

/// Supabase Home View
///
/// This view is built using `MasterViewCubit` from core and a
/// `SupabaseHomeViewModel` that extends `BaseViewModelCubit`.
/// It replaces the old `_MinimalistHomePage` while keeping the same
/// visual design for now.
class SupabaseHomeView
    extends MasterViewCubit<SupabaseHomeViewModel, SupabaseHomeState> {
  SupabaseHomeView({
    super.key,
    super.arguments = const {'home': true},
    required super.goRoute,
  }) : super(
          horizontalPadding: const PaddingVisibility.disabled(),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(
              'Storefront Supabase',
              color: Theme.of(context)
                  .colorScheme
                  .onPrimary, // Text color matches onPrimary
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            size: AppBarSize.large,
            elevation: 0,
            titleSpacing: 0.0,
            actions: [
              AppBarAction(
                type: AppBarActionType.search,
                icon: Icon(Icons.search,
                    color: Theme.of(context).colorScheme.onPrimary),
                onPressed: () => goRoute('/search'),
              ),
              AppBarAction(
                type: AppBarActionType.more,
                icon: Icon(Icons.shopping_cart_outlined,
                    color: Theme.of(context).colorScheme.onPrimary),
                onPressed: () => goRoute('/cart'),
              ),
            ],
          ),
        );

  @override
  void initialContent(
    SupabaseHomeViewModel viewModel,
    BuildContext context,
  ) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    SupabaseHomeViewModel viewModel,
    SupabaseHomeState state,
  ) {
    if (state is SupabaseHomeErrorState) {
      return buildError(
        state.message,
        onRetry: () => viewModel.initial(),
      );
    }

    if (state is SupabaseHomeLoadingState ||
        state is SupabaseHomeInitialState) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is SupabaseHomeLoadedState) {
      return Column(
        children: [
          _buildFilterBar(context, viewModel, state),
          Expanded(
            child: state.products.isEmpty
                ? OsmeaComponents.center(
                    child: OsmeaComponents.text('No products found.'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => goRoute('/product-detail/${product.id}'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: (product.imageUrl
                                        .contains('placehold.co'))
                                    ? const Center(
                                        child: Icon(Icons.image,
                                            color: Colors.grey))
                                    : Image.network(
                                        product.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Center(
                                              child: Icon(Icons.error,
                                                  color: Colors.red));
                                        },
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    }

    // Fallback for any other state
    return const Center(
      child: Text('Something went wrong.'),
    );
  }

  Widget _buildFilterBar(
    BuildContext context,
    SupabaseHomeViewModel viewModel,
    SupabaseHomeLoadedState state,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).cardColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton.icon(
            icon: const Icon(Icons.sort),
            label: const Text('Sort'),
            onPressed: () => _showSortSheet(context, viewModel, state),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            icon: const Icon(Icons.filter_list),
            label: const Text('Filter'),
            onPressed: () => _showFilterSheet(context, viewModel, state),
          ),
        ],
      ),
    );
  }

  void _showSortSheet(
    BuildContext context,
    SupabaseHomeViewModel viewModel,
    SupabaseHomeLoadedState currentState,
  ) {
    var tempPriceSort = currentState.priceSort;
    var tempDateSort = currentState.dateSort;
    var tempPopularitySort = currentState.popularitySort;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.4,
              maxChildSize: 0.6,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sort',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _buildSortSection(
                            context,
                            'Sort by Date',
                            tempDateSort,
                            DateSort.values,
                            (sort) {
                              setModalState(() {
                                tempDateSort = sort as DateSort;
                                tempPriceSort = PriceSort.none;
                                tempPopularitySort = PopularitySort.none;
                              });
                            },
                          ),
                          _buildSortSection(
                            context,
                            'Sort by Popularity',
                            tempPopularitySort,
                            PopularitySort.values,
                            (sort) {
                              setModalState(() {
                                tempPopularitySort = sort as PopularitySort;
                                tempPriceSort = PriceSort.none;
                                tempDateSort = DateSort.none;
                              });
                            },
                          ),
                          _buildSortSection(
                            context,
                            'Sort by Price',
                            tempPriceSort,
                            PriceSort.values,
                            (sort) {
                              setModalState(() {
                                tempPriceSort = sort as PriceSort;
                                tempDateSort = DateSort.none;
                                tempPopularitySort = PopularitySort.none;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setModalState(() {
                                  tempPriceSort = PriceSort.none;
                                  tempDateSort = DateSort.newestFirst;
                                  tempPopularitySort = PopularitySort.none;
                                });
                              },
                              child: const Text('Clear'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                viewModel.fetchProducts(
                                  priceSort: tempPriceSort,
                                  dateSort: tempDateSort,
                                  popularitySort: tempPopularitySort,
                                );
                                Navigator.pop(context);
                              },
                              child: const Text('Apply'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _showFilterSheet(
    BuildContext context,
    SupabaseHomeViewModel viewModel,
    SupabaseHomeLoadedState currentState,
  ) {
    // Hierarchical Filters
    Category? tempRoot = currentState.selectedRootCategory;
    Category? tempSub = currentState.selectedSubCategory;
    Category? tempLeaf = currentState.selectedLeafCategory;
    
    // Brand Filter
    Set<int> tempBrandIds = Set.from(currentState.selectedBrandIds);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            
            // Helpers
            final rootCats = viewModel.getRootCategories(currentState.allCategories);
            final subCats = viewModel.getSubCategories(currentState.allCategories, tempRoot?.id);
            final leafCats = viewModel.getSubCategories(currentState.allCategories, tempSub?.id);

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filters',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                           // --- Category Hierarchy ---
                          _buildSafeDropdown<Category>(
                            'Main Category',
                            rootCats,
                            (c) => c.name,
                            tempRoot,
                            (val) => setModalState(() {
                              tempRoot = val;
                              tempSub = null;
                              tempLeaf = null;
                            }),
                          ),
                          if (tempRoot != null && subCats.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _buildSafeDropdown<Category>(
                              'Sub Category',
                              subCats,
                              (c) => c.name,
                              tempSub,
                              (val) => setModalState(() {
                                tempSub = val;
                                tempLeaf = null;
                              }),
                            ),
                          ],
                          if (tempSub != null && leafCats.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _buildSafeDropdown<Category>(
                              'Specific Category',
                              leafCats,
                              (c) => c.name,
                              tempLeaf,
                              (val) => setModalState(() {
                                tempLeaf = val;
                              }),
                            ),
                          ],
                          
                          const Divider(height: 32),
                          
                          _buildCheckboxFilterSection<Brand, int>(
                            context,
                            'Brands',
                            currentState.allBrands,
                            tempBrandIds,
                            (brand) => brand.name,
                            (brand) => brand.id,
                            (isSelected, id) {
                              setModalState(() {
                                isSelected
                                    ? tempBrandIds.add(id)
                                    : tempBrandIds.remove(id);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setModalState(() {
                                  tempRoot = null;
                                  tempSub = null;
                                  tempLeaf = null;
                                  tempBrandIds.clear();
                                });
                              },
                              child: const Text('Clear'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                viewModel.fetchProducts(
                                  selectedRoot: tempRoot,
                                  selectedSub: tempSub,
                                  selectedLeaf: tempLeaf,
                                  selectedBrandIds: tempBrandIds,
                                );
                                Navigator.pop(context);
                              },
                              child: const Text('Apply'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
  
  Widget _buildSafeDropdown<T>(
    String label,
    List<T> items,
    String Function(T) itemToString,
    T? selectedItem,
    void Function(T?) onChanged,
  ) {
    T? effectiveValue;
    if (selectedItem != null) {
      try {
        effectiveValue = items.firstWhere((item) => item == selectedItem);
      } catch (e) {
        effectiveValue = null;
      }
    }
    return DropdownButtonFormField<T>(
      // ignore: deprecated_member_use
      value: effectiveValue,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemToString(item)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildSortSection<T>(
    BuildContext context,
    String title,
    T currentSort,
    List<T> allSorts,
    ValueChanged<T?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        ...allSorts.map(
          (sort) => ListTile(
            title: Text((sort as Enum).name),
            leading: Radio<T>(
              value: sort,
              // ignore: deprecated_member_use
              groupValue: currentSort,
              // ignore: deprecated_member_use
              onChanged: null,
            ),
            onTap: () => onChanged(sort),
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildCheckboxFilterSection<T, ID>(
    BuildContext context,
    String title,
    List<T> allItems,
    Set<ID> selectedIds,
    String Function(T) itemTitle,
    ID Function(T) itemId,
    void Function(bool, ID) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        ...allItems.map((item) {
          final id = itemId(item);
          final isSelected = selectedIds.contains(id);
          return ListTile(
            title: Text(itemTitle(item)),
            leading: Checkbox(
              value: isSelected,
              onChanged: null,
            ),
            onTap: () => onChanged(!isSelected, id),
          );
        }),
        const Divider(),
      ],
    );
  }
}
