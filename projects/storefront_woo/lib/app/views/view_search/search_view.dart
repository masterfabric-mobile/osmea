import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_search/models/search_view_model.dart';
import 'package:storefront_woo/app/views/view_search/models/module/states.dart'
    as search_states;
import 'package:get_it/get_it.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
import 'package:storefront_woo/app/views/view_search/widgets/search_results_grid_widget.dart';
import 'package:storefront_woo/app/views/view_search/widgets/search_categories_list_widget.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_brands_api/freezed_model/response/list_product_brands_response_model.dart';

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
          wishlistViewModel.restorePrevious(
            WishlistLoadedState(items: const []),
          );
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
      return buildError(
        state.message,
        onRetry: () => viewModel.loadCategories(),
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
      return SearchResultsGridWidget(products: state.results);
    }

    // Initial or ready state: show categories using Osmea list items
    final categories = state is search_states.SearchReadyState
        ? state.categories
        : const [];
    final brands = state is search_states.SearchReadyState
        ? state.brands
        : const <ListProductBrandsResponseModel>[];
    return SearchCategoriesListWidget(
      categories: categories,
      brands: brands,
      viewModel: viewModel,
    );
  }
}
