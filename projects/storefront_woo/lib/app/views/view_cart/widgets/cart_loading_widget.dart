/*
 * Cart Loading Widget
 * -------------------
 * Loading widget for cart view.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Loading widget for cart view
class CartLoadingWidget extends StatelessWidget {
  const CartLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.center(
      child: OsmeaComponents.loading(
        type: LoadingType.circularFade,
        size: context.iconSizeLarge,
        color: OsmeaColors.black,
      ),
    );
  }
}

