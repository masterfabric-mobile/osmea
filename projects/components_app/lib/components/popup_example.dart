import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 📱 **OSMEA Popup Examples**
///
/// A comprehensive showcase of all popup component variants, sizes, and features
/// available in the OSMEA UI Kit.
///
/// {@category Examples}
/// {@subCategory Popup}
///
/// Features demonstrated:
/// * 📏 All size variants (small, medium, large)
/// * 🎨 All style variants (modal, alert, dialog, tooltip)
/// * 🔄 All interactive states
/// * 📍 Multiple position options
/// * 🎬 Different animation types
/// * 🎯 Custom theming and styling
/// * ♿ Accessibility features
///
/// This example serves as both documentation and interactive showcase
/// for popup components.

class PopupExample extends StatefulWidget {
  const PopupExample({super.key});

  @override
  State<PopupExample> createState() => _PopupExampleState();
}

class _PopupExampleState extends State<PopupExample> {
  PopupSize _selectedSize = PopupSize.medium;
  PopupVariant _selectedVariant = PopupVariant.modal;
  PopupPosition _selectedPosition = PopupPosition.center;
  PopupAnimationType _selectedAnimation = PopupAnimationType.scale;
  final bool _showCloseButton = true;
  final bool _isDismissible = true;

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'popup_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: context.paddingMedium,
        child: OsmeaComponents.singleChildScrollView(
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildWelcomeSection(),
              OsmeaComponents.sizedBox(height: 24),
              _buildControlsSection(),
              OsmeaComponents.sizedBox(height: 24),
              _buildQuickExamplesSection(),
              OsmeaComponents.sizedBox(height: 24),
              _buildSizeComparisonSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return OsmeaComponents.container(
      padding: context.paddingMedium,
      decoration: BoxDecoration(
        color: OsmeaColors.nordicBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(context.radiusLow * 2),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            '📱 Popup Component',
            textAlign: TextAlign.start,
            color: OsmeaColors.nordicBlue,
          ),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.text(
            'Explore all popup variants (S, M, L sizes), animations, and customization options.',
            textAlign: TextAlign.start,
            color: OsmeaColors.slate,
          ),
        ],
      ),
    );
  }

  Widget _buildControlsSection() {
    return OsmeaComponents.container(
      padding: context.paddingMedium,
      decoration: BoxDecoration(
        border: Border.all(color: OsmeaColors.silver),
        borderRadius: BorderRadius.circular(context.radiusLow * 2),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            '⚙️ Popup Controls',
            color: OsmeaColors.slate,
          ),
          OsmeaComponents.sizedBox(height: 20),

          // Size Selection
          _buildSectionTitle('📏 Size'),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.wrap(
            spacing: 8,
            children: PopupSize.values.map<Widget>((size) {
              return OsmeaComponents.button(
                text: _getSizeLabel(size),
                variant: _selectedSize == size
                    ? ButtonVariant.primary
                    : ButtonVariant.outlined,
                size: ButtonSize.small,
                onPressed: () => setState(() => _selectedSize = size),
              );
            }).toList(),
          ),
          OsmeaComponents.sizedBox(height: 24),

          // Variant Selection
          _buildSectionTitle('🎨 Variant'),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.wrap(
            spacing: 8,
            children: PopupVariant.values.map<Widget>((variant) {
              return OsmeaComponents.button(
                text: _getVariantLabel(variant),
                variant: _selectedVariant == variant
                    ? ButtonVariant.primary
                    : ButtonVariant.outlined,
                size: ButtonSize.small,
                onPressed: () => setState(() => _selectedVariant = variant),
              );
            }).toList(),
          ),
          OsmeaComponents.sizedBox(height: 24),

          // Position Selection
          _buildSectionTitle('📍 Position'),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.wrap(
            spacing: 8,
            children: PopupPosition.values.map<Widget>((position) {
              return OsmeaComponents.button(
                text: _getPositionLabel(position),
                variant: _selectedPosition == position
                    ? ButtonVariant.primary
                    : ButtonVariant.outlined,
                size: ButtonSize.small,
                onPressed: () => setState(() => _selectedPosition = position),
              );
            }).toList(),
          ),
          OsmeaComponents.sizedBox(height: 24),

          // Animation Selection
          _buildSectionTitle('🎬 Animation'),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.wrap(
            spacing: 8,
            children: PopupAnimationType.values.map<Widget>((animation) {
              return OsmeaComponents.button(
                text: _getAnimationLabel(animation),
                variant: _selectedAnimation == animation
                    ? ButtonVariant.primary
                    : ButtonVariant.outlined,
                size: ButtonSize.small,
                onPressed: () => setState(() => _selectedAnimation = animation),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickExamplesSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          '🚀 Quick',
          color: OsmeaColors.slate,
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildExampleButton(
              '📱 Custom Popup',
              () => _showCustomPopup(),
              ButtonVariant.primary,
            ),
            _buildExampleButton(
              '⚠️ Simple Alert',
              () => _showSimpleAlert(),
              ButtonVariant.warning,
            ),
            _buildExampleButton(
              '💬 Confirmation',
              () => _showConfirmationDialog(),
              ButtonVariant.secondary,
            ),
            _buildExampleButton(
              '💡 Tooltip',
              () => _showTooltipInfo(),
              ButtonVariant.ghost,
            ),
            _buildExampleButton(
              '📝 Form Dialog',
              () => _showFormDialog(),
              ButtonVariant.success,
            ),
            _buildExampleButton(
              '⏰ Auto Dismiss',
              () => _showAutoDismissPopup(),
              ButtonVariant.outlined,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSizeComparisonSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          '🎯 Size Comparison (S, M, L)',
          color: OsmeaColors.slate,
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.column(
          children: [
            OsmeaComponents.container(
              width: double.infinity,
              child: _buildExampleButton(
                '🔸 Small (S)',
                () => _showSizeShowcase(PopupSize.small),
                ButtonVariant.outlined,
              ),
            ),
            OsmeaComponents.sizedBox(height: 12),
            OsmeaComponents.container(
              width: double.infinity,
              child: _buildExampleButton(
                '🔶 Medium (M)',
                () => _showSizeShowcase(PopupSize.medium),
                ButtonVariant.outlined,
              ),
            ),
            OsmeaComponents.sizedBox(height: 12),
            OsmeaComponents.container(
              width: double.infinity,
              child: _buildExampleButton(
                '🔷 Large (L)',
                () => _showSizeShowcase(PopupSize.large),
                ButtonVariant.outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return OsmeaComponents.text(
      title,
      color: OsmeaColors.slate,
    );
  }

  Widget _buildExampleButton(
    String title,
    VoidCallback onPressed,
    ButtonVariant variant,
  ) {
    return OsmeaComponents.container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 50),
      child: OsmeaComponents.button(
        text: title,
        variant: variant,
        size: ButtonSize.medium,
        onPressed: onPressed,
        fullWidth: true,
      ),
    );
  }

  String _getSizeLabel(PopupSize size) {
    switch (size) {
      case PopupSize.small:
        return 'Small (S)';
      case PopupSize.medium:
        return 'Medium (M)';
      case PopupSize.large:
        return 'Large (L)';
    }
  }

  String _getVariantLabel(PopupVariant variant) {
    switch (variant) {
      case PopupVariant.modal:
        return 'Modal';
      case PopupVariant.alert:
        return 'Alert';
      case PopupVariant.dialog:
        return 'Dialog';
      case PopupVariant.tooltip:
        return 'Tooltip';
    }
  }

  String _getPositionLabel(PopupPosition position) {
    switch (position) {
      case PopupPosition.center:
        return 'Center';
      case PopupPosition.top:
        return 'Top';
      case PopupPosition.bottom:
        return 'Bottom';
      case PopupPosition.topLeft:
        return 'Top Left';
      case PopupPosition.topRight:
        return 'Top Right';
      case PopupPosition.bottomLeft:
        return 'Bottom Left';
      case PopupPosition.bottomRight:
        return 'Bottom Right';
    }
  }

  String _getAnimationLabel(PopupAnimationType animation) {
    switch (animation) {
      case PopupAnimationType.fade:
        return 'Fade';
      case PopupAnimationType.scale:
        return 'Scale';
      case PopupAnimationType.slide:
        return 'Slide';
      case PopupAnimationType.slideAndFade:
        return 'Slide & Fade';
    }
  }

  void _showCustomPopup() {
    OsmeaComponents.showPopup(
      context: context,
      size: _selectedSize,
      variant: _selectedVariant,
      position: _selectedPosition,
      animationType: _selectedAnimation,
      title: 'Custom Popup',
      subtitle: 'This popup uses your selected settings',
      showCloseButton: _showCloseButton,
      isDismissible: _isDismissible,
      child: OsmeaComponents.column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OsmeaComponents.text(
            'Size: ${_getSizeLabel(_selectedSize)}',
            textAlign: TextAlign.start,
          ),
          OsmeaComponents.text(
            'Variant: ${_getVariantLabel(_selectedVariant)}',
            textAlign: TextAlign.start,
          ),
          OsmeaComponents.text(
            'Position: ${_getPositionLabel(_selectedPosition)}',
            textAlign: TextAlign.start,
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.text(
            'This showcases the popup component with your custom settings.',
            textAlign: TextAlign.center,
            color: OsmeaColors.slate,
          ),
        ],
      ),
      footer: OsmeaComponents.row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OsmeaComponents.button(
            text: 'Cancel',
            variant: ButtonVariant.outlined,
            size: ButtonSize.small,
            onPressed: () => Navigator.of(context).pop(),
          ),
          OsmeaComponents.sizedBox(width: 8),
          OsmeaComponents.button(
            text: 'OK',
            variant: ButtonVariant.primary,
            size: ButtonSize.small,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showSimpleAlert() {
    OsmeaComponents.showPopup(
      context: context,
      variant: PopupVariant.alert,
      size: PopupSize.small,
      title: '⚠️ Alert',
      showCloseButton: false,
      child: OsmeaComponents.text(
        'This is a simple alert message. Please acknowledge to continue.',
        textAlign: TextAlign.center,
      ),
      footer: OsmeaComponents.button(
        text: 'OK',
        variant: ButtonVariant.primary,
        size: ButtonSize.medium,
        fullWidth: true,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showConfirmationDialog() {
    OsmeaComponents.showPopup(
      context: context,
      variant: PopupVariant.dialog,
      size: PopupSize.small,
      title: '💬 Confirmation',
      subtitle: 'Are you sure you want to proceed?',
      child: OsmeaComponents.text(
        'This action cannot be undone. Please confirm your choice.',
        textAlign: TextAlign.center,
        color: OsmeaColors.slate,
      ),
      footer: OsmeaComponents.row(
        children: [
          OsmeaComponents.expanded(
            child: OsmeaComponents.button(
              text: 'Cancel',
              variant: ButtonVariant.outlined,
              size: ButtonSize.medium,
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ),
          OsmeaComponents.sizedBox(width: 12),
          OsmeaComponents.expanded(
            child: OsmeaComponents.button(
              text: 'Confirm',
              variant: ButtonVariant.primary,
              size: ButtonSize.medium,
              onPressed: () {
                Navigator.of(context).pop(true);
                _showSuccessMessage();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showTooltipInfo() {
    OsmeaComponents.showPopup(
      context: context,
      variant: PopupVariant.tooltip,
      position: PopupPosition.top,
      animationType: PopupAnimationType.fade,
      autoDismiss: const Duration(seconds: 3),
      showCloseButton: false,
      backgroundColor: OsmeaColors.slate,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: OsmeaColors.silver, width: 1),
      ),
      child: OsmeaComponents.text(
        '💡 This is a tooltip that will auto-dismiss in 3 seconds.',
        textAlign: TextAlign.center,
        color: OsmeaColors.white,
      ),
    );
  }

  void _showFormDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    OsmeaComponents.showPopup(
      context: context,
      size: PopupSize.medium,
      title: '📝 User Information',
      subtitle: 'Please fill in your details',
      child: OsmeaComponents.column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OsmeaComponents.textField(
            controller: nameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            variant: TextFieldVariant.outlined,
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.textField(
            controller: emailController,
            label: 'Email Address',
            hint: 'Enter your email address',
            variant: TextFieldVariant.outlined,
            type: TextFieldType.email,
          ),
        ],
      ),
      footer: OsmeaComponents.row(
        children: [
          OsmeaComponents.expanded(
            child: OsmeaComponents.button(
              text: 'Cancel',
              variant: ButtonVariant.outlined,
              size: ButtonSize.medium,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          OsmeaComponents.sizedBox(width: 12),
          OsmeaComponents.expanded(
            child: OsmeaComponents.button(
              text: 'Save',
              variant: ButtonVariant.primary,
              size: ButtonSize.medium,
              onPressed: () {
                Navigator.of(context).pop();
                _showSuccessMessage('User information saved!');
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAutoDismissPopup() {
    OsmeaComponents.showPopup(
      context: context,
      variant: PopupVariant.alert,
      title: '⏰ Auto Dismiss',
      autoDismiss: const Duration(seconds: 3),
      showCloseButton: false,
      child: OsmeaComponents.column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OsmeaComponents.text(
            'This popup will automatically close in 3 seconds.',
            textAlign: TextAlign.center,
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  void _showSizeShowcase(PopupSize size) {
    OsmeaComponents.showPopup(
      context: context,
      size: size,
      title: '${_getSizeLabel(size)} Popup',
      subtitle:
          'This showcases the ${_getSizeLabel(size).toLowerCase()} size variant',
      child: OsmeaComponents.text(
        'This is a ${_getSizeLabel(size).toLowerCase()} sized popup. '
        'Notice how the width and padding adjust based on the size variant.',
        textAlign: TextAlign.center,
      ),
      footer: OsmeaComponents.button(
        text: 'Close',
        variant: ButtonVariant.primary,
        size: size == PopupSize.small ? ButtonSize.small : ButtonSize.medium,
        fullWidth: true,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showSuccessMessage([String? message]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: OsmeaComponents.text(
          message ?? 'Action completed successfully!',
          color: OsmeaColors.white,
        ),
        backgroundColor: OsmeaColors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
