/*
 * HomeView - E-commerce Home Page
 * -----------------------------
 * A modern e-commerce home page following OSMEA architecture.
 * Uses MasterViewHydratedCubit pattern with HydratedBloc state management.
 * Built entirely with OsmeaComponents for consistent UI.
 */

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_home/models/module/states.dart';
import 'package:storefront_woo/app/views/view_home/widgets/home_content_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/home_error_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/home_skeleton_widget.dart';
import 'package:storefront_woo/app/utils/unified_loading_widget.dart';

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
    return _HomeViewWithRouteAware(
      state: state,
      viewModel: viewModel,
      buildBody: _buildBody,
    );
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
      // Show unified loading indicator while navigating
      return buildUnifiedLoading(goRoute: goRoute);
    }

    // Build content based on state - using helpful error widget
    if (state is HomeErrorState) {
      return HomeErrorWidget(
        message: state.message,
        onRetry: () => viewModel.loadProducts(),
      );
    }

    if (state is HomeLoadingState) {
      // Show skeleton loading widget
      return const HomeSkeletonWidget();
    }

    if (state is HomeLoadedState) {
      // Use RepaintBoundary and lazy loading to prevent blocking
      // Use key based on route to force rebuild when navigating back
      return RepaintBoundary(
        child: HomeContentWidget(
          key: ValueKey(GoRouterState.of(context).uri.toString()),
          state: state,
          viewModel: viewModel,
        ),
      );
    }

    // Initial state - show skeleton loading
    return const HomeSkeletonWidget();
  }
}

/// Wrapper widget that listens to route changes and refreshes config
class _HomeViewWithRouteAware extends StatefulWidget {
  final HomeState state;
  final HomeViewModel viewModel;
  final Widget Function(BuildContext, HomeViewModel, HomeState) buildBody;

  const _HomeViewWithRouteAware({
    required this.state,
    required this.viewModel,
    required this.buildBody,
  });

  @override
  State<_HomeViewWithRouteAware> createState() =>
      _HomeViewWithRouteAwareState();
}

class _HomeViewWithRouteAwareState extends State<_HomeViewWithRouteAware>
    with WidgetsBindingObserver {
  String? _lastRoute;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App resumed - refresh config
      _refreshConfig();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentRoute = GoRouterState.of(context).uri.toString();
    
    // Only refresh if route changed (navigated back) or first time
    if (!_hasInitialized || _lastRoute != currentRoute) {
      _lastRoute = currentRoute;
      if (_hasInitialized) {
        // Route changed - refresh config
        _refreshConfig();
      } else {
        _hasInitialized = true;
      }
    }
  }

  void _refreshConfig() {
    debugPrint('🔄 HomeView: Refreshing configuration from app_config.json');
    // Trigger rebuild by calling initial again to reload config
    widget.viewModel.initial();
  }

  @override
  Widget build(BuildContext context) {
    return widget.buildBody(context, widget.viewModel, widget.state);
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
