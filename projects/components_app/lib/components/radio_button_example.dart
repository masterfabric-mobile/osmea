import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 🔘 **OSMEA Radio Button Examples**
///
/// Comprehensive examples demonstrating all variants, sizes, and features
/// of the OSMEA Radio component library.
///
/// This file showcases:
/// * 🎨 All radio variants (simple, labeled, card, tile, compact, extended)
/// * 📏 All size options (small, medium, large)
/// * 🎭 All visual styles (material, modern, glassmorphism, etc.)
/// * 🔄 All interactive states (enabled, disabled, focused, hovered)
/// * 🏷️ Label and description examples
/// * 🎨 Custom color examples using activeColor parameter
/// * ⚙️ Custom styling options

class RadioButtonExample extends StatefulWidget {
  const RadioButtonExample({super.key});

  @override
  State<RadioButtonExample> createState() => _RadioButtonExampleState();
}

class _RadioButtonExampleState extends State<RadioButtonExample> {
  // State variables for different radio group options
  String? _selectedVariant = 'simple';
  String? _selectedSize = 'medium';
  String? _selectedStyle = 'modern';
  String? _selectedColor = 'blue';
  String? _selectedPayment = 'credit_card';
  String? _selectedPlan = 'pro';
  String? _selectedTheme = 'light';

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'radio_button_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('🎨 Radio Variants'),
            _buildVariantsSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('📏 Radio Sizes'),
            _buildSizesSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('💳 Payment Method Selection'),
            _buildPaymentSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('📦 Subscription Plans'),
            _buildPlansSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🔄 State'),
            _buildStateSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🎭 Radio Styles'),
            _buildStylesSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🎨 Custom Colors'),
            _buildCustomColorsSection(),
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
          color: OsmeaColors.black.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildVariantsSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Simple Radio (No Labels)'),
        OsmeaComponents.wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            OsmeaComponents.radioButton<String>(
              value: 'simple',
              groupValue: _selectedVariant,
              onChanged: (value) => setState(() => _selectedVariant = value),
            ),
            OsmeaComponents.radioButton<String>(
              value: 'option2',
              groupValue: _selectedVariant,
              onChanged: (value) => setState(() => _selectedVariant = value),
            ),
            OsmeaComponents.radioButton<String>(
              value: 'option3',
              groupValue: _selectedVariant,
              onChanged: (value) => setState(() => _selectedVariant = value),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 20),
        _buildSubsectionTitle('Labeled Radio'),
        OsmeaComponents.column(
          children: [
            OsmeaComponents.radioButton<String>(
              value: 'labeled',
              groupValue: _selectedVariant,
              label: 'Labeled Option',
              description: 'This option includes a descriptive label',
              onChanged: (value) => setState(() => _selectedVariant = value),
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.radioButton<String>(
              value: 'another',
              groupValue: _selectedVariant,
              label: 'Another Option',
              description: 'This is another option with description',
              onChanged: (value) => setState(() => _selectedVariant = value),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 20),
        _buildSubsectionTitle('Card Radio'),
        OsmeaComponents.column(
          children: [
            OsmeaCardRadio<String>(
              value: 'card1',
              groupValue: _selectedVariant,
              label: 'Premium Plan',
              description: 'Full access to all features with priority support',
              onChanged: (value) => setState(() => _selectedVariant = value),
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaCardRadio<String>(
              value: 'card2',
              groupValue: _selectedVariant,
              label: 'Basic Plan',
              description: 'Essential features for getting started',
              onChanged: (value) => setState(() => _selectedVariant = value),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 20),
        _buildSubsectionTitle('Tile Radio'),
        OsmeaComponents.column(
          children: [
            OsmeaTileRadio<String>(
              value: 'tile1',
              groupValue: _selectedVariant,
              label: 'Professional',
              description: 'For teams and organizations',
              onChanged: (value) => setState(() => _selectedVariant = value),
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaTileRadio<String>(
              value: 'tile2',
              groupValue: _selectedVariant,
              label: 'Enterprise',
              description: 'Advanced features and custom solutions',
              onChanged: (value) => setState(() => _selectedVariant = value),
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
        OsmeaComponents.wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            OsmeaComponents.radioButton<String>(
              value: 'small1',
              groupValue: _selectedSize,
              label: 'Small Option 1',
              size: RadioSize.small,
              onChanged: (value) => setState(() => _selectedSize = value),
            ),
            OsmeaComponents.radioButton<String>(
              value: 'small2',
              groupValue: _selectedSize,
              label: 'Small Option 2',
              size: RadioSize.small,
              onChanged: (value) => setState(() => _selectedSize = value),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildSubsectionTitle('Medium Size (Default)'),
        OsmeaComponents.wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            OsmeaComponents.radioButton<String>(
              value: 'medium',
              groupValue: _selectedSize,
              label: 'Medium Option 1',
              size: RadioSize.medium,
              onChanged: (value) => setState(() => _selectedSize = value),
            ),
            OsmeaComponents.radioButton<String>(
              value: 'medium2',
              groupValue: _selectedSize,
              label: 'Medium Option 2',
              size: RadioSize.medium,
              onChanged: (value) => setState(() => _selectedSize = value),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildSubsectionTitle('Large Size'),
        OsmeaComponents.wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            OsmeaComponents.radioButton<String>(
              value: 'large1',
              groupValue: _selectedSize,
              label: 'Large Option 1',
              size: RadioSize.large,
              onChanged: (value) => setState(() => _selectedSize = value),
            ),
            OsmeaComponents.radioButton<String>(
              value: 'large2',
              groupValue: _selectedSize,
              label: 'Large Option 2',
              size: RadioSize.large,
              onChanged: (value) => setState(() => _selectedSize = value),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentSection() {
    return OsmeaComponents.column(
      children: [
        OsmeaCardRadio<String>(
          value: 'credit_card',
          groupValue: _selectedPayment,
          label: 'Credit Card',
          description: 'Pay with Visa, Mastercard, or American Express',
          onChanged: (value) => setState(() => _selectedPayment = value),
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaCardRadio<String>(
          value: 'paypal',
          groupValue: _selectedPayment,
          label: 'PayPal',
          description: 'Secure payment through your PayPal account',
          onChanged: (value) => setState(() => _selectedPayment = value),
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaCardRadio<String>(
          value: 'bank_transfer',
          groupValue: _selectedPayment,
          label: 'Bank Transfer',
          description: 'Direct transfer from your bank account',
          onChanged: (value) => setState(() => _selectedPayment = value),
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaCardRadio<String>(
          value: 'apple_pay',
          groupValue: _selectedPayment,
          label: 'Apple Pay',
          description: 'Quick and secure payment with Touch ID',
          onChanged: (value) => setState(() => _selectedPayment = value),
        ),
      ],
    );
  }

  Widget _buildPlansSection() {
    return OsmeaComponents.column(
      children: [
        OsmeaTileRadio<String>(
          value: 'basic',
          groupValue: _selectedPlan,
          label: 'Basic Plan',
          description: '\$9.99/month • Essential features • 5GB storage',
          onChanged: (value) => setState(() => _selectedPlan = value),
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaTileRadio<String>(
          value: 'pro',
          groupValue: _selectedPlan,
          label: 'Pro Plan',
          description: '\$19.99/month • Advanced features • 50GB storage',
          onChanged: (value) => setState(() => _selectedPlan = value),
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaTileRadio<String>(
          value: 'enterprise',
          groupValue: _selectedPlan,
          label: 'Enterprise Plan',
          description: '\$49.99/month • All features • Unlimited storage',
          onChanged: (value) => setState(() => _selectedPlan = value),
        ),
      ],
    );
  }

  Widget _buildStateSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Enabled States'),
        OsmeaComponents.wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            OsmeaComponents.radioButton<String>(
              value: 'enabled1',
              groupValue: _selectedTheme,
              label: 'Enabled Option',
              state: RadioState.enabled,
              onChanged: (value) => setState(() => _selectedTheme = value),
            ),
            OsmeaComponents.radioButton<String>(
              value: 'enabled2',
              groupValue: _selectedTheme,
              label: 'Another Enabled',
              state: RadioState.enabled,
              onChanged: (value) => setState(() => _selectedTheme = value),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildSubsectionTitle('Disabled States'),
        OsmeaComponents.wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            OsmeaComponents.radioButton<String>(
              value: 'disabled1',
              groupValue: _selectedTheme,
              label: 'Disabled Option',
              state: RadioState.disabled,
              onChanged: null, // Disabled
            ),
            OsmeaComponents.radioButton<String>(
              value: 'disabled2',
              groupValue: _selectedTheme,
              label: 'Another Disabled',
              state: RadioState.disabled,
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
        OsmeaComponents.radioButton<String>(
          value: 'material',
          groupValue: _selectedStyle,
          label: 'Material Design',
          style: RadioStyle.material,
          onChanged: (value) => setState(() => _selectedStyle = value),
        ),
        OsmeaComponents.sizedBox(height: 8),
        _buildSubsectionTitle('Cupertino Style'),
        OsmeaComponents.radioButton<String>(
          value: 'cupertino',
          groupValue: _selectedStyle,
          label: 'iOS Style',
          style: RadioStyle.cupertino,
          onChanged: (value) => setState(() => _selectedStyle = value),
        ),
        OsmeaComponents.sizedBox(height: 8),
        _buildSubsectionTitle('Modern Style'),
        OsmeaComponents.radioButton<String>(
          value: 'modern',
          groupValue: _selectedStyle,
          label: 'Modern Design',
          style: RadioStyle.modern,
          onChanged: (value) => setState(() => _selectedStyle = value),
        ),
        OsmeaComponents.sizedBox(height: 8),
        _buildSubsectionTitle('Minimal Style'),
        OsmeaComponents.radioButton<String>(
          value: 'minimal',
          groupValue: _selectedStyle,
          label: 'Clean & Minimal',
          style: RadioStyle.minimal,
          onChanged: (value) => setState(() => _selectedStyle = value),
        ),
      ],
    );
  }

  Widget _buildCustomColorsSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Custom Active Colors'),
        OsmeaComponents.wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            OsmeaComponents.radioButton<String>(
              value: 'red',
              groupValue: _selectedColor,
              label: 'Red Theme',
              activeColor: OsmeaColors.red,
              onChanged: (value) => setState(() => _selectedColor = value),
            ),
            OsmeaComponents.radioButton<String>(
              value: 'green',
              groupValue: _selectedColor,
              label: 'Green Theme',
              activeColor: OsmeaColors.green,
              onChanged: (value) => setState(() => _selectedColor = value),
            ),
            OsmeaComponents.radioButton<String>(
              value: 'purple',
              groupValue: _selectedColor,
              label: 'Purple Theme',
              activeColor: OsmeaColors.purple,
              onChanged: (value) => setState(() => _selectedColor = value),
            ),
            OsmeaComponents.radioButton<String>(
              value: 'orange',
              groupValue: _selectedColor,
              label: 'Orange Theme',
              activeColor: OsmeaColors.orange,
              onChanged: (value) => setState(() => _selectedColor = value),
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
        textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: OsmeaColors.black54,
        ),
      ),
    );
  }
}
