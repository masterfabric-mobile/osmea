import 'package:flutter/material.dart';
import 'package:core/core.dart';

import 'models/home_view_model.dart';
import 'models/states.dart';

/// Supabase Home View
///
/// This view is built using `MasterViewCubit` from core and a
/// `SupabaseHomeViewModel` that extends `BaseViewModelCubit`.
/// It replaces the old `_MinimalistHomePage` while keeping the same
/// visual design for now.
class SupabaseHomeView
    extends MasterViewCubit<SupabaseHomeViewModel, SupabaseHomeState> {
  SupabaseHomeView({
    super.key,
    super.arguments = const {'home': true},
    required super.goRoute,
  }) : super(
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          navbarSpacer: const SpacerVisibility.disabled(),
          footerSpacer: const SpacerVisibility.disabled(),
          verticalPadding: const PaddingVisibility.disabled(),
          horizontalPadding: const PaddingVisibility.disabled(),
          coreAppBar: null,
        );

  @override
  void initialContent(
    SupabaseHomeViewModel viewModel,
    BuildContext context,
  ) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    SupabaseHomeViewModel viewModel,
    SupabaseHomeState state,
  ) {
    if (state is SupabaseHomeErrorState) {
      return buildError(
        state.message,
        onRetry: () => viewModel.initial(),
      );
    }

    if (state is SupabaseHomeLoadedState) {
      return OsmeaComponents.scaffold(
        body: OsmeaComponents.center(
          child: OsmeaComponents.column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OsmeaComponents.text(
                state.title,
                color: OsmeaColors.black,
                textAlign: TextAlign.center,
                textStyle: OsmeaTextStyle.headlineSmall(
                  context,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(
                state.subtitle,
                color: OsmeaColors.slate,
                textAlign: TextAlign.center,
                textStyle: OsmeaTextStyle.bodyMedium(context),
              ),
            ],
          ),
        ),
      );
    }

    // Initial / fallback: simple loading indicator
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}


