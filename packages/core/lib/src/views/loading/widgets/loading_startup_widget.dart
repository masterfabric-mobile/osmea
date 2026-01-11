import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/views/loading/cubit/loading_cubit.dart';
import 'package:core/src/views/loading/cubit/loading_state.dart';
import 'package:core/src/models/loading_models.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🔄 **OSMEA Loading Startup Widget**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Basic loading style - Simple and clean design
/// Circular progress indicator with loading messages
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
        return SizedBox.expand(
          child: OsmeaComponents.container(
            color: model.getBackgroundColor() ?? OsmeaColors.white,
            child: SafeArea(
              child: OsmeaComponents.column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Main content area
                  Expanded(
                    child: _buildMainContent(context, state),
                  ),

                  // Bottom section with progress
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
    final textColor = model.getTextColor() ?? OsmeaColors.black;

    return OsmeaComponents.column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Loading indicator
        _buildLoadingIndicator(context, state),

        OsmeaComponents.sizedBox(height: context.spacing32),

        // Title
        OsmeaComponents.text(
          model.title,
          variant: OsmeaTextVariant.titleLarge,
          color: textColor,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.center,
        ),

        OsmeaComponents.sizedBox(height: context.spacing16),

        // Description
        OsmeaComponents.text(
          model.description,
          variant: OsmeaTextVariant.bodyLarge,
          color: textColor.withOpacity(0.7),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),

        if (state.message != null) ...[
          OsmeaComponents.sizedBox(height: context.spacing16),
          OsmeaComponents.text(
            state.message!,
            variant: OsmeaTextVariant.bodyMedium,
            color: textColor.withOpacity(0.8),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  /// Build loading indicator
  Widget _buildLoadingIndicator(BuildContext context, LoadingViewState state) {
    final progressColor = model.getProgressColor() ?? OsmeaColors.black;

    return OsmeaComponents.container(
      width: 80,
      height: 80,
      child: CircularProgressIndicator(
        value: state.isLoading ? null : state.progress,
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(progressColor),
        backgroundColor: progressColor.withOpacity(0.2),
      ),
    );
  }

  /// Build bottom section
  Widget _buildBottomSection(BuildContext context, LoadingViewState state) {
    final textColor = model.getTextColor() ?? OsmeaColors.black;
    final progressColor = model.getProgressColor() ?? OsmeaColors.black;

    return OsmeaComponents.column(
      children: [
        // Progress percentage
        if (model.showProgress) ...[
          OsmeaComponents.text(
            '${state.progressPercentage}%',
            variant: OsmeaTextVariant.titleMedium,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
          OsmeaComponents.sizedBox(height: context.spacing16),
        ],

        // Cancel button
        if (model.showCancelButton && onCancel != null) ...[
          OsmeaComponents.button(
            text: model.cancelButtonText ?? 'Cancel',
            onPressed: onCancel,
            variant: ButtonVariant.ghost,
            size: ButtonSize.medium,
            textColor: textColor.withOpacity(0.7),
          ),
          OsmeaComponents.sizedBox(height: context.spacing16),
        ],

        // Simple indicator line
        OsmeaComponents.container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            color: progressColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        OsmeaComponents.sizedBox(height: context.spacing24),
      ],
    );
  }
}
