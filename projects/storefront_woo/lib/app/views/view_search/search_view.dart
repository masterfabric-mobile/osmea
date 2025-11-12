import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_search/models/search_view_model.dart';
import 'package:storefront_woo/app/views/view_search/models/module/states.dart'
    as search_states;
import 'package:storefront_woo/app/widgets/product_card_widget.dart';
import 'package:get_it/get_it.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';

class SearchView
    extends
        MasterViewHydratedCubit<SearchViewModel, search_states.SearchState> {
  SearchView({super.key, required super.goRoute})
    : super(
        arguments: const {'search': true},
        appBarPadding: const AppBarPaddingVisibility.disabled(),
        verticalPadding: const PaddingVisibility.disabled(),
        horizontalPadding: const PaddingVisibility.disabled(),
        coreAppBar: (context, vm) => OsmeaComponents.appBarWithSearchBar(
          title: OsmeaComponents.text(
            // Always show Categories as requested
            'Categories',
            textStyle: OsmeaTextStyle.titleLarge(
              context,
            ).copyWith(fontWeight: FontWeight.w700, color: OsmeaColors.thunder),
          ),
          leading: OsmeaComponents.iconButton(
            onPressed: () {
              // If showing products (SearchLoadedState or SearchErrorState), go back to categories
              // Otherwise, go to home
              final currentState = vm.state;
              if (currentState is search_states.SearchLoadedState ||
                  currentState is search_states.SearchErrorState) {
                vm.goBackToCategories();
              } else {
                context.go('/home');
              }
            },
            icon: Icon(Icons.arrow_back, color: OsmeaColors.thunder),
            backgroundColor: OsmeaColors.transparent,
            tooltip: 'Back',
          ),
          appBarVariant: AppBarVariant.standard,
          appBarSize: AppBarSize.standard,
          appBarBackgroundColor: OsmeaColors.white,
          appBarActionColor: OsmeaColors.thunder,
          centerTitle: true,
          // integrated searchbar
          searchHint: 'Search products...',
          searchBarVariant: SearchbarVariant.outlined,
          searchBarStyle: SearchbarStyle.standard,
          onSearch: (q) => vm.search(q),
          onSearchSubmitted: (q) => vm.search(q),
          showBackButton: false,
          onSearchBack: null,
        ),
      );

  @override
  void initialContent(SearchViewModel viewModel, BuildContext context) {
    // Initialize wishlist first to ensure state is ready
    _initializeWishlist();
    // Then load categories
    viewModel.loadCategories();
  }

  /// Initializes wishlist if not already loaded
  /// This ensures wishlist state is ready before checking product status
  Future<void> _initializeWishlist() async {
    try {
      final wishlistViewModel = GetIt.I<WishlistViewModel>();
      final currentState = wishlistViewModel.state;
      
      // Sync if state is initial, loading, error, or empty loaded state
      if (currentState is WishlistInitialState ||
          currentState is WishlistLoadingState ||
          currentState is WishlistErrorState ||
          (currentState is WishlistLoadedState && currentState.items.isEmpty)) {
        await wishlistViewModel.initial();
      } else if (currentState is! WishlistLoadedState) {
        // For any other state, ensure we have loaded state
        wishlistViewModel.restorePrevious(WishlistLoadedState(items: const []));
      }
    } catch (e) {
      debugPrint('⚠️ SearchView: Failed to initialize wishlist: $e');
      // Ensure we have at least an empty loaded state
      try {
        final wishlistViewModel = GetIt.I<WishlistViewModel>();
        final currentState = wishlistViewModel.state;
        if (currentState is! WishlistLoadedState) {
          wishlistViewModel.restorePrevious(WishlistLoadedState(items: const []));
        }
      } catch (e2) {
        debugPrint('⚠️ SearchView: Failed to restore wishlist state: $e2');
      }
    }
  }

  @override
  Widget viewContent(
    BuildContext context,
    SearchViewModel viewModel,
    search_states.SearchState state,
  ) {
    if (state is search_states.SearchLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is search_states.SearchErrorState) {
      return Center(
        child: OsmeaComponents.text(
          state.message,
          textStyle: OsmeaTextStyle.bodyMedium(context),
        ),
      );
    }
    if (state is search_states.SearchLoadedState) {
      if (state.results.isEmpty) {
        return Center(
          child: OsmeaComponents.text(
            'No results found',
            textStyle: OsmeaTextStyle.bodyMedium(context),
          ),
        );
      }
      // Grid layout exactly like home product grid
      final bool isTablet = context.allWidth >= 768;
      final int crossAxisCount = isTablet ? 3 : 2;
      // Optimized aspect ratio to prevent overflow - more vertical space (same as home)
      final double childAspectRatio = isTablet ? 0.68 : 0.58;
      final double crossAxisSpacing = context.spacing12;
      final double mainAxisSpacing = context.spacing12;

      return GridView.builder(
        padding: context.paddingNormal, // Same padding as home view
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
        ),
        itemCount: state.results.length,
        itemBuilder: (context, index) {
          final product = state.results[index];
          final productId = product.id ?? 0;
          
          // Use BlocBuilder to reactively listen to WishlistViewModel changes
          return BlocBuilder<WishlistViewModel, WishlistState>(
            bloc: GetIt.I<WishlistViewModel>(),
            buildWhen: (previous, current) {
              // Always rebuild when transitioning to LoadedState from any other state
              if (previous is! WishlistLoadedState && current is WishlistLoadedState) {
                return true; // State just loaded, rebuild to show saved status
              }
              // Rebuild when state changes between Loaded states (item added/removed)
              if (previous is WishlistLoadedState && current is WishlistLoadedState) {
                final prevSaved = previous.items.any((e) => e.id == productId);
                final currSaved = current.items.any((e) => e.id == productId);
                return prevSaved != currSaved;
              }
              // Also rebuild if previous was LoadedState and current is not (shouldn't happen, but safe)
              if (previous is WishlistLoadedState && current is! WishlistLoadedState) {
                return true;
              }
              return false; // Don't rebuild for other state changes
            },
            builder: (context, wishlistState) {
              final wishlistVm = GetIt.I<WishlistViewModel>();
              // Always check current state, even if it's not LoadedState yet
              final isSaved = wishlistVm.isSaved(productId);
              
              return ProductCardWidget(
                product: product,
                isSaved: isSaved,
                onWishlistTap: () {
                  // Use shared HomeViewModel for wishlist to keep messages/state in sync
                  GetIt.I<HomeViewModel>().addProductToWishlist(productId);
                },
                onTap: () => context.push('/product-detail/${product.id ?? 0}'),
              );
            },
          );
        },
      );
    }

    // Initial or ready state: show categories using Osmea list items
    final categories = state is search_states.SearchReadyState
        ? state.categories
        : const [];
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing12,
        vertical: context.spacing10,
      ),
      children: [
        OsmeaComponents.text(
          'Categories',
          textStyle: OsmeaTextStyle.titleMedium(context),
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        ...categories.map((c) {
          return OsmeaComponents.listItem(
            variant: ListItemVariant.outlined,
            size: ListItemSize.large,
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing12,
              vertical: context.spacing10,
            ),
            margin: EdgeInsets.only(bottom: context.spacing8),
            title: OsmeaComponents.text(
              c.name ?? 'Category',
              textStyle: OsmeaTextStyle.titleSmall(
                context,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
            trailing: Icon(Icons.chevron_right, color: OsmeaColors.pewter),
            onTap: () =>
                viewModel.searchByCategory(c.id ?? 0, name: c.name ?? ''),
          );
        }).toList(),
      ],
    );
  }
}
