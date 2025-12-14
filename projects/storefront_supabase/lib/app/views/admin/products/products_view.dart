import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/views/admin/products/models/product_filters.dart';
import 'package:storefront_supabase/app/views/admin/products/models/states.dart';
import 'package:storefront_supabase/app/views/admin/products/models/view_model.dart';

class AdminProductsView
    extends MasterViewCubit<AdminProductsViewModel, AdminProductsState> {
  AdminProductsView({
    super.key,
    required super.goRoute,
    super.arguments = const {'init': true},
  }) : super(
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text('Products'),
            variant: AppBarVariant.primary,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            leading: OsmeaComponents.iconButton(
              onPressed: () => context.go('/profile'),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        );

  @override
  void initialContent(AdminProductsViewModel viewModel, BuildContext context) {
    viewModel.fetchProducts();
  }

  @override
  Widget viewContent(
    BuildContext context,
    AdminProductsViewModel viewModel,
    AdminProductsState state,
  ) {
    return Scaffold(
      body: Column(
        children: [
          _buildFilterControls(context, viewModel, state),
          Expanded(child: _buildBody(context, viewModel, state)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/admin/products/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterControls(
    BuildContext context,
    AdminProductsViewModel viewModel,
    AdminProductsState state,
  ) {
    if (state is! AdminProductsLoaded) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: viewModel.searchController,
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: viewModel.setSearchQuery,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context, viewModel, state),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(
    BuildContext context,
    AdminProductsViewModel viewModel,
    AdminProductsLoaded currentState,
  ) {
    // ✅ TEMP STATE’LER BURADA (KRİTİK NOKTA)
    var tempPriceSort = currentState.priceSort;
    var tempDateSort = currentState.dateSort;
    var tempPopularitySort = currentState.popularitySort;
    var tempSelectedCatIds =
        Set<String>.from(currentState.selectedCategoryIds);
    var tempSelectedBrandIds =
        Set<String>.from(currentState.selectedBrandIds);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
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
                                tempPopularitySort =
                                    sort as PopularitySort;
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
                          _buildCheckboxFilterSection<Category>(
                            context,
                            'Categories',
                            currentState.allCategories,
                            tempSelectedCatIds,
                            (cat) => cat.name,
                            (cat) => cat.id,
                            (isSelected, id) {
                              setModalState(() {
                                isSelected
                                    ? tempSelectedCatIds.add(id)
                                    : tempSelectedCatIds.remove(id);
                              });
                            },
                          ),
                          _buildCheckboxFilterSection<Brand>(
                            context,
                            'Brands',
                            currentState.allBrands,
                            tempSelectedBrandIds,
                            (brand) => brand.name,
                            (brand) => brand.id.toString(),
                            (isSelected, id) {
                              setModalState(() {
                                isSelected
                                    ? tempSelectedBrandIds.add(id)
                                    : tempSelectedBrandIds.remove(id);
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
                                  tempPopularitySort =
                                      PopularitySort.none;
                                  tempSelectedCatIds.clear();
                                  tempSelectedBrandIds.clear();
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
                                  selectedCategoryIds:
                                      tempSelectedCatIds,
                                  selectedBrandIds:
                                      tempSelectedBrandIds,
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
              groupValue: currentSort,
              onChanged: null,
            ),
            onTap: () => onChanged(sort),
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildCheckboxFilterSection<T>(
    BuildContext context,
    String title,
    List<T> allItems,
    Set<String> selectedIds,
    String Function(T) itemTitle,
    String Function(T) itemId,
    void Function(bool, String) onChanged,
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

  Widget _buildBody(
    BuildContext context,
    AdminProductsViewModel viewModel,
    AdminProductsState state,
  ) {
    if (state is AdminProductsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AdminProductsError) {
      return Center(child: Text(state.message));
    }

    if (state is AdminProductsLoaded) {
      if (state.products.isEmpty) {
        return const Center(child: Text('No products found.'));
      }

      return RefreshIndicator(
        onRefresh: viewModel.fetchProducts,
        child: ListView.builder(
          itemCount: state.products.length,
          itemBuilder: (context, index) {
            final product = state.products[index];
            return ListTile(
              leading: Image.network(
                product.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.error, size: 40),
              ),
              title: Text(product.name),
              subtitle:
                  Text('\$${product.price.toStringAsFixed(2)}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () =>
                    context.go('/admin/products/edit/${product.id}'),
              ),
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
