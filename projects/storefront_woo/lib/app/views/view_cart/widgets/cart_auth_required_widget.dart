import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Widget shown when authentication is required for cart operations
class CartAuthRequiredWidget extends StatelessWidget {
  final String message;

  const CartAuthRequiredWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Center(
          child: CircularProgressIndicator(color: OsmeaColors.nordicBlue),
        ),
      ),
    );
  }
}





