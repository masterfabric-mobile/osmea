import 'package:flutter/material.dart';
import 'package:osmea_components/src/enums/location_picker_enums.dart';
import 'package:osmea_components/src/utils/sizer_extensions.dart';

/// Configuration class for `OsmeaLocationPicker` sizes.
class LocationPickerSizeConfig {
  final double height;
  final double iconSize;
  final TextStyle textStyle;
  final EdgeInsets padding;

  const LocationPickerSizeConfig({
    required this.height,
    required this.iconSize,
    required this.textStyle,
    required this.padding,
  });
}

/// Extension on `LocationPickerSize` to provide size-specific configurations.
extension LocationPickerSizeExtension on LocationPickerSize {
  LocationPickerSizeConfig getConfig(BuildContext context) {
    switch (this) {
      case LocationPickerSize.small:
        return LocationPickerSizeConfig(
          height: 36.0,
          iconSize: 16.0,
          textStyle: Theme.of(context).textTheme.bodySmall!,
          padding: EdgeInsets.symmetric(horizontal: context.spacing8, vertical: context.spacing4),
        );
      case LocationPickerSize.medium:
        return LocationPickerSizeConfig(
          height: 44.0,
          iconSize: 20.0,
          textStyle: Theme.of(context).textTheme.bodyMedium!,
          padding: EdgeInsets.symmetric(horizontal: context.spacing12, vertical: context.spacing8),
        );
      case LocationPickerSize.large:
        return LocationPickerSizeConfig(
          height: 52.0,
          iconSize: 24.0,
          textStyle: Theme.of(context).textTheme.bodyLarge!,
          padding: EdgeInsets.symmetric(horizontal: context.spacing16, vertical: context.spacing12),
        );
    }
  }
}
