/*
 * BannerCarouselWidget
 * --------------------
 * Banner carousel widget that loads from app config.
 * Shows image if URL provided, otherwise shows text content.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:osmea_components/src/enums/carousel_enums.dart';

/// Banner item model from config
class BannerItem {
  final String? imageUrl;
  final String? title;
  final String? subtitle;
  final String? text;
  final String? route;
  final int? categoryId;
  final int? productId;
  final VoidCallback? onTap;

  BannerItem({
    this.imageUrl,
    this.title,
    this.subtitle,
    this.text,
    this.route,
    this.categoryId,
    this.productId,
    this.onTap,
  });

  factory BannerItem.fromConfig(Map<String, dynamic> config) {
    return BannerItem(
      imageUrl: config['imageUrl'] as String?,
      title: config['title'] as String?,
      subtitle: config['subtitle'] as String?,
      text: config['text'] as String?,
      route: config['route'] as String?,
      categoryId: config['category_id'] as int?,
      productId: config['product_id'] as int?,
    );
  }
}

/// Banner carousel widget
class BannerCarouselWidget extends StatelessWidget {
  final AssetConfigHelper configHelper;

  const BannerCarouselWidget({super.key, required this.configHelper});

  List<BannerItem> _loadBanners() {
    try {
      final bannersConfig = configHelper.getObject('home_view.banner');
      if (bannersConfig == null) return [];

      final List<dynamic>? bannersList =
          bannersConfig['items'] as List<dynamic>?;
      if (bannersList == null || bannersList.isEmpty) return [];

      return bannersList
          .map((item) => BannerItem.fromConfig(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('⚠️ Failed to load banners from config: $e');
      return [];
    }
  }

  /// Handles banner tap navigation
  void _handleBannerTap(BuildContext context, BannerItem banner) {
    if (banner.onTap != null) {
      banner.onTap!();
      return;
    }

    // Navigate based on configuration
    if (banner.route != null && banner.route!.isNotEmpty) {
      // Direct route navigation
      context.push(banner.route!);
    } else if (banner.categoryId != null) {
      // Navigate to category products page
      context.push('/products?category_id=${banner.categoryId}');
    } else if (banner.productId != null) {
      // Navigate to product detail page
      context.push('/product-detail/${banner.productId}');
    }
  }

  Widget _buildBannerItem(BuildContext context, BannerItem banner) {
    return GestureDetector(
      onTap: () => _handleBannerTap(context, banner),
      child: ClipRRect(
        borderRadius: BorderRadius.zero,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image - fills entire container
            if (banner.imageUrl != null && banner.imageUrl!.isNotEmpty)
              OsmeaComponents.image(
                imageUrl: banner.imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                variant: ImageVariant.normal,
                borderRadius: BorderRadius.zero,
              )
            else
              Container(
                color: OsmeaColors.nordicBlue,
              ),
            // Gradient overlay for text readability
            if (banner.imageUrl != null && banner.imageUrl!.isNotEmpty)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: context.topCenter,
                      end: context.bottomCenter,
                      colors: [Colors.transparent, OsmeaColors.thunder],
                    ),
                  ),
                ),
              ),
            // Text content overlay
            if (banner.title != null || banner.text != null)
              Positioned.fill(
                child: OsmeaComponents.padding(
                  padding: context.paddingNormal,
                  child: OsmeaComponents.column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (banner.title != null)
                        OsmeaComponents.text(
                          banner.title!,
                          textStyle: OsmeaTextStyle.headlineSmall(context).copyWith(
                            fontWeight: FontWeight.w700,
                            color: OsmeaColors.white,
                            shadows: [
                              Shadow(
                                color: OsmeaColors.thunder,
                                blurRadius: context.blurRadius2,
                              ),
                            ],
                          ),
                          maxLines: context.maxLineTwo,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (banner.title != null && banner.text != null)
                        OsmeaComponents.sizedBox(height: context.spacing8),
                      if (banner.text != null)
                        OsmeaComponents.text(
                          banner.text!,
                          textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                            color: OsmeaColors.white,
                            shadows: [
                              Shadow(
                                color: OsmeaColors.thunder,
                                blurRadius: context.blurRadius2,
                              ),
                            ],
                          ),
                          maxLines: context.maxLineThree,
                          overflow: TextOverflow.ellipsis,
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

  @override
  Widget build(BuildContext context) {
    final banners = _loadBanners();

    if (banners.isEmpty) {
      return const SizedBox.shrink();
    }

    // Always use items (not imageUrls) to support tap handlers
    // Build items with tap handlers for navigation - edge to edge (no horizontal margin)
    final items = banners
        .map(
          (banner) => OsmeaComponents.container(
            width: double.infinity,
            height: context.height192,
            child: _buildBannerItem(context, banner),
          ),
        )
        .toList();

    // Create tap handlers for each banner
    final onItemTaps = banners
        .map((banner) => () => _handleBannerTap(context, banner))
        .toList();

    return OsmeaComponents.padding(
      padding: EdgeInsets.only(bottom: context.spacing16),
      child: OsmeaComponents.carousel(
        variant: CarouselVariant.standard,
        size: CarouselSize.large,
        height: context.height192,
        items: items,
        onItemTaps: onItemTaps,
        showIndicators: true,
        showArrows: true,
        autoPlay: CarouselAutoPlay.continuous,
        autoPlayInterval: 4.seconds,
        indicatorType: CarouselIndicatorType.custom,
        indicatorPosition: CarouselIndicatorPosition.bottomRight,
        customIndicator: (context, itemCount, activeIndex) {
          return OsmeaComponents.padding(
            padding: EdgeInsets.only(
              right: context.spacing16,
              bottom: context.spacing12,
            ),
            child: OsmeaComponents.container(
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing8,
                vertical: context.spacing4,
              ),
              decoration: BoxDecoration(
                color: OsmeaColors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: OsmeaComponents.text(
                '${activeIndex + 1}/$itemCount',
                textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                  color: OsmeaColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
        borderRadiusValue: BorderRadius.zero,
        loop: true,
      ),
    );
  }
}
