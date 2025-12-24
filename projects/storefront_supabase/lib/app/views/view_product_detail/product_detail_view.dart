import 'package:storefront_supabase/app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:storefront_supabase/app/models/product_review.dart';
import 'package:storefront_supabase/l10n/app_localizations.dart';

import 'models/view_model.dart';
import 'models/states.dart';

class ProductDetailView
    extends MasterViewCubit<ProductDetailViewModel, ProductDetailState> {
  ProductDetailView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  }) : super(
          coreAppBar: (context, viewModel) {
            final productId = arguments['productId'] as String?;
            return OsmeaComponents.appBar(
              title: (viewModel.state is ProductDetailLoadedState)
                  ? Text((viewModel.state as ProductDetailLoadedState).product.name)
                  : Text(AppLocalizations.of(context)!.productDetail),
              variant: AppBarVariant.primary,
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
                AppBarAction(
                  type: AppBarActionType.favorite,
                  icon: BlocBuilder<ProductDetailViewModel, ProductDetailState>(
                    bloc: viewModel,
                    builder: (context, state) {
                      bool isInWishlist = false;
                      if (state is ProductDetailLoadedState) {
                        isInWishlist = state.isInWishlist;
                      }
                      return Icon(
                        isInWishlist ? Icons.favorite : Icons.favorite_border,
                      );
                    },
                  ),
                  onPressed: () {
                    if (productId != null) {
                      viewModel.toggleFavorite(productId);
                    }
                  },
                ),
              ],
            );
          },
        );

  @override
  void initialContent(
    ProductDetailViewModel viewModel,
    BuildContext context,
  ) {
    final productId = arguments['productId'] as String?;
    final product = arguments['product'] as Product?;
    viewModel.initial(productId: productId, product: product);
  }

  @override
  Widget viewContent(
    BuildContext context,
    ProductDetailViewModel viewModel,
    ProductDetailState state,
  ) {
    final l10n = AppLocalizations.of(context)!;
    if (state is ProductDetailErrorState) {
      return buildError(
        state.message,
        onRetry: () => initialContent(viewModel, context),
      );
    }

    if (state is ProductDetailLoadingState ||
        state is ProductDetailInitialState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ProductDetailLoadedState) {
      final product = state.product;
      final reviews = state.reviews;

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (product.imageUrl.contains('placehold.co'))
                ? Container(
                    height: 300,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.image, color: Colors.grey, size: 50)),
                  )
                : Image.network(
                    product.imageUrl,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 300,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: const Center(child: Icon(Icons.error, color: Colors.red, size: 50)),
                      );
                    },
                  ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  _buildQuantitySelector(context, viewModel, state),
                  const SizedBox(height: 16),
                  OsmeaComponents.button(
                    text: l10n.addToCart,
                    onPressed: () async {
                      final success = await viewModel.addToCart(
                          product.id, state.detailPageQuantity);
                      if (!context.mounted) return;
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.productAddedToCart),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.failedToAddCart),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    variant: ButtonVariant.primary,
                    fullWidth: true,
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    l10n.reviewsCount(reviews.length),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildReviewsList(context, reviews),
                  const SizedBox(height: 24),
                  _buildAddReviewForm(context, viewModel, product.id),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Center(child: Text(l10n.somethingWentWrong));
  }

  Widget _buildQuantitySelector(BuildContext context,
      ProductDetailViewModel viewModel, ProductDetailLoadedState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OsmeaComponents.iconButton(
          onPressed: viewModel.decreaseQuantity,
          icon: const Icon(Icons.remove),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '${state.detailPageQuantity}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        OsmeaComponents.iconButton(
          onPressed: viewModel.increaseQuantity,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildReviewsList(BuildContext context, List<ProductReview> reviews) {
    final l10n = AppLocalizations.of(context)!;
    if (reviews.isEmpty) {
      return Center(child: Text(l10n.noReviewsYet));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review.authorName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat.yMMMd().format(review.createdAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Simple star rating display
                Row(
                  children: List.generate(5, (i) => Icon(
                    i < review.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  )),
                ),
                if (review.title != null && review.title!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(review.title!, style: Theme.of(context).textTheme.titleMedium),
                ],
                if (review.comment != null && review.comment!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(review.comment!),
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddReviewForm(BuildContext context, ProductDetailViewModel viewModel, String productId) {
    final l10n = AppLocalizations.of(context)!;
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.writeReview,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('${l10n.rating}: '),
                ...List.generate(5, (index) => IconButton(
                  icon: Icon(
                    index < viewModel.currentRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      viewModel.setRating(index + 1.0);
                    });
                  },
                )),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: viewModel.reviewTitleController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: l10n.reviewTitle,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: viewModel.reviewCommentController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: l10n.yourReview,
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            OsmeaComponents.button(
              text: l10n.submitReview,
              onPressed: () async {
                final success = await viewModel.submitReview(productId);
                if (!context.mounted) return;
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.reviewSubmitted),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.failedSubmitReview),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
