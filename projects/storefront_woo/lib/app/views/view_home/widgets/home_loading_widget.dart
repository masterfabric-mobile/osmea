/*
 * HomeLoadingWidget
 * -----------------
 * Loading state widget for home view.
 * Displays a loading indicator using OSMEA components.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Loading state widget for home view
class HomeLoadingWidget extends StatelessWidget {
  const HomeLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.center(
      child: OsmeaComponents.loading(
        type: LoadingType.circularFade,
        color: OsmeaColors.nordicBlue,
        size: context.iconSizeExtraHigh,
      ),
    );
  }
}

