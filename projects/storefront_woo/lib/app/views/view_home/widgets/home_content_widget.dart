/*
 * HomeContentWidget
 * -----------------
 * Main content widget for home view.
 * Combines banner, deals of day, recommended section and products grid.
 */

import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_home/models/module/states.dart';
import 'package:storefront_woo/app/views/view_home/widgets/banner_carousel_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/deals_of_day_carousel_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/recommended_section_widget.dart';

/// Main content widget for home view
class HomeContentWidget extends StatelessWidget {
  final HomeLoadedState state;
  final HomeViewModel viewModel;

  const HomeContentWidget({
    super.key,
    required this.state,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final configHelper = AssetConfigHelper();

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: OsmeaComponents.singleChildScrollView(
        padding: EdgeInsets.only(bottom: context.spacing24 * 2),
        child: OsmeaComponents.column(
      children: [
          // Banner carousel (from config)
          BannerCarouselWidget(configHelper: configHelper),
          // Deals of the day carousel
          DealsOfDayCarouselWidget(
            configHelper: configHelper,
            allProducts: state.products,
            viewModel: viewModel,
          saleProducts:
              state.products.where((p) => p.onSale == true).toList(),
          ),
          // Spacing between carousels and recommended section for better UI
          OsmeaComponents.sizedBox(height: context.spacing24),
          // Recommended section (compact grid)
          RecommendedSectionWidget(
            configHelper: configHelper,
            allProducts: state.products,
            viewModel: viewModel,
        ),
      ],
        ),
      ),
    );
  }
}

