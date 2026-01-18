/*
 * CollectionsSectionWidget
 * ------------------------
 * Config-driven collections (curated product groups) for Home view.
 *
 * Renders a horizontal list of collection tabs and a horizontal product strip
 * for the selected collection. All data (titles, ids, product_ids, limits) is
 * loaded from app config.
 */
 
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/utils/cart_add_helper.dart';
import 'package:storefront_woo/app/widgets/product_card_widget.dart';
 
class CollectionsSectionWidget extends StatefulWidget {
  final AssetConfigHelper configHelper;
  final List<ListAllProductsResponseModel> allProducts;
  final HomeViewModel viewModel;
 
  const CollectionsSectionWidget({
    super.key,
    required this.configHelper,
    required this.allProducts,
    required this.viewModel,
  });
 
  @override
  State<CollectionsSectionWidget> createState() => _CollectionsSectionWidgetState();
}
 
class _CollectionsSectionWidgetState extends State<CollectionsSectionWidget>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
 
  Map<String, dynamic>? _loadCollectionsConfig() {
    try {
      return widget.configHelper.getObject('home_view.collections');
    } catch (e) {
      debugPrint('⚠️ Failed to load collections config: $e');
      return null;
    }
  }
 
  List<Map<String, dynamic>> _itemsFromConfig(Map<String, dynamic>? cfg) {
    final raw = cfg?['items'];
    if (raw is! List) return const [];
    return raw.whereType<Map<String, dynamic>>().toList();
  }
 
  double _getHorizontalPadding(Map<String, dynamic>? cfg) {
    try {
      final padding = cfg?['padding'];
      if (padding is Map<String, dynamic>) {
        final h = (padding['horizontal'] as num?)?.toDouble();
        if (h != null && h >= 0) return h;
      }
    } catch (_) {}
    return widget.configHelper.getDouble('home_view.component_spacing.horizontal', 20.0);
  }
 
  int _getLimit(Map<String, dynamic> item) {
    final limit = (item['limit'] as num?)?.toInt();
    if (limit == null || limit <= 0) return 10;
    return limit.clamp(1, 20);
  }
 
  List<int> _getProductIds(Map<String, dynamic> item) {
    final raw = item['product_ids'];
    if (raw is! List) return const [];
    return raw
        .map((e) => int.tryParse(e.toString()) ?? -1)
        .where((id) => id > 0)
        .toList();
  }
 
  List<ListAllProductsResponseModel> _pickProductsForItem(Map<String, dynamic> item) {
    final ids = _getProductIds(item);
    final limit = _getLimit(item);
    if (ids.isEmpty) return const [];
 
    // Preserve configured order
    final byId = <int, ListAllProductsResponseModel>{};
    for (final p in widget.allProducts) {
      final id = p.id;
      if (id != null && id > 0) byId[id] = p;
    }
 
    return ids
        .map((id) => byId[id])
        .whereType<ListAllProductsResponseModel>()
        .take(limit)
        .toList();
  }

  void _ensureTabController(int length) {
    if (length <= 0) return;
    if (_tabController != null && _tabController!.length == length) return;

    final previousIndex = _tabController?.index ?? 0;
    _tabController?.dispose();
    _tabController = TabController(
      length: length,
      vsync: this,
      initialIndex: previousIndex.clamp(0, length - 1),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    final cfg = _loadCollectionsConfig();
    final enabled = cfg?['enabled'] as bool? ?? true;
    if (!enabled) return const SizedBox.shrink();
 
    final rawItems = _itemsFromConfig(cfg);
    if (rawItems.isEmpty) return const SizedBox.shrink();
 
    final horizontalPadding = _getHorizontalPadding(cfg);
    final sectionTitle = cfg?['title'] as String? ?? 'Collections';

    final items = rawItems
        .map((item) {
          final title = (item['title'] as String?)?.trim() ?? 'Collection';
          final products = _pickProductsForItem(item);
          return (title: title, products: products);
        })
        .where((e) => e.title.isNotEmpty)
        .toList();

    if (items.isEmpty) return const SizedBox.shrink();

    _ensureTabController(items.length);
    final tabController = _tabController;
    if (tabController == null) return const SizedBox.shrink();

    final double cardWidth =
        (context.allWidth - (horizontalPadding * 2) - context.spacing16) / 2;
    final imageHeight = context.height160 + context.spacing10;
    // Keep this tight; extra height makes the section feel "empty" at top/bottom.
    final tabViewHeight = imageHeight + context.height80 + context.spacing12;
 
    return OsmeaComponents.column(
      crossAxisAlignment: context.crossStart,
      children: [
        // Header
        OsmeaComponents.padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: OsmeaComponents.text(
            sectionTitle,
            textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
              fontSize: context.fontSizeNormal * context.textScaleFactor,
              fontWeight: FontWeight.w600,
              height: context.lineHeightTight,
              letterSpacing: -0.2,
              color: OsmeaColors.thunder,
            ),
          ),
        ),
        // Reduce top gap so the section doesn't start "too empty"
        OsmeaComponents.sizedBox(height: context.spacing6),
 
        // Underlined TabBar (no repeated tab title inside content)
        OsmeaComponents.padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                controller: tabController,
                isScrollable: true,
                // Start tabs flush-left (no leading inset) and keep consistent spacing.
                tabAlignment: TabAlignment.start,
                padding: EdgeInsets.zero,
                labelPadding: EdgeInsets.only(right: context.spacing16),
                labelColor: OsmeaColors.black,
                unselectedLabelColor: OsmeaColors.black.withValues(alpha: 0.55),
                labelStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
                unselectedLabelStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: OsmeaColors.black,
                    width: 2,
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.zero,
                tabs: items.map((e) => Tab(text: e.title)).toList(),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: OsmeaColors.silver.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),

        // Give the underline tabs some breathing room from content.
        OsmeaComponents.sizedBox(height: context.spacing16),

        // Tab content
        SizedBox(
          height: tabViewHeight,
          child: TabBarView(
            controller: tabController,
            children: items.map((e) {
              final products = e.products;
              if (products.isEmpty) return const SizedBox.shrink();

              return ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  itemCount: products.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(width: context.spacing16),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final productId = product.id ?? 0;
                    final wishlistVm = GetIt.I<WishlistViewModel>();
                    final isSaved = wishlistVm.isSaved(productId);

                    return SizedBox(
                      width: cardWidth,
                      child: ProductCardWidget(
                        product: product,
                        isSaved: isSaved,
                        onWishlistTap: () async =>
                            widget.viewModel.addProductToWishlist(productId),
                        onAddToCart: () async => addToCartFromProductCard(
                          context,
                          productId: productId,
                        ),
                        onTap: () {
                          widget.viewModel.selectProduct(product);
                          context.push('/product-detail/$productId');
                        },
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

