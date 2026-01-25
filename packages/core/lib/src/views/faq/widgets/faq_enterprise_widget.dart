import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/models/faq_models.dart';
import 'package:core/src/views/faq/cubit/faq_cubit.dart';
import 'package:core/src/views/faq/cubit/faq_state.dart';
import 'package:core/src/helper/web_viewer_helper.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🏢 **OSMEA FAQ Enterprise Widget**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Enterprise-themed FAQ style - Professional and structured
///
/// {@category Widgets}
/// {@subCategory FAQEnterprise}

class FAQEnterpriseWidget extends StatelessWidget {
  final FAQPageModel model;
  final FAQViewCubit cubit;

  const FAQEnterpriseWidget({
    super.key,
    required this.model,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = model.getBackgroundColor() ?? OsmeaColors.snow;
    final textColor = model.getTextColor() ?? OsmeaColors.shark;
    final primaryColor = model.getPrimaryColor() ?? OsmeaColors.deepSea;

    return Container(
      color: bgColor,
      child: BlocBuilder<FAQViewCubit, FAQViewState>(
        bloc: cubit,
        builder: (context, state) {
          final filteredItems = state.getFilteredItems();

          return SingleChildScrollView(
            child: OsmeaComponents.column(
              children: [
                // Header
                _buildHeader(context, textColor, primaryColor),

                // Search bar (if enabled)
                if (model.showSearchBar) _buildSearchBar(context, state),

                // FAQ Items
                if (filteredItems.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(context.spacing24),
                    child: OsmeaComponents.text(
                      'No questions found',
                      variant: OsmeaTextVariant.bodyMedium,
                      color: textColor.withOpacity(0.5),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  ...filteredItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return _buildFAQItem(context, index, item, textColor, primaryColor, state);
                  }),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build header section
  Widget _buildHeader(BuildContext context, Color textColor, Color primaryColor) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.spacing8,
        bottom: context.spacing24,
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Accent line
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing12),
          // Title
          OsmeaComponents.text(
            model.title,
            variant: OsmeaTextVariant.headlineSmall,
            color: textColor,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          if (model.description != null) ...[
            OsmeaComponents.sizedBox(height: context.spacing12),
            OsmeaComponents.text(
              model.description!,
              variant: OsmeaTextVariant.bodyLarge,
              color: textColor.withOpacity(0.75),
              textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build search bar
  Widget _buildSearchBar(BuildContext context, FAQViewState state) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.spacing16,
      ),
      child: OsmeaComponents.textField(
        hint: 'Search frequently asked questions...',
        onChanged: (value) => cubit.setSearchQuery(value),
        prefixIcon: Icon(Icons.search, color: OsmeaColors.shark.withOpacity(0.5)),
      ),
    );
  }

  /// Build FAQ item
  Widget _buildFAQItem(
    BuildContext context,
    int index,
    FAQItem item,
    Color textColor,
    Color primaryColor,
    FAQViewState state,
  ) {
    final isExpanded = state.expandedIndices.contains(index);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.spacing8,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: OsmeaColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isExpanded ? primaryColor : OsmeaColors.silver,
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            // Question header
            InkWell(
              onTap: () => cubit.toggleItem(index),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: EdgeInsets.all(context.spacing16),
                child: Row(
                  children: [
                    Expanded(
                      child: OsmeaComponents.text(
                        item.question,
                        variant: OsmeaTextVariant.bodyLarge,
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    OsmeaComponents.sizedBox(width: context.spacing12),
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: primaryColor,
                      size: context.iconSizeNormal,
                    ),
                  ],
                ),
              ),
            ),

            // Divider
            if (isExpanded)
              Container(
                height: 0.5,
                color: OsmeaColors.silver,
                margin: EdgeInsets.symmetric(horizontal: context.spacing16),
              ),

            // Answer content
            if (isExpanded)
              Padding(
                padding: EdgeInsets.all(context.spacing16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: WebViewerHelper.html(
                    item.answer,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
