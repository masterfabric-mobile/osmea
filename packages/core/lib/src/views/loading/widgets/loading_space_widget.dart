import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/views/loading/cubit/loading_cubit.dart';
import 'package:core/src/views/loading/cubit/loading_state.dart';
import 'package:core/src/models/loading_models.dart';
import 'package:osmea_components/osmea_components.dart';

/// ⚪ **OSMEA Loading Space Widget**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Minimalist loading style - Clean design with generous whitespace
/// Focus on simplicity and breathing room
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
        final bgColor = model.getBackgroundColor() ?? OsmeaColors.white;

        return SizedBox.expand(
          child: OsmeaComponents.container(
            color: bgColor,
            child: SafeArea(
              child: OsmeaComponents.column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Generous top spacing
                  const Expanded(flex: 2, child: SizedBox()),

                  // Minimalist content
                  _buildMinimalContent(context, state),

                  // Generous bottom spacing
                  const Expanded(flex: 2, child: SizedBox()),

                  // Minimal bottom section
                  _buildMinimalBottom(context, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build minimalist content with lots of space
  Widget _buildMinimalContent(BuildContext context, LoadingViewState state) {
    final textColor = model.getTextColor() ?? OsmeaColors.shark;
    final progressColor = model.getProgressColor() ?? OsmeaColors.nordicBlue;

    return OsmeaComponents.column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Simple, clean progress indicator
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            value: state.isLoading ? null : state.progress,
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            backgroundColor: progressColor.withOpacity(0.1),
          ),
        ),

        OsmeaComponents.sizedBox(height: context.spacing48),

        // Title - minimal styling
        OsmeaComponents.text(
          model.title,
          variant: OsmeaTextVariant.titleMedium,
          color: textColor,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
        ),

        OsmeaComponents.sizedBox(height: context.spacing16),

        // Description - subtle
        OsmeaComponents.text(
          model.description,
          variant: OsmeaTextVariant.bodyMedium,
          color: textColor.withOpacity(0.6),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),

        if (state.message != null) ...[
          OsmeaComponents.sizedBox(height: context.spacing32),
          OsmeaComponents.text(
            state.message!,
            variant: OsmeaTextVariant.bodySmall,
            color: textColor.withOpacity(0.5),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  /// Build minimal bottom section
  Widget _buildMinimalBottom(BuildContext context, LoadingViewState state) {
    final textColor = model.getTextColor() ?? OsmeaColors.shark;

    return OsmeaComponents.column(
      children: [
        // Simple progress percentage - no decoration
        if (model.showProgress) ...[
          OsmeaComponents.text(
            '${state.progressPercentage}%',
            variant: OsmeaTextVariant.bodySmall,
            color: textColor.withOpacity(0.4),
            fontWeight: FontWeight.w300,
          ),
          OsmeaComponents.sizedBox(height: context.spacing32),
        ],

        // Cancel button - minimal
        if (model.showCancelButton && onCancel != null) ...[
          OsmeaComponents.button(
            text: model.cancelButtonText ?? 'Cancel',
            onPressed: onCancel,
            variant: ButtonVariant.ghost,
            size: ButtonSize.small,
            textColor: textColor.withOpacity(0.5),
          ),
          OsmeaComponents.sizedBox(height: context.spacing32),
        ] else
          OsmeaComponents.sizedBox(height: context.spacing40),
      ],
    );
  }
}
