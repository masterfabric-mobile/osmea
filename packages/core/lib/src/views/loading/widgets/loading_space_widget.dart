import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/views/loading/cubit/loading_cubit.dart';
import 'package:core/src/views/loading/cubit/loading_state.dart';
import 'package:core/src/models/loading_models.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🚀 **OSMEA Loading Space Widget**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Futuristic space-themed loading style
/// Animated progress with cosmic design elements
///
/// {@category Widgets}
/// {@subCategory LoadingSpace}

class LoadingSpaceWidget extends StatelessWidget {
  final LoadingPageModel model;
  final VoidCallback? onCancel;

  const LoadingSpaceWidget({
    super.key,
    required this.model,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingViewCubit, LoadingViewState>(
      builder: (context, state) {
        return SizedBox.expand(
          child: OsmeaComponents.container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  model.getBackgroundColor() ?? OsmeaColors.paperWhite,
                  (model.getBackgroundColor() ?? OsmeaColors.paperWhite)
                      .withOpacity(0.8),
                  (model.getBackgroundColor() ?? OsmeaColors.paperWhite)
                      .withOpacity(0.6),
                ],
              ),
            ),
            child: SafeArea(
              child: OsmeaComponents.column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top spacer
                  const Spacer(),

                  // Main content area
                  _buildMainContent(context, state),

                  // Bottom section
                  _buildBottomSection(context, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build main content with space theme
  Widget _buildMainContent(BuildContext context, LoadingViewState state) {
    final textColor = model.getTextColor() ?? OsmeaColors.black;

    return OsmeaComponents.column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Cosmic loading indicator
        _buildCosmicLoadingIndicator(context, state),

        OsmeaComponents.sizedBox(height: context.spacing40),

        // Title with glow effect
        OsmeaComponents.text(
          model.title,
          variant: OsmeaTextVariant.titleLarge,
          color: textColor,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
        ),

        OsmeaComponents.sizedBox(height: context.spacing16),

        // Description
        OsmeaComponents.text(
          model.description,
          variant: OsmeaTextVariant.bodyLarge,
          color: textColor.withOpacity(0.8),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),

        if (state.message != null) ...[
          OsmeaComponents.sizedBox(height: context.spacing20),
          OsmeaComponents.container(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing16,
              vertical: context.spacing8,
            ),
            decoration: BoxDecoration(
              color: textColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: textColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: OsmeaComponents.text(
              state.message!,
              variant: OsmeaTextVariant.bodyMedium,
              color: textColor.withOpacity(0.9),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }

  /// Build cosmic loading indicator
  Widget _buildCosmicLoadingIndicator(
      BuildContext context, LoadingViewState state) {
    final progressColor = model.getProgressColor() ?? OsmeaColors.black;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow circle
        OsmeaComponents.container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                progressColor.withOpacity(0.3),
                progressColor.withOpacity(0.1),
                Colors.transparent,
              ],
            ),
          ),
        ),

        // Main progress indicator
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: state.isLoading ? null : state.progress,
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            backgroundColor: progressColor.withOpacity(0.2),
          ),
        ),

        // Center dot
        OsmeaComponents.container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: progressColor,
            boxShadow: [
              BoxShadow(
                color: progressColor.withOpacity(0.6),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build bottom section with space theme
  Widget _buildBottomSection(BuildContext context, LoadingViewState state) {
    final textColor = model.getTextColor() ?? OsmeaColors.black;
    final progressColor = model.getProgressColor() ?? OsmeaColors.black;

    return OsmeaComponents.column(
      children: [
        // Progress percentage with cosmic styling
        if (model.showProgress) ...[
          OsmeaComponents.container(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing20,
              vertical: context.spacing8,
            ),
            decoration: BoxDecoration(
              color: textColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: progressColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: OsmeaComponents.text(
              '${state.progressPercentage}%',
              variant: OsmeaTextVariant.titleMedium,
              color: progressColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing20),
        ],

        // Cancel button with space styling
        if (model.showCancelButton && onCancel != null) ...[
          OsmeaComponents.container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: textColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: OsmeaComponents.button(
              text: model.cancelButtonText ?? 'Abort Mission',
              onPressed: onCancel,
              variant: ButtonVariant.ghost,
              size: ButtonSize.medium,
              textColor: textColor.withOpacity(0.8),
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing20),
        ],

        // Cosmic indicator bars
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return OsmeaComponents.container(
              width: 8,
              height: 3,
              margin: EdgeInsets.symmetric(horizontal: context.spacing4),
              decoration: BoxDecoration(
                color: progressColor.withOpacity(
                  index <= (state.progress * 4) ? 0.8 : 0.2,
                ),
                borderRadius: BorderRadius.circular(2),
                boxShadow: index <= (state.progress * 4)
                    ? [
                        BoxShadow(
                          color: progressColor.withOpacity(0.4),
                          blurRadius: 4,
                        ),
                      ]
                    : null,
              ),
            );
          }),
        ),

        OsmeaComponents.sizedBox(height: context.spacing32),
      ],
    );
  }
}
