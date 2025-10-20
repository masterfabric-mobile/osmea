/*
 * HomeView - E-commerce Home Page
 * -----------------------------
 * A modern e-commerce home page following OSMEA architecture.
 * Uses MasterViewHydratedCubit pattern with HydratedBloc state management.
 * Built entirely with OsmeaComponents for consistent UI.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_home/models/module/states.dart';
import 'package:storefront_woo/app/services/cart_service.dart';
import 'package:storefront_woo/app/views/view_home/widgets/cart_content_widget.dart';

/// HomeView displays the main e-commerce product catalog
class HomeView extends MasterViewHydratedCubit<HomeViewModel, HomeState> {
  HomeView({
    super.key,
    super.arguments,
    super.currentView,
    super.snackBarFunction,
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    required super.goRoute,
  }) : super(
         coreAppBar: (context, viewModel) =>
             _buildHomeAppBar(context, viewModel),
       );

  @override
  void initialContent(HomeViewModel viewModel, BuildContext context) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    HomeViewModel viewModel,
    HomeState state,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: viewModel.buildContent(context, state),
      ),
    );
  }
}

/// Builds home app bar following OSMEA standards
PreferredSizeWidget _buildHomeAppBar(
  BuildContext context,
  HomeViewModel? viewModel,
) {
  final cartService = CartService();

  return OsmeaComponents.appBar(
    title: OsmeaComponents.text(
      'Home',
      color: OsmeaColors.thunder,
      textStyle: OsmeaTextStyle.titleLarge(context),
    ),
    variant: AppBarVariant.standard,
    size: AppBarSize.standard,
    backgroundColor: OsmeaColors.paperWhite,
    foregroundColor: OsmeaColors.thunder,
    actions: [
      // Restart button
      AppBarAction(
        type: AppBarActionType.refresh,
        icon: Icon(Icons.refresh, color: OsmeaColors.thunder),
        onPressed: () => viewModel?.restart(),
        tooltip: 'Restart',
      ),
      // Cart button with badge
      AppBarAction(
        type: AppBarActionType.secondary,
        icon: Icon(Icons.shopping_cart, color: OsmeaColors.thunder),
        onPressed: () => _showCartModal(context, cartService),
        tooltip: 'Cart (${cartService.itemCount})',
        badge: cartService.itemCount > 0
            ? OsmeaComponents.container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: OsmeaColors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: OsmeaComponents.text(
                  '${cartService.itemCount}',
                  color: OsmeaColors.white,
                  textStyle: OsmeaTextStyle.bodySmall(
                    context,
                  ).copyWith(fontSize: 11, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              )
            : null,
      ),
    ],
  );
}

/// Shows cart modal following OSMEA standards
void _showCartModal(BuildContext context, CartService cartService) {
  OsmeaComponents.showPopup(
    context: context,
    child: CartContentWidget(cartService: cartService),
    size: PopupSize.large,
    variant: PopupVariant.modal,
    title: 'Shopping Cart',
    backgroundColor: OsmeaColors.paperWhite,
    barrierColor: OsmeaColors.black.withOpacity(0.5),
    isDismissible: true,
    showCloseButton: true,
  );
}

/// Cart content widget following OSMEA standards
