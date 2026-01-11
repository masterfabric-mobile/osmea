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
/// Clean, corporate design with progress indicators
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
        return SizedBox.expand(
          child: OsmeaComponents.container(
            color: model.getBackgroundColor() ?? const Color(0xFFF8F9FA),
            child: SafeArea(
              child: OsmeaComponents.column(
                children: [
                  // Top section with branding
                  _buildTopSection(context),

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

  /// Build top section with enterprise branding
  Widget _buildTopSection(BuildContext context) {
    return OsmeaComponents.container(
      width: double.infinity,
      padding: EdgeInsets.all(context.spacing24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo placeholder
          OsmeaComponents.container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: model.getProgressColor() ?? OsmeaColors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.business,
              color: Colors.white,
              size: 24,
            ),
          ),

          OsmeaComponents.sizedBox(width: context.spacing12),

          // Company branding
          OsmeaComponents.text(
            'OSMEA',
            variant: OsmeaTextVariant.titleMedium,
            color: OsmeaColors.black,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  /// Build main content with enterprise styling
  Widget _buildMainContent(BuildContext context, LoadingViewState state) {
    final textColor = model.getTextColor() ?? OsmeaColors.black;

    return OsmeaComponents.container(
      padding: EdgeInsets.symmetric(horizontal: context.spacing32),
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Professional loading indicator
          _buildEnterpriseLoadingIndicator(context, state),

          OsmeaComponents.sizedBox(height: context.spacing32),

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
            variant: OsmeaTextVariant.bodyLarge,
            color: textColor.withOpacity(0.7),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),

          if (state.message != null) ...[
            OsmeaComponents.sizedBox(height: context.spacing20),
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
              child: OsmeaComponents.text(
                state.message!,
                variant: OsmeaTextVariant.bodyMedium,
                color: textColor.withOpacity(0.8),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build enterprise loading indicator
  Widget _buildEnterpriseLoadingIndicator(
      BuildContext context, LoadingViewState state) {
    final progressColor = model.getProgressColor() ?? OsmeaColors.black;

    return OsmeaComponents.container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 16,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              value: state.isLoading ? null : state.progress,
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              backgroundColor: progressColor.withOpacity(0.1),
            ),
          ),

          // Center icon
          Icon(
            Icons.sync,
            color: progressColor,
            size: 24,
          ),
        ],
      ),
    );
  }

  /// Build bottom section with enterprise styling
  Widget _buildBottomSection(BuildContext context, LoadingViewState state) {
    final textColor = model.getTextColor() ?? OsmeaColors.black;
    final progressColor = model.getProgressColor() ?? OsmeaColors.black;

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
          // Progress bar
          if (model.showProgress) ...[
            Row(
              children: [
                OsmeaComponents.text(
                  'Progress:',
                  variant: OsmeaTextVariant.bodyMedium,
                  color: textColor.withOpacity(0.7),
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
            OsmeaComponents.sizedBox(height: context.spacing8),
            // Linear progress indicator
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: state.progress,
                minHeight: 6,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                backgroundColor: progressColor.withOpacity(0.1),
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),
          ],

          // Cancel button
          if (model.showCancelButton && onCancel != null) ...[
            SizedBox(
              width: double.infinity,
              child: OsmeaComponents.button(
                text: model.cancelButtonText ?? 'Cancel Process',
                onPressed: onCancel,
                variant: ButtonVariant.outlined,
                size: ButtonSize.medium,
                textColor: textColor.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
