/*
 * SubServe Onboarding – MasterViewHydratedCubit + ViewModel + OnboardingContent.
 * Navigation via ViewModel callback; no BlocListener.
 */

import 'package:flutter/material.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide OnboardingState;
import 'package:sub_serve/app/views/view_onboarding/models/onboarding_view_model.dart';
import 'package:sub_serve/app/views/view_onboarding/models/module/onboarding_state.dart';
import 'package:sub_serve/app/views/view_onboarding/widgets/onboarding_content.dart';

class SubServeOnboardingView extends MasterViewHydratedCubit<
    OnboardingViewModel, OnboardingState> {
  SubServeOnboardingView({
    super.key,
    super.arguments,
    super.currentView,
    super.snackBarFunction,
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.horizontalPadding = const PaddingVisibility.disabled(),
    required super.goRoute,
  });

  @override
  void initialContent(OnboardingViewModel viewModel, BuildContext context) {
    viewModel.setGoRoute(goRoute);
    viewModel.loadFromUrl();
  }

  @override
  Widget viewContent(
    BuildContext context,
    OnboardingViewModel viewModel,
    OnboardingState state,
  ) {
    return OnboardingContent(viewModel: viewModel, state: state);
  }
}
