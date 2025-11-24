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
        imageHeight: context.height192,
        imageFit: BoxFit.cover,
        imageAlignment: Alignment.center,
        imagePosition: banner.imageUrl != null && banner.imageUrl!.isNotEmpty
            ? ComponentPosition.center
            : ComponentPosition.top,

        // Card appearance
        variant: ComponentAppearance.filled,
        size: ComponentSize.medium,
        backgroundColor: OsmeaColors.nordicBlue,
        borderRadius: context.borderRadiusNormal,
        width: double.infinity,
        height: context.height192,

        // Content
        title: banner.title,
        content: banner.text,

        // Text styling for overlay on background images
        titleStyle: OsmeaTextStyle.headlineSmall(context).copyWith(
          fontWeight: FontWeight.w700,
          color: OsmeaColors.white,
          shadows: [
            Shadow(color: OsmeaColors.thunder, blurRadius: context.blurRadius2),
          ],
        ),
        contentStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
          color: OsmeaColors.white,
          shadows: [
            Shadow(color: OsmeaColors.thunder, blurRadius: context.blurRadius2),
          ],
        ),

        // Text overflow control
        titleMaxLines: context.maxLineTwo,
        contentMaxLines: context.maxLineThree,
        textOverflow: TextOverflow.ellipsis,
        spacing: context.spacing12,

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
        padding: EdgeInsets.fromLTRB(
          context.spacing16,
          0,
          context.spacing16,
          context.spacing16,
        ),
        child: OsmeaComponents.carousel(
          imageUrls: imageUrls,
          variant: CarouselVariant.standard,
          size: CarouselSize.large,
          height: context.height192,
          autoPlay: CarouselAutoPlay.continuous,
          autoPlayInterval: 4.seconds,
          showIndicators: true,
          showArrows: true,
          loop: true,
          indicatorPosition: CarouselIndicatorPosition.bottomCenter,
          indicatorType: CarouselIndicatorType.dot,
          borderRadiusValue: context.borderRadiusNormal,
        ),
      );
    }

    // Mixed content: build items and delegate to OsmeaComponents.carousel
    final items = banners
        .map(
          (b) => OsmeaComponents.container(
            margin: EdgeInsets.symmetric(horizontal: context.spacing4),
            width: double.infinity,
            height: context.height192,
            child: _buildBannerItem(context, b),
          ),
        )
        .toList();

    return OsmeaComponents.padding(
      padding: EdgeInsets.fromLTRB(
        context.spacing16,
        0,
        context.spacing16,
        context.spacing16,
      ),
      child: OsmeaComponents.carousel(
        variant: CarouselVariant.standard,
        size: CarouselSize.large,
        height: context.height192,
        items: items,
        showIndicators: true,
        showArrows: true,
        autoPlay: CarouselAutoPlay.continuous,
        autoPlayInterval: 4.seconds,
        indicatorType: CarouselIndicatorType.dot,
        indicatorPosition: CarouselIndicatorPosition.bottomCenter,
        borderRadiusValue: context.borderRadiusNormal,
      ),
    );
  }
}
