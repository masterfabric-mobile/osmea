import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 🔘 **OSMEA Button Examples**
///
/// Comprehensive examples demonstrating all variants, sizes, and features
/// of the OSMEA Button component library.
///
/// This file showcases:
/// * 🎨 All button variants (primary, secondary, outlined, text, etc.)
/// * 📏 All size options (extraSmall, small, medium, large, extraLarge)
/// * 🎭 All interactive states (enabled, disabled, loading, pressed)
/// * 🎯 Icon positioning (leading, trailing, only)
/// * 🎨 Custom styling and theming options
/// * 🔧 Full-width and responsive layouts

class ButtonExample extends StatefulWidget {
  const ButtonExample({super.key});

  @override
  State<ButtonExample> createState() => _ButtonExampleState();
}

class _ButtonExampleState extends State<ButtonExample> {
  // State variables for different button demonstrations
  bool _isLoading = false;
  int _pressedCount = 0;

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'button_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('🎨 Button Variants'),
            _buildVariantsSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('📏 Button Sizes'),
            _buildSizesSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🎯 Icon Positions'),
            _buildIconPositionsSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🔄 Button States'),
            _buildStatesSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🎭 Interactive'),
            _buildInteractiveSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('📐 Layout'),
            _buildLayoutSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🎨 Custom Styling'),
            _buildCustomStylingSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🎯 Icon Button'),
            _buildIconButtonSection(),
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
        _buildSubsectionTitle('Primary Buttons'),
        OsmeaComponents.wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OsmeaComponents.button(
              text: 'Primary',
              variant: ButtonVariant.primary,
              onPressed: () => _showSnackBar('Primary pressed'),
            ),
            OsmeaComponents.button(
              text: 'With Icon',
              variant: ButtonVariant.primary,
              icon: const Icon(Icons.star),
              onPressed: () => _showSnackBar('Primary with icon pressed'),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildSubsectionTitle('Secondary Buttons'),
        OsmeaComponents.wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OsmeaComponents.button(
              text: 'Secondary',
              variant: ButtonVariant.secondary,
              onPressed: () => _showSnackBar('Secondary pressed'),
            ),
            OsmeaComponents.button(
              text: 'With Icon',
              variant: ButtonVariant.secondary,
              icon: const Icon(Icons.favorite),
              onPressed: () => _showSnackBar('Secondary with icon pressed'),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildSubsectionTitle('Outlined Buttons'),
        OsmeaComponents.wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OsmeaComponents.button(
              text: 'Outlined',
              variant: ButtonVariant.outlined,
              onPressed: () => _showSnackBar('Outlined pressed'),
            ),
            OsmeaComponents.button(
              text: 'With Icon',
              variant: ButtonVariant.outlined,
              icon: const Icon(Icons.share),
              onPressed: () => _showSnackBar('Outlined with icon pressed'),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildSubsectionTitle('Text Buttons'),
        OsmeaComponents.wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OsmeaComponents.button(
              text: 'Text Button',
              variant: ButtonVariant.primary,
              onPressed: () => _showSnackBar('Text button pressed'),
            ),
            OsmeaComponents.textButton(
              text: 'With Icon',
              variant: ButtonVariant.primary,
              onPressed: () => _showSnackBar('Text button with icon pressed'),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildSubsectionTitle('Destructive & Success Buttons'),
        OsmeaComponents.wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OsmeaComponents.button(
              text: 'Delete',
              variant: ButtonVariant.danger,
              icon: const Icon(Icons.delete),
              onPressed: () => _showSnackBar('Delete pressed'),
            ),
            OsmeaComponents.button(
              text: 'Success',
              variant: ButtonVariant.success,
              icon: const Icon(Icons.check),
              onPressed: () => _showSnackBar('Success pressed'),
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
        _buildSubsectionTitle('Size Comparison'),
        OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.button(
              text: 'Extra Small',
              size: ButtonSize.extraSmall,
              onPressed: () => _showSnackBar('Extra Small pressed'),
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.button(
              text: 'Small',
              size: ButtonSize.small,
              onPressed: () => _showSnackBar('Small pressed'),
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.button(
              text: 'Medium (Default)',
              size: ButtonSize.medium,
              onPressed: () => _showSnackBar('Medium pressed'),
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.button(
              text: 'Large',
              size: ButtonSize.large,
              onPressed: () => _showSnackBar('Large pressed'),
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.button(
              text: 'Extra Large',
              size: ButtonSize.extraLarge,
              onPressed: () => _showSnackBar('Extra Large pressed'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconPositionsSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Icon Positions'),
        OsmeaComponents.wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OsmeaComponents.button(
              text: 'Leading Icon',
              icon: const Icon(Icons.arrow_back),
              iconPosition: IconPosition.leading,
              onPressed: () => _showSnackBar('Leading icon pressed'),
            ),
            OsmeaComponents.button(
              text: 'Trailing Icon',
              icon: const Icon(Icons.arrow_forward),
              iconPosition: IconPosition.trailing,
              onPressed: () => _showSnackBar('Trailing icon pressed'),
            ),
            OsmeaComponents.button(
              text: '',
              icon: const Icon(Icons.favorite),
              iconPosition: IconPosition.only,
              onPressed: () => _showSnackBar('Icon only pressed'),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildSubsectionTitle('Vertical Layout'),
        OsmeaComponents.button(
          text: 'Download',
          icon: const Icon(Icons.download),
          iconPosition: IconPosition.top,
          onPressed: () => _showSnackBar('Vertical layout pressed'),
        ),
      ],
    );
  }

  Widget _buildStatesSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Button States'),
        OsmeaComponents.wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OsmeaComponents.button(
              text: 'Enabled',
              state: ButtonState.enabled,
              onPressed: () => _showSnackBar('Enabled pressed'),
            ),
            OsmeaComponents.button(
              text: 'Disabled',
              state: ButtonState.disabled,
              onPressed: null, // Disabled
            ),
            OsmeaComponents.button(
              text: _isLoading ? 'Loading...' : 'Click to Load',
              state: _isLoading ? ButtonState.loading : ButtonState.enabled,
              onPressed: _isLoading ? null : _simulateLoading,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInteractiveSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Interactive'),
        OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.button(
              text: 'Pressed $_pressedCount times',
              icon: const Icon(Icons.touch_app),
              onPressed: () {
                setState(() {
                  _pressedCount++;
                });
                _showSnackBar('Button pressed $_pressedCount times');
              },
            ),
            OsmeaComponents.sizedBox(height: 12),
            OsmeaComponents.button(
              text: 'Long Press Me',
              icon: const Icon(Icons.timer),
              onPressed: () => _showSnackBar('Regular press'),
              onLongPress: () => _showSnackBar('Long press detected!'),
            ),
            OsmeaComponents.sizedBox(height: 12),
            OsmeaComponents.button(
              text: 'Reset Counter',
              variant: ButtonVariant.outlined,
              icon: const Icon(Icons.refresh),
              onPressed: _pressedCount > 0
                  ? () {
                      setState(() {
                        _pressedCount = 0;
                      });
                      _showSnackBar('Counter reset');
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLayoutSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Full Width Button'),
        OsmeaComponents.button(
          text: 'Full Width Button',
          fullWidth: true,
          icon: const Icon(Icons.fullscreen),
          onPressed: () => _showSnackBar('Full width pressed'),
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildSubsectionTitle('Button Row'),
        OsmeaComponents.row(
          children: [
            OsmeaComponents.expanded(
              child: OsmeaComponents.button(
                text: 'Cancel',
                variant: ButtonVariant.outlined,
                onPressed: () => _showSnackBar('Cancel pressed'),
              ),
            ),
            OsmeaComponents.sizedBox(width: 12),
            OsmeaComponents.expanded(
              child: OsmeaComponents.button(
                text: 'Confirm',
                variant: ButtonVariant.primary,
                onPressed: () => _showSnackBar('Confirm pressed'),
              ),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildSubsectionTitle('Centered Button'),
        OsmeaComponents.center(
          child: OsmeaComponents.button(
            text: 'Centered Button',
            variant: ButtonVariant.secondary,
            icon: const Icon(Icons.center_focus_strong),
            onPressed: () => _showSnackBar('Centered pressed'),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomStylingSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Custom Colors'),
        OsmeaComponents.wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OsmeaComponents.button(
              text: 'Custom Red',
              backgroundColor: OsmeaColors.red,
              textColor: OsmeaColors.white,
              onPressed: () => _showSnackBar('Custom red pressed'),
            ),
            OsmeaComponents.button(
              text: 'Custom Green',
              backgroundColor: OsmeaColors.green,
              textColor: OsmeaColors.white,
              icon: const Icon(Icons.eco),
              onPressed: () => _showSnackBar('Custom green pressed'),
            ),
            OsmeaComponents.button(
              text: 'Custom Purple',
              backgroundColor: OsmeaColors.purple,
              textColor: OsmeaColors.white,
              icon: const Icon(Icons.star),
              onPressed: () => _showSnackBar('Custom purple pressed'),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildSubsectionTitle('Custom Shapes & Effects'),
        OsmeaComponents.wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OsmeaComponents.button(
              text: 'Rounded',
              onPressed: () => _showSnackBar('Rounded pressed'),
            ),
            OsmeaComponents.button(
              text: 'Shadow',
              onPressed: () => _showSnackBar('Shadow pressed'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButtonSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Basic Icon Buttons'),
        OsmeaComponents.wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OsmeaComponents.iconButton(
              icon: const Icon(
                Icons.favorite,
                color: Colors.blue,
              ),
              backgroundColor: OsmeaColors.white,
              onPressed: () => _showSnackBar('Favorite icon pressed'),
            ),
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.share),
              variant: ButtonVariant.primary,
              onPressed: () => _showSnackBar('Share icon pressed'),
            ),
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.delete),
              variant: ButtonVariant.danger,
              onPressed: () => _showSnackBar('Delete icon pressed'),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildSubsectionTitle('Different Sizes'),
        OsmeaComponents.wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.star),
              size: ButtonSize.extraSmall,
              onPressed: () => _showSnackBar('Extra small star'),
            ),
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.star),
              size: ButtonSize.small,
              onPressed: () => _showSnackBar('Small star'),
            ),
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.star),
              size: ButtonSize.medium,
              onPressed: () => _showSnackBar('Medium star'),
            ),
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.star),
              size: ButtonSize.large,
              onPressed: () => _showSnackBar('Large star'),
            ),
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.star),
              size: ButtonSize.extraLarge,
              onPressed: () => _showSnackBar('Extra large star'),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildSubsectionTitle('Custom Colors & Background'),
        OsmeaComponents.wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.notifications),
              backgroundColor: OsmeaColors.sunsetGlow,
              onPressed: () => _showSnackBar('Orange notification'),
            ),
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.message),
              backgroundColor: OsmeaColors.crystalBay,
              onPressed: () => _showSnackBar('Blue message'),
            ),
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.phone),
              backgroundColor: OsmeaColors.forestHeart,
              onPressed: () => _showSnackBar('Green phone'),
            ),
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.camera),
              backgroundColor: OsmeaColors.amberFlame,
              onPressed: () => _showSnackBar('Red camera'),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildSubsectionTitle('Different Variants'),
        OsmeaComponents.wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.home),
              variant: ButtonVariant.primary,
              onPressed: () => _showSnackBar('Primary home'),
            ),
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.search),
              variant: ButtonVariant.secondary,
              onPressed: () => _showSnackBar('Secondary search'),
            ),
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.settings),
              variant: ButtonVariant.outlined,
              onPressed: () => _showSnackBar('Outlined settings'),
            ),
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.info),
              variant: ButtonVariant.ghost,
              onPressed: () => _showSnackBar('Ghost info'),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildSubsectionTitle('Custom Elevation & Radius'),
        OsmeaComponents.wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.cloud),
              backgroundColor: OsmeaColors.crystalBay,
              elevation: 0.0, // No shadow
              onPressed: () => _showSnackBar('Shadowless cloud'),
            ),
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.sunny),
              backgroundColor: OsmeaColors.sunsetGlow,
              elevation: 8.0, // High shadow
              onPressed: () => _showSnackBar('Shadowy sun'),
            ),
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.square),
              backgroundColor: OsmeaColors.forestHeart,
              borderRadius: 8.0, // Custom radius
              onPressed: () => _showSnackBar('Square corners'),
            ),
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.circle),
              backgroundColor: OsmeaColors.purple,
              borderRadius: 50.0, // Very rounded
              onPressed: () => _showSnackBar('Very round circle'),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildSubsectionTitle('Disabled & Loading States'),
        OsmeaComponents.wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.block),
              state: ButtonState.disabled,
              onPressed: null, // Disabled
            ),
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.refresh),
              state: _isLoading ? ButtonState.loading : ButtonState.enabled,
              onPressed: _isLoading ? null : _simulateLoading,
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildSubsectionTitle('Tooltip & Long Press'),
        OsmeaComponents.wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.help),
              tooltip: 'This is a help button',
              onPressed: () => _showSnackBar('Help button pressed'),
            ),
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.touch_app),
              tooltip: 'Long pressable',
              onPressed: () => _showSnackBar('Short press'),
              onLongPress: () => _showSnackBar('Long press detected!'),
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: OsmeaComponents.text(
          message,
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.white,
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: OsmeaColors.nordicBlue,
      ),
    );
  }

  void _simulateLoading() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Loading completed!');
      }
    });
  }
}
