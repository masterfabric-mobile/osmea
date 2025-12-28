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
    extends MasterViewCubit<FavoriteCategoriesViewModel, FavoriteCategoriesState> {
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

      return OsmeaComponents.singleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing12,
          vertical: context.spacing8,
        ),
        child: OsmeaComponents.column(
          children: [
            for (int i = 0; i < state.categories.length; i++) ...[
              _buildCategoryItem(context, state.categories[i], viewModel),
              if (i < state.categories.length - 1)
                OsmeaComponents.divider(
                  color: OsmeaColors.platinum,
                  height: context.height1,
                ),
            ],
          ],
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

  Widget _buildCategoryItem(
    BuildContext context,
    FavoriteCategory category,
    FavoriteCategoriesViewModel viewModel,
  ) {
    return OsmeaComponents.listItem(
      variant: ListItemVariant.standard,
      size: ListItemSize.medium,
      title: OsmeaComponents.text(
        category.name,
        textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      leading: category.imageUrl != null && category.imageUrl!.isNotEmpty
          ? OsmeaComponents.image(
              imageUrl: category.imageUrl!,
              width: context.width64,
              height: context.height64,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(context.radiusLow),
              variant: ImageVariant.normal,
              errorWidget: _buildDefaultIcon(context),
              placeholder: OsmeaComponents.container(
                width: context.width64,
                height: context.height64,
                color: OsmeaColors.grayMaterial[50],
                alignment: context.center,
                child: CircularProgressIndicator(
                  strokeWidth: context.width2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(OsmeaColors.nordicBlue),
                ),
              ),
            )
          : _buildDefaultIcon(context),
      trailing: OsmeaComponents.iconButton(
        icon: Icon(
          Icons.favorite,
          color: OsmeaColors.nordicBlue,
          size: context.iconSizeSmall,
        ),
        size: ButtonSize.extraSmall,
        variant: ButtonVariant.ghost,
        onPressed: () {
          viewModel.removeFavorite(category.id);
          context.showSnackbar(
            title: 'Removed from favorites',
            message: 'Category was removed from your favorites',
            type: SnackbarType.error,
            style: SnackbarStyle.minimal,
            position: SnackbarPosition.bottom,
            animation: SnackbarAnimation.slide,
            actionLabel: 'Undo',
            onAction: () => viewModel.toggleFavorite(category.id, category.name),
          );
        },
      ),
      onTap: () {
        goRoute('/products?category_id=${category.id}');
      },
      padding: context.paddingLow,
      margin: context.paddingZero,
    );
  }

  Widget _buildDefaultIcon(BuildContext context) {
    return OsmeaComponents.container(
      width: context.width64,
      height: context.height64,
      color: OsmeaColors.grayMaterial[50],
      child: Icon(
        Icons.category_outlined,
        color: OsmeaColors.grayMaterial[400],
        size: context.iconSizeNormal,
      ),
    );
  }
}

