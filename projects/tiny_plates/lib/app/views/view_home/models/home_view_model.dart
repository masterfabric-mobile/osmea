/*
 * HomeViewModel
 * -------------
 * ViewModel for the home view (Tiny Plates).
 * Uses BaseViewModelHydratedCubit for HydratedBloc state persistence.
 */

import 'package:injectable/injectable.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:tiny_plates/app/views/view_home/models/module/states.dart';

@injectable
class HomeViewModel extends BaseViewModelHydratedCubit<HomeState> {
  HomeViewModel() : super(HomeInitialState());

  final Map<String, dynamic> _arguments = {};

  void setArguments(Map<String, dynamic> args) {
    _arguments
      ..clear()
      ..addAll(args);
  }

  Map<String, dynamic> get arguments => Map.unmodifiable(_arguments);

  void initial() {
    emit(HomeLoadedState());
  }

  @override
  HomeState? fromJson(Map<String, dynamic> json) {
    return null; // State reconstructed on load
  }

  @override
  Map<String, dynamic>? toJson(HomeState state) {
    return null; // No persistence needed for minimal home state
  }
}
