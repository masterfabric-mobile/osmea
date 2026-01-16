import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
import 'package:storefront_woo/app/views/view_wishlist/widgets/wishlist_item_widget.dart';
import 'package:storefront_woo/app/utils/favorite_categories_helper.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_categories_api/freezed_model/response/retrieve_product_category_response_model.dart';
import 'package:get_it/get_it.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_categories_api/abstract/store_product_categories_service.dart';

class WishlistListWidget extends StatefulWidget {
  final List<WishlistItem> items;
  final WishlistViewModel viewModel;

  const WishlistListWidget({
    super.key,
    required this.items,
    required this.viewModel,
  });

  @override
  State<WishlistListWidget> createState() => _WishlistListWidgetState();
}

class _WishlistListWidgetState extends State<WishlistListWidget> {
  final AssetConfigHelper _configHelper = AssetConfigHelper();
  final FavoriteCategoriesHelper _favoriteHelper = FavoriteCategoriesHelper();
  final StoreProductCategoriesService _categoriesService = GetIt.I<StoreProductCategoriesService>();
  
  List<RetrieveProductCategoryResponseModel> _favoriteCategories = [];
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteCategories();
  }

  Future<void> _loadFavoriteCategories() async {
    try {
      final favoriteIds = await _favoriteHelper.getFavoriteCategoryIds();
      debugPrint('💖 WishlistList: Found ${favoriteIds.length} favorite category IDs');

      if (favoriteIds.isEmpty) {
        if (mounted) {
          setState(() {
            _favoriteCategories = [];
            _isLoadingCategories = false;
          });
        }
        return;
      }

      final apiVersion = _configHelper.getString('woocommerce_configuration.version', 'v1');
      final List<RetrieveProductCategoryResponseModel> categories = [];

      for (final categoryId in favoriteIds) {
        try {
          final categoryResponse = await _categoriesService.retrieveProductCategory(
            apiVersion: apiVersion,
            categoryId: categoryId,
          );
          categories.add(categoryResponse);
        } catch (e) {
          debugPrint('⚠️ Failed to fetch category $categoryId: $e');
        }
      }

      if (mounted) {
        setState(() {
          _favoriteCategories = categories;
          _isLoadingCategories = false;
        });
      }
      debugPrint('✅ WishlistList: Loaded ${categories.length} favorite categories');
    } catch (e) {
      debugPrint('❌ Error loading favorite categories: $e');
      if (mounted) {
        setState(() {
          _favoriteCategories = [];
          _isLoadingCategories = false;
        });
      }
    }
  }

  Future<void> _removeFavoriteCategory(int categoryId) async {
    try {
      final success = await _favoriteHelper.removeFavorite(categoryId);
      if (success) {
        await _loadFavoriteCategories();
        if (context.mounted) {
          context.showSnackbar(
            title: 'Removed from favorites',
            message: 'Category was removed from your favorites',
            type: SnackbarType.info,
            style: SnackbarStyle.minimal,
            position: SnackbarPosition.bottom,
            duration: const Duration(seconds: 2),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ Error removing favorite category: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasCategories = _favoriteCategories.isNotEmpty;
    final hasProducts = widget.items.isNotEmpty;
    
    // Don't navigate to empty view if still loading categories
    if (!_isLoadingCategories && !hasCategories && !hasProducts) {
      // Navigate to empty view route
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/empty/wishlist?actionPath=/home');
      });
      // Return empty container while navigating
      return const SizedBox.shrink();
    }

    final horizontalPadding = _configHelper.getDouble(
      'wishlist_view.component_spacing.horizontal',
      context.spacing12,
    );
    final verticalPadding = _configHelper.getDouble(
      'wishlist_view.component_spacing.vertical',
      context.spacing8,
    );
    final dividerColor = _configHelper.getColor(
      'wishlist_view.divider.color',
      OsmeaColors.silver,
    );
    final dividerHeight = _configHelper.getDouble(
      'wishlist_view.divider.height',
      context.height1,
    );

    return OsmeaComponents.singleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: OsmeaComponents.column(
        children: [
          // Favorite Categories Section
          if (hasCategories) ...[
            OsmeaComponents.padding(
              padding: EdgeInsets.only(bottom: context.spacing12),
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.text(
                    'Favorite Categories',
                    textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: OsmeaColors.black,
                    ),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing12),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _favoriteCategories.length,
                      itemBuilder: (context, index) {
                        final category = _favoriteCategories[index];
                        return _buildFavoriteCategoryCard(context, category);
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (hasProducts)
              OsmeaComponents.divider(
                color: dividerColor,
                height: dividerHeight,
              ),
            OsmeaComponents.sizedBox(height: context.spacing12),
          ],
          
          // Products Section
          if (hasProducts) ...[
            if (hasCategories)
              OsmeaComponents.text(
                'Saved Products',
                textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: OsmeaColors.black,
                ),
              ),
            if (hasCategories) OsmeaComponents.sizedBox(height: context.spacing12),
            for (int i = 0; i < widget.items.length; i++) ...[
              WishlistItemWidget(item: widget.items[i], viewModel: widget.viewModel),
              if (i < widget.items.length - 1)
                OsmeaComponents.divider(
                  color: dividerColor,
                  height: dividerHeight,
                ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildFavoriteCategoryCard(
    BuildContext context,
    RetrieveProductCategoryResponseModel category,
  ) {
    final categoryId = category.id ?? 0;
    final categoryName = category.name ?? 'Category';
    final imageUrl = category.image?.src ?? category.image?.thumbnail;

    return OsmeaComponents.container(
      margin: EdgeInsets.only(right: context.spacing12),
      width: 100,
      child: GestureDetector(
        onTap: () {
          context.push('/products?category_id=$categoryId');
        },
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: OsmeaColors.silver, width: 1),
                    color: OsmeaColors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? OsmeaComponents.image(
                            imageUrl: imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            variant: ImageVariant.normal,
                            cacheWidth: 80,
                            showLoadingIndicator: false,
                            errorWidget: Center(
                              child: Icon(
                                Icons.category_outlined,
                                color: OsmeaColors.grayMaterial[400],
                                size: 32,
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.category_outlined,
                              color: OsmeaColors.grayMaterial[400],
                              size: 32,
                            ),
                          ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removeFavoriteCategory(categoryId),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: OsmeaColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: OsmeaColors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: OsmeaColors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            OsmeaComponents.sizedBox(height: context.spacing4),
            OsmeaComponents.text(
              categoryName,
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                fontSize: context.fontSizeExtraSmall * context.textScaleFactor,
                fontWeight: FontWeight.w500,
                color: OsmeaColors.thunder,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
