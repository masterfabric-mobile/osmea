// Location Picker page is temporarily fully disabled (all content commented out).
// To restore the previous content, recover this file from git history.

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';
import '../widgets/common_appbar.dart';

class LocationPickerExample extends StatelessWidget {
  const LocationPickerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'location_picker_example',
      ),
      body: Center(
        child: OsmeaComponents.text(
          'Location Picker component is temporarily disabled.',
          variant: OsmeaTextVariant.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
