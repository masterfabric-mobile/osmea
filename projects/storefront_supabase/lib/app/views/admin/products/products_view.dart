import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/models/product_filters.dart';
import 'package:storefront_supabase/app/views/admin/products/models/states.dart';
import 'package:storefront_supabase/app/views/admin/products/models/view_model.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class AdminProductsView
    extends MasterViewCubit<AdminProductsViewModel, AdminProductsState> {
  AdminProductsView({
    super.key,
    required super.goRoute,
    super.arguments = const {'init': true},
  }) : super(
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(
              context.resources.products,
              color: Colors.black,
            ),
            variant: AppBarVariant.primary,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
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
    return OsmeaComponents.scaffold(
      body: OsmeaComponents.column(
        children: [
          _buildFilterControls(context, viewModel, state),
          OsmeaComponents.expanded(child: _buildBody(context, viewModel, state)),
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
    final resources = context.resources;
    if (state is! AdminProductsLoaded) return const SizedBox.shrink();

    return OsmeaComponents.container(
      color: Colors.white,
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: OsmeaComponents.row(
          children: [
            OsmeaComponents.expanded(
              child: OsmeaComponents.textField(
                controller: viewModel.searchController,
                label: resources.searchProductsHint, // Using label as hint proxy or label
                prefixIcon: const Icon(Icons.search),
                onChanged: viewModel.setSearchQuery,
                variant: TextFieldVariant.outlined,
              ),
            ),
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.sort, color: Colors.black),
              tooltip: resources.sort,
              onPressed: () => _showSortSheet(context, viewModel, state),
            ),
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.filter_list, color: Colors.black),
              tooltip: resources.filter,
              onPressed: () => _showFilterSheet(context, viewModel, state),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortSheet(
    BuildContext context,
    AdminProductsViewModel viewModel,
    AdminProductsLoaded currentState,
  ) {
    final resources = context.resources;
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
                return OsmeaComponents.column(
                  children: [
                    OsmeaComponents.padding(
                      padding: const EdgeInsets.all(16),
                      child: OsmeaComponents.row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OsmeaComponents.text(
                            resources.sort,
                            textStyle: Theme.of(context).textTheme.titleLarge,
                          ),
                          OsmeaComponents.iconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    OsmeaComponents.expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _buildSortSection(
                            context,
                            resources.sortByDate,
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
                            resources.sortByPopularity,
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
                            resources.sortByPrice,
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
                    OsmeaComponents.padding(
                      padding: const EdgeInsets.all(16),
                      child: OsmeaComponents.row(
                        children: [
                          OsmeaComponents.expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setModalState(() {
                                  tempPriceSort = PriceSort.none;
                                  tempDateSort = DateSort.newestFirst;
                                  tempPopularitySort = PopularitySort.none;
                                });
                              },
                              child: OsmeaComponents.text(resources.clear),
                            ),
                          ),
                          OsmeaComponents.sizedBox(width: 16),
                          OsmeaComponents.expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                viewModel.fetchProducts(
                                  priceSort: tempPriceSort,
                                  dateSort: tempDateSort,
                                  popularitySort: tempPopularitySort,
                                );
                                Navigator.pop(context);
                              },
                              child: OsmeaComponents.text(resources.apply),
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
    AdminProductsViewModel viewModel,
    AdminProductsLoaded currentState,
  ) {
    final resources = context.resources;
    // Temp State for Filter Sheet
    Category? tempRoot = currentState.selectedRootCategory;
    Category? tempSub = currentState.selectedSubCategory;
    Category? tempLeaf = currentState.selectedLeafCategory;
    Set<int> tempBrandIds = Set.from(currentState.selectedBrandIds);
    List<String> tempSizes = List.from(currentState.selectedSizesOrAges);

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
            
            final isShoe = viewModel.isShoeCategory(tempLeaf, tempSub, tempRoot);
            final isFashion = viewModel.isFashionCategory(tempRoot);

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.85,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return OsmeaComponents.column(
                  children: [
                    // Header
                    OsmeaComponents.padding(
                      padding: const EdgeInsets.all(16),
                      child: OsmeaComponents.row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OsmeaComponents.text(resources.filters, textStyle: Theme.of(context).textTheme.titleLarge),
                          OsmeaComponents.iconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    OsmeaComponents.expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                           // --- Category Hierarchy ---
                          _buildSafeDropdown<Category>(
                            resources.mainCategory,
                            rootCats,
                            (c) => c.name,
                            tempRoot,
                            (val) => setModalState(() {
                              tempRoot = val;
                              tempSub = null;
                              tempLeaf = null;
                              tempSizes.clear(); // Reset sizes on root change
                            }),
                          ),
                          if (tempRoot != null && subCats.isNotEmpty) ...[
                            OsmeaComponents.sizedBox(height: 16),
                            _buildSafeDropdown<Category>(
                              resources.subCategory,
                              subCats,
                              (c) => c.name,
                              tempSub,
                              (val) => setModalState(() {
                                tempSub = val;
                                tempLeaf = null;
                                tempSizes.clear();
                              }),
                            ),
                          ],
                          if (tempSub != null && leafCats.isNotEmpty) ...[
                            OsmeaComponents.sizedBox(height: 16),
                            _buildSafeDropdown<Category>(
                              resources.specificCategory,
                              leafCats,
                              (c) => c.name,
                              tempLeaf,
                              (val) => setModalState(() {
                                tempLeaf = val;
                                tempSizes.clear();
                              }),
                            ),
                          ],

                          const Divider(height: 32),

                          // --- Size / Age Filter ---
                          if (isShoe || isFashion) ...[
                            OsmeaComponents.text(
                              isShoe ? resources.shoeSizes : resources.sizeAgeGroups,
                              textStyle: Theme.of(context).textTheme.titleMedium,
                            ),
                            OsmeaComponents.sizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: (isShoe ? viewModel.shoeSizes : viewModel.clothingSizesAndAges).map((opt) {
                                final isSelected = tempSizes.contains(opt);
                                return FilterChip(
                                  label: Text(opt),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setModalState(() {
                                      selected ? tempSizes.add(opt) : tempSizes.remove(opt);
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            const Divider(height: 32),
                          ],

                          // --- Brand Filter ---
                          OsmeaComponents.text(resources.brands, textStyle: Theme.of(context).textTheme.titleMedium),
                          ...currentState.allBrands.map((brand) {
                            final isSelected = tempBrandIds.contains(brand.id);
                            return CheckboxListTile(
                              title: Text(brand.name),
                              value: isSelected,
                              onChanged: (val) {
                                setModalState(() {
                                  val == true ? tempBrandIds.add(brand.id) : tempBrandIds.remove(brand.id);
                                });
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                    
                    // Buttons
                    OsmeaComponents.padding(
                      padding: const EdgeInsets.all(16),
                      child: OsmeaComponents.row(
                        children: [
                          OsmeaComponents.expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setModalState(() {
                                  tempRoot = null;
                                  tempSub = null;
                                  tempLeaf = null;
                                  tempBrandIds.clear();
                                  tempSizes.clear();
                                });
                              },
                              child: OsmeaComponents.text(resources.clear),
                            ),
                          ),
                          OsmeaComponents.sizedBox(width: 16),
                          OsmeaComponents.expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                viewModel.fetchProducts(
                                  selectedRoot: tempRoot,
                                  selectedSub: tempSub,
                                  selectedLeaf: tempLeaf,
                                  selectedBrandIds: tempBrandIds,
                                  selectedSizesOrAges: tempSizes,
                                );
                                Navigator.pop(context);
                              },
                              child: OsmeaComponents.text(resources.apply),
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
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(title, textStyle: Theme.of(context).textTheme.titleMedium),
        ...allSorts.map(
          (sort) => RadioListTile<T>(
            title: Text((sort as Enum).name),
            // ignore: deprecated_member_use
            value: sort,
            // ignore: deprecated_member_use
            groupValue: currentSort,
            // ignore: deprecated_member_use
            onChanged: onChanged,
            // selected: sort == currentSort, // Optional: highlight selected
          ),
        ),
        const Divider(),
      ],
    );
  }



  Widget _buildBody(
    BuildContext context,
    AdminProductsViewModel viewModel,
    AdminProductsState state,
  ) {
    final resources = context.resources;
    if (state is AdminProductsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AdminProductsError) {
      return OsmeaComponents.center(child: OsmeaComponents.text(state.message));
    }

    if (state is AdminProductsLoaded) {
      if (state.products.isEmpty && !state.isLoading) {
        return OsmeaComponents.center(child: OsmeaComponents.text(resources.noProducts));
      }

      return OsmeaComponents.column(
        children: [
          if (state.isLoading) const LinearProgressIndicator(),
          OsmeaComponents.expanded(
            child: RefreshIndicator(
              onRefresh: viewModel.fetchProducts,
              child: ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return OsmeaComponents.listItem(
                    leading: OsmeaComponents.image(
                      imageUrl: product.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorWidget: const Icon(Icons.error, size: 40),
                    ),
                    title: OsmeaComponents.text(product.name),
                    subtitle: BlocBuilder<CurrencyCubit, String>(
                      builder: (context, currency) {
                        return OsmeaComponents.text(PriceHelper.format(
                            product.price,
                            currency,
                            Localizations.localeOf(context).toString()));
                      },
                    ),
                    trailing: OsmeaComponents.iconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          context.go('/admin/products/edit/${product.id}'),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
