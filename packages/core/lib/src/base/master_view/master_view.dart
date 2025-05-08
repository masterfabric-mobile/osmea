import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // Import the async library for Timer

//TODO : MasterView for generic use views
/// A generic master view widget that serves as a base template for views in the application.
/// This widget provides a consistent structure and common functionality that can be
/// extended by specific view implementations.
///
/// Features:
/// - Scaffold with customizable app bar
/// - Safe area support
/// - Responsive layout support
/// - Common navigation patterns
///
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

// Enum representing different states of the MasterView
enum MasterViewState {
  loading, // Represents a loading state
  content, // Represents the content state
  error, // Represents an error state
  empty, // Represents an empty state (no data)
  unauthorized, // Represents an unauthorized access state
  timeout, // Represents a timeout state
  maintenance, // Represents a maintenance state
}

// Mixin to provide common functionality for MasterView
mixin MasterViewMixin on StatelessWidget {
  MasterViewState get currentState;

  // Method to build a loading indicator
  Widget buildLoading() {
    return Center(child: CircularProgressIndicator()); // Loading indicator
  }

  // Method to build an error message
  Widget buildError(String message) {
    return Center(child: Text('Error: $message')); // Error message
  }
}

// Abstract class representing the MasterView
abstract class MasterView extends StatelessWidget with MasterViewMixin {
  MasterView({super.key}) {
    // Global Flutter error handler
    FlutterError.onError = (FlutterErrorDetails details) {
      debugPrint('FlutterError: ${details.exception}');
      debugPrintStack(stackTrace: details.stack);
    };
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  MasterViewState get currentState; // Abstract getter for current state
  Widget viewContent(BuildContext context); // Abstract method for content

  @override
  Widget build(BuildContext context) {
    assert(currentState != null, 'currentState must not be null');
    debugPrint('MasterView build started. State: $currentState');

    // Show Snackbar for non-content states
    if (currentState != MasterViewState.content) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final snackBar = SnackBar(
          content: Text(_getSnackbarMessage(currentState)),
          duration: const Duration(days: 1), // Keep the Snackbar visible until dismissed
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              debugPrint('Snackbar Undo pressed');
              // Optional: Add your undo logic here
            },
          ),
        );
        try {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } catch (e, s) {
          debugPrint('Error showing snackbar: $e');
          debugPrintStack(stackTrace: s);
        }
      });
    }

    try {
      return _scaffold(context);
    } on Exception catch (e, s) {
      debugPrint('Exception in MasterView build: $e');
      debugPrintStack(stackTrace: s);
      return _buildErrorScaffold(context, 'Exception: $e');
    } catch (e, s) {
      debugPrint('Unknown error in MasterView build: $e');
      debugPrintStack(stackTrace: s);
      return _buildErrorScaffold(context, 'Unknown error: $e');
    }
  }

  Widget _scaffold(BuildContext context) {
    try {
      return Scaffold(
        key: _scaffoldMessengerKey,
        body: Builder(
          builder: (ctx) {
            try {
              return viewContent(ctx);
            } on Exception catch (e, s) {
              debugPrint('Exception in viewContent: $e');
              debugPrintStack(stackTrace: s);
              return buildError('Exception: $e');
            } catch (e, s) {
              debugPrint('Unknown error in viewContent: $e');
              debugPrintStack(stackTrace: s);
              return buildError('Unknown error: $e');
            }
          },
        ),
      );
    } on Exception catch (e, s) {
      debugPrint('Exception in _scaffold: $e');
      debugPrintStack(stackTrace: s);
      return _buildErrorScaffold(context, 'Exception: $e');
    } catch (e, s) {
      debugPrint('Unknown error in _scaffold: $e');
      debugPrintStack(stackTrace: s);
      return _buildErrorScaffold(context, 'Unknown error: $e');
    }
  }

  Widget _buildErrorScaffold(BuildContext context, String message) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      body: buildError(message),
    );
  }

  // Helper method to get Snackbar messages based on the state
  String _getSnackbarMessage(MasterViewState state) {
    switch (state) {
      case MasterViewState.loading:
        return 'Loading...';
      case MasterViewState.error:
        return 'An error occurred.';
      case MasterViewState.maintenance:
        return 'Maintenance mode.';
      case MasterViewState.empty:
        return 'No data available.';
      case MasterViewState.unauthorized:
        return 'Unauthorized access.';
      case MasterViewState.timeout:
        return 'Request timed out.';
      default:
        return ''; // Default case for safety
    }
  }
}

// Example implementation of MasterView
class SplashView extends MasterView {
  // Define the current state for this view
  MasterViewState get currentState => MasterViewState.empty;

  // Provide the content for this view
  @override
  Widget viewContent(BuildContext context) {
    return Center(child: Text('Splash Screen')); // Return a valid Widget
  }
}
