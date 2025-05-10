part of master_view; // Indicate that this file is part of the master_view library

// Mixin to provide common functionality for MasterView
mixin MasterViewMixin on StatelessWidget {
  MasterViewTypes get currentView;

  // Method to build a loading indicator with customizable properties
  Widget buildLoading({Color color = Colors.blue, double size = 50.0}) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(color),
        strokeWidth: size,
      ),
    );
  }

  // Method to build an error message with an optional retry button
  Widget buildError(String message, {VoidCallback? onRetry}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $message'), // Display the error message
          if (onRetry != null) // Show retry button if provided
            ElevatedButton(
              onPressed: onRetry,
              child: Text('Retry'),
            ),
        ],
      ),
    );
  }
}
