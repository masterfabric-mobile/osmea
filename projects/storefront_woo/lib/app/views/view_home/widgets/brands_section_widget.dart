/*
 * BrandsSectionWidget
 * -------------------
 * Brands section showing brand logos in a grid/carousel.
 * Loads from app config.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';

/// Brands section widget
class BrandsSectionWidget extends StatelessWidget {
  final AssetConfigHelper configHelper;
  final HomeViewModel viewModel;

  const BrandsSectionWidget({
    super.key,
    required this.configHelper,
    required this.viewModel,
  });

  /// Loads brands section configuration
  Map<String, dynamic>? _loadBrandsConfig() {
    try {
      return configHelper.getObject('home_view.brands');
    } catch (e) {
      debugPrint('Failed to load brands config: $e');
      return null;
    }
  }

  /// Gets brands list from config
  List<Map<String, dynamic>> _getBrands() {
    final config = _loadBrandsConfig();
    final brandsList = config?['brands'] as List<dynamic>?;
    
    if (brandsList != null && brandsList.isNotEmpty) {
      return brandsList
          .map((b) => b as Map<String, dynamic>)
          .toList();
    }

    // Return empty list if no brands configured
    return [];
  }

  /// Gets horizontal padding from config
  double _getHorizontalPadding() {
    try {
      final config = _loadBrandsConfig();
      final paddingConfig = config?['padding'] as Map<String, dynamic>?;
      if (paddingConfig != null) {
        final horizontal = (paddingConfig['horizontal'] as num?)?.toDouble();
        if (horizontal != null && horizontal > 0) {
          return horizontal;
        }
      }
    } catch (e) {
      debugPrint('Failed to load horizontal padding: $e');
    }
    return configHelper.getDouble('home_view.component_spacing.horizontal', 20.0);
  }

  /// Gets title to content spacing from config
  double _getTitleSpacing() {
    return configHelper.getDouble('home_view.component_spacing.title_to_content', 16.0);
  }

  @override
  Widget build(BuildContext context) {
    final config = _loadBrandsConfig();
    final sectionTitle = config?['title'] as String? ?? 'Shop by Brand';
    final showSection = config?['enabled'] as bool? ?? true;
    final layout = config?['layout'] as String? ?? 'grid'; // 'grid' or 'carousel'

    if (!showSection) return const SizedBox.shrink();

    final brands = _getBrands();
    if (brands.isEmpty) return const SizedBox.shrink();

    final horizontalPadding = _getHorizontalPadding();

    return OsmeaComponents.column(
      crossAxisAlignment: context.crossStart,
      children: [
        // Section header
        OsmeaComponents.padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: OsmeaComponents.row(
            mainAxisAlignment: context.spaceBetween,
            crossAxisAlignment: context.crossCenter,
            children: [
              OsmeaComponents.text(
                sectionTitle,
                textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                  fontSize: context.fontSizeNormal * context.textScaleFactor,
                  fontWeight: FontWeight.w600,
                  height: context.lineHeightTight,
                  letterSpacing: -0.2,
                  color: OsmeaColors.thunder,
                ),
              ),
              // See all button
              GestureDetector(
                onTap: () {
                  context.push('/products');
                },
                child: OsmeaComponents.text(
                  'See all',
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    fontSize: context.fontSizeExtraSmallMedium * context.textScaleFactor,
                    fontWeight: FontWeight.w500,
                    color: OsmeaColors.nordicBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
        OsmeaComponents.sizedBox(height: _getTitleSpacing()),
        // Brands grid or carousel
        if (layout == 'carousel')
          SizedBox(
            height: context.height80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              itemCount: brands.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(
                    right: index < brands.length - 1 ? context.spacing16 : 0,
                  ),
                  child: _buildBrandCard(context, brands[index]),
                );
              },
            ),
          )
        else
          OsmeaComponents.padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Wrap(
              spacing: context.spacing16,
              runSpacing: context.height16,
              children: brands.map((brand) {
                return SizedBox(
                  width: (context.allWidth - (horizontalPadding * 2) - (context.spacing16 * 2)) / 3,
                  child: _buildBrandCard(context, brand),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  /// Builds a single brand card
  Widget _buildBrandCard(
    BuildContext context,
    Map<String, dynamic> brand,
  ) {
    final brandName = brand['name'] as String? ?? 'Brand';
    final imageUrl = brand['image_url'] as String?;
    final logoUrl = brand['logo_url'] as String?;
    final brandId = brand['id'] as int?;
    final route = brand['route'] as String?;
    final categoryId = brand['category_id'] as int?;

    // Use logo_url if available, otherwise fall back to image_url
    final displayImageUrl = logoUrl ?? imageUrl;

    return GestureDetector(
      onTap: () {
        if (route != null) {
          context.push(route);
        } else if (categoryId != null) {
          context.push('/products?category_id=$categoryId');
        } else if (brandId != null) {
          context.push('/products?brand=$brandId');
        } else {
          context.push('/products');
        }
      },
      child: Container(
        height: context.height80,
        decoration: BoxDecoration(
          color: OsmeaColors.white,
          borderRadius: BorderRadius.circular(context.spacing12),
          border: Border.all(
            color: OsmeaColors.silver,
            width: context.borderWidth,
          ),
        ),
        padding: EdgeInsets.all(context.spacing12),
        child: displayImageUrl != null && displayImageUrl.isNotEmpty
            ? OsmeaComponents.image(
                imageUrl: displayImageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
                variant: ImageVariant.normal,
                cacheWidth: 200,
                showLoadingIndicator: true,
                errorWidget: OsmeaComponents.container(
                  width: double.infinity,
                  height: double.infinity,
                  color: OsmeaColors.grayMaterial[50],
                  alignment: context.center,
                  child: OsmeaComponents.text(
                    brandName,
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      fontSize: context.fontSizeExtraSmall * context.textScaleFactor,
                      fontWeight: FontWeight.w600,
                      color: OsmeaColors.thunder,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : OsmeaComponents.container(
                width: double.infinity,
                height: double.infinity,
                alignment: context.center,
                child: OsmeaComponents.text(
                  brandName,
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    fontSize: context.fontSizeExtraSmall * context.textScaleFactor,
                    fontWeight: FontWeight.w600,
                    color: OsmeaColors.thunder,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
      ),
    );
  }
}

