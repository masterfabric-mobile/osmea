import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/models/empty_view_models.dart';
import 'package:core/src/views/empty_view/cubit/empty_view_cubit.dart';
import 'package:core/src/views/empty_view/cubit/empty_view_state.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🚀 **OSMEA Empty View Startup Widget**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Ultra minimalist empty view style - Pure white space design with text focus
/// Perfect for startup applications with clean, modern aesthetics
///
/// {@category Widgets}
/// {@subCategory EmptyViewStartup}

class EmptyViewStartupWidget extends StatefulWidget {
  final VoidCallback? onActionPressed;

  const EmptyViewStartupWidget({
    super.key,
    this.onActionPressed,
  });

  @override
  State<EmptyViewStartupWidget> createState() =>
      _EmptyViewStartupWidgetState();
}

class _EmptyViewStartupWidgetState extends State<EmptyViewStartupWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocBuilder<EmptyViewCubit, EmptyViewState>(
      builder: (context, state) {
        if (state.status != EmptyViewStatus.showingEmpty) {
          return const SizedBox.shrink();
        }

        final config = state.config;
        final currentEmptyPage = state.currentEmptyPage;

        // Update animation duration from config
        if (config?.animationDuration != null) {
          _animationController.duration =
              Duration(milliseconds: config!.animationDuration);
        }

        // Get colors from config
        final backgroundColor = currentEmptyPage?.getBackgroundColor() ??
            config?.getBackgroundColor() ??
            config?.getPrimaryColor() ??
            OsmeaColors.white;
        final textColor = currentEmptyPage?.getTextColor() ??
            config?.getTextColor() ??
            OsmeaColors.black;

        // Get messages from config
        final title = state.emptyTitle;
        final description = state.emptyDescription;

        return FadeTransition(
          opacity: _fadeAnimation,
          child: OsmeaComponents.container(
            color: backgroundColor,
            child: SafeArea(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenSize.height -
                      MediaQuery.of(context).viewPadding.top -
                      MediaQuery.of(context).viewPadding.bottom,
                ),
                child: SingleChildScrollView(
                  child: OsmeaComponents.container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.08,
                      vertical: screenSize.height * 0.05,
                    ),
                    child: OsmeaComponents.column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icon Circle (always show, even if image/icon path provided)
                        _buildIconCircle(context, state, config, textColor),

                        OsmeaComponents.sizedBox(
                            height: screenSize.height * 0.04),

                        // Main Empty Title
                        OsmeaComponents.text(
                          title,
                          color: textColor,
                          textAlign: TextAlign.center,
                          textStyle:
                              OsmeaTextStyle.headlineMedium(context).copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                          ),
                        ),

                        OsmeaComponents.sizedBox(
                            height: screenSize.height * 0.02),

                        // Empty Description
                        OsmeaComponents.text(
                          description,
                          color: textColor.withOpacity(0.7),
                          textAlign: TextAlign.center,
                          textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                          ),
                        ),

                        OsmeaComponents.sizedBox(
                            height: screenSize.height * 0.06),

                        // Action Button (if enabled in config and callback provided)
                        if (config?.showActionButton == true &&
                            widget.onActionPressed != null)
                          OsmeaComponents.button(
                            text: state.actionButtonText ?? 'Continue',
                            onPressed: widget.onActionPressed,
                            variant: ButtonVariant.primary,
                            size: ButtonSize.medium,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildIconCircle(
    BuildContext context,
    EmptyViewState state,
    EmptyViewConfigModel? config,
    Color textColor,
  ) {
    final accentColor = config?.getSecondaryColor() ?? OsmeaColors.nordicBlue;
    final icon = _getEmptyIcon(state.currentEmptyType);
    
    return OsmeaComponents.container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 60,
        color: accentColor,
      ),
    );
  }

  IconData _getEmptyIcon(EmptyType emptyType) {
    switch (emptyType) {
      case EmptyType.cart:
        return Icons.shopping_cart_outlined;
      case EmptyType.search:
        return Icons.search_off;
      case EmptyType.favorites:
        return Icons.favorite_border;
      case EmptyType.wishlist:
        return Icons.favorite_border;
      case EmptyType.products:
        return Icons.inventory_2_outlined;
      case EmptyType.orders:
        return Icons.receipt_long_outlined;
      case EmptyType.notifications:
        return Icons.notifications_none;
      case EmptyType.messages:
        return Icons.message_outlined;
      case EmptyType.history:
        return Icons.history_outlined;
      case EmptyType.reviews:
        return Icons.rate_review_outlined;
      case EmptyType.addresses:
        return Icons.location_on_outlined;
      case EmptyType.payments:
        return Icons.payment_outlined;
      default:
        return Icons.inbox_outlined;
    }
  }
}
