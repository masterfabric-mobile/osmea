/*
 * OnboardingViewModel
 * -------------------
 * ViewModel for the onboarding view following OSMEA architecture.
 * Uses BLoC pattern with events and states.
 */

import 'dart:async';
import 'package:admin_dashboard/core/constants/text_constants.dart';
import 'package:admin_dashboard/app/views/view_onboarding/models/module/events.dart';
import 'package:admin_dashboard/app/views/view_onboarding/models/module/states.dart';
import 'package:core/core.dart' hide OnboardingState;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class OnboardingViewModel
    extends BaseViewModelBloc<OnboardingEvent, OnboardingState> {
  OnboardingViewModel() : super(OnboardingInitialState()) {
    on<OnboardingInitialEvent>(_onboardingInitialEvent);
    on<OnboardingNextEvent>(_onboardingNextEvent);
    on<OnboardingSkipEvent>(_onboardingSkipEvent);
    on<OnboardingPageChangedEvent>(_onboardingPageChangedEvent);
  }

  // Dependencies
  final OnboardingStorageHelper _onboardingHelper = OnboardingStorageHelper();

  // Page Controller and State
  PageController pageController = PageController(initialPage: 0);
  int currentIndex = 0;
  Function(String route)? _onNavigate;

  // Public getters for UI
  int get totalPages => onboardingData.length;
  bool get isLastPage => currentIndex == totalPages - 1;
  double get progressValue => (currentIndex + 1) / totalPages.toDouble();

  /// Set navigation callback from view
  void setNavigationCallback(Function(String route)? onNavigate) {
    _onNavigate = onNavigate;
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }

  // Public trigger functions - following splash pattern
  void onboardingInitial() => add(OnboardingInitialEvent());
  void onboardingNext(BuildContext context) =>
      add(OnboardingNextEvent(context: context));
  void onboardingSkip(BuildContext context) =>
      add(OnboardingSkipEvent(context: context));
  void onPageChanged(int index) => add(OnboardingPageChangedEvent(index));

  // Event handlers - single responsibility pattern
  FutureOr<void> _onboardingInitialEvent(
    OnboardingInitialEvent event,
    Emitter<OnboardingState> emit,
  ) {
    currentIndex = 0;
    emit(OnboardingLoadedState(currentIndex: currentIndex));
  }

  FutureOr<void> _onboardingNextEvent(
    OnboardingNextEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    if (currentIndex < totalPages - 1) {
      currentIndex++;
      pageController.nextPage(
        duration: event.context.animationMedium,
        curve: Curves.easeInOut,
      );
      emit(OnboardingLoadedState(currentIndex: currentIndex));
    } else {
      // Mark onboarding as completed
      await _onboardingHelper.markOnboardingSeen();
      // Complete onboarding and navigate
      emit(OnboardingCompleteState());
      if (_onNavigate != null) {
        _onNavigate!('/welcome');
      }
    }
  }

  FutureOr<void> _onboardingSkipEvent(
    OnboardingSkipEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    // Mark onboarding as completed even when skipped
    await _onboardingHelper.markOnboardingSeen();
    // Skip directly to completion
    emit(OnboardingCompleteState());
    if (_onNavigate != null) {
      _onNavigate!('/welcome');
    }
  }

  FutureOr<void> _onboardingPageChangedEvent(
    OnboardingPageChangedEvent event,
    Emitter<OnboardingState> emit,
  ) {
    // Update current index and progress
    currentIndex = event.index;
    emit(OnboardingLoadedState(currentIndex: currentIndex));
  }
}
