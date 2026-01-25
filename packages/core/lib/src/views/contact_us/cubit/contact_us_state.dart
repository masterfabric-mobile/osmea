import 'package:equatable/equatable.dart';
import 'package:core/src/models/contact_us_models.dart';

/// 📧 **OSMEA Contact Us View State**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// State management for Contact Us View
///
/// {@category States}
/// {@subCategory ContactUsViewState}

/// 📱 Contact us view status enum
enum ContactUsViewStatus {
  /// Initial state
  initial,

  /// Loading content
  loading,

  /// Content loaded successfully
  loaded,

  /// Submitting form
  submitting,

  /// Form submitted successfully
  submitted,

  /// Error loading content or submitting form
  error,
}

/// 📧 Contact us view state class
class ContactUsViewState extends Equatable {
  /// Current status
  final ContactUsViewStatus status;

  /// Contact us page model
  final ContactUsPageModel? model;

  /// Error message if loading failed
  final String? errorMessage;

  const ContactUsViewState({
    this.status = ContactUsViewStatus.initial,
    this.model,
    this.errorMessage,
  });

  /// Create a copy of the current state with modified values
  ContactUsViewState copyWith({
    ContactUsViewStatus? status,
    ContactUsPageModel? model,
    String? errorMessage,
  }) {
    return ContactUsViewState(
      status: status ?? this.status,
      model: model ?? this.model,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Check if currently loading
  bool get isLoading => status == ContactUsViewStatus.loading;

  /// Check if content is loaded
  bool get isLoaded => status == ContactUsViewStatus.loaded;

  /// Check if form is submitting
  bool get isSubmitting => status == ContactUsViewStatus.submitting;

  /// Check if form is submitted
  bool get isSubmitted => status == ContactUsViewStatus.submitted;

  /// Check if there's an error
  bool get hasError => status == ContactUsViewStatus.error;

  @override
  List<Object?> get props => [
        status,
        model,
        errorMessage,
      ];

  @override
  String toString() {
    return 'ContactUsViewState(status: $status, model: ${model?.title}, errorMessage: $errorMessage)';
  }
}
