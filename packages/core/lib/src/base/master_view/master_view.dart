library master_view; // Define a library name

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'master_view_enums.dart'; // Include the enums part
part 'master_view_mixins.dart'; // Include the mixins part

/// MasterView (BLoC-based) — reusable screen scaffold for feature views.
///
/// Purpose
/// - Provide consistent skeleton (app bar, safe area, paddings, footer/navbar spacers)
/// - Host `BaseView<V,E,S>` lifecycle and state listening
/// - Centralize error handling and default snackbars for high-level states
///
/// Extend points
/// - `viewContent(context, viewModel, state)`: render your feature UI
/// - `initialContent(viewModel, context)`: fire first effects (e.g., dispatch init event)
/// - `coreAppBar/coreBottomBar/bottomNavigationBar`: customize chrome
///
/// Example
/// ```dart
/// class ProductsView extends MasterView<MyBloc, MyEvent, MyState> {
///   ProductsView({super.key}) : super(currentView: MasterViewTypes.content);
///
///   @override
///   void initialContent(MyBloc vm, BuildContext context) {
///     vm.add(LoadProducts());
///   }
///
///   @override
///   Widget viewContent(BuildContext context, MyBloc vm, MyState state) {
///     if (state is Loading) return buildLoading();
///     if (state is Failure) return buildError(state.message);
///     return ProductsList(items: state.items);
///   }
/// }
/// ```

// Abstract class representing the MasterView
abstract class MasterView<V extends BaseViewModelBloc<E, S>, E, S>
    extends StatelessWidget with MasterViewMixin {
  final Map<String, dynamic> arguments; // Arguments passed to the view
  final MasterViewTypes currentView; // Current view type for the master view
  final Function snackBarFunction; // Function to handle Snackbar actions
  final PreferredSizeWidget Function(BuildContext, V)? coreAppBar;
  final Widget? Function(BuildContext, V)? coreBottomBar;
  final bool showDevGrid;
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

  // System UI color management

  /// Optional bottom navigation bar widget for the Scaffold.
  final Widget? bottomNavigationBar;

  MasterView({
    super.key,
    this.arguments = const {}, // Default to an empty map
    this.currentView = MasterViewTypes.content, // Default to content state
    this.snackBarFunction = defaultSnackBarFunction,
    this.coreAppBar, // Default to a predefined function
    this.coreBottomBar, // New: function to build bottom bar
    this.showDevGrid = true,
    this.bottomNavigationBar, // Optional bottom navigation bar
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
  }) : assert(arguments.isNotEmpty, 'Arguments must not be empty') {
    // Global Flutter error handler
    FlutterError.onError = (FlutterErrorDetails details) {
      debugPrintStack(stackTrace: details.stack);
    };
  }

  // Declare the GlobalKey after the constructor
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // Abstract method for content that must be implemented by subclasses
  Widget viewContent(BuildContext context, V viewModel, S state);
  void initialContent(V viewModel, BuildContext context);

  @override
  Widget build(BuildContext context) {
    debugPrint('MasterView build started. -> View Type: $currentView');

    // Show Snackbar for non-content states
    if (currentView != MasterViewTypes.content) {
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
      return _scaffold(context); // Build the scaffold for the view
    } on Exception catch (e, s) {
      debugPrint('Exception in MasterView build: $e');
      debugPrintStack(stackTrace: s);
      return _buildErrorScaffold(context, 'Exception: $e'); // Handle exceptions
    } catch (e, s) {
      debugPrint('Unknown error in MasterView build: $e');
      debugPrintStack(stackTrace: s);
      return _buildErrorScaffold(
          context, 'Unknown error: $e'); // Handle unknown errors
    }
  }

  /// Builds the main scaffold for the view, including the body content.
  Widget _scaffold(BuildContext context) {
    return _handleScaffoldErrors(() {
      return BaseView<V, E, S>(
        onViewModelReady: initialContent,
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

  /// Handles errors that may occur during scaffold building.
  Widget _handleScaffoldErrors(
      Function() scaffoldBuilder, BuildContext context) {
    try {
      return scaffoldBuilder(); // Attempt to build the scaffold
    } catch (e, s) {
      debugPrint('Error in scaffold: $e');
      debugPrintStack(stackTrace: s);
      return _buildErrorScaffold(
          context, 'Error: $e'); // Return an error scaffold on failure
    }
  }

  /// Builds an error scaffold to display when an error occurs.
  Widget _buildErrorScaffold(BuildContext context, String message) {
    return _createScaffold(
      body: buildError(message), // Display the error message
    );
  }

  /// Creates a scaffold with the specified body content.
  Widget _createScaffold({required Widget body}) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      backgroundColor: OsmeaColors.white,
      body: body, // Set the body of the scaffold
    );
  }

  /// Helper method to get Snackbar messages based on the state.
  String _getSnackbarMessage(MasterViewTypes state) {
    final message =
        _getMessageForState(state); // Get the message for the current state
    return message.isNotEmpty
        ? message
        : 'An unexpected error occurred. Please try again later.'; // Fallback to a default message
  }

  /// Retrieves the message corresponding to the given state.
  String _getMessageForState(MasterViewTypes state) {
    switch (state) {
      case MasterViewTypes.loading:
        return resources.loading; // Message for loading state
      case MasterViewTypes.webview:
        return resources.webview; // Message for webview state
      case MasterViewTypes.error:
        return resources.error; // Message for error state
      case MasterViewTypes.maintenance:
        return resources.maintenance; // Message for maintenance state
      case MasterViewTypes.empty:
        return resources.empty; // Message for empty state
      case MasterViewTypes.unauthorized:
        return resources.unauthorized; // Message for unauthorized state
      case MasterViewTypes.timeout:
        return resources.timeout; // Message for timeout state
      default:
        return ''; // Return an empty string for unhandled states
    }
  }

  /// Method to create a Snackbar based on the current view.
  SnackBar _createSnackBar(MasterViewTypes viewType) {
    final message =
        _getSnackbarMessage(viewType); // Get the message for the Snackbar
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message), // Set the content of the Snackbar
      duration:
          const Duration(days: 1), // Keep the Snackbar visible until dismissed
      action: SnackBarAction(
        label: resources.undo, // Label for the Snackbar action
        onPressed: () {
          debugPrint('Snackbar Undo pressed');
          snackBarFunction(); // Execute the Snackbar action
          // Optional: Add your undo logic here
        },
      ),
    );
  }

  /// Method to show the Snackbar and handle errors.
  void _showSnackBar(BuildContext context, SnackBar snackBar) {
    try {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar); // Display the Snackbar
    } catch (e, s) {
      debugPrint('Error showing snackbar: $e');
      debugPrintStack(
          stackTrace:
              s); // Log any errors that occur while showing the SnackBar
    }
  }

  /// Define a default function for the snackBarFunction.
  static void defaultSnackBarFunction() {
    // Default behavior for the snackbar function
    debugPrint('Default Snackbar function called');
  }

  // Method to navigate to a new route
  void navigateTo(BuildContext context, String path) {
    GoRouter.of(context).go(path); // Use GoRouter to navigate
  }

  // Method to navigate to a new route with arguments
  void navigateToWithArguments(
      BuildContext context, String path, Map<String, dynamic> arguments) {
    GoRouter.of(context)
        .go(path, extra: arguments); // Use GoRouter to navigate with arguments
  }
}

/// Footer area widget that only allows a CoreSpacer of type footer.
class FooterArea extends StatelessWidget {
  const FooterArea({super.key});

  @override
  Widget build(BuildContext context) {
    return const CoreSpacer(CoreSpacerType.footer);
  }
}

/// Navbar area widget that only allows a CoreSpacer of type navbar.
class NavbarArea extends StatelessWidget {
  const NavbarArea({super.key});

  @override
  Widget build(BuildContext context) {
    return const CoreSpacer(CoreSpacerType.navbar);
  }
}
