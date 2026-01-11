import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/views/loading/cubit/loading_cubit.dart';
import 'package:core/src/views/loading/cubit/loading_state.dart';
import 'package:core/src/models/loading_models.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🏢 **OSMEA Loading Enterprise Widget**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Professional enterprise-themed loading style
/// Clean, minimal corporate design with structured layout
///
/// {@category Widgets}
/// {@subCategory LoadingEnterprise}

class LoadingEnterpriseWidget extends StatelessWidget {
  final LoadingPageModel model;
  final VoidCallback? onCancel;

  const LoadingEnterpriseWidget({
    super.key,
    required this.model,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingViewCubit, LoadingViewState>(
      builder: (context, state) {
        final bgColor = model.getBackgroundColor() ?? OsmeaColors.snow;

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

                  // Bottom progress section
                  _buildBottomSection(context, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build main content
  Widget _buildMainContent(BuildContext context, LoadingViewState state) {
    final textColor = model.getTextColor() ?? OsmeaColors.shark;
    final progressColor = model.getProgressColor() ?? OsmeaColors.deepSea;

    return OsmeaComponents.container(
      padding: EdgeInsets.symmetric(horizontal: context.spacing32),
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Enterprise progress indicator
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
              width: double.infinity,
              padding: EdgeInsets.all(context.spacing16),
              decoration: BoxDecoration(
                color: OsmeaColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: OsmeaColors.silver,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: progressColor,
                  ),
                  OsmeaComponents.sizedBox(width: context.spacing12),
                  Expanded(
                    child: OsmeaComponents.text(
                      state.message!,
                      variant: OsmeaTextVariant.bodySmall,
                      color: textColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build enterprise progress indicator
  Widget _buildProgressIndicator(
      BuildContext context, LoadingViewState state) {
    final progressColor = model.getProgressColor() ?? OsmeaColors.deepSea;

    return OsmeaComponents.container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: OsmeaColors.silver,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: OsmeaColors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Progress ring
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              value: state.isLoading ? null : state.progress,
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              backgroundColor: progressColor.withOpacity(0.1),
              strokeCap: StrokeCap.round,
            ),
          ),

          // Center icon
          Icon(
            Icons.sync,
            color: progressColor,
            size: 20,
          ),
        ],
      ),
    );
  }

  /// Build bottom section
  Widget _buildBottomSection(BuildContext context, LoadingViewState state) {
    final textColor = model.getTextColor() ?? OsmeaColors.shark;
    final progressColor = model.getProgressColor() ?? OsmeaColors.deepSea;

    return OsmeaComponents.container(
      width: double.infinity,
      padding: EdgeInsets.all(context.spacing24),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        border: Border(
          top: BorderSide(
            color: OsmeaColors.silver,
            width: 1,
          ),
        ),
      ),
      child: OsmeaComponents.column(
        children: [
          // Progress section
          if (model.showProgress) ...[
            Row(
              children: [
                OsmeaComponents.text(
                  'Progress',
                  variant: OsmeaTextVariant.bodySmall,
                  color: textColor.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
                const Spacer(),
                OsmeaComponents.text(
                  '${state.progressPercentage}%',
                  variant: OsmeaTextVariant.bodyMedium,
                  color: progressColor,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            OsmeaComponents.sizedBox(height: context.spacing12),
            // Linear progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: state.progress,
                minHeight: 3,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                backgroundColor: progressColor.withOpacity(0.1),
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing20),
          ],

          // Cancel button
          if (model.showCancelButton && onCancel != null) ...[
            SizedBox(
              width: double.infinity,
              child: OsmeaComponents.button(
                text: model.cancelButtonText ?? 'Cancel',
                onPressed: onCancel,
                variant: ButtonVariant.outlined,
                size: ButtonSize.medium,
                textColor: textColor.withOpacity(0.7),
              ),
            ),
          ] else if (!model.showProgress)
            OsmeaComponents.sizedBox(height: context.spacing8),
        ],
      ),
    );
  }
}
