import 'package:flutter/material.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:example/styles/app_theme.dart';

class ModernSidebar extends StatefulWidget {
  final bool expanded;
  final ApiService? selectedService;
  final Function(ApiService) onServiceSelected;
  final Animation<double> animation;

  const ModernSidebar({
    super.key,
    required this.expanded,
    required this.selectedService,
    required this.onServiceSelected,
    required this.animation,
  });

  @override
  State<ModernSidebar> createState() => _ModernSidebarState();
}

class _ModernSidebarState extends State<ModernSidebar>
    with SingleTickerProviderStateMixin {
  ApiCategory? _selectedMainCategory;
  ApiCategory? _selectedCategory;
  String? _selectedSubcategory;
  late AnimationController _categoryAnimationController;
  late Animation<double> _categoryAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _isDisposed = false; // Track disposal state

  @override
  void initState() {
    super.initState();
    _categoryAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _categoryAnimation = CurvedAnimation(
      parent: _categoryAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _isDisposed = true; // Mark as disposed
    _categoryAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _selectMainCategory(ApiCategory mainCategory) {
    setState(() {
      if (_selectedMainCategory == mainCategory) {
        _selectedMainCategory = null;
        _selectedCategory = null;
        _selectedSubcategory = null;
        _categoryAnimationController.reverse();
      } else {
        _selectedMainCategory = mainCategory;
        _selectedCategory = null;
        _selectedSubcategory = null;
        _categoryAnimationController.forward();
      }
    });
  }

  void _selectCategory(ApiCategory category) {
    setState(() {
      if (_selectedCategory == category) {
        _selectedCategory = null;
        _selectedSubcategory = null;
        _categoryAnimationController.reverse();
      } else {
        _selectedCategory = category;
        _selectedSubcategory = null;
        _categoryAnimationController.forward();
      }
    });
  }

  void _selectSubcategory(String subcategory) {
    setState(() {
      _selectedSubcategory = subcategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isDisposed) {
      return const SizedBox.shrink(); // Prevent rendering after disposal
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 280;
        final isMobile = constraints.maxHeight < 600;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                offset: const Offset(2, 0),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            children: [
              // Responsive Sidebar Header
              Container(
                height: isMobile ? 60 : 80,
                padding: EdgeInsets.all(isNarrow ? 12 : 16),
                decoration: BoxDecoration(
                  gradient: AppTheme.createGradient(
                    AppTheme.primaryColor,
                    AppTheme.primaryVariant,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isNarrow ? 8 : 12),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: AppTheme.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.explore_rounded,
                        color: Colors.white,
                        size: isNarrow ? 20 : 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'API Explorer',
                            style: TextStyle(
                              fontSize: isNarrow ? 16 : 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (!isNarrow)
                            Text(
                              'Browse and test APIs',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: .8),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Responsive Get Started Section
              if (widget.selectedService == null && widget.expanded)
                Container(
                  margin: EdgeInsets.all(isNarrow ? 12 : 16),
                  padding: EdgeInsets.all(isNarrow ? 16 : 20),
                  decoration: BoxDecoration(
                    gradient: AppTheme.createGradient(
                      AppTheme.primaryColor.withValues(alpha: 0.05),
                      AppTheme.primaryVariant.withValues(alpha: 0.02),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isNarrow ? 10 : 12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.01),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.touch_app_rounded,
                          size: isNarrow ? 20 : 24,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      SizedBox(height: isNarrow ? 8 : 12),
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: isNarrow ? 14 : 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isNarrow ? 4 : 6),
                      Text(
                        'Select a category below to explore available APIs',
                        style: TextStyle(
                          fontSize: isNarrow ? 11 : 12,
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withValues(alpha: 0.7),
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      SizedBox(height: isNarrow ? 8 : 12),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isNarrow ? 8 : 12,
                          vertical: isNarrow ? 4 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.primaryColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_downward_rounded,
                              size: isNarrow ? 12 : 14,
                              color: AppTheme.primaryColor,
                            ),
                            SizedBox(width: isNarrow ? 4 : 6),
                            Text(
                              'Choose below',
                              style: TextStyle(
                                fontSize: isNarrow ? 10 : 11,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Selection Guidance when category is selected but no subcategory
              if (_selectedCategory != null &&
                  _selectedSubcategory == null &&
                  widget.expanded)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: isNarrow ? 12 : 16),
                  padding: EdgeInsets.all(isNarrow ? 12 : 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: isNarrow ? 16 : 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      SizedBox(width: isNarrow ? 6 : 8),
                      Expanded(
                        child: Text(
                          'Select a subcategory to view available APIs',
                          style: TextStyle(
                            fontSize: isNarrow ? 11 : 12,
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),

              // Service Selection Guidance when subcategory is selected
              if (_selectedSubcategory != null &&
                  widget.selectedService == null &&
                  widget.expanded)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: isNarrow ? 12 : 16),
                  padding: EdgeInsets.all(isNarrow ? 12 : 16),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.successColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: isNarrow ? 16 : 18,
                        color: AppTheme.successColor,
                      ),
                      SizedBox(width: isNarrow ? 6 : 8),
                      Expanded(
                        child: Text(
                          'Great! Now select an API service to start testing',
                          style: TextStyle(
                            fontSize: isNarrow ? 11 : 12,
                            color: AppTheme.successColor,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),

              // Categories List
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(isNarrow ? 6 : 8),
                    itemCount: ApiServiceRegistry.categories.length,
                    itemBuilder: (context, mainIndex) {
                      final mainCategory =
                          ApiServiceRegistry.categories[mainIndex];
                      final isMainSelected =
                          _selectedMainCategory == mainCategory;
                      final subCategories = mainCategory == ApiCategory.shopify
                          ? ApiServiceRegistry.getShopifyCategories()
                          : ApiServiceRegistry.getWooCommerceCategories();

                      return Column(
                        children: [
                          // Main Category Header
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isMainSelected
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.03)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              dense: !widget.expanded || isMobile,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal:
                                    widget.expanded ? (isNarrow ? 12 : 16) : 8,
                                vertical: isMobile ? 2 : 4,
                              ),
                              leading: Icon(
                                _getCategoryIcon(mainCategory),
                                color: isMainSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).iconTheme.color,
                                size: isNarrow ? 20 : 22,
                              ),
                              title: widget.expanded
                                  ? Text(
                                      mainCategory.displayName,
                                      style: TextStyle(
                                        color: isMainSelected
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.color,
                                        fontWeight: isMainSelected
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                        fontSize: isNarrow ? 13 : 15,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : null,
                              trailing: widget.expanded
                                  ? AnimatedRotation(
                                      turns: isMainSelected ? 0.25 : 0,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: Icon(
                                        Icons.chevron_right,
                                        size: isNarrow ? 16 : 18,
                                        color: isMainSelected
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Theme.of(context).iconTheme.color,
                                      ),
                                    )
                                  : null,
                              onTap: () => _selectMainCategory(mainCategory),
                            ),
                          ),

                          if (isMainSelected && widget.expanded)
                            AnimatedBuilder(
                              animation: _categoryAnimation,
                              builder: (context, child) {
                                return SizeTransition(
                                  sizeFactor: _categoryAnimation,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: isNarrow ? 16 : 24,
                                      bottom: isNarrow ? 6 : 8,
                                    ),
                                    child: Column(
                                      children: subCategories.map((category) {
                                        final isSelected =
                                            _selectedCategory == category;
                                        final subcategories = ApiServiceRegistry
                                            .getSubcategoriesByCategory(
                                                category);
                                        return Column(
                                          children: [
                                            // Category Header
                                            ListTile(
                                              dense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: isNarrow ? 12 : 16,
                                                vertical: isMobile ? 2 : 4,
                                              ),
                                              leading: Icon(
                                                _getCategoryIcon(category),
                                                color: isSelected
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Theme.of(context)
                                                        .iconTheme
                                                        .color,
                                                size: isNarrow ? 18 : 20,
                                              ),
                                              title: Text(
                                                category.displayName,
                                                style: TextStyle(
                                                  color: isSelected
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.color,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w600
                                                      : FontWeight.w500,
                                                  fontSize: isNarrow ? 12 : 14,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              trailing: subcategories.isNotEmpty
                                                  ? AnimatedRotation(
                                                      turns:
                                                          isSelected ? 0.25 : 0,
                                                      duration: const Duration(
                                                          milliseconds: 200),
                                                      child: Icon(
                                                        Icons.chevron_right,
                                                        size:
                                                            isNarrow ? 14 : 16,
                                                        color: isSelected
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .primary
                                                            : Theme.of(context)
                                                                .iconTheme
                                                                .color,
                                                      ),
                                                    )
                                                  : null,
                                              onTap: () =>
                                                  _selectCategory(category),
                                            ),

                                            // Subcategories with animation
                                            if (isSelected && widget.expanded)
                                              AnimatedBuilder(
                                                animation: _categoryAnimation,
                                                builder: (context, child) {
                                                  return SizeTransition(
                                                    sizeFactor:
                                                        _categoryAnimation,
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                        left:
                                                            isNarrow ? 16 : 24,
                                                        bottom:
                                                            isNarrow ? 6 : 8,
                                                      ),
                                                      child: Column(
                                                        children: subcategories
                                                            .map((subcategory) {
                                                          final services =
                                                              ApiServiceRegistry
                                                                  .getBySubcategory(
                                                                      category,
                                                                      subcategory);
                                                          final isSubSelected =
                                                              _selectedSubcategory ==
                                                                  subcategory;
                                                          return Column(
                                                            children: [
                                                              // Subcategory Header
                                                              ListTile(
                                                                dense: true,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      isNarrow
                                                                          ? 12
                                                                          : 16,
                                                                  vertical:
                                                                      isMobile
                                                                          ? 2
                                                                          : 4,
                                                                ),
                                                                title: Text(
                                                                  subcategory,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        isNarrow
                                                                            ? 12
                                                                            : 14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: isSubSelected
                                                                        ? Theme.of(context)
                                                                            .colorScheme
                                                                            .primary
                                                                        : Theme.of(context)
                                                                            .textTheme
                                                                            .bodyMedium
                                                                            ?.color,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                trailing:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        isNarrow
                                                                            ? 6
                                                                            : 8,
                                                                    vertical: 2,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary
                                                                        .withValues(
                                                                            alpha:
                                                                                0.1),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(4),
                                                                  ),
                                                                  child: Text(
                                                                    '${services.length}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          isNarrow
                                                                              ? 10
                                                                              : 12,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .primary,
                                                                    ),
                                                                  ),
                                                                ),
                                                                onTap: () =>
                                                                    _selectSubcategory(
                                                                        subcategory),
                                                              ),

                                                              // Services
                                                              if (isSubSelected)
                                                                ...services
                                                                    .asMap()
                                                                    .entries
                                                                    .map(
                                                                        (entry) {
                                                                  final index =
                                                                      entry.key;
                                                                  final service =
                                                                      entry
                                                                          .value;
                                                                  final isServiceSelected =
                                                                      widget.selectedService ==
                                                                          service;
                                                                  return AnimatedContainer(
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            200 +
                                                                                (index * 50)),
                                                                    margin:
                                                                        EdgeInsets
                                                                            .only(
                                                                      left: isNarrow
                                                                          ? 12
                                                                          : 16,
                                                                      bottom:
                                                                          isNarrow
                                                                              ? 2
                                                                              : 4,
                                                                    ),
                                                                    child:
                                                                        Material(
                                                                      color: Colors
                                                                          .transparent,
                                                                      child:
                                                                          InkWell(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        onTap: () =>
                                                                            widget.onServiceSelected(service),
                                                                        child:
                                                                            Container(
                                                                          padding: EdgeInsets.all(isNarrow
                                                                              ? 6
                                                                              : 8),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color: isServiceSelected
                                                                                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                                                                                : Colors.transparent,
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                            border: isServiceSelected
                                                                                ? Border.all(
                                                                                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                                                                                    width: 1,
                                                                                  )
                                                                                : null,
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Container(
                                                                                width: isNarrow ? 3 : 4,
                                                                                height: isNarrow ? 12 : 16,
                                                                                decoration: BoxDecoration(
                                                                                  color: isServiceSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                                                                                  borderRadius: BorderRadius.circular(2),
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: isNarrow ? 6 : 8),
                                                                              Expanded(
                                                                                child: Text(
                                                                                  service.name,
                                                                                  style: TextStyle(
                                                                                    fontSize: isNarrow ? 11 : 13,
                                                                                    color: isServiceSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).textTheme.bodyMedium?.color,
                                                                                    fontWeight: isServiceSelected ? FontWeight.w500 : FontWeight.w400,
                                                                                  ),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  maxLines: isNarrow ? 2 : 1,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }),
                                                            ],
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon(ApiCategory category) {
    switch (category) {
      case ApiCategory.shopify:
        return Icons.shopping_bag_rounded;
      case ApiCategory.woocommerce:
        return Icons.shopping_cart_checkout_rounded;
      case ApiCategory.access:
        return Icons.security_rounded;
      case ApiCategory.storefront:
        return Icons.storefront_rounded;
      case ApiCategory.admin:
        return Icons.admin_panel_settings_rounded;
      case ApiCategory.catalog:
        return Icons.category_rounded;
      case ApiCategory.customer:
        return Icons.people_rounded;
      case ApiCategory.discounts:
        return Icons.local_offer_rounded;
      case ApiCategory.billing:
        return Icons.payment_rounded;
      case ApiCategory.events:
        return Icons.event_rounded;
      case ApiCategory.inventory:
        return Icons.inventory_rounded;
      case ApiCategory.orders:
        return Icons.shopping_cart_rounded;
      case ApiCategory.marketingEvent:
        return Icons.campaign_rounded;
      case ApiCategory.giftCard:
        return Icons.card_giftcard_rounded;
      case ApiCategory.metafield:
        return Icons.label_rounded;
      case ApiCategory.onlineStore:
        return Icons.store_rounded;
      case ApiCategory.products:
        return Icons.category_rounded;
      case ApiCategory.storeProperties:
        return Icons.settings_rounded;
      case ApiCategory.tendertransaction:
        return Icons.account_balance_wallet_rounded;
      case ApiCategory.webhooks:
        return Icons.webhook_rounded;
      case ApiCategory.woocommerceCoupons:
        return Icons.local_offer_rounded;
      case ApiCategory.woocommerceProducts:
        return Icons.category_rounded;
      case ApiCategory.woocommerceOrders:
        return Icons.shopping_cart_rounded;
      case ApiCategory.woocommerceCustomers:
        return Icons.people_rounded;
      case ApiCategory.woocommerceWebhooks:
        return Icons.webhook_rounded;
      case ApiCategory.woocommerceSystemStatus:
        return Icons.system_update_rounded;
    }
  }
}
