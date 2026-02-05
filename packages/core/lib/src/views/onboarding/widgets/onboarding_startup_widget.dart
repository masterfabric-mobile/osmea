import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/views/onboarding/cubit/onboarding_cubit.dart';
import 'package:core/src/views/onboarding/cubit/onboarding_state.dart';
import 'package:core/src/models/onboarding_models.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🎨 **OSMEA Onboarding Startup Widget**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Modern startup onboarding - Full screen background images, no padding/safe area
/// Supports image_path and icon_path from app_config (priority: image_path > icon_path)
///
/// {@category Widgets}
/// {@subCategory OnboardingStartup}

class OnboardingStartupWidget extends StatefulWidget {
  final Function(int) onPageChanged;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onSkip;
  final VoidCallback onFinish;

  const OnboardingStartupWidget({
    super.key,
    required this.onPageChanged,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
    required this.onFinish,
  });

  @override
  State<OnboardingStartupWidget> createState() =>
      _OnboardingStartupWidgetState();
}

class _OnboardingStartupWidgetState extends State<OnboardingStartupWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if (!state.hasConfig || !state.hasPages) {
          return const SizedBox.shrink();
        }

        final primaryColor =
            state.config?.getPrimaryColor() ?? OsmeaColors.nordicBlue;

        return _buildContent(context, state, primaryColor);
      },
    );
  }

  /// Main content - Single page with animated content switching
  Widget _buildContent(
    BuildContext context,
    OnboardingState state,
    Color primaryColor,
  ) {
    final page = state.config!.pages[state.currentPageIndex];
    
    return SizedBox.expand(
      child: AnimatedSwitcher(
        duration: Duration(
          milliseconds: state.config?.animationDuration ?? 400,
        ),
        transitionBuilder: (Widget child, Animation<double> animation) {
          // Fade + Slide transition for smooth content switching
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.03, 0.0), // Subtle slide from right
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOutCubic,
              )),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(state.currentPageIndex),
          child: _buildFullScreenPage(context, page, primaryColor, state.currentPageIndex, state),
        ),
      ),
    );
  }

  /// Full screen page with background image
  Widget _buildFullScreenPage(
    BuildContext context,
    OnboardingPageModel page,
    Color primaryColor,
    int pageIndex,
    OnboardingState state,
  ) {
    return SizedBox.expand(
      child: Stack(
        children: [
          // Full screen background image - Edge to edge, no padding
          Positioned.fill(
            child: _buildBackgroundImage(context, page, primaryColor, pageIndex),
          ),

          // Content overlay - Edge to edge
          Column(
            children: [
              // Top bar - Skip button
              _buildTopBar(context, state),

              // Spacer
              const Spacer(),

              // Bottom section with text and navigation
              _buildBottomSection(context, state, primaryColor),
            ],
          ),
        ],
      ),
    );
  }

  /// Full screen background image - Edge to edge, no padding
  Widget _buildBackgroundImage(
    BuildContext context,
    OnboardingPageModel page,
    Color primaryColor,
    int pageIndex,
  ) {
    // Priority: image_path > icon_path
    // image_path can be either URL or asset path
    Widget imageWidget;

    if (page.imagePath != null && page.imagePath!.isNotEmpty) {
      final imagePath = page.imagePath!;
      final isUrl = imagePath.startsWith('http://') || imagePath.startsWith('https://');
      
      debugPrint('🖼️ [OnboardingStartup] Loading image_path: $imagePath');
      debugPrint('🖼️ [OnboardingStartup] Is URL: $isUrl');
      
      if (isUrl) {
        // Use Image.network directly for URLs
        imageWidget = Image.network(
          imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              debugPrint('✅ [OnboardingStartup] Image loaded successfully');
              return child;
            }
            debugPrint('⏳ [OnboardingStartup] Loading image: ${loadingProgress.cumulativeBytesLoaded}/${loadingProgress.expectedTotalBytes}');
            return Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            debugPrint('❌ [OnboardingStartup] Image load error: $error');
            debugPrint('❌ [OnboardingStartup] Stack trace: $stackTrace');
            return Container(
              color: Colors.red.withValues(alpha: 0.1),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    SizedBox(height: 8),
                    Text(
                      'Image load error',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        imagePath.length > 50 ? '${imagePath.substring(0, 50)}...' : imagePath,
                        style: TextStyle(color: Colors.red.withValues(alpha: 0.7), fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        // Use OsmeaComponents for asset paths
        imageWidget = SizedBox.expand(
          child: OsmeaComponents.image(
            assetPath: imagePath,
            fit: BoxFit.cover,
            variant: ImageVariant.normal,
            showLoadingIndicator: true,
          ),
        );
      }
    } else if (page.iconPath != null && page.iconPath!.isNotEmpty) {
      final iconPath = page.iconPath!;
      final isUrl = iconPath.startsWith('http://') || iconPath.startsWith('https://');
      
      debugPrint('🖼️ [OnboardingStartup] Loading icon_path: $iconPath');
      debugPrint('🖼️ [OnboardingStartup] Is URL: $isUrl');
      
      if (isUrl) {
        // Use Image.network directly for URLs
        imageWidget = Image.network(
          iconPath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              debugPrint('✅ [OnboardingStartup] Icon loaded successfully');
              return child;
            }
            return Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            debugPrint('❌ [OnboardingStartup] Icon load error: $error');
            return Container(
              color: Colors.red.withValues(alpha: 0.1),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    SizedBox(height: 8),
                    Text(
                      'Icon load error',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        // Use OsmeaComponents for asset paths
        imageWidget = SizedBox.expand(
          child: OsmeaComponents.image(
            assetPath: iconPath,
            fit: BoxFit.cover,
            variant: ImageVariant.normal,
            showLoadingIndicator: true,
          ),
        );
      }
    } else {
      debugPrint('⚠️ [OnboardingStartup] No image found, using gradient fallback');
      debugPrint('⚠️ [OnboardingStartup] imagePath: ${page.imagePath}');
      debugPrint('⚠️ [OnboardingStartup] iconPath: ${page.iconPath}');
      // Fallback: Gradient background if no image
      imageWidget = SizedBox.expand(
        child: OsmeaComponents.container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primaryColor.withValues(alpha: 0.1),
                primaryColor.withValues(alpha: 0.3),
              ],
            ),
          ),
        ),
      );
    }

    return imageWidget;
  }

  /// Top bar - Skip button only (edge to edge, padding only for button)
  Widget _buildTopBar(BuildContext context, OnboardingState state) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + context.spacing12,
        right: context.spacing20,
        bottom: context.spacing8,
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: state.shouldShowSkipButton
            ? GestureDetector(
                onTap: widget.onSkip,
                child: OsmeaComponents.container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing12,
                    vertical: context.spacing6,
                  ),
                  decoration: BoxDecoration(
                    color: OsmeaColors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: OsmeaComponents.text(
                    state.currentPage?.skipText ?? 'Skip',
                    variant: OsmeaTextVariant.bodySmall,
                    color: OsmeaColors.thunder,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  /// Bottom section - Title, subtitle, pagination, and button (edge to edge)
  Widget _buildBottomSection(
    BuildContext context,
    OnboardingState state,
    Color primaryColor,
  ) {
    final page = state.currentPage;
    if (page == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.3),
            Colors.black.withValues(alpha: 0.5),
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: context.spacing40,
          bottom: MediaQuery.of(context).padding.bottom + context.spacing20,
          left: context.spacing24,
          right: context.spacing24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title - Left aligned, bold, white for visibility
            OsmeaComponents.text(
              page.title,
              variant: OsmeaTextVariant.headlineLarge,
              color: OsmeaColors.white,
              fontWeight: context.bold,
              textAlign: TextAlign.left,
            ),

            SizedBox(height: context.spacing8),

            // Subtitle - Left aligned, regular, multi-line, white with slight transparency
            OsmeaComponents.text(
              page.description,
              variant: OsmeaTextVariant.bodyMedium,
              color: OsmeaColors.white.withValues(alpha: 0.9),
              textAlign: TextAlign.left,
              maxLines: 3,
              overflow: TextOverflow.visible,
            ),

            SizedBox(height: context.spacing32),

            // Bottom navigation row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left side: Pagination dots only (no back button)
                _buildPaginationDots(context, state),

                // Right side: Next/Get Started button
                _buildActionButton(context, state, primaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Pagination dots with border
  Widget _buildPaginationDots(
    BuildContext context,
    OnboardingState state,
  ) {
    if (!state.shouldShowPageIndicator) {
      return OsmeaComponents.sizedBox(width: 0);
    }

    return OsmeaComponents.row(
      children: List.generate(state.config!.pages.length, (index) {
        final isActive = index == state.currentPageIndex;
        return OsmeaComponents.container(
          margin: EdgeInsets.only(right: context.spacing6),
          width: isActive ? 8 : 6,
          height: isActive ? 8 : 6,
          decoration: BoxDecoration(
            color: isActive
                ? OsmeaColors.white
                : OsmeaColors.white.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            border: Border.all(
              color: OsmeaColors.white,
              width: 1.5,
            ),
          ),
        );
      }),
    );
  }

  /// Action button - Circular next or rectangular Get Started
  Widget _buildActionButton(
    BuildContext context,
    OnboardingState state,
    Color primaryColor,
  ) {
    if (state.isLastPage) {
      // Rectangular "Get Started" button - No shadow
      return OsmeaComponents.button(
        text: state.currentPage?.buttonText ?? 'Get Started',
        onPressed: widget.onFinish,
        variant: ButtonVariant.primary,
        size: ButtonSize.medium,
        backgroundColor: OsmeaColors.thunder,
        textColor: OsmeaColors.white,
        elevation: 0.0,
      );
    } else {
      // Circular next button with border
      return GestureDetector(
        onTap: widget.onNext,
        child: OsmeaComponents.container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: OsmeaColors.thunder,
            shape: BoxShape.circle,
            border: Border.all(
              color: OsmeaColors.white,
              width: 2.0,
            ),
          ),
          child: OsmeaComponents.center(
            child: Icon(
              Icons.arrow_forward_rounded,
              color: OsmeaColors.white,
              size: context.iconSizeNormal,
            ),
          ),
        ),
      );
    }
  }
}
