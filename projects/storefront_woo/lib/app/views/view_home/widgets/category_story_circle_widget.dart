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

/// Category story circle widget
class CategoryStoryCircleWidget extends StatelessWidget {
  final AssetConfigHelper configHelper;
  final List<ListProductCategoriesResponseModel> categories;

  const CategoryStoryCircleWidget({
    super.key,
    required this.configHelper,
    required this.categories,
  });

  /// Loads circle categories configuration
  Map<String, dynamic>? _loadCategoriesConfig() {
    try {
      return configHelper.getObject('home_view.circle_categories');
    } catch (e) {
      debugPrint('⚠️ Failed to load circle_categories config: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _loadCategoriesConfig();
    final showCategories = config?['enabled'] as bool? ?? true;

    if (!showCategories || categories.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxItems = config?['max_items'] as int? ?? 10;
    final circleSize = config?['circle_size'] as int? ?? 64;
    final showNames = config?['show_names'] as bool? ?? true;
    final imageSize = config?['image_size'] as int? ?? 64;
    final spacing = config?['spacing'] as int? ?? 16;

    final displayCategories = categories.take(maxItems).toList();

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

    return GestureDetector(
      onTap: () {
        context.push('/products?category_id=$categoryId');
      },
      child: Container(
        margin: EdgeInsets.only(right: spacing),
        child: OsmeaComponents.column(
          crossAxisAlignment: context.crossCenter,
          children: [
            Container(
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

