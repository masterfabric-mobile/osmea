/*
 * SplashViewModel
 * ---------------
 * This file defines the ViewModel for the splash screen in the Admin Dashboard app.
 * It manages splash logic, state transitions, and navigation delegation.
 *
 * - Handles splash timing and navigation via callback
 * - Emits states for loading, content, error, and navigation
 * - Keeps UI and business logic separated for testability
 */

import 'package:admin_dashboard/app/views/view_splash/models/module/events.dart';
import 'package:admin_dashboard/app/views/view_splash/models/module/states.dart';
import 'package:core/core.dart' hide SplashState;
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

/// ViewModel for the Splash screen.
///
/// - Handles splash logic (timing, navigation)
/// - Emits states for the splash UI
/// - Delegates navigation to the View via callback for testability
@injectable
class SplashViewModel extends BaseViewModelBloc<SplashEvent, SplashState> {
  SplashViewModel() : super(SplashStateLoading()) {
    // Register event handlers for splash events
    on<SplashEventCheckUser>(_onCheckUser);
    on<SplashEventNavigateHome>(_onNavigateHome);
    on<SplashEventStartSplash>(_onStartSplash);
    on<SplashViewInitialEvent>(_splashEvent);
  }

  Map<String, dynamic> deviceData = {};
  final OnboardingStorageHelper _onboardingHelper = OnboardingStorageHelper();

  // Navigation callback
  Function(String route)? _navigationCallback;

  /// Starts the splash logic and triggers navigation after a delay.
  ///
  /// [context] is required to access SizerExtensions for duration
  /// [onNavigate] is a callback provided by the View to handle navigation.
  void startSplashLogic(
    BuildContext context,
    Function(String route)? onNavigate,
  ) async {
    _navigationCallback = onNavigate;
    // Add the event to the bloc for proper state management
    add(SplashViewInitialEvent(context));
  }

  /// Handles the start splash event with context-dependent duration.
  void _onStartSplash(SplashEventStartSplash event, emit) async {
    emit(SplashStateLoading());

    // --- Splash Delay Simulation ---
    // Waits for a duration from SizerExtensions to simulate loading or initialization.
    await Future.delayed(event.context.durationLong);

    // After delay, trigger navigation to the onboarding route if callback is provided.
    if (event.onNavigate != null) {
      event.onNavigate!(
        '/onboarding',
      ); // Navigate to onboarding instead of home
    }
  }

  /// Handles navigation event by emitting the navigation state.
  void _onNavigateHome(SplashEventNavigateHome event, emit) {
    emit(SplashStateNavigateHome());
  }

  /// Handles the user check event.
  ///
  /// Simulates a user check with a delay, then emits content or error state.
  void _onCheckUser(SplashEventCheckUser event, emit) async {
    emit(SplashStateLoading()); // Set state to loading
    try {
      await Future.delayed(
        event.context.durationVeryLong,
      ); // Use context-dependent duration
      emit(
        SplashStateContent(
          contentValue: "Content coming from View Model logic!",
        ),
      ); // Emit content state with a message
    } catch (e) {
      debugPrint('Error occurred: $e'); // Log error
      emit(SplashStateError(contentValue: 'Failed to load content'));
    }
  }

  void splashInitial(BuildContext context) =>
      add(SplashViewInitialEvent(context));

  FutureOr<void> _splashEvent(
    SplashViewInitialEvent event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashStateLoading());

    // Check onboarding status with debug info
    final hasSeenOnboarding = await _onboardingHelper.hasSeenOnboarding();

    // Additional debug info
    await _onboardingHelper.getOnboardingDebugInfo();
    Future.delayed(const Duration(seconds: 2), () {
      // PROD mode logic: Check if onboarding was seen
      if (hasSeenOnboarding) {
        _navigationCallback?.call('/welcome');
      } else {
        _navigationCallback?.call('/onboarding');
      }
    });
  }
}
