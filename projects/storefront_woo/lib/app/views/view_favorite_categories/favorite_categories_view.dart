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
         coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
           title: OsmeaComponents.text(
             'Favorite Categories',
             variant: OsmeaTextVariant.headlineMedium,
             color: OsmeaColors.black,
             fontWeight: FontWeight.w600,
           ),
           backgroundColor: OsmeaColors.white,
           foregroundColor: OsmeaColors.black,
           elevation: 0,
           surfaceTintColor: OsmeaColors.transparent,
           shadowColor: OsmeaColors.transparent,
           leading: OsmeaComponents.iconButton(
             icon: Icon(Icons.arrow_back_ios_new, color: OsmeaColors.black),
             onPressed: () => Navigator.of(context).maybePop(),
             backgroundColor: OsmeaColors.transparent,
           ),
           centerTitle: false,
         ),
       );

  @override
  void initialContent(
    FavoriteCategoriesViewModel viewModel,
    BuildContext context,
  ) {
    viewModel.initial();
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
      return LoadingView(
        goRoute: goRoute,
        loadingType: LoadingModelType.dataLoading,
        stepDuration: context.durationSlow,
        showCancelButton: false,
      );
    }

    if (state is FavoriteCategoriesLoadingState) {
      return LoadingView(
        goRoute: goRoute,
        loadingType: LoadingModelType.dataLoading,
        stepDuration: context.durationSlow,
        showCancelButton: false,
      );
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

      return SingleChildScrollView(
        padding: EdgeInsets.all(context.spacing16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: context.spacing12,
            mainAxisSpacing: context.spacing12,
            childAspectRatio: 0.85,
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

    return LoadingView(
      goRoute: goRoute,
      loadingType: LoadingModelType.dataLoading,
      stepDuration: context.durationSlow,
      showCancelButton: false,
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    FavoriteCategory category,
    FavoriteCategoriesViewModel viewModel,
  ) {
    final imageUrl = category.imageUrl;
    final categoryName = category.name;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            goRoute('/products?category_id=${category.id}');
          },
          borderRadius: BorderRadius.circular(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
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
                        placeholder: Container(
                          color: Colors.grey.shade100,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                OsmeaColors.nordicBlue,
                              ),
                            ),
                          ),
                        ),
                      )
                    : _buildImagePlaceholder(context),
                // Gradient overlay from bottom - darker
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.85),
                          Colors.black.withOpacity(0.65),
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.3, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
                // Category name on gradient
                Positioned(
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
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                // Favorite button overlay
                Positioned(
                  top: context.spacing8,
                  right: context.spacing8,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 2,
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
                        width: 36,
                        height: 36,
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.favorite,
                          color: OsmeaColors.nordicBlue,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey.shade100, Colors.grey.shade200],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.category_outlined,
          color: Colors.grey.shade400,
          size: 48,
        ),
      ),
    );
  }
}
