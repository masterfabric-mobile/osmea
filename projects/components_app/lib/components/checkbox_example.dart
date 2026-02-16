import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// ☑️ **OSMEA Checkbox Examples**
///
/// Comprehensive examples demonstrating all variants, sizes, and features
/// of the OSMEA Checkbox component library.
///
/// This file showcases:
/// * 🎨 All checkbox variants (simple, labeled, card, tile, compact, extended)
/// * 📏 All size options (small, medium, large)
/// * 🎭 All visual styles (material, cupertino, modern, glassmorphism, minimal)
/// * 🔄 All interactive states (enabled, disabled, focused, hovered)
/// * 🔀 Tristate support (checked, unchecked, indeterminate)
/// * 🏷️ Label and description examples
/// * 🎨 Custom color examples
/// * ⚙️ Custom styling options

class CheckboxExample extends StatefulWidget {
  const CheckboxExample({super.key});

  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  // State variables for different checkbox variants
  bool? _simpleCheckbox = false;
  bool? _labeledCheckbox = true;
  bool? _cardCheckbox1 = false;
  bool? _cardCheckbox2 = true;
  bool? _tileCheckbox1 = false;
  bool? _tileCheckbox2 = true;

  // State variables for different sizes
  bool? _smallCheckbox = true;
  bool? _mediumCheckbox = false;
  bool? _largeCheckbox = true;

  // State variables for different styles
  bool? _materialStyle = true;
  bool? _cupertinoStyle = false;
  bool? _modernStyle = true;
  bool? _glassmorphismStyle = true;
  bool? _minimalStyle = false;

  // State variables for tristate examples
  bool? _tristateCheckbox1; // Indeterminate
  bool? _tristateCheckbox2 = true;
  bool? _tristateCheckbox3 = false;

  // State variables for settings example
  bool? _notificationsEnabled = true;
  bool? _locationEnabled = false;
  bool? _cameraEnabled = true;
  bool? _microphoneEnabled = false;
  bool? _analyticsEnabled; // Indeterminate

  // State variables for custom colors
  bool? _redCheckbox = false;
  bool? _greenCheckbox = true;
  bool? _purpleCheckbox = false;
  bool? _orangeCheckbox = true;

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'checkbox_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('🎨 Checkbox Variants'),
            _buildVariantsSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('📏 Checkbox Sizes'),
            _buildSizesSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🔀 Tristate Checkboxes'),
            _buildTristateSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('⚙️ Settings'),
            _buildSettingsSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🔄 State'),
            _buildStateSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🎭 Checkbox Styles'),
            _buildStylesSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🎨 Custom Colors'),
            _buildCustomColorsSection(),
            OsmeaComponents.sizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return OsmeaComponents.padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: OsmeaComponents.text(
        title,
        variant: OsmeaTextVariant.headlineSmall,
      ),
    );
  }

  Widget _buildVariantsSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Simple Checkbox (No Labels)'),
        OsmeaComponents.row(
          children: [
            OsmeaComponents.checkbox(
              value: _simpleCheckbox,
              variant: CheckboxVariant.simple,
              onChanged: (value) => setState(() => _simpleCheckbox = value),
            ),
            OsmeaComponents.sizedBox(width: 16),
            OsmeaComponents.checkbox(
              value: true,
              variant: CheckboxVariant.simple,
              onChanged: (value) {},
            ),
            OsmeaComponents.sizedBox(width: 16),
            OsmeaComponents.checkbox(
              value: false,
              variant: CheckboxVariant.simple,
              onChanged: (value) {},
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 20),
        _buildSubsectionTitle('Labeled Checkbox'),
        OsmeaComponents.column(
          children: [
            OsmeaComponents.checkbox(
              value: _labeledCheckbox,
              variant: CheckboxVariant.labeled,
              label: 'Enable notifications',
              description: 'Receive push notifications for important updates',
              onChanged: (value) => setState(() => _labeledCheckbox = value),
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.checkbox(
              value: false,
              variant: CheckboxVariant.labeled,
              label: 'Subscribe to newsletter',
              description: 'Get weekly updates about new features',
              onChanged: (value) {},
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 20),
        _buildSubsectionTitle('Card Checkbox'),
        OsmeaComponents.column(
          children: [
            OsmeaComponents.checkbox(
              value: _cardCheckbox1,
              variant: CheckboxVariant.card,
              label: 'Premium Features',
              description: 'Access to advanced tools and priority support',
              fullWidth: true,
              onChanged: (value) => setState(() => _cardCheckbox1 = value),
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.checkbox(
              value: _cardCheckbox2,
              variant: CheckboxVariant.card,
              label: 'Marketing Communications',
              description: 'Receive promotional emails and product updates',
              fullWidth: true,
              onChanged: (value) => setState(() => _cardCheckbox2 = value),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 20),
        _buildSubsectionTitle('Tile Checkbox'),
        OsmeaComponents.column(
          children: [
            OsmeaComponents.checkbox(
              value: _tileCheckbox1,
              variant: CheckboxVariant.tile,
              label: 'Dark Mode',
              description: 'Use dark theme across the application',
              fullWidth: true,
              onChanged: (value) => setState(() => _tileCheckbox1 = value),
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.checkbox(
              value: _tileCheckbox2,
              variant: CheckboxVariant.tile,
              label: 'Auto-save',
              description: 'Automatically save your work every 5 minutes',
              fullWidth: true,
              onChanged: (value) => setState(() => _tileCheckbox2 = value),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSizesSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Small Size'),
        OsmeaComponents.row(
          children: [
            OsmeaComponents.checkbox(
              value: _smallCheckbox,
              variant: CheckboxVariant.labeled,
              label: 'Small Option 1',
              size: CheckboxSize.small,
              onChanged: (value) => setState(() => _smallCheckbox = value),
            ),
            OsmeaComponents.sizedBox(width: 16),
            OsmeaComponents.checkbox(
              value: false,
              variant: CheckboxVariant.labeled,
              label: 'Small Option 2',
              size: CheckboxSize.small,
              onChanged: (value) {},
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildSubsectionTitle('Medium Size (Default)'),
        OsmeaComponents.row(
          children: [
            OsmeaComponents.checkbox(
              value: _mediumCheckbox,
              variant: CheckboxVariant.labeled,
              label: 'Medium Option 1',
              size: CheckboxSize.medium,
              onChanged: (value) => setState(() => _mediumCheckbox = value),
            ),
            OsmeaComponents.sizedBox(width: 16),
            OsmeaComponents.checkbox(
              value: true,
              variant: CheckboxVariant.labeled,
              label: 'Medium Option 2',
              size: CheckboxSize.medium,
              onChanged: (value) {},
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildSubsectionTitle('Large Size'),
        OsmeaComponents.row(
          children: [
            OsmeaComponents.checkbox(
              value: _largeCheckbox,
              variant: CheckboxVariant.labeled,
              label: 'Large Option 1',
              size: CheckboxSize.large,
              onChanged: (value) => setState(() => _largeCheckbox = value),
            ),
            OsmeaComponents.sizedBox(width: 16),
            OsmeaComponents.checkbox(
              value: false,
              variant: CheckboxVariant.labeled,
              label: 'Large Option 2',
              size: CheckboxSize.large,
              onChanged: (value) {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTristateSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle(
            'Tristate Checkboxes (3 States: checked, unchecked, indeterminate)'),
        OsmeaComponents.column(
          children: [
            OsmeaComponents.checkbox(
              value: _tristateCheckbox1,
              tristate: true,
              variant: CheckboxVariant.labeled,
              label: 'Select All Items',
              description: 'Currently indeterminate - some items selected',
              onChanged: (value) => setState(() => _tristateCheckbox1 = value),
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.checkbox(
              value: _tristateCheckbox2,
              tristate: true,
              variant: CheckboxVariant.labeled,
              label: 'Permissions',
              description: 'All permissions granted',
              onChanged: (value) => setState(() => _tristateCheckbox2 = value),
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.checkbox(
              value: _tristateCheckbox3,
              tristate: true,
              variant: CheckboxVariant.labeled,
              label: 'Features',
              description: 'No features enabled',
              onChanged: (value) => setState(() => _tristateCheckbox3 = value),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.checkbox(
          value: _notificationsEnabled,
          variant: CheckboxVariant.tile,
          label: 'Push Notifications',
          description: 'Receive notifications for important updates',
          fullWidth: true,
          onChanged: (value) => setState(() => _notificationsEnabled = value),
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.checkbox(
          value: _locationEnabled,
          variant: CheckboxVariant.tile,
          label: 'Location Services',
          description: 'Allow app to access your location',
          fullWidth: true,
          onChanged: (value) => setState(() => _locationEnabled = value),
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.checkbox(
          value: _cameraEnabled,
          variant: CheckboxVariant.tile,
          label: 'Camera Access',
          description: 'Enable camera for photo capture',
          fullWidth: true,
          onChanged: (value) => setState(() => _cameraEnabled = value),
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.checkbox(
          value: _microphoneEnabled,
          variant: CheckboxVariant.tile,
          label: 'Microphone Access',
          description: 'Enable microphone for voice recording',
          fullWidth: true,
          onChanged: (value) => setState(() => _microphoneEnabled = value),
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.checkbox(
          value: _analyticsEnabled,
          tristate: true,
          variant: CheckboxVariant.tile,
          label: 'Analytics & Crashlytics',
          description: 'Help improve the app by sharing usage data',
          fullWidth: true,
          onChanged: (value) => setState(() => _analyticsEnabled = value),
        ),
      ],
    );
  }

  Widget _buildStateSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Enabled States'),
        OsmeaComponents.row(
          children: [
            OsmeaComponents.checkbox(
              value: true,
              variant: CheckboxVariant.labeled,
              label: 'Enabled Option',
              state: CheckboxState.enabled,
              onChanged: (value) {},
            ),
            OsmeaComponents.sizedBox(width: 16),
            OsmeaComponents.checkbox(
              value: false,
              variant: CheckboxVariant.labeled,
              label: 'Another Enabled',
              state: CheckboxState.enabled,
              onChanged: (value) {},
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildSubsectionTitle('Disabled States'),
        OsmeaComponents.row(
          children: [
            OsmeaComponents.checkbox(
              value: true,
              variant: CheckboxVariant.labeled,
              label: 'Disabled Checked',
              state: CheckboxState.disabled,
              onChanged: null, // Disabled
            ),
            OsmeaComponents.sizedBox(width: 16),
            OsmeaComponents.checkbox(
              value: false,
              variant: CheckboxVariant.labeled,
              label: 'Disabled Unchecked',
              state: CheckboxState.disabled,
              onChanged: null, // Disabled
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStylesSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Material Style'),
        OsmeaComponents.checkbox(
          value: _materialStyle,
          variant: CheckboxVariant.labeled,
          label: 'Material Design',
          style: CheckboxStyle.material,
          onChanged: (value) => setState(() => _materialStyle = value),
        ),
        OsmeaComponents.sizedBox(height: 8),
        _buildSubsectionTitle('Cupertino Style'),
        OsmeaComponents.checkbox(
          value: _cupertinoStyle,
          variant: CheckboxVariant.labeled,
          label: 'iOS Style',
          style: CheckboxStyle.cupertino,
          onChanged: (value) => setState(() => _cupertinoStyle = value),
        ),
        OsmeaComponents.sizedBox(height: 8),
        _buildSubsectionTitle('Modern Style'),
        OsmeaComponents.checkbox(
          value: _modernStyle,
          variant: CheckboxVariant.labeled,
          label: 'Modern Design',
          style: CheckboxStyle.modern,
          onChanged: (value) => setState(() => _modernStyle = value),
        ),
        OsmeaComponents.sizedBox(height: 8),
        _buildSubsectionTitle('Glassmorphism Style'),
        OsmeaComponents.checkbox(
          value: _glassmorphismStyle,
          variant: CheckboxVariant.labeled,
          label: 'Glass Design',
          style: CheckboxStyle.glassmorphism,
          onChanged: (value) => setState(() => _glassmorphismStyle = value),
        ),
        OsmeaComponents.sizedBox(height: 8),
        _buildSubsectionTitle('Minimal Style'),
        OsmeaComponents.checkbox(
          value: _minimalStyle,
          variant: CheckboxVariant.labeled,
          label: 'Clean & Minimal',
          style: CheckboxStyle.minimal,
          onChanged: (value) => setState(() => _minimalStyle = value),
        ),
      ],
    );
  }

  Widget _buildCustomColorsSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Custom Active Colors'),
        OsmeaComponents.row(
          children: [
            OsmeaComponents.checkbox(
              value: _redCheckbox,
              variant: CheckboxVariant.labeled,
              label: 'Red Theme',
              activeColor: OsmeaColors.amberFlame,
              onChanged: (value) => setState(() => _redCheckbox = value),
            ),
            OsmeaComponents.sizedBox(width: 16),
            OsmeaComponents.checkbox(
              value: _greenCheckbox,
              variant: CheckboxVariant.labeled,
              label: 'Green Theme',
              activeColor: OsmeaColors.forestHeart,
              onChanged: (value) => setState(() => _greenCheckbox = value),
            ),
            OsmeaComponents.sizedBox(width: 16),
            OsmeaComponents.checkbox(
              value: _purpleCheckbox,
              variant: CheckboxVariant.labeled,
              label: 'Purple Theme',
              activeColor: OsmeaColors.purple,
              onChanged: (value) => setState(() => _purpleCheckbox = value),
            ),
            OsmeaComponents.sizedBox(width: 16),
            OsmeaComponents.checkbox(
              value: _orangeCheckbox,
              variant: CheckboxVariant.labeled,
              label: 'Orange Theme',
              activeColor: OsmeaColors.sunsetGlow,
              onChanged: (value) => setState(() => _orangeCheckbox = value),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubsectionTitle(String title) {
    return OsmeaComponents.padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
      child: OsmeaComponents.text(
        title,
        variant: OsmeaTextVariant.titleMedium,
        color: OsmeaColors.pewter,
      ),
    );
  }
}
