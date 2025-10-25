/*
 * HomeView - E-commerce Home Page
 * -----------------------------
 * A modern e-commerce home page following OSMEA architecture.
 * Uses MasterViewHydratedCubit pattern with HydratedBloc state management.
 * Built entirely with OsmeaComponents for consistent UI.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_home/models/module/states.dart';

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
    // ✅ Listen for auth required state and navigate to auth screen
    if (state is HomeAuthRequiredState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint('🔒 Auth required, navigating to auth screen');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: OsmeaColors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
        // Reset to loading state to prevent infinite loop
        viewModel.restart();
        // Navigate to auth
        context.push('/auth');
      });
      // Show loading while navigating
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Center(
            child: CircularProgressIndicator(color: OsmeaColors.nordicBlue),
          ),
        ),
      );
    }

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
      // Cart button
      AppBarAction(
        type: AppBarActionType.secondary,
        icon: Icon(Icons.shopping_cart, color: OsmeaColors.thunder),
        onPressed: () => context.go('/cart'),
        tooltip: 'Cart',
      ),
    ],
  );
}
