import 'package:flutter/material.dart';

import 'package:core/core.dart';

import 'models/home_view_model.dart';
import 'models/states.dart';

/// Supabase Home View
///
/// This view is built using `MasterViewCubit` from core and a
/// `SupabaseHomeViewModel` that extends `BaseViewModelCubit`.
/// It replaces the old `_MinimalistHomePage` while keeping the same
/// visual design for now.
class SupabaseHomeView
    extends MasterViewCubit<SupabaseHomeViewModel, SupabaseHomeState> {
  SupabaseHomeView({
    super.key,
    super.arguments = const {'home': true},
    required super.goRoute,
  }) : super(
          horizontalPadding: const PaddingVisibility.disabled(),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(
              'Storefront Supabase',
              color: Theme.of(context).colorScheme.onPrimary, // Text color matches onPrimary
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            size: AppBarSize.large,
            elevation: 0,
            titleSpacing: 0.0,
            actions: [
              AppBarAction(
                type: AppBarActionType.search,
                icon: Icon(Icons.search, color: Theme.of(context).colorScheme.onPrimary),
                onPressed: () => goRoute('/search'),
              ),
              AppBarAction(
                type: AppBarActionType.more,
                icon: Icon(Icons.shopping_cart_outlined, color: Theme.of(context).colorScheme.onPrimary),
                onPressed: () => goRoute('/cart'),
              ),
            ],
          ),
        );

  @override
  void initialContent(
    SupabaseHomeViewModel viewModel,
    BuildContext context,
  ) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    SupabaseHomeViewModel viewModel,
    SupabaseHomeState state,
  ) {
    if (state is SupabaseHomeErrorState) {
      return buildError(
        state.message,
        onRetry: () => viewModel.initial(),
      );
    }

    if (state is SupabaseHomeLoadingState || state is SupabaseHomeInitialState) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is SupabaseHomeLoadedState) {
      if (state.products.isEmpty) {
        return OsmeaComponents.center(
          child: OsmeaComponents.text('No products found.'),
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
        itemCount: state.products.length,
        itemBuilder: (context, index) {
          final product = state.products[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => goRoute('/product-detail/${product.id}'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: (product.imageUrl.contains('placehold.co'))
                        ? const Center(child: Icon(Icons.image, color: Colors.grey))
                        : Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(child: Icon(Icons.error, color: Colors.red));
                            },
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

    // Fallback for any other state
    return const Center(
      child: Text('Something went wrong.'),
    );
  }
}
