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

class LoadingEnterpriseWidget extends StatefulWidget {
  final LoadingPageModel model;
  final VoidCallback? onCancel;

  const LoadingEnterpriseWidget({
    super.key,
    required this.model,
    this.onCancel,
  });

  @override
  State<LoadingEnterpriseWidget> createState() =>
      _LoadingEnterpriseWidgetState();
}

class _LoadingEnterpriseWidgetState extends State<LoadingEnterpriseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(); // Continuously rotate
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingViewCubit, LoadingViewState>(
      builder: (context, state) {
        final bgColor = widget.model.getBackgroundColor() ?? OsmeaColors.snow;

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

  /// Build main content
  Widget _buildMainContent(BuildContext context, LoadingViewState state) {
    return OsmeaComponents.container(
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Rotating refresh icon
          _buildRotatingRefreshIcon(context, state),
        ],
      ),
    );
  }

  /// Build rotating refresh icon
  Widget _buildRotatingRefreshIcon(
      BuildContext context, LoadingViewState state) {
    final progressColor = widget.model.getProgressColor() ?? OsmeaColors.deepSea;

    return RotationTransition(
      turns: _animationController,
      child: Icon(
        Icons.refresh,
        color: progressColor,
        size: 48,
      ),
    );
  }

  /// Build bottom section (simplified - only cancel button if needed)
  Widget _buildBottomSection(BuildContext context, LoadingViewState state) {
    final textColor = widget.model.getTextColor() ?? OsmeaColors.shark;

    // Only show cancel button if needed, otherwise return empty container
    if (!widget.model.showCancelButton || widget.onCancel == null) {
      return const SizedBox.shrink();
    }

    return OsmeaComponents.container(
      width: double.infinity,
      padding: EdgeInsets.all(context.spacing24),
      child: SizedBox(
        width: double.infinity,
        child: OsmeaComponents.button(
          text: widget.model.cancelButtonText ?? 'Cancel',
          onPressed: widget.onCancel,
          variant: ButtonVariant.outlined,
          size: ButtonSize.medium,
          textColor: textColor.withOpacity(0.7),
        ),
      ),
    );
  }
}
