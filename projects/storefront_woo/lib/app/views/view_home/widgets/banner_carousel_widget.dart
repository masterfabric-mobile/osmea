/*
 * BannerCarouselWidget
 * --------------------
 * Banner carousel widget that loads from app config.
 * Shows image if URL provided, otherwise shows text content.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Banner item model from config
class BannerItem {
  final String? imageUrl;
  final String? title;
  final String? subtitle;
  final String? text;
  final VoidCallback? onTap;

  BannerItem({this.imageUrl, this.title, this.subtitle, this.text, this.onTap});

  factory BannerItem.fromConfig(Map<String, dynamic> config) {
    return BannerItem(
      imageUrl: config['imageUrl'] as String?,
      title: config['title'] as String?,
      subtitle: config['subtitle'] as String?,
      text: config['text'] as String?,
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

  Widget _buildBannerItem(BuildContext context, BannerItem banner) {
    return GestureDetector(
      onTap: banner.onTap,
      child: OsmeaComponents.imageCard(
        // Image configuration
        imageUrl: banner.imageUrl,
        imageHeight: 200,
        imageFit: BoxFit.cover,
        imageAlignment: Alignment.center,
        imagePosition: banner.imageUrl != null && banner.imageUrl!.isNotEmpty
            ? ComponentPosition.center
            : ComponentPosition.top,

        // Card appearance
        variant: ComponentAppearance.filled,
        size: ComponentSize.medium,
        backgroundColor: OsmeaColors.nordicBlue,
        borderRadius: BorderRadius.circular(12),
        width: double.infinity,
        height: 200,

        // Content
        title: banner.title,
        content: banner.text,

        // Text styling for overlay on background images
        titleStyle: OsmeaTextStyle.headlineSmall(context).copyWith(
          fontWeight: FontWeight.w700,
          color: OsmeaColors.white,
          shadows: [Shadow(color: OsmeaColors.thunder, blurRadius: 2)],
        ),
        contentStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
          color: OsmeaColors.white,
          shadows: [Shadow(color: OsmeaColors.thunder, blurRadius: 2)],
        ),

        // Text overflow control
        titleMaxLines: 2,
        contentMaxLines: 3,
        textOverflow: TextOverflow.ellipsis,
        spacing: 12,

        // Show overlay for better text readability on background images
        showOverlay: banner.imageUrl != null && banner.imageUrl!.isNotEmpty,
        overlayGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, OsmeaColors.thunder],
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

    final imageUrls = banners
        .where((b) => b.imageUrl != null && b.imageUrl!.isNotEmpty)
        .map((b) => b.imageUrl!)
        .toList();

    // If all banners have images, use imageUrls
    if (imageUrls.length == banners.length) {
      return OsmeaComponents.padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: OsmeaComponents.carousel(
          imageUrls: imageUrls,
          variant: CarouselVariant.standard,
          size: CarouselSize.large,
          height: 200,
          autoPlay: CarouselAutoPlay.continuous,
          autoPlayInterval: const Duration(seconds: 4),
          showIndicators: true,
          showArrows: true,
          loop: true,
          indicatorPosition: CarouselIndicatorPosition.bottomCenter,
          indicatorType: CarouselIndicatorType.dot,
          borderRadiusValue: BorderRadius.circular(12),
        ),
      );
    }

    // Mixed content: build items and delegate to OsmeaComponents.carousel
    final items = banners
        .map(
          (b) => OsmeaComponents.container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: double.infinity,
            height: 200,
            child: _buildBannerItem(context, b),
          ),
        )
        .toList();

    return OsmeaComponents.padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: OsmeaComponents.carousel(
        variant: CarouselVariant.standard,
        size: CarouselSize.large,
        height: 200,
        items: items,
        showIndicators: true,
        showArrows: true,
        autoPlay: CarouselAutoPlay.continuous,
        autoPlayInterval: const Duration(seconds: 4),
        indicatorType: CarouselIndicatorType.dot,
        indicatorPosition: CarouselIndicatorPosition.bottomCenter,
        borderRadiusValue: BorderRadius.circular(12),
      ),
    );
  }
}
