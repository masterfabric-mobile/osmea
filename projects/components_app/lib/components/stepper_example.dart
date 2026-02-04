import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

class StepperExample extends StatefulWidget {
  const StepperExample({super.key});

  @override
  State<StepperExample> createState() => _StepperExampleState();
}

class _StepperExampleState extends State<StepperExample> {
  int _horizontalStepperStep = 0;
  int _restrictedStepperStep = 0;
  int _verticalStepperStep = 0;
  int _dotsStepperStep = 0;
  int _numberedOnlyStepperStep = 0;
  int _dotsOnlyStepperStep = 0;

  static const int _stepsCount = 3;

  void _advanceStep(ValueSetter<int> setCurrentStep, int stepIndex) {
    if (stepIndex < _stepsCount - 1) {
      setCurrentStep((stepIndex + 1).clamp(0, _stepsCount - 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'stepper_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OsmeaComponents.text(
              'Horizontal Stepper - Click any step to navigate',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.text(
              'Notice: Completed steps show check icons and green color',
              fontSize: 14,
              color: OsmeaColors.silver,
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.stepper(
              key: ValueKey('horizontal_$_horizontalStepperStep'),
              currentStep: _horizontalStepperStep,
              steps: [
                OsmeaStep(
                  label: 'Personal',
                  content: _buildStepContent(
                    context,
                    'Enter your personal information',
                    Icons.person,
                    onContinue: () => _advanceStep(
                        (s) => setState(() => _horizontalStepperStep = s), 0),
                    isLastStep: false,
                  ),
                ),
                OsmeaStep(
                  label: 'Contact',
                  content: _buildStepContent(
                    context,
                    'Provide your contact information',
                    Icons.contact_mail,
                    onContinue: () => _advanceStep(
                        (s) => setState(() => _horizontalStepperStep = s), 1),
                    isLastStep: false,
                  ),
                ),
                OsmeaStep(
                  label: 'Review',
                  content: _buildStepContent(
                    context,
                    'Review and submit your information',
                    Icons.check_circle,
                    isLastStep: true,
                  ),
                ),
              ],
              orientation: ComponentOrientation.horizontal,
              allowStepTapping: true,
              stepperStyle: StepperStyle.numberedWithLinesAndLabels,
              size: ComponentSize.medium,
              appearance: ComponentAppearance.filled,
              onStepChanged: (step) {
                setState(() => _horizontalStepperStep = step);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: OsmeaComponents.text('Step changed to: $step')),
                );
              },
            ),
            OsmeaComponents.sizedBox(height: 40),
            OsmeaComponents.text(
              'Restricted Stepper - No Step Clicking',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.stepper(
              key: ValueKey('restricted_$_restrictedStepperStep'),
              currentStep: _restrictedStepperStep,
              steps: [
                OsmeaStep(
                  label: 'Step 1',
                  content: _buildStepContent(
                    context,
                    'First step - cannot click other steps',
                    Icons.looks_one,
                    onContinue: () => _advanceStep(
                        (s) => setState(() => _restrictedStepperStep = s), 0),
                    isLastStep: false,
                  ),
                ),
                OsmeaStep(
                  label: 'Step 2',
                  content: _buildStepContent(
                    context,
                    'Second step - sequential only',
                    Icons.looks_two,
                    onContinue: () => _advanceStep(
                        (s) => setState(() => _restrictedStepperStep = s), 1),
                    isLastStep: false,
                  ),
                ),
                OsmeaStep(
                  label: 'Step 3',
                  content: _buildStepContent(
                    context,
                    'Third step - linear progression',
                    Icons.looks_3,
                    isLastStep: true,
                  ),
                ),
              ],
              orientation: ComponentOrientation.horizontal,
              allowStepTapping: false, // Disable free step navigation
              size: ComponentSize.medium,
              appearance: ComponentAppearance.ghost,
              onStepChanged: (step) =>
                  setState(() => _restrictedStepperStep = step),
            ),
            OsmeaComponents.sizedBox(height: 40),
            OsmeaComponents.text(
              'Vertical Stepper',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.sizedBox(
              height: 300,
              child: OsmeaComponents.stepper(
                key: ValueKey('vertical_$_verticalStepperStep'),
                currentStep: _verticalStepperStep,
                onStepChanged: (step) =>
                    setState(() => _verticalStepperStep = step),
                steps: [
                  OsmeaStep(
                    label: 'Setup',
                    content: _buildStepContent(
                      context,
                      'Initialize your account',
                      Icons.settings,
                      onContinue: () => _advanceStep(
                          (s) => setState(() => _verticalStepperStep = s), 0),
                      isLastStep: false,
                    ),
                  ),
                  OsmeaStep(
                    label: 'Configure',
                    content: _buildStepContent(
                      context,
                      'Configure your preferences',
                      Icons.tune,
                      onContinue: () => _advanceStep(
                          (s) => setState(() => _verticalStepperStep = s), 1),
                      isLastStep: false,
                    ),
                  ),
                  OsmeaStep(
                    label: 'Complete',
                    content: _buildStepContent(
                      context,
                      'Finalize setup',
                      Icons.done,
                      isLastStep: true,
                    ),
                  ),
                ],
                orientation: ComponentOrientation.vertical,
                size: ComponentSize.small,
                appearance: ComponentAppearance.outlined,
              ),
            ),
            OsmeaComponents.sizedBox(height: 40),
            OsmeaComponents.text(
              'Dots with Lines Style',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.stepper(
              key: ValueKey('dots_$_dotsStepperStep'),
              currentStep: _dotsStepperStep,
              onStepChanged: (step) => setState(() => _dotsStepperStep = step),
              steps: [
                OsmeaStep(
                  label: 'Start',
                  content: _buildStepContent(
                    context,
                    'Begin your journey with dots and lines',
                    Icons.start,
                    onContinue: () => _advanceStep(
                        (s) => setState(() => _dotsStepperStep = s), 0),
                    isLastStep: false,
                  ),
                ),
                OsmeaStep(
                  label: 'Process',
                  content: _buildStepContent(
                    context,
                    'Continue with dot-style progression',
                    Icons.trending_up,
                    onContinue: () => _advanceStep(
                        (s) => setState(() => _dotsStepperStep = s), 1),
                    isLastStep: false,
                  ),
                ),
                OsmeaStep(
                  label: 'Finish',
                  content: _buildStepContent(
                    context,
                    'Complete with check mark',
                    Icons.flag,
                    isLastStep: true,
                  ),
                ),
              ],
              stepperStyle: StepperStyle.dotsWithLinesAndLabels,
              allowStepTapping: true,
            ),
            OsmeaComponents.sizedBox(height: 40),
            OsmeaComponents.text(
              'Numbered Only Style',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.stepper(
              key: ValueKey('numbered_$_numberedOnlyStepperStep'),
              currentStep: _numberedOnlyStepperStep,
              onStepChanged: (step) =>
                  setState(() => _numberedOnlyStepperStep = step),
              steps: [
                OsmeaStep(
                  label: 'First',
                  content: _buildStepContent(
                    context,
                    'Simple numbered steps without lines',
                    Icons.filter_1,
                    onContinue: () => _advanceStep(
                        (s) => setState(() => _numberedOnlyStepperStep = s), 0),
                    isLastStep: false,
                  ),
                ),
                OsmeaStep(
                  label: 'Second',
                  content: _buildStepContent(
                    context,
                    'Clean numbered design',
                    Icons.filter_2,
                    onContinue: () => _advanceStep(
                        (s) => setState(() => _numberedOnlyStepperStep = s), 1),
                    isLastStep: false,
                  ),
                ),
                OsmeaStep(
                  label: 'Third',
                  content: _buildStepContent(
                    context,
                    'Minimalist approach',
                    Icons.filter_3,
                    isLastStep: true,
                  ),
                ),
              ],
              stepperStyle: StepperStyle.numberedOnly,
              allowStepTapping: true,
            ),
            OsmeaComponents.sizedBox(height: 40),
            OsmeaComponents.text(
              'Dots with Lines Only (No Labels)',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.stepper(
              key: ValueKey('dotsOnly_$_dotsOnlyStepperStep'),
              currentStep: _dotsOnlyStepperStep,
              onStepChanged: (step) =>
                  setState(() => _dotsOnlyStepperStep = step),
              steps: [
                OsmeaStep(
                  label: 'Hidden',
                  content: _buildStepContent(
                    context,
                    'Compact dot design with connecting lines',
                    Icons.circle,
                    onContinue: () => _advanceStep(
                        (s) => setState(() => _dotsOnlyStepperStep = s), 0),
                    isLastStep: false,
                  ),
                ),
                OsmeaStep(
                  label: 'Hidden',
                  content: _buildStepContent(
                    context,
                    'Space-efficient progression',
                    Icons.circle_outlined,
                    onContinue: () => _advanceStep(
                        (s) => setState(() => _dotsOnlyStepperStep = s), 1),
                    isLastStep: false,
                  ),
                ),
                OsmeaStep(
                  label: 'Hidden',
                  content: _buildStepContent(
                    context,
                    'Clean line completion',
                    Icons.check_circle,
                    isLastStep: true,
                  ),
                ),
              ],
              stepperStyle: StepperStyle.dotsWithLines,
              allowStepTapping: true,
            ),
            OsmeaComponents.sizedBox(height: 40),
            OsmeaComponents.text(
              'OSMEA Colors Showcase',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.text(
              'Shows OSMEA Colors used in stepper states',
              fontSize: 14,
              color: OsmeaColors.silver,
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildColorShowcase(
                    'Success', OsmeaColors.forestHeart, Icons.check),
                _buildColorShowcase(
                    'Error', OsmeaColors.sunsetGlow, Icons.error),
                _buildColorShowcase(
                    'Warning', OsmeaColors.goldenHour, Icons.warning),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(
    BuildContext context,
    String description,
    IconData icon, {
    VoidCallback? onContinue,
    bool isLastStep = false,
  }) {
    return OsmeaComponents.container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: OsmeaColors.snow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: OsmeaColors.silver),
      ),
      child: OsmeaComponents.column(
        children: [
          Icon(icon, size: 48, color: OsmeaColors.nordicBlue),
          OsmeaComponents.sizedBox(height: 12),
          OsmeaComponents.text(
            description,
            textAlign: TextAlign.center,
            fontSize: 16,
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.button(
            text: isLastStep ? 'Submit' : 'Continue',
            onPressed: onContinue,
            variant: ButtonVariant.primary,
            size: ButtonSize.medium,
          ),
        ],
      ),
    );
  }

  Widget _buildColorShowcase(String label, Color color, IconData icon) {
    return OsmeaComponents.column(
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 24,
          child: Icon(icon, color: OsmeaColors.white, size: 20),
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.text(
          label,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
