/*
 * CampaignCardWidget
 * ------------------
 * Campaign card carousel widget for home view.
 * Displays campaign cards in a horizontal scrollable carousel.
 * Configured via app_config.json with image, title, and navigation options.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:storefront_supabase/utils/config_utils.dart';

/// Campaign card item model from config
class CampaignCardItem {
  final String imageUrl;
  final String? title;
  final String? subtitle;
  final String? route;
  final String? categoryId; // Supabase uses String
  final String? productId; // Supabase uses String

  CampaignCardItem({
    required this.imageUrl,
    this.title,
    this.subtitle,
    this.route,
    this.categoryId,
    this.productId,
  });

  factory CampaignCardItem.fromConfig(Map<String, dynamic> config) {
    return CampaignCardItem(
      imageUrl: configString(config['imageUrl']) ?? '',
      title: configString(config['title']),
      subtitle: configString(config['subtitle']),
      route: configString(config['route']),
      categoryId: configString(config['category_id']),
      productId: configString(config['product_id']),
    );
  }
}

/// Campaign card carousel widget
class CampaignCardWidget extends StatelessWidget {
  final AssetConfigHelper configHelper;

  const CampaignCardWidget({super.key, required this.configHelper});

  /// Loads campaign cards configuration
  Map<String, dynamic>? _loadCampaignConfig() {
    try {
      return configHelper.getObject('home_view.campaign_cards');
    } catch (e) {
      debugPrint('⚠️ Failed to load campaign_cards config: $e');
      return null;
    }
  }

  List<CampaignCardItem> _loadCampaignCards() {
    try {
      final config = _loadCampaignConfig();
      if (config == null) return [];

      final List<dynamic>? cardsList = config['items'] as List<dynamic>?;
      if (cardsList == null || cardsList.isEmpty) return [];

      return cardsList
          .map(
            (item) => CampaignCardItem.fromConfig(item as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      debugPrint('⚠️ Failed to load campaign cards: $e');
      return [];
    }
  }

  /// Gets horizontal padding from config
  double _getHorizontalPadding() {
    try {
      final config = _loadCampaignConfig();
      final paddingConfig = config?['padding'] as Map<String, dynamic>?;
      if (paddingConfig != null) {
        final horizontal = (paddingConfig['horizontal'] as num?)?.toDouble();
        if (horizontal != null && horizontal > 0) {
          return horizontal;
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load horizontal padding: $e');
    }
    // Default from component_spacing
    return configHelper.getDouble(
      'home_view.component_spacing.horizontal',
      20.0,
    );
  }

  /// Gets title to content spacing from config
  double _getTitleSpacing() {
    return configHelper.getDouble(
      'home_view.component_spacing.title_to_content',
      16.0,
    );
  }

  /// Handles campaign card tap navigation
  void _handleCardTap(BuildContext context, CampaignCardItem card) {
    // Navigate based on configuration
    if (card.route != null && card.route!.isNotEmpty) {
      // Direct route navigation
      context.push(card.route!);
    } else if (card.categoryId != null) {
      // Navigate to category products page
      context.push('/categories/products/${card.categoryId}');
    } else if (card.productId != null) {
      // Navigate to product detail page
      context.push('/product-detail/${card.productId}');
    }
  }

  Widget _buildCampaignCard(BuildContext context, CampaignCardItem card) {
    final cardHeight = configHelper.getDouble(
      'home_view.campaign_cards.card_height',
      160.0,
    );
    final cardWidth = configHelper.getDouble(
      'home_view.campaign_cards.card_width',
      280.0,
    );
    final borderRadius = configHelper.getDouble(
      'home_view.campaign_cards.border_radius',
      12.0,
    );

    return GestureDetector(
      onTap: () => _handleCardTap(context, card),
      child: OsmeaComponents.container(
        margin: EdgeInsets.only(right: context.spacing12),
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: OsmeaColors.thunder.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image - fills entire card
            OsmeaComponents.image(
              imageUrl: card.imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              variant: ImageVariant.normal,
              borderRadius: BorderRadius.zero,
            ),
            // Gradient overlay for text readability (optional)
            if (card.title != null || card.subtitle != null)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        OsmeaColors.thunder.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
            // Text content overlay
            if (card.title != null || card.subtitle != null)
              Positioned.fill(
                child: OsmeaComponents.padding(
                  padding: context.paddingNormal,
                  child: OsmeaComponents.column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (card.title != null)
                        OsmeaComponents.text(
                          card.title!,
                          textStyle: OsmeaTextStyle.titleMedium(context)
                              .copyWith(
                                fontWeight: FontWeight.w700,
                                color: OsmeaColors.white,
                                shadows: [
                                  Shadow(
                                    color: OsmeaColors.thunder,
                                    blurRadius: context.blurRadius2,
                                  ),
                                ],
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (card.title != null && card.subtitle != null)
                        OsmeaComponents.sizedBox(height: context.spacing4),
                      if (card.subtitle != null)
                        OsmeaComponents.text(
                          card.subtitle!,
                          textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                            color: OsmeaColors.white,
                            shadows: [
                              Shadow(
                                color: OsmeaColors.thunder,
                                blurRadius: context.blurRadius2,
                              ),
                            ],
                          ),
                          maxLines: 1,
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
    final config = _loadCampaignConfig();
    final showCampaigns = config?['enabled'] as bool? ?? true;

    if (!showCampaigns) return const SizedBox.shrink();

    final campaignCards = _loadCampaignCards();
    if (campaignCards.isEmpty) return const SizedBox.shrink();

    final sectionTitle = configString(config?['title']) ?? 'Campaigns';
    final horizontalPadding = _getHorizontalPadding();

    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        OsmeaComponents.padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: OsmeaComponents.text(
            sectionTitle,
            textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
              fontSize: context.fontSizeNormal * context.textScaleFactor,
              fontWeight: FontWeight.w600,
              color: OsmeaColors.thunder,
            ),
          ),
        ),
        OsmeaComponents.sizedBox(height: _getTitleSpacing()),
        // Horizontal scrollable campaign cards
        OsmeaComponents.singleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: OsmeaComponents.row(
            children: campaignCards
                .map((card) => _buildCampaignCard(context, card))
                .toList(),
          ),
        ),
      ],
    );
  }
}
