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
import 'package:osmea_components/osmea_components.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_home/models/module/states.dart';
import 'package:storefront_woo/app/views/view_home/widgets/home_loading_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/home_error_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/home_content_widget.dart';

/// HomeView displays the main e-commerce product catalog
class HomeView extends MasterViewHydratedCubit<HomeViewModel, HomeState> {
  HomeView({
    super.key,
    super.arguments,
    super.currentView,
    super.snackBarFunction,
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.horizontalPadding = const PaddingVisibility.disabled(),
    super.verticalPadding = const PaddingVisibility.disabled(),
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
      return Center(
        child: CircularProgressIndicator(color: OsmeaColors.nordicBlue),
      );
    }

    // Build content based on state - using widgets instead of ViewModel methods
    if (state is HomeErrorState) {
      return HomeErrorWidget(
        message: state.message,
        onRetry: () => viewModel.loadProducts(),
      );
    }

    if (state is HomeLoadingState) {
      return const HomeLoadingWidget();
    }

    if (state is HomeLoadedState) {
      return HomeContentWidget(state: state, viewModel: viewModel);
    }

    // Initial state - show loading
    return const HomeLoadingWidget();
  }
}

/// Builds home app bar following OSMEA standards
PreferredSizeWidget _buildHomeAppBar(
  BuildContext context,
  HomeViewModel? viewModel,
) {
  // Try to get app name from config, fallback to "MasterFabric"
  final configHelper = AssetConfigHelper();
  final appName = configHelper.getString(
    'app_settings.app_name',
    'MasterFabric',
  );

  return OsmeaComponents.appBar(
    padding: const EdgeInsets.only(bottom: 16),
    title: OsmeaComponents.text(
      'MasterFabric',
      color: OsmeaColors.thunder,
      textStyle: OsmeaTextStyle.titleLarge(
        context,
      ).copyWith(fontWeight: FontWeight.w700),
    ),
    variant: AppBarVariant.standard,
    size: AppBarSize.standard,
    backgroundColor: OsmeaColors.paperWhite,
    foregroundColor: OsmeaColors.thunder,
    actions: const [],
  );
}
