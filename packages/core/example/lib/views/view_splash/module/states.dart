abstract class SplashState {}

class SplashStateLoading extends SplashState {}

class SplashStateContent extends SplashState {
  final String contentValue;
  SplashStateContent({required this.contentValue});
}

class SplashStateError extends SplashState {
  final String contentValue;

  SplashStateError({required this.contentValue});
}
