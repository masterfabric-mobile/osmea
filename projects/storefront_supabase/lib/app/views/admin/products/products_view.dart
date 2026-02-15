import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/models/product_filters.dart';
import 'package:storefront_supabase/app/views/admin/products/models/module/states.dart';
import 'package:storefront_supabase/app/views/admin/products/models/products_view_model.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class AdminProductsView
    extends MasterViewCubit<AdminProductsViewModel, AdminProductsState> {
  AdminProductsView({
    super.key,
    required super.goRoute,
    super.arguments = const {'init': true},
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.horizontalPadding = const PaddingVisibility.disabled(),
  }) : super(
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(
              context.resources.products,
              color: OsmeaColors.black,
            ),
            variant: AppBarVariant.primary,
            backgroundColor: OsmeaColors.white,
            foregroundColor: OsmeaColors.black,
            leading: OsmeaComponents.iconButton(
              onPressed: () => context.go('/profile'),
              icon: Icon(Icons.arrow_back, color: OsmeaColors.black),
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
        backgroundColor: OsmeaColors.black,
        foregroundColor: OsmeaColors.white,
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
      color: OsmeaColors.white,
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
              icon: Icon(Icons.sort, color: OsmeaColors.black),
              tooltip: resources.sort,
              onPressed: () => _showSortSheet(context, viewModel, state),
            ),
            OsmeaComponents.iconButton(
              icon: Icon(Icons.filter_list, color: OsmeaColors.black),
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
      backgroundColor: OsmeaColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.5,
              maxChildSize: 0.75,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OsmeaComponents.text(
                            resources.sort,
                            textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    
                    // Content
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        children: [
                          _buildModernSortSection(
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
                          _buildModernSortSection(
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
                          _buildModernSortSection(
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
                    
                    // Footer
                    const Divider(height: 1),
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
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                foregroundColor: OsmeaColors.black,
                                side: const BorderSide(color: OsmeaColors.black),
                              ),
                              child: OsmeaComponents.text(resources.clear, color: OsmeaColors.black),
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: OsmeaColors.black,
                                foregroundColor: OsmeaColors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: OsmeaComponents.text(resources.apply, color: OsmeaColors.white),
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

  Widget _buildModernSortSection<T>(
    BuildContext context,
    String title,
    T currentSort,
    List<T> allSorts,
    ValueChanged<T?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: OsmeaComponents.text(
            title,
            textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: OsmeaColors.thunder,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allSorts.map((sort) {
            final isSelected = currentSort == sort;
            final label = (sort as Enum).name;
            return InkWell(
              onTap: () => onChanged(sort),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? OsmeaColors.black : OsmeaColors.ash,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? OsmeaColors.black : OsmeaColors.silver,
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? OsmeaColors.white : OsmeaColors.black,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showFilterSheet(
    BuildContext context,
    AdminProductsViewModel viewModel,
    AdminProductsLoaded currentState,
  ) {
    final resources = context.resources;
    
    Category? tempRoot = currentState.selectedRootCategory;
    Category? tempSub = currentState.selectedSubCategory;
    Category? tempLeaf = currentState.selectedLeafCategory;
    Set<int> tempBrandIds = Set.from(currentState.selectedBrandIds);
    List<String> tempSizes = List.from(currentState.selectedSizesOrAges);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: OsmeaColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            
            final rootCats = viewModel.getRootCategories(currentState.allCategories);
            // We only show root categories in the modern filter for simplicity in this refactor,
            // or we could show sub-cats dynamically. Let's stick to Root for the chip list to mimic Home.
            // If user wants deep hierarchy, they can select one.
            
            final isShoe = viewModel.isShoeCategory(tempLeaf, tempSub, tempRoot);
            final isFashion = viewModel.isFashionCategory(tempRoot);

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.85,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OsmeaComponents.text(resources.filters, textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),

                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        children: [
                           // --- Categories (Root) ---
                           OsmeaComponents.text(
                             resources.categories, 
                             textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
                           ),
                           const SizedBox(height: 12),
                           Wrap(
                             spacing: 8,
                             runSpacing: 8,
                             children: rootCats.map((cat) {
                               final isSelected = tempRoot?.id == cat.id;
                               return FilterChip(
                                 label: Text(cat.name),
                                 selected: isSelected,
                                 onSelected: (selected) {
                                   setModalState(() {
                                     // Toggle logic
                                     if (selected) {
                                       tempRoot = cat;
                                     } else {
                                       tempRoot = null;
                                     }
                                     tempSub = null;
                                     tempLeaf = null;
                                     tempSizes.clear();
                                   });
                                 },
                                 selectedColor: OsmeaColors.black,
                                 checkmarkColor: OsmeaColors.white,
                                 labelStyle: TextStyle(color: isSelected ? OsmeaColors.white : OsmeaColors.black),
                                 backgroundColor: OsmeaColors.white,
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(20),
                                   side: BorderSide(color: OsmeaColors.silver),
                                 ),
                               );
                             }).toList(),
                           ),
                           
                           // Sub Categories (Only if root selected)
                           if (tempRoot != null) ...[
                             const SizedBox(height: 24),
                             OsmeaComponents.text(resources.subCategory, textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                             const SizedBox(height: 12),
                             Wrap(
                               spacing: 8,
                               runSpacing: 8,
                               children: viewModel.getSubCategories(currentState.allCategories, tempRoot?.id).map((sub) {
                                 final isSelected = tempSub?.id == sub.id;
                                 return FilterChip(
                                   label: Text(sub.name),
                                   selected: isSelected,
                                   onSelected: (selected) {
                                     setModalState(() {
                                       tempSub = selected ? sub : null;
                                       tempLeaf = null;
                                       tempSizes.clear();
                                     });
                                   },
                                   selectedColor: OsmeaColors.black,
                                   checkmarkColor: OsmeaColors.white,
                                   labelStyle: TextStyle(color: isSelected ? OsmeaColors.white : OsmeaColors.black),
                                   backgroundColor: OsmeaColors.white,
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(20),
                                     side: BorderSide(color: OsmeaColors.silver),
                                   ),
                                 );
                               }).toList(),
                             ),
                           ],

                          const Divider(height: 32),

                          // --- Size / Age Filter ---
                          if (isShoe || isFashion) ...[
                            OsmeaComponents.text(
                              isShoe ? resources.shoeSizes : resources.sizeAgeGroups,
                              textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
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
                                  selectedColor: OsmeaColors.black,
                                  checkmarkColor: OsmeaColors.white,
                                  labelStyle: TextStyle(color: isSelected ? OsmeaColors.white : OsmeaColors.black),
                                  backgroundColor: OsmeaColors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), // Square-ish for sizes
                                    side: BorderSide(color: OsmeaColors.silver),
                                  ),
                                );
                              }).toList(),
                            ),
                            const Divider(height: 32),
                          ],

                          // --- Brand Filter ---
                          OsmeaComponents.text(resources.brands, textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: currentState.allBrands.map((brand) {
                              final isSelected = tempBrandIds.contains(brand.id);
                              return FilterChip(
                                label: Text(brand.name),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setModalState(() {
                                    selected ? tempBrandIds.add(brand.id) : tempBrandIds.remove(brand.id);
                                  });
                                },
                                selectedColor: OsmeaColors.black,
                                checkmarkColor: OsmeaColors.white,
                                labelStyle: TextStyle(color: isSelected ? OsmeaColors.white : OsmeaColors.black),
                                backgroundColor: OsmeaColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(color: OsmeaColors.silver),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    
                    // Buttons
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: OsmeaColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: OsmeaColors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
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
                                  tempSizes.clear();
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                foregroundColor: OsmeaColors.black,
                                side: const BorderSide(color: OsmeaColors.black),
                              ),
                              child: OsmeaComponents.text(resources.clear, color: OsmeaColors.black),
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
                                  selectedSizesOrAges: tempSizes,
                                );
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: OsmeaColors.black,
                                foregroundColor: OsmeaColors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: OsmeaComponents.text(resources.apply, color: OsmeaColors.white),
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
