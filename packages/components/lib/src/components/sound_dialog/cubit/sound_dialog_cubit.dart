/// 🔊 OSMEA Sound Dialog Cubit
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// Cubit for managing sound recording dialog state, including recording,
/// pause, review, visibility, and simulated volume feedback. It also handles
/// behavioral configurations like maximum recording duration.
///
/// {@category Cubit}
/// {@subCategory Dialog}
///
/// ## Example Usage:
/// ```dart
/// // Create a Cubit instance for the feedback variant with a 30-second limit.
/// final cubit = SoundDialogCubit(
///   variant: SoundDialogVariant.feedbackRecorder,
///   maxRecordingDuration: const Duration(seconds: 30),
///   autoStopOnMaxDuration: true,
/// );
///
/// // Start the recording process.
/// cubit.startRecording();
///
/// // Listen to state changes to update the UI.
/// cubit.stream.listen((state) {
///   print('Current duration: ${state.recordedDuration}');
///   if (state.isReviewing) {
///     print('Recording finished, now in review mode.');
///   }
/// });
/// ```

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osmea_components/osmea_components.dart';

/// Manages the state and timers for all sound dialog variants.
class SoundDialogCubit extends Cubit<SoundDialogState> {
  Timer? _volumeTimer;
  Timer? _durationTimer;
  final _random = math.Random();

  // Behavioral parameters
  final Duration? maxRecordingDuration;
  final bool autoStopOnMaxDuration;

  /// Creates a [SoundDialogCubit] with the given dialog [variant] and
  /// optional behavioral configurations.
  SoundDialogCubit({
    required SoundDialogVariant variant,
    this.maxRecordingDuration,
    this.autoStopOnMaxDuration = false,
  }) : super(SoundDialogState(variant: variant));

  /// Starts the recording session and begins updating duration and volume.
  void startRecording() {
    _stopAllTimers();
    emit(state.copyWith(
      isRecording: true,
      isPaused: false,
      isReviewing: false,
      recordedDuration: Duration.zero,
      volumeLevel: 0.0,
    ));
    _startVolumeSimulation();
    _startDurationTicker();
  }

  /// Pauses the current recording session.
  void pauseRecording() {
    if (!state.isRecording || state.isPaused) return;
    emit(state.copyWith(isPaused: true));
    _stopVolumeSimulation();
    _stopDurationTicker();
  }

  /// Resumes a paused recording session.
  void resumeRecording() {
    if (!state.isRecording || !state.isPaused) return;
    emit(state.copyWith(isPaused: false));
    _startVolumeSimulation();
    _startDurationTicker();
  }

  /// Stops recording and switches to review mode
  /// (used only in [SoundDialogVariant.feedbackRecorder]).
  void finishRecordingForReview(String path) {
    _stopAllTimers();
    emit(state.copyWith(
      isRecording: false,
      isPaused: false,
      isReviewing: true,
      filePath: path,
      volumeLevel: 0.0,
    ));
  }

  /// Stops the recording and finalizes the audio file.
  void stopRecording(String path) {
    _stopAllTimers();
    emit(state.copyWith(
      isRecording: false,
      isPaused: false,
      isReviewing: false,
      filePath: path,
      volumeLevel: 0.0,
    ));
  }

  /// Cancels the current recording and resets the dialog state.
  void cancelRecording() {
    _stopAllTimers();
    emit(SoundDialogState(variant: state.variant));
  }

  /// Starts the duration ticker, incrementing the recorded time each second.
  /// Also handles the logic for maximum recording duration.
  void _startDurationTicker() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!state.isRecording || state.isPaused) {
        timer.cancel();
        return;
      }

      final newDuration = state.recordedDuration + const Duration(seconds: 1);
      emit(state.copyWith(recordedDuration: newDuration));

      // Check if the maximum recording duration has been reached.
      if (maxRecordingDuration != null &&
          newDuration >= maxRecordingDuration!) {
        timer.cancel(); // Stop the timer immediately.

        if (autoStopOnMaxDuration) {
          // Automatically finish the recording based on the variant.
          const fakePath = "auto_stopped_record.wav";
          if (state.variant == SoundDialogVariant.feedbackRecorder) {
            finishRecordingForReview(fakePath);
          } else {
            // For other variants, finalize the recording.
            stopRecording(fakePath);
          }
        } else {
          // Just pause the recording, letting the user decide the next step.
          pauseRecording();
        }
      }
    });
  }

  /// Stops the duration ticker.
  void _stopDurationTicker() {
    _durationTimer?.cancel();
    _durationTimer = null;
  }

  /// Starts simulating live microphone volume changes.
  void _startVolumeSimulation() {
    _volumeTimer?.cancel();
    _volumeTimer = Timer.periodic(const Duration(milliseconds: 120), (_) {
      if (!state.isRecording || state.isPaused) {
        if (state.volumeLevel != 0.0) {
          emit(state.copyWith(volumeLevel: 0.0));
        }
        return;
      }
      final randomLevel = 0.2 + _random.nextDouble() * 0.8;
      emit(state.copyWith(volumeLevel: randomLevel.clamp(0.0, 1.0)));
    });
  }

  /// Stops the volume simulation ticker.
  void _stopVolumeSimulation() {
    _volumeTimer?.cancel();
    _volumeTimer = null;
  }

  /// Stops all running timers.
  void _stopAllTimers() {
    _stopVolumeSimulation();
    _stopDurationTicker();
  }

  @override
  Future<void> close() {
    _stopAllTimers();
    return super.close();
  }
}
