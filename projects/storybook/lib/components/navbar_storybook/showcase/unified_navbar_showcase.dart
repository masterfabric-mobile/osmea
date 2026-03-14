import 'package:osmea_components/osmea_components.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

import 'navbar_showcase_widget.dart';

/// Unified Navbar Showcase - Modular Structure
/// 
/// Single story that shows all navbar variations in one place
/// All knobs control every navbar simultaneously for easy comparison

List<Story> getUnifiedNavbarShowcase() {
  return [
    Story(
      name: 'Navigation Bar',
      builder: (context) => NavbarShowcaseWidget(
        // Size Controls
        size: context.knobs.options(
          label: 'Size',
          initial: NavbarSize.medium,
          options: const [
            Option(label: 'Small', value: NavbarSize.small),
            Option(label: 'Medium', value: NavbarSize.medium),
            Option(label: 'Large', value: NavbarSize.large),
          ],
        ),
        
        // Variant Controls
        variant: context.knobs.options(
          label: 'Variant',
          initial: NavbarVariant.retailMain,
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
        ),
        
        // Visual Controls
        elevation: context.knobs.slider(
          label: 'Elevation',
          initial: 4.0,
          max: 20.0,
          min: 0.0,
        ),
        
        // Color Customization
        useCustomColors: context.knobs.boolean(
          label: 'Use Custom Colors',
          initial: false,
        ),
        customBackgroundColor: context.knobs.options(
          label: 'Background Color',
          initial: 'Default',
          options: const [
            Option(label: 'Default', value: 'Default'),
            Option(label: 'Blue', value: 'Blue'),
            Option(label: 'Green', value: 'Green'),
            Option(label: 'Red', value: 'Red'),
            Option(label: 'Purple', value: 'Purple'),
          ],
        ),
        customActiveColor: context.knobs.options(
          label: 'Active Color',
          initial: 'Default',
          options: const [
            Option(label: 'Default', value: 'Default'),
            Option(label: 'Orange', value: 'Orange'),
            Option(label: 'Teal', value: 'Teal'),
            Option(label: 'Pink', value: 'Pink'),
          ],
        ),
        
        // Border Radius
        borderRadius: context.knobs.slider(
          label: 'Border Radius',
          initial: 0.0,
          max: 25.0,
          min: 0.0,
        ),
        
        // Animation Duration
        animationSpeed: context.knobs.options(
          label: 'Animation Speed',
          initial: 'Normal',
          options: const [
            Option(label: 'Fast', value: 'Fast'),
            Option(label: 'Normal', value: 'Normal'),
            Option(label: 'Slow', value: 'Slow'),
          ],
        ),
        
        // Content Controls
        showLabels: context.knobs.boolean(
          label: 'Show Labels',
          initial: true,
        ),
        showIcons: context.knobs.boolean(
          label: 'Show Icons',
          initial: true,
        ),
        centerItems: context.knobs.boolean(
          label: 'Center Items',
          initial: true,
        ),
        scrollable: context.knobs.boolean(
          label: 'Scrollable',
          initial: false,
        ),
        
        // Item Configuration
        itemCount: context.knobs.slider(
          label: 'Item Count',
          initial: 4,
          min: 2,
          max: 6,
        ).round(),
        
        // Behavior Controls
        showBadges: context.knobs.boolean(
          label: 'Show Badges',
          initial: false,
        ),
        
        // Item States Demo
        showDifferentStates: context.knobs.boolean(
          label: 'Show Different Item States',
          initial: false,
        ),
        
        // Demo Controls
        showBackground: context.knobs.boolean(
          label: 'Show Background Content',
          initial: true,
        ),
        
        // Interactive Controls
        selectedIndex: context.knobs.slider(
          label: 'Selected Index',
          initial: 0,
          min: 0,
          max: 5,
        ).round(),
      ),
    ),
  ];
}
