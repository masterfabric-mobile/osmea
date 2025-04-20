import 'package:core/src/base/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// 🧑‍💻 Type definition for a callback that is called when the ViewModel is ready.
/// Useful for initializing data or starting listeners.
typedef OnViewModelReady<V> = void Function(V viewModel);

/// 🧹 Type definition for a callback that is called when the ViewModel is about to be disposed.
/// Useful for cleaning up resources.
typedef OnViewModelEnd<V> = void Function(V viewModel);

/// 🖼️ Type definition for the builder function that builds the UI based on the ViewModel and state.
typedef OnViewModelStateBuilder<V, S> = Widget Function(
    V viewModel, BuildContext context, S state);

/// 🎧 Type definition for a listener that reacts to state changes.
typedef OnStateListener<S> = void Function(BuildContext context, Object? state);

/// 🔄 Type definition for a condition to determine whether the builder should be called.
/// Returns true if the widget should rebuild.
typedef BuilderCondition<S> = bool Function(S? previous, S? current);

/// 🪟 Type definition for showing a bottom sheet.
typedef ShowBottomSheet = Future<T?> Function<T>({
  required WidgetBuilder builder,
  bool isScrollControlled,
  Color? backgroundColor,
});

/// 🪟 Type definition for showing a dialog.
typedef ShowDialog = Future<T?> Function<T>({
  required WidgetBuilder builder,
  bool barrierDismissible,
});

/// 🧭 Type definition for navigation actions.
typedef Navigate = Future<T?> Function<T>(Route<T> route);

/// 🪧 Type definition for showing a banner.
typedef ShowBanner = void Function({
  required Widget content,
  Color? backgroundColor,
  Duration? duration,
});

/// 🌟
/// BaseView is a generic widget that provides a convenient way to use BLoC and ViewModel patterns together.
/// It handles ViewModel lifecycle, state listening, and error reporting in a single place.
///
/// Example usage:
/// ```dart
/// BaseView<MyBloc, MyEvent, MyState>(
///   onViewModelReady: (bloc) => bloc.add(MyInitEvent()),
///   builder: (bloc, context, state) {
///     if (state is MyLoadingState) {
///       return CircularProgressIndicator();
///     }
///     if (state is MyLoadedState) {
///       return Text(state.data);
///     }
///     return SizedBox.shrink();
///   },
/// )
/// ```
///
/// Features:
/// - 🔗 Dependency injection via GetIt
/// - 🛡️ Error handling with FlutterError.reportError
/// - 🧩 Customizable builder, listener, and buildWhen
/// - 🧬 Lifecycle hooks for ViewModel
class BaseView<V extends BaseViewModelBloc<E, S>, E, S> extends StatefulWidget {
  /// Creates a [BaseView] widget.
  ///
  /// [onViewModelReady] is called in initState, after the ViewModel is created.
  /// [onViewModelEnd] is called in dispose, before the ViewModel is destroyed.
  /// [builder] is required to build the UI.
  /// [onStateListener] is called on every state change.
  /// [buildWhen] controls when the builder is called.
  const BaseView({
    Key? key,
    this.onViewModelReady,
    this.onViewModelEnd,
    this.builder,
    this.onStateListener,
    this.buildWhen,
    this.showBottomSheet,
    this.showDialog,
    this.navigate,
    this.showBanner, // 🪧 Add showBanner parameter
  })  : assert(builder != null, 'builder must not be null!'), // 🚨 Assertion for builder
        super(key: key);

  final OnViewModelReady<V>? onViewModelReady;
  final OnViewModelEnd<V>? onViewModelEnd;
  final OnViewModelStateBuilder<V, S>? builder;
  final OnStateListener<S>? onStateListener;
  final BuilderCondition<S>? buildWhen;
  final ShowBottomSheet? showBottomSheet;
  final ShowDialog? showDialog;
  final Navigate? navigate;
  final ShowBanner? showBanner; // 🪧 Add showBanner field

  @override
  State<BaseView<V, E, S>> createState() => _BaseViewState<V, E, S>();
}

///
/// The private State class for [BaseView].
/// Handles lifecycle, error reporting, and widget building.
///
class _BaseViewState<V extends BaseViewModelBloc<E, S>, E, S>
    extends State<BaseView<V, E, S>> with WidgetsBindingObserver {
  /// 🧩 ViewModel instance injected via GetIt.
  late final V viewModel = GetIt.I<V>();

  @override
  void initState() {
    super.initState();
    // 🚦 Call the ready callback if provided, with error handling and null check.
    assert(viewModel != null, 'ViewModel must not be null!'); // 🚨 Assertion for viewModel
    try {
      if (viewModel == null) {
        FlutterError.reportError(FlutterErrorDetails(
          exception: Exception('ViewModel is null in initState'),
          library: 'base_view_bloc',
          context: ErrorDescription('while initializing BaseView'),
        ));
      } else {
        widget.onViewModelReady?.call(viewModel);
      }
    } catch (e, stack) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        stack: stack,
        library: 'base_view_bloc',
        context: ErrorDescription('while calling onViewModelReady'),
      ));
    }
    // 👀 Add this widget as an observer to app lifecycle changes, with error handling.
    try {
      WidgetsBinding.instance.addObserver(this);
    } catch (e, stack) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        stack: stack,
        library: 'base_view_bloc',
        context: ErrorDescription('while adding WidgetsBinding observer'),
      ));
    }
  }

  @override
  void dispose() {
    // 👋 Remove observer before disposing.
    WidgetsBinding.instance.removeObserver(this);
    // 🧹 Call the end callback if provided.
    widget.onViewModelEnd?.call(viewModel);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state);
  // 💤 This method can be overridden for custom lifecycle handling.

  /// Helper to show a bottom sheet.
  Future<T?> showBottomSheet<T>({
    required WidgetBuilder builder,
    bool isScrollControlled = false,
    Color? backgroundColor,
  }) {
    if (widget.showBottomSheet != null) {
      return widget.showBottomSheet!.call(
        builder: builder,
        isScrollControlled: isScrollControlled,
        backgroundColor: backgroundColor,
      );
    }
    return showModalBottomSheet<T>(
      context: context,
      builder: builder,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
    );
  }

  /// Helper to show a dialog.
  Future<T?> showDialogHelper<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    if (widget.showDialog != null) {
      return widget.showDialog!.call(
        builder: builder,
        barrierDismissible: barrierDismissible,
      );
    }
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }

  /// Helper to navigate.
  Future<T?> navigate<T>(Route<T> route) {
    if (widget.navigate != null) {
      return widget.navigate!.call(route);
    }
    return Navigator.of(context).push(route);
  }

  /// Helper to show a banner.
  void showBanner({
    required Widget content,
    Color? backgroundColor,
    Duration? duration,
  }) {
    if (widget.showBanner != null) {
      widget.showBanner!(
        content: content,
        backgroundColor: backgroundColor,
        duration: duration,
      );
      return;
    }
    // Default implementation using ScaffoldMessenger
    final banner = MaterialBanner(
      content: content,
      backgroundColor: backgroundColor,
      actions: [
        TextButton(
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          child: const Text('Kapat'),
        ),
      ],
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(banner);
    if (duration != null) {
      Future.delayed(duration, () {
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🛡️ Top-level error handling for the build method.
    assert(viewModel != null, 'ViewModel must not be null!'); // 🚨 Assertion for viewModel
    assert(widget.builder != null, 'builder must not be null!'); // 🚨 Assertion for builder
    try {
      // ❗ Defensive: Check if viewModel is null (should not happen).
      if (viewModel == null) {
        FlutterError.reportError(FlutterErrorDetails(
          exception: Exception('ViewModel is null'),
          library: 'base_view_bloc',
          context: ErrorDescription('while building BaseView'),
        ));
        return const SizedBox.shrink();
      }
      // ❗ Defensive: Warn if builder is null.
      if (widget.builder == null) {
        FlutterError.reportError(FlutterErrorDetails(
          exception: Exception('Builder is null'),
          library: 'base_view_bloc',
          context: ErrorDescription('while building BaseView'),
        ));
      }
      // 🏗️ Provide the ViewModel to the widget subtree.
      return BlocProvider<V>.value(
        value: viewModel,
        child: BlocConsumer<V, S>(
          listener: widget.onStateListener ?? (_, __) {},
          builder: (context, state) {
            // 🛡️ Error handling for the builder function.
            try {
              return widget.builder?.call(
                viewModel,
                context,
                state,
              ) ?? const SizedBox.shrink();
            } catch (e, stack) {
              FlutterError.reportError(FlutterErrorDetails(
                exception: e,
                stack: stack,
                library: 'base_view_bloc',
                context: ErrorDescription('while building BlocConsumer.builder'),
              ));
              return const SizedBox.shrink();
            }
          },
          buildWhen: widget.buildWhen,
        ),
      );
    } catch (e, stack) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        stack: stack,
        library: 'base_view_bloc',
        context: ErrorDescription('while building BaseView'),
      ));
      return const SizedBox.shrink();
    }
  }
}
