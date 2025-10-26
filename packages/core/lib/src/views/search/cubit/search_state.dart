import 'package:equatable/equatable.dart';

/// 🔍 **Search State**
///
/// Represents the state of the search functionality.
/// Contains search query, results, suggestions, loading states, and error handling.
///
/// {@category States}
/// {@subCategory SearchView}
class SearchState extends Equatable {
  const SearchState({
    required this.query,
    required this.isSearching,
    required this.isLoading,
    required this.isLoadingSuggestions,
    required this.results,
    required this.suggestions,
    required this.searchHistory,
    required this.hasResults,
    required this.hasError,
    this.errorMessage,
  });

  /// Current search query
  final String query;

  /// Whether search is currently active
  final bool isSearching;

  /// Whether search results are being loaded
  final bool isLoading;

  /// Whether search suggestions are being loaded
  final bool isLoadingSuggestions;

  /// Current search results
  final List<dynamic> results;

  /// Current search suggestions
  final List<String> suggestions;

  /// Search history
  final List<String> searchHistory;

  /// Whether there are search results
  final bool hasResults;

  /// Whether there is an error
  final bool hasError;

  /// Error message if any
  final String? errorMessage;

  /// Initial state
  factory SearchState.initial() {
    return const SearchState(
      query: '',
      isSearching: false,
      isLoading: false,
      isLoadingSuggestions: false,
      results: [],
      suggestions: [],
      searchHistory: [],
      hasResults: false,
      hasError: false,
      errorMessage: null,
    );
  }

  /// Loading state
  factory SearchState.loading({
    required String query,
    List<String> searchHistory = const [],
  }) {
    return SearchState(
      query: query,
      isSearching: true,
      isLoading: true,
      isLoadingSuggestions: false,
      results: const [],
      suggestions: const [],
      searchHistory: searchHistory,
      hasResults: false,
      hasError: false,
      errorMessage: null,
    );
  }

  /// Success state with results
  factory SearchState.success({
    required String query,
    required List<dynamic> results,
    List<String> searchHistory = const [],
  }) {
    return SearchState(
      query: query,
      isSearching: true,
      isLoading: false,
      isLoadingSuggestions: false,
      results: results,
      suggestions: const [],
      searchHistory: searchHistory,
      hasResults: results.isNotEmpty,
      hasError: false,
      errorMessage: null,
    );
  }

  /// Error state
  factory SearchState.error({
    required String query,
    required String errorMessage,
    List<String> searchHistory = const [],
  }) {
    return SearchState(
      query: query,
      isSearching: true,
      isLoading: false,
      isLoadingSuggestions: false,
      results: const [],
      suggestions: const [],
      searchHistory: searchHistory,
      hasResults: false,
      hasError: true,
      errorMessage: errorMessage,
    );
  }

  /// Copy with method for state updates
  SearchState copyWith({
    String? query,
    bool? isSearching,
    bool? isLoading,
    bool? isLoadingSuggestions,
    List<dynamic>? results,
    List<String>? suggestions,
    List<String>? searchHistory,
    bool? hasResults,
    bool? hasError,
    String? errorMessage,
  }) {
    return SearchState(
      query: query ?? this.query,
      isSearching: isSearching ?? this.isSearching,
      isLoading: isLoading ?? this.isLoading,
      isLoadingSuggestions: isLoadingSuggestions ?? this.isLoadingSuggestions,
      results: results ?? this.results,
      suggestions: suggestions ?? this.suggestions,
      searchHistory: searchHistory ?? this.searchHistory,
      hasResults: hasResults ?? this.hasResults,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Whether the search is in empty state (no query, no results)
  bool get isEmpty => query.isEmpty && results.isEmpty;

  /// Whether search suggestions should be shown
  bool get shouldShowSuggestions =>
      query.isNotEmpty &&
      !isLoading &&
      (suggestions.isNotEmpty || searchHistory.isNotEmpty);

  /// Whether to show search history
  bool get shouldShowHistory => query.isEmpty && searchHistory.isNotEmpty;

  /// Whether to show "no results" message
  bool get shouldShowNoResults =>
      !isLoading && query.isNotEmpty && !hasError && results.isEmpty;

  /// Whether to show error message
  bool get shouldShowError => hasError && errorMessage != null;

  @override
  List<Object?> get props => [
        query,
        isSearching,
        isLoading,
        isLoadingSuggestions,
        results,
        suggestions,
        searchHistory,
        hasResults,
        hasError,
        errorMessage,
      ];

  @override
  String toString() {
    return 'SearchState('
        'query: $query, '
        'isSearching: $isSearching, '
        'isLoading: $isLoading, '
        'hasResults: $hasResults, '
        'hasError: $hasError, '
        'resultsCount: ${results.length}, '
        'suggestionsCount: ${suggestions.length}, '
        'historyCount: ${searchHistory.length}'
        ')';
  }
}
