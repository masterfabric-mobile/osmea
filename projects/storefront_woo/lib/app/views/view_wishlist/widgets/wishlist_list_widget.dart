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
import 'package:osmea_components/src/components/bottom_sheet/bottom_sheet.dart';

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
  
  List<WishlistGroup> _wishlistGroups = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteCategories();
    _loadWishlistGroups();
    
    // Listen to viewModel state changes to update groups
    widget.viewModel.stream.listen((state) {
      if (mounted && state is WishlistLoadedState) {
        setState(() {
          _wishlistGroups = state.groups;
        });
      }
    });
  }
  
  void _loadWishlistGroups() {
    final currentState = widget.viewModel.state;
    if (currentState is WishlistLoadedState) {
      setState(() {
        _wishlistGroups = currentState.groups;
      });
    }
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
    final hasGroups = _wishlistGroups.isNotEmpty;
    
    // Default en başta olacak şekilde sıralama
    final sortedGroups = List<WishlistGroup>.from(_wishlistGroups);
    sortedGroups.sort((a, b) {
      if (a.name == 'Default') return -1;
      if (b.name == 'Default') return 1;
      return 0;
    });

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
          // Wishlist Collections Section
          if (hasGroups) ...[
            OsmeaComponents.padding(
              padding: EdgeInsets.only(bottom: context.spacing12),
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.text(
                    'Collections',
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
                      itemCount: sortedGroups.length,
                      itemBuilder: (context, index) {
                        final group = sortedGroups[index];
                        return _buildCollectionCard(context, group);
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (hasCategories || hasProducts)
              OsmeaComponents.divider(
                color: dividerColor,
                height: dividerHeight,
              ),
            OsmeaComponents.sizedBox(height: context.spacing12),
          ],
          
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

  Widget _buildCollectionCard(
    BuildContext context,
    WishlistGroup group,
  ) {
    return OsmeaComponents.container(
      margin: EdgeInsets.only(right: context.spacing12),
      width: 100,
      child: GestureDetector(
        onTap: () {
          _showCollectionDetailDialog(context, group);
        },
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: OsmeaColors.silver, width: 1),
                color: OsmeaColors.grayMaterial[50],
              ),
              child: Center(
                child: Icon(
                  Icons.folder_outlined,
                  color: OsmeaColors.grayMaterial[600],
                  size: 32,
                ),
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing4),
            OsmeaComponents.text(
              group.name == 'Default' ? 'My Collection' : group.name,
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                fontSize: context.fontSizeExtraSmall * context.textScaleFactor,
                fontWeight: FontWeight.w500,
                color: OsmeaColors.thunder,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            if (group.itemCount != null && group.itemCount! > 0)
              OsmeaComponents.text(
                '${group.itemCount} items',
                textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                  fontSize: context.fontSizeExtraSmall * 0.9 * context.textScaleFactor,
                  color: OsmeaColors.grayMaterial[500],
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

  void _showCollectionDetailDialog(BuildContext context, WishlistGroup group) {
    final groupId = int.tryParse(group.id);
    if (groupId == null) {
      context.showSnackbar(
        title: 'Error',
        message: 'Invalid collection ID',
        type: SnackbarType.error,
        style: SnackbarStyle.minimal,
        position: SnackbarPosition.bottom,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => StatefulBuilder(
        builder: (context, setBottomSheetState) {
          bool isDeleting = false;
          
          return OsmeaBottomSheet(
            size: BottomSheetSize.large,
            variant: BottomSheetVariant.modal,
            title: group.name == 'Default' ? 'My Collection' : group.name,
            headerActions: [
              if (group.name != 'Default')
                isDeleting 
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: Icon(Icons.delete_outline, color: OsmeaColors.red),
                      onPressed: () async {
                        final confirmed = await OsmeaComponents.showPopup<bool>(
                          context: context,
                          variant: PopupVariant.dialog,
                          title: 'Delete Collection',
                          subtitle: 'Are you sure you want to delete this collection?',
                          padding: context.paddingNormal,
                          child: OsmeaComponents.row(
                            children: [
                              OsmeaComponents.expanded(
                                child: OsmeaComponents.button(
                                  text: 'Cancel',
                                  variant: ButtonVariant.outlined,
                                  onPressed: () => Navigator.of(context).pop(false),
                                ),
                              ),
                              OsmeaComponents.sizedBox(width: context.spacing8),
                              OsmeaComponents.expanded(
                                child: OsmeaComponents.button(
                                  text: 'Delete',
                                  variant: ButtonVariant.primary,
                                  backgroundColor: OsmeaColors.red,
                                  onPressed: () => Navigator.of(context).pop(true),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          setBottomSheetState(() => isDeleting = true);
                          try {
                            await widget.viewModel.deleteGroup(groupId);
                            if (bottomSheetContext.mounted) {
                              Navigator.of(bottomSheetContext).pop();
                              context.showSnackbar(
                                title: 'Deleted',
                                message: 'Collection deleted successfully',
                                type: SnackbarType.success,
                                style: SnackbarStyle.minimal,
                                position: SnackbarPosition.bottom,
                                duration: const Duration(seconds: 2),
                              );
                            }
                          } catch (e) {
                            setBottomSheetState(() => isDeleting = false);
                            if (context.mounted) {
                              context.showSnackbar(
                                title: 'Error',
                                message: 'Failed to delete collection',
                                type: SnackbarType.error,
                                style: SnackbarStyle.minimal,
                                position: SnackbarPosition.bottom,
                                duration: const Duration(seconds: 2),
                              );
                            }
                          }
                        }
                      },
                    )
              else
                Icon(
                  Icons.folder_outlined,
                  color: OsmeaColors.black,
                  size: 24,
                ),
            ],
            footer: OsmeaComponents.button(
              text: 'Close',
              variant: ButtonVariant.outlined,
              onPressed: () => Navigator.of(bottomSheetContext).pop(),
            ),
            backgroundColor: OsmeaColors.white,
            child: _CollectionDetailContent(
              group: group,
              groupId: groupId,
              viewModel: widget.viewModel,
              allItems: widget.items,
            ),
          );
        },
      ),
    );
  }
}

class _CollectionDetailContent extends StatefulWidget {
  final WishlistGroup group;
  final int groupId;
  final WishlistViewModel viewModel;
  final List<WishlistItem> allItems;

  const _CollectionDetailContent({
    required this.group,
    required this.groupId,
    required this.viewModel,
    required this.allItems,
  });

  @override
  State<_CollectionDetailContent> createState() => _CollectionDetailContentState();
}

class _CollectionDetailContentState extends State<_CollectionDetailContent> {
  List<WishlistItem>? _collectionItems;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCollectionItems();
  }

  Future<void> _loadCollectionItems() async {
    setState(() => _isLoading = true);
    try {
      // Wait a bit for server to process the change
      await Future.delayed(const Duration(milliseconds: 800));
      // Reload groups to get updated item counts
      await widget.viewModel.loadGroups();
      // Wait a bit more for groups to update
      await Future.delayed(const Duration(milliseconds: 300));
      final items = await widget.viewModel.getCollectionItems(widget.groupId);
      if (mounted) {
        setState(() {
          _collectionItems = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _collectionItems = [];
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          if (widget.group.description != null && widget.group.description!.isNotEmpty) ...[
            OsmeaComponents.text(
              widget.group.description!,
              textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                color: OsmeaColors.grayMaterial[600],
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),
          ],
          // Collection içindeki ürünler
          OsmeaComponents.text(
            'Items in this collection: ${_collectionItems?.length ?? 0}',
            textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.grayMaterial[500],
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          if (_collectionItems != null && _collectionItems!.isNotEmpty) ...[
            ..._collectionItems!.map((item) => Container(
              margin: EdgeInsets.only(bottom: context.spacing2),
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing12,
                vertical: context.spacing6,
              ),
              child: Row(
                children: [
                  item.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: OsmeaComponents.image(
                            imageUrl: item.imageUrl!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            variant: ImageVariant.normal,
                          ),
                        )
                      : Icon(Icons.image_outlined, size: 24),
                  SizedBox(width: context.spacing12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.name ?? 'Product',
                          style: OsmeaTextStyle.bodyLarge(context).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.regularPrice != null)
                          Padding(
                            padding: EdgeInsets.only(top: context.spacing2),
                            child: Text(
                              PriceInfoCurrencyHelper.formatPrice(
                                double.tryParse(item.regularPrice ?? '0') ?? 0,
                                currencyCode: item.currencyCode,
                              ),
                              style: OsmeaTextStyle.bodySmall(context).copyWith(
                                color: OsmeaColors.grayMaterial[600],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline, 
                      color: OsmeaColors.black,
                      size: 24,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    onPressed: () async {
                      if (_isLoading) return;
                      setState(() => _isLoading = true);
                      try {
                        // Use itemId if available (preferred method), otherwise use productId + groupId
                        if (item.itemId != null) {
                          await widget.viewModel.removeByItemId(item.itemId!);
                        } else {
                          await widget.viewModel.remove(item.id, groupId: widget.groupId);
                        }
                        // Reload collection items and keep loading until update is complete
                        await _loadCollectionItems();
                        if (mounted) {
                          context.showSnackbar(
                            title: 'Removed',
                            message: '${item.name} removed from ${widget.group.name == 'Default' ? 'My Collection' : widget.group.name}',
                            type: SnackbarType.success,
                            style: SnackbarStyle.minimal,
                            position: SnackbarPosition.bottom,
                            duration: const Duration(seconds: 2),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          setState(() => _isLoading = false);
                          context.showSnackbar(
                            title: 'Error',
                            message: 'Failed to remove item: ${e.toString()}',
                            type: SnackbarType.error,
                            style: SnackbarStyle.minimal,
                            position: SnackbarPosition.bottom,
                            duration: const Duration(seconds: 2),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            )),
            OsmeaComponents.sizedBox(height: context.spacing12),
          ] else if (_collectionItems != null && _collectionItems!.isEmpty) ...[
            Padding(
              padding: EdgeInsets.all(context.spacing12),
              child: OsmeaComponents.text(
                'No items in this collection yet',
                textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                  color: OsmeaColors.grayMaterial[500],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing12),
          ],
          // Eklenebilecek ürünler
          OsmeaComponents.text(
            'Add products to this collection:',
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          if (widget.allItems.isNotEmpty)
            ...widget.allItems.map((item) => Container(
              margin: EdgeInsets.only(bottom: context.spacing2),
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing12,
                vertical: context.spacing6,
              ),
              child: Row(
                children: [
                  item.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: OsmeaComponents.image(
                            imageUrl: item.imageUrl!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            variant: ImageVariant.normal,
                          ),
                        )
                      : Icon(Icons.image_outlined, size: 24),
                  SizedBox(width: context.spacing12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.name ?? 'Product',
                          style: OsmeaTextStyle.bodyLarge(context).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.regularPrice != null)
                          Padding(
                            padding: EdgeInsets.only(top: context.spacing2),
                            child: Text(
                              PriceInfoCurrencyHelper.formatPrice(
                                double.tryParse(item.regularPrice ?? '0') ?? 0,
                                currencyCode: item.currencyCode,
                              ),
                              style: OsmeaTextStyle.bodySmall(context).copyWith(
                                color: OsmeaColors.grayMaterial[600],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, 
                      color: OsmeaColors.black,
                      size: 24,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    onPressed: () async {
                      if (_isLoading) return;
                      setState(() => _isLoading = true);
                      try {
                        await widget.viewModel.add(item, groupId: widget.groupId);
                        // Reload collection items and keep loading until update is complete
                        await _loadCollectionItems();
                        if (mounted) {
                          context.showSnackbar(
                            title: 'Added',
                            message: '${item.name} added to ${widget.group.name == 'Default' ? 'My Collection' : widget.group.name}',
                            type: SnackbarType.success,
                            style: SnackbarStyle.minimal,
                            position: SnackbarPosition.bottom,
                            duration: const Duration(seconds: 2),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          setState(() => _isLoading = false);
                        }
                      }
                    },
                  ),
                ],
              ),
            )),
          if (widget.allItems.isEmpty)
            Padding(
              padding: EdgeInsets.all(context.spacing16),
              child: OsmeaComponents.text(
                'No products available to add',
                textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                  color: OsmeaColors.grayMaterial[500],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ],
          ),
        ),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: OsmeaColors.white.withOpacity(0.8),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
