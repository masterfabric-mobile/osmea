/*
 * RecommendedSectionWidget
 * ------------------------
 * "Recommended for you" product carousel section.
 * Loads from app config.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:get_it/get_it.dart';
import 'package:storefront_supabase/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_supabase/app/views/view_favorites/models/favorites_view_model.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/widgets/product_card_widget.dart';
import 'package:storefront_supabase/utils/config_utils.dart';
import 'package:storefront_supabase/app/views/view_favorites/models/module/states.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Recommended section widget
class RecommendedSectionWidget extends StatelessWidget {
  final AssetConfigHelper configHelper;
  final List<Product> allProducts;
  final SupabaseHomeViewModel viewModel;

  const RecommendedSectionWidget({
    super.key,
    required this.configHelper,
    required this.allProducts,
    required this.viewModel,
  });

  /// Loads recommended section configuration
  Map<String, dynamic>? _loadRecommendedConfig() {
    try {
      return configHelper.getObject('home_view.recommended');
    } catch (e) {
      debugPrint('⚠️ Failed to load recommended config: $e');
      return null;
    }
  }

  /// Filters products based on recommended config
  List<Product> _getRecommendedProducts() {
    final config = _loadRecommendedConfig();
    if (config == null) {
      return allProducts.take(4).toList();
    }

    final productIds = config['product_ids'] as List<dynamic>?;
    if (productIds != null && productIds.isNotEmpty) {
      final ids = productIds.map((e) => e.toString()).toSet();
      return allProducts.where((p) => ids.contains(p.id)).toList();
    }

    final limit = config['limit'] as int? ?? 4;
    return allProducts.take(limit).toList();
  }

  /// Gets horizontal padding from config
  double _getHorizontalPadding() {
    try {
      final config = _loadRecommendedConfig();
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

  /// Get color from config
  Color _getColorFromConfig(String key, Color fallback) {
    try {
      final colorString = configHelper.getString('home_view.recommended.$key');
      if (colorString.isNotEmpty && colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load recommended color $key: $e');
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    final config = _loadRecommendedConfig();
    final sectionTitle =
        configString(config?['title']) ?? context.resources.recommendedForYou;
    final showSection = config?['enabled'] as bool? ?? true;

    if (!showSection) return const SizedBox.shrink();

    final recommendedProducts = _getRecommendedProducts();
    if (recommendedProducts.isEmpty) return const SizedBox.shrink();

    final horizontalPadding = _getHorizontalPadding();

    return OsmeaComponents.column(
      crossAxisAlignment: context.crossStart,
      children: [
        // Section header with "See all" button
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
                  color: _getColorFromConfig('titleColor', OsmeaColors.black),
                ),
              ),
              // See all button
              GestureDetector(
                onTap: () {
                  context.push('/categories/products/all'); // Adjust route
                },
                child: OsmeaComponents.text(
                  context.resources.seeAll,
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    fontSize:
                        context.fontSizeExtraSmallMedium *
                        context.textScaleFactor,
                    fontWeight: FontWeight.w500,
                    color: _getColorFromConfig(
                      'seeAllColor',
                      OsmeaColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        OsmeaComponents.sizedBox(height: _getTitleSpacing()),
        // Product grid - 2 columns
        OsmeaComponents.padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Wrap(
            spacing: context.spacing16,
            runSpacing: context.height16,
            children: recommendedProducts.asMap().entries.map((entry) {
              final index = entry.key;
              final product = entry.value;
              return RepaintBoundary(
                child: StaggeredAnimation(
                  index: index,
                  child: SizedBox(
                    width:
                        (context.allWidth -
                            (horizontalPadding * 2) -
                            context.spacing16) /
                        2,
                    child: BlocBuilder<FavoritesViewModel, FavoritesState>(
                      bloc: GetIt.I<FavoritesViewModel>(),
                      builder: (context, favState) {
                        final productId = product.id;
                        final wishlistVm = GetIt.I<FavoritesViewModel>();
                        bool isSaved = false;
                        if (favState is FavoritesLoadedState) {
                          isSaved = (favState).favoriteProducts.any((p) => p.id == productId);
                        }
                        return ProductCardWidget(
                          product: product,
                          isSaved: isSaved,
                          badges: {if (index == 0) ProductCardBadge.weekStar},
                          onWishlistTap: () async {
                            final wasSaved = isSaved;
                            if (!wasSaved && Supabase.instance.client.auth.currentUser == null) {
                              if (!context.mounted) return;
                              context.snackbarWarning(
                                context.resources.loginToAddToFavorites,
                                duration: context.durationLong,
                                style: SnackbarStyle.minimal,
                                position: SnackbarPosition.bottom,
                              );
                              return;
                            }
                            final success = wasSaved
                                ? await wishlistVm.removeFavorite(productId)
                                : await wishlistVm.addFavorite(
                                    productId,
                                    productForOptimisticUpdate: wasSaved ? null : product,
                                  );
                            if (!context.mounted) return;
                            if (success) {
                              final addedMsg = context.resources.addedToFavorites;
                              final removedMsg = context.resources.removedFromFavorites;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (!context.mounted) return;
                                if (wasSaved) {
                                  context.showSnackbar(
                                    message: removedMsg,
                                    type: SnackbarType.info,
                                    style: SnackbarStyle.minimal,
                                    position: SnackbarPosition.bottom,
                                    duration: context.durationLong,
                                  );
                                } else {
                                  context.snackbarSuccess(
                                    addedMsg,
                                    duration: context.durationLong,
                                    style: SnackbarStyle.minimal,
                                    position: SnackbarPosition.bottom,
                                  );
                                }
                              });
                            }
                          },
                          onAddToCart: () async {
                            try {
                              await viewModel.addProductToCart(product.id);
                              if (!context.mounted) return;
                              context.snackbarSuccess(
                                context.resources.productAddedToCart,
                                style: SnackbarStyle.minimal,
                                position: SnackbarPosition.bottom,
                              );
                            } catch (_) {
                              if (!context.mounted) return;
                              context.showSnackbar(
                                message: context.resources.failedToAddCart,
                                type: SnackbarType.warning,
                                style: SnackbarStyle.minimal,
                                position: SnackbarPosition.bottom,
                              );
                            }
                          },
                          onTap: () {
                            context.push('/product-detail/$productId');
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
