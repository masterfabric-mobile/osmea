/*
 * HomeContentWidget
 * -----------------
 * Main content widget for home view.
 * Combines banner, deals of day, recommended section and products grid.
 * Components are ordered by orderID from app_config.json.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_home/models/module/states.dart';
import 'package:storefront_woo/app/views/view_home/widgets/banner_carousel_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/deals_of_day_carousel_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/recommended_section_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/search_bar_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/category_story_circle_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/campaign_card_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/campaign_popup_button_widget.dart';
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

  /// Builds all components sorted by orderID
  List<Widget> _buildOrderedComponents(BuildContext context) {
    final configHelper = _configHelper ?? AssetConfigHelper();
    final List<_HomeComponent> components = [];

    // Search bar
    if (_isEnabled(configHelper, 'search')) {
      components.add(
        _HomeComponent(
          orderId: _getOrderId(configHelper, 'search'),
          widget: SearchBarWidget(configHelper: configHelper),
          name: 'search',
        ),
      );
    }

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

    // Sort by orderID
    components.sort((a, b) => a.orderId.compareTo(b.orderId));

    // Convert to widgets list
    return components.map((c) => c.widget).toList();
  }

  @override
  Widget build(BuildContext context) {
    final configHelper = _configHelper ?? AssetConfigHelper();
    
    return SizedBox.expand(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: OsmeaComponents.singleChildScrollView(
              padding: EdgeInsets.only(
                top: context.spacing16,
                bottom: context.spacing24 * 2,
              ),
              child: OsmeaComponents.column(
                children: _buildOrderedComponents(context),
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
        ],
      ),
    );
  }
}
