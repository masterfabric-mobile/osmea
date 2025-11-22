import 'dart:async';
import 'package:core/src/base/base_view_model_cubit.dart';
import 'package:core/src/views/search/cubit/search_state.dart';

/// 🔍 **Search Cubit**
///
/// Manages the state and business logic for the Search view.
/// Handles search queries, results, suggestions, and search history.
///
/// {@category Cubits}
/// {@subCategory SearchView}
class SearchCubit extends BaseViewModelCubit<SearchState> {
  SearchCubit({
    this.maxHistoryItems = 10,
    this.minQueryLength = 2,
    this.debounceDuration = const Duration(milliseconds: 500),
    List<String> initialHistory = const [],
  }) : super(SearchState.initial().copyWith(searchHistory: initialHistory));

  /// Maximum number of search history items to keep
  final int maxHistoryItems;

  /// Minimum query length to trigger search
  final int minQueryLength;

  /// Debounce duration for live search
  final Duration debounceDuration;

  /// Timer for debouncing search
  Timer? _debounceTimer;

  /// Current search query
  String get currentQuery => state.query;

  /// Whether search is currently active
  bool get isSearchActive => state.isSearching;

  /// Current search results
  List<dynamic> get searchResults => state.results;

  /// Current search suggestions
  List<String> get searchSuggestions => state.suggestions;

  /// Search history
  List<String> get searchHistory => state.searchHistory;

  /// Update the search query
  void updateQuery(String query) {
    emit(state.copyWith(
      query: query,
      isSearching: query.length >= minQueryLength,
    ));
  }

  /// Perform search with the given query (with debounce)
  Future<void> performSearch(
    String query, {
    Future<List<dynamic>> Function(String)? searchProvider,
    bool immediate = false,
  }) async {
    if (query.length < minQueryLength) {
      emit(state.copyWith(
        query: query,
        isSearching: false,
        results: [],
        isLoading: false,
      ));
      return;
    }

    // Cancel previous debounce timer
    _debounceTimer?.cancel();

    if (immediate) {
      // Execute immediately (e.g., on submit)
      await _executeSearch(query, searchProvider);
    } else {
      // Debounce the search
      _debounceTimer = Timer(debounceDuration, () async {
        await _executeSearch(query, searchProvider);
      });
    }
  }

  /// Execute the actual search
  Future<void> _executeSearch(
    String query,
    Future<List<dynamic>> Function(String)? searchProvider,
  ) async {
    // Start loading
    emit(state.copyWith(
      query: query,
      isSearching: true,
      isLoading: true,
    ));

    try {
      List<dynamic> results = [];

      if (searchProvider != null) {
        results = await searchProvider(query);
      }

      // Add to history if not already present
      _addToHistory(query);

      emit(state.copyWith(
        results: results,
        isLoading: false,
        hasResults: results.isNotEmpty,
      ));
    } catch (error) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: error.toString(),
      ));
    }
  }

  /// Get search suggestions for the given query
  Future<void> getSuggestions(
    String query, {
    Future<List<String>> Function(String)? suggestionProvider,
  }) async {
    if (query.length < minQueryLength) {
      emit(state.copyWith(suggestions: []));
      return;
    }

    emit(state.copyWith(isLoadingSuggestions: true));

    try {
      List<String> suggestions = [];

      if (suggestionProvider != null) {
        suggestions = await suggestionProvider(query);
      } else {
        // Fallback: filter search history
        suggestions = searchHistory
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .take(5)
            .toList();
      }

      emit(state.copyWith(
        suggestions: suggestions,
        isLoadingSuggestions: false,
      ));
    } catch (error) {
      emit(state.copyWith(
        suggestions: [],
        isLoadingSuggestions: false,
      ));
    }
  }

  /// Clear current search
  void clearSearch() {
    emit(state.copyWith(
      query: '',
      isSearching: false,
      results: [],
      suggestions: [],
      hasResults: false,
      isLoading: false,
      hasError: false,
      errorMessage: null,
    ));
  }

  /// Clear search results but keep query
  void clearResults() {
    emit(state.copyWith(
      results: [],
      hasResults: false,
      isLoading: false,
      hasError: false,
      errorMessage: null,
    ));
  }

  /// Add query to search history
  void _addToHistory(String query) {
    if (query.trim().isEmpty) return;

    final currentHistory = List<String>.from(state.searchHistory);

    // Remove if already exists
    currentHistory.remove(query);

    // Add to beginning
    currentHistory.insert(0, query);

    // Limit history size
    if (currentHistory.length > maxHistoryItems) {
      currentHistory.removeRange(maxHistoryItems, currentHistory.length);
    }

    emit(state.copyWith(searchHistory: currentHistory));
  }

  /// Remove item from search history
  void removeFromHistory(String query) {
    final currentHistory = List<String>.from(state.searchHistory);
    currentHistory.remove(query);
    emit(state.copyWith(searchHistory: currentHistory));
  }

  /// Clear all search history
  void clearHistory() {
    emit(state.copyWith(searchHistory: []));
  }

  /// Set loading state
  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  /// Set error state
  void setError(String? errorMessage) {
    emit(state.copyWith(
      hasError: errorMessage != null,
      errorMessage: errorMessage,
      isLoading: false,
    ));
  }

  /// Initialize search with configuration
  Future<void> initializeSearch({
    int maxHistoryItems = 10,
    int minQueryLength = 2,
    List<String> initialHistory = const [],
  }) async {
    emit(state.copyWith(searchHistory: initialHistory));
  }

  /// Reset to initial state
  void reset() {
    emit(SearchState.initial().copyWith(
      searchHistory: state.searchHistory, // Keep history
    ));
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
