import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:core/src/models/empty_view_models.dart';
import 'package:core/src/views/empty_view/cubit/empty_view_cubit.dart';
import 'package:core/src/views/empty_view/cubit/empty_view_state.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🌌 **OSMEA Empty View Space Widget**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Modern minimalist empty view - Full screen white space with elegant typography
/// Designed for space-themed applications with futuristic aesthetics
///
/// {@category Widgets}
/// {@subCategory EmptyViewSpace}

class EmptyViewSpaceWidget extends StatefulWidget {
  final VoidCallback? onActionPressed;

  const EmptyViewSpaceWidget({
    super.key,
    this.onActionPressed,
  });

  @override
  State<EmptyViewSpaceWidget> createState() => _EmptyViewSpaceWidgetState();
}

class _EmptyViewSpaceWidgetState extends State<EmptyViewSpaceWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
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
        final accentColor =
            config?.getSecondaryColor() ?? OsmeaColors.nordicBlue;

        // Get messages from config
        final title = state.emptyTitle;
        final description = state.emptyDescription;

        return OsmeaComponents.scaffold(
          backgroundColor: backgroundColor,
          appBar: OsmeaComponents.appBar(
            title: OsmeaComponents.text(
              title,
              color: textColor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: () {
                context.go('/home');
              },
            ),
          ),
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SafeArea(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: screenSize.height -
                        MediaQuery.of(context).viewPadding.top -
                        MediaQuery.of(context).viewPadding.bottom -
                        kToolbarHeight,
                  ),
                  child: SingleChildScrollView(
                    child: OsmeaComponents.container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.1,
                        vertical: screenSize.height * 0.05,
                      ),
                      child: OsmeaComponents.center(
                        child: OsmeaComponents.column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Image or Icon
                            if (state.imagePath != null ||
                                state.iconPath != null)
                              _buildImageOrIcon(
                                  context, state, config, accentColor),

                            if (state.imagePath != null ||
                                state.iconPath != null)
                              OsmeaComponents.sizedBox(
                                  height: screenSize.height * 0.03),

                            // Icon Circle (if no image/icon provided)
                            if (state.imagePath == null &&
                                state.iconPath == null)
                              OsmeaComponents.container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: accentColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _getEmptyIcon(state.currentEmptyType),
                                  size: 40,
                                  color: accentColor,
                                ),
                              ),

                            if (state.imagePath == null &&
                                state.iconPath == null)
                              OsmeaComponents.sizedBox(
                                  height: screenSize.height * 0.03),

                            // Main Empty Title
                            OsmeaComponents.text(
                              title,
                              color: textColor,
                              textAlign: TextAlign.center,
                              textStyle: OsmeaTextStyle.headlineMedium(context)
                                  .copyWith(
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
                              textStyle:
                                  OsmeaTextStyle.bodyLarge(context).copyWith(
                                fontWeight: FontWeight.w300,
                                height: 1.6,
                              ),
                            ),

                            OsmeaComponents.sizedBox(
                                height: screenSize.height * 0.05),

                            // Action Button (if enabled in config and callback provided)
                            if (config?.showActionButton == true &&
                                widget.onActionPressed != null)
                              SizedBox(
                                width: 200,
                                child: OsmeaComponents.button(
                                  text: state.actionButtonText ?? 'Continue',
                                  onPressed: widget.onActionPressed,
                                  variant: ButtonVariant.primary,
                                  size: ButtonSize.medium,
                                ),
                              ),
                          ],
                        ),
                      ),
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

  Widget _buildImageOrIcon(
    BuildContext context,
    EmptyViewState state,
    EmptyViewConfigModel? config,
    Color accentColor,
  ) {
    final screenSize = MediaQuery.of(context).size;

    if (state.imagePath != null) {
      // Try to load as network image first, then asset
      if (state.imagePath!.startsWith('http://') ||
          state.imagePath!.startsWith('https://')) {
        return Image.network(
          state.imagePath!,
          width: screenSize.width * 0.5,
          height: screenSize.width * 0.5,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultIcon(context, accentColor);
          },
        );
      } else {
        return Image.asset(
          state.imagePath!,
          width: screenSize.width * 0.5,
          height: screenSize.width * 0.5,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultIcon(context, accentColor);
          },
        );
      }
    } else if (state.iconPath != null) {
      if (state.iconPath!.startsWith('http://') ||
          state.iconPath!.startsWith('https://')) {
        return Image.network(
          state.iconPath!,
          width: 100,
          height: 100,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultIcon(context, accentColor);
          },
        );
      } else {
        return Image.asset(
          state.iconPath!,
          width: 100,
          height: 100,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultIcon(context, accentColor);
          },
        );
      }
    }

    return _buildDefaultIcon(context, accentColor);
  }

  Widget _buildDefaultIcon(BuildContext context, Color accentColor) {
    return OsmeaComponents.container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.inbox_outlined,
        size: 40,
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
