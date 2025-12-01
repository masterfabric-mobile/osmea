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
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.horizontalPadding = const PaddingVisibility.disabled(),
    required super.goRoute,
  }) : super(
         coreAppBar: (context, viewModel) =>
             _buildHomeAppBar(context, viewModel),
       );

  @override
  void initialContent(HomeViewModel viewModel, BuildContext context) {
    viewModel.setArguments(arguments);
    // ViewModel handles wishlist initialization internally
    viewModel.initial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    HomeViewModel viewModel,
    HomeState state,
  ) {
    return _buildBody(context, viewModel, state);
  }

  Widget _buildBody(
    BuildContext context,
    HomeViewModel viewModel,
    HomeState state,
  ) {
    // ✅ Listen for auth required state and navigate to auth screen
    if (state is HomeAuthRequiredState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint('🔒 Auth required, navigating to auth screen');
        context.snackbarWarning(state.message, duration: context.durationLong);
        // Reset to loading state to prevent infinite loop
        viewModel.restart();
        // Navigate to auth
        context.push('/auth');
      });
      // Show simple loading indicator while navigating
      return const Center(child: CircularProgressIndicator());
    }

    // Build content based on state - using simple loading indicator
    if (state is HomeErrorState) {
      return buildError(state.message, onRetry: () => viewModel.loadProducts());
    }

    if (state is HomeLoadingState) {
      // Use simple loading indicator instead of LoadingView to prevent blocking
      return const Center(child: CircularProgressIndicator());
    }

    if (state is HomeLoadedState) {
      // Use RepaintBoundary and lazy loading to prevent blocking
      return RepaintBoundary(
        child: HomeContentWidget(state: state, viewModel: viewModel),
      );
    }

    // Initial state - show simple loading indicator
    return const Center(child: CircularProgressIndicator());
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
    title: OsmeaComponents.text(
      appName,
      color: OsmeaColors.thunder,
      textStyle: OsmeaTextStyle.titleLarge(
        context,
      ).copyWith(fontWeight: FontWeight.w700),
    ),
    variant: AppBarVariant.standard,
    size: AppBarSize.standard,
    backgroundColor: OsmeaColors.white,
    foregroundColor: OsmeaColors.thunder,
    actions: const [],
  );
}
