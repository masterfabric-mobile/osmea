import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_brands_api/freezed_model/response/list_product_brands_response_model.dart'
    as brand_models;
import 'package:storefront_woo/app/views/view_search/models/search_view_model.dart';

class SearchBrandsListWidget extends StatelessWidget {
  final List<brand_models.ListProductBrandsResponseModel> brands;
  final SearchViewModel viewModel;

  const SearchBrandsListWidget({
    super.key,
    required this.brands,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          'Brands',
          textStyle: OsmeaTextStyle.titleMedium(context),
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        if (brands.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: context.spacing8),
            child: OsmeaComponents.text(
              'No brands available',
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                color: OsmeaColors.pewter,
              ),
            ),
          )
        else
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: context.spacing4),
              itemCount: brands.length,
              separatorBuilder: (context, index) => SizedBox(width: context.spacing8),
              itemBuilder: (context, index) {
                final brand = brands[index];
                return _BrandCard(
                  brand: brand,
                  onTap: () {
                    // TODO: Implement brand search functionality
                    // viewModel.searchByBrand(brand.id ?? 0, name: brand.name ?? '');
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

class _BrandCard extends StatelessWidget {
  final brand_models.ListProductBrandsResponseModel brand;
  final VoidCallback? onTap;

  const _BrandCard({
    required this.brand,
    this.onTap,
  });

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
            textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
              fontWeight: FontWeight.w600,
              color: OsmeaColors.thunder,
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

