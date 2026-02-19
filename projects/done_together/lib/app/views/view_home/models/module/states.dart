/// Base state for home view.
abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final String? userName;

  HomeLoadedState({this.userName});
}

class HomeErrorState extends HomeState {
  final String message;

  HomeErrorState(this.message);
}
