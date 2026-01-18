import 'package:flutter/material.dart';
import 'package:core/core.dart'
    hide
        BuildContextTranslationsExtension,
        AppLocaleUtils,
        LocaleSettings,
        TranslationProvider;
import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/models/product_filters.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';
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
              context.resources.appTitle,
              color: const Color(0xFFFFFFFF), // White text
            ),
            backgroundColor: const Color(0xFF000000), // Black background
            foregroundColor: const Color(0xFFFFFFFF), // White foreground
            size: AppBarSize.large,
            elevation: 0,
            titleSpacing: 0.0,
            actions: [
              AppBarAction(
                type: AppBarActionType.search,
                icon: const Icon(
                  Icons.search,
                  color: Color(0xFFFFFFFF), // White
                ),
                onPressed: () => goRoute('/search'),
              ),
              AppBarAction(
                type: AppBarActionType.more,
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Color(0xFFFFFFFF), // White
                ),
                onPressed: () => goRoute('/cart'),
              ),
            ],
          ),
        );

  @override
  void initialContent(SupabaseHomeViewModel viewModel, BuildContext context) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    SupabaseHomeViewModel viewModel,
    SupabaseHomeState state,
  ) {
    final resources = context.resources;

    if (state is SupabaseHomeErrorState) {
      return buildError(state.message, onRetry: () => viewModel.initial());
    }

    if (state is SupabaseHomeLoadingState ||
        state is SupabaseHomeInitialState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is SupabaseHomeLoadedState) {
      return _ProductsViewWithScrollToTop(
        state: state,
        viewModel: viewModel,
        resources: resources,
        goRoute: goRoute,
      );
    }

    // Fallback for any other state
    return Center(child: Text(resources.somethingWentWrong));
  }
}

/// Products view with scroll to top and list/grid toggle
class _ProductsViewWithScrollToTop extends StatefulWidget {
  final SupabaseHomeLoadedState state;
  final SupabaseHomeViewModel viewModel;
  final dynamic resources; // Resources type from context.resources
  final Function(String) goRoute;

  const _ProductsViewWithScrollToTop({
    required this.state,
    required this.viewModel,
    required this.resources,
    required this.goRoute,
  });

  @override
  State<_ProductsViewWithScrollToTop> createState() =>
      _ProductsViewWithScrollToTopState();
}

class _ProductsViewWithScrollToTopState
    extends State<_ProductsViewWithScrollToTop> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;
  bool _isListView = false;
  int _columnCount = 2; // 2 or 3 for grid view

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final shouldShow = _scrollController.offset > 300;
    if (shouldShow != _showScrollToTop) {
      setState(() {
        _showScrollToTop = shouldShow;
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            _buildFilterBarWithViewToggle(
              context,
              widget.viewModel,
              widget.state,
            ),
            Expanded(
              child: widget.state.products.isEmpty
                  ? OsmeaComponents.center(
                      child: OsmeaComponents.text(widget.resources.noProducts),
                    )
                  : _isListView
                      ? _buildListView(context)
                      : _buildGridView(context),
            ),
          ],
        ),
        // Scroll to top button
        if (_showScrollToTop)
          Positioned(
            bottom: 24,
            right: 24,
            child: Material(
              color: const Color(0xFF000000),
              shape: const CircleBorder(),
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.3),
              child: InkWell(
                onTap: _scrollToTop,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFilterBarWithViewToggle(
    BuildContext context,
    SupabaseHomeViewModel viewModel,
    SupabaseHomeLoadedState state,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).cardColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              TextButton.icon(
                icon: const Icon(Icons.sort),
                label: Text(context.resources.sort),
                onPressed: () => _showSortSheet(context, viewModel, state),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                icon: const Icon(Icons.filter_list),
                label: Text(context.resources.filter),
                onPressed: () => _showFilterSheet(context, viewModel, state),
              ),
            ],
          ),
          // View toggle buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildViewToggleButton(
                icon: Icons.grid_view,
                isActive: !_isListView && _columnCount == 2,
                onTap: () => setState(() {
                  _isListView = false;
                  _columnCount = 2;
                }),
              ),
              const SizedBox(width: 4),
              _buildViewToggleButton(
                icon: Icons.apps,
                isActive: !_isListView && _columnCount == 3,
                onTap: () => setState(() {
                  _isListView = false;
                  _columnCount = 3;
                }),
              ),
              const SizedBox(width: 4),
              _buildViewToggleButton(
                icon: Icons.list,
                isActive: _isListView,
                onTap: () => setState(() => _isListView = true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggleButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF000000) : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isActive ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildGridView(BuildContext context) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _columnCount,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: _columnCount == 2
            ? 0.65
            : 0.58, // Adjusted to prevent overflow
      ),
      itemCount: widget.state.products.length,
      itemBuilder: (context, index) {
        final product = widget.state.products[index];
        return _buildProductCard(context, product);
      },
    );
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      itemCount: widget.state.products.length,
      itemBuilder: (context, index) {
        final product = widget.state.products[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildProductListTile(context, product),
        );
      },
    );
  }

  Widget _buildProductCard(BuildContext context, product) {
    final hasDiscount = product.hasDiscount;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => widget.goRoute('/product-detail/${product.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  SizedBox.expand(
                    child: (product.imageUrl.contains('placehold.co'))
                        ? const Center(
                            child: Icon(Icons.image, color: Colors.grey),
                          )
                        : Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.error, color: Colors.red),
                              );
                            },
                          ),
                  ),
                  if (hasDiscount)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFF000000),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Text(
                          product.discountPercentage != null
                              ? '-${product.discountPercentage!.toStringAsFixed(0)}%'
                              : 'SALE',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (hasDiscount) ...[
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey[600],
                                  ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        '\$${product.effectivePrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF000000),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListTile(BuildContext context, product) {
    final hasDiscount = product.hasDiscount;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => widget.goRoute('/product-detail/${product.id}'),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: (product.imageUrl.contains('placehold.co'))
                      ? const Icon(Icons.image, color: Colors.grey)
                      : Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, color: Colors.red);
                          },
                        ),
                ),
                if (hasDiscount)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF000000),
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      child: Text(
                        product.discountPercentage != null
                            ? '-${product.discountPercentage!.toStringAsFixed(0)}%'
                            : 'SALE',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (hasDiscount) ...[
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey[600],
                                    ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          '\$${product.effectivePrice.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: const Color(0xFF000000),
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortSheet(
    BuildContext context,
    SupabaseHomeViewModel viewModel,
    SupabaseHomeLoadedState currentState,
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
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            resources.sort,
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
                              child: Text(resources.clear),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                widget.viewModel.fetchProducts(
                                  priceSort: tempPriceSort,
                                  dateSort: tempDateSort,
                                  popularitySort: tempPopularitySort,
                                );
                                Navigator.pop(context);
                              },
                              child: Text(resources.apply),
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
    final resources = context.resources;
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
            final rootCats = widget.viewModel.getRootCategories(
              currentState.allCategories,
            );
            final subCats = widget.viewModel.getSubCategories(
              currentState.allCategories,
              tempRoot?.id,
            );
            final leafCats = widget.viewModel.getSubCategories(
              currentState.allCategories,
              tempSub?.id,
            );
            final isShoe = widget.viewModel.isShoeCategory(
              tempLeaf,
              tempSub,
              tempRoot,
            );
            final isFashion = widget.viewModel.isFashionCategory(tempRoot);

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.85,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            resources.filters,
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
                          _buildSafeDropdown<Category>(
                            resources.mainCategory,
                            rootCats,
                            (c) => c.name,
                            tempRoot,
                            (val) => setModalState(() {
                              tempRoot = val;
                              tempSub = null;
                              tempLeaf = null;
                              tempSizes.clear();
                            }),
                          ),
                          if (tempRoot != null && subCats.isNotEmpty) ...[
                            const SizedBox(height: 16),
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
                            const SizedBox(height: 16),
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
                          if (isShoe || isFashion) ...[
                            Text(
                              isShoe
                                  ? resources.shoeSizes
                                  : resources.sizeAgeGroups,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: (isShoe
                                      ? widget.viewModel.shoeSizes
                                      : widget.viewModel.clothingSizesAndAges)
                                  .map((opt) {
                                final isSelected = tempSizes.contains(opt);
                                return FilterChip(
                                  label: Text(opt),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setModalState(() {
                                      selected
                                          ? tempSizes.add(opt)
                                          : tempSizes.remove(opt);
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            const Divider(height: 32),
                          ],
                          _buildCheckboxFilterSection<Brand, int>(
                            context,
                            resources.brands,
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
                                  tempSizes.clear();
                                });
                              },
                              child: Text(resources.clear),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                widget.viewModel.fetchProducts(
                                  selectedRoot: tempRoot,
                                  selectedSub: tempSub,
                                  selectedLeaf: tempLeaf,
                                  selectedBrandIds: tempBrandIds,
                                  selectedSizesOrAges: tempSizes,
                                  applyFilter: true,
                                );
                                Navigator.pop(context);
                              },
                              child: Text(resources.apply),
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
            leading: Checkbox(value: isSelected, onChanged: null),
            onTap: () => onChanged(!isSelected, id),
          );
        }),
        const Divider(),
      ],
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
}