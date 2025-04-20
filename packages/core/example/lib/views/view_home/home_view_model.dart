import 'package:core/core.dart';
import 'package:example/views/view_home/module/events.dart';
import 'package:example/views/view_home/module/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable

/// ViewModel for the HomeView.
class HomeViewModel extends BaseViewModelBloc<HomeViewEvents, HomeViewStates> {
  HomeViewModel() : super(HomeViewInitialState()) {
    on<HomeViewInitialEvent>(_onInitialEvent);
  }

  _onInitialEvent(HomeViewInitialEvent event, Emitter<HomeViewStates> emit) {
    emit(HomeViewLoadingState());
    // Simulate a network call or some async operation
    Future.delayed(Duration(seconds: 2), () {});
  }
}
