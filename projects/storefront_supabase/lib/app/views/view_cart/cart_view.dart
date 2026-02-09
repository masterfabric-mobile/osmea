/*
 * CartView
 * --------
 * Cart view for the storefront app following OSMEA architecture.
 * Uses MasterViewCubit pattern with Cubit state management.
 */

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/app/views/view_cart/models/view_model.dart';
import 'package:storefront_supabase/app/views/view_cart/models/states.dart';
import 'package:storefront_supabase/app/views/view_cart/widgets/cart_content_widget.dart';
import 'package:storefront_supabase/app/views/view_cart/widgets/cart_error_widget.dart';
import 'package:storefront_supabase/app/utils/unified_loading_widget.dart';

/// CartView displays the shopping cart with items and checkout functionality
class CartView extends MasterViewCubit<CartViewModel, CartState> {
  CartView({
    super.key,
    super.arguments,
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.horizontalPadding = const PaddingVisibility.enabled(),
    required super.goRoute,
  }) : super(
         coreAppBar: (context, viewModel) => _buildCartAppBar(context, viewModel),
       );

  @override
  void initialContent(CartViewModel viewModel, BuildContext context) {
    viewModel.setArguments(arguments);
    viewModel.initial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    CartViewModel viewModel,
    CartState state,
  ) {
    if (state is CartAuthRequiredState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.snackbarWarning(state.message, duration: context.durationLong);
      });
      return _buildAuthRequiredLoading(context);
    }

    return _buildBody(context, viewModel, state);
  }

  Widget _buildBody(
    BuildContext context,
    CartViewModel viewModel,
    CartState state,
  ) {
    if (state is CartErrorState) {
      return CartErrorWidget(
        message: state.message,
        onRetry: () => viewModel.refreshCart(),
      );
    }

    // Use BlocBuilder to listen to state changes and preserve loaded state during loading
    return BlocBuilder<CartViewModel, CartState>(
      bloc: viewModel,
      builder: (context, currentState) {
        CartLoadedState? loadedState;
        if (currentState is CartLoadedState) {
          loadedState = currentState;
        } else if (state is CartLoadedState) {
          loadedState = state;
        } else if (viewModel.lastLoadedState != null) {
          loadedState = viewModel.lastLoadedState;
        }

        if (loadedState != null) {
          final isLoading = currentState is CartLoadingState;
          return _buildCartContentWithRefresh(
            context,
            viewModel,
            loadedState,
            isLoading: isLoading,
          );
        }

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
        final showGlobalLoading = isLoading && currentState is CartLoadingState;
        
        return Stack(
          children: [
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
            if (showGlobalLoading)
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

  static PreferredSizeWidget _buildCartAppBar(
    BuildContext context,
    CartViewModel? viewModel,
  ) {
    final configHelper = AssetConfigHelper();
    
    final title = 'Shopping Cart';
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
    final showBackButton = configHelper.getBool(
      'cart_view_configuration.app_bar.show_back_button',
      true,
    );
    final showRefreshButton = configHelper.getBool(
      'cart_view_configuration.app_bar.show_refresh_button',
      true,
    );

    return OsmeaComponents.appBar(
      title: OsmeaComponents.text(
        title,
        color: titleColor,
        textStyle: OsmeaTextStyle.titleLarge(context),
      ),
      backgroundColor: backgroundColor,
      elevation: elevation,
      foregroundColor: foregroundColor,
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
                onPressed: () => viewModel?.refreshCart(),
                tooltip: 'Refresh cart',
              ),
            ]
          : [],
    );
  }

  static Color _getRefreshIndicatorColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'cart_view_configuration.refresh_indicator.color',
        '#000000',
      ),
    );
  }

  static Color _getRefreshIndicatorBackgroundColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'cart_view_configuration.refresh_indicator.backgroundColor',
        '#FFFFFF',
      ),
    );
  }

  static double _getRefreshIndicatorStrokeWidth(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return configHelper.getDouble(
      'cart_view_configuration.refresh_indicator.strokeWidth',
      2.0,
    );
  }

  static double _getRefreshIndicatorDisplacement(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return configHelper.getDouble(
      'cart_view_configuration.refresh_indicator.displacement',
      40.0,
    );
  }

  static double _getLoadingBlurSigma(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return configHelper.getDouble(
      'cart_view_configuration.loading_overlay.blur_sigma',
      4.0,
    );
  }

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

  static Color _getLoadingContainerBackgroundColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'cart_view_configuration.loading_overlay.container_background_color',
        '#FFFFFF',
      ),
    );
  }

  static double _getLoadingContainerBorderRadius(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return configHelper.getDouble(
      'cart_view_configuration.loading_overlay.container_border_radius',
      16.0,
    );
  }

  static Color _getLoadingColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'cart_view_configuration.loading_overlay.loading_color',
        '#000000',
      ),
    );
  }

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

  static Color _parseColor(String colorString) {
    try {
      String hex = colorString.replaceAll('#', '');
      if (hex.length == 8) {
        final alpha = int.parse(hex.substring(0, 2), radix: 16);
        final red = int.parse(hex.substring(2, 4), radix: 16);
        final green = int.parse(hex.substring(4, 6), radix: 16);
        final blue = int.parse(hex.substring(6, 8), radix: 16);
        return Color.fromARGB(alpha, red, green, blue);
      }
      if (hex.length == 6) {
        final red = int.parse(hex.substring(0, 2), radix: 16);
        final green = int.parse(hex.substring(2, 4), radix: 16);
        final blue = int.parse(hex.substring(4, 6), radix: 16);
        return Color.fromRGBO(red, green, blue, 1.0);
      }
      return OsmeaColors.black;
    } catch (e) {
      return OsmeaColors.black;
    }
  }
}
