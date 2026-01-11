/*
 * CartView
 * --------
 * Cart view for the storefront app following OSMEA architecture.
 * Uses MasterViewHydratedCubit pattern with HydratedBloc state management.
 */

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_cart/models/cart_view_model.dart';
import 'package:storefront_woo/app/views/view_cart/models/module/states.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/cart_content_widget.dart';
import 'package:storefront_woo/app/utils/unified_loading_widget.dart';

/// CartView displays the shopping cart with items and checkout functionality
class CartView extends MasterViewHydratedCubit<CartViewModel, CartState> {
  CartView({
    super.key,
    super.arguments,
    super.currentView,
    super.snackBarFunction,
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.horizontalPadding = const PaddingVisibility.enabled(),
    required super.goRoute,
  }) : super(
         coreAppBar: (context, viewModel) => _buildCartAppBar(context, viewModel),
       ) {
    debugPrint('🛒 CartView: Constructor called');
  }

  @override
  void initialContent(CartViewModel viewModel, BuildContext context) {
    debugPrint('🛒 CartView: initialContent called');
    // Set arguments to ViewModel
    viewModel.setArguments(arguments);
    // Load cart - token will be taken from arguments or storage
    viewModel.loadCart(cartToken: arguments['cartToken'] as String?);
  }

  @override
  Widget viewContent(
    BuildContext context,
    CartViewModel viewModel,
    CartState state,
  ) {
    debugPrint(
      '🛒 CartView: viewContent called with state: ${state.runtimeType}',
    );

    // Handle auth required state (removed checkout functionality)
    if (state is CartAuthRequiredState) {
      _showAuthRequiredMessage(context, state.message);
      return _buildAuthRequiredLoading(context);
    }

    return _buildBody(context, viewModel, state);
  }

  Widget _buildBody(
    BuildContext context,
    CartViewModel viewModel,
    CartState state,
  ) {
    // Error state
    if (state is CartErrorState) {
      return ErrorHandlingView(
        goRoute: goRoute,
        customRetryFunction: () async {
          viewModel.loadCart();
          return true;
        },
      );
    }

    // Use BlocBuilder to listen to state changes and preserve loaded state during loading
    return BlocBuilder<CartViewModel, CartState>(
      bloc: viewModel,
      builder: (context, currentState) {
        // Get the loaded state - prefer currentState if it's loaded, otherwise use lastLoadedState or state parameter
        CartLoadedState? loadedState;
        if (currentState is CartLoadedState) {
          loadedState = currentState;
        } else if (state is CartLoadedState) {
          // Use the state parameter if currentState is loading but we have loaded state from parameter
          loadedState = state;
        } else if (viewModel.lastLoadedState != null) {
          // Use last loaded state from viewModel when currentState is loading
          loadedState = viewModel.lastLoadedState;
        }

        // If we have a loaded state, show content with overlay
        if (loadedState != null) {
          final isLoading = currentState is CartLoadingState;
          return _buildCartContentWithRefresh(
            context,
            viewModel,
            loadedState,
            isLoading: isLoading,
          );
        }

        // Loading state or initial state - show full screen loading
        return UnifiedLoadingWidget(
          goRoute: goRoute,
          loadingSteps: ['Loading cart...'],
        );
      },
    );
  }

  Widget _buildCartContentWithRefresh(
    BuildContext context,
    CartViewModel viewModel,
    CartLoadedState state, {
    bool isLoading = false,
  }) {
    return BlocBuilder<CartViewModel, CartState>(
      bloc: viewModel,
      builder: (context, currentState) {
        final isCurrentlyLoading = isLoading || currentState is CartLoadingState;
        
        return Stack(
          children: [
            // Cart content
            RefreshIndicator(
              onRefresh: () => viewModel.refreshCart(),
              color: _getRefreshIndicatorColor(context),
              backgroundColor: _getRefreshIndicatorBackgroundColor(context),
              strokeWidth: _getRefreshIndicatorStrokeWidth(context),
              displacement: _getRefreshIndicatorDisplacement(context),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: CartContentWidget(viewModel: viewModel, state: state),
              ),
            ),
            // Loading overlay when refreshing
            if (isCurrentlyLoading)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: _getLoadingBlurSigma(context),
                    sigmaY: _getLoadingBlurSigma(context),
                  ),
                  child: Container(
                    color: _getLoadingOverlayBackgroundColor(context),
                    child: OsmeaComponents.center(
                      child: OsmeaComponents.container(
                        padding: EdgeInsets.all(context.spacing24),
                        decoration: BoxDecoration(
                          color: _getLoadingContainerBackgroundColor(context),
                          borderRadius: BorderRadius.circular(
                            _getLoadingContainerBorderRadius(context),
                          ),
                        ),
                        child: OsmeaComponents.loading(
                          type: LoadingType.circularFade,
                          size: _getLoadingSize(context),
                          color: _getLoadingColor(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// Shows authentication required message via Osmea Snackbar
  void _showAuthRequiredMessage(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.snackbarWarning(message, duration: context.durationLong);
    });
  }

  /// Builds loading widget for authentication required state
  Widget _buildAuthRequiredLoading(BuildContext context) {
    return SafeArea(
      child: OsmeaComponents.container(
        padding: context.onlyBottomPaddingNormal,
        child: OsmeaComponents.center(
          child: OsmeaComponents.loading(
            type: LoadingType.circularFade,
            size: _getLoadingSize(context),
            color: _getLoadingColor(context),
          ),
        ),
      ),
    );
  }

  /// Builds cart app bar from config
  static PreferredSizeWidget _buildCartAppBar(
    BuildContext context,
    CartViewModel? viewModel,
  ) {
    final configHelper = AssetConfigHelper();
    
    final title = configHelper.getString(
      'cart_view_configuration.app_bar.title',
      'Shopping Cart',
    );
    final backgroundColor = _parseColor(
      configHelper.getString(
        'cart_view_configuration.app_bar.backgroundColor',
        '#FFFFFF',
      ),
    );
    final foregroundColor = _parseColor(
      configHelper.getString(
        'cart_view_configuration.app_bar.foregroundColor',
        '#000000',
      ),
    );
    final titleColor = _parseColor(
      configHelper.getString(
        'cart_view_configuration.app_bar.titleColor',
        '#000000',
      ),
    );
    final iconColor = _parseColor(
      configHelper.getString(
        'cart_view_configuration.app_bar.iconColor',
        '#000000',
      ),
    );
    final elevation = configHelper.getDouble(
      'cart_view_configuration.app_bar.elevation',
      0.0,
    );
    final variantString = configHelper.getString(
      'cart_view_configuration.app_bar.variant',
      'standard',
    );
    final sizeString = configHelper.getString(
      'cart_view_configuration.app_bar.size',
      'standard',
    );
    final showBackButton = configHelper.getBool(
      'cart_view_configuration.app_bar.show_back_button',
      true,
    );
    final showRefreshButton = configHelper.getBool(
      'cart_view_configuration.app_bar.show_refresh_button',
      true,
    );
    final refreshTooltip = configHelper.getString(
      'cart_view_configuration.app_bar.refresh_tooltip',
      'Refresh cart',
    );

    final variant = _parseAppBarVariant(variantString);
    final size = _parseAppBarSize(sizeString);

    return OsmeaComponents.appBar(
      title: OsmeaComponents.text(
        title,
        color: titleColor,
        textStyle: OsmeaTextStyle.titleLarge(context),
      ),
      backgroundColor: backgroundColor,
      elevation: elevation,
      foregroundColor: foregroundColor,
      variant: variant,
      size: size,
      leading: showBackButton
          ? OsmeaComponents.iconButton(
              onPressed: () => context.go('/home'),
              icon: Icon(
                Icons.arrow_back,
                color: iconColor,
                size: context.iconSizeNormal,
              ),
            )
          : null,
      actions: showRefreshButton
          ? [
              AppBarAction(
                type: AppBarActionType.refresh,
                icon: Icon(
                  Icons.refresh,
                  color: iconColor,
                  size: context.iconSizeNormal,
                ),
                onPressed: () => viewModel?.loadCart(),
                tooltip: refreshTooltip,
              ),
            ]
          : [],
    );
  }

  /// Gets refresh indicator color from config
  static Color _getRefreshIndicatorColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'cart_view_configuration.refresh_indicator.color',
        '#000000',
      ),
    );
  }

  /// Gets refresh indicator background color from config
  static Color _getRefreshIndicatorBackgroundColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'cart_view_configuration.refresh_indicator.backgroundColor',
        '#FFFFFF',
      ),
    );
  }

  /// Gets refresh indicator stroke width from config
  static double _getRefreshIndicatorStrokeWidth(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return configHelper.getDouble(
      'cart_view_configuration.refresh_indicator.strokeWidth',
      2.0,
    );
  }

  /// Gets refresh indicator displacement from config
  static double _getRefreshIndicatorDisplacement(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return configHelper.getDouble(
      'cart_view_configuration.refresh_indicator.displacement',
      40.0,
    );
  }

  /// Gets loading overlay blur sigma from config
  static double _getLoadingBlurSigma(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return configHelper.getDouble(
      'cart_view_configuration.loading_overlay.blur_sigma',
      4.0,
    );
  }

  /// Gets loading overlay background color from config
  static Color _getLoadingOverlayBackgroundColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    final colorString = configHelper.getString(
      'cart_view_configuration.loading_overlay.background_color',
      '#FFFFFF',
    );
    final alpha = configHelper.getDouble(
      'cart_view_configuration.loading_overlay.background_alpha',
      0.7,
    );
    return _parseColor(colorString).withValues(alpha: alpha);
  }

  /// Gets loading container background color from config
  static Color _getLoadingContainerBackgroundColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'cart_view_configuration.loading_overlay.container_background_color',
        '#FFFFFF',
      ),
    );
  }

  /// Gets loading container border radius from config
  static double _getLoadingContainerBorderRadius(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return configHelper.getDouble(
      'cart_view_configuration.loading_overlay.container_border_radius',
      16.0,
    );
  }

  /// Gets loading color from config
  static Color _getLoadingColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'cart_view_configuration.loading_overlay.loading_color',
        '#000000',
      ),
    );
  }

  /// Gets loading size from config
  static double _getLoadingSize(BuildContext context) {
    final configHelper = AssetConfigHelper();
    final sizeString = configHelper.getString(
      'cart_view_configuration.loading_overlay.loading_size',
      'large',
    );
    switch (sizeString.toLowerCase()) {
      case 'small':
        return context.iconSizeSmall;
      case 'medium':
        return context.iconSizeNormal;
      case 'large':
        return context.iconSizeLarge;
      default:
        return context.iconSizeLarge;
    }
  }

  /// Parses color string to Color
  static Color _parseColor(String colorString) {
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
  static AppBarVariant _parseAppBarVariant(String variantString) {
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
  static AppBarSize _parseAppBarSize(String sizeString) {
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
}
