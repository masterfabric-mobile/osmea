/*
 * Product Images Widget
 * ---------------------
 * Modern product images carousel with smooth animations and beautiful indicators.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, ImageDetailScreen;
import 'package:storefront_supabase/app/views/view_product_detail/models/product_detail_view_model.dart';
import 'package:storefront_supabase/app/views/view_product_detail/widgets/image_detail_screen.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Modern widget for displaying product images with carousel and overlay actions
class ProductImagesWidget extends StatefulWidget {
  final List<String> imageUrls;
  final ProductDetailViewModel viewModel;
  final Function(String path) goRoute;
  final bool withOverlays;
  final bool isInWishlist;
  final String productId;
  final String? productName;

  const ProductImagesWidget({
    super.key,
    required this.imageUrls,
    required this.viewModel,
    required this.goRoute,
    this.withOverlays = false,
    this.isInWishlist = false,
    this.productId = '',
    this.productName,
  });

  @override
  State<ProductImagesWidget> createState() => _ProductImagesWidgetState();
}

class _ProductImagesWidgetState extends State<ProductImagesWidget> {
  late PageController _pageController;
  int _currentPage = 0;
  late bool _localIsInWishlist;

  @override
  void initState() {
    super.initState();
    _localIsInWishlist = widget.isInWishlist;
    _pageController = PageController();
  }

  @override
  void didUpdateWidget(covariant ProductImagesWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isInWishlist != widget.isInWishlist) {
      _localIsInWishlist = widget.isInWishlist;
    }
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

    final height = context.dynamicHeight(0.40);

    return OsmeaComponents.sizedBox(
      height: height,
      child: Stack(
        children: [
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
              
              return Hero(
                tag: heroTag,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ImageDetailScreen(
                      imageUrls: widget.imageUrls,
                      initialIndex: index,
                      goRoute: widget.goRoute,
                    )));
                  },
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

          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: context.spacing16,
              left: 0,
              right: 0,
              child: OsmeaComponents.center(
                child: OsmeaComponents.container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing8,
                    vertical: context.spacing6,
                  ),
                  decoration: BoxDecoration(
                    color: OsmeaColors.black.withValues(alpha: 0.4),
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
            ),

          if (widget.withOverlays)
            Positioned(
              right: context.spacing12,
              top: context.spacing12,
              child: OsmeaComponents.column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (!_localIsInWishlist && Supabase.instance.client.auth.currentUser == null) {
                          context.snackbarWarning(
                            context.resources.loginToAddToFavorites,
                            duration: context.durationLong,
                            style: SnackbarStyle.minimal,
                            position: SnackbarPosition.bottom,
                          );
                          return;
                        }
                        setState(() {
                          _localIsInWishlist = !_localIsInWishlist;
                        });
                        widget.viewModel.addProductToWishlistFire(widget.productId);
                      },
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
                            _localIsInWishlist
                                ? Icons.favorite
                                : Icons.favorite_outline,
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
}