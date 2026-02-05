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
              child: _buildMinimalContent(context, state),
            ),
          ),
        );
      },
    );
  }

  /// Build minimalist content - just a simple loading indicator
  Widget _buildMinimalContent(BuildContext context, LoadingViewState state) {
    final progressColor = model.getProgressColor() ?? OsmeaColors.nordicBlue;

    return Center(
      child: SizedBox(
        width: 48,
        height: 48,
        child: CircularProgressIndicator(
          value: null, // Always indeterminate for continuous rotation
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          backgroundColor: progressColor.withOpacity(0.1),
        ),
      ),
    );
  }
}
