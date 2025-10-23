/// 📍 **OSMEA Location Picker Enums**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// Enums for the `OsmeaLocationPicker` component.

/// Defines the visual and functional variant of the location picker.
enum LocationPickerVariant {
  /// Shows only the search input field.
  input,

  /// Shows only the map view.
  map,

  /// Shows both the search input and a toggleable map view.
  combined,
}

/// Defines the visual style of the location picker's input field.
enum LocationPickerStyle {
  /// A filled style with a background color.
  filled,

  /// An outlined style with a visible border.
  outlined,
}

/// Defines the size of the location picker component.
enum LocationPickerSize {
  /// A small-sized location picker.
  small,

  /// A medium-sized location picker, the default.
  medium,

  /// A large-sized location picker.
  large,
}
