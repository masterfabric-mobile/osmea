library master_view; // Define a library name

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'master_view_enums.dart'; // Include the enums part
part 'master_view_mixins.dart'; // Include the mixins part

/// A generic master view widget that serves as a base template for views in the application.
/// This widget provides a consistent structure and common functionality that can be
/// extended by specific view implementations.
///
/// Features:
/// - Scaffold with customizable app bar
/// - Safe area support
/// - Responsive layout support
/// - Common navigation patterns
/// - Error handling
/// Usage:
/// ```dart
/// class MyCustomView extends MasterView {
///   @override
///   Widget viewContent(BuildContext context) {
///     return Center(
///       child: Text('My Custom Content'),
///     );
///   }
/// }
/// ```

// Abstract class representing the MasterView
abstract class MasterView<V extends BaseViewModelBloc<E, S>, E, S>
    extends StatelessWidget with MasterViewMixin {
  final Map<String, dynamic> arguments; // Arguments passed to the view
  final MasterViewTypes currentView; // Current view type for the master view
  final Function snackBarFunction; // Function to handle Snackbar actions
  final AppBar? appBar; // AppBar for the view

  MasterView({
    super.key,
    this.arguments = const {}, // Default to an empty map
    this.currentView = MasterViewTypes.content, // Default to content state
    this.snackBarFunction = defaultSnackBarFunction,
    this.appBar, // Default to a predefined function
  })  : assert(arguments != null,
            'Arguments must not be null'), // Ensure arguments is not null
        assert(arguments.isNotEmpty,
            'Arguments must not be empty'), // Ensure arguments is not empty
        assert(currentView != null,
            'Current view must not be null'), // Ensure currentView is not null
        assert(snackBarFunction != null, 'SnackBar function must not be null') {
    // Global Flutter error handler
    FlutterError.onError = (FlutterErrorDetails details) {
      debugPrint('FlutterError: ${details.exception}');
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
    assert(currentView != null, 'currentState must not be null');
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
      return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        key: _scaffoldMessengerKey,
        appBar: appBar, // Set the appBar of the scaffold 
        body: BaseView<V, E, S>(
          onViewModelReady: initialContent,
          builder: (viewModel, context, state) {
            return viewContent(
                context, viewModel, state); // Render the view content
          },
        ),
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
      appBar: appBar, // Set the appBar of the scaffold
      key: _scaffoldMessengerKey,
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
              s); // Log any errors that occur while showing the Snackbar
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
