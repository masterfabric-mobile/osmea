import 'package:equatable/equatable.dart';
import 'package:core/src/models/faq_models.dart';

/// ❓ **OSMEA FAQ View State**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// State management for FAQ View
///
/// {@category States}
/// {@subCategory FAQViewState}

/// 📱 FAQ view status enum
enum FAQViewStatus {
  /// Initial state
  initial,

  /// Loading content
  loading,

  /// Content loaded successfully
  loaded,

  /// Error loading content
  error,
}

/// ❓ FAQ view state class
class FAQViewState extends Equatable {
  /// Current status
  final FAQViewStatus status;

  /// FAQ page model
  final FAQPageModel? model;

  /// Error message if loading failed
  final String? errorMessage;

  /// Expanded items indices
  final Set<int> expandedIndices;

  /// Search query
  final String searchQuery;

  /// Selected category filter
  final String? selectedCategory;

  const FAQViewState({
    this.status = FAQViewStatus.initial,
    this.model,
    this.errorMessage,
    this.expandedIndices = const {},
    this.searchQuery = '',
    this.selectedCategory,
  });

  /// Create a copy of the current state with modified values
  FAQViewState copyWith({
    FAQViewStatus? status,
    FAQPageModel? model,
    String? errorMessage,
    Set<int>? expandedIndices,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return FAQViewState(
      status: status ?? this.status,
      model: model ?? this.model,
      errorMessage: errorMessage ?? this.errorMessage,
      expandedIndices: expandedIndices ?? this.expandedIndices,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  /// Check if currently loading
  bool get isLoading => status == FAQViewStatus.loading;

  /// Check if content is loaded
  bool get isLoaded => status == FAQViewStatus.loaded;

  /// Check if there's an error
  bool get hasError => status == FAQViewStatus.error;

  /// Get filtered items based on search and category
  List<FAQItem> getFilteredItems() {
    if (model == null) return [];

    var items = model!.items;

    // Filter by category
    if (selectedCategory != null) {
      items = items
          .where((item) => item.category == selectedCategory)
          .toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      items = items
          .where((item) =>
              item.question.toLowerCase().contains(query) ||
              item.answer.toLowerCase().contains(query))
          .toList();
    }

    return items;
  }

  @override
  List<Object?> get props => [
        status,
        model,
        errorMessage,
        expandedIndices,
        searchQuery,
        selectedCategory,
      ];

  @override
  String toString() {
    return 'FAQViewState(status: $status, model: ${model?.title}, errorMessage: $errorMessage, expandedIndices: $expandedIndices)';
  }
}
