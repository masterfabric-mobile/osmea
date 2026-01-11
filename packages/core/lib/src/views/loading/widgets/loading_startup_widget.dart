import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/views/loading/cubit/loading_cubit.dart';
import 'package:core/src/views/loading/cubit/loading_state.dart';
import 'package:core/src/models/loading_models.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🚀 **OSMEA Loading Startup Widget**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Startup-themed loading style - Modern, clean and energetic design
/// Features dynamic progress with startup vibes
///
/// {@category Widgets}
/// {@subCategory LoadingStartup}

class LoadingStartupWidget extends StatelessWidget {
  final LoadingPageModel model;
  final VoidCallback? onCancel;

  const LoadingStartupWidget({
    super.key,
    required this.model,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingViewCubit, LoadingViewState>(
      builder: (context, state) {
        final bgColor = model.getBackgroundColor() ?? OsmeaColors.white;

        return SizedBox.expand(
          child: OsmeaComponents.container(
            color: bgColor,
            child: SafeArea(
              child: OsmeaComponents.column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Main content
                  Expanded(
                    child: _buildMainContent(context, state),
                  ),

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

  /// Build main content area
  Widget _buildMainContent(BuildContext context, LoadingViewState state) {
    final textColor = model.getTextColor() ?? OsmeaColors.shark;
    final progressColor = model.getProgressColor() ?? OsmeaColors.nordicBlue;

    return OsmeaComponents.column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Modern progress indicator
        _buildProgressIndicator(context, state),

        OsmeaComponents.sizedBox(height: context.spacing40),

        // Title
        OsmeaComponents.text(
          model.title,
          variant: OsmeaTextVariant.titleLarge,
          color: textColor,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.center,
        ),

        OsmeaComponents.sizedBox(height: context.spacing12),

        // Description
        OsmeaComponents.text(
          model.description,
          variant: OsmeaTextVariant.bodyMedium,
          color: textColor.withOpacity(0.7),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),

        if (state.message != null) ...[
          OsmeaComponents.sizedBox(height: context.spacing24),
          OsmeaComponents.container(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing20,
              vertical: context.spacing12,
            ),
            decoration: BoxDecoration(
              color: progressColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: progressColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: OsmeaComponents.text(
              state.message!,
              variant: OsmeaTextVariant.bodySmall,
              color: textColor.withOpacity(0.8),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }

  /// Build modern progress indicator
  Widget _buildProgressIndicator(BuildContext context, LoadingViewState state) {
    final progressColor = model.getProgressColor() ?? OsmeaColors.nordicBlue;

    return OsmeaComponents.container(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          OsmeaComponents.container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: progressColor.withOpacity(0.08),
            ),
          ),

          // Progress ring
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              value: state.isLoading ? null : state.progress,
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              backgroundColor: Colors.transparent,
              strokeCap: StrokeCap.round,
            ),
          ),

          // Center content
          OsmeaComponents.column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Icon(
                Icons.rocket_launch,
                color: progressColor,
                size: 32,
              ),
              
              // Progress percentage (if enabled)
              if (model.showProgress) ...[
                OsmeaComponents.sizedBox(height: context.spacing4),
                OsmeaComponents.text(
                  '${state.progressPercentage}%',
                  variant: OsmeaTextVariant.bodySmall,
                  color: progressColor,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// Build bottom section
  Widget _buildBottomSection(BuildContext context, LoadingViewState state) {
    final textColor = model.getTextColor() ?? OsmeaColors.shark;
    final progressColor = model.getProgressColor() ?? OsmeaColors.nordicBlue;

    return OsmeaComponents.column(
      children: [
        // Progress bar (if percentage not shown in center)
        if (model.showProgress) ...[
          OsmeaComponents.sizedBox(height: context.spacing8),
          OsmeaComponents.container(
            width: 120,
            height: 4,
            decoration: BoxDecoration(
              color: progressColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: state.progress,
              child: OsmeaComponents.container(
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing24),
        ] else
          OsmeaComponents.sizedBox(height: context.spacing16),

        // Cancel button
        if (model.showCancelButton && onCancel != null) ...[
          OsmeaComponents.button(
            text: model.cancelButtonText ?? 'Cancel',
            onPressed: onCancel,
            variant: ButtonVariant.ghost,
            size: ButtonSize.medium,
            textColor: textColor.withOpacity(0.6),
          ),
          OsmeaComponents.sizedBox(height: context.spacing32),
        ] else
          OsmeaComponents.sizedBox(height: context.spacing40),
      ],
    );
  }
}
