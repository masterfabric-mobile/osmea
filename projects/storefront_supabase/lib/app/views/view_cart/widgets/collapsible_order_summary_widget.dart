/*
 * Collapsible Order Summary Widget
 * ---------------------------------
 * Bottom-stacked collapsible order summary widget.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:storefront_supabase/app/views/view_cart/models/view_model.dart';
import 'package:storefront_supabase/app/views/view_cart/models/states.dart';
import 'package:storefront_supabase/app/views/view_cart/widgets/order_summary_widget.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Collapsible order summary widget for bottom of cart
class CollapsibleOrderSummaryWidget extends StatefulWidget {
  final CartViewModel viewModel;
  final CartLoadedState state;
  final ValueChanged<bool>? onExpandedChanged;

  const CollapsibleOrderSummaryWidget({
    super.key,
    required this.viewModel,
    required this.state,
    this.onExpandedChanged,
  });

  @override
  State<CollapsibleOrderSummaryWidget> createState() =>
      _CollapsibleOrderSummaryWidgetState();
}

class _CollapsibleOrderSummaryWidgetState
    extends State<CollapsibleOrderSummaryWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      // Notify parent of expanded state change
      widget.onExpandedChanged?.call(_isExpanded);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: OsmeaColors.paperWhite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Collapsible order summary (above bottom bar)
            ClipRect(
              child: SizeTransition(
                sizeFactor: _expandAnimation,
                child: Column(
                  children: [
                    OsmeaComponents.container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: OsmeaColors.grayMaterial[200] ?? OsmeaColors.pewter.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                      ),
                      child: OrderSummaryWidget(state: widget.state),
                    ),
                    OsmeaComponents.sizedBox(height: context.spacing12),
                  ],
                ),
              ),
            ),
            // Bottom summary bar with total and expand button
            OsmeaComponents.container(
              decoration: BoxDecoration(
                color: OsmeaColors.white,
                border: _isExpanded
                    ? Border(
                        top: BorderSide(
                          color: OsmeaColors.grayMaterial[200] ?? OsmeaColors.pewter.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      )
                    : null,
              ),
              child: OsmeaComponents.padding(
                padding: EdgeInsets.all(context.spacing16),
                child: OsmeaComponents.column(
                  children: [
                    // Total row with expand button
                    OsmeaComponents.row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OsmeaComponents.column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OsmeaComponents.text(
                              context.resources.total,
                              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                                color: OsmeaColors.pewter,
                              ),
                            ),
                            OsmeaComponents.sizedBox(height: context.spacing4),
                            OsmeaComponents.text(
                              PriceHelper.format(
                                widget.state.discountedTotal,
                                widget.state.currencyCode ?? 'USD',
                                Localizations.localeOf(context).toString(),
                              ),
                              textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                                fontWeight: FontWeight.w700,
                                color: OsmeaColors.thunder,
                              ),
                            ),
                          ],
                        ),
                        OsmeaComponents.iconButton(
                          onPressed: _toggleExpanded,
                          icon: AnimatedRotation(
                            turns: _isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              Icons.keyboard_arrow_up,
                              color: OsmeaColors.thunder,
                              size: context.iconSizeLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                    OsmeaComponents.sizedBox(height: context.spacing16),
                    // Checkout button
                    _buildCheckoutButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    final configHelper = AssetConfigHelper();
    final buttonColor = _parseColor(
      configHelper.getString(
        'cart_view_configuration.order_summary.checkout_button_background',
        '#000000',
      ),
    );
    final borderRadius = configHelper.getDouble(
      'cart_view_configuration.order_summary.checkout_button_border_radius',
      16.0,
    );
    
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _handleCheckout(context);
          },
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: OsmeaComponents.row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OsmeaComponents.text(
                  context.resources.proceedToCheckout,
                  textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                    color: _parseColor(
                      configHelper.getString(
                        'cart_view_configuration.order_summary.checkout_button_text_color',
                        '#FFFFFF',
                      ),
                    ),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                OsmeaComponents.sizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: _parseColor(
                    configHelper.getString(
                      'cart_view_configuration.order_summary.checkout_button_icon_color',
                      '#FFFFFF',
                    ),
                  ),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Parses color string to Color
  Color _parseColor(String colorString) {
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
      debugPrint('⚠️ Error parsing color: $colorString - $e');
      return OsmeaColors.black;
    }
  }

  void _handleCheckout(BuildContext context) async {
    final isAuthenticated =
        Supabase.instance.client.auth.currentUser != null;

    if (!isAuthenticated) {
      if (context.mounted) {
        context.snackbarWarning(
          context.resources.loginToViewCart,
          duration: const Duration(seconds: 3),
        );
        await Future.delayed(const Duration(milliseconds: 500));
        if (context.mounted) context.go('/auth');
      }
      return;
    }

    if (!context.mounted) return;
    final currentState = widget.viewModel.state;
    if (currentState is CartLoadedState) {
      context.go(
        '/checkout',
        extra: {
          'totalAmount': currentState.discountedTotal,
          'currencySymbol': currentState.currencySymbol ?? '\$',
          'currencyCode': currentState.currencyCode ?? 'USD',
        },
      );
    }
  }
}
