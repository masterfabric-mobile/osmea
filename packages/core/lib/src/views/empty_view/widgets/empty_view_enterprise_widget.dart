import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/models/empty_view_models.dart';
import 'package:core/src/views/empty_view/cubit/empty_view_cubit.dart';
import 'package:core/src/views/empty_view/cubit/empty_view_state.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🏢 **OSMEA Empty View Enterprise Widget**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Minimal text-based empty view - Clean and simple design
/// Perfect for enterprise applications with professional, business-focused aesthetics
///
/// {@category Widgets}
/// {@subCategory EmptyViewEnterprise}

class EmptyViewEnterpriseWidget extends StatefulWidget {
  final VoidCallback? onActionPressed;

  const EmptyViewEnterpriseWidget({
    super.key,
    this.onActionPressed,
  });

  @override
  State<EmptyViewEnterpriseWidget> createState() =>
      _EmptyViewEnterpriseWidgetState();
}

class _EmptyViewEnterpriseWidgetState extends State<EmptyViewEnterpriseWidget>
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

        // Get messages from config
        final title = state.emptyTitle;
        final description = state.emptyDescription;

        return FadeTransition(
          opacity: _fadeAnimation,
          child: SizedBox.expand(
            child: OsmeaComponents.center(
              child: OsmeaComponents.container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.08,
                ),
                child: OsmeaComponents.column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Professional icon circle
                    _buildIconCircle(context, state, config, textColor),

                    OsmeaComponents.sizedBox(height: context.spacing32),

                    // Empty Title - Professional centered
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

                    OsmeaComponents.sizedBox(height: context.spacing16),

                    // Professional divider
                    OsmeaComponents.container(
                      width: 60,
                      height: 2,
                      decoration: BoxDecoration(
                        color: textColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),

                    OsmeaComponents.sizedBox(height: context.spacing20),

                    // Empty Description - Professional centered
                    OsmeaComponents.text(
                      description,
                      color: textColor.withValues(alpha: 0.7),
                      textAlign: TextAlign.center,
                      textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),

                    OsmeaComponents.sizedBox(height: context.spacing32),

                    // Action Button - Professional style
                    if (config?.showActionButton == true &&
                        widget.onActionPressed != null)
                      OsmeaComponents.button(
                        text: state.actionButtonText ?? 'Continue',
                        onPressed: widget.onActionPressed,
                        variant: ButtonVariant.outlined,
                        size: ButtonSize.medium,
                        backgroundColor: Colors.transparent,
                        textColor: textColor,
                        borderColor: textColor.withValues(alpha: 0.3),
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

  Widget _buildIconCircle(
    BuildContext context,
    EmptyViewState state,
    EmptyViewConfigModel? config,
    Color textColor,
  ) {
    return OsmeaComponents.container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: textColor.withValues(alpha: 0.15),
          width: 2,
        ),
      ),
      child: OsmeaComponents.center(
        child: Icon(
          _getEmptyIcon(state.currentEmptyType),
          size: 48,
          color: textColor.withValues(alpha: 0.4),
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
