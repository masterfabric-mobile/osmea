abstract class SearchState {}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchLoadedState extends SearchState {
  final List<String> searchResults;

  SearchLoadedState({required this.searchResults});
}

class SearchErrorState extends SearchState {
  final String message;

  SearchErrorState(this.message);
}