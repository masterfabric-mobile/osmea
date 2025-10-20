library master_view_cubit;

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:core/src/base/widgets/master_scaffold_widget.dart';
import 'package:go_router/go_router.dart';

part 'master_view_cubit_enums.dart';
part 'master_view_cubit_mixins.dart';

/// Cubit-based Master View
abstract class MasterViewCubit<V extends BaseViewModelCubit<S>, S>
    extends StatelessWidget with MasterViewCubitMixin {
  final Map<String, dynamic> arguments;
  final MasterViewCubitTypes currentView;
  final Function snackBarFunction;
  final PreferredSizeWidget Function(BuildContext, V)? coreAppBar;
  final Widget? Function(BuildContext, V)? coreBottomBar;
  final bool showDevGrid;
  final Function(String path) goRoute;
  final bool? extendBody;
  final bool? extendBodyBehindAppBar;

  // Layout configuration - external values
  final SpacerVisibility? navbarSpacer;
  final SpacerVisibility? footerSpacer;
  final PaddingVisibility? horizontalPadding;
  final bool? useSafeArea;

  // Spacer types - custom overrides default
  final CoreSpacerType? customNavbarSpacerType;
  final CoreSpacerType? customFooterSpacerType;
  final CoreSpacerType defaultNavbarSpacerType;
  final CoreSpacerType defaultFooterSpacerType;

  // Padding values - custom overrides default
  final double? customHorizontalPadding;
  final double defaultHorizontalPadding;

  /// Optional bottom navigation bar widget for the Scaffold.
  final Widget? bottomNavigationBar;

  MasterViewCubit({
    super.key,
    this.arguments = const {},
    this.currentView = MasterViewCubitTypes.content,
    this.snackBarFunction = defaultSnackBarFunction,
    this.coreAppBar,
    this.coreBottomBar,
    this.showDevGrid = true,
    this.bottomNavigationBar,
    this.extendBody,
    this.extendBodyBehindAppBar,
    this.navbarSpacer,
    this.footerSpacer,
    this.horizontalPadding,
    this.useSafeArea,
    this.customNavbarSpacerType,
    this.customFooterSpacerType,
    this.defaultNavbarSpacerType = CoreSpacerType.navbar,
    this.defaultFooterSpacerType = CoreSpacerType.footer,
    this.customHorizontalPadding,
    this.defaultHorizontalPadding = 16.0,
    required this.goRoute,
  }) : assert(arguments.isNotEmpty, 'Arguments must not be empty') {
    FlutterError.onError = (FlutterErrorDetails details) {
      debugPrint('FlutterError: ${details.exception}');
      debugPrintStack(stackTrace: details.stack);
    };
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // Ensures initialContent is called only once per widget instance
  final ValueNotifier<bool> _didCallInitial = ValueNotifier<bool>(false);

  /// UI content
  Widget viewContent(BuildContext context, V viewModel, S state);

  /// Called when ViewModel is ready with a BuildContext
  void initialContent(V viewModel, BuildContext context);

  @override
  Widget build(BuildContext context) {
    debugPrint('🔍 [MasterViewCubit] build() called');

    if (currentView != MasterViewCubitTypes.content) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          final snackBar = _createSnackBar(currentView);
          _showSnackBar(context, snackBar);
        } catch (e) {
          debugPrint('🔴 [MasterViewCubit] Error creating or showing Snackbar: $e');
        }
      });
    }

    try {
      return _scaffold(context);
    } on Exception catch (e, s) {
      debugPrint('🔴 [MasterViewCubit] Exception in build: $e');
      debugPrintStack(stackTrace: s);
      return _buildErrorScaffold(context, 'Exception: $e');
    } catch (e, s) {
      debugPrint('🔴 [MasterViewCubit] Unknown error in build: $e');
      debugPrintStack(stackTrace: s);
      return _buildErrorScaffold(context, 'Unknown error: $e');
    }
  }

  Widget _scaffold(BuildContext context) {
    return _handleScaffoldErrors(() {
      return BaseViewCubit<V, S>(
        onViewModelReady: (viewModel) {
          // Defer until after first frame to ensure we have a valid BuildContext
          if (!_didCallInitial.value) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_didCallInitial.value) {
                try {
                  // Use the closest available context from the builder phase
                  final ctx = _scaffoldMessengerKey.currentContext;
                  if (ctx != null) {
                    initialContent(viewModel, ctx);
                  }
                } catch (e, s) {
                  debugPrint('🔴 [MasterViewCubit] initialContent error: $e');
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
            navbarSpacer: navbarSpacer,
            footerSpacer: footerSpacer,
            horizontalPadding: horizontalPadding,
            useSafeArea: useSafeArea,
            customNavbarSpacerType: customNavbarSpacerType,
            customFooterSpacerType: customFooterSpacerType,
            defaultNavbarSpacerType: defaultNavbarSpacerType,
            defaultFooterSpacerType: defaultFooterSpacerType,
            customHorizontalPadding: customHorizontalPadding,
            defaultHorizontalPadding: defaultHorizontalPadding,
          );
        },
      );
    }, context);
  }

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

  Widget _buildErrorScaffold(BuildContext context, String message) {
    return _createScaffold(
      body: buildError(message),
    );
  }

  Widget _createScaffold({required Widget body}) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      backgroundColor: OsmeaColors.white,
      body: body,
    );
  }

  String _getSnackbarMessage(MasterViewCubitTypes state) {
    final message = _getMessageForState(state);
    return message.isNotEmpty
        ? message
        : 'An unexpected error occurred. Please try again later.';
  }

  String _getMessageForState(MasterViewCubitTypes state) {
    switch (state) {
      case MasterViewCubitTypes.loading:
        return resources.loading;
      case MasterViewCubitTypes.webview:
        return resources.webview;
      case MasterViewCubitTypes.error:
        return resources.error;
      case MasterViewCubitTypes.maintenance:
        return resources.maintenance;
      case MasterViewCubitTypes.empty:
        return resources.empty;
      case MasterViewCubitTypes.unauthorized:
        return resources.unauthorized;
      case MasterViewCubitTypes.timeout:
        return resources.timeout;
      default:
        return '';
    }
  }

  SnackBar _createSnackBar(MasterViewCubitTypes viewType) {
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

  void _showSnackBar(BuildContext context, SnackBar snackBar) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e, s) {
      debugPrint('Error showing snackbar: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  static void defaultSnackBarFunction() {
    debugPrint('Default Snackbar function called');
  }

  void navigateTo(BuildContext context, String path) {
    GoRouter.of(context).go(path);
  }

  void navigateToWithArguments(
      BuildContext context, String path, Map<String, dynamic> arguments) {
    GoRouter.of(context).go(path, extra: arguments);
  }
}
