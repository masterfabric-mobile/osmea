import 'package:equatable/equatable.dart';
import 'package:core/src/models/about_models.dart';

/// 📄 **OSMEA About View State**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// State management for About View
///
/// {@category States}
/// {@subCategory AboutViewState}

/// 📱 About view status enum
enum AboutViewStatus {
  /// Initial state
  initial,

  /// Loading content
  loading,

  /// Content loaded successfully
  loaded,

  /// Error loading content
  error,
}

/// 📄 About view state class
class AboutViewState extends Equatable {
  /// Current status
  final AboutViewStatus status;

  /// About page model
  final AboutPageModel? model;

  /// Error message if loading failed
  final String? errorMessage;

  const AboutViewState({
    this.status = AboutViewStatus.initial,
    this.model,
    this.errorMessage,
  });

  /// Create a copy of the current state with modified values
  AboutViewState copyWith({
    AboutViewStatus? status,
    AboutPageModel? model,
    String? errorMessage,
  }) {
    return AboutViewState(
      status: status ?? this.status,
      model: model ?? this.model,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Check if currently loading
  bool get isLoading => status == AboutViewStatus.loading;

  /// Check if content is loaded
  bool get isLoaded => status == AboutViewStatus.loaded;

  /// Check if there's an error
  bool get hasError => status == AboutViewStatus.error;

  @override
  List<Object?> get props => [
        status,
        model,
        errorMessage,
      ];

  @override
  String toString() {
    return 'AboutViewState(status: $status, model: ${model?.title}, errorMessage: $errorMessage)';
  }
}
