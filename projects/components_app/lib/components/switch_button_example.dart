import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 🔄 **OSMEA Switch Button Examples**
///
/// Comprehensive examples demonstrating all variants, sizes, and features
/// of the OSMEA Switch component library.
///
/// This file showcases:
/// * 🎨 All switch variants (simple, labeled, toggle, slider, card, compact, extended)
/// * 📏 All size options (small, medium, large)
/// * 🎭 All visual styles (material, modern, glassmorphism, etc.)
/// * 🔄 All interactive states (enabled, disabled, focused, hovered)
/// * 🏷️ Label and description examples
/// * 🎨 Custom color examples using activeColor parameter
/// * ⚙️ Custom styling options

class SwitchButtonExample extends StatefulWidget {
  const SwitchButtonExample({super.key});

  @override
  State<SwitchButtonExample> createState() => _SwitchButtonExampleState();
}

class _SwitchButtonExampleState extends State<SwitchButtonExample> {
  // State variables for different switch variants
  bool _simpleSwitch = true;
  bool _labeledSwitch = false;
  bool _toggleSwitch = true;
  bool _sliderSwitch = false;
  bool _cardSwitch = true;
  bool _compactSwitch = false;
  bool _extendedSwitch = true;

  // State variables for different sizes
  bool _smallSwitch = true;
  bool _mediumSwitch = false;
  bool _largeSwitch = true;

  // State variables for different styles
  bool _materialStyle = true;
  bool _cupertinoStyle = false;
  bool _modernStyle = true;
  bool _glassmorphismStyle = true;
  bool _minimalStyle = false;

  // State variables for settings example
  bool _darkModeSwitch = false;
  bool _notificationSwitch = true;
  bool _locationSwitch = false;
  bool _bluetoothSwitch = true;
  bool _wifiSwitch = true;
  bool _autoBackupSwitch = false;

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'switch_button_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('🎨 Switch Variants'),
            _buildVariantsSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('📏 Switch Sizes'),
            _buildSizesSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('⚙️ Settings'),
            _buildSettingsSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🔄 State'),
            _buildStateSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🎭 Custom Styled Switches'),
            _buildCustomSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🎭 Switch Styles'),
            _buildStylesSection(),
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
        textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: OsmeaColors.black54,
        ),
      ),
    );
  }

  Widget _buildVariantsSection() {
    return Card(
      child: OsmeaComponents.padding(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          children: [
            _buildSwitchRow(
              '🎯 Simple Switch',
              'Basic switch without labels',
              _simpleSwitch,
              (value) => setState(() => _simpleSwitch = value),
              variant: SwitchVariant.simple,
            ),
            OsmeaComponents.divider(),
            _buildSwitchRow(
              '🏷️ Labeled Switch',
              'Switch with label support',
              _labeledSwitch,
              (value) => setState(() => _labeledSwitch = value),
              variant: SwitchVariant.labeled,
            ),
            OsmeaComponents.divider(),
            _buildSwitchRow(
              '🔄 Toggle Switch',
              'Classic toggle switch style',
              _toggleSwitch,
              (value) => setState(() => _toggleSwitch = value),
              variant: SwitchVariant.toggle,
            ),
            OsmeaComponents.divider(),
            _buildSwitchRow(
              '🎚️ Slider Switch',
              'Slider-style switch with smooth animation',
              _sliderSwitch,
              (value) => setState(() => _sliderSwitch = value),
              variant: SwitchVariant.slider,
            ),
            OsmeaComponents.divider(),
            _buildSwitchRow(
              '🎴 Card Switch',
              'Switch embedded in card container',
              _cardSwitch,
              (value) => setState(() => _cardSwitch = value),
              variant: SwitchVariant.card,
            ),
            OsmeaComponents.divider(),
            _buildSwitchRow(
              '📦 Compact Switch',
              'Minimal space switch for dense layouts',
              _compactSwitch,
              (value) => setState(() => _compactSwitch = value),
              variant: SwitchVariant.compact,
            ),
            OsmeaComponents.divider(),
            _buildSwitchRow(
              '🔧 Extended Switch',
              'Full-featured switch with maximum customization',
              _extendedSwitch,
              (value) => setState(() => _extendedSwitch = value),
              variant: SwitchVariant.extended,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizesSection() {
    return Card(
      child: OsmeaComponents.padding(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          children: [
            _buildSwitchRow(
              '🔸 Small Switch',
              'Compact switch for tight spaces (32px)',
              _smallSwitch,
              (value) => setState(() => _smallSwitch = value),
              size: SwitchSize.small,
            ),
            OsmeaComponents.divider(),
            _buildSwitchRow(
              '🔶 Medium Switch',
              'Standard switch size (48px)',
              _mediumSwitch,
              (value) => setState(() => _mediumSwitch = value),
              size: SwitchSize.medium,
            ),
            OsmeaComponents.divider(),
            _buildSwitchRow(
              '🔷 Large Switch',
              'Prominent switch for accessibility (64px)',
              _largeSwitch,
              (value) => setState(() => _largeSwitch = value),
              size: SwitchSize.large,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Card(
      child: OsmeaComponents.padding(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          children: [
            _buildSwitchRow(
              '🌙 Dark Mode',
              'Enable dark theme throughout the app',
              _darkModeSwitch,
              (value) => setState(() => _darkModeSwitch = value),
              variant: SwitchVariant.labeled,
            ),
            OsmeaComponents.divider(),
            _buildSwitchRow(
              '🔔 Notifications',
              'Receive push notifications',
              _notificationSwitch,
              (value) => setState(() => _notificationSwitch = value),
              variant: SwitchVariant.labeled,
              customActiveColor: OsmeaColors.meadow,
            ),
            OsmeaComponents.divider(),
            _buildSwitchRow(
              '📍 Location Services',
              'Allow location access for better experience',
              _locationSwitch,
              (value) => setState(() => _locationSwitch = value),
              variant: SwitchVariant.labeled,
              customActiveColor: OsmeaColors.sunsetGlow,
            ),
            OsmeaComponents.divider(),
            _buildSwitchRow(
              '📶 Bluetooth',
              'Enable Bluetooth connectivity',
              _bluetoothSwitch,
              (value) => setState(() => _bluetoothSwitch = value),
              variant: SwitchVariant.toggle,
              customActiveColor: OsmeaColors.nordicBlue,
            ),
            OsmeaComponents.divider(),
            _buildSwitchRow(
              '📶 WiFi',
              'Connect to available WiFi networks',
              _wifiSwitch,
              (value) => setState(() => _wifiSwitch = value),
              variant: SwitchVariant.slider,
            ),
            OsmeaComponents.divider(),
            _buildSwitchRow(
              '💾 Auto Backup',
              'Automatically backup your data',
              _autoBackupSwitch,
              (value) => setState(() => _autoBackupSwitch = value),
              variant: SwitchVariant.card,
              customActiveColor: OsmeaColors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateSection() {
    return Card(
      child: OsmeaComponents.padding(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          children: [
            _buildSwitchRow(
              '✅ Enabled Switch',
              'Normal interactive state',
              true,
              (value) {},
              state: SwitchState.enabled,
            ),
            OsmeaComponents.divider(),
            _buildSwitchRow(
              '⚫ Disabled Switch',
              'Non-interactive state',
              false,
              null,
              state: SwitchState.disabled,
            ),
            OsmeaComponents.divider(),
            _buildSwitchRow(
              '🎯 Focused Switch',
              'Keyboard focus state',
              true,
              (value) {},
              state: SwitchState.focused,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomSection() {
    return Card(
      child: OsmeaComponents.padding(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          children: [
            // Custom colored switch
            OsmeaComponents.switchButton(
              value: true,
              onChanged: (value) {},
              label: '🎨 Custom Colors',
              description: 'Switch with custom active and inactive colors',
              variant: SwitchVariant.extended,
              size: SwitchSize.large,
              activeColor: OsmeaColors.purple,
              inactiveColor: OsmeaColors.platinum,
              thumbColor: OsmeaColors.white,
            ),
            OsmeaComponents.divider(), // Full width switch
            OsmeaComponents.switchButton(
              value: false,
              onChanged: (value) {},
              label: '📐 Full Width Switch',
              description: 'Switch that takes full available width',
              variant: SwitchVariant.card,
              activeColor: OsmeaColors.meadow, 
              fullWidth: true,
            ),
            OsmeaComponents.divider(),
            // Switch with custom padding
            OsmeaComponents.container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: OsmeaColors.nordicBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: OsmeaComponents.switchButton(
                value: true,
                onChanged: (value) {},
                label: '🎁 Custom Container',
                description: 'Switch inside a custom container',
                variant: SwitchVariant.labeled,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStylesSection() {
    return Card(
      child: OsmeaComponents.padding(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          children: [
            _buildSwitchRow(
              '✨ Modern Style',
              'Contemporary flat design with subtle shadows',
              _modernStyle,
              (value) => setState(() => _modernStyle = value),
              style: SwitchStyle.modern,
            ),
            OsmeaComponents.divider(),
            _buildSwitchRow(
              '📱 Material Style',
              'Google Material Design 3 style',
              _materialStyle,
              (value) => setState(() => _materialStyle = value),
              style: SwitchStyle.material,
            ),
            OsmeaComponents.divider(),
            _buildSwitchRow(
              '🍎 Cupertino Style',
              'Apple iOS style with smooth animations',
              _cupertinoStyle,
              (value) => setState(() => _cupertinoStyle = value),
              style: SwitchStyle.cupertino,
            ),
            OsmeaComponents.divider(),
            _buildSwitchRow(
              '💎 Glassmorphism Style',
              'Glass-like transparency with blur effects',
              _glassmorphismStyle,
              (value) => setState(() => _glassmorphismStyle = value),
              style: SwitchStyle.glassmorphism,
            ),
            OsmeaComponents.divider(),
            _buildSwitchRow(
              '🔲 Minimal Style',
              'Ultra-clean design with pure geometric shapes',
              _minimalStyle,
              (value) => setState(() => _minimalStyle = value),
              style: SwitchStyle.minimal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow(
    String title,
    String description,
    bool value,
    ValueChanged<bool>? onChanged, {
    SwitchVariant variant = SwitchVariant.labeled,
    SwitchSize size = SwitchSize.medium,
    SwitchState state = SwitchState.enabled,
    SwitchStyle style = SwitchStyle.modern,
    Color? customActiveColor,
  }) {
    return OsmeaComponents.padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: OsmeaComponents.switchButton(
        value: value,
        onChanged: onChanged,
        label: title,
        description: description,
        variant: variant,
        size: size,
        state: state,
        style: style,
        activeColor: customActiveColor,
        fullWidth: true,
      ),
    );
  }
}
