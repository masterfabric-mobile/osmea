import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/product_detail_view_model.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';

class DescriptionSection extends StatelessWidget {
  final String description;
  final ProductDetailViewModel viewModel;
  final ProductDetailLoadedState state;

  const DescriptionSection({
    super.key,
    required this.description,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.column(
      crossAxisAlignment: context.crossStart,
      children: [
        OsmeaComponents.container(
          padding: context.paddingLow,
          decoration: BoxDecoration(
            color: OsmeaColors.pewter.withOpacity(context.alpha5),
            borderRadius: context.borderRadiusNormal,
          ),
          child: state.isDescriptionExpanded
              ? _buildExpandedDescription(context)
              : _buildCollapsedDescription(context),
        ),
        if (_shouldShowButton()) ...[
          OsmeaComponents.sizedBox(height: context.spacing6),
          OsmeaComponents.center(
            child: GestureDetector(
              onTap: () => viewModel.toggleDescriptionExpandedFire(),
              child: OsmeaComponents.container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.spacing12,
                  vertical: context.spacing6,
                ),
                decoration: BoxDecoration(
                  color: OsmeaColors.nordicBlue.withOpacity(context.alpha5),
                  borderRadius: BorderRadius.circular(
                    context.radiusNormal - context.width1,
                  ),
                ),
                child: OsmeaComponents.text(
                  state.isDescriptionExpanded ? 'Show Less' : 'Show More',
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    color: OsmeaColors.nordicBlue.withOpacity(context.alpha80),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  bool _shouldShowButton() => description.length > 200;

  Widget _buildExpandedDescription(BuildContext context) {
    final structuredItems = _parseDescriptionToBulletPoints();
    return OsmeaComponents.column(
      crossAxisAlignment: context.crossStart,
      children: [
        ...structuredItems.map((item) => _buildBulletPoint(context, item)),
      ],
    );
  }

  Widget _buildCollapsedDescription(BuildContext context) {
    final structuredItems = _parseDescriptionToBulletPoints();
    final itemsToShow = structuredItems.take(2).toList();
    final hasMoreItems = structuredItems.length > 2;

    return OsmeaComponents.column(
      crossAxisAlignment: context.crossStart,
      children: [
        ...itemsToShow.map((item) => _buildBulletPoint(context, item)),
        if (hasMoreItems) ...[
          OsmeaComponents.sizedBox(height: context.spacing4),
          OsmeaComponents.text(
            '...',
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              fontSize:
                  context.fontSizeExtraSmallMedium * context.textScaleFactor,
              fontWeight: FontWeight.bold,
            ),
            color: OsmeaColors.pewter,
          ),
        ],
      ],
    );
  }

  List<String> _parseDescriptionToBulletPoints() {
    final plainText = description
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final items = <String>[];
    final patterns = [
      RegExp(r'[•\-\*]\s*'),
      RegExp(r'\n\s*'),
      RegExp(r'\.\s+(?=[A-Z])'),
      RegExp(r':\s*'),
    ];

    String workingText = plainText;
    for (final pattern in patterns) {
      if (workingText.contains(pattern)) {
        final parts = workingText.split(pattern);
        for (final part in parts) {
          final trimmed = part.trim();
          if (trimmed.isNotEmpty && trimmed.length > 10) {
            items.add(trimmed);
          }
        }
        break;
      }
    }

    if (items.isEmpty && plainText.length > 100) {
      final sentences = plainText.split(RegExp(r'[.!?]\s+'));
      for (final sentence in sentences) {
        final trimmed = sentence.trim();
        if (trimmed.isNotEmpty) {
          items.add(trimmed);
        }
      }
    }

    if (items.isEmpty) {
      items.add(plainText);
    }

    return items;
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return OsmeaComponents.padding(
      padding: context.onlyBottomPaddingZero,
      child: OsmeaComponents.row(
        crossAxisAlignment: context.crossStart,
        children: [
          OsmeaComponents.container(
            width: 3,
            height: 3,
            margin: EdgeInsets.only(
              top: context.spacing12,
              right: context.spacing12,
            ),
            decoration: BoxDecoration(
              color: OsmeaColors.nordicBlue.withOpacity(context.alpha40),
              borderRadius: BorderRadius.circular(context.spacing2 - 0.5),
            ),
          ),
          OsmeaComponents.expanded(
            child: OsmeaComponents.text(
              text,
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                fontSize:
                    context.fontSizeExtraSmallMedium * context.textScaleFactor,
                height: 1.7,
                fontWeight: FontWeight.w200,
                letterSpacing: 0.3,
                color: OsmeaColors.thunder.withOpacity(context.alpha70),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
