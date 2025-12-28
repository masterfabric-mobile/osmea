/*
 * HomeSkeletonWidget
 * ------------------
 * Skeleton loading widget for home view.
 * Shows shimmer effect placeholders for all home components.
 */

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Skeleton component model with orderID
class _SkeletonComponent {
  final int orderId;
  final Widget widget;
  final String name;

  _SkeletonComponent({
    required this.orderId,
    required this.widget,
    required this.name,
  });
}

/// Skeleton loading widget for home view
class HomeSkeletonWidget extends StatefulWidget {
  const HomeSkeletonWidget({super.key});

  @override
  State<HomeSkeletonWidget> createState() => _HomeSkeletonWidgetState();
}

class _HomeSkeletonWidgetState extends State<HomeSkeletonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  AssetConfigHelper? _configHelper;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _loadConfig();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loadConfig() {
    _configHelper = AssetConfigHelper();
  }

  /// Loads component orderID from config
  int _getOrderId(AssetConfigHelper configHelper, String componentName) {
    try {
      final config = configHelper.getObject('home_view.$componentName');
      return config?['order_id'] as int? ?? 999;
    } catch (e) {
      debugPrint('⚠️ Failed to load order_id for $componentName: $e');
      return 999;
    }
  }

  /// Checks if component is enabled
  bool _isEnabled(AssetConfigHelper configHelper, String componentName) {
    try {
      final config = configHelper.getObject('home_view.$componentName');
      return config?['enabled'] as bool? ?? true;
    } catch (e) {
      debugPrint('⚠️ Failed to load enabled for $componentName: $e');
      return true;
    }
  }

  /// Builds all skeleton components sorted by orderID
  List<Widget> _buildOrderedSkeletonComponents(BuildContext context) {
    final configHelper = _configHelper ?? AssetConfigHelper();
    final List<_SkeletonComponent> components = [];

    // Search bar skeleton
    if (_isEnabled(configHelper, 'search')) {
      components.add(
        _SkeletonComponent(
          orderId: _getOrderId(configHelper, 'search'),
          widget: _buildSearchBarSkeleton(context),
          name: 'search',
        ),
      );
    }

    // Category circles skeleton
    if (_isEnabled(configHelper, 'circle_categories')) {
      components.add(
        _SkeletonComponent(
          orderId: _getOrderId(configHelper, 'circle_categories'),
          widget: _buildCategoryCirclesSkeleton(context),
          name: 'circle_categories',
        ),
      );
    }

    // Banner carousel skeleton
    if (_isEnabled(configHelper, 'banner')) {
      components.add(
        _SkeletonComponent(
          orderId: _getOrderId(configHelper, 'banner'),
          widget: _buildBannerSkeleton(context),
          name: 'banner',
        ),
      );
    }

    // Promotional bar skeleton
    if (_isEnabled(configHelper, 'promotional_bar')) {
      components.add(
        _SkeletonComponent(
          orderId: _getOrderId(configHelper, 'promotional_bar'),
          widget: _buildPromotionalBarSkeleton(context),
          name: 'promotional_bar',
        ),
      );
    }

    // Campaign cards skeleton
    if (_isEnabled(configHelper, 'campaign_cards')) {
      components.add(
        _SkeletonComponent(
          orderId: _getOrderId(configHelper, 'campaign_cards'),
          widget: _buildCampaignCardsSkeleton(context),
          name: 'campaign_cards',
        ),
      );
    }

    // Deals of the day skeleton
    if (_isEnabled(configHelper, 'deals_of_day')) {
      components.add(
        _SkeletonComponent(
          orderId: _getOrderId(configHelper, 'deals_of_day'),
          widget: _buildDealsOfDaySkeleton(context),
          name: 'deals_of_day',
        ),
      );
    }

    // Recommended section skeleton
    if (_isEnabled(configHelper, 'recommended')) {
      components.add(
        _SkeletonComponent(
          orderId: _getOrderId(configHelper, 'recommended'),
          widget: _buildProductsGridSkeleton(context),
          name: 'recommended',
        ),
      );
    }

    // Sort by orderID
    components.sort((a, b) => a.orderId.compareTo(b.orderId));

    // Convert to widgets list with spacing
    final List<Widget> widgets = [];
    for (int i = 0; i < components.length; i++) {
      widgets.add(components[i].widget);
      if (i < components.length - 1) {
        widgets.add(OsmeaComponents.sizedBox(height: context.spacing16));
      }
    }

    return widgets;
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
            children: _buildOrderedSkeletonComponents(context),
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

  Widget _buildPromotionalBarSkeleton(BuildContext context) {
    // Get height from config
    double getSkeletonHeight() {
      try {
        final config = _configHelper?.getObject('home_view.promotional_bar');
        final heightStr = config?['height'] as String? ?? 'medium';
        
        switch (heightStr.toLowerCase()) {
          case 'short':
            return 60.0; // Short
          case 'medium':
            return 100.0; // Medium
          case 'tall':
            return 120.0; // Tall
          default:
            return 100.0; // Default: medium
        }
      } catch (e) {
        debugPrint('⚠️ Failed to load height from config: $e');
        return 100.0; // Default: medium
      }
    }

    final skeletonHeight = getSkeletonHeight();

    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(horizontal: context.spacing20),
      child: OsmeaComponents.row(
        children: [
          // Left promotional bar item skeleton
          Expanded(
            child: _ShimmerContainer(
              animation: _controller,
              child: Container(
                margin: EdgeInsets.only(right: context.spacing8),
                height: skeletonHeight,
                decoration: BoxDecoration(
                  color: OsmeaColors.grayMaterial[200],
                  borderRadius: BorderRadius.circular(context.radiusMedium),
                  border: Border.all(
                    color: OsmeaColors.silver.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          // Right promotional bar item skeleton
          Expanded(
            child: _ShimmerContainer(
              animation: _controller,
              child: Container(
                margin: EdgeInsets.only(left: context.spacing8),
                height: skeletonHeight,
                decoration: BoxDecoration(
                  color: OsmeaColors.grayMaterial[200],
                  borderRadius: BorderRadius.circular(context.radiusMedium),
                  border: Border.all(
                    color: OsmeaColors.silver.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignCardsSkeleton(BuildContext context) {
    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(horizontal: context.spacing20),
      child: SizedBox(
        height: 160,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return _ShimmerContainer(
              animation: _controller,
              child: Container(
                margin: EdgeInsets.only(right: context.spacing12),
                width: 280,
                height: 160,
                decoration: BoxDecoration(
                  color: OsmeaColors.grayMaterial[200],
                  borderRadius: BorderRadius.circular(context.radiusMedium),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDealsOfDaySkeleton(BuildContext context) {
    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(horizontal: context.spacing20),
      child: SizedBox(
        height: 280,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return _ShimmerContainer(
              animation: _controller,
              child: Container(
                margin: EdgeInsets.only(right: context.spacing12),
                width: 200,
                height: 280,
                decoration: BoxDecoration(
                  color: OsmeaColors.grayMaterial[200],
                  borderRadius: BorderRadius.circular(context.radiusMedium),
                ),
              ),
            );
          },
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

