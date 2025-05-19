import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

/// 🧩 Base class for all ViewModel Blocs.
/// Provides logging and state management utilities.
abstract class BaseViewModelBloc<E, S> extends Bloc<E, S> {
  /// 📝 Logger instance for logging state changes.

  /// 🏗️ Constructor with optional logger for testability.
  ///
  /// Throws assertion error if logger is null.
  BaseViewModelBloc(S state) : super(state);

  /// 📦 Getter for current state.
  S get currentState => state;

  /// 🔄 Updates the state and emits the new value.
  void updateState(S newState) {
    // ignore: invalid_use_of_visible_for_testing_member
    emit(newState);
  }

  @override
  void onChange(Change<S> change) {
    // 🔔 State change detected!
    try {
      debugPrint('🔄 State changed!');
      debugPrint('Current: ${change.currentState}');
      debugPrint('Next: ${change.nextState}');
    } catch (e, stack) {
      // ⚠️ Logging failed, report to FlutterError
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        stack: stack,
        library: 'base_view_model.dart',
        context: ErrorDescription('Error while logging onChange'),
      ));
    }
    super.onChange(change);
  }

  @override
  void onTransition(Transition<E, S> transition) {
    // 🔁 Bloc transition detected!
    try {
      debugPrint('🔁 Transition!');
      debugPrint('Event: ${transition.event}');
      debugPrint('CurrentState: ${transition.currentState}');
      debugPrint('NextState: ${transition.nextState}');
    } catch (e, stack) {
      // ⚠️ Logging failed, report to FlutterError
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        stack: stack,
        library: 'base_view_model.dart',
        context: ErrorDescription('Error while logging onTransition'),
      ));
    }
    super.onTransition(transition);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // ❌ Error detected in Bloc!
    try {
      debugPrint('❌ Error: $error');
      debugPrint('🧵 StackTrace: $stackTrace');
    } catch (e) {
      // ⚠️ Logging failed, report to FlutterError
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        stack: stackTrace,
        library: 'base_view_model.dart',
        context: ErrorDescription('Error while logging onError'),
      ));
    }
    super.onError(error, stackTrace);
  }
}
