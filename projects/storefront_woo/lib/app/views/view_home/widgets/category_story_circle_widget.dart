/*
 * CategoryStoryCircleWidget
 * -------------------------
 * Instagram-style category story circles widget.
 * Displays categories in horizontal scrollable circles.
 * Configured via app_config.json.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_categories_api/freezed_model/response/list_product_categories_response_model.dart';
import 'package:storefront_woo/app/utils/favorite_categories_helper.dart';

/// Category story circle widget
class CategoryStoryCircleWidget extends StatefulWidget {
  final AssetConfigHelper configHelper;
  final List<ListProductCategoriesResponseModel> categories;

  const CategoryStoryCircleWidget({
    super.key,
    required this.configHelper,
    required this.categories,
  });

  @override
  State<CategoryStoryCircleWidget> createState() =>
      _CategoryStoryCircleWidgetState();
}

class _CategoryStoryCircleWidgetState
    extends State<CategoryStoryCircleWidget> {
  final FavoriteCategoriesHelper _favoriteHelper = FavoriteCategoriesHelper();
  Map<int, bool> _favoriteStatus = {};

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final favoriteIds = await _favoriteHelper.getFavoriteCategoryIds();
    setState(() {
      _favoriteStatus = {
        for (var id in favoriteIds) id: true,
      };
    });
  }

  Future<void> _toggleFavorite(int categoryId, String categoryName) async {
    final wasFavorite = _favoriteStatus[categoryId] ?? false;
    final success = await _favoriteHelper.toggleFavorite(categoryId);

    if (success) {
      setState(() {
        _favoriteStatus[categoryId] = !wasFavorite;
      });

      if (!context.mounted) return;

      context.showSnackbar(
        title: !wasFavorite ? 'Added to favorites' : 'Removed from favorites',
        message: !wasFavorite
            ? 'Category was added to your favorites'
            : 'Category was removed from your favorites',
        type: !wasFavorite ? SnackbarType.info : SnackbarType.error,
        style: SnackbarStyle.minimal,
        position: SnackbarPosition.bottom,
        animation: SnackbarAnimation.slide,
        actionLabel: 'Undo',
        onAction: () async {
          await _favoriteHelper.toggleFavorite(categoryId);
          setState(() {
            _favoriteStatus[categoryId] = wasFavorite;
          });
        },
      );
    }
  }

  /// Loads circle categories configuration
  Map<String, dynamic>? _loadCategoriesConfig() {
    try {
      return widget.configHelper.getObject('home_view.circle_categories');
    } catch (e) {
      debugPrint('⚠️ Failed to load circle_categories config: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _loadCategoriesConfig();
    final showCategories = config?['enabled'] as bool? ?? true;

    if (!showCategories || widget.categories.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxItems = config?['max_items'] as int? ?? 10;
    final circleSize = config?['circle_size'] as int? ?? 64;
    final showNames = config?['show_names'] as bool? ?? true;
    final imageSize = config?['image_size'] as int? ?? 64;
    final spacing = config?['spacing'] as int? ?? 16;

    final displayCategories = widget.categories.take(maxItems).toList();

    return OsmeaComponents.padding(
      padding: EdgeInsets.fromLTRB(
        context.spacing20,
        0,
        context.spacing20,
        context.spacing16,
      ),
      child: SizedBox(
        height: showNames
            ? (circleSize.toDouble() + context.spacing8 + context.height20)
            : circleSize.toDouble(),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: displayCategories.length,
          itemBuilder: (context, index) {
            final category = displayCategories[index];
            return _buildCategoryCircle(
              context,
              category,
              circleSize.toDouble(),
              imageSize.toDouble(),
              spacing.toDouble(),
              showNames,
            );
          },
        ),
      ),
    );
  }

  /// Builds a single category circle
  Widget _buildCategoryCircle(
    BuildContext context,
    ListProductCategoriesResponseModel category,
    double circleSize,
    double imageSize,
    double spacing,
    bool showName,
  ) {
    final categoryId = category.id ?? 0;
    final categoryName = category.name ?? 'Category';
    final imageUrl = category.image?.src ?? category.image?.thumbnail;
    final isFavorite = _favoriteStatus[categoryId] ?? false;

    return Container(
      margin: EdgeInsets.only(right: spacing),
      child: OsmeaComponents.column(
        crossAxisAlignment: context.crossCenter,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () {
                  context.push('/products?category_id=$categoryId');
                },
                child: Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: OsmeaColors.nordicBlue,
                      width: 2,
                    ),
                    gradient: LinearGradient(
                      begin: context.topLeft,
                      end: context.bottomRight,
                      colors: [
                        OsmeaColors.nordicBlue,
                        OsmeaColors.nordicBlue.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: ClipOval(
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? OsmeaComponents.image(
                            imageUrl: imageUrl,
                            width: circleSize,
                            height: circleSize,
                            fit: BoxFit.cover,
                            variant: ImageVariant.normal,
                            cacheWidth: imageSize.toInt(),
                            showLoadingIndicator: true,
                            errorWidget: _buildDefaultIcon(context, circleSize),
                          )
                        : _buildDefaultIcon(context, circleSize),
                  ),
                ),
              ),
              // Favorite button overlay
              Positioned(
                top: -4,
                right: -4,
                child: GestureDetector(
                  onTap: () => _toggleFavorite(categoryId, categoryName),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: OsmeaColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: OsmeaColors.silver,
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 14,
                      color: isFavorite
                          ? OsmeaColors.nordicBlue
                          : OsmeaColors.thunder,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (showName) ...[
            OsmeaComponents.sizedBox(height: context.spacing8),
            SizedBox(
              width: circleSize + spacing,
              child: OsmeaComponents.text(
                categoryName,
                textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                  fontSize:
                      context.fontSizeExtraSmall * context.textScaleFactor,
                  fontWeight: FontWeight.w500,
                  color: OsmeaColors.thunder,
                ),
                maxLines: context.maxLineOne,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds default icon when category has no image
  Widget _buildDefaultIcon(BuildContext context, double size) {
    return Container(
      width: size,
      height: size,
      color: OsmeaColors.pewter,
      child: Icon(
        Icons.category_outlined,
        size: size * 0.5,
        color: OsmeaColors.thunder,
      ),
    );
  }
}

