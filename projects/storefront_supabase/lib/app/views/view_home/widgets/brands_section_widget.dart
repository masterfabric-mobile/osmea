/*
 * BrandsSectionWidget
 * -------------------
 * Brands section showing brand logos in a grid/carousel.
 * Uses state.allBrands (logoUrl from DB) when available - Woo-style; else falls back to config.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/views/view_favorites/models/view_model.dart';
import 'package:storefront_supabase/app/views/view_favorites/models/states.dart';
import 'package:storefront_supabase/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';
import 'package:storefront_supabase/utils/config_utils.dart';

/// Brands section widget
class BrandsSectionWidget extends StatelessWidget {
  final AssetConfigHelper configHelper;
  final SupabaseHomeViewModel viewModel;
  /// When provided, use these brands (logoUrl from DB) - same as Woo.
  final List<Brand>? brandsFromState;

  const BrandsSectionWidget({
    super.key,
    required this.configHelper,
    required this.viewModel,
    this.brandsFromState,
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
      return brandsList.map((b) => b as Map<String, dynamic>).toList();
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

  @override
  Widget build(BuildContext context) {
    final config = _loadBrandsConfig();
    final sectionTitle = configString(config?['title']) ?? context.resources.shopByBrand;
    final showSection = config?['enabled'] as bool? ?? true;
    final layout =
        configString(config?['layout']) ?? 'grid'; // 'grid' or 'carousel'

    if (!showSection) return const SizedBox.shrink();

    final configBrands = _getBrands();
    final useStateBrands = brandsFromState != null && brandsFromState!.isNotEmpty;
    final count = useStateBrands ? brandsFromState!.length : configBrands.length;
    if (count == 0) return const SizedBox.shrink();

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
              GestureDetector(
                onTap: () {
                  context.push('/categories/products/all');
                },
                child: OsmeaComponents.text(
                  context.resources.seeAll,
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    fontSize:
                        context.fontSizeExtraSmallMedium *
                        context.textScaleFactor,
                    fontWeight: FontWeight.w500,
                    color: OsmeaColors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        OsmeaComponents.sizedBox(height: _getTitleSpacing()),
        if (layout == 'carousel')
          SizedBox(
            height: context.height80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              itemCount: count,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(
                    right: index < count - 1 ? context.spacing16 : 0,
                  ),
                  child: useStateBrands
                      ? _buildBrandCardFromModel(context, brandsFromState![index])
                      : _buildBrandCard(context, configBrands[index]),
                );
              },
            ),
          )
        else
          Builder(
            builder: (context) {
              final isEvenCount = count % 2 == 0;
              final columns = isEvenCount ? 2 : 3;
              final totalSpacing = context.spacing16 * (columns - 1);
              final itemWidth =
                  (context.allWidth - (horizontalPadding * 2) - totalSpacing) /
                  columns;

              return OsmeaComponents.padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Wrap(
                  spacing: context.spacing16,
                  runSpacing: context.height16,
                  children: List.generate(count, (index) {
                    return SizedBox(
                      width: itemWidth,
                      child: useStateBrands
                          ? _buildBrandCardFromModel(context, brandsFromState![index])
                          : _buildBrandCard(context, configBrands[index]),
                    );
                  }),
                ),
              );
            },
          ),
      ],
    );
  }

  /// Woo-style brand card from state (Brand model with logoUrl from DB); includes favorite heart.
  Widget _buildBrandCardFromModel(BuildContext context, Brand brand) {
    final displayImageUrl = brand.logoUrl;
    final brandName = brand.name;

    return BlocBuilder<FavoritesViewModel, FavoritesState>(
      bloc: GetIt.I<FavoritesViewModel>(),
      buildWhen: (prev, curr) => curr is FavoritesLoadedState,
      builder: (context, favState) {
        final isFavorite = favState is FavoritesLoadedState &&
            favState.favoriteBrands.any((b) => b.id == brand.id);
        return Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () {
                context.push('/brands/${brand.id}');
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
                padding: EdgeInsets.all(context.spacing20),
                child: displayImageUrl != null && displayImageUrl.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(context.spacing8),
                child: OsmeaComponents.image(
                  imageUrl: displayImageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  variant: ImageVariant.normal,
                  cacheWidth: 400,
                  showLoadingIndicator: true,
                  errorWidget: OsmeaComponents.container(
                    width: double.infinity,
                    height: double.infinity,
                    color: OsmeaColors.grayMaterial[50],
                    alignment: context.center,
                    child: OsmeaComponents.text(
                      brandName,
                      textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                        fontSize:
                            context.fontSizeExtraSmall *
                            context.textScaleFactor,
                        fontWeight: FontWeight.w600,
                        color: OsmeaColors.thunder,
                      ),
                      textAlign: TextAlign.center,
                    ),
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
                    fontSize:
                        context.fontSizeExtraSmall * context.textScaleFactor,
                    fontWeight: FontWeight.w600,
                    color: OsmeaColors.thunder,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            ),
            Positioned(
              top: context.spacing8,
              right: context.spacing8,
              child: GestureDetector(
                onTap: () async {
                  final vm = GetIt.I<FavoritesViewModel>();
                  if (isFavorite) {
                    await vm.removeFavoriteBrand(brand.id);
                    if (context.mounted) {
                      context.snackbarInfo(
                        context.resources.brandRemovedFromFavorites,
                        style: SnackbarStyle.minimal,
                        position: SnackbarPosition.bottom,
                      );
                    }
                  } else {
                    final ok = await vm.addFavoriteBrand(brand.id, brandForOptimisticUpdate: brand);
                    if (context.mounted) {
                      if (ok) {
                        context.snackbarSuccess(
                          context.resources.brandAddedToFavorites,
                          style: SnackbarStyle.minimal,
                          position: SnackbarPosition.bottom,
                        );
                      } else {
                        context.showSnackbar(
                          message: context.resources.wishlistUpdateFailed,
                          type: SnackbarType.warning,
                          style: SnackbarStyle.minimal,
                          position: SnackbarPosition.bottom,
                        );
                      }
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(context.spacing4),
                  decoration: BoxDecoration(
                    color: OsmeaColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: OsmeaColors.silver),
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: isFavorite ? OsmeaColors.thunder : OsmeaColors.pewter,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Builds a single brand card
  Widget _buildBrandCard(BuildContext context, Map<String, dynamic> brand) {
    final brandName = configString(brand['name']) ?? 'Brand';
    final imageUrl = configString(brand['image_url']);
    final logoUrl = configString(brand['logo_url']);
    final brandId = brand['id']; // String or int
    final route = configString(brand['route']);
    final categoryId = configString(brand['category_id']);

    // Use logo_url if available, otherwise fall back to image_url
    final displayImageUrl = logoUrl ?? imageUrl;

    return GestureDetector(
      onTap: () {
        if (route != null) {
          context.push(route);
        } else if (categoryId != null) {
          context.push('/categories/products/$categoryId');
        } else if (brandId != null) {
          context.push('/brands/$brandId');
        } else {
          context.push('/categories/products/all');
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
        padding: EdgeInsets.all(context.spacing20),
        child: displayImageUrl != null && displayImageUrl.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(context.spacing8),
                child: OsmeaComponents.image(
                  imageUrl: displayImageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  variant: ImageVariant.normal,
                  cacheWidth: 400,
                  showLoadingIndicator: true,
                  errorWidget: OsmeaComponents.container(
                    width: double.infinity,
                    height: double.infinity,
                    color: OsmeaColors.grayMaterial[50],
                    alignment: context.center,
                    child: OsmeaComponents.text(
                      brandName,
                      textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                        fontSize:
                            context.fontSizeExtraSmall *
                            context.textScaleFactor,
                        fontWeight: FontWeight.w600,
                        color: OsmeaColors.thunder,
                      ),
                      textAlign: TextAlign.center,
                    ),
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
                    fontSize:
                        context.fontSizeExtraSmall * context.textScaleFactor,
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
