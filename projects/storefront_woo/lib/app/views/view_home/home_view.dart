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
import 'package:storefront_woo/gen/translations.g.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_home/models/module/states.dart';
import 'package:storefront_woo/app/views/view_home/widgets/home_content_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/home_error_widget.dart';
import 'package:storefront_woo/app/views/view_home/widgets/home_skeleton_widget.dart';
import 'package:storefront_woo/app/utils/unified_loading_widget.dart';
import 'package:storefront_woo/app/widgets/config_update_notifier.dart';
import 'package:storefront_woo/utils/config_utils.dart';

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

    // When user is on home and there is a pending config update, show snackbar and restart
    final scope = ConfigUpdateScope.maybeOf(context);
    if (scope?.hasPendingConfigUpdate == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ConfigUpdateScope.maybeOf(context)?.showSnackbarAndRestart();
      });
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
  final configHelper = AssetConfigHelper();

  // Get title from config
  final titleSource = configHelper.getString(
    'home_view.app_bar.title_source',
    'app_settings.app_name',
  );
  final fallbackTitle = configHelper.getString(
    'home_view.app_bar.fallback_title',
    'MasterFabric',
  );
  final title = configHelper.getString(titleSource, fallbackTitle);

  // Get colors from config
  final backgroundColor = _parseColor(
    configHelper.getString('home_view.app_bar.backgroundColor', '#FFFFFF'),
  );
  final foregroundColor = _parseColor(
    configHelper.getString('home_view.app_bar.foregroundColor', '#000000'),
  );
  final titleColor = _parseColor(
    configHelper.getString('home_view.app_bar.titleColor', '#000000'),
  );

  // Get other properties from config
  final elevation = configHelper.getDouble('home_view.app_bar.elevation', 0.0);
  final variantString = configHelper.getString(
    'home_view.app_bar.variant',
    'standard',
  );
  final sizeString = configHelper.getString(
    'home_view.app_bar.size',
    'standard',
  );
  final titleFontWeight = configHelper.getInt(
    'home_view.app_bar.titleFontWeight',
    700,
  );

  final variant = _parseAppBarVariant(variantString);
  final size = _parseAppBarSize(sizeString);

  // Parse font weight (100-900, must be multiple of 100)
  final fontWeight = _parseFontWeight(titleFontWeight);

  // Get search config
  final searchConfig = configHelper.getObject('home_view.search');
  final searchPlaceholder =
      configString(searchConfig?['placeholder']) ??
      context.t.homeView.widgets.search.placeholder;
  final searchVariant = configString(searchConfig?['variant']) ?? 'outlined';

  // Create controllers for home searchbar (just for navigation)
  final searchFocusNode = FocusNode();
  final searchController = TextEditingController();

  // Listen for focus changes to navigate on tap (same as search view)
  searchFocusNode.addListener(() {
    if (searchFocusNode.hasFocus) {
      // Navigate to search when searchbar is focused (tapped) with fromHome flag
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.push('/search?fromHome=true');
        }
      });
    }
  });

  return OsmeaComponents.appBarWithSearchBar(
    title: OsmeaComponents.text(
      title,
      color: titleColor,
      textStyle: OsmeaTextStyle.titleLarge(
        context,
      ).copyWith(fontWeight: fontWeight),
    ),
    titleAlignment: AppBarTitleAlignment.center,
    centerTitle: true,
    appBarVariant: variant,
    appBarSize: size,
    appBarBackgroundColor: backgroundColor,
    appBarForegroundColor: foregroundColor,
    appBarElevation: elevation,
    searchHint: searchPlaceholder,
    searchController: searchController,
    searchFocusNode: searchFocusNode,
    searchBarVariant: searchVariant == 'outlined'
        ? SearchbarVariant.outlined
        : SearchbarVariant.borderless,
    searchBarSize: TextFieldSize.medium,
    showBackButton: false,
    showClearButton: true,
    showSearchIcon: true,
    onSearch: (query) {
      // Navigate to search with query and fromHome flag
      if (query.trim().isNotEmpty) {
        context.push(
          '/search?query=${Uri.encodeComponent(query.trim())}&fromHome=true',
        );
      } else {
        context.push('/search?fromHome=true');
      }
    },
    onSearchSubmitted: (query) {
      // Navigate to search with query and fromHome flag
      if (query.trim().isNotEmpty) {
        context.push(
          '/search?query=${Uri.encodeComponent(query.trim())}&fromHome=true',
        );
      } else {
        context.push('/search?fromHome=true');
      }
    },
    onSearchChanged: (query) {
      // When user starts typing, navigate to search with fromHome flag
      if (query.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            context.push(
              '/search?query=${Uri.encodeComponent(query.trim())}&fromHome=true',
            );
          }
        });
      }
    },
    actions: const [],
  );
}

/// Parses color string to Color
Color _parseColor(String colorString) {
  try {
    // Remove # if present
    String hex = colorString.replaceAll('#', '');

    // Handle ARGB format (8 characters)
    if (hex.length == 8) {
      final alpha = int.parse(hex.substring(0, 2), radix: 16);
      final red = int.parse(hex.substring(2, 4), radix: 16);
      final green = int.parse(hex.substring(4, 6), radix: 16);
      final blue = int.parse(hex.substring(6, 8), radix: 16);
      return Color.fromARGB(alpha, red, green, blue);
    }

    // Handle RGB format (6 characters)
    if (hex.length == 6) {
      final red = int.parse(hex.substring(0, 2), radix: 16);
      final green = int.parse(hex.substring(2, 4), radix: 16);
      final blue = int.parse(hex.substring(4, 6), radix: 16);
      return Color.fromRGBO(red, green, blue, 1.0);
    }

    // Fallback to black
    return OsmeaColors.black;
  } catch (e) {
    debugPrint('⚠️ Error parsing color: $colorString - $e');
    return OsmeaColors.black;
  }
}

/// Parses app bar variant string to AppBarVariant
AppBarVariant _parseAppBarVariant(String variantString) {
  switch (variantString.toLowerCase()) {
    case 'standard':
      return AppBarVariant.standard;
    case 'transparent':
      return AppBarVariant.transparent;
    case 'primary':
      return AppBarVariant.primary;
    case 'secondary':
      return AppBarVariant.secondary;
    case 'surface':
      return AppBarVariant.surface;
    case 'glass':
      return AppBarVariant.glass;
    case 'gradient':
      return AppBarVariant.gradient;
    case 'outlined':
      return AppBarVariant.outlined;
    case 'elevated':
      return AppBarVariant.elevated;
    default:
      return AppBarVariant.standard;
  }
}

/// Parses app bar size string to AppBarSize
AppBarSize _parseAppBarSize(String sizeString) {
  switch (sizeString.toLowerCase()) {
    case 'compact':
      return AppBarSize.compact;
    case 'standard':
      return AppBarSize.standard;
    case 'comfortable':
      return AppBarSize.comfortable;
    case 'large':
      return AppBarSize.large;
    case 'extralarge':
      return AppBarSize.extraLarge;
    default:
      return AppBarSize.standard;
  }
}

/// Parses font weight integer to FontWeight
FontWeight _parseFontWeight(int weight) {
  // Clamp to valid range (100-900, multiples of 100)
  final clampedWeight = weight.clamp(100, 900);
  final normalizedWeight = (clampedWeight ~/ 100) * 100;

  switch (normalizedWeight) {
    case 100:
      return FontWeight.w100;
    case 200:
      return FontWeight.w200;
    case 300:
      return FontWeight.w300;
    case 400:
      return FontWeight.w400;
    case 500:
      return FontWeight.w500;
    case 600:
      return FontWeight.w600;
    case 700:
      return FontWeight.w700;
    case 800:
      return FontWeight.w800;
    case 900:
      return FontWeight.w900;
    default:
      return FontWeight.w700;
  }
}
