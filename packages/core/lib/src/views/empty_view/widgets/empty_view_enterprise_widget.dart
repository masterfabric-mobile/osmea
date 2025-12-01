import 'package:flutter/foundation.dart';
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

class _EmptyViewEnterpriseWidgetState
    extends State<EmptyViewEnterpriseWidget> with TickerProviderStateMixin {
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
                      crossAxisAlignment: crossStart,
                      children: [
                        // Image or Icon (smaller for enterprise)
                        if (state.imagePath != null || state.iconPath != null)
                          _buildImageOrIcon(context, state, config),

                        if (state.imagePath != null || state.iconPath != null)
                          OsmeaComponents.sizedBox(
                              height: screenSize.height * 0.03),

                        // Simple Empty Title
                        OsmeaComponents.text(
                          title,
                          color: textColor,
                          textStyle:
                              OsmeaTextStyle.headlineSmall(context).copyWith(
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.3,
                          ),
                        ),

                        OsmeaComponents.sizedBox(
                            height: screenSize.height * 0.02),

                        // Simple divider
                        OsmeaComponents.container(
                          width: 40,
                          height: 1,
                          color: config?.getSecondaryColor() ?? OsmeaColors.ash,
                        ),

                        OsmeaComponents.sizedBox(
                            height: screenSize.height * 0.02),

                        // Empty Description
                        OsmeaComponents.text(
                          description,
                          color: textColor.withOpacity(0.8),
                          textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                            fontWeight: FontWeight.w300,
                            height: 1.6,
                          ),
                        ),

                        OsmeaComponents.sizedBox(
                            height: screenSize.height * 0.04),

                        // Action Button (if enabled in config and callback provided) - Text style
                        if (config?.showActionButton == true &&
                            widget.onActionPressed != null)
                          GestureDetector(
                            onTap: widget.onActionPressed,
                            child: OsmeaComponents.container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 0),
                              child: OsmeaComponents.text(
                                '→ ${state.actionButtonText ?? 'Continue'}',
                                color: config?.getPrimaryColor() ??
                                    OsmeaColors.nordicBlue,
                                textStyle:
                                    OsmeaTextStyle.bodyLarge(context).copyWith(
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
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

  Widget _buildImageOrIcon(
    BuildContext context,
    EmptyViewState state,
    EmptyViewConfigModel? config,
  ) {
    final screenSize = MediaQuery.of(context).size;

    if (state.imagePath != null) {
      // Try to load as network image first, then asset
      if (state.imagePath!.startsWith('http://') ||
          state.imagePath!.startsWith('https://')) {
        return Image.network(
          state.imagePath!,
          width: screenSize.width * 0.3,
          height: screenSize.width * 0.3,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const SizedBox.shrink();
          },
        );
      } else {
        return Image.asset(
          state.imagePath!,
          width: screenSize.width * 0.3,
          height: screenSize.width * 0.3,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const SizedBox.shrink();
          },
        );
      }
    } else if (state.iconPath != null) {
      if (state.iconPath!.startsWith('http://') ||
          state.iconPath!.startsWith('https://')) {
        return Image.network(
          state.iconPath!,
          width: 60,
          height: 60,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const SizedBox.shrink();
          },
        );
      } else {
        return Image.asset(
          state.iconPath!,
          width: 60,
          height: 60,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const SizedBox.shrink();
          },
        );
      }
    }

    return const SizedBox.shrink();
  }
}
