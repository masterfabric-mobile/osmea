library master_view_hydrated_cubit;

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'master_view_hydrated_cubit_enums.dart';
part 'master_view_hydrated_cubit_mixins.dart';

/// Hydrated Cubit-based master view scaffold that wires a
/// `BaseViewHydratedCubit` into a consistent layout, complete with app bar,
/// spacing, snackbars, and route helpers. Extend this widget when building a
/// screen whose state comes from a `BaseViewModelHydratedCubit` so that the UI
/// automatically reacts to hydrated state changes.
///
/// Typical usage—after calling `MasterApp.runBefore(hydrated: true)` during app
/// boot—is to subclass `MasterViewHydratedCubit` and provide implementations for
/// `viewContent` and `initialContent`:
///
/// ```dart
/// class ProfileView extends MasterViewHydratedCubit<ProfileViewModel, ProfileState> {
///   ProfileView({required super.goRoute}) : super(arguments: {'userId': '123'});
///
///   @override
///   void initialContent(ProfileViewModel viewModel, BuildContext context) {
///     viewModel.loadProfile(arguments['userId'] as String);
///   }
///
///   @override
///   Widget viewContent(BuildContext context, ProfileViewModel viewModel, ProfileState state) {
///     if (currentView == MasterViewHydratedCubitTypes.loading) {
///       return buildLoading();
///     }
///     return ProfileBody(state: state, onRetry: viewModel.reload);
///   }
/// }
/// ```
abstract class MasterViewHydratedCubit<V extends BaseViewModelHydratedCubit<S>,
    S> extends StatelessWidget with MasterViewHydratedCubitMixin {
  final Map<String, dynamic> arguments;
  final MasterViewHydratedCubitTypes currentView;
  final Function snackBarFunction;
  final PreferredSizeWidget Function(BuildContext, V)? coreAppBar;
  final Widget? Function(BuildContext, V)? coreBottomBar;
  final bool showDevGrid;
  final Function(String path) goRoute;
  final bool? extendBody;
  final bool? extendBodyBehindAppBar;
  final Color? backgroundColor;

  // Layout configuration - external values
  final SpacerVisibility? navbarSpacer;
  final SpacerVisibility? footerSpacer;
  final PaddingVisibility? horizontalPadding;
  final PaddingVisibility? verticalPadding;
  final AppBarPaddingVisibility? appBarPadding;
  final bool? useSafeArea;

  // Spacer types - custom overrides default
  final CoreSpacerType? customNavbarSpacerType;
  final CoreSpacerType? customFooterSpacerType;
  final CoreSpacerType defaultNavbarSpacerType;
  final CoreSpacerType defaultFooterSpacerType;

  // Padding values - custom overrides default
  final double? customHorizontalPadding;
  final double defaultHorizontalPadding;
  final double? customVerticalPadding;
  final double defaultVerticalPadding;
  final double? customAppBarPadding;
  final double defaultAppBarPadding;

  final Widget? bottomNavigationBar;

  MasterViewHydratedCubit({
    super.key,
    this.arguments = const {},
    this.currentView = MasterViewHydratedCubitTypes.content,
    this.snackBarFunction = defaultSnackBarFunction,
    this.coreAppBar,
    this.coreBottomBar,
    this.showDevGrid = true,
    this.bottomNavigationBar,
    this.extendBody,
    this.extendBodyBehindAppBar,
    this.backgroundColor,
    this.navbarSpacer,
    this.footerSpacer,
    this.horizontalPadding,
    this.verticalPadding,
    this.appBarPadding,
    this.useSafeArea,
    this.customNavbarSpacerType,
    this.customFooterSpacerType,
    this.defaultNavbarSpacerType = CoreSpacerType.navbar,
    this.defaultFooterSpacerType = CoreSpacerType.footer,
    this.customHorizontalPadding,
    this.defaultHorizontalPadding = 16.0,
    this.customVerticalPadding,
    this.defaultVerticalPadding = 16.0,
    this.customAppBarPadding,
    this.defaultAppBarPadding = 16.0,
    required this.goRoute,
  }) : assert(arguments.isNotEmpty, 'Arguments must not be empty') {
    FlutterError.onError = (FlutterErrorDetails details) {
      debugPrint('FlutterError: ${details.exception}');
      debugPrintStack(stackTrace: details.stack);
    };
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final ValueNotifier<bool> _didCallInitial = ValueNotifier<bool>(false);

  /// Builds the primary body for the screen by consuming the latest hydrated
  /// state. Use the provided `viewModel` to dispatch actions or read helper
  /// methods.
  Widget viewContent(BuildContext context, V viewModel, S state);

  /// Runs once after the widget is mounted and the internal scaffold has a
  /// context. Ideal spot to trigger initial data loads based on `arguments` or
  /// perform one-off side effects.
  void initialContent(V viewModel, BuildContext context);

  @override
  Widget build(BuildContext context) {
    debugPrint('MasterViewHydratedCubit build. -> View Type: $currentView');

    if (currentView != MasterViewHydratedCubitTypes.content) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          final snackBar = _createSnackBar(currentView);
          _showSnackBar(context, snackBar);
        } catch (e) {
          debugPrint('Error creating or showing Snackbar: $e');
        }
      });
    }

    try {
      return _scaffold(context);
    } on Exception catch (e, s) {
      debugPrint('Exception in MasterViewHydratedCubit build: $e');
      debugPrintStack(stackTrace: s);
      return _buildErrorScaffold(context, 'Exception: $e');
    } catch (e, s) {
      debugPrint('Unknown error in MasterViewHydratedCubit build: $e');
      debugPrintStack(stackTrace: s);
      return _buildErrorScaffold(context, 'Unknown error: $e');
    }
  }

  /// Creates the underlying `BaseViewHydratedCubit` scaffold, handling snackbars
  /// and error resilience.
  Widget _scaffold(BuildContext context) {
    return _handleScaffoldErrors(() {
      return BaseViewHydratedCubit<V, S>(
        onViewModelReady: (viewModel) {
          if (!_didCallInitial.value) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_didCallInitial.value) {
                try {
                  final ctx = _scaffoldMessengerKey.currentContext;
                  if (ctx != null) {
                    initialContent(viewModel, ctx);
                  }
                } catch (e, s) {
                  debugPrint('initialContent error: $e');
                  debugPrintStack(stackTrace: s);
                } finally {
                  _didCallInitial.value = true;
                }
              }
            });
          }
        },
        builder: (viewModel, context, state) {
          return MasterScaffoldWidget(
            scaffoldMessengerKey: _scaffoldMessengerKey,
            appBar: coreAppBar?.call(context, viewModel),
            body: viewContent(context, viewModel, state),
            bottomNavigationBar: coreBottomBar != null
                ? coreBottomBar!.call(context, viewModel)
                : bottomNavigationBar,
            extendBody: extendBody,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
            backgroundColor: backgroundColor,
            navbarSpacer: navbarSpacer,
            footerSpacer: footerSpacer,
            horizontalPadding: horizontalPadding,
            verticalPadding: verticalPadding,
            appBarPadding: appBarPadding,
            useSafeArea: useSafeArea,
            customNavbarSpacerType: customNavbarSpacerType,
            customFooterSpacerType: customFooterSpacerType,
            defaultNavbarSpacerType: defaultNavbarSpacerType,
            defaultFooterSpacerType: defaultFooterSpacerType,
            customHorizontalPadding: customHorizontalPadding,
            defaultHorizontalPadding: defaultHorizontalPadding,
            customVerticalPadding: customVerticalPadding,
            defaultVerticalPadding: defaultVerticalPadding,
            customAppBarPadding: customAppBarPadding,
            defaultAppBarPadding: defaultAppBarPadding,
          );
        },
      );
    }, context);
  }

  /// Wraps scaffold construction to surface unexpected errors in a fallback UI
  /// instead of crashing the app tree.
  Widget _handleScaffoldErrors(
      Function() scaffoldBuilder, BuildContext context) {
    try {
      return scaffoldBuilder();
    } catch (e, s) {
      debugPrint('Error in scaffold: $e');
      debugPrintStack(stackTrace: s);
      return _buildErrorScaffold(context, 'Error: $e');
    }
  }

  /// Builds a minimal scaffold displaying the provided error message. Used when
  /// an exception occurs before the normal layout can render.
  Widget _buildErrorScaffold(BuildContext context, String message) {
    return _createScaffold(
      body: buildError(message),
    );
  }

  /// Convenience method to create the fallback scaffold without duplicating
  /// boilerplate properties.
  Widget _createScaffold({required Widget body}) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      backgroundColor: OsmeaColors.white,
      body: body,
    );
  }

  String _getSnackbarMessage(MasterViewHydratedCubitTypes state) {
    final message = _getMessageForState(state);
    return message.isNotEmpty
        ? message
        : 'An unexpected error occurred. Please try again later.';
  }

  String _getMessageForState(MasterViewHydratedCubitTypes state) {
    switch (state) {
      case MasterViewHydratedCubitTypes.loading:
        return resources.loading;
      case MasterViewHydratedCubitTypes.webview:
        return resources.webview;
      case MasterViewHydratedCubitTypes.error:
        return resources.error;
      case MasterViewHydratedCubitTypes.maintenance:
        return resources.maintenance;
      case MasterViewHydratedCubitTypes.empty:
        return resources.empty;
      case MasterViewHydratedCubitTypes.unauthorized:
        return resources.unauthorized;
      case MasterViewHydratedCubitTypes.timeout:
        return resources.timeout;
      default:
        return '';
    }
  }

  /// Generates a snackbar based on the current view type. The snackbar stays
  /// visible until dismissed, giving product teams control over messaging for
  /// non-content states.
  SnackBar _createSnackBar(MasterViewHydratedCubitTypes viewType) {
    final message = _getSnackbarMessage(viewType);
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      duration: const Duration(days: 1),
      action: SnackBarAction(
        label: resources.undo,
        onPressed: () {
          debugPrint('Snackbar Undo pressed');
          snackBarFunction();
        },
      ),
    );
  }

  /// Safely shows the snackbar, swallowing errors that can occur when the
  /// messenger has not yet been mounted.
  void _showSnackBar(BuildContext context, SnackBar snackBar) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e, s) {
      debugPrint('Error showing snackbar: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  /// Default fallback for snackbar actions when none is provided.
  static void defaultSnackBarFunction() {
    debugPrint('Default Snackbar function called');
  }

  /// Navigates to a route managed by `GoRouter` without passing extra data.
  void navigateTo(BuildContext context, String path) {
    GoRouter.of(context).go(path);
  }

  /// Navigates to a route while attaching `arguments` to the `extra` payload so
  /// downstream screens can retrieve the hydrated context.
  void navigateToWithArguments(
      BuildContext context, String path, Map<String, dynamic> arguments) {
    GoRouter.of(context).go(path, extra: arguments);
  }
}
