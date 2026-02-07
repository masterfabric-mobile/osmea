import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:core/core.dart';

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
        return SingleChildScrollView( // OsmeaComponents might not have singleChildScrollView exposed statically, keeping standard
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing16,
            vertical: context.spacing16,
          ),
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter bar skeleton
              _buildFilterBarSkeleton(context),
              OsmeaComponents.sizedBox(height: context.spacing16),
              // Product grid skeleton
              _buildProductGridSkeleton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterBarSkeleton(BuildContext context) {
    return OsmeaComponents.row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ShimmerContainer(
          animation: _controller,
          child: OsmeaComponents.container(
            height: 32,
            width: 150,
            decoration: BoxDecoration(
              color: OsmeaColors.grayMaterial[200],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        _ShimmerContainer(
          animation: _controller,
          child: OsmeaComponents.container(
            height: 32,
            width: 80,
            decoration: BoxDecoration(
              color: OsmeaColors.grayMaterial[200],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductGridSkeleton(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: context.spacing12,
        mainAxisSpacing: context.spacing12,
        childAspectRatio: 0.65, 
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _buildProductCardSkeleton(context);
      },
    );
  }

  Widget _buildProductCardSkeleton(BuildContext context) {
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        color: OsmeaColors.grayMaterial[50],
        borderRadius: BorderRadius.circular(context.radiusMedium),
      ),
      clipBehavior: Clip.antiAlias,
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _ShimmerContainer(
            animation: _controller,
            child: OsmeaComponents.container(
              height: context.height160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: OsmeaColors.grayMaterial[100],
                borderRadius: context.borderRadiusNormal,
              ),
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          OsmeaComponents.padding(
            padding: context.onlyLeftPaddingLow,
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerContainer(
                  animation: _controller,
                  child: OsmeaComponents.container(
                    height: 16,
                    width: context.allWidth * 0.35,
                    decoration: BoxDecoration(
                      color: OsmeaColors.grayMaterial[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                OsmeaComponents.sizedBox(height: context.spacing4),
                _ShimmerContainer(
                  animation: _controller,
                  child: OsmeaComponents.container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: OsmeaColors.grayMaterial[100],
                      borderRadius: BorderRadius.circular(4),
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

class _ShimmerContainer extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _ShimmerContainer({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final value = animation.value;
        final opacity = 0.5 + (math.sin(value * 2 * math.pi) + 1) / 4;
        return Opacity(opacity: opacity.clamp(0.3, 0.7), child: child);
      },
      child: child,
    );
  }
}