import 'package:flutter/material.dart';

import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

import 'models/view_model.dart';
import 'models/states.dart';

class FavoritesView
    extends MasterViewCubit<FavoritesViewModel, FavoritesState> {
  FavoritesView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  }) : super(
          horizontalPadding: const PaddingVisibility.disabled(),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) {
            final configHelper = AssetConfigHelper();
            final appBarConfig = configHelper.getObject('favorites_view.app_bar');
            final title = appBarConfig?['title'] as String? ?? context.resources.favorites;
            final titleWithCount = appBarConfig?['titleWithCount'] as String? ?? '${context.resources.favorites} ({count})';
            final backgroundColor = configHelper.getColor(
              'favorites_view.app_bar.backgroundColor',
              OsmeaColors.white,
            );
            final foregroundColor = configHelper.getColor(
              'favorites_view.app_bar.foregroundColor',
              OsmeaColors.black,
            );
            final titleColor = configHelper.getColor(
              'favorites_view.app_bar.titleColor',
              OsmeaColors.black,
            );
            final iconColor = configHelper.getColor(
              'favorites_view.app_bar.iconColor',
              OsmeaColors.black,
            );
            final elevation = configHelper.getDouble(
              'favorites_view.app_bar.elevation',
              0.0,
            );
            return PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: BlocBuilder<FavoritesViewModel, FavoritesState>(
                bloc: viewModel,
                builder: (context, state) {
                  final currentCount = state is FavoritesLoadedState
                      ? state.favoriteProducts.length
                      : 0;
                  final currentTitle = currentCount > 0
                      ? titleWithCount.replaceAll('{count}', currentCount.toString())
                      : title;
                  return OsmeaComponents.appBar(
                    title: OsmeaComponents.text(
                      currentTitle,
                      color: titleColor,
                    ),
                    backgroundColor: backgroundColor,
                    foregroundColor: foregroundColor,
                    size: AppBarSize.large,
                    elevation: elevation,
                    titleSpacing: 0.0,
                    actions: [
                      if (state is FavoritesLoadedState &&
                          state.favoriteProducts.isNotEmpty)
                        AppBarAction(
                          type: AppBarActionType.more,
                          icon: Icon(Icons.delete_sweep, color: iconColor),
                          onPressed: () async {
                            final success = await viewModel.clearAllFavorites();
                            if (!context.mounted) return;
                            if (success) {
                              final msg = configHelper.getString(
                                'favorites_view.snackbar.all_removed_message',
                                context.resources.removedFromFavorites,
                              );
                              context.snackbarSuccess(
                                msg,
                                duration: context.durationLong,
                                style: SnackbarStyle.minimal,
                                position: SnackbarPosition.bottom,
                              );
                            }
                          },
                        ),
                    ],
                  );
                },
              ),
            );
          },
        );

  @override
  void initialContent(
    FavoritesViewModel viewModel,
    BuildContext context,
  ) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    FavoritesViewModel viewModel,
    FavoritesState state,
  ) {
    final resources = context.resources;

    if (state is FavoritesLoadingState || state is FavoritesInitialState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is FavoritesErrorState) {
      return OsmeaComponents.center(
        child: OsmeaComponents.padding(
          padding: const EdgeInsets.all(16.0),
          child: OsmeaComponents.column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OsmeaComponents.text(state.message, textAlign: TextAlign.center),
              OsmeaComponents.sizedBox(height: 20),
              OsmeaComponents.button(
                text: resources.loginSignup,
                onPressed: () => goRoute('/profile'),
                variant: ButtonVariant.primary,
              ),
            ],
          ),
        ),
      );
    }

    if (state is FavoritesLoadedState) {
      return Column(
        children: [
          // 1. Tab Selector (Products / Brands)
          _buildTabSelector(context, viewModel, state),
          
          // 2. Group Selector (Only visible for Products view usually, but can be for both)
          if (state.viewType == FavoritesViewType.products)
            _buildGroupSelector(context, viewModel, state),

          // 3. Content
          Expanded(
            child: state.viewType == FavoritesViewType.products
                ? _buildProductsList(context, viewModel, state)
                : _buildBrandsGrid(context, viewModel, state),
          ),
        ],
      );
    }

    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildTabSelector(
      BuildContext context, FavoritesViewModel viewModel, FavoritesLoadedState state) {
    final configHelper = AssetConfigHelper();
    final horizontal = configHelper.getDouble(
      'favorites_view.component_spacing.horizontal',
      16.0,
    );
    final vertical = configHelper.getDouble(
      'favorites_view.component_spacing.vertical',
      8.0,
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      color: OsmeaColors.white,
      child: Row(
        children: [
          _buildTabButton(
            context,
            text: context.resources.products,
            isSelected: state.viewType == FavoritesViewType.products,
            onTap: () => viewModel.setViewType(FavoritesViewType.products),
          ),
          const SizedBox(width: 12),
          _buildTabButton(
            context,
            text: context.resources.brands, // Using existing 'brands' string
            isSelected: state.viewType == FavoritesViewType.brands,
            onTap: () => viewModel.setViewType(FavoritesViewType.brands),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(BuildContext context,
      {required String text,
      required bool isSelected,
      required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? OsmeaColors.black : OsmeaColors.ash,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? OsmeaColors.white : OsmeaColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupSelector(
      BuildContext context, FavoritesViewModel viewModel, FavoritesLoadedState state) {
    return Container(
      height: 50,
      width: double.infinity,
      color: OsmeaColors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // "All" Chip
          _buildGroupChip(
            context,
            label: "All",
            isSelected: state.selectedGroupId == null,
            onTap: () => viewModel.selectGroup(null),
          ),
          const SizedBox(width: 8),
          
          // Groups Chips
          ...state.groups.map((group) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildGroupChip(
                context,
                label: group.name,
                isSelected: state.selectedGroupId == group.id,
                onTap: () => viewModel.selectGroup(group.id),
              ),
            );
          }),

          // "Create Group" Button
          ActionChip(
            label: Icon(Icons.add, size: 18, color: OsmeaColors.black),
            onPressed: () => _showCreateGroupDialog(context, viewModel),
            backgroundColor: OsmeaColors.white,
            shape: CircleBorder(side: BorderSide(color: OsmeaColors.silver)),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupChip(BuildContext context,
      {required String label,
      required bool isSelected,
      required VoidCallback onTap}) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: OsmeaColors.white,
      selectedColor: OsmeaColors.black,
      labelStyle: TextStyle(
        color: isSelected ? OsmeaColors.white : OsmeaColors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isSelected ? OsmeaColors.transparent : OsmeaColors.platinum),
      ),
      showCheckmark: false,
    );
  }

  void _showCreateGroupDialog(BuildContext context, FavoritesViewModel viewModel) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create New Group'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Group Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: OsmeaColors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                viewModel.createGroup(controller.text);
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
backgroundColor: OsmeaColors.black,
                  foregroundColor: OsmeaColors.white,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(
      BuildContext context, FavoritesViewModel viewModel, FavoritesLoadedState state) {
    final resources = context.resources;
    if (state.favoriteProducts.isEmpty) {
      return OsmeaComponents.center(
        child: OsmeaComponents.text(resources.noFavorites),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: state.favoriteProducts.length,
      separatorBuilder: (context, index) => OsmeaComponents.sizedBox(height: 16),
      itemBuilder: (context, index) {
        final product = state.favoriteProducts[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () => goRoute('/product-detail/${product.id}'),
            child: OsmeaComponents.row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image (Left)
                OsmeaComponents.container(
                  width: 100,
                  height: 100,
                  color: OsmeaColors.silver,
                  child: (product.imageUrl.contains('placehold.co'))
                      ? Center(child: Icon(Icons.image, color: OsmeaColors.pewter))
                      : OsmeaComponents.image(
                          imageUrl: product.imageUrl,
                          fit: BoxFit.cover,
                          errorWidget: Center(
                              child: Icon(Icons.error, color: OsmeaColors.black)),
                        ),
                ),
                
                // Details (Middle)
                OsmeaComponents.expanded(
                  child: OsmeaComponents.padding(
                    padding: const EdgeInsets.all(12.0),
                    child: OsmeaComponents.column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OsmeaComponents.text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        OsmeaComponents.sizedBox(height: 8),
                        BlocBuilder<CurrencyCubit, String>(
                          builder: (context, currency) {
                            return OsmeaComponents.text(
                              PriceHelper.format(product.effectivePrice, currency,
                                  Localizations.localeOf(context).toString()),
                              textStyle:
                                  Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: OsmeaColors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Actions (Right)
                OsmeaComponents.padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: OsmeaComponents.column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OsmeaComponents.iconButton(
                        icon: const Icon(Icons.favorite, color: OsmeaColors.black),
                        onPressed: () async {
                          final success = await viewModel.removeFavorite(product.id);
                          if (!context.mounted) return;
                          if (success) {
                            context.showSnackbar(
                              message: resources.removedFromFavorites,
                              type: SnackbarType.info,
                              style: SnackbarStyle.minimal,
                              position: SnackbarPosition.bottom,
                              duration: context.durationLong,
                            );
                          }
                        },
                      ),
                      OsmeaComponents.iconButton(
                        icon: const Icon(Icons.shopping_cart_outlined, color: OsmeaColors.black),
                        onPressed: () async {
                          final success = await viewModel.addToCart(product.id);
                          if (!context.mounted) return;
                          if (success) {
                            context.snackbarSuccess(
                              resources.productAddedToCart,
                              duration: context.durationLong,
                              style: SnackbarStyle.minimal,
                              position: SnackbarPosition.bottom,
                            );
                          } else {
                            context.snackbarError(
                              resources.failedToAddCart,
                              duration: context.durationLong,
                              style: SnackbarStyle.minimal,
                              position: SnackbarPosition.bottom,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBrandsGrid(
      BuildContext context, FavoritesViewModel viewModel, FavoritesLoadedState state) {
    if (state.favoriteBrands.isEmpty) {
      return OsmeaComponents.center(
        child: OsmeaComponents.text("No favorite brands yet."), // Add to resources later
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: state.favoriteBrands.length,
      itemBuilder: (context, index) {
        final brand = state.favoriteBrands[index];
        return GestureDetector(
          onTap: () => goRoute('/brands/${brand.id}'),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: OsmeaColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: OsmeaColors.silver),
                    boxShadow: [
                      BoxShadow(
                        color: OsmeaColors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    image: brand.logoUrl != null
                        ? DecorationImage(
                            image: NetworkImage(brand.logoUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: brand.logoUrl == null
                      ? Center(
                          child: Text(
                            brand.name[0].toUpperCase(),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      brand.name,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await viewModel.removeFavoriteBrand(brand.id);
                      if (context.mounted) {
                        context.showSnackbar(
                          message: context.resources.removedFromFavorites,
                          type: SnackbarType.info,
                          style: SnackbarStyle.minimal,
                          position: SnackbarPosition.bottom,
                          duration: context.durationLong,
                        );
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Icon(Icons.favorite, size: 14, color: OsmeaColors.black),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
