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
        context.snackbarWarning(
          state.message,
          duration: context.durationLong,
        );
        // Reset to loading state to prevent infinite loop
        viewModel.restart();
        // Navigate to auth
        context.push('/auth');
      });
      // Show LoadingView while navigating
      return LoadingView(
        goRoute: goRoute,
        loadingType: LoadingModelType.authentication,
        loadingSteps: ['Redirecting to sign in...'],
        stepDuration: context.durationMedium,
        showProgress: false,
      );
    }

    // Build content based on state - using LoadingView
    if (state is HomeErrorState) {
      return buildError(state.message, onRetry: () => viewModel.loadProducts());
    }

    if (state is HomeLoadingState) {
      return LoadingView(
        goRoute: goRoute,
        loadingType: LoadingModelType.dataLoading,
        stepDuration: context.durationSlow,
        showCancelButton: false,
      );
    }

    if (state is HomeLoadedState) {
      return HomeContentWidget(state: state, viewModel: viewModel);
    }

    // Initial state - show loading
    return LoadingView(
      goRoute: goRoute,
      loadingType: LoadingModelType.initialization,
    );
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
