import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 🃏 **OSMEA Card Examples**
///
/// Comprehensive examples demonstrating all variants, sizes, and features
/// of the OSMEA Card component library.
///
/// This file showcases:
/// * 🎨 All card variants (elevated, outlined, filled)
/// * 📏 All size options (small, medium, large)
/// * 📝 Basic Cards - Simple content cards
/// * 🖼️ Image Cards - Cards with image content
/// * 🔘 Action Cards - Cards with interactive elements
/// * 🎯 Custom styling and theming options
/// * 🔧 Full-width and responsive layouts

class CardExample extends StatefulWidget {
  const CardExample({super.key});

  @override
  State<CardExample> createState() => _CardExampleState();
}

class _CardExampleState extends State<CardExample> {
  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'card_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('📝 Basic Cards'),
            _buildBasicCardsSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🖼️ Image Cards'),
            _buildImageCardsSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🔘 Action Cards'),
            _buildActionCardsSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🎨 Card Variants'),
            _buildVariantsSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('📏 Card Sizes'),
            _buildSizesSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🎭 Interactive'),
            _buildInteractiveSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🚀 Advanced'),
            _buildAdvancedSection(),
            OsmeaComponents.sizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return OsmeaComponents.text(
      title,
      variant: OsmeaTextVariant.headlineSmall,
      color: OsmeaColors.nordicBlue,
    );
  }

  Widget _buildSubsectionTitle(String title) {
    return OsmeaComponents.text(
      title,
      variant: OsmeaTextVariant.titleMedium,
      color: OsmeaColors.pewter,
    );
  }

  Widget _buildBasicCardsSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Simple Basic Cards'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.basicCard(
          title: 'Welcome to OSMEA',
          subtitle: 'Component Library',
          content:
              'A comprehensive Flutter component library with beautiful, accessible, and customizable components.',
          variant: ComponentAppearance.elevated,
          size: ComponentSize.medium,
          titleColor: OsmeaColors.nordicBlue,
          subtitleColor: OsmeaColors.pewter,
          spacing: 12.0,
          margin: const EdgeInsets.only(bottom: 16),
          onTap: () => _showSnackBar('Basic card tapped'),
        ),
        _buildSubsectionTitle('Card with Custom Styling'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.basicCard(
          title: 'Premium Feature',
          subtitle: 'Pro Plan',
          content:
              'Unlock advanced features with our premium plan. Get access to exclusive components and priority support.',
          variant: ComponentAppearance.outlined,
          size: ComponentSize.medium,
          borderColor: OsmeaColors.nordicBlue,
          titleColor: OsmeaColors.nordicBlue,
          subtitleColor: OsmeaColors.sunsetGlow,
          contentColor: OsmeaColors.pewter,
          spacing: 16.0,
          margin: const EdgeInsets.only(bottom: 16),
          onTap: () => _showSnackBar('Premium card tapped'),
        ),
        _buildSubsectionTitle('Card with Custom Content'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.basicCard(
          variant: ComponentAppearance.filled,
          size: ComponentSize.large,
          borderRadius: BorderRadius.circular(16),
          spacing: 20.0,
          margin: const EdgeInsets.only(bottom: 16),
          customContent: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OsmeaComponents.row(
                children: [
                  Icon(Icons.star, color: OsmeaColors.sunsetGlow, size: 32),
                  OsmeaComponents.sizedBox(width: 12),
                  OsmeaComponents.expanded(
                    child: OsmeaComponents.column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OsmeaComponents.text(
                          'Featured Component',
                          variant: OsmeaTextVariant.titleMedium,
                          color: OsmeaColors.nordicBlue,
                        ),
                        OsmeaComponents.text(
                          'Highly recommended',
                          variant: OsmeaTextVariant.labelMedium,
                          color: OsmeaColors.forestHeart,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(
                'This card shows how to use custom content with the OSMEA card component.',
                variant: OsmeaTextVariant.bodyMedium,
              ),
            ],
          ),
          onTap: () => _showSnackBar('Custom content card tapped'),
        ),
      ],
    );
  }

  Widget _buildImageCardsSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Image Card - Top Position'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.imageCard(
          title: 'Beautiful Nature',
          subtitle: 'Photography Collection',
          content:
              'Discover stunning landscape photography from around the world.',
          imageWidget: OsmeaComponents.container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: OsmeaColors.nordicBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                const Icon(Icons.landscape, color: OsmeaColors.white, size: 48),
          ),
          imageHeight: 200,
          imagePosition: ComponentPosition.top,
          imageFit: BoxFit.cover,
          imageAlignment: Alignment.center,
          variant: ComponentAppearance.elevated,
          size: ComponentSize.medium,
          titleColor: OsmeaColors.nordicBlue,
          subtitleColor: OsmeaColors.pewter,
          spacing: 16.0,
          margin: const EdgeInsets.only(bottom: 16),
          semanticLabel: 'Beautiful nature landscape image',
          onTap: () => _showSnackBar('Nature image card tapped'),
        ),
        _buildSubsectionTitle('Image Card - Left Position'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.imageCard(
          title: 'Tech Innovation',
          subtitle: 'Latest Updates',
          content:
              'Stay updated with the latest technology trends and innovations.',
          imageWidget: OsmeaComponents.container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: OsmeaColors.crystalBay,
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                const Icon(Icons.computer, color: OsmeaColors.white, size: 32),
          ),
          imageHeight: 100,
          imagePosition: ComponentPosition.left,
          imageFit: BoxFit.cover,
          imageAlignment: Alignment.center,
          variant: ComponentAppearance.outlined,
          size: ComponentSize.medium,
          borderColor: OsmeaColors.nordicBlue,
          titleColor: OsmeaColors.nordicBlue,
          subtitleColor: OsmeaColors.pewter,
          spacing: 16.0,
          margin: const EdgeInsets.only(bottom: 16),
          semanticLabel: 'Technology innovation icon',
          onTap: () => _showSnackBar('Tech image card tapped'),
        ),
        // ⭐ Premium Product Cards Section
        _buildSubsectionTitle('🌟 Premium Product Cards'),
        OsmeaComponents.sizedBox(height: 8),

        // Info about new features
        OsmeaComponents.container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: OsmeaColors.azureWave.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: OsmeaColors.azureWave.withValues(alpha: 0.3)),
          ),
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OsmeaComponents.row(
                children: [
                  Icon(Icons.new_releases,
                      color: OsmeaColors.azureWave, size: 20),
                  OsmeaComponents.sizedBox(width: 8),
                  OsmeaComponents.text(
                    'New: Text Overflow Control',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: OsmeaColors.azureWave,
                  ),
                ],
              ),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.text(
                'Image cards now support text overflow control with titleMaxLines, subtitleMaxLines, contentMaxLines, and textOverflow properties for consistent card heights.',
                fontSize: 14,
                color: OsmeaColors.slate,
              ),
            ],
          ),
        ),
        OsmeaComponents.sizedBox(height: 16),

        // 💰 Price Comparison Example with subtitle2
        _buildSubsectionTitle('💰 Price Comparison with Dual Subtitles'),
        OsmeaComponents.sizedBox(height: 12),

        // Rose Pastel Dining Set - Price comparison example
        OsmeaComponents.imageCard(
          title: 'Rose Pastel Dining Set',
          subtitle: '\$49.99', // Old price (left side)
          subtitle2: '\$33.33', // New price (right side)
          imageWidget: OsmeaComponents.container(
            width: double.infinity,
            height: context.height176,
            color: OsmeaColors.crystalBay,
            child: OsmeaComponents.center(
              child: Icon(
                Icons.dining,
                color: OsmeaColors.white,
                size: context.iconSizeLarge,
              ),
            ),
          ),
          imageHeight: context.height176,
          imagePosition: ComponentPosition.top,
          variant: ComponentAppearance.elevated,
          size: ComponentSize.medium,
          margin: EdgeInsets.only(bottom: context.spacing20),
          semanticLabel: 'Rose Pastel dining set with price comparison',
          onTap: () => _showSnackBar('Rose Pastel Set - 33% discount!'),
        ),
        // 🎯 Text Overflow Comparison Cards
        _buildSubsectionTitle('📏 Text Overflow Control'),
        OsmeaComponents.sizedBox(height: 12),

        OsmeaComponents.row(
          children: [
            // Card 1 - Without text overflow control
            OsmeaComponents.expanded(
              child: OsmeaComponents.imageCard(
                title: 'Standard Card Without Text Overflow Control Features',
                subtitle:
                    'This is a very long subtitle that might cause layout issues',
                content:
                    'This shows what happens when you have very long text content that exceeds the normal display area. Without proper text overflow control, this can cause inconsistent card heights and poor visual alignment in grid layouts.',
                imageWidget: OsmeaComponents.container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: OsmeaColors.pewter,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.warning,
                      color: OsmeaColors.white, size: 40),
                ),
                imageHeight: 120,
                imagePosition: ComponentPosition.top,
                variant: ComponentAppearance.outlined,
                size: ComponentSize.medium,
                borderColor: OsmeaColors.pewter,
                titleColor: OsmeaColors.thunder,
                subtitleColor: OsmeaColors.pewter,
                contentColor: OsmeaColors.slate,
                spacing: 12.0,
                margin: const EdgeInsets.only(right: 8, bottom: 16),
                onTap: () =>
                    _showSnackBar('Standard card tapped - No text control'),
              ),
            ),

            // Card 2 - With text overflow control (when API supports it)
            OsmeaComponents.expanded(
              child: OsmeaComponents.imageCard(
                title:
                    'Controlled Card With Text Overflow Management and Consistent Height',
                subtitle:
                    'This subtitle is also very long but will be controlled properly',
                content:
                    'This card shows how text overflow control works to maintain consistent layouts. Even with very long text content, the card maintains a predictable height and clean appearance, making it perfect for grid layouts and uniform design systems.',
                imageWidget: OsmeaComponents.container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: OsmeaColors.forestHeart,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.check_circle,
                      color: OsmeaColors.white, size: 40),
                ),
                imageHeight: 120,
                imagePosition: ComponentPosition.top,
                variant: ComponentAppearance.outlined,
                size: ComponentSize.medium,
                borderColor: OsmeaColors.forestHeart,
                titleColor: OsmeaColors.thunder,
                subtitleColor: OsmeaColors.forestHeart,
                contentColor: OsmeaColors.slate,
                spacing: 12.0,
                margin: const EdgeInsets.only(left: 8, bottom: 16),
                titleMaxLines: 2,
                subtitleMaxLines: 1,
                contentMaxLines: 3,
                textOverflow: TextOverflow.ellipsis,
                semanticLabel: 'Controlled card with text overflow management',
                onTap: () =>
                    _showSnackBar('Controlled card tapped - With text control'),
              ),
            ),
          ],
        ),

        OsmeaComponents.sizedBox(height: 20),

        // Wireless Earbuds - Premium with solid color and text overflow control
        OsmeaComponents.imageCard(
          title:
              'Wireless Earbuds Pro - Advanced Noise Cancellation Technology',
          subtitle: 'Premium Sound Quality with High-Fidelity Audio',
          content:
              '\$1,299 - Limited Time Offer with Free Shipping and 2-Year Warranty',
          imageWidget: OsmeaComponents.container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              color: OsmeaColors.nordicBlue,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: OsmeaColors.nordicBlue.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: OsmeaComponents.center(
              child: const Icon(
                Icons.headphones,
                color: OsmeaColors.white,
                size: 90,
              ),
            ),
          ),
          imageHeight: 220,
          imagePosition: ComponentPosition.top,
          imageFit: BoxFit.cover,
          imageAlignment: Alignment.center,
          showOverlay: false,
          badge: OsmeaComponents.container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: OsmeaColors.forestHeart,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: OsmeaColors.forestHeart.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: OsmeaComponents.text(
              'NEW',
              color: OsmeaColors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          badgePosition: BadgePosition.topRight,
          variant: ComponentAppearance.elevated,
          size: ComponentSize.large,
          backgroundColor: OsmeaColors.white,
          titleColor: OsmeaColors.eclipse,
          subtitleColor: OsmeaColors.slate,
          contentColor: OsmeaColors.thunder,
          spacing: 16.0,
          borderRadius: BorderRadius.circular(20),
          elevation: 8.0,
          shadowColor: OsmeaColors.nordicBlue.withValues(alpha: 0.3),
          margin: const EdgeInsets.only(bottom: 24),
          semanticLabel: 'Premium wireless earbuds product card',
          onTap: () => _showSnackBar('Premium earbuds tapped - \$1,299'),
        ),

        // Smart Watch - Health focused with solid color
        OsmeaComponents.imageCard(
          title: 'Apple Watch Series 10',
          subtitle: 'Health & Fitness Tracking',
          content: '\$2,499',
          titleMaxLines: 2,
          subtitleMaxLines: 1,
          contentMaxLines: 2,
          textOverflow: TextOverflow.ellipsis,
          imageWidget: OsmeaComponents.container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: OsmeaColors.thunder,
              borderRadius: BorderRadius.circular(12),
            ),
            child: OsmeaComponents.column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.watch,
                  color: OsmeaColors.white,
                  size: 85,
                ),
                OsmeaComponents.sizedBox(height: 16),
                OsmeaComponents.container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: OsmeaColors.sunsetGlow.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: OsmeaComponents.row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite,
                          color: OsmeaColors.sunsetGlow, size: 16),
                      OsmeaComponents.sizedBox(width: 4),
                      OsmeaComponents.text('72 BPM',
                          color: OsmeaColors.white, fontSize: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
          imageHeight: 200,
          imagePosition: ComponentPosition.top,
          imageFit: BoxFit.cover,
          imageAlignment: Alignment.center,
          showOverlay: false,
          badge: OsmeaComponents.container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: OsmeaColors.sunsetGlow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: OsmeaComponents.text(
              'HOT',
              color: OsmeaColors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          badgePosition: BadgePosition.topRight,
          variant: ComponentAppearance.elevated,
          size: ComponentSize.medium,
          backgroundColor: OsmeaColors.white,
          titleColor: OsmeaColors.thunder,
          subtitleColor: OsmeaColors.slate,
          contentColor: OsmeaColors.forestHeart,
          spacing: 12.0,
          borderRadius: BorderRadius.circular(16),
          elevation: 6.0,
          margin: const EdgeInsets.only(bottom: 20),
          semanticLabel: 'Apple Watch health tracking device',
          onTap: () => _showSnackBar('Apple Watch tapped - Health features'),
        ),

        // 📱 Mobile & Tech Section
        _buildSubsectionTitle('📱 Mobile & Technology'),
        OsmeaComponents.sizedBox(height: 16),

        // Smartphone with solid color
        OsmeaComponents.imageCard(
          title: 'iPhone 16 Pro Max',
          subtitle: 'Latest Technology • 1TB',
          content: '\$15,999',
          imageWidget: OsmeaComponents.container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: OsmeaColors.nordicBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: OsmeaComponents.column(
              children: [
                OsmeaComponents.padding(
                  padding: const EdgeInsets.all(16.0),
                  child: OsmeaComponents.row(
                    children: [
                      OsmeaComponents.text(
                        '5G',
                        textStyle: OsmeaTextStyle.labelLarge(context).copyWith(
                          color: OsmeaColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      OsmeaComponents.spacer(),
                    ],
                  ),
                ),
                OsmeaComponents.expanded(
                  child: OsmeaComponents.center(
                    child: const Icon(
                      Icons.smartphone,
                      color: OsmeaColors.white,
                      size: 80,
                    ),
                  ),
                ),
                OsmeaComponents.padding(
                  padding: const EdgeInsets.all(16.0),
                  child: OsmeaComponents.row(
                    children: [
                      OsmeaComponents.container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: OsmeaColors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: OsmeaComponents.text(
                          '1TB Storage',
                          textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                            color: OsmeaColors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      OsmeaComponents.spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          imageHeight: 200,
          imagePosition: ComponentPosition.top,
          imageFit: BoxFit.cover,
          imageAlignment: Alignment.center,
          showOverlay: false,
          badge: OsmeaComponents.container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: OsmeaColors.amberFlame,
              borderRadius: BorderRadius.circular(12),
            ),
            child: OsmeaComponents.text(
              '25% OFF',
              textStyle: OsmeaTextStyle.labelSmall(context).copyWith(
                color: OsmeaColors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          badgePosition: BadgePosition.topRight,
          variant: ComponentAppearance.elevated,
          size: ComponentSize.medium,
          backgroundColor: OsmeaColors.white,
          titleColor: OsmeaColors.thunder,
          subtitleColor: OsmeaColors.slate,
          contentColor: OsmeaColors.nordicBlue,
          spacing: 12.0,
          borderRadius: BorderRadius.circular(16),
          elevation: 4.0,
          margin: const EdgeInsets.only(bottom: 20),
          semanticLabel: 'iPhone 16 Pro Max smartphone',
          onTap: () => _showSnackBar('iPhone 16 Pro Max - 25% discount!'),
        ),

        // Gaming Section
        _buildSubsectionTitle('🎮 Gaming & Entertainment'),
        OsmeaComponents.sizedBox(height: 16),

        // Gaming Headset
        OsmeaComponents.imageCard(
          title: 'Gaming Headset Pro',
          subtitle: '7.1 Surround Sound',
          content: '\$899',
          imageWidget: OsmeaComponents.container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: OsmeaColors.eclipse,
              borderRadius: BorderRadius.circular(12),
            ),
            child: OsmeaComponents.column(
              children: [
                OsmeaComponents.padding(
                  padding: const EdgeInsets.all(20.0),
                  child: OsmeaComponents.row(
                    children: [
                      OsmeaComponents.spacer(),
                      OsmeaComponents.container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: OsmeaColors.azureWave,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  OsmeaColors.azureWave.withValues(alpha: 0.6),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                OsmeaComponents.expanded(
                  child: OsmeaComponents.center(
                    child: Icon(
                      Icons.headset_mic,
                      color: OsmeaColors.azureWave,
                      size: 75,
                    ),
                  ),
                ),
              ],
            ),
          ),
          imageHeight: 180,
          imagePosition: ComponentPosition.top,
          imageFit: BoxFit.cover,
          imageAlignment: Alignment.center,
          showOverlay: false,
          badge: OsmeaComponents.container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: OsmeaColors.azureWave,
              borderRadius: BorderRadius.circular(12),
            ),
            child: OsmeaComponents.text(
              'GAMING',
              textStyle: OsmeaTextStyle.labelSmall(context).copyWith(
                color: OsmeaColors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          badgePosition: BadgePosition.topRight,
          variant: ComponentAppearance.elevated,
          size: ComponentSize.medium,
          backgroundColor: OsmeaColors.eclipse,
          titleColor: OsmeaColors.white,
          subtitleColor: OsmeaColors.azureWave,
          contentColor: OsmeaColors.forestHeart,
          spacing: 12.0,
          borderRadius: BorderRadius.circular(16),
          elevation: 6.0,
          margin: const EdgeInsets.only(bottom: 20),
          semanticLabel: 'Gaming headset with surround sound',
          onTap: () => _showSnackBar('Gaming Headset Pro - RGB lighting!'),
        ),

        // Home & Lifestyle Section
        _buildSubsectionTitle('🏠 Home & Lifestyle'),
        OsmeaComponents.sizedBox(height: 16),

        // Smart Home Device
        OsmeaComponents.imageCard(
          title: 'Smart Home Hub',
          subtitle: 'Voice Control • WiFi 6',
          content: '\$599',
          imageWidget: OsmeaComponents.container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              color: OsmeaColors.snow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: OsmeaColors.silver,
                width: 1,
              ),
            ),
            child: OsmeaComponents.column(
              children: [
                OsmeaComponents.padding(
                  padding: const EdgeInsets.all(12.0),
                  child: OsmeaComponents.row(
                    children: [
                      OsmeaComponents.spacer(),
                      Icon(
                        Icons.wifi,
                        color: OsmeaColors.forestHeart,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                OsmeaComponents.expanded(
                  child: OsmeaComponents.center(
                    child: Icon(
                      Icons.home_outlined,
                      color: OsmeaColors.pewter,
                      size: 70,
                    ),
                  ),
                ),
                OsmeaComponents.padding(
                  padding: const EdgeInsets.all(12.0),
                  child: OsmeaComponents.row(
                    children: [
                      OsmeaComponents.container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: OsmeaColors.nordicBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.mic,
                          color: OsmeaColors.nordicBlue,
                          size: 16,
                        ),
                      ),
                      OsmeaComponents.spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          imageHeight: 160,
          imagePosition: ComponentPosition.top,
          imageFit: BoxFit.cover,
          imageAlignment: Alignment.center,
          showOverlay: false,
          badge: OsmeaComponents.container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: OsmeaColors.nordicBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: OsmeaComponents.text(
              'SMART',
              textStyle: OsmeaTextStyle.labelSmall(context).copyWith(
                color: OsmeaColors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          badgePosition: BadgePosition.topRight,
          variant: ComponentAppearance.outlined,
          size: ComponentSize.small,
          borderColor: OsmeaColors.silver,
          backgroundColor: OsmeaColors.white,
          titleColor: OsmeaColors.thunder,
          subtitleColor: OsmeaColors.slate,
          contentColor: OsmeaColors.nordicBlue,
          spacing: 10.0,
          borderRadius: BorderRadius.circular(12),
          margin: const EdgeInsets.only(bottom: 20),
          semanticLabel: 'Smart home automation hub',
          onTap: () => _showSnackBar('Smart Home Hub - Voice control ready'),
        ),
      ],
    );
  }

  Widget _buildActionCardsSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🚨 Critical Actions Section
        _buildSubsectionTitle('⚠️ Critical Actions'),
        OsmeaComponents.sizedBox(height: 16),

        // Delete Account - High risk action
        OsmeaComponents.actionCard(
          title: 'Delete Account',
          subtitle: 'This action cannot be undone',
          content:
              'Are you sure you want to permanently delete your account? All your data, purchases, and settings will be lost forever.',
          primaryAction: 'Delete Forever',
          secondaryAction: 'Keep Account',
          onPrimaryPressed: () =>
              _showSnackBar('⚠️ Account deletion confirmed'),
          onSecondaryPressed: () => _showSnackBar('Account preserved safely'),
          primaryVariant: ButtonVariant.danger,
          secondaryVariant: ButtonVariant.outlined,
          primarySize: ButtonSize.medium,
          secondarySize: ButtonSize.medium,
          primaryIcon: const Icon(Icons.delete_forever, size: 18),
          secondaryIcon: const Icon(Icons.shield, size: 18),
          buttonLayout: ComponentOrientation.horizontal,
          actionSpacing: 16.0,
          contentSpacing: 20.0,
          variant: ComponentAppearance.outlined,
          size: ComponentSize.medium,
          borderColor: OsmeaColors.sunsetGlow.withValues(alpha: 0.3),
          backgroundColor: OsmeaColors.sunsetGlow.withValues(alpha: 0.5),
          titleColor: OsmeaColors.sunsetGlow,
          subtitleColor: OsmeaColors.amberFlame,
          contentColor: OsmeaColors.amberFlame,
          margin: const EdgeInsets.only(bottom: 20),
        ),

        // 💎 Premium & Subscription Section
        _buildSubsectionTitle('💎 Premium Services'),
        OsmeaComponents.sizedBox(height: 16),

        // Premium Subscription with benefits
        OsmeaComponents.actionCard(
          title: 'Upgrade to OSMEA Pro',
          subtitle: '\$29.99/month • First 7 days free',
          content:
              '✨ Premium components\n🚀 Priority support\n📊 Advanced analytics\n🎨 Custom themes\n📱 Multi-platform access',
          primaryAction: 'Get Started',
          secondaryAction: 'Learn More',
          onPrimaryPressed: () => _showSnackBar('🎉 Started!'),
          onSecondaryPressed: () => _showSnackBar('More info requested'),
          primaryVariant: ButtonVariant.primary,
          secondaryVariant: ButtonVariant.ghost,
          primarySize: ButtonSize.large,
          secondarySize: ButtonSize.medium,
          primaryIcon: const Icon(Icons.diamond, size: 20),
          secondaryIcon: const Icon(Icons.info_outline, size: 18),
          buttonLayout: ComponentOrientation.horizontal,
          actionSpacing: 32.0,
          contentSpacing: 24.0,
          variant: ComponentAppearance.elevated,
          size: ComponentSize.large,
          elevation: 8.0,
          backgroundColor: OsmeaColors.snow,
          borderRadius: BorderRadius.circular(16),
          titleColor: OsmeaColors.nordicBlue,
          subtitleColor: OsmeaColors.forestHeart,
          contentColor: OsmeaColors.slate,
          margin: const EdgeInsets.only(bottom: 20),
        ),

        // 🛒 E-commerce Actions Section
        _buildSubsectionTitle('🛒 Shopping & Commerce'),
        OsmeaComponents.sizedBox(height: 16),

        // Add to Cart action
        OsmeaComponents.actionCard(
          title: 'Add to Shopping Cart',
          subtitle: 'iPhone 16 Pro Max • 1TB',
          content:
              'Price: \$15,999\nStock: 3 items left\nFree shipping available',
          primaryAction: 'Add to Cart',
          secondaryAction: 'Add to Wishlist',
          onPrimaryPressed: () => _showSnackBar('🛒 Added to cart - \$15,999'),
          onSecondaryPressed: () => _showSnackBar('💖 Added to wishlist'),
          primaryVariant: ButtonVariant.primary,
          secondaryVariant: ButtonVariant.outlined,
          primarySize: ButtonSize.medium,
          secondarySize: ButtonSize.medium,
          primaryIcon: const Icon(Icons.add_shopping_cart, size: 18),
          secondaryIcon: const Icon(Icons.favorite_outline, size: 18),
          buttonLayout: ComponentOrientation.horizontal,
          actionSpacing: 28.0,
          contentSpacing: 16.0,
          variant: ComponentAppearance.filled,
          size: ComponentSize.medium,
          backgroundColor: OsmeaColors.forestHeart.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          titleColor: OsmeaColors.thunder,
          subtitleColor: OsmeaColors.slate,
          contentColor: OsmeaColors.pewter,
          margin: const EdgeInsets.only(bottom: 20),
        ),

        // 📋 Task Management Section
        _buildSubsectionTitle('📋 Task & Project Management'),
        OsmeaComponents.sizedBox(height: 16),

        // Save Changes - Vertical layout
        OsmeaComponents.actionCard(
          title: 'Save Project Changes',
          subtitle: '12 files modified • Last saved 5 minutes ago',
          content:
              'You have unsaved changes in your project. Save now to prevent data loss.',
          primaryAction: 'Save & Continue',
          secondaryAction: 'Discard Changes',
          onPrimaryPressed: () =>
              _showSnackBar('💾 Changes saved successfully'),
          onSecondaryPressed: () => _showSnackBar('🗑️ Changes discarded'),
          primaryVariant: ButtonVariant.primary,
          secondaryVariant: ButtonVariant.outlined,
          primarySize: ButtonSize.large,
          secondarySize: ButtonSize.medium,
          primaryIcon: const Icon(Icons.save, size: 20),
          secondaryIcon: const Icon(Icons.delete_outline, size: 18),
          buttonLayout: ComponentOrientation.vertical,
          actionSpacing: 20.0,
          contentSpacing: 20.0,
          variant: ComponentAppearance.elevated,
          size: ComponentSize.large,
          elevation: 4.0,
          backgroundColor: OsmeaColors.white,
          titleColor: OsmeaColors.thunder,
          subtitleColor: OsmeaColors.slate,
          contentColor: OsmeaColors.pewter,
          margin: const EdgeInsets.only(bottom: 20),
        ),

        // 🔐 Security Actions Section
        _buildSubsectionTitle('🔐 Security & Privacy'),
        OsmeaComponents.sizedBox(height: 16),

        // Two-factor authentication
        OsmeaComponents.actionCard(
          title: 'Enable Two-Factor Authentication',
          subtitle: 'Recommended for account security',
          content:
              'Protect your account with an additional layer of security. You\'ll need your phone to sign in.',
          primaryAction: 'Enable 2FA',
          secondaryAction: 'Skip for Now',
          onPrimaryPressed: () => _showSnackBar('🔐 2FA setup started'),
          onSecondaryPressed: () => _showSnackBar('⏭️ 2FA setup skipped'),
          primaryVariant: ButtonVariant.primary,
          secondaryVariant: ButtonVariant.ghost,
          primarySize: ButtonSize.medium,
          secondarySize: ButtonSize.medium,
          primaryIcon: const Icon(Icons.security, size: 18),
          secondaryIcon: const Icon(Icons.skip_next, size: 18),
          buttonLayout: ComponentOrientation.horizontal,
          actionSpacing: 32.0,
          contentSpacing: 18.0,
          variant: ComponentAppearance.outlined,
          size: ComponentSize.medium,
          borderColor: OsmeaColors.nordicBlue,
          backgroundColor: OsmeaColors.nordicBlue.withValues(alpha: 0.05),
          titleColor: OsmeaColors.nordicBlue,
          subtitleColor: OsmeaColors.nordicBlue,
          contentColor: OsmeaColors.thunder,
          margin: const EdgeInsets.only(bottom: 20),
        ),

        // 📱 Communication Section
        _buildSubsectionTitle('📱 Communication & Social'),
        OsmeaComponents.sizedBox(height: 16),

        // Share content
        OsmeaComponents.actionCard(
          title: 'Share Your Creation',
          subtitle: 'Let others see your amazing work',
          content:
              'Share your project with the community and get feedback from other developers.',
          primaryAction: 'Share Now',
          secondaryAction: 'Copy Link',
          onPrimaryPressed: () => _showSnackBar('📤 Shared successfully!'),
          onSecondaryPressed: () =>
              _showSnackBar('🔗 Link copied to clipboard'),
          primaryVariant: ButtonVariant.primary,
          secondaryVariant: ButtonVariant.outlined,
          primarySize: ButtonSize.medium,
          secondarySize: ButtonSize.medium,
          primaryIcon: const Icon(Icons.share, size: 18),
          secondaryIcon: const Icon(Icons.link, size: 18),
          buttonLayout: ComponentOrientation.horizontal,
          actionSpacing: 30.0,
          contentSpacing: 16.0,
          variant: ComponentAppearance.filled,
          size: ComponentSize.medium,
          backgroundColor: OsmeaColors.nordicBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          titleColor: OsmeaColors.deepSea,
          subtitleColor: OsmeaColors.nordicBlue,
          contentColor: OsmeaColors.slate,
          margin: const EdgeInsets.only(bottom: 20),
        ),
      ],
    );
  }

  Widget _buildVariantsSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Different Appearance Variants'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            OsmeaComponents.basicCard(
              title: 'Elevated Card',
              content: 'This card has shadow elevation for depth.',
              variant: ComponentAppearance.elevated,
              size: ComponentSize.medium,
              width: 180,
              elevation: 8.0,
              shadowColor: OsmeaColors.nordicBlue.withValues(alpha: 0.3),
              margin: const EdgeInsets.all(8),
              onTap: () => _showSnackBar('Elevated card tapped'),
            ),
            OsmeaComponents.basicCard(
              title: 'Outlined Card',
              content: 'This card has a border outline.',
              variant: ComponentAppearance.outlined,
              size: ComponentSize.medium,
              width: 180,
              borderColor: OsmeaColors.nordicBlue,
              margin: const EdgeInsets.all(8),
              onTap: () => _showSnackBar('Outlined card tapped'),
            ),
            OsmeaComponents.basicCard(
              title: 'Filled Card',
              content: 'This card has a filled background.',
              variant: ComponentAppearance.filled,
              size: ComponentSize.medium,
              width: 180,
              backgroundColor: OsmeaColors.crystalBay.withValues(alpha: 0.1),
              margin: const EdgeInsets.all(8),
              onTap: () => _showSnackBar('Filled card tapped'),
            ),
            OsmeaComponents.basicCard(
              title: 'Ghost Card',
              content: 'This card has minimal styling.',
              variant: ComponentAppearance.ghost,
              size: ComponentSize.medium,
              width: 180,
              margin: const EdgeInsets.all(8),
              onTap: () => _showSnackBar('Ghost card tapped'),
            ),
            OsmeaComponents.basicCard(
              title: 'Flat Card',
              content: 'This card has no elevation.',
              variant: ComponentAppearance.flat,
              size: ComponentSize.medium,
              width: 180,
              backgroundColor: OsmeaColors.ash.withValues(alpha: 0.1),
              margin: const EdgeInsets.all(8),
              onTap: () => _showSnackBar('Flat card tapped'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSizesSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Different Size Variants'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.basicCard(
          title: 'Extra Small Card',
          content: 'Minimal space, compact design.',
          variant: ComponentAppearance.elevated,
          size: ComponentSize.extraSmall,
          titleColor: OsmeaColors.nordicBlue,
          margin: const EdgeInsets.only(bottom: 16),
          onTap: () => _showSnackBar('Extra small card tapped'),
        ),
        OsmeaComponents.basicCard(
          title: 'Small Card',
          content: 'Compact card with minimal content.',
          variant: ComponentAppearance.elevated,
          size: ComponentSize.small,
          titleColor: OsmeaColors.nordicBlue,
          margin: const EdgeInsets.only(bottom: 16),
          onTap: () => _showSnackBar('Small card tapped'),
        ),
        OsmeaComponents.basicCard(
          title: 'Medium Card',
          subtitle: 'Standard Size',
          content: 'This is a medium-sized card with standard proportions.',
          variant: ComponentAppearance.elevated,
          size: ComponentSize.medium,
          titleColor: OsmeaColors.nordicBlue,
          subtitleColor: OsmeaColors.pewter,
          spacing: 16.0,
          margin: const EdgeInsets.only(bottom: 16),
          onTap: () => _showSnackBar('Medium card tapped'),
        ),
        OsmeaComponents.basicCard(
          title: 'Large Card',
          subtitle: 'Extra Space',
          content:
              'This is a large card with plenty of space for content. It\'s perfect for detailed information and rich content.',
          variant: ComponentAppearance.elevated,
          size: ComponentSize.large,
          titleColor: OsmeaColors.nordicBlue,
          subtitleColor: OsmeaColors.pewter,
          spacing: 20.0,
          margin: const EdgeInsets.only(bottom: 16),
          onTap: () => _showSnackBar('Large card tapped'),
        ),
        OsmeaComponents.basicCard(
          title: 'Extra Large Card',
          subtitle: 'Maximum Space',
          content:
              'This is an extra large card with maximum spacing and content area. Perfect for rich content displays and detailed information layouts.',
          variant: ComponentAppearance.elevated,
          size: ComponentSize.extraLarge,
          titleColor: OsmeaColors.nordicBlue,
          subtitleColor: OsmeaColors.pewter,
          spacing: 24.0,
          margin: const EdgeInsets.only(bottom: 16),
          onTap: () => _showSnackBar('Extra large card tapped'),
        ),
      ],
    );
  }

  Widget _buildInteractiveSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Clickable Cards'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.basicCard(
          title: 'Interactive Card',
          subtitle: 'Tap to interact',
          content: 'This card responds to tap events with visual feedback.',
          variant: ComponentAppearance.outlined,
          size: ComponentSize.medium,
          borderColor: OsmeaColors.crystalBay,
          titleColor: OsmeaColors.nordicBlue,
          subtitleColor: OsmeaColors.pewter,
          spacing: 16.0,
          margin: const EdgeInsets.only(bottom: 16),
          onTap: () => _showSnackBar('Interactive card tapped'),
        ),
        _buildSubsectionTitle('Cards with Custom Actions'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.basicCard(
          variant: ComponentAppearance.filled,
          size: ComponentSize.medium,
          backgroundColor: OsmeaColors.ash.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          spacing: 16.0,
          margin: const EdgeInsets.only(bottom: 16),
          customContent: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OsmeaComponents.text(
                'Notification Settings',
                variant: OsmeaTextVariant.titleMedium,
                color: OsmeaColors.nordicBlue,
              ),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.text(
                'Manage your notification preferences.',
                variant: OsmeaTextVariant.bodyMedium,
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OsmeaComponents.text('Push Notifications'),
                  OsmeaComponents.switchButton(
                    value: true,
                    onChanged: (value) => _showSnackBar(
                        'Push notifications ${value ? 'enabled' : 'disabled'}'),
                    variant: SwitchVariant.simple,
                    size: SwitchSize.small,
                  ),
                ],
              ),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OsmeaComponents.text('Email Notifications'),
                  OsmeaComponents.switchButton(
                    value: false,
                    onChanged: (value) => _showSnackBar(
                        'Email notifications ${value ? 'enabled' : 'disabled'}'),
                    variant: SwitchVariant.simple,
                    size: SwitchSize.small,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Card Grid Layout'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            OsmeaComponents.sizedBox(
              width: 150,
              height: 125,
              child: OsmeaComponents.basicCard(
                title: 'Stats',
                content: '1,234 Users',
                variant: ComponentAppearance.elevated,
                size: ComponentSize.small,
                titleColor: OsmeaColors.nordicBlue,
                contentColor: OsmeaColors.forestHeart,
                onTap: () => _showSnackBar('Stats card tapped'),
              ),
            ),
            OsmeaComponents.sizedBox(
              width: 150,
              height: 125,
              child: OsmeaComponents.basicCard(
                title: 'Revenue',
                content: '\$12,345',
                variant: ComponentAppearance.elevated,
                size: ComponentSize.small,
                titleColor: OsmeaColors.nordicBlue,
                contentColor: OsmeaColors.sunsetGlow,
                onTap: () => _showSnackBar('Revenue card tapped'),
              ),
            ),
            OsmeaComponents.sizedBox(
              width: 150,
              height: 125,
              child: OsmeaComponents.basicCard(
                title: 'Growth',
                content: '+23.4%',
                variant: ComponentAppearance.elevated,
                size: ComponentSize.small,
                titleColor: OsmeaColors.nordicBlue,
                contentColor: OsmeaColors.forestHeart,
                onTap: () => _showSnackBar('Growth card tapped'),
              ),
            ),
            OsmeaComponents.sizedBox(
              width: 150,
              height: 125,
              child: OsmeaComponents.basicCard(
                title: 'Orders',
                content: '567 Orders',
                variant: ComponentAppearance.elevated,
                size: ComponentSize.small,
                titleColor: OsmeaColors.nordicBlue,
                contentColor: OsmeaColors.crystalBay,
                onTap: () => _showSnackBar('Orders card tapped'),
              ),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildSubsectionTitle('Profile Card'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.basicCard(
          variant: ComponentAppearance.elevated,
          size: ComponentSize.large,
          elevation: 4.0,
          borderRadius: BorderRadius.circular(16),
          spacing: 20.0,
          margin: const EdgeInsets.only(bottom: 16),
          customContent: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OsmeaComponents.row(
                children: [
                  OsmeaComponents.container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: OsmeaColors.nordicBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person,
                        color: OsmeaColors.white, size: 32),
                  ),
                  OsmeaComponents.sizedBox(width: 16),
                  OsmeaComponents.expanded(
                    child: OsmeaComponents.column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OsmeaComponents.text(
                          'John Doe',
                          variant: OsmeaTextVariant.titleLarge,
                          color: OsmeaColors.nordicBlue,
                        ),
                        OsmeaComponents.text(
                          'Senior Developer',
                          variant: OsmeaTextVariant.bodyMedium,
                          color: OsmeaColors.pewter,
                        ),
                        OsmeaComponents.text(
                          'San Francisco, CA',
                          variant: OsmeaTextVariant.labelMedium,
                          color: OsmeaColors.steel,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.container(
                height: 1,
                color: OsmeaColors.silver,
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OsmeaComponents.column(
                    children: [
                      OsmeaComponents.text(
                        '156',
                        variant: OsmeaTextVariant.titleMedium,
                        color: OsmeaColors.nordicBlue,
                      ),
                      OsmeaComponents.text(
                        'Projects',
                        variant: OsmeaTextVariant.labelMedium,
                        color: OsmeaColors.pewter,
                      ),
                    ],
                  ),
                  OsmeaComponents.column(
                    children: [
                      OsmeaComponents.text(
                        '89',
                        variant: OsmeaTextVariant.titleMedium,
                        color: OsmeaColors.forestHeart,
                      ),
                      OsmeaComponents.text(
                        'Completed',
                        variant: OsmeaTextVariant.labelMedium,
                        color: OsmeaColors.pewter,
                      ),
                    ],
                  ),
                  OsmeaComponents.column(
                    children: [
                      OsmeaComponents.text(
                        '4.9',
                        variant: OsmeaTextVariant.titleMedium,
                        color: OsmeaColors.sunsetGlow,
                      ),
                      OsmeaComponents.text(
                        'Rating',
                        variant: OsmeaTextVariant.labelMedium,
                        color: OsmeaColors.pewter,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          onTap: () => _showSnackBar('Profile card tapped'),
        ),
      ],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: OsmeaComponents.text(message),
        backgroundColor: OsmeaColors.nordicBlue,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
