import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osmea_components/src/components/bottom_sheet/bottom_sheet.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';
import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/favorite_group.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';

import 'models/view_model.dart';
import 'models/states.dart';
import 'widgets/favorites_list_widget.dart';

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
                      textStyle: OsmeaTextStyle.headlineMedium(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                    backgroundColor: backgroundColor,
                    foregroundColor: foregroundColor,
                    size: AppBarSize.large,
                    elevation: elevation,
                    titleSpacing: 0.0,
                    leading: OsmeaComponents.iconButton(
                      icon: Icon(Icons.arrow_back, color: iconColor),
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          goRoute('/home');
                        }
                      },
                      backgroundColor: OsmeaColors.transparent,
                    ),
                    actions: [
                      AppBarAction(
                        icon: Icon(Icons.add, color: iconColor),
                        onPressed: () => FavoritesView._showCreateGroupDialogImpl(context, viewModel),
                        tooltip: 'Create new collection',
                      ),
                      if (state is FavoritesLoadedState &&
                          state.favoriteProducts.isNotEmpty)
                        AppBarAction(
                          icon: Icon(Icons.delete_outline, color: iconColor),
                          onPressed: () => FavoritesView._showRemoveAllDialogImpl(context, viewModel, state),
                          tooltip: 'Remove all',
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
              OsmeaComponents.text(resources.loginToViewFavorites, textAlign: TextAlign.center),
              OsmeaComponents.sizedBox(height: 20),
              OsmeaComponents.button(
                text: resources.loginSignup,
                onPressed: () => goRoute('/profile'),
                variant: ButtonVariant.outlined,
                textColor: OsmeaColors.black,
                borderColor: OsmeaColors.black,
              ),
            ],
          ),
        ),
      );
    }

    if (state is FavoritesLoadedState) {
      return _buildWooStyleContent(context, viewModel, state);
    }

    return const Center(child: CircularProgressIndicator());
  }

  static void _showCreateGroupDialogImpl(BuildContext context, FavoritesViewModel viewModel) {
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

  Widget _buildWooStyleContent(
    BuildContext context,
    FavoritesViewModel viewModel,
    FavoritesLoadedState state,
  ) {
    final resources = context.resources;
    final hasProducts = state.favoriteProducts.isNotEmpty;
    final hasGroups = state.groups.isNotEmpty;

    final hasBrands = state.favoriteBrands.isNotEmpty;
    if (!hasProducts && !hasGroups && !hasBrands) {
      return OsmeaComponents.center(
        child: OsmeaComponents.text(resources.noFavorites),
      );
    }

    void navigateTo(String path) {
      if (path.startsWith('/product-detail')) {
        context.push(path);
      } else {
        goRoute(path);
      }
    }

    // Woo-style: Favorite brands row (if any), then collections, then products
    Widget? brandsSection;
    if (hasBrands) {
      brandsSection = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            resources.brands,
            textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: context.spacing12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.favoriteBrands.length,
              itemBuilder: (context, index) {
                final brand = state.favoriteBrands[index];
                return _FavoriteBrandCard(
                  brand: brand,
                  viewModel: viewModel,
                );
              },
            ),
          ),
        ],
      );
    }

    Widget? topSection;
    if (hasGroups || hasBrands) {
      topSection = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (brandsSection != null) ...[
            brandsSection,
            SizedBox(height: context.spacing16),
          ],
          if (hasGroups)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.resources.collections,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: context.spacing12),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.groups.length,
                    itemBuilder: (context, index) {
                      return _buildCollectionCard(context, state.groups[index], viewModel, state);
                    },
                  ),
                ),
              ],
            ),
        ],
      );
    }

    return FavoritesListWidget(
      items: state.favoriteProducts,
      viewModel: viewModel,
      goRoute: navigateTo,
      topSection: topSection,
    );
  }

  Widget _buildCollectionCard(
    BuildContext context,
    FavoriteGroup group,
    FavoritesViewModel viewModel,
    FavoritesLoadedState state,
  ) {
    return Container(
      margin: EdgeInsets.only(right: context.spacing12),
      width: 100,
      child: GestureDetector(
        onTap: () => _showCollectionBottomSheet(context, group, viewModel, state),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: OsmeaColors.silver, width: 1),
                color: OsmeaColors.grayMaterial[50],
              ),
              child: Icon(
                Icons.folder_outlined,
                color: OsmeaColors.grayMaterial[600],
                size: 32,
              ),
            ),
            SizedBox(height: context.spacing4),
            Text(
              group.name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _FavoriteBrandCard({
    required Brand brand,
    required FavoritesViewModel viewModel,
  }) {
    return Builder(
      builder: (context) {
        const circleSize = 64.0;
        return Container(
          margin: EdgeInsets.only(right: context.spacing12),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () => context.push('/brands/${brand.id}'),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: circleSize,
                      height: circleSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: OsmeaColors.silver, width: 1),
                        color: OsmeaColors.grayMaterial[100],
                      ),
                      child: ClipOval(
                        child: brand.logoUrl != null && brand.logoUrl!.isNotEmpty
                            ? OsmeaComponents.image(
                                imageUrl: brand.logoUrl!,
                                width: circleSize,
                                height: circleSize,
                                fit: BoxFit.cover,
                                variant: ImageVariant.normal,
                                errorWidget: Icon(Icons.branding_watermark, size: circleSize * 0.5, color: OsmeaColors.pewter),
                              )
                            : Icon(Icons.branding_watermark, size: circleSize * 0.5, color: OsmeaColors.pewter),
                      ),
                    ),
                    SizedBox(height: context.spacing8),
                    SizedBox(
                      width: circleSize + context.spacing12,
                      child: OsmeaComponents.text(
                        brand.name,
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          fontWeight: FontWeight.w500,
                          color: OsmeaColors.thunder,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -4,
                right: -4,
                child: GestureDetector(
                  onTap: () async {
                    await viewModel.removeFavoriteBrand(brand.id);
                    if (context.mounted) {
                      context.snackbarWarning(
                        context.resources.brandRemovedFromFavorites,
                        style: SnackbarStyle.minimal,
                        position: SnackbarPosition.bottom,
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(context.spacing4),
                    decoration: BoxDecoration(
                      color: OsmeaColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: OsmeaColors.silver),
                    ),
                    child: Icon(Icons.favorite, size: 18, color: OsmeaColors.thunder),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void _showCollectionBottomSheet(
    BuildContext context,
    FavoriteGroup group,
    FavoritesViewModel viewModel,
    FavoritesLoadedState state,
  ) {
    void goRoute(String path) {
      if (path.startsWith('/product-detail')) {
        Navigator.of(context).pop(context);
        context.push(path);
      } else {
        Navigator.of(context).pop(context);
        context.go(path);
      }
    }
    OsmeaBottomSheetHelpers.showModal(
      context: context,
      size: BottomSheetSize.large,
      title: group.name,
      headerActions: [
        _CollectionSheetDeleteButton(
          viewModel: viewModel,
          group: group,
          onDeleted: () => Navigator.of(context).pop(),
        ),
      ],
      backgroundColor: OsmeaColors.white,
      child: _CollectionDetailContent(
        group: group,
        viewModel: viewModel,
        allProducts: state.favoriteProducts,
        goRoute: goRoute,
      ),
    ).then((_) {
      viewModel.initial();
    });
  }

  static Future<void> _showRemoveAllDialogImpl(
    BuildContext context,
    FavoritesViewModel viewModel,
    FavoritesLoadedState state,
  ) async {
    final resources = context.resources;
    final confirmed = await OsmeaComponents.showPopup<bool>(
      context: context,
      variant: PopupVariant.dialog,
      title: 'Remove all favorites?',
      subtitle: 'All items will be removed from your favorites. This cannot be undone.',
      padding: context.paddingNormal,
      backgroundColor: OsmeaColors.white,
      child: OsmeaComponents.column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OsmeaComponents.row(
            children: [
              OsmeaComponents.expanded(
                child: OsmeaComponents.button(
                  text: resources.cancel,
                  variant: ButtonVariant.outlined,
                  borderColor: OsmeaColors.black,
                  textColor: OsmeaColors.black,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
              OsmeaComponents.sizedBox(width: context.spacing8),
              OsmeaComponents.expanded(
                child: OsmeaComponents.button(
                  text: 'Remove all',
                  variant: ButtonVariant.primary,
                  backgroundColor: OsmeaColors.black,
                  textColor: OsmeaColors.white,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      final success = await viewModel.clearAllFavorites();
      if (!context.mounted) return;
      if (success) {
        final configHelper = AssetConfigHelper();
        context.snackbarSuccess(
          configHelper.getString(
            'favorites_view.snackbar.all_removed_message',
            resources.removedFromFavorites,
          ),
          duration: context.durationLong,
          style: SnackbarStyle.minimal,
          position: SnackbarPosition.bottom,
        );
      }
    }
  }
}

/// Delete collection button for sheet header (Woo-style): confirm dialog, then delete, then pop.
class _CollectionSheetDeleteButton extends StatefulWidget {
  final FavoritesViewModel viewModel;
  final FavoriteGroup group;
  final VoidCallback onDeleted;

  const _CollectionSheetDeleteButton({
    required this.viewModel,
    required this.group,
    required this.onDeleted,
  });

  @override
  State<_CollectionSheetDeleteButton> createState() => _CollectionSheetDeleteButtonState();
}

class _CollectionSheetDeleteButtonState extends State<_CollectionSheetDeleteButton> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    if (_isDeleting) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    return IconButton(
      icon: Icon(Icons.delete_outline, color: OsmeaColors.red),
      onPressed: () async {
        final confirmed = await OsmeaComponents.showPopup<bool>(
          context: context,
          variant: PopupVariant.dialog,
          title: 'Delete Collection',
          subtitle: 'Are you sure you want to delete this collection?',
          padding: context.paddingNormal,
          backgroundColor: OsmeaColors.white,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: OsmeaComponents.button(
                  text: 'Cancel',
                  variant: ButtonVariant.outlined,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
              SizedBox(width: context.spacing8),
              Expanded(
                child: OsmeaComponents.button(
                  text: 'Delete',
                  variant: ButtonVariant.primary,
                  backgroundColor: OsmeaColors.red,
                  textColor: OsmeaColors.white,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ),
            ],
          ),
        );
        if (confirmed == true && mounted) {
          setState(() => _isDeleting = true);
          try {
            final success = await widget.viewModel.deleteGroup(widget.group.id);
            if (!mounted) return;
            if (success) {
              widget.onDeleted();
              context.showSnackbar(
                title: 'Deleted',
                message: 'Collection deleted successfully',
                type: SnackbarType.success,
                style: SnackbarStyle.minimal,
                position: SnackbarPosition.bottom,
              );
            } else {
              setState(() => _isDeleting = false);
            }
          } catch (e) {
            if (mounted) setState(() => _isDeleting = false);
          }
        }
      },
    );
  }
}

/// Woo-style collection detail: items in collection (with remove) + add products to collection.
class _CollectionDetailContent extends StatefulWidget {
  final FavoriteGroup group;
  final FavoritesViewModel viewModel;
  final List<Product> allProducts;
  final void Function(String path) goRoute;

  const _CollectionDetailContent({
    required this.group,
    required this.viewModel,
    required this.allProducts,
    required this.goRoute,
  });

  @override
  State<_CollectionDetailContent> createState() => _CollectionDetailContentState();
}

class _CollectionDetailContentState extends State<_CollectionDetailContent> {
  List<Product>? _inCollection;
  List<Product>? _notInCollection;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final inCol = await widget.viewModel.getCollectionProducts(widget.group.id);
    final notIn = await widget.viewModel.getFavoriteProductsNotInGroup(widget.group.id);
    if (mounted) {
      setState(() {
        _inCollection = inCol;
        _notInCollection = notIn;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Padding(
        padding: EdgeInsets.all(context.spacing24),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Items in this collection
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.spacing20, vertical: context.spacing8),
            child: Text(
              'Items in this collection: ${_inCollection!.length}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (_inCollection!.isEmpty)
            Padding(
              padding: EdgeInsets.all(context.spacing16),
              child: Text(
                'No items in this collection yet',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            ..._inCollection!.map((p) => _CollectionItemRow(
                  product: p,
                  viewModel: widget.viewModel,
                  goRoute: widget.goRoute,
                  isInCollection: true,
                  groupId: widget.group.id,
                  onRemove: () => _load(),
                )),
          SizedBox(height: context.spacing24),
          // Add products to this collection
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.spacing20, vertical: context.spacing8),
            child: Text(
              'Add products to this collection:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          if (_notInCollection!.isEmpty)
            Padding(
              padding: EdgeInsets.all(context.spacing16),
              child: Text(
                'No other products to add',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            ..._notInCollection!.map((p) => _CollectionItemRow(
                  product: p,
                  viewModel: widget.viewModel,
                  goRoute: widget.goRoute,
                  isInCollection: false,
                  groupId: widget.group.id,
                  onAdd: () => _load(),
                )),
          SizedBox(height: context.spacing32),
        ],
      ),
    );
  }
}

class _CollectionItemRow extends StatelessWidget {
  final Product product;
  final FavoritesViewModel viewModel;
  final void Function(String path) goRoute;
  final bool isInCollection;
  final String groupId;
  final VoidCallback? onRemove;
  final VoidCallback? onAdd;

  const _CollectionItemRow({
    required this.product,
    required this.viewModel,
    required this.goRoute,
    required this.isInCollection,
    required this.groupId,
    this.onRemove,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing12,
        vertical: context.spacing6,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: OsmeaComponents.image(
              imageUrl: product.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              variant: ImageVariant.normal,
              errorWidget: SizedBox(
                width: 50,
                height: 50,
                child: Icon(Icons.image_outlined, size: 24, color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          ),
          SizedBox(width: context.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => goRoute('/product-detail/${product.id}'),
                  child: Text(
                    product.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: context.spacing2),
                  child: Text(
                    PriceHelper.format(
                      product.effectivePrice,
                      context.watch<CurrencyCubit>().state,
                      Localizations.localeOf(context).toString(),
                    ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isInCollection ? Icons.remove_circle_outline : Icons.add_circle_outline,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            onPressed: () async {
              if (isInCollection) {
                final ok = await viewModel.removeProductFromGroup(product.id, groupId);
                if (context.mounted && ok) {
                  context.showSnackbar(
                    title: 'Removed',
                    message: '${product.name} removed from collection',
                    type: SnackbarType.info,
                    style: SnackbarStyle.minimal,
                    position: SnackbarPosition.bottom,
                  );
                  onRemove?.call();
                }
              } else {
                final ok = await viewModel.addProductToGroup(product.id, groupId);
                if (context.mounted && ok) {
                  context.showSnackbar(
                    title: 'Added',
                    message: '${product.name} added to collection',
                    type: SnackbarType.success,
                    style: SnackbarStyle.minimal,
                    position: SnackbarPosition.bottom,
                  );
                  onAdd?.call();
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
