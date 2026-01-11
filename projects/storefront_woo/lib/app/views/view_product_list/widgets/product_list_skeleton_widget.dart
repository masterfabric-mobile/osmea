/*
 * ProductListSkeletonWidget
 * -------------------------
 * Skeleton loading widget for product list view.
 * Shows shimmer effect placeholders for product grid/list and filters.
 */

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Skeleton loading widget for product list view
class ProductListSkeletonWidget extends StatefulWidget {
  final bool isGridView;

  const ProductListSkeletonWidget({
    super.key,
    this.isGridView = true,
  });

  @override
  State<ProductListSkeletonWidget> createState() =>
      _ProductListSkeletonWidgetState();
}

class _ProductListSkeletonWidgetState extends State<ProductListSkeletonWidget>
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
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing16,
            vertical: context.spacing16,
          ),
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter chips skeleton
              _buildFilterChipsSkeleton(context),
              OsmeaComponents.sizedBox(height: context.spacing16),
              // Product grid/list skeleton
              if (widget.isGridView)
                _buildProductGridSkeleton(context)
              else
                _buildProductListSkeleton(context),
            ],
          ),
        );
      },
    );
  }

  /// Builds filter chips skeleton
  Widget _buildFilterChipsSkeleton(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return _ShimmerContainer(
            animation: _controller,
            child: Container(
              margin: EdgeInsets.only(right: context.spacing8),
              width: 80 + (index * 20).toDouble(),
              height: 40,
              decoration: BoxDecoration(
                color: OsmeaColors.grayMaterial[200],
                borderRadius: BorderRadius.circular(context.radiusMedium),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds product grid skeleton
  Widget _buildProductGridSkeleton(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: context.spacing12,
        mainAxisSpacing: context.spacing12,
        childAspectRatio: 0.58, // Match actual product card aspect ratio
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _ShimmerContainer(
          animation: _controller,
          child: _buildProductCardSkeleton(context),
        );
      },
    );
  }

  /// Builds product list skeleton (vertical list)
  Widget _buildProductListSkeleton(BuildContext context) {
    return OsmeaComponents.column(
      children: List.generate(
        6,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: context.spacing12),
          child: _ShimmerContainer(
            animation: _controller,
            child: _buildProductListItemSkeleton(context),
          ),
        ),
      ),
    );
  }

  /// Builds a single product card skeleton (for grid)
  Widget _buildProductCardSkeleton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: OsmeaColors.grayMaterial[200],
        borderRadius: BorderRadius.circular(context.radiusMedium),
      ),
      clipBehavior: Clip.antiAlias,
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton - 60% of card height
          Container(
            height: (context.height160 + context.spacing10) * 0.6,
            width: double.infinity,
            color: OsmeaColors.grayMaterial[300],
          ),
          // Content skeleton - 40% of card height
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(context.spacing8),
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title skeleton
                  Container(
                    height: context.fontSizeSmall * 1.2,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: OsmeaColors.grayMaterial[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing4),
                  Container(
                    height: context.fontSizeSmall * 1.2,
                    width: context.allWidth * 0.6,
                    decoration: BoxDecoration(
                      color: OsmeaColors.grayMaterial[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing8),
                  // Price skeleton
                  Container(
                    height: context.fontSizeMedium * 1.2,
                    width: context.allWidth * 0.4,
                    decoration: BoxDecoration(
                      color: OsmeaColors.grayMaterial[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing8),
                  // Rating/badge skeleton
                  Container(
                    height: context.iconSizeSmall,
                    width: context.allWidth * 0.5,
                    decoration: BoxDecoration(
                      color: OsmeaColors.grayMaterial[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a single product list item skeleton (for list view)
  Widget _buildProductListItemSkeleton(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: OsmeaColors.grayMaterial[200],
        borderRadius: BorderRadius.circular(context.radiusMedium),
      ),
      child: OsmeaComponents.row(
        children: [
          // Image skeleton
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: OsmeaColors.grayMaterial[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(context.radiusMedium),
                bottomLeft: Radius.circular(context.radiusMedium),
              ),
            ),
          ),
          // Content skeleton
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(context.spacing12),
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title skeleton
                  Container(
                    height: context.fontSizeMedium * 1.2,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: OsmeaColors.grayMaterial[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing4),
                  Container(
                    height: context.fontSizeSmall * 1.2,
                    width: context.allWidth * 0.7,
                    decoration: BoxDecoration(
                      color: OsmeaColors.grayMaterial[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing8),
                  // Price and rating skeleton
                  OsmeaComponents.row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: context.fontSizeMedium * 1.2,
                        width: context.allWidth * 0.3,
                        decoration: BoxDecoration(
                          color: OsmeaColors.grayMaterial[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        height: context.iconSizeSmall,
                        width: context.allWidth * 0.2,
                        decoration: BoxDecoration(
                          color: OsmeaColors.grayMaterial[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer effect container (reusable from home skeleton)
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
