import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

class PhonePickerExample extends StatefulWidget {
  const PhonePickerExample({super.key});

  @override
  State<PhonePickerExample> createState() => _PhonePickerExampleState();
}

class _PhonePickerExampleState extends State<PhonePickerExample> {
  final TextEditingController phoneController = TextEditingController();
  String selectedCountryCode = 'TR';
  String phoneNumber = '';

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void _onCountryChanged(String countryCode) {
    setState(() {
      selectedCountryCode = countryCode;
    });

    // Show selected country info in snackbar
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: OsmeaComponents.text(
          'Selected country: $countryCode',
          color: OsmeaColors.white,
          fontSize: 14,
        ),
        backgroundColor: OsmeaColors.nordicBlue,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _onPhoneChanged(String phone) {
    setState(() {
      phoneNumber = phone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'phone_picker_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            OsmeaComponents.container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    OsmeaColors.nordicBlue.withValues(alpha: 0.1),
                    OsmeaColors.azureWave.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: OsmeaColors.nordicBlue.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.row(
                    children: [
                      Icon(
                        Icons.phone_android,
                        color: OsmeaColors.nordicBlue,
                        size: 24,
                      ),
                      OsmeaComponents.sizedBox(width: 8),
                      OsmeaComponents.expanded(
                        child: OsmeaComponents.text(
                          'OSMEA Phone Picker',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: OsmeaColors.nordicBlue,
                        ),
                      ),
                    ],
                  ),
                  OsmeaComponents.sizedBox(height: 8),
                  OsmeaComponents.text(
                    'A complete phone number input component with integrated country selection and flag display.',
                    fontSize: 14,
                    color: OsmeaColors.slate,
                  ),
                ],
              ),
            ),

            OsmeaComponents.sizedBox(height: 32),

            // OSMEA Phone Picker Section
            OsmeaComponents.text(
              'OSMEA Phone Picker Component',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: OsmeaColors.nordicBlue,
            ),
            OsmeaComponents.sizedBox(height: 24),
            // OSMEA Phone Picker with country dropdown
            OsmeaComponents.phonePicker(
              controller: phoneController,
              label: 'Phone Number',
              hint: 'Enter your phone number (e.g., 123 456 789)',
              variant: TextFieldVariant.outlined,
              size: TextFieldSize.medium,
              initialCountryCode: selectedCountryCode,
              onCountryChanged: _onCountryChanged,
              onPhoneChanged: _onPhoneChanged,
              showCountryFlag: true,
              suffixIcon: Icon(
                Icons.phone,
                color: OsmeaColors.nordicBlue,
                size: 20,
              ),
              flagSize: 20,
            ),
            OsmeaComponents.sizedBox(height: 24),
            // Info card
            OsmeaComponents.container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: OsmeaColors.azureWave.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: OsmeaColors.azureWave.withValues(alpha: 0.3),
                ),
              ),
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: OsmeaColors.azureWave,
                        size: 20,
                      ),
                      OsmeaComponents.sizedBox(width: 8),
                      OsmeaComponents.text(
                        'Info',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: OsmeaColors.azureWave,
                      ),
                    ],
                  ),
                  OsmeaComponents.sizedBox(height: 8),
                  OsmeaComponents.text(
                    'When you select a country from the dropdown, that country\'s dial code will be displayed in a snackbar. The selected country is automatically shown as a prefix in the phone number field. Numbers are automatically grouped in 3-3-3 format (e.g., 123 456 789) with a maximum of 9 digits.',
                    fontSize: 13,
                    color: OsmeaColors.slate,
                  ),
                ],
              ),
            ),

            OsmeaComponents.sizedBox(height: 24),

            // Phone number result display
            if (phoneNumber.isNotEmpty)
              OsmeaComponents.container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: OsmeaColors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: OsmeaColors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OsmeaComponents.row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: OsmeaColors.green,
                          size: 20,
                        ),
                        OsmeaComponents.sizedBox(width: 8),
                        OsmeaComponents.text(
                          'Phone Number Result',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: OsmeaColors.green,
                        ),
                      ],
                    ),
                    OsmeaComponents.sizedBox(height: 8),
                    OsmeaComponents.text(
                      'Country: $selectedCountryCode',
                      fontSize: 14,
                      color: OsmeaColors.thunder,
                    ),
                    OsmeaComponents.sizedBox(height: 4),
                    OsmeaComponents.text(
                      'Phone Number: $phoneNumber',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: OsmeaColors.thunder,
                    ),
                  ],
                ),
              ),

            OsmeaComponents.sizedBox(height: 32),

            // Component Features Info
            OsmeaComponents.container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: OsmeaColors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: OsmeaColors.green.withValues(alpha: 0.3),
                ),
              ),
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: OsmeaColors.green,
                        size: 20,
                      ),
                      OsmeaComponents.sizedBox(width: 8),
                      OsmeaComponents.text(
                        'OSMEA Phone Picker Features',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: OsmeaColors.green,
                      ),
                    ],
                  ),
                  OsmeaComponents.sizedBox(height: 8),
                  OsmeaComponents.text(
                    '• Integrated country flag and dial code dropdown\n• Modal bottom sheet country selection\n• CoreTextField foundation with full OSMEA design compliance\n• Embedded dropdown display (e.g. Nigeria 🇳🇬 +234)\n• Custom country list support\n• Search functionality for countries\n• Numeric keyboard only (no foreign characters)\n• Maximum 9 digits input limit\n• Automatic 3-3-3 number grouping (123 456 789)\n• Real-time input validation and formatting',
                    fontSize: 13,
                    color: OsmeaColors.slate,
                  ),
                ],
              ),
            ),

            OsmeaComponents.sizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
