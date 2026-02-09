/*
 * ProductDetailSkeletonWidget
 * ---------------------------
 * Skeleton loading widget for product detail view.
 * Shows shimmer effect placeholders for all product detail components.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'dart:math' as math;

/// Skeleton loading widget for product detail view
class ProductDetailSkeletonWidget extends StatefulWidget {
  const ProductDetailSkeletonWidget({super.key});

  @override
  State<ProductDetailSkeletonWidget> createState() =>
      _ProductDetailSkeletonWidgetState();
}

class _ProductDetailSkeletonWidgetState
    extends State<ProductDetailSkeletonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: context.dynamicHeight(0.10)),
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image gallery skeleton
              _buildImageGallerySkeleton(context),
              OsmeaComponents.sizedBox(height: context.spacing16),
              // Name and price skeleton
              _buildNamePriceSkeleton(context),
              OsmeaComponents.sizedBox(height: context.spacing16),
              // Attributes skeleton
              _buildAttributesSkeleton(context),
              OsmeaComponents.sizedBox(height: context.spacing16),
              // Description skeleton
              _buildDescriptionSkeleton(context),
              OsmeaComponents.sizedBox(height: context.spacing16),
              // Reviews skeleton
              _buildReviewsSkeleton(context),
              OsmeaComponents.sizedBox(height: context.spacing24),
            ],
          ),
        );
      },
    );
  }

  /// Builds image gallery skeleton
  Widget _buildImageGallerySkeleton(BuildContext context) {
    return _ShimmerContainer(
      animation: _controller,
      child: Container(
        height: context.dynamicHeight(0.45), // 45% of screen height
        width: double.infinity,
        color: OsmeaColors.grayMaterial[200],
        child: Stack(
          children: [
            // Main image placeholder
            Container(
              width: double.infinity,
              height: double.infinity,
              color: OsmeaColors.grayMaterial[300],
            ),
            // Image indicators (dots) skeleton at bottom
            Positioned(
              bottom: context.spacing16,
              left: 0,
              right: 0,
              child: OsmeaComponents.row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: context.spacing4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: OsmeaColors.grayMaterial[400],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds name and price skeleton
  Widget _buildNamePriceSkeleton(BuildContext context) {
    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(horizontal: context.spacing16),
      child: _ShimmerContainer(
        animation: _controller,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product name skeleton (2 lines)
            Container(
              height: context.fontSizeLarge * 1.3,
              width: double.infinity,
              decoration: BoxDecoration(
                color: OsmeaColors.grayMaterial[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing4),
            Container(
              height: context.fontSizeLarge * 1.3,
              width: context.allWidth * 0.7,
              decoration: BoxDecoration(
                color: OsmeaColors.grayMaterial[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing12),
            // Price skeleton
            Container(
              height: context.fontSizeLarge * 1.4,
              width: context.allWidth * 0.4,
              decoration: BoxDecoration(
                color: OsmeaColors.grayMaterial[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds attributes skeleton
  Widget _buildAttributesSkeleton(BuildContext context) {
    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(horizontal: context.spacing16),
      child: _ShimmerContainer(
        animation: _controller,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Attribute header skeleton
            Container(
              height: context.fontSizeMedium * 1.2,
              width: context.allWidth * 0.3,
              decoration: BoxDecoration(
                color: OsmeaColors.grayMaterial[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing12),
            // Attribute options skeleton (chips)
            Wrap(
              spacing: context.spacing8,
              runSpacing: context.spacing8,
              children: List.generate(
                4,
                (index) => Container(
                  width: 60 + (index * 10).toDouble(),
                  height: 36,
                  decoration: BoxDecoration(
                    color: OsmeaColors.grayMaterial[200],
                    borderRadius: BorderRadius.circular(context.radiusMedium),
                    border: Border.all(
                      color: OsmeaColors.grayMaterial[300]!,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),
            // Second attribute skeleton
            Container(
              height: context.fontSizeMedium * 1.2,
              width: context.allWidth * 0.25,
              decoration: BoxDecoration(
                color: OsmeaColors.grayMaterial[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing12),
            Wrap(
              spacing: context.spacing8,
              runSpacing: context.spacing8,
              children: List.generate(
                3,
                (index) => Container(
                  width: 70 + (index * 15).toDouble(),
                  height: 36,
                  decoration: BoxDecoration(
                    color: OsmeaColors.grayMaterial[200],
                    borderRadius: BorderRadius.circular(context.radiusMedium),
                    border: Border.all(
                      color: OsmeaColors.grayMaterial[300]!,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds description skeleton
  Widget _buildDescriptionSkeleton(BuildContext context) {
    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(horizontal: context.spacing16),
      child: _ShimmerContainer(
        animation: _controller,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description header skeleton
            Container(
              height: context.fontSizeMedium * 1.2,
              width: context.allWidth * 0.4,
              decoration: BoxDecoration(
                color: OsmeaColors.grayMaterial[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing12),
            // Description lines skeleton
            ...List.generate(
              5,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: context.spacing8),
                child: Container(
                  height: context.fontSizeSmall * 1.3,
                  width: index == 4
                      ? context.allWidth * 0.6
                      : double.infinity,
                  decoration: BoxDecoration(
                    color: OsmeaColors.grayMaterial[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds reviews skeleton
  Widget _buildReviewsSkeleton(BuildContext context) {
    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(horizontal: context.spacing16),
      child: _ShimmerContainer(
        animation: _controller,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reviews header skeleton
            Container(
              height: context.fontSizeMedium * 1.2,
              width: context.allWidth * 0.35,
              decoration: BoxDecoration(
                color: OsmeaColors.grayMaterial[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),
            // Review items skeleton
            ...List.generate(
              3,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: context.spacing16),
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Review header (name + rating)
                    OsmeaComponents.row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: context.fontSizeSmall * 1.2,
                          width: context.allWidth * 0.3,
                          decoration: BoxDecoration(
                            color: OsmeaColors.grayMaterial[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Container(
                          height: context.iconSizeSmall,
                          width: context.allWidth * 0.2,
                          decoration: BoxDecoration(
                            color: OsmeaColors.grayMaterial[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    OsmeaComponents.sizedBox(height: context.spacing8),
                    // Review text skeleton
                    Container(
                      height: context.fontSizeSmall * 1.3,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: OsmeaColors.grayMaterial[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    OsmeaComponents.sizedBox(height: context.spacing4),
                    Container(
                      height: context.fontSizeSmall * 1.3,
                      width: context.allWidth * 0.8,
                      decoration: BoxDecoration(
                        color: OsmeaColors.grayMaterial[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer effect container (reusable)
class _ShimmerContainer extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _ShimmerContainer({
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final value = animation.value;
        final opacity = 0.5 + (math.sin(value * 2 * math.pi) + 1) / 4;
        return Opacity(
          opacity: opacity.clamp(0.3, 0.7),
          child: child,
        );
      },
      child: child,
    );
  }
}