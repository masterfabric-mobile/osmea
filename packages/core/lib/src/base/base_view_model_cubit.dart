import 'package:core/src/helper/common_logger_helper/abstract/common_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart'; // For FlutterError

/// 🧩 Base class for Cubit-based ViewModels.
/// Provides logging and error handling for state changes.
abstract class BaseViewModelCubit<S> extends Cubit<S> {
  /// 📝 Logger instance for logging state changes and errors.
  final ICommonLogger _logger = GetIt.I<ICommonLogger>();

  /// 🏗️ Constructor with non-null state assertion.
  /// 
  /// Example:
  /// ```dart
  /// MyCubit() : super(MyInitialState());
  /// ```
  BaseViewModelCubit(S state)
      : assert(state != null, '🚨 State cannot be null!'), // Assertion example and explanation
        super(state);

  /// 🚀 Setter to update the state with error handling.
  /// 
  /// Example:
  /// ```dart
  /// cubit.stateCurrentValue = newState;
  /// ```
  set stateCurrentValue(S value) {
    // 🚀 State is being updated. Errors are caught by try-catch.
    try {
      // ignore: invalid_use_of_visible_for_testing_member
      emit(value);
    } catch (e, stack) {
      _logger.printBaseViewModelQubitLogs([
        "❌ Error occurred during emit:",
        e.toString(),
        stack.toString()
      ]);
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        stack: stack,
        library: 'base_view_model_cubit',
        context: ErrorDescription('stateCurrentValue emit'),
      ));
    }
  }

  /// 🔄 Method to change the state with error handling.
  /// 
  /// Example:
  /// ```dart
  /// cubit.stateChanger(newState);
  /// ```
  void stateChanger(S state) {
    // 🔄 State is being changed. Errors are caught by try-catch.
    try {
      // ignore: invalid_use_of_visible_for_testing_member
      emit(state);
    } catch (e, stack) {
      _logger.printBaseViewModelQubitLogs([
        "❌ Error occurred during emit:",
        e.toString(),
        stack.toString()
      ]);
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        stack: stack,
        library: 'base_view_model_cubit',
        context: ErrorDescription('stateChanger emit'),
      ));
    }
  }

  /// 📝 Called whenever the state changes. Logs before and after states.
  /// 
  /// Example:
  /// ```dart
  ///  This is called automatically by Bloc.
  /// ```
  @override
  void onChange(Change<S> change) {
    // 📝 State change is being logged.
    _logger.printBaseViewModelQubitLogs([
      "Before",
      change.currentState.toString(),
      "After",
      change.nextState.toString()
    ]);
    super.onChange(change);
  }
}
