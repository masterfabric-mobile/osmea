import 'package:flutter/material.dart';
import 'package:core/core.dart';

import 'models/view_model.dart';
import 'models/states.dart';

class SignupView
    extends MasterViewCubit<SignupViewModel, SignupState> {
  SignupView({
    super.key,
    super.arguments = const {'init': true},
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
    SignupViewModel viewModel,
    BuildContext context,
  ) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    SignupViewModel viewModel,
    SignupState state,
  ) {
    if (state is SignupErrorState) {
      return buildError(
        state.message,
        onRetry: () => viewModel.initial(),
      );
    }

    if (state is SignupLoadedState) {
      return OsmeaComponents.scaffold(
        body: OsmeaComponents.center(
          child: OsmeaComponents.text('Signup Page Content'),
        ),
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
