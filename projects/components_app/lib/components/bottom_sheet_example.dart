import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 📋 **Bottom Sheet Example**
///
/// Example screen showing different sizes (S, M, L) and
/// style variants of the OSMEA Bottom Sheet component.

class BottomSheetExample extends StatefulWidget {
  const BottomSheetExample({super.key});

  @override
  State<BottomSheetExample> createState() => _BottomSheetExampleState();
}

class _BottomSheetExampleState extends State<BottomSheetExample> {
  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'bottom_sheet_example',
      ),
      body: OsmeaComponents.padding(
        padding: const EdgeInsets.all(16.0),
        child: OsmeaComponents.singleChildScrollView(
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OsmeaComponents.text(
                'Bottom Sheet Sizes',
                variant: OsmeaTextVariant.headlineMedium,
                fontWeight: FontWeight.bold,
              ),
              OsmeaComponents.sizedBox(height: 16),

              // Small Bottom Sheet
              _buildExampleButton(
                title: 'Small Bottom Sheet (S)',
                description: '25% screen height - Quick actions',
                onPressed: () => _showSmallBottomSheet(context),
                color: OsmeaColors.forestHeart,
              ),

              OsmeaComponents.sizedBox(height: 12),

              // Medium Bottom Sheet
              _buildExampleButton(
                title: 'Medium Bottom Sheet (M)',
                description: '50% screen height - Standard content',
                onPressed: () => _showMediumBottomSheet(context),
                color: OsmeaColors.nordicBlue,
              ),

              OsmeaComponents.sizedBox(height: 12),

              // Large Bottom Sheet
              _buildExampleButton(
                title: 'Large Bottom Sheet (L)',
                description: '75% screen height - Detailed content',
                onPressed: () => _showLargeBottomSheet(context),
                color: OsmeaColors.sunsetGlow,
              ),

              OsmeaComponents.sizedBox(height: 32),

              OsmeaComponents.text(
                'Bottom Sheet Variants',
                variant: OsmeaTextVariant.headlineMedium,
                fontWeight: FontWeight.bold,
              ),
              OsmeaComponents.sizedBox(height: 16),

              // Modal Bottom Sheet
              _buildExampleButton(
                title: 'Modal Bottom Sheet',
                description: 'With backdrop overlay',
                onPressed: () => _showModalBottomSheet(context),
                color: OsmeaColors.eclipse,
              ),

              OsmeaComponents.sizedBox(height: 12),

              // Custom Widget Example
              _buildExampleButton(
                title: 'Components App',
                description: 'Using MasterFabric Components',
                onPressed: () => _showWithOsmeaComponents(context),
                color: OsmeaColors.purple,
              ),

              OsmeaComponents.sizedBox(height: 12),

              // Action Bar Bottom Sheet
              _buildExampleButton(
                title: 'Action Bar Bottom Sheet',
                description: 'With left/right action buttons',
                onPressed: () => _showActionBarBottomSheet(context),
                color: OsmeaColors.nordicBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExampleButton({
    required String title,
    required String description,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return OsmeaComponents.container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            OsmeaComponents.text(
              title,
              variant: OsmeaTextVariant.titleMedium,
              fontWeight: FontWeight.bold,
              color: OsmeaColors.white,
            ),
            OsmeaComponents.sizedBox(height: 4),
            OsmeaComponents.text(
              description,
              variant: OsmeaTextVariant.bodyMedium,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ],
        ),
      ),
    );
  }

  void _showSmallBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => OsmeaComponents.bottomSheet(
        size: BottomSheetSize.small,
        title: 'Quick Actions',
        child: OsmeaComponents.column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OsmeaComponents.listItem(
              leading: const Icon(Icons.edit),
              title: OsmeaComponents.text('Edit'),
              onTap: () => Navigator.pop(context),
            ),
            OsmeaComponents.listItem(
              leading: const Icon(Icons.share),
              title: OsmeaComponents.text('Share'),
              onTap: () => Navigator.pop(context),
            ),
            OsmeaComponents.listItem(
              leading: const Icon(Icons.delete),
              title: OsmeaComponents.text('Delete'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showMediumBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => OsmeaComponents.bottomSheet(
        size: BottomSheetSize.medium,
        title: 'Settings',
        subtitle: 'Configure your preferences',
        headerActions: [
          OsmeaComponents.iconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        child: OsmeaComponents.column(
          children: [
            OsmeaComponents.listItem(
              leading: const Icon(Icons.notifications),
              title: OsmeaComponents.text('Notifications'),
              subtitle: OsmeaComponents.text('Receive push notifications'),
              trailing: OsmeaComponents.switchButton(
                value: true,
                onChanged: (value) {},
              ),
            ),
            OsmeaComponents.listItem(
              leading: const Icon(Icons.dark_mode),
              title: OsmeaComponents.text('Dark Mode'),
              subtitle: OsmeaComponents.text('Use dark theme'),
              trailing: OsmeaComponents.switchButton(
                value: false,
                onChanged: (value) {},
              ),
            ),
            OsmeaComponents.listItem(
              leading: const Icon(Icons.language),
              title: OsmeaComponents.text('Language'),
              subtitle: OsmeaComponents.text('English'),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            OsmeaComponents.listItem(
              leading: const Icon(Icons.storage),
              title: OsmeaComponents.text('Storage'),
              subtitle: OsmeaComponents.text('Manage app storage'),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
        footer: OsmeaComponents.padding(
          padding: const EdgeInsets.all(16),
          child: OsmeaComponents.button(
            text: 'Save Settings',
            onPressed: () => Navigator.pop(context),
            variant: ButtonVariant.primary,
            size: ButtonSize.large,
            backgroundColor: OsmeaColors.nordicBlue,
            textColor: OsmeaColors.white,
            fullWidth: true,
          ),
        ),
      ),
    );
  }

  void _showLargeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => OsmeaComponents.bottomSheet(
        size: BottomSheetSize.large,
        title: 'Detailed Form',
        subtitle: 'Fill in all information',
        child: OsmeaComponents.padding(
          padding: const EdgeInsets.all(16),
          child: OsmeaComponents.column(
            children: [
              OsmeaComponents.textField(
                label: 'Full Name',
                variant: TextFieldVariant.outlined,
                size: TextFieldSize.medium,
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.textField(
                label: 'Email',
                variant: TextFieldVariant.outlined,
                size: TextFieldSize.medium,
                type: TextFieldType.email,
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.textField(
                label: 'Phone',
                variant: TextFieldVariant.outlined,
                size: TextFieldSize.medium,
                type: TextFieldType.phone,
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.textField(
                label: 'Address',
                variant: TextFieldVariant.outlined,
                size: TextFieldSize.medium,
                maxLines: 3,
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text('Subscribe to newsletter'),
                trailing: OsmeaComponents.checkbox(
                  value: false,
                  onChanged: null,
                ),
              ),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text('Allow marketing emails'),
                trailing: OsmeaComponents.checkbox(
                  value: true,
                  onChanged: null,
                ),
              ),
            ],
          ),
        ),
        footer: OsmeaComponents.padding(
          padding: const EdgeInsets.all(16),
          child: OsmeaComponents.row(
            children: [
              OsmeaComponents.expanded(
                child: OsmeaComponents.button(
                  text: 'Cancel',
                  onPressed: () => Navigator.pop(context),
                  variant: ButtonVariant.outlined,
                  size: ButtonSize.medium,
                ),
              ),
              OsmeaComponents.sizedBox(width: 16),
              OsmeaComponents.expanded(
                child: OsmeaComponents.button(
                  text: 'Submit',
                  onPressed: () => Navigator.pop(context),
                  variant: ButtonVariant.primary,
                  size: ButtonSize.medium,
                  backgroundColor: OsmeaColors.forestHeart,
                  textColor: OsmeaColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => OsmeaComponents.container(
        decoration: const BoxDecoration(
          color: OsmeaColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: OsmeaComponents.bottomSheet(
          size: BottomSheetSize.medium,
          title: 'Modal Bottom Sheet',
          subtitle: 'This sheet has a backdrop overlay',
          child: OsmeaComponents.center(
            child: OsmeaComponents.column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 64,
                  color: OsmeaColors.nordicBlue,
                ),
                OsmeaComponents.sizedBox(height: 16),
                OsmeaComponents.text(
                  'This is a modal bottom sheet',
                  variant: OsmeaTextVariant.titleLarge,
                  fontWeight: FontWeight.bold,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Tap outside to dismiss',
                  variant: OsmeaTextVariant.bodyMedium,
                  color: OsmeaColors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showWithOsmeaComponents(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => OsmeaComponents.container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(20),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle
            OsmeaComponents.center(
              child: OsmeaComponents.container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            OsmeaComponents.sizedBox(height: 20),

            // Title with OSMEA Text
            OsmeaComponents.text(
              'MasterFabric Components',
              variant: OsmeaTextVariant.headlineMedium,
              color: OsmeaColors.nordicBlue,
            ),

            OsmeaComponents.sizedBox(height: 8),

            // Subtitle
            OsmeaComponents.text(
              'Created using MasterFabric components',
              variant: OsmeaTextVariant.bodyMedium,
              color: const Color(0xFF757575),
            ),

            OsmeaComponents.sizedBox(height: 24),

            // OSMEA Badge examples
            OsmeaComponents.row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OsmeaComponents.badge(
                  content: 'Small',
                  size: BadgeSize.small,
                  variant: BadgeVariant.success,
                ),
                OsmeaComponents.badge(
                  content: 'Medium',
                  size: BadgeSize.medium,
                  variant: BadgeVariant.primary,
                ),
                OsmeaComponents.badge(
                  content: 'Large',
                  size: BadgeSize.large,
                  variant: BadgeVariant.warning,
                ),
              ],
            ),

            OsmeaComponents.sizedBox(height: 24),

            // OSMEA Button examples
            OsmeaComponents.button(
              text: 'Primary Button',
              variant: ButtonVariant.primary,
              size: ButtonSize.medium,
              onPressed: () {},
            ),

            OsmeaComponents.sizedBox(height: 12),

            OsmeaComponents.button(
              text: 'Secondary Button',
              variant: ButtonVariant.secondary,
              size: ButtonSize.medium,
              onPressed: () {},
            ),

            OsmeaComponents.sizedBox(height: 12),

            OsmeaComponents.button(
              text: 'Success Button',
              variant: ButtonVariant.success,
              size: ButtonSize.medium,
              icon: const Icon(Icons.check),
              onPressed: () {},
            ),

            OsmeaComponents.expanded(
              child: OsmeaComponents.sizedBox(),
            ),

            // Close button
            OsmeaComponents.button(
              text: 'Close',
              variant: ButtonVariant.outlined,
              size: ButtonSize.large,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showActionBarBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => OsmeaComponents.bottomSheet(
        size: BottomSheetSize.medium,
        variant: BottomSheetVariant.actionBar,
        title: 'Multi-Step Form',
        subtitle: 'Step 1 of 3 - Personal Information',
        leftAction: OsmeaComponents.iconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
          variant: ButtonVariant.ghost,
          tooltip: 'Close',
        ),
        rightAction: OsmeaComponents.button(
          text: 'Next',
          icon: const Icon(Icons.arrow_forward),
          iconPosition: IconPosition.trailing,
          onPressed: () {
            Navigator.pop(context);
            _showActionBarStep2(context);
          },
          variant: ButtonVariant.primary,
          size: ButtonSize.small,
        ),
        showActionBorder: true,
        actionBarBackgroundColor: OsmeaColors.grey.shade50,
        actionBarBorderColor: OsmeaColors.grey.shade300,
        child: OsmeaComponents.padding(
          padding: const EdgeInsets.all(20),
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OsmeaComponents.textField(
                label: 'First Name',
                hint: 'Enter your first name',
                variant: TextFieldVariant.outlined,
                size: TextFieldSize.medium,
                isRequired: true,
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.textField(
                label: 'Last Name',
                hint: 'Enter your last name',
                variant: TextFieldVariant.outlined,
                size: TextFieldSize.medium,
                isRequired: true,
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.textField(
                label: 'Email',
                hint: 'Enter your email address',
                variant: TextFieldVariant.outlined,
                size: TextFieldSize.medium,
                type: TextFieldType.email,
                isRequired: true,
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.textField(
                label: 'Phone Number',
                hint: 'Enter your phone number',
                variant: TextFieldVariant.outlined,
                size: TextFieldSize.medium,
                type: TextFieldType.phone,
              ),
              OsmeaComponents.sizedBox(height: 24),
              OsmeaComponents.text(
                'Please fill in all required fields to continue to the next step.',
                variant: OsmeaTextVariant.bodySmall,
                color: OsmeaColors.grey.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showActionBarStep2(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => OsmeaComponents.bottomSheet(
        size: BottomSheetSize.medium,
        variant: BottomSheetVariant.actionBar,
        title: 'Multi-Step Form',
        subtitle: 'Step 2 of 3 - Preferences',
        leftAction: OsmeaComponents.iconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            _showActionBarBottomSheet(context);
          },
          variant: ButtonVariant.ghost,
          tooltip: 'Back',
        ),
        rightAction: OsmeaComponents.button(
          text: 'Finish',
          icon: const Icon(Icons.check),
          iconPosition: IconPosition.trailing,
          onPressed: () {
            Navigator.pop(context);
            _showActionBarStep3(context);
          },
          variant: ButtonVariant.success,
          size: ButtonSize.small,
        ),
        showActionBorder: true,
        actionBarBackgroundColor:
            OsmeaColors.forestHeart.withValues(alpha: 0.1),
        actionBarBorderColor: OsmeaColors.forestHeart.withValues(alpha: 0.3),
        child: OsmeaComponents.padding(
          padding: const EdgeInsets.all(20),
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OsmeaComponents.listItem(
                title: OsmeaComponents.text('Email Notifications'),
                subtitle: OsmeaComponents.text('Receive updates via email'),
                trailing: OsmeaComponents.switchButton(
                  value: true,
                  onChanged: (value) {},
                ),
              ),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text('SMS Notifications'),
                subtitle: OsmeaComponents.text('Receive updates via SMS'),
                trailing: OsmeaComponents.switchButton(
                  value: false,
                  onChanged: (value) {},
                ),
              ),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text('Marketing Updates'),
                subtitle: OsmeaComponents.text('Receive promotional content'),
                trailing: OsmeaComponents.switchButton(
                  value: false,
                  onChanged: (value) {},
                ),
              ),
              OsmeaComponents.sizedBox(height: 24),
              OsmeaComponents.text(
                'You can change these preferences later in your account settings.',
                variant: OsmeaTextVariant.bodySmall,
                color: OsmeaColors.grey.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showActionBarStep3(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => OsmeaComponents.bottomSheet(
        size: BottomSheetSize.medium,
        variant: BottomSheetVariant.actionBar,
        title: 'Multi-Step Form',
        subtitle: 'Step 3 of 3 - Complete',
        leftAction: OsmeaComponents.iconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            _showActionBarStep2(context);
          },
          variant: ButtonVariant.ghost,
          tooltip: 'Back',
        ),
        rightAction: OsmeaComponents.button(
          text: 'Done',
          icon: const Icon(Icons.done_all),
          iconPosition: IconPosition.trailing,
          onPressed: () => Navigator.pop(context),
          variant: ButtonVariant.success,
          size: ButtonSize.small,
        ),
        showActionBorder: true,
        actionBarBackgroundColor: OsmeaColors.sunsetGlow.withValues(alpha: 0.1),
        actionBarBorderColor: OsmeaColors.sunsetGlow.withValues(alpha: 0.3),
        child: OsmeaComponents.padding(
          padding: const EdgeInsets.all(20),
          child: OsmeaComponents.center(
            child: OsmeaComponents.column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 80,
                  color: OsmeaColors.forestHeart,
                ),
                OsmeaComponents.sizedBox(height: 24),
                OsmeaComponents.text(
                  'Form Completed Successfully!',
                  variant: OsmeaTextVariant.headlineMedium,
                  fontWeight: FontWeight.bold,
                  color: OsmeaColors.forestHeart,
                ),
                OsmeaComponents.sizedBox(height: 12),
                OsmeaComponents.text(
                  'Thank you for completing the multi-step form. Your information has been saved successfully.',
                  variant: OsmeaTextVariant.bodyMedium,
                  color: OsmeaColors.grey.shade600,
                  textAlign: TextAlign.center,
                ),
                OsmeaComponents.sizedBox(height: 24),
                OsmeaComponents.badge(
                  content: 'Complete',
                  variant: BadgeVariant.success,
                  size: BadgeSize.large,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
