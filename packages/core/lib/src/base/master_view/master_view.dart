import 'package:core/src/resources/resources.g.dart';
import 'package:flutter/material.dart';

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
///   Widget buildContent(BuildContext context) {
///     return Center(
///       child: Text('My Custom Content'),
///     );
///   }
/// }
/// ```

class MasterView extends StatelessWidget {
  const MasterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Center(child: Text(resources.appTitle)),  
        ],
      ),
    );
  }
}
