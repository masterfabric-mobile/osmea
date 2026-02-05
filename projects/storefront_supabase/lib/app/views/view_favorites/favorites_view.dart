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
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(
              context.resources.favorites,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            size: AppBarSize.large,
            elevation: 0,
            titleSpacing: 0.0,
            actions: [
              if (viewModel.state is FavoritesLoadedState && 
                  (viewModel.state as FavoritesLoadedState).favoriteProducts.isNotEmpty)
                AppBarAction(
                  type: AppBarActionType.more, // Using 'more' as a generic action type
                  icon: const Icon(Icons.delete_outline, color: Colors.black),
                  onPressed: () async {
                    // Show confirmation dialog could be good here, but for now executing directly as requested
                    final success = await viewModel.clearAllFavorites();
                    if (!context.mounted) return;
                    if (success) {
                      context.showSnackbar(
                        message: context.resources.removedFromFavorites, // Or generic cleared message
                        type: SnackbarType.info,
                      );
                    }
                  },                ),
            ],
          ),
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
                    color: Colors.grey[200],
                    child: (product.imageUrl.contains('placehold.co'))
                        ? const Center(child: Icon(Icons.image, color: Colors.grey))
                        : OsmeaComponents.image(
                            imageUrl: product.imageUrl,
                            fit: BoxFit.cover,
                            errorWidget: const Center(
                                child: Icon(Icons.error, color: Colors.red)),
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
                                          color: Colors.black,
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
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () async {
                            final success = await viewModel.removeFavorite(product.id);
                            if (!context.mounted) return;
                            if (success) {
                              context.showSnackbar(
                                message: resources.removedFromFavorites,
                                type: SnackbarType.info,
                              );
                            }
                          },
                        ),
                        OsmeaComponents.iconButton(
                          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
                          onPressed: () async {
                            final success = await viewModel.addToCart(product.id);
                            if (!context.mounted) return;
                            if (success) {
                              context.showSnackbar(
                                message: resources.productAddedToCart,
                                type: SnackbarType.success,
                              );
                            } else {
                              context.showSnackbar(
                                message: resources.failedToAddCart,
                                type: SnackbarType.error,
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

    return const Center(child: CircularProgressIndicator());
  }
}
