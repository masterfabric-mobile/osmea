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
import 'package:storefront_woo/app/services/cart_service.dart';

/// HomeView displays the main e-commerce product catalog
class HomeView extends MasterViewHydratedCubit<HomeViewModel, HomeState> {
  HomeView({
    super.key,
    super.arguments,
    super.currentView,
    super.snackBarFunction,
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

    return viewModel.buildContent(context, state);
  }
}

/// Shows clean cart success dialog
void _showCartSuccessDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(20),
        content: OsmeaComponents.column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            OsmeaComponents.container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: OsmeaColors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: OsmeaComponents.center(
                child: Icon(
                  Icons.check_circle,
                  size: 24,
                  color: OsmeaColors.green,
                ),
              ),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Title
            OsmeaComponents.text(
              'Success!',
              textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                color: OsmeaColors.thunder,
                fontWeight: FontWeight.bold,
              ),
            ),
            OsmeaComponents.sizedBox(height: 8),

            // Message
            OsmeaComponents.text(
              'Product added to cart successfully!',
              textStyle: OsmeaTextStyle.bodyMedium(
                context,
              ).copyWith(color: OsmeaColors.grayMaterial[600]),
              textAlign: TextAlign.center,
            ),
            OsmeaComponents.sizedBox(height: 20),

            // Action Buttons
            OsmeaComponents.row(
              children: [
                // Continue Shopping
                OsmeaComponents.expanded(
                  child: OsmeaComponents.button(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      // Stay on home page
                    },
                    backgroundColor: OsmeaColors.grayMaterial[100],
                    textColor: OsmeaColors.thunder,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    borderRadius: 8,
                    text: 'Continue',
                    textStyle: OsmeaTextStyle.bodyMedium(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                OsmeaComponents.sizedBox(width: 12),

                // Go to Cart
                OsmeaComponents.expanded(
                  child: OsmeaComponents.button(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog first
                      context.push('/cart'); // Then navigate to cart
                    },
                    backgroundColor: OsmeaColors.blue,
                    textColor: OsmeaColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    borderRadius: 8,
                    text: 'View Cart',
                    textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                      color: OsmeaColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

/// Builds home app bar following OSMEA standards
PreferredSizeWidget _buildHomeAppBar(
  BuildContext context,
  HomeViewModel? viewModel,
) {
  final cartService = CartService();
  
  return _ReactiveAppBar(
    cartService: cartService,
    viewModel: viewModel,
  );
}

/// Reactive app bar that updates when cart changes
class _ReactiveAppBar extends StatefulWidget implements PreferredSizeWidget {
  final CartService cartService;
  final HomeViewModel? viewModel;

  const _ReactiveAppBar({
    required this.cartService,
    this.viewModel,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<_ReactiveAppBar> createState() => _ReactiveAppBarState();
}

class _ReactiveAppBarState extends State<_ReactiveAppBar> {
  String _appName = 'Home';

  @override
  void initState() {
    super.initState();
    _loadAppName();
  }

  Future<void> _loadAppName() async {
    try {
      final configHelper = AssetConfigHelper();
      await configHelper.loadConfig('assets/app_config.json');
      final appName = configHelper.getString(
        'app_settings.app_name',
        'Home',
      );
      if (mounted) {
        setState(() {
          _appName = appName;
        });
      }
    } catch (e) {
      debugPrint('❌ Error loading app name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.cartService,
      builder: (context, child) {
        return OsmeaComponents.appBar(
          padding: const EdgeInsets.only(bottom: 16),
          title: OsmeaComponents.text(
            _appName,
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
              onPressed: () => widget.viewModel?.restart(),
              tooltip: 'Restart',
            ),
            // Cart button with badge - using custom icon widget
            AppBarAction(
              type: AppBarActionType.secondary,
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.shopping_cart, color: OsmeaColors.thunder),
                  if (widget.cartService.itemCount > 0)
                    Positioned(
                      right: -8,
                      top: -8,
                        child: Container(
                        padding: widget.cartService.itemCount > 9
                            ? const EdgeInsets.symmetric(horizontal: 4, vertical: 1)
                            : const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: OsmeaColors.red,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: OsmeaColors.white,
                            width: 1.5,
                          ),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            widget.cartService.itemCount > 99 ? '99+' : '${widget.cartService.itemCount}',
                            style: OsmeaTextStyle.bodySmall(context).copyWith(
                              color: OsmeaColors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () => context.go('/cart'),
              tooltip: 'Cart (${widget.cartService.itemCount})',
            ),
          ],
        );
      },
    );
  }
}
