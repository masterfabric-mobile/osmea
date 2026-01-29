/*
 * HomeContentWidget
 * -----------------
 * Main content widget for home view.
 * Combines banner, deals of day, recommended section and products grid.
 * Components are ordered by orderID from app_config.json.
 */

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_home/models/module/states.dart';
import 'package:storefront_woo/app/views/view_home/widgets/banner_carousel_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/deals_of_day_carousel_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/recommended_section_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/category_story_circle_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/campaign_card_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/campaign_popup_button_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/promotional_bar_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/bottom_foreground_banner_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/flash_sale_section_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/collections_section_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/brands_section_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/campaign_alert_widget.dart';
import 'package:go_router/go_router.dart';

/// Home component model with orderID
class _HomeComponent {
  final int orderId;
  final Widget widget;
  final String name;

  _HomeComponent({
    required this.orderId,
    required this.widget,
    required this.name,
  });
}

/// Main content widget for home view
class HomeContentWidget extends StatefulWidget {
  final HomeLoadedState state;
  final HomeViewModel viewModel;

  const HomeContentWidget({
    super.key,
    required this.state,
    required this.viewModel,
  });

  @override
  State<HomeContentWidget> createState() => _HomeContentWidgetState();
}

class _HomeContentWidgetState extends State<HomeContentWidget>
    with WidgetsBindingObserver {
  AssetConfigHelper? _configHelper;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadConfig();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App resumed - refresh config
      _refreshConfig();
    }
  }

  @override
  void didUpdateWidget(HomeContentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Widget updated - refresh config to get latest from app_config.json
    if (oldWidget.key != widget.key) {
      _refreshConfig();
    }
  }

  void _loadConfig() {
    _configHelper = AssetConfigHelper();
  }

  void _refreshConfig() {
    debugPrint('🔄 HomeContentWidget: Refreshing configuration from app_config.json');
    setState(() {
      _loadConfig();
    });
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

  /// Gets bottom spacing for a component from config
  /// Returns spacing value in pixels (not EdgeInsets)
  double _getComponentBottomSpacing(
    AssetConfigHelper configHelper,
    String componentName,
  ) {
    try {
      final config = configHelper.getObject('home_view.$componentName');
      final paddingConfig = config?['padding'] as Map<String, dynamic>?;
      if (paddingConfig != null) {
        final bottom = (paddingConfig['bottom'] as num?)?.toDouble();
        if (bottom != null && bottom > 0) {
          return bottom;
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load spacing for $componentName: $e');
    }
    // Default spacing from component_spacing
    return configHelper.getDouble('home_view.component_spacing.bottom', 16.0);
  }

  /// Builds all components sorted by orderID
  List<Widget> _buildOrderedComponents(BuildContext context) {
    final configHelper = _configHelper ?? AssetConfigHelper();
    final List<_HomeComponent> components = [];

    // Search bar is now in appbar, so we don't add it here anymore
    // Category story circles
    if (_isEnabled(configHelper, 'circle_categories')) {
      components.add(
        _HomeComponent(
          orderId: _getOrderId(configHelper, 'circle_categories'),
          widget: CategoryStoryCircleWidget(
            configHelper: configHelper,
            categories: widget.state.categories,
          ),
          name: 'circle_categories',
        ),
      );
    }

    // Banner carousel
    if (_isEnabled(configHelper, 'banner')) {
      components.add(
        _HomeComponent(
          orderId: _getOrderId(configHelper, 'banner'),
          widget: BannerCarouselWidget(configHelper: configHelper),
          name: 'banner',
        ),
      );
    }

    // Promotional bar (2 items side by side)
    if (_isEnabled(configHelper, 'promotional_bar')) {
      components.add(
        _HomeComponent(
          orderId: _getOrderId(configHelper, 'promotional_bar'),
          widget: PromotionalBarWidget(configHelper: configHelper),
          name: 'promotional_bar',
        ),
      );
    }

    // Campaign cards carousel
    if (_isEnabled(configHelper, 'campaign_cards')) {
      components.add(
        _HomeComponent(
          orderId: _getOrderId(configHelper, 'campaign_cards'),
          widget: CampaignCardWidget(configHelper: configHelper),
          name: 'campaign_cards',
        ),
      );
    }

    // Deals of the day carousel
    if (_isEnabled(configHelper, 'deals_of_day')) {
      components.add(
        _HomeComponent(
          orderId: _getOrderId(configHelper, 'deals_of_day'),
          widget: DealsOfDayCarouselWidget(
            configHelper: configHelper,
            allProducts: widget.state.products,
            viewModel: widget.viewModel,
            saleProducts: widget.state.products
                .where((p) => p.onSale == true)
                .toList(),
          ),
          name: 'deals_of_day',
        ),
      );
    }

    // Collections (curated groups) - between Deals and Flash Sale
    if (_isEnabled(configHelper, 'collections')) {
      components.add(
        _HomeComponent(
          orderId: _getOrderId(configHelper, 'collections'),
          widget: CollectionsSectionWidget(
            configHelper: configHelper,
            allProducts: widget.state.products,
            viewModel: widget.viewModel,
          ),
          name: 'collections',
        ),
      );
    }

    // Recommended section
    if (_isEnabled(configHelper, 'recommended')) {
      components.add(
        _HomeComponent(
          orderId: _getOrderId(configHelper, 'recommended'),
          widget: RecommendedSectionWidget(
            configHelper: configHelper,
            allProducts: widget.state.products,
            viewModel: widget.viewModel,
          ),
          name: 'recommended',
        ),
      );
    }

    // Campaign Alert section
    if (_isEnabled(configHelper, 'campaign_alert')) {
      components.add(
        _HomeComponent(
          orderId: _getOrderId(configHelper, 'campaign_alert'),
          widget: CampaignAlertWidget(
            configHelper: configHelper,
          ),
          name: 'campaign_alert',
        ),
      );
    }

    // Flash Sale section
    if (_isEnabled(configHelper, 'flash_sale')) {
      components.add(
        _HomeComponent(
          orderId: _getOrderId(configHelper, 'flash_sale'),
          widget: FlashSaleSectionWidget(
            configHelper: configHelper,
            allProducts: widget.state.products,
            viewModel: widget.viewModel,
          ),
          name: 'flash_sale',
        ),
      );
    }

    // Brands section
    if (_isEnabled(configHelper, 'brands')) {
      components.add(
        _HomeComponent(
          orderId: _getOrderId(configHelper, 'brands'),
          widget: BrandsSectionWidget(
            configHelper: configHelper,
            viewModel: widget.viewModel,
          ),
          name: 'brands',
        ),
      );
    }

    // Sort by orderID
    components.sort((a, b) => a.orderId.compareTo(b.orderId));

    // Convert to widgets list with spacing between components
    // Use SizedBox for spacing instead of padding
    final List<Widget> widgets = [];
    for (int i = 0; i < components.length; i++) {
      final component = components[i];
      
      // Add the component widget
      widgets.add(component.widget);
      
      // Add spacing after component (except for the last one)
      if (i < components.length - 1) {
        final bottomSpacing = _getComponentBottomSpacing(configHelper, component.name);
        if (bottomSpacing > 0) {
          widgets.add(OsmeaComponents.sizedBox(height: bottomSpacing));
        }
      }
    }
    
    return widgets;
  }

  Future<void> _handleRefresh() async {
    await widget.viewModel.initial();
  }

  @override
  Widget build(BuildContext context) {
    final configHelper = _configHelper ?? AssetConfigHelper();
    
    return SizedBox.expand(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // iOS-styled pull-to-refresh
          RefreshIndicator(
            onRefresh: _handleRefresh,
            color: OsmeaColors.black,
            backgroundColor: OsmeaColors.white,
            strokeWidth: 2.0,
            displacement: 40,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: OsmeaComponents.singleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  top: 5, // Extra spacing between app bar and categories
                  bottom: configHelper.getDouble('home_view.component_spacing.bottom', 16.0) * 2,
                ),
                child: OsmeaComponents.column(
                  children: _buildOrderedComponents(context),
                ),
              ),
            ),
          ),
          // Floating campaign popup button - positioned absolutely
          CampaignPopupButtonWidget(
            configHelper: configHelper,
            goRoute: (String path) {
              if (path.contains('products')) {
                context.go('/products');
              } else if (path.contains('product-detail')) {
                context.go(path);
              } else if (path.contains('category')) {
                context.go(path);
              } else {
                context.go(path);
              }
            },
          ),
          // Bottom foreground banner - dismissible banner at bottom
          BottomForegroundBannerWidget(
            configHelper: configHelper,
            goRoute: (String path) {
              if (path.contains('products')) {
                context.go('/products');
              } else if (path.contains('product-detail')) {
                context.go(path);
              } else if (path.contains('category')) {
                context.go(path);
              } else {
                context.go(path);
              }
            },
          ),
        ],
      ),
    );
  }
}
