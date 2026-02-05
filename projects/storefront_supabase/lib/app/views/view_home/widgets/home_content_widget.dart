import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/models/product_filters.dart';
import 'package:storefront_supabase/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_supabase/app/views/view_home/models/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

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
    
    return OsmeaComponents.stack(
      children: [
        OsmeaComponents.column(
          children: [
            if (widget.state.isLoading)
              const LinearProgressIndicator(minHeight: 2),
            _buildFilterBarWithViewToggle(
              context,
              widget.viewModel,
              widget.state,
            ),
            OsmeaComponents.expanded(
              child: widget.state.products.isEmpty
                  ? OsmeaComponents.center(
                      child: OsmeaComponents.text(resources.noProducts),
                    )
                  : widget.state.isListView
                      ? _buildListView(context)
                      : _buildGridView(context),
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
            : 0.58, 
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
        return OsmeaComponents.container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildProductListTile(context, product),
        );
      },
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  OsmeaComponents.sizedBox(height: 4),
                  BlocBuilder<CurrencyCubit, String>(
                    builder: (context, currency) {
                      return OsmeaComponents.row(
                        children: [
                          if (hasDiscount) ...[
                            OsmeaComponents.text(
                              PriceHelper.format(product.price, currency, Localizations.localeOf(context).toString()),
                              textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey[600],
                                  ),
                            ),
                            OsmeaComponents.sizedBox(width: 4),
                          ],
                          OsmeaComponents.text(
                            PriceHelper.format(product.effectivePrice, currency, Localizations.localeOf(context).toString()),
                            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                          errorWidget: const Icon(Icons.error, color: Colors.red),
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
                      textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                                PriceHelper.format(product.price, currency, Localizations.localeOf(context).toString()),
                                textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey[600],
                                    ),
                              ),
                              OsmeaComponents.sizedBox(width: 8),
                            ],
                            OsmeaComponents.text(
                              PriceHelper.format(product.effectivePrice, currency, Localizations.localeOf(context).toString()),
                              textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
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
                          IconButton(
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
                                widget.viewModel.fetchProducts(
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
    SupabaseHomeViewModel viewModel,
    SupabaseHomeLoadedState currentState,
  ) {
    // Simplified filter sheet for brevity - relying on HomeView logic
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        builder: (context, scrollController) => OsmeaComponents.center(child: OsmeaComponents.text("Filter Sheet")),
      ),
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
            title: OsmeaComponents.text((sort as Enum).name),
            // ignore: deprecated_member_use
            value: sort,
            // ignore: deprecated_member_use
            groupValue: currentSort,
            // ignore: deprecated_member_use
            onChanged: onChanged,
          ),
        ),
        const Divider(),
      ],
    );
  }
}
