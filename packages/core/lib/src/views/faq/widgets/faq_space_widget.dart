import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/models/faq_models.dart';
import 'package:core/src/views/faq/cubit/faq_cubit.dart';
import 'package:core/src/views/faq/cubit/faq_state.dart';
import 'package:core/src/helper/web_viewer_helper.dart';
import 'package:osmea_components/osmea_components.dart';

/// ⚪ **OSMEA FAQ Space Widget**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Space-themed FAQ style - Minimalist with lots of whitespace
///
/// {@category Widgets}
/// {@subCategory FAQSpace}

class FAQSpaceWidget extends StatelessWidget {
  final FAQPageModel model;
  final FAQViewCubit cubit;

  const FAQSpaceWidget({
    super.key,
    required this.model,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = model.getBackgroundColor() ?? OsmeaColors.white;
    final textColor = model.getTextColor() ?? OsmeaColors.shark;

    return Container(
      color: bgColor,
      child: BlocBuilder<FAQViewCubit, FAQViewState>(
        bloc: cubit,
        builder: (context, state) {
          final filteredItems = state.getFilteredItems();

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: OsmeaComponents.column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header
                  _buildHeader(context, textColor),

                  // Search bar (if enabled)
                  if (model.showSearchBar) _buildSearchBar(context, state),

                  // FAQ Items
                  if (filteredItems.isEmpty)
                    Padding(
                      padding: EdgeInsets.all(context.spacing24),
                      child: OsmeaComponents.text(
                        'No questions found',
                        variant: OsmeaTextVariant.bodySmall,
                        color: textColor.withOpacity(0.4),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    ...filteredItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return _buildFAQItem(context, index, item, textColor, state);
                    }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build header section
  Widget _buildHeader(BuildContext context, Color textColor) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.spacing24,
      ),
      child: OsmeaComponents.column(
        children: [
          OsmeaComponents.text(
            model.title,
            variant: OsmeaTextVariant.titleMedium,
            color: textColor,
            fontWeight: FontWeight.w300,
            textAlign: TextAlign.center,
          ),
          if (model.description != null) ...[
            OsmeaComponents.sizedBox(height: context.spacing16),
            OsmeaComponents.text(
              model.description!,
              variant: OsmeaTextVariant.bodySmall,
              color: textColor.withOpacity(0.5),
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
        hint: 'Search...',
        onChanged: (value) => cubit.setSearchQuery(value),
        prefixIcon: Icon(Icons.search, color: OsmeaColors.shark.withOpacity(0.3)),
      ),
    );
  }

  /// Build FAQ item
  Widget _buildFAQItem(
    BuildContext context,
    int index,
    FAQItem item,
    Color textColor,
    FAQViewState state,
  ) {
    final isExpanded = state.expandedIndices.contains(index);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.spacing12,
      ),
      child: Column(
        children: [
          // Question
          InkWell(
            onTap: () => cubit.toggleItem(index),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: context.spacing16),
              child: Row(
                children: [
                  Expanded(
                    child: OsmeaComponents.text(
                      item.question,
                      variant: OsmeaTextVariant.bodyMedium,
                      color: textColor.withOpacity(0.7),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  OsmeaComponents.sizedBox(width: context.spacing12),
                  Icon(
                    isExpanded ? Icons.remove : Icons.add,
                    color: textColor.withOpacity(0.4),
                    size: context.iconSizeSmall,
                  ),
                ],
              ),
            ),
          ),

          // Divider
          Container(
            height: 0.5,
            color: textColor.withOpacity(0.1),
          ),

          // Answer
          if (isExpanded)
            Padding(
              padding: EdgeInsets.only(
                top: context.spacing16,
                bottom: context.spacing16,
              ),
              child: WebViewerHelper.html(
                item.answer,
              ),
            ),
        ],
      ),
    );
  }
}
