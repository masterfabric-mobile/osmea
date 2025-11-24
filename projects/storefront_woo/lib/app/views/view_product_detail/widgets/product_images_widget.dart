/*
 * Product Images Widget
 * ---------------------
 * Widget for displaying product images in a carousel with overlay actions.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/product_detail_view_model.dart';

/// Widget for displaying product images with carousel and overlay actions
class ProductImagesWidget extends StatelessWidget {
  final List<String> imageUrls;
  final ProductDetailViewModel viewModel;
  final Function(String path) goRoute;
  final bool withOverlays;
  final bool isInWishlist;
  final int productId;

  const ProductImagesWidget({
    super.key,
    required this.imageUrls,
    required this.viewModel,
    required this.goRoute,
    this.withOverlays = false,
    this.isInWishlist = false,
    this.productId = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return OsmeaComponents.container(
        height: context.dynamicHeight(0.45),
        width: context.infinity,
        color: OsmeaColors.white,
        child: OsmeaComponents.center(
          child: Icon(
            Icons.image,
            size: context.iconSizeExtraHigh * 2.5,
            color: OsmeaColors.pewter.withOpacity(context.alpha30),
          ),
        ),
      );
    }

    // Better aspect ratio for product images - taller for better visibility
    final height = context.allHeight < 700
        ? context.dynamicHeight(0.45)
        : context.dynamicHeight(0.50);

    final pager = PageView.builder(
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ImageDetailScreen(
                  goRoute: goRoute,
                  imageUrls: imageUrls,
                  initialIndex: index,
                ),
              ),
            );
          },
          child: OsmeaComponents.container(
            width: context.infinity,
            height: height,
            color: OsmeaColors.white,
            child: OsmeaComponents.center(
              child: OsmeaComponents.image(
                imageUrl: imageUrls[index],
                width: context.infinity,
                height: height,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                placeholder: OsmeaComponents.container(
                  color: OsmeaColors.white,
                  child: OsmeaComponents.center(
                    child: Icon(
                      Icons.image,
                      size: context.iconSizeExtraHigh * 2.5,
                      color: OsmeaColors.pewter.withOpacity(context.alpha30),
                    ),
                  ),
                ),
                errorWidget: OsmeaComponents.container(
                  color: OsmeaColors.white,
                  child: OsmeaComponents.center(
                    child: Icon(
                      Icons.broken_image,
                      size: context.iconSizeExtraHigh * 2.5,
                      color: OsmeaColors.pewter.withOpacity(context.alpha30),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (!withOverlays) {
      return OsmeaComponents.sizedBox(height: height, child: pager);
    }

    return OsmeaComponents.sizedBox(
      height: height,
      child: Stack(
        children: [
          pager,
          Positioned(
            right: context.spacing10,
            top: context.spacing10,
            child: OsmeaComponents.column(
              children: [
                OsmeaComponents.iconButton(
                  icon: Icon(
                    isInWishlist ? Icons.favorite : Icons.favorite_outline,
                    color: isInWishlist
                        ? OsmeaColors.nordicBlue
                        : OsmeaColors.thunder,
                  ),
                  size: ButtonSize.medium,
                  variant: ButtonVariant.ghost,
                  backgroundColor: OsmeaColors.white.withValues(alpha: 0.9),
                  borderRadius: context.width24,
                  onPressed: () =>
                      viewModel.addProductToWishlistFire(productId),
                ),
                OsmeaComponents.sizedBox(height: context.spacing6),
                OsmeaComponents.iconButton(
                  icon: const Icon(Icons.share_outlined),
                  size: ButtonSize.medium,
                  variant: ButtonVariant.ghost,
                  backgroundColor: OsmeaColors.white.withValues(alpha: 0.9),
                  borderRadius: context.width24,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

