/*
 * FavoriteCategoriesView
 * ----------------------
 * View for displaying and managing favorite categories.
 */

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_favorite_categories/models/favorite_categories_view_model.dart';
import 'package:storefront_woo/app/views/view_favorite_categories/models/states.dart';
import 'package:storefront_woo/app/views/view_favorite_categories/models/favorite_category.dart';
import 'package:storefront_woo/app/utils/unified_loading_widget.dart';

class FavoriteCategoriesView
    extends
        MasterViewCubit<FavoriteCategoriesViewModel, FavoriteCategoriesState> {
  FavoriteCategoriesView({
    super.key,
    Map<String, dynamic>? arguments,
    required super.goRoute,
  }) : super(
         arguments: arguments ?? const {'favorite_categories': true},
         horizontalPadding: const PaddingVisibility.disabled(),
         verticalPadding: const PaddingVisibility.disabled(),
         appBarPadding: const AppBarPaddingVisibility.disabled(),
         navbarSpacer: const SpacerVisibility.disabled(),
         footerSpacer: const SpacerVisibility.disabled(),
         coreAppBar: (context, viewModel) => _buildAppBar(context),
       );

  @override
  void initialContent(
    FavoriteCategoriesViewModel viewModel,
    BuildContext context,
  ) {
    viewModel.initial();
  }

  /// Build app bar with config colors
  static PreferredSizeWidget _buildAppBar(BuildContext context) {
    final configHelper = AssetConfigHelper();
    
    Color getColor(String key, Color fallback) {
      try {
        final colorString = configHelper.getString('favorite_categories_view_configuration.app_bar.$key');
        if (colorString.isNotEmpty && colorString.startsWith('#')) {
          final hexString = colorString.substring(1);
          if (hexString.length == 6) {
            return Color(int.parse('FF$hexString', radix: 16));
          } else if (hexString.length == 8) {
            return Color(int.parse(hexString, radix: 16));
          }
        }
      } catch (e) {
        debugPrint('⚠️ Failed to load app bar color $key: $e');
      }
      return fallback;
    }
    
    final title = configHelper.getString('favorite_categories_view_configuration.app_bar.title', 'Favorite Categories');
    final backgroundColor = getColor('backgroundColor', OsmeaColors.white);
    final foregroundColor = getColor('foregroundColor', OsmeaColors.black);
    final titleColor = getColor('titleColor', OsmeaColors.black);
    final iconColor = getColor('iconColor', OsmeaColors.black);
    final elevation = configHelper.getDouble('favorite_categories_view_configuration.app_bar.elevation', 0.0);
    
    return OsmeaComponents.appBar(
      title: OsmeaComponents.text(
        title,
        variant: OsmeaTextVariant.headlineMedium,
        color: titleColor,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      surfaceTintColor: OsmeaColors.transparent,
      shadowColor: OsmeaColors.transparent,
      leading: OsmeaComponents.iconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: iconColor),
        onPressed: () => Navigator.of(context).maybePop(),
        backgroundColor: OsmeaColors.transparent,
      ),
      centerTitle: false,
    );
  }

  @override
  Widget viewContent(
    BuildContext context,
    FavoriteCategoriesViewModel viewModel,
    FavoriteCategoriesState state,
  ) {
    if (state is FavoriteCategoriesInitialState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.initial();
      });
      return UnifiedLoadingWidget(goRoute: goRoute);
    }

    if (state is FavoriteCategoriesLoadingState) {
      return UnifiedLoadingWidget(goRoute: goRoute);
    }

    if (state is FavoriteCategoriesErrorState) {
      return buildError(
        state.message,
        onRetry: () => viewModel.loadFavoriteCategories(),
      );
    }

    if (state is FavoriteCategoriesLoadedState) {
      if (state.categories.isEmpty) {
        // Navigate to empty view
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/empty/favorite-categories?actionPath=/home');
        });
        return const SizedBox.shrink();
      }

      final configHelper = AssetConfigHelper();
      final gridConfig = configHelper.getObject('favorite_categories_view_configuration.grid');
      final crossAxisCount = (gridConfig?['crossAxisCount'] as num?)?.toInt() ?? 2;
      final crossAxisSpacing = (gridConfig?['crossAxisSpacing'] as num?)?.toDouble() ?? 12.0;
      final mainAxisSpacing = (gridConfig?['mainAxisSpacing'] as num?)?.toDouble() ?? 12.0;
      final childAspectRatio = (gridConfig?['childAspectRatio'] as num?)?.toDouble() ?? 0.85;
      final padding = (gridConfig?['padding'] as num?)?.toDouble() ?? 16.0;
      
      return SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: state.categories.length,
          itemBuilder: (context, index) {
            return _buildCategoryCard(
              context,
              state.categories[index],
              viewModel,
            );
          },
        ),
      );
    }

    return UnifiedLoadingWidget(goRoute: goRoute);
  }

  /// Get color from config
  Color _getColorFromConfig(String key, Color fallback) {
    try {
      final configHelper = AssetConfigHelper();
      final colorString = configHelper.getString('favorite_categories_view_configuration.$key');
      if (colorString.isNotEmpty && colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load color $key: $e');
    }
    return fallback;
  }

  Widget _buildCategoryCard(
    BuildContext context,
    FavoriteCategory category,
    FavoriteCategoriesViewModel viewModel,
  ) {
    final configHelper = AssetConfigHelper();
    final imageUrl = category.imageUrl;
    final categoryName = category.name;
    
    // Get card config
    final cardConfig = configHelper.getObject('favorite_categories_view_configuration.category_card');
    final borderRadius = (cardConfig?['borderRadius'] as num?)?.toDouble() ?? 16.0;
    final shadowColor = _getColorFromConfig('category_card.shadowColor', OsmeaColors.black);
    final shadowOpacity = (cardConfig?['shadowOpacity'] as num?)?.toDouble() ?? 0.05;
    final shadowBlur = (cardConfig?['shadowBlur'] as num?)?.toDouble() ?? 8.0;
    final shadowOffset = (cardConfig?['shadowOffset'] as num?)?.toDouble() ?? 2.0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(shadowOpacity),
            blurRadius: shadowBlur,
            offset: Offset(0, shadowOffset),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            goRoute('/products?category_id=${category.id}');
          },
          borderRadius: BorderRadius.circular(borderRadius),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                imageUrl != null && imageUrl.isNotEmpty
                    ? OsmeaComponents.image(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        variant: ImageVariant.normal,
                        errorWidget: _buildImagePlaceholder(context),
                        placeholder: _buildLoadingPlaceholder(context),
                      )
                    : _buildImagePlaceholder(context),
                // Gradient overlay from bottom - darker
                _buildGradientOverlay(context),
                // Category name on gradient
                _buildCategoryName(context, categoryName),
                // Favorite button overlay
                _buildFavoriteButton(context, category, viewModel),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build loading placeholder
  Widget _buildLoadingPlaceholder(BuildContext context) {
    final configHelper = AssetConfigHelper();
    final loadingConfig = configHelper.getObject('favorite_categories_view_configuration.category_card.loading_indicator');
    final loadingColor = _getColorFromConfig('category_card.loading_indicator.color', OsmeaColors.black);
    final strokeWidth = (loadingConfig?['strokeWidth'] as num?)?.toDouble() ?? 2.0;
    
    return Container(
      color: Colors.grey.shade100,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
        ),
      ),
    );
  }

  /// Build gradient overlay
  Widget _buildGradientOverlay(BuildContext context) {
    final configHelper = AssetConfigHelper();
    final gradientConfig = configHelper.getObject('favorite_categories_view_configuration.category_card.gradient_overlay');
    final enabled = gradientConfig?['enabled'] as bool? ?? true;
    
    if (!enabled) {
      return const SizedBox.shrink();
    }
    
    final height = (gradientConfig?['height'] as num?)?.toDouble() ?? 120.0;
    final colorsList = gradientConfig?['colors'] as List<dynamic>?;
    final stopsList = gradientConfig?['stops'] as List<dynamic>?;
    
    List<Color> gradientColors = [
      Colors.black.withOpacity(0.85),
      Colors.black.withOpacity(0.65),
      Colors.black.withOpacity(0.3),
      Colors.transparent,
    ];
    
    List<double> gradientStops = const [0.0, 0.3, 0.7, 1.0];
    
    if (colorsList != null && colorsList.isNotEmpty) {
      gradientColors = colorsList.map((colorMap) {
        final colorString = colorMap['color'] as String? ?? '#000000';
        final opacity = (colorMap['opacity'] as num?)?.toDouble() ?? 1.0;
        Color baseColor = Colors.black;
        if (colorString.startsWith('#')) {
          final hexString = colorString.substring(1);
          if (hexString.length == 6) {
            baseColor = Color(int.parse('FF$hexString', radix: 16));
          } else if (hexString.length == 8) {
            baseColor = Color(int.parse(hexString, radix: 16));
          }
        }
        return baseColor.withOpacity(opacity);
      }).toList();
    }
    
    if (stopsList != null && stopsList.isNotEmpty) {
      gradientStops = stopsList.map((stop) => (stop as num).toDouble()).toList();
    }
    
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: gradientColors,
            stops: gradientStops,
          ),
        ),
      ),
    );
  }

  /// Build category name
  Widget _buildCategoryName(BuildContext context, String categoryName) {
    final configHelper = AssetConfigHelper();
    final nameConfig = configHelper.getObject('favorite_categories_view_configuration.category_card.category_name');
    final nameColor = _getColorFromConfig('category_card.category_name.color', OsmeaColors.white);
    final shadowColor = _getColorFromConfig('category_card.category_name.shadowColor', OsmeaColors.black);
    final shadowOpacity = (nameConfig?['shadowOpacity'] as num?)?.toDouble() ?? 0.3;
    final shadowBlur = (nameConfig?['shadowBlur'] as num?)?.toDouble() ?? 4.0;
    final shadowOffset = (nameConfig?['shadowOffset'] as num?)?.toDouble() ?? 1.0;
    final fontWeight = (nameConfig?['fontWeight'] as num?)?.toInt() ?? 600;
    final fontSize = (nameConfig?['fontSize'] as num?)?.toDouble() ?? 14.0;
    final maxLines = (nameConfig?['maxLines'] as num?)?.toInt() ?? 2;
    
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: EdgeInsets.all(context.spacing12),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: OsmeaComponents.text(
            categoryName,
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: nameColor,
              fontWeight: FontWeight.values.firstWhere(
                (w) => w.value == fontWeight,
                orElse: () => FontWeight.w600,
              ),
              fontSize: fontSize,
              shadows: [
                Shadow(
                  color: shadowColor.withOpacity(shadowOpacity),
                  blurRadius: shadowBlur,
                  offset: Offset(0, shadowOffset),
                ),
              ],
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  /// Build favorite button
  Widget _buildFavoriteButton(
    BuildContext context,
    FavoriteCategory category,
    FavoriteCategoriesViewModel viewModel,
  ) {
    final configHelper = AssetConfigHelper();
    final buttonConfig = configHelper.getObject('favorite_categories_view_configuration.category_card.favorite_button');
    final buttonBgColor = _getColorFromConfig('category_card.favorite_button.backgroundColor', OsmeaColors.white);
    final buttonIconColor = _getColorFromConfig('category_card.favorite_button.iconColor', OsmeaColors.black);
    final buttonSize = (buttonConfig?['size'] as num?)?.toDouble() ?? 36.0;
    final elevation = (buttonConfig?['elevation'] as num?)?.toDouble() ?? 2.0;
    
    return Positioned(
      top: context.spacing8,
      right: context.spacing8,
      child: Material(
        color: buttonBgColor,
        shape: const CircleBorder(),
        elevation: elevation,
        child: InkWell(
          onTap: () {
            viewModel.removeFavorite(category.id);
            context.showSnackbar(
              title: 'Removed from favorites',
              message: 'Category was removed from your favorites',
              type: SnackbarType.error,
              style: SnackbarStyle.minimal,
              position: SnackbarPosition.bottom,
              animation: SnackbarAnimation.slide,
              actionLabel: 'Undo',
              onAction: () => viewModel.toggleFavorite(
                category.id,
                category.name,
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: buttonSize,
            height: buttonSize,
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.favorite,
              color: buttonIconColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    final configHelper = AssetConfigHelper();
    final placeholderConfig = configHelper.getObject('favorite_categories_view_configuration.category_card.placeholder');
    
    Color getColor(String colorString, Color fallback) {
      if (colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
      return fallback;
    }
    
    final gradientStart = getColor(
      placeholderConfig?['gradient_start'] as String? ?? '#F5F5F5',
      Colors.grey.shade100,
    );
    final gradientEnd = getColor(
      placeholderConfig?['gradient_end'] as String? ?? '#E0E0E0',
      Colors.grey.shade200,
    );
    final iconColor = getColor(
      placeholderConfig?['iconColor'] as String? ?? '#BDBDBD',
      Colors.grey.shade400,
    );
    final iconSize = (placeholderConfig?['iconSize'] as num?)?.toDouble() ?? 48.0;
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [gradientStart, gradientEnd],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.category_outlined,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}
