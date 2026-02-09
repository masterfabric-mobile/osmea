/*
 * SearchEmptyStateWidget (Supabase)
 * ---------------------------------
 * Shows categories and brands when search has no query.
 * Same UI as storefront_woo: search bar stays, body shows categories grid + brands row.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:storefront_supabase/src/resources/resources.g.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/models/brand.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  List<Category> _categories = [];
  List<Brand> _brands = [];
  bool _isLoading = true;
  String? _error;
  static const int _columnCount = 2;

  @override
  void initState() {
    super.initState();
    _loadCategoriesAndBrands();
  }

  Future<void> _loadCategoriesAndBrands() async {
    if (!mounted) return;
    final client = Supabase.instance.client;
    try {
      final catsResponse = await client.from('categories').select().order('name');
      final categories = (catsResponse as List)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();

      List<Brand> brands = [];
      try {
        final brandsResponse = await client.from('brand').select().order('name');
        brands = (brandsResponse as List)
            .map((e) => Brand.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('⚠️ Failed to load brands: $e');
      }

      if (mounted) {
        setState(() {
          _categories = categories;
          _brands = brands;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Failed to load categories: $e');
      if (mounted) {
        setState(() {
          _error = context.resources.unexpectedError;
          _isLoading = false;
        });
      }
    }
  }

  void _searchByCategory(String categoryId, String categoryName) {
    context.push('/products?category_id=$categoryId');
  }

  Future<void> _searchByBrand(String brandName, int brandId) async {
    if (widget.searchCubit == null || widget.searchProvider == null) return;
    try {
      await widget.searchCubit!.performSearch(
        brandName,
        searchProvider: widget.searchProvider!,
        immediate: true,
      );
    } catch (e) {
      debugPrint('Search by brand error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showSkeleton && _isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: context.spacing16),
            Text('Loading...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(context.spacing20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: OsmeaColors.pewter),
              SizedBox(height: context.spacing12),
              Text(_error!, textAlign: TextAlign.center),
              SizedBox(height: context.spacing16),
              OsmeaComponents.button(
                text: context.resources.retry,
                onPressed: () {
                  setState(() {
                    _error = null;
                    _isLoading = true;
                  });
                  _loadCategoriesAndBrands();
                },
                variant: ButtonVariant.outlined,
              ),
            ],
          ),
        ),
      );
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing12,
        vertical: context.spacing10,
      ),
      children: [
        if (_brands.isNotEmpty) ...[
          OsmeaComponents.text(
            context.resources.brands,
            textStyle: OsmeaTextStyle.titleMedium(context),
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _brands.length,
              itemBuilder: (context, index) {
                final brand = _brands[index];
                return _BrandCard(
                  brand: brand,
                  onTap: () => _searchByBrand(brand.name, brand.id),
                );
              },
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing16),
        ],
        OsmeaComponents.text(
          context.resources.categories,
          textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        OsmeaComponents.sizedBox(height: context.spacing12),
        Wrap(
          spacing: context.spacing12,
          runSpacing: context.spacing12,
          alignment: WrapAlignment.start,
          children: _categories.map((category) {
            final itemWidth = (MediaQuery.of(context).size.width -
                    (context.spacing12 * (_columnCount - 1)) -
                    (context.spacing16 * 2)) /
                _columnCount;
            return SizedBox(
              width: itemWidth,
              child: AspectRatio(
                aspectRatio: 0.85,
                child: _CategoryCard(
                  category: category,
                  onTap: () =>
                      _searchByCategory(category.id, category.name),
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
  final Brand brand;
  final VoidCallback? onTap;

  const _BrandCard({required this.brand, this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = brand.logoUrl;
    const circleSize = 64.0;

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
                color: OsmeaColors.grayMaterial[100],
              ),
              child: ClipOval(
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? OsmeaComponents.image(
                        imageUrl: imageUrl,
                        width: circleSize,
                        height: circleSize,
                        fit: BoxFit.cover,
                        variant: ImageVariant.normal,
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
              brand.name,
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                fontWeight: FontWeight.w500,
                color: OsmeaColors.thunder,
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
      color: OsmeaColors.grayMaterial[200],
      child: Icon(
        Icons.branding_watermark,
        size: size * 0.5,
        color: OsmeaColors.pewter,
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = category.imageUrl;
    final categoryName = category.name;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: OsmeaColors.black.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
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
                imageUrl != null && imageUrl.isNotEmpty
                    ? OsmeaComponents.image(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        variant: ImageVariant.normal,
                        errorWidget: _buildPlaceholder(context),
                      )
                    : _buildPlaceholder(context),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          OsmeaColors.black.withValues(alpha: 0.6),
                          OsmeaColors.black.withValues(alpha: 0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    padding: EdgeInsets.all(context.spacing12),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: OsmeaComponents.text(
                        categoryName,
                        textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                          color: OsmeaColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
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

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: OsmeaColors.grayMaterial[100],
      child: Icon(
        Icons.category_outlined,
        size: 48,
        color: OsmeaColors.pewter,
      ),
    );
  }
}
