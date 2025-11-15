import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:storefront_woo/app/views/view_search/models/search_view_model.dart';
import 'package:storefront_woo/app/views/view_search/widgets/search_brands_list_widget.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_brands_api/freezed_model/response/list_product_brands_response_model.dart';

class SearchCategoriesListWidget extends StatelessWidget {
  final List<dynamic> categories;
  final List<ListProductBrandsResponseModel> brands;
  final SearchViewModel viewModel;

  const SearchCategoriesListWidget({
    super.key,
    required this.categories,
    required this.brands,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing12,
        vertical: context.spacing10,
      ),
      children: [
        // Brands section
        SearchBrandsListWidget(
          brands: brands,
          viewModel: viewModel,
        ),
        OsmeaComponents.sizedBox(height: context.spacing16),
        // Categories section
        OsmeaComponents.text(
          'Categories',
          textStyle: OsmeaTextStyle.titleMedium(context),
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        ...categories.map((c) {
          return OsmeaComponents.listItem(
            variant: ListItemVariant.outlined,
            size: ListItemSize.large,
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing12,
              vertical: context.spacing10,
            ),
            margin: EdgeInsets.only(bottom: context.spacing8),
            title: OsmeaComponents.text(
              c.name ?? 'Category',
              textStyle: OsmeaTextStyle.titleSmall(
                context,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
            trailing: Icon(Icons.chevron_right, color: OsmeaColors.pewter),
            onTap: () =>
                viewModel.searchByCategory(c.id ?? 0, name: c.name ?? ''),
          );
        }),
      ],
    );
  }
}
