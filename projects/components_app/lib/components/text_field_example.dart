import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 🔤 **OSMEA TextField Examples**
///
/// Comprehensive examples demonstrating all variants, sizes, and features
/// of the OSMEA TextField component library including OTP TextField.
///
/// This file showcases:
/// * 🎨 All text field variants (outlined, filled, underlined, borderless)
/// * 📏 All size options (extraSmall, small, medium, large, extraLarge)
/// * 🎭 All input types (text, email, password, number, etc.)
/// * 🎯 Advanced features (floating labels, validation, custom builders)
/// * 🔢 OTP TextField with different digit counts
/// * 🎨 Custom styling and theming options
/// * 🔧 Responsive layouts and accessibility features

class TextFieldExample extends StatefulWidget {
  const TextFieldExample({super.key});

  @override
  State<TextFieldExample> createState() => _TextFieldExampleState();
}

class _TextFieldExampleState extends State<TextFieldExample> {
  // Controllers for different text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // State variables
  bool _isPasswordVisible = false;
  String _validationMessage = '';
  bool _showFloatingLabel = true;
  TextFieldVariant _selectedVariant = TextFieldVariant.outlined;
  TextFieldSize _selectedSize = TextFieldSize.medium;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'text_field_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('🎨 TextField Variants'),
            _buildVariantsSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('📏 TextField Sizes'),
            _buildSizesSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🎭 Input Types & Validation'),
            _buildInputTypesSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🎯 Advanced Features'),
            _buildAdvancedFeaturesSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🔢 OTP TextField Examples'),
            _buildOTPSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('⚙️ Interactive Section'),
            _buildInteractiveSection(),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle('🎨 Custom Styling'),
            _buildCustomStylingSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return OsmeaComponents.padding(
      padding: EdgeInsets.only(bottom: context.spacing16),
      child: OsmeaComponents.text(
        title,
        variant: OsmeaTextVariant.headlineSmall,
        color: OsmeaColors.slate,
      ),
    );
  }

  Widget _buildVariantsSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Outlined TextField
        OsmeaComponents.textField(
          label: 'Outlined TextField',
          hint: 'Enter text here...',
          variant: TextFieldVariant.outlined,
          size: TextFieldSize.medium,
          prefixIcon: const Icon(Icons.person_outline),
        ),
        OsmeaComponents.sizedBox(height: 16),

        // Filled TextField
        OsmeaComponents.textField(
          label: 'Filled TextField',
          hint: 'Enter text here...',
          variant: TextFieldVariant.filled,
          size: TextFieldSize.medium,
          prefixIcon: const Icon(Icons.email_outlined),
        ),
        OsmeaComponents.sizedBox(height: 16),

        // Underlined TextField
        OsmeaComponents.textField(
          label: 'Underlined TextField',
          hint: 'Enter text here...',
          variant: TextFieldVariant.underlined,
          size: TextFieldSize.medium,
          prefixIcon: const Icon(Icons.phone_outlined),
        ),
        OsmeaComponents.sizedBox(height: 16),

        // Borderless TextField
        OsmeaComponents.textField(
          label: 'Borderless TextField',
          hint: 'Enter text here...',
          variant: TextFieldVariant.borderless,
          size: TextFieldSize.medium,
          prefixIcon: const Icon(Icons.search_outlined),
        ),
      ],
    );
  }

  Widget _buildSizesSection() {
    final sizes = [
      {'size': TextFieldSize.extraSmall, 'name': 'Extra Small'},
      {'size': TextFieldSize.small, 'name': 'Small'},
      {'size': TextFieldSize.medium, 'name': 'Medium'},
      {'size': TextFieldSize.large, 'name': 'Large'},
      {'size': TextFieldSize.extraLarge, 'name': 'Extra Large'},
    ];

    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: sizes.map((sizeData) {
        return OsmeaComponents.padding(
          padding: EdgeInsets.only(bottom: context.spacing12),
          child: OsmeaComponents.textField(
            label: sizeData['name'] as String,
            hint: 'Size: ${sizeData['name']}',
            variant: TextFieldVariant.outlined,
            size: sizeData['size'] as TextFieldSize,
            prefixIcon: const Icon(Icons.format_size),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInputTypesSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Email TextField
        OsmeaComponents.textField(
          controller: _emailController,
          label: 'Email Address',
          hint: 'Enter your email',
          type: TextFieldType.email,
          variant: TextFieldVariant.outlined,
          size: TextFieldSize.medium,
          prefixIcon: const Icon(Icons.email_outlined),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email is required';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
          onChanged: (value) => setState(() {}),
        ),
        OsmeaComponents.sizedBox(height: 16),

        // Password TextField
        OsmeaComponents.textField(
          controller: _passwordController,
          label: 'Password',
          hint: 'Enter your password',
          type: TextFieldType.password,
          variant: TextFieldVariant.outlined,
          size: TextFieldSize.medium,
          obscureText: !_isPasswordVisible,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: OsmeaComponents.iconButton(
            icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility),
            onPressed: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        OsmeaComponents.sizedBox(height: 16),

        // Phone Number TextField
        OsmeaComponents.textField(
          controller: _phoneController,
          label: 'Phone Number',
          hint: '+1 (555) 123-4567',
          type: TextFieldType.phone,
          variant: TextFieldVariant.outlined,
          size: TextFieldSize.medium,
          prefixIcon: const Icon(Icons.phone_outlined),
          maxLength: 15,
        ),
        OsmeaComponents.sizedBox(height: 16),

        // Multiline TextField
        OsmeaComponents.textField(
          controller: _messageController,
          label: 'Message',
          hint: 'Enter your message here...',
          type: TextFieldType.multiline,
          variant: TextFieldVariant.outlined,
          size: TextFieldSize.medium,
          prefixIcon: const Icon(Icons.message_outlined),
          maxLines: 4,
          minLines: 2,
          maxLength: 500,
        ),
      ],
    );
  }

  Widget _buildAdvancedFeaturesSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Floating Label TextField
        OsmeaComponents.textField(
          label: 'Floating Label TextField',
          hint: 'Watch the label float...',
          variant: TextFieldVariant.outlined,
          size: TextFieldSize.medium,
          prefixIcon: const Icon(Icons.label_outline),
          helperText: 'The label will float above when focused or filled',
        ),
        OsmeaComponents.sizedBox(height: 16),

        // Custom Error Builder TextField
        OsmeaComponents.textField(
          label: 'Custom Error Display',
          hint: 'Enter "error" to see custom error',
          variant: TextFieldVariant.outlined,
          size: TextFieldSize.medium,
          prefixIcon: const Icon(Icons.error_outline),
          validator: (value) =>
              value == 'error' ? 'This is a custom error message' : null,
          onChanged: (value) => setState(() {}),
        ),
        OsmeaComponents.sizedBox(height: 16),

        // Disabled TextField
        OsmeaComponents.textField(
          label: 'Disabled TextField',
          hint: 'This field is disabled',
          variant: TextFieldVariant.outlined,
          size: TextFieldSize.medium,
          enabled: false,
          prefixIcon: const Icon(Icons.block),
          helperText: 'This field cannot be edited',
        ),
      ],
    );
  }

  Widget _buildOTPSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 4-digit OTP
        OsmeaComponents.text(
          '4-Digit OTP',
          variant: OsmeaTextVariant.titleMedium,
          color: OsmeaColors.slate,
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.otpTextField(
          digitCount: 4,
          size: TextFieldSize.large,
          variant: TextFieldVariant.outlined,
          spacing: 12.0,
          onChanged: (otp) => debugPrint('4-digit OTP changed: $otp'),
          onCompleted: (otp) {
            debugPrint('4-digit OTP completed: $otp');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: OsmeaComponents.text('4-digit OTP completed: $otp')),
            );
          },
          validator: (otp) => otp?.length == 4 ? null : 'Please enter 4 digits',
        ),
        OsmeaComponents.sizedBox(height: 24),

        // 6-digit OTP
        OsmeaComponents.text(
          '6-Digit OTP (Default)',
          variant: OsmeaTextVariant.titleMedium,
          color: OsmeaColors.slate,
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.otpTextField(
          digitCount: 6,
          size: TextFieldSize.medium,
          variant: TextFieldVariant.filled,
          spacing: 8.0,
          onChanged: (otp) {
            debugPrint('6-digit OTP changed: $otp');
          },
          onCompleted: (otp) {
            debugPrint('6-digit OTP completed: $otp');
            setState(() => _validationMessage = 'OTP Completed: $otp');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: OsmeaComponents.text('6-digit OTP completed: $otp'),
                backgroundColor: OsmeaColors.orange,
              ),
            );
          },
          validator: (otp) {
            if (otp == null || otp.isEmpty) return 'OTP is required';
            if (otp.length < 6) return 'Please enter all 6 digits';
            return null;
          },
        ),
        if (_validationMessage.isNotEmpty) ...[
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.container(
            padding: EdgeInsets.all(context.spacing12),
            decoration: BoxDecoration(
              color: OsmeaColors.forestHeart.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: OsmeaColors.forestHeart, width: 1),
            ),
            child: OsmeaComponents.row(
              children: [
                Icon(Icons.check_circle,
                    color: OsmeaColors.forestHeart, size: 16),
                OsmeaComponents.sizedBox(width: context.spacing8),
                OsmeaComponents.text(
                  _validationMessage,
                  variant: OsmeaTextVariant.bodyMedium,
                  color: OsmeaColors.forestHeart,
                ),
              ],
            ),
          ),
        ],
        OsmeaComponents.sizedBox(height: 24),

        // 5-digit OTP with custom styling
        OsmeaComponents.text(
          '5-Digit OTP (Custom Style)',
          variant: OsmeaTextVariant.titleMedium,
          color: OsmeaColors.slate,
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.otpTextField(
          digitCount: 5,
          size: TextFieldSize.large,
          variant: TextFieldVariant.filled,
          spacing: 16.0,
          obscureText: true, // Hidden digits for security
          backgroundColor: OsmeaColors.orange,
          focusColor: OsmeaColors.orange,
          borderColor: OsmeaColors.silver,
          onChanged: (otp) =>
              debugPrint('5-digit secure OTP changed: ${'*' * otp.length}'),
          onCompleted: (otp) {
            debugPrint('5-digit secure OTP completed');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: OsmeaComponents.text('Secure OTP completed!'),
                backgroundColor: OsmeaColors.orange,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInteractiveSection() {
    return OsmeaComponents.container(
      padding: EdgeInsets.all(context.spacing16),
      decoration: BoxDecoration(
        color: OsmeaColors.pewter.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OsmeaColors.silver, width: 1),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OsmeaComponents.text(
            'Interactive TextField Section',
            variant: OsmeaTextVariant.titleMedium,
            color: OsmeaColors.slate,
          ),
          OsmeaComponents.sizedBox(height: 16),

          // Variant Selection
          OsmeaComponents.text(
            'Variant:',
            variant: OsmeaTextVariant.bodyMedium,
            color: OsmeaColors.slate,
          ),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.wrap(
            spacing: 8,
            children: TextFieldVariant.values.map((variant) {
              return ChoiceChip(
                label: OsmeaComponents.text(variant.toString().split('.').last),
                selected: _selectedVariant == variant,
                onSelected: (selected) =>
                    setState(() => _selectedVariant = variant),
              );
            }).toList(),
          ),
          OsmeaComponents.sizedBox(height: 16),

          // Size Selection
          OsmeaComponents.text(
            'Size:',
            variant: OsmeaTextVariant.bodyMedium,
            color: OsmeaColors.slate,
          ),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.wrap(
            spacing: 8,
            children: TextFieldSize.values.map((size) {
              return ChoiceChip(
                label: OsmeaComponents.text(size.toString().split('.').last),
                selected: _selectedSize == size,
                onSelected: (selected) => setState(() => _selectedSize = size),
              );
            }).toList(),
          ),
          OsmeaComponents.sizedBox(height: 16),

          // Floating Label Toggle
          CheckboxListTile(
            title: OsmeaComponents.text('Floating Label'),
            value: _showFloatingLabel,
            onChanged: (value) =>
                setState(() => _showFloatingLabel = value ?? false),
            contentPadding: EdgeInsets.zero,
          ),
          OsmeaComponents.sizedBox(height: 16),

          // Interactive TextField
          OsmeaComponents.textField(
            label: 'Interactive TextField',
            hint: 'This field changes based on your selections above',
            variant: _selectedVariant,
            size: _selectedSize,
            prefixIcon: const Icon(Icons.settings),
            helperText:
                'Variant: ${_selectedVariant.toString().split('.').last}, Size: ${_selectedSize.toString().split('.').last}',
          ),
        ],
      ),
    );
  }

  Widget _buildCustomStylingSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Custom colored TextField
        OsmeaComponents.textField(
          label: 'Custom Themed TextField',
          hint: 'This field has custom colors',
          variant: TextFieldVariant.filled,
          size: TextFieldSize.medium,
          backgroundColor: OsmeaColors.orange,
          borderColor: OsmeaColors.nordicBlue,
          focusColor: OsmeaColors.forestHeart,
          textColor: OsmeaColors.slate,
          labelColor: OsmeaColors.nordicBlue,
          hintColor: OsmeaColors.pewter,
          prefixIcon: Icon(Icons.palette, color: OsmeaColors.nordicBlue),
          helperText: 'Custom colors applied to this field',
        ),
        OsmeaComponents.sizedBox(height: 16),

        // Full-width TextField
        OsmeaComponents.textField(
          label: 'Full Width TextField',
          hint: 'This field takes full width',
          variant: TextFieldVariant.filled,
          size: TextFieldSize.large,
          fullWidth: true,
          prefixIcon: const Icon(Icons.fullscreen),
          helperText: 'This field spans the full width of its container',
        ),
        OsmeaComponents.sizedBox(height: 16),

        // Custom animation duration
        OsmeaComponents.textField(
          label: 'Slow Animation TextField',
          hint: 'Watch the slow transition animations',
          variant: TextFieldVariant.outlined,
          size: TextFieldSize.medium,
          animationDuration: const Duration(milliseconds: 800),
          prefixIcon: const Icon(Icons.slow_motion_video),
          helperText: 'This field has slower transition animations',
        ),
      ],
    );
  }
}
