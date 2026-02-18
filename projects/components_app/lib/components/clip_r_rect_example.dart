import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// ✂️ **OSMEA ClipRRect Examples**
///
/// This file demonstrates various ways to use the OSMEA ClipRRect component.
/// Interactive and comprehensive examples showcasing all ClipRRect capabilities.
///
class ClipRRectExample extends StatefulWidget {
  const ClipRRectExample({Key? key}) : super(key: key);

  @override
  State<ClipRRectExample> createState() => _ClipRRectExampleState();
}

class _ClipRRectExampleState extends State<ClipRRectExample> {
  // Interactive controls
  double borderRadiusValue = 16.0;
  Clip clipBehavior = Clip.antiAlias;
  bool topLeft = true;
  bool topRight = true;
  bool bottomLeft = true;
  bool bottomRight = true;

  // Border radius types
  int selectedRadiusType = 0; // 0: circular, 1: only, 2: all

  final List<String> radiusTypeLabels = [
    'BorderRadius.circular',
    'BorderRadius.only',
    'BorderRadius.all',
  ];

  final List<Clip> clipBehaviorOptions = [
    Clip.antiAlias,
    Clip.hardEdge,
    Clip.none,
  ];

  final Map<Clip, String> clipBehaviorLabels = {
    Clip.antiAlias: 'Clip.antiAlias',
    Clip.hardEdge: 'Clip.hardEdge',
    Clip.none: 'Clip.none',
  };

  final Map<Clip, String> clipBehaviorDescriptions = {
    Clip.antiAlias: 'Smooth edges with anti-aliasing',
    Clip.hardEdge: 'Sharp edges, better performance',
    Clip.none: 'No clipping applied',
  };

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'clip_r_rect_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        child: OsmeaComponents.padding(
          padding: const EdgeInsets.all(16),
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OsmeaComponents.text(
                '✂️ Interactive ClipRRect',
                textStyle: OsmeaTextStyle.titleLarge(context)
                    .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(
                'Explore all ClipRRect features with interactive controls.',
                textStyle:
                    OsmeaTextStyle.bodyMedium(context).copyWith(fontSize: 14),
                color: OsmeaColors.pewter,
                textAlign: TextAlign.center,
              ),
              OsmeaComponents.sizedBox(height: 24),

              // Interactive Controls Card
              _buildControlsCard(),
              OsmeaComponents.sizedBox(height: 24),

              // Live Examples Card
              _buildLiveExamplesCard(),
              OsmeaComponents.sizedBox(height: 24),

              // Use Cases Card
              _buildUseCasesCard(),
              OsmeaComponents.sizedBox(height: 24),

              // Gallery Card
              _buildGalleryCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlsCard() {
    return Card(
      elevation: 4,
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(20),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.text(
              '🎛️ Interactive Controls',
              textStyle: OsmeaTextStyle.titleMedium(context)
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 20),

            // Radius Type Selector
            _buildRadiusTypeSelector(),
            OsmeaComponents.sizedBox(height: 20),

            // Radius Value Slider
            _buildRadiusSlider(),
            OsmeaComponents.sizedBox(height: 20),

            // Corner Selectors (only for BorderRadius.only)
            if (selectedRadiusType == 1) ...[
              _buildCornerSelectors(),
              OsmeaComponents.sizedBox(height: 20),
            ],

            // Clip Behavior Selector
            _buildClipBehaviorSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildRadiusTypeSelector() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          'Border Radius Type:',
          textStyle: OsmeaTextStyle.bodyLarge(context)
              .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        OsmeaComponents.sizedBox(height: 12),
        OsmeaComponents.wrap(
          spacing: 8,
          children: List.generate(radiusTypeLabels.length, (index) {
            final isSelected = selectedRadiusType == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedRadiusType = index;
                });
              },
              child: OsmeaComponents.container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      isSelected ? OsmeaColors.nordicBlue : OsmeaColors.white,
                  border: Border.all(
                    color: isSelected
                        ? OsmeaColors.nordicBlue
                        : OsmeaColors.silver,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: OsmeaComponents.text(
                  radiusTypeLabels[index],
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    color: isSelected ? OsmeaColors.white : OsmeaColors.slate,
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildRadiusSlider() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OsmeaComponents.text(
              'Border Radius:',
              textStyle: OsmeaTextStyle.bodyLarge(context)
                  .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.text(
              '${borderRadiusValue.toInt()}px',
              textStyle: OsmeaTextStyle.bodyLarge(context)
                  .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
              color: OsmeaColors.nordicBlue,
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 8),
        Slider(
          value: borderRadiusValue,
          min: 0,
          max: 50,
          divisions: 50,
          activeColor: OsmeaColors.nordicBlue,
          inactiveColor: OsmeaColors.silver,
          onChanged: (value) {
            setState(() {
              borderRadiusValue = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCornerSelectors() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          'Select Corners:',
          textStyle: OsmeaTextStyle.bodyLarge(context)
              .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        OsmeaComponents.sizedBox(height: 12),
        OsmeaComponents.row(
          children: [
            OsmeaComponents.expanded(
              child: _buildCornerCheckbox('Top Left', topLeft, (value) {
                setState(() {
                  topLeft = value ?? false;
                });
              }),
            ),
            OsmeaComponents.expanded(
              child: _buildCornerCheckbox('Top Right', topRight, (value) {
                setState(() {
                  topRight = value ?? false;
                });
              }),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.row(
          children: [
            OsmeaComponents.expanded(
              child: _buildCornerCheckbox('Bottom Left', bottomLeft, (value) {
                setState(() {
                  bottomLeft = value ?? false;
                });
              }),
            ),
            OsmeaComponents.expanded(
              child: _buildCornerCheckbox('Bottom Right', bottomRight, (value) {
                setState(() {
                  bottomRight = value ?? false;
                });
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCornerCheckbox(
      String label, bool value, Function(bool?) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: OsmeaComponents.row(
        mainAxisSize: MainAxisSize.min,
        children: [
          OsmeaComponents.checkbox(
            value: value,
            onChanged: onChanged,
            variant: CheckboxVariant.simple,
            size: CheckboxSize.small,
          ),
          OsmeaComponents.sizedBox(width: 8),
          OsmeaComponents.flexible(
            child: OsmeaComponents.text(
              label,
              textStyle:
                  OsmeaTextStyle.bodySmall(context).copyWith(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClipBehaviorSelector() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          'Clip Behavior:',
          textStyle: OsmeaTextStyle.bodyLarge(context)
              .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        OsmeaComponents.sizedBox(height: 12),
        OsmeaComponents.container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: OsmeaColors.silver),
            borderRadius: BorderRadius.circular(8),
            color: OsmeaColors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Clip>(
              value: clipBehavior,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: OsmeaColors.nordicBlue),
              style: OsmeaTextStyle.bodyMedium(context)
                  .copyWith(color: OsmeaColors.slate, fontSize: 14),
              dropdownColor: OsmeaColors.white,
              onChanged: (Clip? newValue) {
                if (newValue != null) {
                  setState(() {
                    clipBehavior = newValue;
                  });
                }
              },
              items:
                  clipBehaviorOptions.map<DropdownMenuItem<Clip>>((Clip value) {
                return DropdownMenuItem<Clip>(
                  value: value,
                  child: OsmeaComponents.text(
                    clipBehaviorLabels[value] ?? '',
                    textStyle: OsmeaTextStyle.bodyMedium(context)
                        .copyWith(fontSize: 14),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.text(
          clipBehaviorDescriptions[clipBehavior] ?? '',
          textStyle: OsmeaTextStyle.bodySmall(context).copyWith(fontSize: 12),
          color: OsmeaColors.pewter,
        ),
      ],
    );
  }

  Widget _buildLiveExamplesCard() {
    return Card(
      elevation: 4,
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(20),
        child: OsmeaComponents.column(
          children: [
            OsmeaComponents.text(
              '🎬 Live Showcase',
              textStyle: OsmeaTextStyle.titleMedium(context)
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 20),

            // Current settings display
            _buildCurrentSettingsDisplay(),
            OsmeaComponents.sizedBox(height: 20),

            // Live examples row
            OsmeaComponents.wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _buildLiveExample('Text Content', _buildTextContent()),
                _buildLiveExample('Image Style', _buildImageContent()),
                _buildLiveExample('Gradient', _buildGradientContent()),
              ],
            ),

            OsmeaComponents.sizedBox(height: 20),

            // Large example
            _buildLargeExample(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentSettingsDisplay() {
    String radiusText = '';
    switch (selectedRadiusType) {
      case 0:
        radiusText = 'BorderRadius.circular(${borderRadiusValue.toInt()})';
        break;
      case 1:
        radiusText = 'BorderRadius.only(...)';
        break;
      case 2:
        radiusText =
            'BorderRadius.all(Radius.circular(${borderRadiusValue.toInt()}))';
        break;
    }

    return OsmeaComponents.container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OsmeaColors.oceanMist.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: OsmeaColors.silver),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            'Current Settings:',
            textStyle: OsmeaTextStyle.bodyLarge(context)
                .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.text(
            radiusText,
            textStyle: OsmeaTextStyle.bodySmall(context)
                .copyWith(fontSize: 12, fontFamily: 'monospace'),
            color: OsmeaColors.nordicBlue,
          ),
          OsmeaComponents.text(
            clipBehaviorLabels[clipBehavior] ?? '',
            textStyle: OsmeaTextStyle.bodySmall(context)
                .copyWith(fontSize: 12, fontFamily: 'monospace'),
            color: OsmeaColors.forestHeart,
          ),
        ],
      ),
    );
  }

  Widget _buildLiveExample(String label, Widget content) {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.text(
          label,
          textStyle: OsmeaTextStyle.bodySmall(context)
              .copyWith(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.clipRRect(
          borderRadius: _getCurrentBorderRadius(),
          clipBehavior: clipBehavior,
          child: content,
        ),
      ],
    );
  }

  Widget _buildTextContent() {
    return OsmeaComponents.container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: OsmeaColors.sunsetGlow,
      ),
      child: OsmeaComponents.center(
        child: OsmeaComponents.column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.text_fields,
              color: OsmeaColors.white,
              size: 32,
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.text(
              'TEXT\nCONTENT',
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                color: OsmeaColors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    return OsmeaComponents.container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [OsmeaColors.forestHeart, OsmeaColors.meadow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: OsmeaComponents.center(
        child: OsmeaComponents.column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.image,
              color: OsmeaColors.white,
              size: 32,
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.text(
              'IMAGE\nSTYLE',
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                color: OsmeaColors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientContent() {
    return OsmeaComponents.container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            OsmeaColors.nordicBlue,
            OsmeaColors.crystalBay,
            OsmeaColors.oceanMist
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: OsmeaComponents.center(
        child: OsmeaComponents.column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.gradient,
              color: OsmeaColors.white,
              size: 32,
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.text(
              'GRADIENT\nDESIGN',
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                color: OsmeaColors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeExample() {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.text(
          'Large Interactive:',
          textStyle: OsmeaTextStyle.bodyLarge(context)
              .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        OsmeaComponents.sizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final double containerWidth = constraints.maxWidth;
            final double containerHeight = containerWidth > 600 ? 200 : 160;

            return OsmeaComponents.clipRRect(
              borderRadius: _getCurrentBorderRadius(),
              clipBehavior: clipBehavior,
              child: OsmeaComponents.container(
                width: double.infinity,
                height: containerHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      OsmeaColors.sunsetGlow,
                      OsmeaColors.goldenHour,
                      OsmeaColors.desertSand,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: OsmeaComponents.center(
                  child: OsmeaComponents.column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: OsmeaColors.white,
                        size: 48,
                      ),
                      OsmeaComponents.sizedBox(height: 16),
                      OsmeaComponents.text(
                        'CLIP RRECT',
                        textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                          color: OsmeaColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      OsmeaComponents.sizedBox(height: 8),
                      OsmeaComponents.text(
                        'Radius: {borderRadiusValue.toInt()}px',
                        textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                          color: OsmeaColors.white,
                          fontSize: 14,
                        ),
                      ),
                      OsmeaComponents.text(
                        clipBehaviorLabels[clipBehavior] ?? '',
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: OsmeaColors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildUseCasesCard() {
    return Card(
      elevation: 4,
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(20),
        child: OsmeaComponents.column(
          children: [
            OsmeaComponents.text(
              '💼 Real-World Use Cases',
              textStyle: OsmeaTextStyle.titleMedium(context)
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 20),
            OsmeaComponents.wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _buildUseCaseExample('Profile Avatar', _buildProfileAvatar()),
                _buildUseCaseExample('Card Component', _buildCardComponent()),
                _buildUseCaseExample('Button Design', _buildButtonDesign()),
                _buildUseCaseExample('Image Gallery', _buildImageGallery()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUseCaseExample(String label, Widget content) {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.text(
          label,
          textStyle: OsmeaTextStyle.bodySmall(context)
              .copyWith(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        OsmeaComponents.sizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildProfileAvatar() {
    return OsmeaComponents.clipRRect(
      borderRadius: BorderRadius.circular(35),
      child: OsmeaComponents.container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [OsmeaColors.nordicBlue, OsmeaColors.crystalBay],
          ),
        ),
        child: OsmeaComponents.center(
          child: const Icon(
            Icons.person,
            color: OsmeaColors.white,
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildCardComponent() {
    return OsmeaComponents.clipRRect(
      borderRadius: BorderRadius.circular(12),
      child: OsmeaComponents.container(
        width: 100,
        height: 80,
        decoration: const BoxDecoration(
          color: OsmeaColors.white,
          boxShadow: [
            BoxShadow(
              color: OsmeaColors.shadowLight,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: OsmeaComponents.padding(
          padding: const EdgeInsets.all(8),
          child: OsmeaComponents.column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.credit_card,
                color: OsmeaColors.nordicBlue,
                size: 24,
              ),
              OsmeaComponents.sizedBox(height: 4),
              OsmeaComponents.text(
                'Card',
                textStyle: OsmeaTextStyle.bodySmall(context)
                    .copyWith(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonDesign() {
    return OsmeaComponents.clipRRect(
      borderRadius: BorderRadius.circular(20),
      child: OsmeaComponents.container(
        width: 100,
        height: 40,
        decoration: BoxDecoration(
          color: OsmeaColors.forestHeart,
        ),
        child: OsmeaComponents.center(
          child: OsmeaComponents.text(
            'BUTTON',
            textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    return OsmeaComponents.clipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      child: OsmeaComponents.container(
        width: 100,
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [OsmeaColors.sunsetGlow, OsmeaColors.goldenHour],
          ),
        ),
        child: OsmeaComponents.center(
          child: OsmeaComponents.column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.photo_library,
                color: OsmeaColors.white,
                size: 24,
              ),
              OsmeaComponents.sizedBox(height: 4),
              OsmeaComponents.text(
                'Gallery',
                textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                  color: OsmeaColors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryCard() {
    return Card(
      elevation: 4,
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(20),
        child: OsmeaComponents.column(
          children: [
            OsmeaComponents.text(
              '🎨 Border Radius Gallery',
              textStyle: OsmeaTextStyle.titleMedium(context)
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 20),

            // Quick gallery of different radius examples
            OsmeaComponents.wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildGalleryItem(0, 'None'),
                _buildGalleryItem(4, 'Subtle'),
                _buildGalleryItem(8, 'Small'),
                _buildGalleryItem(16, 'Medium'),
                _buildGalleryItem(24, 'Large'),
                _buildGalleryItem(50, 'Circle'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryItem(double radius, String label) {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.clipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: OsmeaComponents.container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  OsmeaColors.nordicBlue.withValues(alpha: 0.7),
                  OsmeaColors.crystalBay.withValues(alpha: 0.7),
                ],
              ),
            ),
            child: OsmeaComponents.center(
              child: OsmeaComponents.text(
                '${radius.toInt()}',
                textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                  color: OsmeaColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        OsmeaComponents.sizedBox(height: 4),
        OsmeaComponents.text(
          label,
          textStyle: OsmeaTextStyle.bodySmall(context).copyWith(fontSize: 10),
        ),
      ],
    );
  }

  BorderRadius _getCurrentBorderRadius() {
    final radius = Radius.circular(borderRadiusValue);

    switch (selectedRadiusType) {
      case 0: // circular
        return BorderRadius.circular(borderRadiusValue);
      case 1: // only
        return BorderRadius.only(
          topLeft: topLeft ? radius : Radius.zero,
          topRight: topRight ? radius : Radius.zero,
          bottomLeft: bottomLeft ? radius : Radius.zero,
          bottomRight: bottomRight ? radius : Radius.zero,
        );
      case 2: // all
        return BorderRadius.all(radius);
      default:
        return BorderRadius.circular(borderRadiusValue);
    }
  }
}
