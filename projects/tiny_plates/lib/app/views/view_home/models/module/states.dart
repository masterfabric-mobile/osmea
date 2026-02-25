/*
 * Home States
 * -----------
 * States for the home view (Tiny Plates).
 */

/// Base class for all home states
abstract class HomeState {}

/// Initial state when the view is first loaded
class HomeInitialState extends HomeState {}

/// Loading state
class HomeLoadingState extends HomeState {}

/// Loaded state when content is ready to display
class HomeLoadedState extends HomeState {
  HomeLoadedState();
}
