/*
 * CollapsibleSectionWidget
 * ------------------------
 * Widget for collapsible filter sections.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';
import 'package:storefront_woo/app/views/view_product_list/models/module/states.dart';

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
    return BlocBuilder<ProductListViewModel, ProductListState>(
      bloc: viewModel,
      builder: (context, state) {
        return OsmeaComponents.collapse(
          size: CollapseSize.medium,
          variant: CollapseVariant.ghost,
          mode: CollapseBehaviorMode.multiple,
          children: [
            OsmeaCollapsePanel(
              header: OsmeaComponents.text(title),
              value: sectionKey,
              body: OsmeaComponents.padding(
                padding: EdgeInsets.only(
                  top: context.spacing8,
                  bottom: context.spacing4,
                ),
                child: child,
              ),
            ),
          ],
          expansionCallback: (int index, bool isExpanded) {
            viewModel.toggleExpandedSection(sectionKey);
          },
        );
      },
    );
  }
}

