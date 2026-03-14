import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:osmea_components/osmea_components.dart';

/// Configuration utility for Storybook knobs used in navbar showcases
/// 
/// This utility provides standardized knob configurations that can be reused
/// across different navbar showcases, ensuring consistency in controls.

class NavbarKnobsConfig {
  /// Creates the standard variant knob
  static NavbarVariant variantKnob(KnobsBuilder knobs, {
    NavbarVariant initial = NavbarVariant.retailMain,
    String label = '🎯 Navbar Variant',
  }) {
    return knobs.options(
      label: label,
      initial: initial,
      options: const [
        Option(label: 'Retail Main', value: NavbarVariant.retailMain),
        Option(label: 'Dotted Outline', value: NavbarVariant.dottedOutline),
        Option(label: 'Healthcare Minimal', value: NavbarVariant.healthcareMinimal),
        Option(label: 'Media Overlay', value: NavbarVariant.mediaOverlay),
        Option(label: 'Social Glass', value: NavbarVariant.socialGlass),
        Option(label: 'Minimal', value: NavbarVariant.minimal),
        Option(label: 'Pill Shaped', value: NavbarVariant.pillShaped),
        Option(label: 'Glassy Blur', value: NavbarVariant.glassyBlur),
      ],
    );
  }

  /// Creates the standard size knob
  static NavbarSize sizeKnob(KnobsBuilder knobs, {
    NavbarSize initial = NavbarSize.medium,
    String label = '📏 Size',
  }) {
    return knobs.options(
      label: label,
      initial: initial,
      options: const [
        Option(label: 'Small', value: NavbarSize.small),
        Option(label: 'Medium', value: NavbarSize.medium),
        Option(label: 'Large', value: NavbarSize.large),
      ],
    );
  }

  /// Creates the standard position knob
  static NavbarPosition positionKnob(KnobsBuilder knobs, {
    NavbarPosition initial = NavbarPosition.bottom,
    String label = '📍 Position',
  }) {
    return knobs.options(
      label: label,
      initial: initial,
      options: const [
        Option(label: 'Top', value: NavbarPosition.top),
        Option(label: 'Bottom', value: NavbarPosition.bottom),
      ],
    );
  }

  /// Creates the elevation slider knob
  static double elevationKnob(KnobsBuilder knobs, {
    double initial = 4.0,
    double min = 0.0,
    double max = 20.0,
    String label = '🏔️ Elevation',
  }) {
    return knobs.slider(
      label: label,
      initial: initial,
      min: min,
      max: max,
    );
  }

  /// Creates the border radius slider knob
  static double borderRadiusKnob(KnobsBuilder knobs, {
    double initial = 0.0,
    double min = 0.0,
    double max = 25.0,
    String label = '🔲 Border Radius',
  }) {
    return knobs.slider(
      label: label,
      initial: initial,
      min: min,
      max: max,
    );
  }

  /// Creates the item count slider knob
  static int itemCountKnob(KnobsBuilder knobs, {
    int initial = 4,
    int min = 2,
    int max = 6,
    String label = '🔢 Item Count',
  }) {
    return knobs.slider(
      label: label,
      initial: initial.toDouble(),
      min: min.toDouble(),
      max: max.toDouble(),
    ).round();
  }

  /// Creates the selected index slider knob
  static int selectedIndexKnob(KnobsBuilder knobs, {
    int initial = 0,
    int min = 0,
    int max = 5,
    String label = '👆 Selected Index',
  }) {
    return knobs.slider(
      label: label,
      initial: initial.toDouble(),
      min: min.toDouble(),
      max: max.toDouble(),
    ).round();
  }

  /// Creates boolean knobs for navbar features
  static bool showLabelsKnob(KnobsBuilder knobs, {
    bool initial = true,
    String label = '🏷️ Show Labels',
  }) {
    return knobs.boolean(label: label, initial: initial);
  }

  static bool showIconsKnob(KnobsBuilder knobs, {
    bool initial = true,
    String label = '🎭 Show Icons',
  }) {
    return knobs.boolean(label: label, initial: initial);
  }

  static bool centerItemsKnob(KnobsBuilder knobs, {
    bool initial = true,
    String label = '📍 Center Items',
  }) {
    return knobs.boolean(label: label, initial: initial);
  }

  static bool scrollableKnob(KnobsBuilder knobs, {
    bool initial = false,
    String label = '📜 Scrollable',
  }) {
    return knobs.boolean(label: label, initial: initial);
  }

  static bool showBadgesKnob(KnobsBuilder knobs, {
    bool initial = false,
    String label = '🔴 Show Badges',
  }) {
    return knobs.boolean(label: label, initial: initial);
  }

  static bool showDifferentStatesKnob(KnobsBuilder knobs, {
    bool initial = false,
    String label = '🎭 Show Different States',
  }) {
    return knobs.boolean(label: label, initial: initial);
  }

  static bool showBackgroundKnob(KnobsBuilder knobs, {
    bool initial = true,
    String label = '🖼️ Show Background Content',
  }) {
    return knobs.boolean(label: label, initial: initial);
  }

  static bool useCustomColorsKnob(KnobsBuilder knobs, {
    bool initial = false,
    String label = '🎨 Use Custom Colors',
  }) {
    return knobs.boolean(label: label, initial: initial);
  }

  /// Creates the custom background color knob
  static String customBackgroundColorKnob(KnobsBuilder knobs, {
    String initial = 'Default',
    String label = '🎨 Background Color',
  }) {
    return knobs.options(
      label: label,
      initial: initial,
      options: const [
        Option(label: 'Default', value: 'Default'),
        Option(label: 'Blue', value: 'Blue'),
        Option(label: 'Green', value: 'Green'),
        Option(label: 'Red', value: 'Red'),
        Option(label: 'Purple', value: 'Purple'),
      ],
    );
  }

  /// Creates the custom active color knob
  static String customActiveColorKnob(KnobsBuilder knobs, {
    String initial = 'Default',
    String label = '✨ Active Color',
  }) {
    return knobs.options(
      label: label,
      initial: initial,
      options: const [
        Option(label: 'Default', value: 'Default'),
        Option(label: 'Orange', value: 'Orange'),
        Option(label: 'Teal', value: 'Teal'),
        Option(label: 'Pink', value: 'Pink'),
      ],
    );
  }

  /// Creates the animation speed knob
  static String animationSpeedKnob(KnobsBuilder knobs, {
    String initial = 'Normal',
    String label = '⚡ Animation Speed',
  }) {
    return knobs.options(
      label: label,
      initial: initial,
      options: const [
        Option(label: 'Fast', value: 'Fast'),
        Option(label: 'Normal', value: 'Normal'),
        Option(label: 'Slow', value: 'Slow'),
      ],
    );
  }

  /// Creates a complete knobs configuration for the unified showcase
  static Map<String, dynamic> createUnifiedShowcaseKnobs(KnobsBuilder knobs) {
    return {
      'size': sizeKnob(knobs),
      'variant': variantKnob(knobs),
      'elevation': elevationKnob(knobs),
      'useCustomColors': useCustomColorsKnob(knobs),
      'customBackgroundColor': customBackgroundColorKnob(knobs),
      'customActiveColor': customActiveColorKnob(knobs),
      'borderRadius': borderRadiusKnob(knobs),
      'animationSpeed': animationSpeedKnob(knobs),
      'showLabels': showLabelsKnob(knobs),
      'showIcons': showIconsKnob(knobs),
      'centerItems': centerItemsKnob(knobs),
      'scrollable': scrollableKnob(knobs),
      'itemCount': itemCountKnob(knobs),
      'showBadges': showBadgesKnob(knobs),
      'showDifferentStates': showDifferentStatesKnob(knobs),
      'showBackground': showBackgroundKnob(knobs),
      'selectedIndex': selectedIndexKnob(knobs),
    };
  }
}
