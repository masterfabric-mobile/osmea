/// 🔊 OSMEA Sound Dialog Enums
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// Enum definitions for sound dialog component variants.
///
/// {@category Enums}
/// {@subCategory Dialog}
///
/// Enums:
/// * 🎙️ SoundDialogVariant - Style variants for sound dialogs
///
/// Example usage:
/// ```dart
/// OsmeaComponents.soundDialog(variant: SoundDialogVariant.expandable);
/// ```

// ignore_for_file: constant_identifier_names

/// Defines the visual and functional variants for the OsmeaSoundDialog.
enum SoundDialogVariant {
  /// 🎤 A standard, compact dialog with a central microphone button
  /// and expanding wave effects for recording feedback.
  standard,

  /// 📊 An advanced dialog featuring a sound wave visualizer (bar graph)
  /// and separate, explicit controls for recording actions.
  expandable,

  /// 🔍 Minimal variant that works inside the search bar.
  inlineSearchBar,

  /// 💬 Feedback variant with the ability to listen to the recording and re-record it.
  feedbackRecorder,
}
