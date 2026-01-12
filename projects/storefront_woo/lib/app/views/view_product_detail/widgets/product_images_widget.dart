/*
 * Product Images Widget
 * ---------------------
 * Modern product images carousel with smooth animations and beautiful indicators.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/product_detail_view_model.dart';
import 'package:storefront_woo/gen/translations.g.dart';

/// Modern widget for displaying product images with carousel and overlay actions
class ProductImagesWidget extends StatefulWidget {
  final List<String> imageUrls;
  final ProductDetailViewModel viewModel;
  final Function(String path) goRoute;
  final bool withOverlays;
  final bool isInWishlist;
  final int productId;
  final String? productName;

  const ProductImagesWidget({
    super.key,
    required this.imageUrls,
    required this.viewModel,
    required this.goRoute,
    this.withOverlays = false,
    this.isInWishlist = false,
    this.productId = 0,
    this.productName,
  });

  @override
  State<ProductImagesWidget> createState() => _ProductImagesWidgetState();
}

class _ProductImagesWidgetState extends State<ProductImagesWidget> {
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
    if (widget.imageUrls.isEmpty) {
      return OsmeaComponents.container(
        height: context.dynamicHeight(0.50),
        width: context.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              OsmeaColors.grayMaterial[50]!,
              OsmeaColors.grayMaterial[100]!,
            ],
          ),
        ),
        child: OsmeaComponents.center(
          child: OsmeaComponents.column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.image_outlined,
                size: context.iconSizeExtraHigh * 2,
                color: OsmeaColors.grayMaterial[300]!,
              ),
              OsmeaComponents.sizedBox(height: context.spacing8),
              OsmeaComponents.text(
                'No Image Available',
                textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                  color: OsmeaColors.grayMaterial[400]!,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Elegant image area - refined proportions
    final height = context.dynamicHeight(0.55);

    return OsmeaComponents.sizedBox(
      height: height,
      child: Stack(
        children: [
          // Main image carousel - Pull & Bear style
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final heroTag = index == 0
                  ? 'product-image-${widget.productId}'
                  : 'product_image_${widget.productId}_$index';
              
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ImageDetailScreen(
                        goRoute: widget.goRoute,
                        imageUrls: widget.imageUrls,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: heroTag,
                  child: OsmeaComponents.container(
                    width: context.infinity,
                    height: height,
                    color: OsmeaColors.white,
                    child: OsmeaComponents.image(
                      imageUrl: widget.imageUrls[index],
                      width: context.infinity,
                      height: height,
                      fit: BoxFit.contain,
                      alignment: context.center,
                      placeholder: OsmeaComponents.container(
                        color: OsmeaColors.grayMaterial[50],
                        child: OsmeaComponents.center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: OsmeaColors.black,
                          ),
                        ),
                      ),
                      errorWidget: OsmeaComponents.container(
                        color: OsmeaColors.grayMaterial[50],
                        child: OsmeaComponents.center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: context.iconSizeExtraHigh * 1.5,
                            color: OsmeaColors.grayMaterial[300]!,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Image indicators - elegant and refined
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: context.spacing16,
              left: 0,
              right: 0,
              child: OsmeaComponents.center(
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
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        width: _currentPage == index ? 20 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? OsmeaColors.white
                              : OsmeaColors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Overlay actions - elegant and refined
          if (widget.withOverlays)
            Positioned(
              right: context.spacing12,
              top: context.spacing12,
              child: OsmeaComponents.column(
                children: [
                  // Wishlist button - elegant
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => widget.viewModel.addProductToWishlistFire(widget.productId),
                      borderRadius: BorderRadius.circular(20),
                      child: OsmeaComponents.container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: OsmeaColors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: OsmeaComponents.center(
                          child: Icon(
                            widget.isInWishlist
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: OsmeaColors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing6),
                  // Share button - elegant
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _shareProduct(context),
                      borderRadius: BorderRadius.circular(20),
                      child: OsmeaComponents.container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: OsmeaColors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: OsmeaComponents.center(
                          child: Icon(
                            Icons.share_outlined,
                            color: OsmeaColors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Shares product information
  Future<void> _shareProduct(BuildContext context) async {
    try {
      final name = widget.productName ?? 'Product';
      final shareText = '$name\n\n/product-detail/${widget.productId}';
      
      final success = await ApplicationShareHelper.shareText(
        shareText,
        subject: name,
      );
      
      if (success) {
        debugPrint('✅ Product shared successfully: $name');
      } else {
        debugPrint('⚠️ Failed to share product');
        if (context.mounted) {
          context.snackbarError(context.t.productDetailView.share.failed);
        }
      }
    } catch (e) {
      debugPrint('❌ Error sharing product: $e');
      if (context.mounted) {
        context.snackbarError(context.t.productDetailView.share.error);
      }
    }
  }
}

