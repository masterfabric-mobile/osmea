/*
 * Product Sections List Widget
 * -----------------------------
 * Modern expandable sections list for product details (Attributes, Description, Reviews)
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osmea_components/src/components/bottom_sheet/bottom_sheet.dart';
import 'package:osmea_components/src/components/collapse/cubit/collapse_cubit.dart';
import 'package:osmea_components/src/enums/collapse_enums.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/product_detail_view_model.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/product_attributes_widget.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/product_reviews_widget.dart';
import 'package:storefront_woo/gen/translations.g.dart';

/// Modern expandable sections list widget
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

    // Attributes section
    if (state.product.attributes != null &&
        state.product.attributes!.isNotEmpty) {
      sections.add(
        _SectionItem(
          title: 'Options',
          icon: Icons.tune,
          widget: ProductAttributesWidget(viewModel: viewModel, state: state),
        ),
      );
    }

    // Description section - opens in bottom sheet
    if (state.product.description?.isNotEmpty == true) {
      sections.add(
        _SectionItem(
          title: context.t.productDetailView.description.details,
          icon: Icons.description_outlined,
          widget:
              const SizedBox.shrink(), // Empty widget, will open bottom sheet
          onTap: () =>
              _showDescriptionBottomSheet(context, viewModel, state, goRoute),
        ),
      );
    }

    // Reviews section
    sections.add(
      _SectionItem(
        title: context.t.productDetailView.reviews.title,
        icon: Icons.star_outline,
        widget: ProductReviewsWidget(state: state),
      ),
    );

    if (sections.isEmpty) {
      return const SizedBox.shrink();
    }

    return OsmeaComponents.collapse(
      size: CollapseSize.small,
      variant: CollapseVariant.ghost,
      mode: CollapseBehaviorMode.multiple,
      padding: EdgeInsets.zero,
      expansionCallback: (panelIndex, isExpanded) {
        // If section has onTap callback, call it and prevent expansion
        final section = sections[panelIndex];
        if (section.onTap != null) {
          section.onTap!();
          // Prevent expansion by not toggling the panel
          // We need to access the cubit to prevent expansion
          final cubit = context.read<CollapseCubit>();
          // If it expanded, immediately collapse it
          if (isExpanded) {
            cubit.collapsePanel(panelIndex);
          }
          return;
        }
        // Otherwise, let the default expansion behavior happen
      },
      children: sections.map((section) {
        // Build header - same for all sections
        final header = OsmeaComponents.container(
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
            ],
          ),
        );

        return OsmeaCollapsePanel(
          header: header,
          value: section.title.toLowerCase(),
          body: section.widget,
        );
      }).toList(),
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
            if (state.imageUrls.isNotEmpty)
              OsmeaComponents.container(
                height: context.dynamicHeight(0.35),
                width: context.infinity,
                color: OsmeaColors.white,
                child: PageView.builder(
                  itemCount: state.imageUrls.length,
                  itemBuilder: (context, index) {
                    return OsmeaComponents.container(
                      width: context.infinity,
                      height: context.dynamicHeight(0.35),
                      color: OsmeaColors.white,
                      child: OsmeaComponents.image(
                        imageUrl: state.imageUrls[index],
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
                    state.product.name ??
                        context.t.productDetailView.unknownProduct,
                    textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                      height: 1.3,
                      color: OsmeaColors.black,
                    ),
                  ),
                  if (state.product.shortDescription?.isNotEmpty == true) ...[
                    OsmeaComponents.sizedBox(height: context.spacing8),
                    WebViewerHelper.html(
                      state.product.shortDescription!,
                      height: null,
                    ),
                  ],
                ],
              ),
            ),

            OsmeaComponents.sizedBox(height: context.spacing16),

            // Product description - HTML formatted, full content
            if (state.product.description?.isNotEmpty == true)
              OsmeaComponents.padding(
                padding: EdgeInsets.symmetric(horizontal: context.spacing16),
                child: WebViewerHelper.html(state.product.description!),
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
  final Widget widget;
  final VoidCallback? onTap;

  _SectionItem({
    required this.title,
    required this.icon,
    required this.widget,
    this.onTap,
  });
}
