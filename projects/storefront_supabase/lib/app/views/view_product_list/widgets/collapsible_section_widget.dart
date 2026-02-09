/*
 * CollapsibleSectionWidget
 * ------------------------
 * Widget for collapsible filter sections.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_supabase/app/views/view_product_list/models/product_list_view_model.dart';

class CollapsibleSectionWidget extends StatelessWidget {
  final ProductListViewModel viewModel;
  final String title;
  final String sectionKey;
  final Widget child;

  const CollapsibleSectionWidget({
    super.key,
    required this.viewModel,
    required this.title,
    required this.sectionKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Ideally we track expansion state in ViewModel or local state.
    // For now, using a simple ExpansionTile wrapped in Theme to remove borders.
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: OsmeaComponents.text(
          title,
          textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
            fontWeight: FontWeight.w600,
            color: OsmeaColors.black,
          ),
        ),
        initiallyExpanded: false, // Or check viewModel state if implemented
        children: [
          OsmeaComponents.padding(
            padding: EdgeInsets.only(
              top: context.spacing8,
              bottom: context.spacing4,
              left: context.spacing16,
              right: context.spacing16,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
