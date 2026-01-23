import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/abstract/product_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_categories_api/abstract/store_product_categories_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_brands_api/abstract/store_product_brands_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_brands_api/freezed_model/response/list_product_brands_response_model.dart'
    as brand_models;
import 'package:storefront_woo/gen/translations.g.dart';

/// Widget to load and display categories and brands in search empty state
class SearchEmptyStateWidget extends StatefulWidget {
  final SearchCubit? searchCubit;
  final Future<List<dynamic>> Function(String query)? searchProvider;
  final bool showSkeleton;

  const SearchEmptyStateWidget({
    super.key,
    this.searchCubit,
    this.searchProvider,
    this.showSkeleton = false,
  });

  @override
  State<SearchEmptyStateWidget> createState() => _SearchEmptyStateWidgetState();
}

class _SearchEmptyStateWidgetState extends State<SearchEmptyStateWidget> {
  List<dynamic> _categories = [];
  List<brand_models.ListProductBrandsResponseModel> _brands = [];
  bool _isLoading = true;
  String? _error;
  int _columnCount = 2; // Default to 2 columns for category grid
  bool _isListView = false; // Default to grid view

  @override
  void initState() {
    super.initState();
    _loadCategoriesAndBrands();
  }

  Future<void> _loadCategoriesAndBrands() async {
    try {
      final categoriesService = GetIt.I<StoreProductCategoriesService>();
      final brandsService = GetIt.I<StoreProductBrandsService>();

      final cats = await categoriesService.listProductCategories(
        apiVersion: 'v1',
        perPage: 100,
        hideEmpty: true,
      );

      List<brand_models.ListProductBrandsResponseModel> brandsList = [];
      try {
        final brandsResponse = await brandsService.listProductBrands(
          apiVersion: 'v1',
          perPage: 100,
          hideEmpty: true,
        );
        brandsList = brandsResponse
            .cast<brand_models.ListProductBrandsResponseModel>();
      } catch (e) {
        debugPrint('⚠️ Failed to load brands: $e');
      }

      if (mounted) {
        setState(() {
          _categories = cats;
          _brands = brandsList;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Failed to load categories: $e');
      if (mounted) {
        setState(() {
          _error = context.t.searchView.error.failedToLoadCategories;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _searchByCategory(int categoryId, String categoryName) async {
    debugPrint('📁 Category selected: $categoryName (ID: $categoryId)');

    // Navigate to product list view with category filter
    if (mounted) {
      context.push('/products?category_id=$categoryId');
    }
  }

  Future<void> _searchByBrand(String brandName, int? brandId) async {
    if (widget.searchCubit == null) {
      debugPrint('⚠️ SearchCubit is null, cannot search');
      return;
    }

    debugPrint('🏷️ Brand selected: $brandName (ID: $brandId)');

    try {
      final productService = GetIt.I<ProductService>();

      await widget.searchCubit!.performSearch(
        brandName,
        searchProvider: (query) async {
          debugPrint('🔄 Starting brand product search...');
          List<dynamic> products = [];

          // Approach 1: Try with brand ID and search query combined
          if (brandId != null) {
            debugPrint(
              '🔍 Approach 1: Trying brand=$brandId + search="$brandName"',
            );
            try {
              products = await productService.listAllProducts(
                apiVersion: 'v1',
                brand: brandId.toString(),
                search: brandName,
                perPage: 50,
              );
              debugPrint('📊 Approach 1 result: ${products.length} products');
              if (products.isNotEmpty) {
                debugPrint(
                  '✅ SUCCESS: Found ${products.length} products using brand=$brandId + search',
                );
                return products;
              }
            } catch (e) {
              debugPrint('❌ Approach 1 failed: $e');
            }
          }

          // Approach 2: Try with brand ID only
          if (brandId != null) {
            debugPrint('🔍 Approach 2: Trying brand=$brandId (as string)');
            try {
              products = await productService.listAllProducts(
                apiVersion: 'v1',
                brand: brandId.toString(),
                perPage: 50,
              );
              debugPrint('📊 Approach 2 result: ${products.length} products');
              if (products.isNotEmpty) {
                debugPrint(
                  '✅ SUCCESS: Found ${products.length} products using brand=$brandId',
                );
                return products;
              }
            } catch (e) {
              debugPrint('❌ Approach 2 failed: $e');
            }
          } else {
            debugPrint('⚠️ Brand ID is null, skipping brand ID approach');
          }

          // Approach 3: Try with brand slug and search query
          final brandSlug = brandName.toLowerCase().replaceAll(' ', '-');
          debugPrint(
            '🔍 Approach 3: Trying brand=$brandSlug + search="$brandName"',
          );
          try {
            products = await productService.listAllProducts(
              apiVersion: 'v1',
              brand: brandSlug,
              search: brandName,
              perPage: 50,
            );
            debugPrint('📊 Approach 3 result: ${products.length} products');
            if (products.isNotEmpty) {
              debugPrint(
                '✅ SUCCESS: Found ${products.length} products using brand=$brandSlug + search',
              );
              return products;
            }
          } catch (e) {
            debugPrint('❌ Approach 3 failed: $e');
          }

          // Approach 4: Try with search query only
          debugPrint('🔍 Approach 4: Trying search="$brandName"');
          try {
            products = await productService.listAllProducts(
              apiVersion: 'v1',
              search: brandName,
              perPage: 50,
            );
            debugPrint('📊 Approach 4 result: ${products.length} products');
            if (products.isNotEmpty) {
              debugPrint(
                '✅ SUCCESS: Found ${products.length} products using search="$brandName"',
              );
              return products;
            }
          } catch (e) {
            debugPrint('❌ Approach 4 failed: $e');
          }

          debugPrint(
            '❌ NO RESULTS: No products found for brand "$brandName" (ID: $brandId)',
          );
          return [];
        },
        immediate: true,
      );
    } catch (e) {
      debugPrint('❌ CRITICAL ERROR in _searchByBrand: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show skeleton if requested and loading
    if (widget.showSkeleton && _isLoading) {
      return _SearchEmptyStateSkeleton(
        columnCount: _columnCount,
        isListView: _isListView,
      );
    }

    if (_isLoading) {
      // Use LoadingView from core instead of CircularProgressIndicator
      return LoadingView(
        goRoute: (String path) {
          if (path.contains('home')) {
            context.go('/home');
          } else if (path.contains('product-detail')) {
            context.go('/product-detail');
          } else {
            context.go('/search');
          }
        },
        loadingType: LoadingModelType.networkRequest,
        loadingSteps: [
          context.t.searchView.loading.categories,
          context.t.searchView.loading.brands,
          context.t.searchView.loading.almostReady,
        ],
        stepDuration: const Duration(milliseconds: 500),
        showProgress: true,
        showCancelButton: false,
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: context.paddingHigh,
          child: Column(
            mainAxisAlignment: context.centerMain,
            children: [
              Icon(Icons.error_outline, size: 64, color: OsmeaColors.black),
              SizedBox(height: context.spacing16),
              OsmeaComponents.text(
                _error!,
                textStyle: OsmeaTextStyle.bodyMedium(
                  context,
                ).copyWith(color: OsmeaColors.black),
              ),
              SizedBox(height: context.spacing16),
              OsmeaComponents.button(
                text: context.t.searchView.error.retry,
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _loadCategoriesAndBrands();
                },
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing12,
        vertical: context.spacing10,
      ),
      children: [
        // Brands section with horizontal scroll
        if (_brands.isNotEmpty) ...[
          OsmeaComponents.text(
            context.t.searchView.sections.brands,
            textStyle: OsmeaTextStyle.titleMedium(context),
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: context.horizontalPaddingZero,
              itemCount: _brands.length,
              itemBuilder: (context, index) {
                final brand = _brands[index];
                return _BrandCard(
                  brand: brand,
                  onTap: () => _searchByBrand(brand.name ?? '', brand.id),
                );
              },
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing16),
        ],
        // Categories section
        Padding(
          padding: EdgeInsets.only(right: context.spacing8),
          child: OsmeaComponents.text(
            context.t.searchView.sections.categories,
            textStyle: OsmeaTextStyle.titleMedium(
              context,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        OsmeaComponents.sizedBox(height: context.spacing12),
        // Categories grid or list view
        _isListView
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return _CategoryListItem(
                    category: category,
                    onTap: () {
                      if (category.id != null) {
                        _searchByCategory(category.id as int, category.name ?? '');
                      }
                    },
                  );
                },
              )
            : Wrap(
                spacing: context.spacing12,
                runSpacing: context.spacing12,
                alignment: WrapAlignment.start,
                children: _categories.map((category) {
                  final itemWidth = (MediaQuery.of(context).size.width - 
                                    (context.spacing12 * (_columnCount - 1)) - 
                                    (context.spacing16 * 2)) / _columnCount;
                  return SizedBox(
                    width: itemWidth,
                    child: AspectRatio(
                      aspectRatio: 0.85,
                      child: _CategoryCard(
                        category: category,
                        onTap: () {
                          if (category.id != null) {
                            _searchByCategory(category.id as int, category.name ?? '');
                          }
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }

}

class _BrandCard extends StatelessWidget {
  final brand_models.ListProductBrandsResponseModel brand;
  final VoidCallback? onTap;

  const _BrandCard({required this.brand, this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = brand.image?.thumbnail ?? brand.image?.src;
    final brandName = brand.name ?? context.t.searchView.fallbacks.brand;
    final circleSize = 64.0;

    return Container(
      margin: EdgeInsets.only(right: context.spacing12),
      child: OsmeaComponents.column(
        crossAxisAlignment: context.crossCenter,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: OsmeaColors.black, width: 2),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    OsmeaColors.black,
                    OsmeaColors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: ClipOval(
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? OsmeaComponents.image(
                        imageUrl: imageUrl,
                        width: circleSize,
                        height: circleSize,
                        fit: BoxFit.cover,
                        variant: ImageVariant.normal,
                        cacheWidth: 128,
                        showLoadingIndicator: true,
                        errorWidget: _buildDefaultIcon(context, circleSize),
                      )
                    : _buildDefaultIcon(context, circleSize),
              ),
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          SizedBox(
            width: circleSize + context.spacing12,
            child: OsmeaComponents.text(
              brandName,
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                fontSize: context.fontSizeExtraSmall * context.textScaleFactor,
                fontWeight: FontWeight.w500,
                color: OsmeaColors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultIcon(BuildContext context, double size) {
    return Container(
      width: size,
      height: size,
      color: OsmeaColors.black,
      child: Icon(
        Icons.branding_watermark,
        size: size * 0.5,
        color: OsmeaColors.black,
      ),
    );
  }
}

/// Category card widget with image
class _CategoryCard extends StatelessWidget {
  final dynamic category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = category.image?.src ?? category.image?.thumbnail;
    final categoryName = category.name ?? context.t.searchView.fallbacks.category;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.005),
            blurRadius: 1,
            offset: const Offset(0, 0.5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                imageUrl != null && imageUrl.isNotEmpty
                    ? OsmeaComponents.image(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        variant: ImageVariant.normal,
                        errorWidget: _buildImagePlaceholder(context),
                        placeholder: Container(
                          color: Colors.grey.shade100,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                OsmeaColors.black,
                              ),
                            ),
                          ),
                        ),
                      )
                    : _buildImagePlaceholder(context),
                // Gradient overlay from bottom - config based
                _buildGradientOverlay(context),
                // Category name on gradient
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding: EdgeInsets.all(context.spacing12),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: OsmeaComponents.text(
                        categoryName,
                        textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build gradient overlay from config
  Widget _buildGradientOverlay(BuildContext context) {
    final configHelper = AssetConfigHelper();
    final gradientConfig = configHelper.getObject('search_view_configuration.category_card.gradient_overlay');
    final enabled = gradientConfig?['enabled'] as bool? ?? true;
    
    if (!enabled) {
      return const SizedBox.shrink();
    }
    
    final height = (gradientConfig?['height'] as num?)?.toDouble() ?? 40.0;
    final colorsList = gradientConfig?['colors'] as List<dynamic>?;
    final stopsList = gradientConfig?['stops'] as List<dynamic>?;
    
    List<Color> gradientColors = [
      Colors.black.withOpacity(0.55),
      Colors.black.withOpacity(0.35),
      Colors.black.withOpacity(0.15),
      Colors.transparent,
    ];
    
    List<double> gradientStops = const [0.0, 0.4, 0.7, 1.0];
    
    if (colorsList != null && colorsList.isNotEmpty) {
      gradientColors = colorsList.map((colorMap) {
        final colorString = colorMap['color'] as String? ?? '#000000';
        final opacity = (colorMap['opacity'] as num?)?.toDouble() ?? 1.0;
        Color baseColor = Colors.black;
        if (colorString.startsWith('#')) {
          final hexString = colorString.substring(1);
          if (hexString.length == 6) {
            baseColor = Color(int.parse('FF$hexString', radix: 16));
          } else if (hexString.length == 8) {
            baseColor = Color(int.parse(hexString, radix: 16));
          }
        }
        return baseColor.withOpacity(opacity);
      }).toList();
    }
    
    if (stopsList != null && stopsList.isNotEmpty) {
      gradientStops = stopsList.map((stop) => (stop as num).toDouble()).toList();
    }
    
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: gradientColors,
            stops: gradientStops,
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey.shade100, Colors.grey.shade200],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.category_outlined,
          color: Colors.grey.shade400,
          size: 48,
        ),
      ),
    );
  }
}

/// Category list item widget for list view
class _CategoryListItem extends StatelessWidget {
  final dynamic category;
  final VoidCallback onTap;

  const _CategoryListItem({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = category.image?.src ?? category.image?.thumbnail;
    final categoryName = category.name ?? context.t.searchView.fallbacks.category;

    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing12,
              vertical: context.spacing12,
            ),
            decoration: BoxDecoration(
              color: OsmeaColors.snow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Category image icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade100,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? OsmeaComponents.image(
                            imageUrl: imageUrl,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            variant: ImageVariant.normal,
                            cacheWidth: 112,
                            errorWidget: _buildIconPlaceholder(context),
                          )
                        : _buildIconPlaceholder(context),
                  ),
                ),
                SizedBox(width: context.spacing16),
                // Category name
                Expanded(
                  child: OsmeaComponents.text(
                    categoryName,
                    textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: OsmeaColors.slate,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: context.spacing12),
                // Arrow icon
                Icon(
                  Icons.chevron_right,
                  color: OsmeaColors.pewter,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconPlaceholder(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey.shade200, Colors.grey.shade300],
        ),
      ),
      child: Icon(
        Icons.category_outlined,
        color: Colors.grey.shade500,
        size: 28,
      ),
    );
  }
}

/// Skeleton widget for search empty state
class _SearchEmptyStateSkeleton extends StatefulWidget {
  final int columnCount;
  final bool isListView;

  const _SearchEmptyStateSkeleton({
    required this.columnCount,
    required this.isListView,
  });

  @override
  State<_SearchEmptyStateSkeleton> createState() =>
      _SearchEmptyStateSkeletonState();
}

class _SearchEmptyStateSkeletonState extends State<_SearchEmptyStateSkeleton>
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
        return ListView(
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing12,
            vertical: context.spacing10,
          ),
          children: [
            // Brands section skeleton
            _buildBrandsSkeleton(context),
            OsmeaComponents.sizedBox(height: context.spacing16),
            // Categories section skeleton
            _buildCategoriesSkeleton(context),
          ],
        );
      },
    );
  }

  Widget _buildBrandsSkeleton(BuildContext context) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ShimmerContainer(
          animation: _controller,
          child: Container(
            height: 20,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return _ShimmerContainer(
                animation: _controller,
                child: Container(
                  margin: EdgeInsets.only(right: context.spacing12),
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSkeleton(BuildContext context) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and view toggle skeleton
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ShimmerContainer(
              animation: _controller,
              child: Container(
                height: 20,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (index) => Padding(
                  padding: EdgeInsets.only(left: context.spacing8),
                  child: _ShimmerContainer(
                    animation: _controller,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: context.spacing12),
        // Categories grid/list skeleton
        widget.isListView
            ? _buildCategoryListSkeleton(context)
            : _buildCategoryGridSkeleton(context),
      ],
    );
  }

  Widget _buildCategoryGridSkeleton(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.columnCount,
        crossAxisSpacing: context.spacing12,
        mainAxisSpacing: context.spacing12,
        childAspectRatio: 0.85,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _buildCategoryCardSkeleton(context);
      },
    );
  }

  Widget _buildCategoryListSkeleton(BuildContext context) {
    return OsmeaComponents.column(
      children: List.generate(
        6,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: context.spacing8),
          child: _ShimmerContainer(
            animation: _controller,
            child: Container(
              padding: EdgeInsets.all(context.spacing12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(width: context.spacing16),
                  Expanded(
                    child: Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCardSkeleton(BuildContext context) {
    return _ShimmerGradientContainer(
      animation: _controller,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image skeleton
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            // Gradient overlay skeleton
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
            ),
            // Text skeleton
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.all(context.spacing12),
                child: Container(
                  height: 16,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
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

/// Modern gradient shimmer effect container
class _ShimmerGradientContainer extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _ShimmerGradientContainer({
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ClipRect(
          child: Stack(
            children: [
              child!,
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final value = animation.value;
                    final shimmerWidth = constraints.maxWidth * 0.6;
                    final shimmerPosition = (value * 2 - 1) *
                            (constraints.maxWidth + shimmerWidth) -
                        shimmerWidth;

                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.transparent,
                            Colors.white.withOpacity(0.4),
                            Colors.white.withOpacity(0.6),
                            Colors.white.withOpacity(0.4),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                        ),
                      ),
                      transform: Matrix4.translationValues(shimmerPosition, 0, 0),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      child: child,
    );
  }
}
