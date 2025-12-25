import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/app/views/view_categories/products_by_category/states.dart';
import 'package:storefront_supabase/app/views/view_categories/products_by_category/view_model.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class ProductsByCategoryView
    extends MasterViewCubit<ProductsByCategoryViewModel, ProductsByCategoryState> {
  ProductsByCategoryView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  }) : super(
          horizontalPadding: const PaddingVisibility.disabled(),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) {
            final resources = context.resources;
            final categoryName = arguments['categoryName'] as String? ?? resources.products;
            return OsmeaComponents.appBar(
              title: OsmeaComponents.text(categoryName),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              leading: OsmeaComponents.iconButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/categories');
                  }
                },
                icon: const Icon(Icons.arrow_back),
              ),
            );
          },
        );

  @override
  void initialContent(
      ProductsByCategoryViewModel viewModel, BuildContext context) {
    final categoryId = arguments['categoryId'] as String?;
    if (categoryId != null) {
      viewModel.fetchProductsByCategory(categoryId);
    } else {
      // Handle error: categoryId is missing
    }
  }

  @override
  Widget viewContent(BuildContext context,
      ProductsByCategoryViewModel viewModel, ProductsByCategoryState state) {
    final resources = context.resources;
    if (state is ProductsByCategoryError) {
      return buildError(state.message, onRetry: () {
        final categoryId = arguments['categoryId'] as String?;
        if (categoryId != null) {
          viewModel.fetchProductsByCategory(categoryId);
        }
      });
    }

    if (state is ProductsByCategoryLoading ||
        state is ProductsByCategoryInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ProductsByCategoryLoaded) {
      return Column(
        children: [
          // Filters Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Theme.of(context).cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subcategories
                if (state.subCategories.isNotEmpty)
                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: state.subCategories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final subCat = state.subCategories[index];
                        // In drill-down mode, chips aren't 'selected' in the traditional sense,
                        // clicking one enters that category.
                        return ActionChip(
                          label: Text(subCat.name),
                          avatar: const Icon(Icons.arrow_forward_ios, size: 12),
                          onPressed: () => viewModel.navigateToSubcategory(subCat.id),
                        );
                      },
                    ),
                  ),
                if (state.subCategories.isNotEmpty) const SizedBox(height: 8),
                
                // Age/Size Groups - ONLY if showSizeFilter is true
                if (state.showSizeFilter)
                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: viewModel.ageGroups.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final age = viewModel.ageGroups[index];
                        final isSelected = state.selectedSizes.contains(age);
                        return FilterChip(
                          label: Text(age),
                          selected: isSelected,
                          onSelected: (_) => viewModel.toggleSizeFilter(age),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          
          Expanded(
            child: state.products.isEmpty
                ? Center(child: Text(resources.noProductsForSelection))
                : GridView.builder(
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
                                    ? const Center(
                                        child: Icon(Icons.image, color: Colors.grey))
                                    : Image.network(
                                        product.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Center(
                                              child: Icon(Icons.error, color: Colors.red));
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
                  ),
          ),
        ],
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
