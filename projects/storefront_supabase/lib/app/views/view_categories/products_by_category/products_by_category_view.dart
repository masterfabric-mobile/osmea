import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';
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
              title: OsmeaComponents.text(
                categoryName,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
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
      // 1. If there are subcategories, show them as a vertical list (Navigation Style)
      if (state.subCategories.isNotEmpty) {
        return ListView.builder(
          itemCount: state.subCategories.length,
          itemBuilder: (context, index) {
            final subCat = state.subCategories[index];
            return OsmeaComponents.listItem(
              title: OsmeaComponents.text(subCat.name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate deeper into the hierarchy
                if (subCat.count != null && subCat.count! > 0) {
                  goRoute(
                      '/categories/products/${subCat.id}?name=${Uri.encodeComponent(subCat.name)}');
                } else {
                  context.showSnackbar(
                    message: resources.noProductsForSelection,
                    type: SnackbarType.info,
                  );
                }
              },
            );
          },
        );
      }

      // 2. If no subcategories (Leaf Node), show Products Grid
      return OsmeaComponents.column(
        children: [
          // Size/Age Filters (Only for Fashion/Leaf categories if applicable)
          if (state.showSizeFilter)
            OsmeaComponents.container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Theme.of(context).cardColor,
              child: SizedBox(
                height: 50,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.ageGroups.length,
                  separatorBuilder: (_, __) => OsmeaComponents.sizedBox(width: 8),
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
            ),

          OsmeaComponents.expanded(
            child: state.products.isEmpty
                ? OsmeaComponents.center(child: OsmeaComponents.text(resources.noProductsForSelection))
                : GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      final hasDiscount = product.hasDiscount;
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => goRoute('/product-detail/${product.id}'),
                          child: OsmeaComponents.column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              OsmeaComponents.expanded(
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: (product.imageUrl
                                              .contains('placehold.co'))
                                          ? const Center(
                                              child: Icon(Icons.image,
                                                  color: Colors.grey))
                                          : OsmeaComponents.image(
                                              imageUrl: product.imageUrl,
                                              fit: BoxFit.cover,
                                              errorWidget: const Center(
                                                  child: Icon(Icons.error,
                                                      color: Colors.red)),
                                            ),
                                    ),
                                    if (hasDiscount)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: OsmeaComponents.container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 4,
                                          ),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF000000),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4)),
                                          ),
                                          child: OsmeaComponents.text(
                                            'SALE',
                                            textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
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
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    OsmeaComponents.sizedBox(height: 4),
                                    BlocBuilder<CurrencyCubit, String>(
                                      builder: (context, currency) {
                                        return OsmeaComponents.row(
                                          children: [
                                            if (hasDiscount) ...[
                                              OsmeaComponents.text(
                                                PriceHelper.format(
                                                    product.price,
                                                    currency,
                                                    Localizations.localeOf(
                                                            context)
                                                        .toString()),
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: Colors.grey[600],
                                                    ),
                                              ),
                                              OsmeaComponents.sizedBox(
                                                  width: 4),
                                            ],
                                            OsmeaComponents.text(
                                              PriceHelper.format(
                                                  product.effectivePrice,
                                                  currency,
                                                  Localizations.localeOf(
                                                          context)
                                                      .toString()),
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color:
                                                        const Color(0xFF000000),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        );
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