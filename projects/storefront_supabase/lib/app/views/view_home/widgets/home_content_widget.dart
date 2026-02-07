import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/product_filters.dart';
import 'package:storefront_supabase/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_supabase/app/views/view_home/models/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';
import 'package:storefront_supabase/app/views/view_home/widgets/home_category_list_widget.dart';
import 'package:storefront_supabase/app/views/view_home/widgets/filter_sheet_widget.dart'; // Added

class HomeContentWidget extends StatefulWidget {
  final SupabaseHomeLoadedState state;
  final SupabaseHomeViewModel viewModel;
  final Function(String) goRoute;

  const HomeContentWidget({
    super.key,
    required this.state,
    required this.viewModel,
    required this.goRoute,
  });

  @override
  State<HomeContentWidget> createState() => _HomeContentWidgetState();
}

class _HomeContentWidgetState extends State<HomeContentWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;
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
    final resources = context.resources;

    return Stack(
      children: [
        Column(
          children: [
                          // --- Fixed Search Bar ---
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8), // Adjusted top padding to 4
                                            child: OsmeaComponents.textField(
                                              key: const ValueKey('homeSearchBar'),
                                              controller: widget.viewModel.searchController,
                                              hint: resources.searchProductsHint, // Changed label to hint
                                              prefixIcon: const Icon(Icons.search),
                                              variant: TextFieldVariant.outlined,
                                              focusColor: Colors.black,
                                              onChanged: widget.viewModel.setSearchQuery,
                                            ),
                            
            ),

            // --- Scrollable Content ---
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // --- Category List ---
                  SliverToBoxAdapter(
                    child: HomeCategoryListWidget(
                      allCategories: widget.state.allCategories,
                      goRoute: widget.goRoute,
                    ),
                  ),

                  if (widget.state.isLoading)
                    const SliverToBoxAdapter(
                      child: LinearProgressIndicator(minHeight: 2),
                    ),

                  // --- PRODUCT OF THE DAY SECTION ---
                  if (widget.state.productsOfTheDay.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: _buildSectionTitle(context, "Günün Ürünü"),
                    ),
                    SliverToBoxAdapter(
                      child: ProductOfTheDayCarousel(
                        products: widget.state.productsOfTheDay,
                        goRoute: widget.goRoute,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: Divider(
                          height: 32, thickness: 1, color: Color(0xFFEEEEEE)),
                    ),
                  ],

                  // --- SHOP BY BRANDS SECTION ---
                  if (widget.state.allBrands.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: _buildSectionTitle(
                          context, "Mağazalara Göre Satın Al"),
                    ),
                    SliverToBoxAdapter(
                      child: _buildBrandList(context, widget.state.allBrands),
                    ),
                    const SliverToBoxAdapter(
                      child: Divider(
                          height: 32, thickness: 1, color: Color(0xFFEEEEEE)),
                    ),
                  ],

                  // --- COLLECTION SECTION ---
                  if (widget.state.collectionProducts.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: _buildSectionTitle(context, "Koleksiyon"),
                    ),
                    SliverToBoxAdapter(
                      child: _buildHorizontalProductList(
                          context, widget.state.collectionProducts),
                    ),
                    const SliverToBoxAdapter(
                      child: Divider(
                          height: 32, thickness: 1, color: Color(0xFFEEEEEE)),
                    ),
                  ],

                  // --- RECOMMENDED SECTION ---
                  if (widget.state.recommendedProducts.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: _buildSectionTitle(context, "Sana Önerilenler"),
                    ),
                    SliverToBoxAdapter(
                      child: _buildHorizontalProductList(
                          context, widget.state.recommendedProducts),
                    ),
                    const SliverToBoxAdapter(
                      child: Divider(
                          height: 32, thickness: 8, color: Color(0xFFF5F5F5)),
                    ),
                  ],

                  // --- ON SALE SECTION ---
                  if (widget.state.onSaleProducts.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: _buildSectionTitle(context, "İndirimli Ürünler"),
                    ),
                    SliverToBoxAdapter(
                      child: _buildHorizontalProductList(
                          context, widget.state.onSaleProducts),
                    ),
                    const SliverToBoxAdapter(
                      child: Divider(
                          height: 32, thickness: 8, color: Color(0xFFF5F5F5)),
                    ),
                  ],

                  // --- Filter Bar ---
                  SliverToBoxAdapter(
                    child: _buildFilterBarWithViewToggle(
                        context, widget.viewModel, widget.state),
                  ),

                  // --- Main Product List/Grid ---
                  widget.state.products.isEmpty
                      ? SliverFillRemaining(
                          child: OsmeaComponents.center(
                            child: OsmeaComponents.text(resources.noProducts),
                          ),
                        )
                      : widget.state.isListView
                          ? _buildSliverListView(context)
                          : _buildSliverGridView(context),
                  
                  // Padding for bottom navigation bar
                  SliverToBoxAdapter(
                    child: SizedBox(height: MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Scroll to top button
        if (_showScrollToTop)
          OsmeaComponents.positioned(
            bottom: 24,
            right: 24,
            child: Material(
              color: const Color(0xFF000000),
              shape: const CircleBorder(),
              elevation: 8,
              shadowColor: Color.fromARGB((255 * 0.3).round(), 0, 0, 0),
              child: InkWell(
                onTap: _scrollToTop,
                borderRadius: BorderRadius.circular(24),
                child: OsmeaComponents.container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB((255 * 0.3).round(), 0, 0, 0),
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

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: OsmeaComponents.text(
              title,
              textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
          ),
          // Optional: See All button
        ],
      ),
    );
  }

  Widget _buildHorizontalProductList(
      BuildContext context, List<Product> products) {
    return SizedBox(
      height: 260, // Fixed height for carousel
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final product = products[index];
          return SizedBox(
            width: 160,
            child: _buildProductCard(
                context, product), // Reusing card but constrained width
          );
        },
      ),
    );
  }

  Widget _buildBrandList(BuildContext context, List<Brand> brands) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final brand = brands[index];
          return GestureDetector(
            onTap: () {
              // Trigger filter for this brand
              widget.viewModel.setBrandFilters({brand.id});
            },
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                    image: brand.logoUrl != null
                        ? DecorationImage(
                            image: NetworkImage(brand.logoUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: brand.logoUrl == null
                      ? Center(
                          child: Text(
                            brand.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 70,
                  child: Text(
                    brand.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterBarWithViewToggle(
    BuildContext context,
    SupabaseHomeViewModel viewModel,
    SupabaseHomeLoadedState state,
  ) {
    final resources = context.resources;
    return OsmeaComponents.container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
      ),
      child: OsmeaComponents.row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OsmeaComponents.row(
            children: [
              TextButton.icon(
                icon: const Icon(Icons.sort, color: Colors.black),
                label: OsmeaComponents.text(
                  resources.sort,
                  textStyle: const TextStyle(color: Colors.black),
                ),
                onPressed: () => _showSortSheet(context, viewModel, state),
              ),
              OsmeaComponents.sizedBox(width: 8),
              TextButton.icon(
                icon: const Icon(Icons.filter_list, color: Colors.black),
                label: OsmeaComponents.text(
                  resources.filter,
                  textStyle: const TextStyle(color: Colors.black),
                ),
                onPressed: () => _showFilterSheet(context, viewModel, state),
              ),
            ],
          ),
          // View toggle buttons
          OsmeaComponents.row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildViewToggleButton(
                icon: Icons.grid_view,
                isActive: !state.isListView && _columnCount == 2,
                onTap: () {
                  viewModel.toggleViewMode(false);
                  setState(() {
                    _columnCount = 2;
                  });
                },
              ),
              OsmeaComponents.sizedBox(width: 4),
              _buildViewToggleButton(
                icon: Icons.apps,
                isActive: !state.isListView && _columnCount == 3,
                onTap: () {
                  viewModel.toggleViewMode(false);
                  setState(() {
                    _columnCount = 3;
                  });
                },
              ),
              OsmeaComponents.sizedBox(width: 4),
              _buildViewToggleButton(
                icon: Icons.list,
                isActive: state.isListView,
                onTap: () => viewModel.toggleViewMode(true),
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
        child: OsmeaComponents.container(
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

  // New Sliver versions of ListView and GridView
  SliverList _buildSliverListView(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = widget.state.products[index];
          return OsmeaComponents.container(
            margin: const EdgeInsets.only(bottom: 16),
            child: _buildProductListTile(context, product),
          );
        },
        childCount: widget.state.products.length,
      ),
    );
  }

  SliverGrid _buildSliverGridView(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _columnCount,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: _columnCount == 2 ? 0.65 : 0.58,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = widget.state.products[index];
          return _buildProductCard(context, product);
        },
        childCount: widget.state.products.length,
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    final hasDiscount = product.hasDiscount;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => widget.goRoute('/product-detail/${product.id}'),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.expanded(
              child: OsmeaComponents.stack(
                children: [
                  SizedBox.expand(
                    child: (product.imageUrl.contains('placehold.co'))
                        ? const Center(
                            child: Icon(Icons.image, color: Colors.grey),
                          )
                        : OsmeaComponents.image(
                            imageUrl: product.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorWidget: const Center(
                              child: Icon(Icons.error, color: Colors.red),
                            ),
                          ),
                  ),
                  if (hasDiscount)
                    OsmeaComponents.positioned(
                      top: 8,
                      right: 8,
                      child: OsmeaComponents.container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFF000000),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: OsmeaComponents.text(
                          product.discountPercentage != null
                              ? '-${product.discountPercentage!.toStringAsFixed(0)}%'
                              : 'SALE',
                          textStyle: const TextStyle(
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
            OsmeaComponents.padding(
              padding: const EdgeInsets.all(8.0),
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.text(
                    product.name,
                    maxLines: 1, // Reduced to 1 line to save space
                    overflow: TextOverflow.ellipsis,
                    textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  OsmeaComponents.sizedBox(height: 4),
                  BlocBuilder<CurrencyCubit, String>(
                    builder: (context, currency) {
                      return Wrap(
                        // Changed Row to Wrap to handle price overflow
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (hasDiscount) ...[
                            OsmeaComponents.text(
                              PriceHelper.format(
                                  product.price,
                                  currency,
                                  Localizations.localeOf(context).toString()),
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey[600],
                                    fontSize: 10, // Slightly smaller font
                                  ),
                            ),
                            OsmeaComponents.sizedBox(width: 4),
                          ],
                          OsmeaComponents.text(
                            PriceHelper.format(
                                product.effectivePrice,
                                currency,
                                Localizations.localeOf(context).toString()),
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: const Color(0xFF000000),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListTile(BuildContext context, Product product) {
    final hasDiscount = product.hasDiscount;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => widget.goRoute('/product-detail/${product.id}'),
        child: OsmeaComponents.row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            OsmeaComponents.stack(
              children: [
                OsmeaComponents.container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: (product.imageUrl.contains('placehold.co'))
                      ? const Icon(Icons.image, color: Colors.grey)
                      : OsmeaComponents.image(
                          imageUrl: product.imageUrl,
                          fit: BoxFit.cover,
                          errorWidget:
                              const Icon(Icons.error, color: Colors.red),
                        ),
                ),
                if (hasDiscount)
                  OsmeaComponents.positioned(
                    top: 4,
                    right: 4,
                    child: OsmeaComponents.container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF000000),
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      child: OsmeaComponents.text(
                        product.discountPercentage != null
                            ? '-${product.discountPercentage!.toStringAsFixed(0)}%'
                            : 'SALE',
                        textStyle: const TextStyle(
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
            OsmeaComponents.expanded(
              child: OsmeaComponents.padding(
                padding: const EdgeInsets.all(12.0),
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OsmeaComponents.text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    OsmeaComponents.sizedBox(height: 8),
                    BlocBuilder<CurrencyCubit, String>(
                      builder: (context, currency) {
                        return OsmeaComponents.row(
                          children: [
                            if (hasDiscount) ...[
                              OsmeaComponents.text(
                                PriceHelper.format(
                                    product.price,
                                    currency,
                                    Localizations.localeOf(context).toString()),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey[600],
                                    ),
                              ),
                              OsmeaComponents.sizedBox(width: 8),
                            ],
                            OsmeaComponents.text(
                              PriceHelper.format(
                                  product.effectivePrice,
                                  currency,
                                  Localizations.localeOf(context).toString()),
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: const Color(0xFF000000),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        );
                      },
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
      backgroundColor: Colors.white,
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
                    // --- Header ---
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
                    
                    // --- Content ---
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        children: [
                          _buildCustomSortSection(
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
                          _buildCustomSortSection(
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
                          _buildCustomSortSection(
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
                    
                    // --- Footer ---
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
                              ),
                              child: OsmeaComponents.text(resources.clear, color: Colors.black),
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: OsmeaComponents.text(resources.apply, color: Colors.white),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => FilterSheetWidget(
        viewModel: viewModel,
        state: currentState,
      ),
    );
  }

  Widget _buildCustomSortSection<T>(
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
              color: Colors.grey[800],
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allSorts.map((sort) {
            final isSelected = currentSort == sort;
            final label = (sort as Enum).name; // Simple name, consider localized mapping if available
            return InkWell(
              onTap: () => onChanged(sort),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  label, // Should localize this ideally
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
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
}

class ProductOfTheDayCarousel extends StatefulWidget {
  final List<Product> products;
  final Function(String) goRoute;

  const ProductOfTheDayCarousel({
    super.key,
    required this.products,
    required this.goRoute,
  });

  @override
  State<ProductOfTheDayCarousel> createState() =>
      _ProductOfTheDayCarouselState();
}

class _ProductOfTheDayCarouselState extends State<ProductOfTheDayCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  // ignore: unused_field
  late final Future<void> _timerFuture;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() async {
    while (_isActive) {
      await Future.delayed(const Duration(seconds: 5));
      if (!_isActive) break;
      if (_pageController.hasClients) {
        final nextIndex = (_currentIndex + 1) % widget.products.length;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _isActive = false;
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240, // Height for the banner
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.products.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final product = widget.products[index];
              return _buildCarouselItem(context, product);
            },
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_currentIndex + 1}/${widget.products.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () => widget.goRoute('/product-detail/${product.id}'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Full background image
              Positioned.fill(
                child: (product.imageUrl.contains('placehold.co'))
                    ? Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 50))
                    : Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: Colors.grey[200]),
                      ),
              ),
              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
              ),
              // Product Info
              Positioned(
                bottom: 16,
                left: 16,
                right: 60, // Leave space for indicator
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    BlocBuilder<CurrencyCubit, String>(
                      builder: (context, currency) {
                        return Text(
                          PriceHelper.format(
                            product.effectivePrice,
                            currency,
                            Localizations.localeOf(context).toString(),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}