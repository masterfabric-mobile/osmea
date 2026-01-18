import 'package:storefront_supabase/app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart'
    hide
        BuildContextTranslationsExtension,
        AppLocaleUtils,
        LocaleSettings,
        TranslationProvider;
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:storefront_supabase/app/models/product_review.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

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
                 ? Text(
                     (viewModel.state as ProductDetailLoadedState).product.name,
                   )
                 : Text(context.resources.productDetail),
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
  void initialContent(ProductDetailViewModel viewModel, BuildContext context) {
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
    final resources = context.resources;
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
            _buildProductImagesCarousel(context, product),
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
                  _buildPriceDisplay(context, product),
                  const SizedBox(height: 16),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  _buildQuantitySelector(context, viewModel, state),
                  const SizedBox(height: 16),
                  OsmeaComponents.button(
                    text: resources.addToCart,
                    onPressed: () async {
                      final success = await viewModel.addToCart(
                        product.id,
                        state.detailPageQuantity,
                      );
                      if (!context.mounted) return;
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(resources.productAddedToCart),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(resources.failedToAddCart),
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
                    resources.reviewsCount.replaceAll(
                      '{count}',
                      reviews.length.toString(),
                    ),
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
    return Center(child: Text(resources.somethingWentWrong));
  }

  Widget _buildProductImagesCarousel(BuildContext context, Product product) {
    final imageUrls = product.imageUrls.isNotEmpty
        ? product.imageUrls
        : [product.imageUrl];

    if (imageUrls.isEmpty ||
        (imageUrls.length == 1 && imageUrls.first.contains('placehold.co'))) {
      return Container(
        height: 300,
        width: double.infinity,
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.image, color: Colors.grey, size: 50),
        ),
      );
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return _ProductImagesCarousel(
          imageUrls: imageUrls,
          hasDiscount: product.hasDiscount,
          discountPercentage: product.discountPercentage,
        );
      },
    );
  }

  Widget _buildPriceDisplay(BuildContext context, Product product) {
    final hasDiscount = product.hasDiscount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (hasDiscount) ...[
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              '\$${product.effectivePrice.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (hasDiscount && product.discountPercentage != null) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF000000),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'SALE -${product.discountPercentage!.toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuantitySelector(
    BuildContext context,
    ProductDetailViewModel viewModel,
    ProductDetailLoadedState state,
  ) {
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
    final resources = context.resources;
    if (reviews.isEmpty) {
      return Center(child: Text(resources.noReviewsYet));
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < review.rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    ),
                  ),
                ),
                if (review.title != null && review.title!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    review.title!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
                if (review.comment != null && review.comment!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(review.comment!),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddReviewForm(
    BuildContext context,
    ProductDetailViewModel viewModel,
    String productId,
  ) {
    final resources = context.resources;
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resources.writeReview,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('${resources.rating}: '),
                ...List.generate(
                  5,
                  (index) => IconButton(
                    icon: Icon(
                      index < viewModel.currentRating
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        viewModel.setRating(index + 1.0);
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: viewModel.reviewTitleController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: resources.reviewTitle,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: viewModel.reviewCommentController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: resources.yourReview,
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            OsmeaComponents.button(
              text: resources.submitReview,
              onPressed: () async {
                final success = await viewModel.submitReview(productId);
                if (!context.mounted) return;
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(resources.reviewSubmitted),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(resources.failedSubmitReview),
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

/// Product Images Carousel with Page Indicator
class _ProductImagesCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final bool hasDiscount;
  final double? discountPercentage;

  const _ProductImagesCarousel({
    required this.imageUrls,
    required this.hasDiscount,
    this.discountPercentage,
  });

  @override
  State<_ProductImagesCarousel> createState() => _ProductImagesCarouselState();
}

class _ProductImagesCarouselState extends State<_ProductImagesCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = 300.0;

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          // Image carousel
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                widget.imageUrls[index],
                height: height,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: height,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.error, color: Colors.red, size: 50),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: height,
                    width: double.infinity,
                    color: Colors.grey[100],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // SALE badge (only on first image)
          if (widget.hasDiscount && _currentPage == 0)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF000000),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.discountPercentage != null
                      ? 'SALE -${widget.discountPercentage!.toStringAsFixed(0)}%'
                      : 'SALE',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Page indicator (if multiple images)
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      widget.imageUrls.length,
                      (index) => GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _currentPage == index ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
