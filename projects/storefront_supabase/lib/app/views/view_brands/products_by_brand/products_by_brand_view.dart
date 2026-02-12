import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';
import 'states.dart';
import 'view_model.dart';

class ProductsByBrandView
    extends MasterViewCubit<ProductsByBrandViewModel, ProductsByBrandState> {
  ProductsByBrandView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  }) : super(
          horizontalPadding: const PaddingVisibility.disabled(),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) {
            String title = '';
            if (viewModel.state is ProductsByBrandLoaded) {
              title = (viewModel.state as ProductsByBrandLoaded).brandName;
            }
            return OsmeaComponents.appBar(
              title: OsmeaComponents.text(
                title,
                color: OsmeaColors.black,
              ),
              backgroundColor: OsmeaColors.white,
              foregroundColor: OsmeaColors.black,
              leading: OsmeaComponents.iconButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },
                icon: const Icon(Icons.arrow_back),
              ),
              actions: [
                if (viewModel.state is ProductsByBrandLoaded)
                  AppBarAction(
                    type: AppBarActionType.favorite,
                    icon: Icon(
                      (viewModel.state as ProductsByBrandLoaded).isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: (viewModel.state as ProductsByBrandLoaded).isFavorite
                          ? OsmeaColors.black
                          : OsmeaColors.black,
                    ),
                    onPressed: () {
                      final brandId = arguments['brandId'] as String?;
                      if (brandId != null) {
                        viewModel.toggleBrandFavorite(brandId);
                      }
                    },
                  ),
              ],
            );
          },
        );

  @override
  void initialContent(
      ProductsByBrandViewModel viewModel, BuildContext context) {
    final brandId = arguments['brandId'] as String?;
    if (brandId != null) {
      viewModel.fetchProductsByBrand(brandId);
    }
  }

  @override
  Widget viewContent(BuildContext context,
      ProductsByBrandViewModel viewModel, ProductsByBrandState state) {
    final resources = context.resources;
    if (state is ProductsByBrandError) {
      return buildError(state.message, onRetry: () {
        final brandId = arguments['brandId'] as String?;
        if (brandId != null) {
          viewModel.fetchProductsByBrand(brandId);
        }
      });
    }

    if (state is ProductsByBrandLoading || state is ProductsByBrandInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ProductsByBrandLoaded) {
      return OsmeaComponents.column(
        children: [
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
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Theme.of(context).dividerColor),
                        ),
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
                                      child: (product.imageUrl.contains('placehold.co'))
                                          ? Center(
                                              child: Icon(Icons.image, color: OsmeaColors.pewter))
                                          : OsmeaComponents.image(
                                              imageUrl: product.imageUrl,
                                              fit: BoxFit.cover,
                                              errorWidget: Center(
                                                  child: Icon(Icons.error,
                                                      color: OsmeaColors.black)),
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
                                              color: OsmeaColors.white,
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
                                                    Localizations.localeOf(context)
                                                        .toString()),
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      decoration:
                                                          TextDecoration.lineThrough,
                                                      color: OsmeaColors.slate,
                                                    ),
                                              ),
                                              OsmeaComponents.sizedBox(width: 4),
                                            ],
                                            OsmeaComponents.text(
                                              PriceHelper.format(
                                                  product.effectivePrice,
                                                  currency,
                                                  Localizations.localeOf(context)
                                                      .toString()),
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: const Color(0xFF000000),
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
