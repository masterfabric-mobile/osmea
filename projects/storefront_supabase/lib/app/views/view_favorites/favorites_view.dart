import 'package:flutter/material.dart';

import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
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
              context.resources.favorites, // Changed to English
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            size: AppBarSize.large,
            elevation: 0,
            titleSpacing: 0.0,
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
                text: context.resources.loginSignup, // Changed to English
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
          child: OsmeaComponents.text(context.resources.noFavorites), // Changed to English
        );
      }
      return GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.75,
        ),
        itemCount: state.favoriteProducts.length,
        itemBuilder: (context, index) {
          final product = state.favoriteProducts[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => goRoute('/product-detail/${product.id}'),
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.expanded(
                    child: (product.imageUrl.contains('placehold.co'))
                        ? const Center(
                            child: Icon(Icons.image, color: Colors.grey))
                        : OsmeaComponents.image(
                            imageUrl: product.imageUrl,
                            fit: BoxFit.cover,
                            errorWidget: const Center(
                                child: Icon(Icons.error, color: Colors.red)),
                          ),
                  ),
                  OsmeaComponents.padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OsmeaComponents.column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OsmeaComponents.text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textStyle:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        OsmeaComponents.sizedBox(height: 4),
                        OsmeaComponents.text(
                          '\$${product.price.toStringAsFixed(2)}',
                          textStyle:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
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

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}