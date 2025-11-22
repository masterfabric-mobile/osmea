import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/abstract/product_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_categories_api/abstract/store_product_categories_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_brands_api/abstract/store_product_brands_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_brands_api/freezed_model/response/list_product_brands_response_model.dart'
    as brand_models;

/// Widget to load and display categories and brands in search empty state
class SearchEmptyStateWidget extends StatefulWidget {
  final SearchCubit? searchCubit;

  const SearchEmptyStateWidget({super.key, this.searchCubit});

  @override
  State<SearchEmptyStateWidget> createState() => _SearchEmptyStateWidgetState();
}

class _SearchEmptyStateWidgetState extends State<SearchEmptyStateWidget> {
  List<dynamic> _categories = [];
  List<brand_models.ListProductBrandsResponseModel> _brands = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCategoriesAndBrands();
  }

  Future<void> _loadCategoriesAndBrands() async {
    try {
      final categoriesService = GetIt.I<StoreProductCategoriesService>();
      final brandsService = GetIt.I<StoreProductBrandsService>();

      // Load categories and brands separately to handle errors properly
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
          _error = 'Failed to load categories';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _searchByCategory(int categoryId, String categoryName) async {
    if (widget.searchCubit == null) return;

    debugPrint(
      '📁 Category tapped: $categoryName (ID: $categoryId), loading products...',
    );

    try {
      final productService = GetIt.I<ProductService>();
      await widget.searchCubit!.performSearch(
        categoryName,
        searchProvider: (query) async {
          final products = await productService.listAllProducts(
            apiVersion: 'v1',
            category: categoryId,
            page: 1,
            perPage: 20,
          );
          debugPrint(
            '🔍 Found ${products.length} products for category: $categoryName',
          );
          return products;
        },
      );
    } catch (e) {
      debugPrint('❌ Error loading category products: $e');
    }
  }

  Future<void> _searchByBrand(String brandName) async {
    if (widget.searchCubit == null || brandName.isEmpty) return;

    debugPrint('🏷️ Brand tapped: $brandName, searching products...');

    try {
      final productService = GetIt.I<ProductService>();
      await widget.searchCubit!.performSearch(
        brandName,
        searchProvider: (query) async {
          final products = await productService.listAllProducts(
            apiVersion: 'v1',
            search: query,
            page: 1,
            perPage: 20,
          );
          debugPrint(
            '🔍 Found ${products.length} products for brand: $brandName',
          );
          return products;
        },
      );
    } catch (e) {
      debugPrint('❌ Error searching brand products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(context.spacing24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: OsmeaColors.pewter.withOpacity(0.5),
              ),
              SizedBox(height: context.spacing16),
              OsmeaComponents.text(
                _error!,
                textStyle: OsmeaTextStyle.bodyMedium(
                  context,
                ).copyWith(color: OsmeaColors.pewter),
              ),
              SizedBox(height: context.spacing16),
              OsmeaComponents.button(
                text: 'Retry',
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
            'Brands',
            textStyle: OsmeaTextStyle.titleMedium(context),
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: context.spacing4),
              itemCount: _brands.length,
              separatorBuilder: (context, index) =>
                  SizedBox(width: context.spacing8),
              itemBuilder: (context, index) {
                final brand = _brands[index];
                return _BrandCard(
                  brand: brand,
                  onTap: () => _searchByBrand(brand.name ?? ''),
                );
              },
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing16),
        ],
        // Categories section
        OsmeaComponents.text(
          'Categories',
          textStyle: OsmeaTextStyle.titleMedium(context),
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        ..._categories.map((category) {
          return OsmeaComponents.listItem(
            variant: ListItemVariant.outlined,
            size: ListItemSize.large,
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing12,
              vertical: context.spacing10,
            ),
            margin: EdgeInsets.only(bottom: context.spacing8),
            title: OsmeaComponents.text(
              category.name ?? 'Category',
              textStyle: OsmeaTextStyle.titleSmall(
                context,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
            trailing: Icon(Icons.chevron_right, color: OsmeaColors.pewter),
            onTap: () {
              if (category.id != null) {
                _searchByCategory(category.id as int, category.name ?? '');
              }
            },
          );
        }),
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
    return OsmeaComponents.basicCard(
      width: 120,
      height: 140,
      variant: ComponentAppearance.outlined,
      size: ComponentSize.small,
      borderRadius: BorderRadius.circular(12),
      padding: EdgeInsets.all(context.spacing8),
      margin: EdgeInsets.zero,
      onTap: onTap,
      customContent: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Brand image or placeholder
          if (brand.image?.thumbnail != null || brand.image?.src != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                brand.image?.thumbnail ?? brand.image?.src ?? '',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: OsmeaColors.pewter.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.branding_watermark,
                      color: OsmeaColors.pewter,
                      size: 30,
                    ),
                  );
                },
              ),
            )
          else
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: OsmeaColors.pewter.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.branding_watermark,
                color: OsmeaColors.pewter,
                size: 30,
              ),
            ),
          SizedBox(height: context.spacing8),
          // Brand name
          OsmeaComponents.text(
            brand.name ?? 'Brand',
            textStyle: OsmeaTextStyle.bodySmall(
              context,
            ).copyWith(fontWeight: FontWeight.w600, color: OsmeaColors.thunder),
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
