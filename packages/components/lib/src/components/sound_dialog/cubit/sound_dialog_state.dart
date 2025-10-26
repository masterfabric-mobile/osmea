/// 🔊 OSMEA Sound Dialog State
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// Immutable state model for the OSMEA sound recording dialog component.
///
/// Holds the current configuration and runtime information such as
/// recording, pause, visibility, playback review, and live volume level.
///
/// {@category State}
/// {@subCategory Dialog}
///
/// Example usage:
/// ```dart
/// final state = SoundDialogState(
///   variant: SoundDialogVariant.feedbackRecorder,
///   isRecording: true,
///   volumeLevel: 0.7,
/// );
/// ```

import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:osmea_components/src/enums/sound_dialog_enums.dart';

/// Holds the configuration and runtime data for a sound dialog instance.
@immutable
class SoundDialogState {
  /// The visual and behavioral variant of the sound dialog.
  final SoundDialogVariant variant;

  /// Whether a recording session is currently active.
  final bool isRecording;

  /// Whether the current recording is paused.
  final bool isPaused;

  /// The total duration of the recording so far.
  final Duration recordedDuration;

  /// The file path of the recorded audio, if available.
  final String? filePath;

  /// Whether the sound dialog is visible on screen.
  final bool visible;

  /// The current microphone volume level (0.0 – 1.0),
  /// used for waveform animation feedback.
  final double volumeLevel;

  /// Indicates whether the dialog is in reviewing mode
  /// (applies only to the [SoundDialogVariant.feedbackRecorder] variant).
  final bool isReviewing;

  /// Creates a new immutable [SoundDialogState] instance.
  const SoundDialogState({
    required this.variant,
    this.isRecording = false,
    this.isPaused = false,
    this.recordedDuration = Duration.zero,
    this.filePath,
    this.visible = true,
    this.volumeLevel = 0.0,
    this.isReviewing = false,
  });

  /// Returns a copy of this state with updated fields.
  SoundDialogState copyWith({
    SoundDialogVariant? variant,
    bool? isRecording,
    bool? isPaused,
    Duration? recordedDuration,
    String? filePath,
    bool? visible,
    double? volumeLevel,
    bool? isReviewing,
  }) =>
      SoundDialogState(
        variant: variant ?? this.variant,
        isRecording: isRecording ?? this.isRecording,
        isPaused: isPaused ?? this.isPaused,
        recordedDuration: recordedDuration ?? this.recordedDuration,
        filePath: filePath ?? this.filePath,
        visible: visible ?? this.visible,
        volumeLevel: volumeLevel ?? this.volumeLevel,
        isReviewing: isReviewing ?? this.isReviewing,
      );
}
