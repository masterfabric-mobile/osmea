import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/models/faq_models.dart';
import 'package:core/src/views/faq/cubit/faq_cubit.dart';
import 'package:core/src/views/faq/cubit/faq_state.dart';
import 'package:core/src/helper/web_viewer_helper.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🚀 **OSMEA FAQ Startup Widget**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Startup-themed FAQ style - Modern and clean design
///
/// {@category Widgets}
/// {@subCategory FAQStartup}

class FAQStartupWidget extends StatelessWidget {
  final FAQPageModel model;
  final FAQViewCubit cubit;

  const FAQStartupWidget({
    super.key,
    required this.model,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = model.getBackgroundColor() ?? OsmeaColors.white;
    final textColor = model.getTextColor() ?? OsmeaColors.shark;
    final primaryColor = model.getPrimaryColor() ?? OsmeaColors.nordicBlue;

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
        children: [
          // Title
          OsmeaComponents.text(
            model.title,
            variant: OsmeaTextVariant.titleLarge,
            color: textColor,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),

          if (model.description != null) ...[
            OsmeaComponents.sizedBox(height: context.spacing12),
            OsmeaComponents.text(
              model.description!,
              variant: OsmeaTextVariant.bodyMedium,
              color: textColor.withOpacity(0.7),
              textAlign: TextAlign.center,
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
        hint: 'Search questions...',
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
          borderRadius: BorderRadius.circular(12),
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
              borderRadius: BorderRadius.circular(12),
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
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: primaryColor,
                      size: context.iconSizeNormal,
                    ),
                  ],
                ),
              ),
            ),

            // Answer content
            if (isExpanded)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  context.spacing16,
                  0,
                  context.spacing16,
                  context.spacing16,
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(context.spacing16),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
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
