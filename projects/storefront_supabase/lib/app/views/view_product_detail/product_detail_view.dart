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
import 'package:storefront_supabase/app/views/view_product_detail/models/favorite_action_status.dart'; // Import the enum

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
                 ? OsmeaComponents.text(
                     (viewModel.state as ProductDetailLoadedState).product.name,
                     textStyle: const TextStyle(color: Colors.black),
                   )
                 : OsmeaComponents.text(
                     context.resources.productDetail,
                     textStyle: const TextStyle(color: Colors.black),
                   ),
             variant: AppBarVariant.primary,
             backgroundColor: Colors.white,
             foregroundColor: Colors.black,
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
                       color: Colors.black, // Explicitly set to black
                     );
                   },
                 ),
                 onPressed: () async {
                   if (productId != null) {
                     final status = await viewModel.toggleFavorite(productId);
                     if (!context.mounted) return;
                     String message;
                     SnackbarType type;
                     switch (status) {
                       case FavoriteActionStatus.added:
                         message = context.resources.addedToFavorites;
                         type = SnackbarType.success;
                         break;
                       case FavoriteActionStatus.removed:
                         message = context.resources.removedFromFavorites;
                         type = SnackbarType.info;
                         break;
                       case FavoriteActionStatus.errorLogin:
                         message = context.resources.loginToViewInfo;
                         type = SnackbarType.error;
                         break;
                       case FavoriteActionStatus.errorFailed:
                         message = context.resources.wishlistUpdateFailed;
                         type = SnackbarType.error;
                         break;
                       case FavoriteActionStatus.unknownError:
                         message = context.resources.unexpectedError;
                         type = SnackbarType.error;
                         break;
                     }
                     context.showSnackbar(
                       message: message,
                       type: type,
                     );
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
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImagesCarousel(context, product),
            OsmeaComponents.padding(
              padding: const EdgeInsets.all(16.0),
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.text(
                    product.name,
                    textStyle: Theme.of(context).textTheme.headlineSmall,
                  ),
                  OsmeaComponents.sizedBox(height: 8),
                  _buildPriceDisplay(context, product),
                  OsmeaComponents.sizedBox(height: 16),
                  OsmeaComponents.text(
                    product.description,
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                  ),
                  OsmeaComponents.sizedBox(height: 24),
                  _buildQuantitySelector(context, viewModel, state),
                  OsmeaComponents.sizedBox(height: 16),
                  OsmeaComponents.button(
                    text: resources.addToCart,
                    onPressed: () async {
                      final success = await viewModel.addToCart(
                        product.id,
                        state.detailPageQuantity,
                      );
                      if (!context.mounted) return;
                      if (success) {
                        context.showSnackbar(
                          message: resources.productAddedToCart,
                          type: SnackbarType.success,
                        );
                      } else {
                        context.showSnackbar(
                          message: resources.failedToAddCart,
                          type: SnackbarType.error,
                        );
                      }
                    },
                    variant: ButtonVariant.primary,
                    backgroundColor: Colors.black, // Explicitly set background
                    textColor: Colors.white, // Explicitly set text color
                    fullWidth: true,
                  ),
                  OsmeaComponents.sizedBox(height: 24),
                  const Divider(), // OsmeaComponents.divider() might need context/theme, keeping const Divider() is simpler if equivalent
                  OsmeaComponents.sizedBox(height: 16),
                  OsmeaComponents.text(
                    resources.reviewsCount.replaceAll(
                      '{count}',
                      reviews.length.toString(),
                    ),
                    textStyle: Theme.of(context).textTheme.titleLarge,
                  ),
                  OsmeaComponents.sizedBox(height: 16),
                  _buildReviewsList(context, reviews),
                  OsmeaComponents.sizedBox(height: 24),
                  _buildAddReviewForm(context, viewModel, product.id),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return OsmeaComponents.center(child: OsmeaComponents.text(resources.somethingWentWrong));
  }

  Widget _buildProductImagesCarousel(BuildContext context, Product product) {
    final imageUrls = product.imageUrls.isNotEmpty
        ? product.imageUrls
        : [product.imageUrl];

    if (imageUrls.isEmpty ||
        (imageUrls.length == 1 && imageUrls.first.contains('placehold.co'))) {
      return OsmeaComponents.container(
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

    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.row(
          children: [
            if (hasDiscount) ...[
              OsmeaComponents.text(
                '\$${product.price.toStringAsFixed(2)}',
                textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey[600],
                ),
              ),
              OsmeaComponents.sizedBox(width: 8),
            ],
            OsmeaComponents.text(
              '\$${product.effectivePrice.toStringAsFixed(2)}',
              textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (hasDiscount && product.discountPercentage != null) ...[
          OsmeaComponents.sizedBox(height: 4),
          OsmeaComponents.container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF000000),
              borderRadius: BorderRadius.circular(4),
            ),
            child: OsmeaComponents.text(
              'SALE -${product.discountPercentage!.toStringAsFixed(0)}%',
              textStyle: const TextStyle(
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
    return OsmeaComponents.row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OsmeaComponents.iconButton(
          onPressed: viewModel.decreaseQuantity,
          icon: const Icon(Icons.remove, color: Colors.black),
        ),
        OsmeaComponents.padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: OsmeaComponents.text(
            '${state.detailPageQuantity}',
            textStyle: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        OsmeaComponents.iconButton(
          onPressed: viewModel.increaseQuantity,
          icon: const Icon(Icons.add, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildReviewsList(BuildContext context, List<ProductReview> reviews) {
    final resources = context.resources;
    if (reviews.isEmpty) {
      return OsmeaComponents.center(child: OsmeaComponents.text(resources.noReviewsYet));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: OsmeaComponents.padding(
            padding: const EdgeInsets.all(16.0),
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OsmeaComponents.text(
                      review.authorName,
                      textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    OsmeaComponents.text(
                      DateFormat.yMMMd().format(review.createdAt),
                      textStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                OsmeaComponents.sizedBox(height: 4),
                
                OsmeaComponents.row(
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
                  OsmeaComponents.sizedBox(height: 8),
                  OsmeaComponents.text(
                    review.title!,
                    textStyle: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
                if (review.comment != null && review.comment!.isNotEmpty) ...[
                  OsmeaComponents.sizedBox(height: 8),
                  OsmeaComponents.text(review.comment!),
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
        return OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.text(
              resources.writeReview,
              textStyle: Theme.of(context).textTheme.titleLarge,
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.row(
              children: [
                OsmeaComponents.text('${resources.rating}: '),
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
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.textField(
              controller: viewModel.reviewTitleController,
              label: resources.reviewTitle,
              variant: TextFieldVariant.outlined,
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.textField(
              controller: viewModel.reviewCommentController,
              label: resources.yourReview,
              maxLines: 4,
              variant: TextFieldVariant.outlined,
            ),
            OsmeaComponents.sizedBox(height: 16),
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

    return OsmeaComponents.sizedBox(
      height: height,
      child: OsmeaComponents.stack(
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
                  return OsmeaComponents.container(
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
                  return OsmeaComponents.container(
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
            OsmeaComponents.positioned(
              top: 16,
              right: 16,
              child: OsmeaComponents.container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF000000),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: OsmeaComponents.text(
                  widget.discountPercentage != null
                      ? 'SALE -${widget.discountPercentage!.toStringAsFixed(0)}%'
                      : 'SALE',
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Page indicator (if multiple images)
          if (widget.imageUrls.length > 1)
            OsmeaComponents.positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: OsmeaComponents.container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB((255 * 0.4).round(), 0, 0, 0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: OsmeaComponents.row(
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
                        child: OsmeaComponents.container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _currentPage == index ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.white
                                : Color.fromARGB((255 * 0.5).round(), 255, 255, 255),
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