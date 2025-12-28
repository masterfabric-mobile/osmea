/*
 * HomeSkeletonWidget
 * ------------------
 * Skeleton loading widget for home view.
 * Shows shimmer effect placeholders for all home components.
 */

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Skeleton loading widget for home view
class HomeSkeletonWidget extends StatefulWidget {
  const HomeSkeletonWidget({super.key});

  @override
  State<HomeSkeletonWidget> createState() => _HomeSkeletonWidgetState();
}

class _HomeSkeletonWidgetState extends State<HomeSkeletonWidget>
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
        return OsmeaComponents.singleChildScrollView(
        padding: EdgeInsets.only(
          top: context.spacing16,
          bottom: context.spacing24 * 2,
        ),
        child: OsmeaComponents.column(
          children: [
            // Search bar skeleton
            _buildSearchBarSkeleton(context),
            OsmeaComponents.sizedBox(height: context.spacing16),
            
            // Category circles skeleton
            _buildCategoryCirclesSkeleton(context),
            OsmeaComponents.sizedBox(height: context.spacing16),
            
            // Banner carousel skeleton
            _buildBannerSkeleton(context),
            OsmeaComponents.sizedBox(height: context.spacing16),
            
            // Products grid skeleton
            _buildProductsGridSkeleton(context),
          ],
        ),
      );
      },
    );
  }

  Widget _buildSearchBarSkeleton(BuildContext context) {
    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(horizontal: context.spacing20),
      child: _ShimmerContainer(
        animation: _controller,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: OsmeaColors.grayMaterial[200],
            borderRadius: BorderRadius.circular(context.radiusMedium),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCirclesSkeleton(BuildContext context) {
    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(horizontal: context.spacing20),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 8,
          itemBuilder: (context, index) {
            return _ShimmerContainer(
              animation: _controller,
              child: Container(
                margin: EdgeInsets.only(right: context.spacing16),
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: OsmeaColors.grayMaterial[200],
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBannerSkeleton(BuildContext context) {
    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(horizontal: context.spacing20),
      child: _ShimmerContainer(
        animation: _controller,
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            color: OsmeaColors.grayMaterial[200],
            borderRadius: BorderRadius.circular(context.radiusMedium),
          ),
        ),
      ),
    );
  }

  Widget _buildProductsGridSkeleton(BuildContext context) {
    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(horizontal: context.spacing20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: context.spacing12,
          mainAxisSpacing: context.spacing12,
          childAspectRatio: 0.58, // Match actual product grid aspect ratio
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return _ShimmerContainer(
            animation: _controller,
            child: Container(
              decoration: BoxDecoration(
                color: OsmeaColors.grayMaterial[200],
                borderRadius: BorderRadius.circular(context.radiusMedium),
              ),
              clipBehavior: Clip.antiAlias,
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image skeleton - fixed height (60% of card)
                  Container(
                    height: context.height160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: OsmeaColors.grayMaterial[200],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(context.radiusMedium),
                        topRight: Radius.circular(context.radiusMedium),
                      ),
                    ),
                  ),
                  // Content skeleton - fixed height with padding
                  OsmeaComponents.padding(
                    padding: context.paddingLow,
                    child: OsmeaComponents.column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title skeleton
                        Container(
                          height: 14,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: OsmeaColors.grayMaterial[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        OsmeaComponents.sizedBox(height: 6),
                        // Price skeleton
                        Container(
                          height: 16,
                          width: 80,
                          decoration: BoxDecoration(
                            color: OsmeaColors.grayMaterial[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        OsmeaComponents.sizedBox(height: 4),
                        // Rating/badge skeleton
                        Container(
                          height: 12,
                          width: 60,
                          decoration: BoxDecoration(
                            color: OsmeaColors.grayMaterial[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
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
    );
  }
}

/// Shimmer effect container
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

