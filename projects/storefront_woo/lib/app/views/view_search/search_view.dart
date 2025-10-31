import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_search/models/search_view_model.dart';
import 'package:storefront_woo/app/views/view_search/models/module/states.dart'
    as search_states;
import 'package:storefront_woo/app/views/view_home/widgets/product_card_widget.dart';
import 'package:get_it/get_it.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';

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
            onPressed: () => context.go('/home'),
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
    viewModel.loadCategories();
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
      // Grid layout similar to home product grid
      final bool isTablet = context.allWidth >= 768;
      final int crossAxisCount = isTablet ? 3 : 2;
      final double childAspectRatio = isTablet ? 0.68 : 0.58;
      return GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing12,
          vertical: context.spacing10,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: context.spacing12,
          mainAxisSpacing: context.spacing12,
        ),
        itemCount: state.results.length,
        itemBuilder: (context, index) {
          final product = state.results[index];
          return ProductCardWidget(
            product: product,
            onWishlistTap: () {
              // Use shared HomeViewModel for wishlist to keep messages/state in sync
              GetIt.I<HomeViewModel>().addProductToWishlist(product.id ?? 0);
            },
            onTap: () => context.push('/product-detail/${product.id ?? 0}'),
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
