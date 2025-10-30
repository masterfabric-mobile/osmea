/*
 * BannerCarouselWidget
 * --------------------
 * Banner carousel widget that loads from app config.
 * Shows image if URL provided, otherwise shows text content.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:osmea_components/osmea_components.dart';

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
    // If image URL provided, show image
    if (banner.imageUrl != null && banner.imageUrl!.isNotEmpty) {
      return GestureDetector(
        onTap: banner.onTap,
        child: Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              banner.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildTextBanner(context, banner);
              },
            ),
          ),
        ),
      );
    }

    // Otherwise, show text banner
    return _buildTextBanner(context, banner);
  }

  Widget _buildTextBanner(BuildContext context, BannerItem banner) {
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        color: OsmeaColors.nordicBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: OsmeaColors.nordicBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (banner.title != null && banner.title!.isNotEmpty)
            OsmeaComponents.text(
              banner.title!,
              textStyle: OsmeaTextStyle.headlineSmall(context).copyWith(
                fontWeight: FontWeight.w700,
                color: OsmeaColors.thunder,
              ),
            ),
          // subtitle intentionally omitted per design
          if (banner.text != null && banner.text!.isNotEmpty) ...[
            OsmeaComponents.sizedBox(height: 12),
            OsmeaComponents.text(
              banner.text!,
              textStyle: OsmeaTextStyle.bodyMedium(
                context,
              ).copyWith(color: OsmeaColors.thunder),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
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
