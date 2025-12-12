/*
 * OnboardingView
 * --------------
 * A 3-page onboarding flow following OSMEA architecture.
 * Uses MasterView pattern with BLoC state management.
 */

import 'package:admin_dashboard/core/constants/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart' hide OnboardingView, OnboardingState;
import 'package:admin_dashboard/app/views/view_onboarding/models/onboarding_view_model.dart';
import 'package:admin_dashboard/app/views/view_onboarding/models/module/events.dart';
import 'package:admin_dashboard/app/views/view_onboarding/models/module/states.dart';
import 'package:admin_dashboard/app/views/view_onboarding/widgets/onboarding_widgets.dart';

/// OnboardingView displays a 3-page onboarding flow
class OnboardingView
    extends MasterView<OnboardingViewModel, OnboardingEvent, OnboardingState> {
  OnboardingView({
    super.key,
    super.arguments,
    super.currentView,
    super.snackBarFunction,
  });

  @override
  void initialContent(
    OnboardingViewModel viewModel,
    BuildContext context,
  ) async {
    // Set navigation callback
    viewModel.setNavigationCallback((route) {
      navigateTo(context, route);
    });

    // Initialize onboarding
    viewModel.onboardingInitial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    OnboardingViewModel viewModel,
    OnboardingState state,
  ) {
    // Error state
    if (state is OnboardingErrorState) {
      return OnboardingErrorWidget(
        onRetry: () => viewModel.onboardingInitial(),
      );
    }

    // Complete state
    if (state is OnboardingCompleteState) {
      // Navigation is now handled in ViewModel
      return const OnboardingCompletedWidget();
    }

    // Main onboarding flow
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.expanded(
          child: PageView.builder(
            controller: viewModel.pageController,
            onPageChanged: viewModel.onPageChanged,
            itemCount: viewModel.totalPages,
            itemBuilder: (context, index) {
              final pageData = onboardingData[index];
              return OnboardingPageContentWidget(
                isLastPage: viewModel.isLastPage,
                progressValue: viewModel.progressValue,
                totalPages: viewModel.totalPages,
                currentPage: index,
                title: pageData['title']!,
                description: pageData['description']!,
                imagePath: pageData['imagePath']!,
                onNext: () => viewModel.onboardingNext(context),
                onSkip: () {
                  // Skip to complete state which will navigate to home
                  viewModel.onboardingSkip(context);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
