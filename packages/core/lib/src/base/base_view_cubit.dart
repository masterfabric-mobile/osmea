import 'package:core/src/base/base_view_model_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// 🧑‍💻 Called when the ViewModel is ready.
/// 
/// Example:
/// ```dart
/// onViewModelReady: (viewModel) {
///   viewModel.init();
/// }
/// ```
typedef OnViewModelReady<V> = void Function(V viewModel);

/// 🧹 Called before the ViewModel is disposed.
/// 
/// Example:
/// ```dart
/// onViewModelEnd: (viewModel) {
///   viewModel.disposeResources();
/// }
/// ```
typedef OnViewModelEnd<V> = void Function(V viewModel);

/// 🖼️ Builder function that creates the UI with ViewModel and state.
/// 
/// Example:
/// ```dart
/// builder: (viewModel, context, state) {
///   return Text(state.title);
/// }
/// ```
typedef OnViewModelStateBuilder<V, S> = Widget Function(
    V viewModel, BuildContext context, S state);

/// 🎧 Listener triggered on state changes.
/// 
/// Example:
/// ```dart
/// onStateListener: (context, state) {
///   if (state.hasError) {
///     showErrorDialog(context);
///   }
/// }
/// ```
typedef OnStateListener<S> = void Function(BuildContext context, S? state);

/// 🔄 Determines whether the builder should be called.
/// 
/// Example:
/// ```dart
/// buildWhen: (previous, current) => previous != current,
/// ```
typedef BuilderCondition<S> = bool Function(S? previous, S? current);

/// 🌟
/// BaseViewCubit simplifies lifecycle, state listening, and builder management with Cubit-based ViewModel.
///
class BaseViewCubit<V extends BaseViewModelCubit<S>, S> extends StatefulWidget {
  const BaseViewCubit({
    Key? key,
    this.onViewModelReady,
    this.onViewModelEnd,
    required this.builder,
    this.onStateListener,
    this.buildWhen,
  }) : super(key: key);

  /// 🧑‍💻 Callback when ViewModel is ready.
  final OnViewModelReady<V>? onViewModelReady;

  /// 🧹 Callback before ViewModel is disposed.
  final OnViewModelEnd<V>? onViewModelEnd;

  /// 🖼️ Builder for UI with ViewModel and state.
  final OnViewModelStateBuilder<V, S> builder;

  /// 🎧 Listener for state changes.
  final OnStateListener<S>? onStateListener;

  /// 🔄 Condition to determine builder call.
  final BuilderCondition<S>? buildWhen;

  /// 🗺️ Global key for navigation, dialogs, and bottom sheets.
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// ⬆️ Helper to show a bottom sheet.
  /// 
  /// Example:
  /// ```dart
  /// BaseViewCubit.showBottomSheet(
  ///   builder: (context) => MyBottomSheetWidget(),
  /// );
  /// ```
  static Future<T?> showBottomSheet<T>({
    required WidgetBuilder builder,
    bool isScrollControlled = false,
    bool useRootNavigator = true,
  }) {
    return showModalBottomSheet<T>(
      context: navigatorKey.currentContext!,
      builder: builder,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
    );
  }

  /// 🗨️ Helper to show a dialog.
  /// 
  /// Example:
  /// ```dart
  /// BaseViewCubit.showDialogBox(
  ///   builder: (context) => AlertDialog(title: Text('Hello')),
  /// );
  /// ```
  static Future<T?> showDialogBox<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
  }) {
    return showDialog<T>(
      context: navigatorKey.currentContext!,
      builder: builder,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
    );
  }

  /// 🚀 Navigation helper: Push a new route onto the navigator stack.
  /// 
  /// Example:
  /// ```dart
  /// BaseViewCubit.navigateTo(MaterialPageRoute(builder: (_) => MyPage()));
  /// ```
  static Future<T?> navigateTo<T extends Object?>(Route<T> route) {
    return navigatorKey.currentState!.push<T>(route);
  }

  /// 🔄 Navigation helper: Replace the current route by pushing a new one and disposing the previous route.
  /// 
  /// Example:
  /// ```dart
  /// BaseViewCubit.pushReplacement(
  ///   MaterialPageRoute(builder: (_) => NewPage()),
  /// );
  /// ```
  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
      Route<T> newRoute, {
      TO? result,
    }) {
    return navigatorKey.currentState!.pushReplacement<T, TO>(newRoute, result: result);
  }

  /// 🚀 Navigation helper: Push a new route and remove all previous routes until the predicate returns true.
  /// 
  /// Example:
  /// ```dart
  /// BaseViewCubit.pushAndRemoveUntil(
  ///   MaterialPageRoute(builder: (_) => HomePage()),
  ///   (route) => false,
  /// );
  /// ```
  static Future<T?> pushAndRemoveUntil<T extends Object?>(
      Route<T> newRoute,
      bool Function(Route<dynamic>) predicate,
    ) {
    return navigatorKey.currentState!.pushAndRemoveUntil<T>(newRoute, predicate);
  }

  /// 🔙 Navigation helper: Pop the top-most route off the navigator stack.
  /// 
  /// Example:
  /// ```dart
  /// BaseViewCubit.pop();
  /// ```
  static void pop<T extends Object?>([T? result]) {
    navigatorKey.currentState!.pop<T>(result);
  }

  /// ❓ Navigation helper: Maybe pop the top-most route if possible.
  /// 
  /// Example:
  /// ```dart
  /// BaseViewCubit.maybePop();
  /// ```
  static Future<bool> maybePop<T extends Object?>([T? result]) {
    return navigatorKey.currentState!.maybePop<T>(result);
  }

  /// ⬆️ Navigation helper: Pop routes until the predicate returns true.
  /// 
  /// Example:
  /// ```dart
  /// BaseViewCubit.popUntil((route) => route.isFirst);
  /// ```
  static void popUntil(bool Function(Route<dynamic>) predicate) {
    navigatorKey.currentState!.popUntil(predicate);
  }

  @override
  State<BaseViewCubit<V, S>> createState() => _BaseViewCubitState<V, S>();
}

class _BaseViewCubitState<V extends BaseViewModelCubit<S>, S>
    extends State<BaseViewCubit<V, S>> {
  /// 🏗️ Lazily get ViewModel instance from GetIt.
  late final V viewModel = GetIt.I<V>();

  @override
  void initState() {
    super.initState();
    try {
      // 🧑‍💻 Call onViewModelReady if provided.
      widget.onViewModelReady?.call(viewModel);
    } catch (e, stack) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        stack: stack,
        library: 'base_view_cubit',
        context: ErrorDescription('while calling onViewModelReady'),
      ));
    }
  }

  @override
  void dispose() {
    try {
      // 🧹 Call onViewModelEnd if provided.
      widget.onViewModelEnd?.call(viewModel);
    } catch (e, stack) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        stack: stack,
        library: 'base_view_cubit',
        context: ErrorDescription('while calling onViewModelEnd'),
      ));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      // 🏗️ Provide ViewModel to widget tree and handle navigation.
      return BlocProvider<V>.value(
        value: viewModel,
        child: Navigator(
          key: BaseViewCubit.navigatorKey,
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => BlocConsumer<V, S>(
              listener: widget.onStateListener ?? (_, __) {},
              buildWhen: widget.buildWhen,
              builder: (context, state) {
                try {
                  // 🖼️ Build UI with ViewModel and state.
                  return widget.builder(viewModel, context, state);
                } catch (e, stack) {
                  FlutterError.reportError(FlutterErrorDetails(
                    exception: e,
                    stack: stack,
                    library: 'base_view_cubit',
                    context: ErrorDescription('while building BlocConsumer.builder'),
                  ));
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      );
    } catch (e, stack) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        stack: stack,
        library: 'base_view_cubit',
        context: ErrorDescription('while building BaseViewCubit'),
      ));
      return const SizedBox.shrink();
    }
  }
}
