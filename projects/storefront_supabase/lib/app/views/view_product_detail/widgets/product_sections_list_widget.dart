/*
 * Product Sections List Widget
 * -----------------------------
 * Menu items list for product details (Attributes, Description, Reviews)
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:osmea_components/src/components/bottom_sheet/bottom_sheet.dart';
import 'package:storefront_supabase/app/views/view_product_detail/models/product_detail_view_model.dart';
import 'package:storefront_supabase/app/views/view_product_detail/models/module/states.dart';
import 'package:storefront_supabase/app/views/view_product_detail/widgets/product_attributes_widget.dart';
import 'package:storefront_supabase/app/views/view_product_detail/widgets/product_reviews_widget.dart';
import 'package:storefront_supabase/app/views/view_product_detail/widgets/product_reviews_with_form_widget.dart';

/// Menu items list widget for product details
class ProductSectionsListWidget extends StatelessWidget {
  final ProductDetailViewModel viewModel;
  final ProductDetailLoadedState state;
  final Function(String path) goRoute;

  const ProductSectionsListWidget({
    super.key,
    required this.viewModel,
    required this.state,
    required this.goRoute,
  });

  @override
  Widget build(BuildContext context) {
    final sections = <_SectionItem>[];
    final configHelper = AssetConfigHelper();

    // Attributes section
    if (state.product.variants.isNotEmpty) {
      sections.add(
        _SectionItem(
          title: 'Options',
          icon: Icons.tune,
          widget: ProductAttributesWidget(viewModel: viewModel, state: state),
          onTap: () => _showContentBottomSheet(
            context,
            'Options',
            ProductAttributesWidget(viewModel: viewModel, state: state),
          ),
        ),
      );
    }

    // Description section - opens in bottom sheet
    if (state.product.description.isNotEmpty) {
      sections.add(
        _SectionItem(
          title: 'Details',
          icon: Icons.description_outlined,
          widget: const SizedBox.shrink(),
          onTap: () =>
              _showDescriptionBottomSheet(context, viewModel, state, goRoute),
        ),
      );
    }

    // Cancellation & returns policy section (menu item)
    sections.add(
      _SectionItem(
        title: configHelper.getString(
          'product_detail_view.policies.cancellation_returns.title',
          'Cancellation & returns',
        ),
        icon: Icons.assignment_return_outlined,
        widget: OsmeaComponents.padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing16,
            vertical: context.spacing12,
          ),
          child: OsmeaComponents.text(
            configHelper.getString(
              'product_detail_view.policies.cancellation_returns.body',
              'Due to our policy, cancellation and returns are currently not available.\n\nPlease review your order carefully before placing it.',
            ),
            textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.thunder,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        onTap: () => _showContentBottomSheet(
          context,
          configHelper.getString(
            'product_detail_view.policies.cancellation_returns.title',
            'Cancellation & returns',
          ),
          OsmeaComponents.padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing16,
              vertical: context.spacing12,
            ),
            child: OsmeaComponents.text(
              configHelper.getString(
                'product_detail_view.policies.cancellation_returns.body',
                'Due to our policy, cancellation and returns are currently not available.\n\nPlease review your order carefully before placing it.',
              ),
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                color: OsmeaColors.thunder,
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );

    // Reviews section (with write-review form when logged in)
    sections.add(
      _SectionItem(
        title: 'Reviews',
        icon: Icons.star_outline,
        widget: ProductReviewsWithFormWidget(
          viewModel: viewModel,
          state: state,
        ),
        onTap: () => _showContentBottomSheet(
          context,
          'Reviews',
          ProductReviewsWithFormWidget(viewModel: viewModel, state: state),
        ),
      ),
    );

    if (sections.isEmpty) {
      return const SizedBox.shrink();
    }

    return OsmeaComponents.column(
      children: sections.map((section) {
        return _buildMenuItem(context, section);
      }).toList(),
    );
  }

  Widget _buildMenuItem(BuildContext context, _SectionItem section) {
    return OsmeaComponents.container(
      margin: EdgeInsets.only(bottom: context.spacing8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: section.onTap,
          borderRadius: BorderRadius.circular(8),
          child: OsmeaComponents.container(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing8,
              vertical: context.spacing4,
            ),
            child: OsmeaComponents.row(
              children: [
                Icon(
                  section.icon,
                  size: context.iconSizeSmall,
                  color: OsmeaColors.black,
                ),
                OsmeaComponents.sizedBox(width: context.spacing6),
                OsmeaComponents.expanded(
                  child: OsmeaComponents.text(
                    section.title,
                    textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: OsmeaColors.black,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: context.iconSizeSmall,
                  color: OsmeaColors.black.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Shows content in bottom sheet
  void _showContentBottomSheet(
    BuildContext context,
    String title,
    Widget content,
  ) {
    OsmeaBottomSheetHelpers.showModal(
      context: context,
      size: BottomSheetSize.large,
      backgroundColor: OsmeaColors.white,
      child: OsmeaComponents.singleChildScrollView(
        child: OsmeaComponents.column(
          crossAxisAlignment: context.crossStart,
          children: [
            // Title
            OsmeaComponents.padding(
              padding: EdgeInsets.all(context.spacing16),
              child: OsmeaComponents.text(
                title,
                textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: OsmeaColors.black,
                ),
              ),
            ),
            // Content
            content,
            OsmeaComponents.sizedBox(height: context.spacing24),
          ],
        ),
      ),
    );
  }

  /// Shows description in full bottom sheet
  void _showDescriptionBottomSheet(
    BuildContext context,
    ProductDetailViewModel viewModel,
    ProductDetailLoadedState state,
    Function(String path) goRoute,
  ) {
    OsmeaBottomSheetHelpers.showModal(
      context: context,
      size: BottomSheetSize.large,
      backgroundColor: OsmeaColors.white,
      child: OsmeaComponents.singleChildScrollView(
        child: OsmeaComponents.column(
          crossAxisAlignment: context.crossStart,
          children: [
            // Product image at top - compact for bottom sheet
            if (state.product.imageUrls.isNotEmpty)
              OsmeaComponents.container(
                height: context.dynamicHeight(0.35),
                width: context.infinity,
                color: OsmeaColors.white,
                child: PageView.builder(
                  itemCount: state.product.imageUrls.length,
                  itemBuilder: (context, index) {
                    return OsmeaComponents.container(
                      width: context.infinity,
                      height: context.dynamicHeight(0.35),
                      color: OsmeaColors.white,
                      child: OsmeaComponents.image(
                        imageUrl: state.product.imageUrls[index],
                        width: context.infinity,
                        height: context.dynamicHeight(0.35),
                        fit: BoxFit.contain,
                        alignment: context.center,
                        placeholder: OsmeaComponents.container(
                          color: OsmeaColors.grayMaterial[50],
                          child: OsmeaComponents.center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: OsmeaColors.black,
                            ),
                          ),
                        ),
                        errorWidget: OsmeaComponents.container(
                          color: OsmeaColors.grayMaterial[50],
                          child: OsmeaComponents.center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              size: context.iconSizeExtraHigh * 1.5,
                              color: OsmeaColors.grayMaterial[300]!,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            OsmeaComponents.sizedBox(height: context.spacing16),

            // Product name and title
            OsmeaComponents.padding(
              padding: EdgeInsets.symmetric(horizontal: context.spacing16),
              child: OsmeaComponents.column(
                crossAxisAlignment: context.crossStart,
                children: [
                  OsmeaComponents.text(
                    state.product.name,
                    textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                      height: 1.3,
                      color: OsmeaColors.black,
                    ),
                  ),
                ],
              ),
            ),

            OsmeaComponents.sizedBox(height: context.spacing16),

            // Product description - HTML formatted, full content
            if (state.product.description.isNotEmpty)
              OsmeaComponents.padding(
                padding: EdgeInsets.symmetric(horizontal: context.spacing16),
                child: WebViewerHelper.html(state.product.description),
              ),

            OsmeaComponents.sizedBox(height: context.spacing24),
          ],
        ),
      ),
    );
  }
}

class _SectionItem {
  final String title;
  final IconData icon;
  final Widget? widget;
  final VoidCallback? onTap;

  _SectionItem({
    required this.title,
    required this.icon,
    this.widget,
    this.onTap,
  });
}
