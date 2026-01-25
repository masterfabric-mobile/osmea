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
  State<EmptyViewStartupWidget> createState() => _EmptyViewStartupWidgetState();
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
        final textColor = currentEmptyPage?.getTextColor() ??
            config?.getTextColor() ??
            OsmeaColors.black;
        final backgroundColor = currentEmptyPage?.getBackgroundColor() ??
            config?.getBackgroundColor() ??
            config?.getPrimaryColor() ??
            OsmeaColors.white;

        // Get messages from config
        final title = state.emptyTitle;
        final description = state.emptyDescription;

        return FadeTransition(
          opacity: _fadeAnimation,
          child: SizedBox.expand(
            child: OsmeaComponents.center(
              child: OsmeaComponents.container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.1,
                ),
                child: OsmeaComponents.column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Large minimalist icon
                    _buildMinimalistIcon(context, state, config, textColor),

                    OsmeaComponents.sizedBox(height: context.spacing40),

                    // Clean Title
                    OsmeaComponents.text(
                      title,
                      color: textColor,
                      textAlign: TextAlign.center,
                      textStyle: OsmeaTextStyle.headlineLarge(context).copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.8,
                      ),
                    ),

                    OsmeaComponents.sizedBox(height: context.spacing12),

                    // Minimal underline
                    OsmeaComponents.container(
                      width: 40,
                      height: 3,
                      decoration: BoxDecoration(
                        color: textColor,
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),

                    OsmeaComponents.sizedBox(height: context.spacing24),

                    // Simple Description
                    OsmeaComponents.text(
                      description,
                      color: textColor.withValues(alpha: 0.6),
                      textAlign: TextAlign.center,
                      textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: 0.2,
                      ),
                    ),

                    OsmeaComponents.sizedBox(height: context.spacing40),

                    // Bold primary button
                    if (config?.showActionButton == true &&
                        widget.onActionPressed != null)
                      OsmeaComponents.button(
                        text: state.actionButtonText ?? 'Get Started',
                        onPressed: widget.onActionPressed,
                        variant: ButtonVariant.primary,
                        size: ButtonSize.large,
                        backgroundColor: textColor,
                        textColor: backgroundColor,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMinimalistIcon(
    BuildContext context,
    EmptyViewState state,
    EmptyViewConfigModel? config,
    Color textColor,
  ) {
    final icon = _getEmptyIcon(state.currentEmptyType);

    return OsmeaComponents.container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: textColor.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: OsmeaComponents.center(
        child: Icon(
          icon,
          size: 40,
          color: textColor.withValues(alpha: 0.8),
        ),
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
