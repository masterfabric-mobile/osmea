import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

class ChipsExample extends StatefulWidget {
  const ChipsExample({Key? key}) : super(key: key);

  @override
  State<ChipsExample> createState() => _ChipsExampleState();
}

class _ChipsExampleState extends State<ChipsExample> {
  // Categories list
  final List<String> _categories = [
    'All',
    'Technology',
    'Design',
    'Business',
    'Marketing',
    'Development',
    'Health',
    'Lifestyle',
    'Sports',
  ];

  // Multi-selection list for interests
  final List<String> _selectedInterests = [];

  // Single selection index for category
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'chips_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.text(
              '1. Category Filtering (Single Selection)',
              textStyle: OsmeaTextStyle.titleMedium(context)
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 12),
            _buildFilterChips(),
            OsmeaComponents.divider(height: 32),
            OsmeaComponents.text(
              '2. Interests (Multiple Selection)',
              textStyle: OsmeaTextStyle.titleMedium(context)
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 12),
            _buildMultiSelectChips(),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.text(
              'Selected interests: ${_selectedInterests.isEmpty ? "No selection yet" : _selectedInterests.join(", ")}',
              fontSize: 14,
              color: OsmeaColors.pewter,
            ),
            OsmeaComponents.divider(height: 32),
            OsmeaComponents.text(
              '3. Different Styles',
              textStyle: OsmeaTextStyle.titleMedium(context)
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 12),
            _buildStyleShowcase(),
            OsmeaComponents.divider(height: 32),
            OsmeaComponents.text(
              '4. Interactive',
              textStyle: OsmeaTextStyle.titleMedium(context)
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 12),
            _buildInteractiveExamples(),
          ],
        ),
      ),
    );
  }

  // 1. Category Filtering - Only one chip can be selected
  Widget _buildFilterChips() {
    return OsmeaComponents.singleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: OsmeaComponents.row(
        children: List.generate(
          _categories.length,
          (index) => OsmeaComponents.padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: OsmeaComponents.chips(
              text: _categories[index],
              variant: ChipsVariant.primary,
              style: _selectedCategoryIndex == index
                  ? ChipsStyle.normal
                  : ChipsStyle.outlined,
              selected: _selectedCategoryIndex == index,
              onTap: () {
                setState(() {
                  _selectedCategoryIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  // 2. Interests - Multiple selections can be made
  Widget _buildMultiSelectChips() {
    final List<String> interests = [
      'Flutter',
      'Dart',
      'UI/UX',
      'Mobile',
      'Web',
      'Backend',
      'AI',
      'Cloud',
      'DevOps',
    ];

    return OsmeaComponents.wrap(
      spacing: 10,
      runSpacing: 12,
      children: interests.map((interest) {
        final isSelected = _selectedInterests.contains(interest);
        return OsmeaComponents.chips(
          text: interest,
          variant: ChipsVariant.secondary,
          selected: isSelected,
          style: ChipsStyle.soft,
          // Each interest gets its own icon
          icon: _getInterestIcon(interest),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedInterests.add(interest);
              } else {
                _selectedInterests.remove(interest);
              }
            });
          },
        );
      }).toList(),
    );
  }

  // Helper method to provide appropriate icons for interests
  IconData? _getInterestIcon(String interest) {
    switch (interest) {
      case 'Flutter':
        return Icons.flutter_dash;
      case 'Dart':
        return Icons.code;
      case 'UI/UX':
        return Icons.design_services;
      case 'Mobile':
        return Icons.phone_android;
      case 'Web':
        return Icons.web;
      case 'Backend':
        return Icons.dns;
      case 'AI':
        return Icons.psychology;
      case 'Cloud':
        return Icons.cloud;
      case 'DevOps':
        return Icons.precision_manufacturing;
      default:
        return null;
    }
  }

  // 3. Different styles
  Widget _buildStyleShowcase() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Style variations
        OsmeaComponents.text('● Style Variations:',
            fontWeight: FontWeight.w500),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OsmeaComponents.chips(
              text: 'Normal',
              icon: Icons.star,
              style: ChipsStyle.normal,
              variant: ChipsVariant.primary,
            ),
            OsmeaComponents.chips(
              text: 'Outlined',
              icon: Icons.bookmark,
              style: ChipsStyle.outlined,
              variant: ChipsVariant.success,
            ),
            OsmeaComponents.chips(
              text: 'Soft',
              icon: Icons.favorite,
              style: ChipsStyle.soft,
              variant: ChipsVariant.danger,
            ),
          ],
        ),

        OsmeaComponents.sizedBox(height: 20),

        // State variations
        OsmeaComponents.text('● State Variations:',
            fontWeight: FontWeight.w500),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OsmeaComponents.chips(
              text: 'Normal',
              style: ChipsStyle.normal,
              variant: ChipsVariant.info,
            ),
            OsmeaComponents.chips(
              text: 'Selected',
              style: ChipsStyle.normal,
              variant: ChipsVariant.info,
              selected: true,
            ),
            OsmeaComponents.chips(
              text: 'Disabled',
              style: ChipsStyle.normal,
              variant: ChipsVariant.info,
              state: ChipsState.disabled,
            ),
          ],
        ),

        OsmeaComponents.sizedBox(height: 20),

        // Size variations
        OsmeaComponents.text('● Size Variations:', fontWeight: FontWeight.w500),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.chips(
              text: 'Extra Small',
              style: ChipsStyle.normal,
              size: ChipsSize.extraSmall,
              variant: ChipsVariant.warning,
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.chips(
              text: 'Small',
              style: ChipsStyle.normal,
              size: ChipsSize.small,
              variant: ChipsVariant.warning,
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.chips(
              text: 'Medium',
              style: ChipsStyle.normal,
              size: ChipsSize.medium,
              variant: ChipsVariant.warning,
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.chips(
              text: 'Large',
              style: ChipsStyle.normal,
              size: ChipsSize.large,
              variant: ChipsVariant.warning,
            ),
          ],
        ),

        OsmeaComponents.sizedBox(height: 20),

        // Shape variations
        OsmeaComponents.text('● Shape Variations:',
            fontWeight: FontWeight.w500),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OsmeaComponents.chips(
              text: 'Rounded',
              icon: Icons.rounded_corner,
              style: ChipsStyle.normal,
              shape: ChipsShape.rounded,
              variant: ChipsVariant.primary,
            ),
            OsmeaComponents.chips(
              text: 'Square',
              icon: Icons.crop_square,
              style: ChipsStyle.normal,
              shape: ChipsShape.square,
              variant: ChipsVariant.secondary,
            ),
            OsmeaComponents.chips(
              text: 'Pill',
              icon: Icons.medication,
              style: ChipsStyle.normal,
              shape: ChipsShape.pill,
              variant: ChipsVariant.success,
            ),
          ],
        ),

        OsmeaComponents.sizedBox(height: 20),

        // Icon position variations
        OsmeaComponents.text('● Icon Position Variations:',
            fontWeight: FontWeight.w500),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.text(
          'Control where the icon appears with iconPosition parameter:',
          fontSize: 12,
          color: OsmeaColors.pewter,
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OsmeaComponents.chips(
              text: 'Icon Start',
              icon: Icons.star,
              iconPosition: ChipsIconPosition.start,
              style: ChipsStyle.normal,
              variant: ChipsVariant.primary,
            ),
            OsmeaComponents.chips(
              text: 'Icon End',
              icon: Icons.arrow_forward,
              iconPosition: ChipsIconPosition.end,
              style: ChipsStyle.normal,
              variant: ChipsVariant.secondary,
            ),
            OsmeaComponents.chips(
              text: 'Download',
              icon: Icons.download,
              iconPosition: ChipsIconPosition.end,
              style: ChipsStyle.outlined,
              variant: ChipsVariant.success,
            ),
            OsmeaComponents.chips(
              text: 'Next Step',
              icon: Icons.navigate_next,
              iconPosition: ChipsIconPosition.end,
              style: ChipsStyle.soft,
              variant: ChipsVariant.info,
            ),
          ],
        ),

        OsmeaComponents.sizedBox(height: 20),

        // Color variations
        OsmeaComponents.text('● Color Variations:',
            fontWeight: FontWeight.w500),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.chips(
              text: 'Primary',
              style: ChipsStyle.normal,
              variant: ChipsVariant.primary,
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.chips(
              text: 'Secondary',
              style: ChipsStyle.normal,
              variant: ChipsVariant.secondary,
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.chips(
              text: 'Success',
              style: ChipsStyle.normal,
              variant: ChipsVariant.success,
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.chips(
              text: 'Warning',
              style: ChipsStyle.normal,
              variant: ChipsVariant.warning,
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.chips(
              text: 'Danger',
              style: ChipsStyle.normal,
              variant: ChipsVariant.danger,
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.chips(
              text: 'Info',
              style: ChipsStyle.normal,
              variant: ChipsVariant.info,
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.chips(
              text: 'Neutral',
              style: ChipsStyle.normal,
              variant: ChipsVariant.neutral,
            ),
          ],
        ),
      ],
    );
  }

  // 4. Interactive examples
  Widget _buildInteractiveExamples() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.container(
          alignment: Alignment.centerLeft,
          child: OsmeaComponents.chips(
            text: 'Closable',
            onClose: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: OsmeaComponents.text('Chip closed'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: OsmeaComponents.text('Chip tapped'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ),

        OsmeaComponents.sizedBox(height: 16),

        // With avatar
        OsmeaComponents.container(
          alignment: Alignment.centerLeft,
          child: OsmeaComponents.chips(
            text: 'With Avatar',
            avatar: CircleAvatar(
              backgroundColor: OsmeaColors.nordicBlue,
              radius: 12,
              child: OsmeaComponents.text(
                'A',
                textStyle: OsmeaTextStyle.labelMedium(context)
                    .copyWith(color: OsmeaColors.white, fontSize: 12),
              ),
            ),
            variant: ChipsVariant.info,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: OsmeaComponents.text('Avatar chip tapped'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ),

        OsmeaComponents.sizedBox(height: 16),

        // With icon
        OsmeaComponents.container(
          alignment: Alignment.centerLeft,
          child: OsmeaComponents.chips(
            text: 'With Icon',
            icon: Icons.location_on,
            variant: ChipsVariant.primary,
            style: ChipsStyle.outlined,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: OsmeaComponents.text('Icon chip tapped'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ),

        OsmeaComponents.sizedBox(height: 16),

        // Icon-only chip
        OsmeaComponents.container(
          alignment: Alignment.centerLeft,
          child: OsmeaComponents.chips(
            icon: Icons.settings,
            tooltip: 'Settings',
            variant: ChipsVariant.neutral,
            style: ChipsStyle.normal,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: OsmeaComponents.text('Icon-only chip tapped'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ),

        OsmeaComponents.sizedBox(height: 20),

        // Pill-style chips showcase
        OsmeaComponents.text('● Pill Style:',
            fontWeight: FontWeight.w500),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.text(
          'Perfect capsule-shaped chips with ChipsShape.pill:',
          fontSize: 12,
          color: OsmeaColors.pewter,
        ),
        OsmeaComponents.sizedBox(height: 8),

        // Pill style examples with current rounded shape
        OsmeaComponents.wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // Small pill-like chip
            OsmeaComponents.chips(
              text: 'Small Tag',
              size: ChipsSize.small,
              shape: ChipsShape.pill,
              style: ChipsStyle.soft,
              variant: ChipsVariant.primary,
            ),

            // Medium pill chip with icon
            OsmeaComponents.chips(
              text: 'Filter',
              icon: Icons.filter_list,
              shape: ChipsShape.pill,
              iconPosition: ChipsIconPosition.end,
              style: ChipsStyle.outlined,
              variant: ChipsVariant.secondary,
            ),

            // Selectable pill chip
            OsmeaComponents.chips(
              text: 'Selectable',
              shape: ChipsShape.pill,
              style: ChipsStyle.normal,
              variant: ChipsVariant.success,
            ),

            // Large pill button
            OsmeaComponents.chips(
              text: 'Pill Button',
              size: ChipsSize.large,
              shape: ChipsShape.pill,
              style: ChipsStyle.normal,
              variant: ChipsVariant.info,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: OsmeaComponents.text('Pill button tapped!'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),

        OsmeaComponents.sizedBox(height: 20),

        // Icon position
        OsmeaComponents.text('● Icon Position:',
            fontWeight: FontWeight.w500),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.text(
          'Explicit icon positioning for layout:',
          fontSize: 12,
          color: OsmeaColors.pewter,
        ),
        OsmeaComponents.sizedBox(height: 8),

        OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.text('Start Position (Default):',
                fontWeight: FontWeight.w500, fontSize: 14),
            OsmeaComponents.sizedBox(height: 4),
            OsmeaComponents.chips(
              text: 'Start Icon',
              icon: Icons.star,
              iconPosition: ChipsIconPosition.start,
              variant: ChipsVariant.primary,
              style: ChipsStyle.normal,
            ),
            OsmeaComponents.sizedBox(height: 12),
            OsmeaComponents.text('End Position:',
                fontWeight: FontWeight.w500, fontSize: 14),
            OsmeaComponents.sizedBox(height: 4),
            OsmeaComponents.chips(
              text: 'End Icon',
              icon: Icons.arrow_forward,
              iconPosition: ChipsIconPosition.end,
              variant: ChipsVariant.secondary,
              style: ChipsStyle.normal,
            ),
            OsmeaComponents.sizedBox(height: 12),
            OsmeaComponents.text('Multiple End:',
                fontWeight: FontWeight.w500, fontSize: 14),
            OsmeaComponents.sizedBox(height: 4),
            OsmeaComponents.wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OsmeaComponents.chips(
                  text: 'Download',
                  icon: Icons.download,
                  iconPosition: ChipsIconPosition.end,
                  variant: ChipsVariant.success,
                  style: ChipsStyle.outlined,
                ),
                OsmeaComponents.chips(
                  text: 'Next',
                  icon: Icons.navigate_next,
                  iconPosition: ChipsIconPosition.end,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  variant: ChipsVariant.info,
                  style: ChipsStyle.soft,
                ),
                OsmeaComponents.chips(
                  text: 'Send',
                  icon: Icons.send,
                  iconPosition: ChipsIconPosition.end,
                  variant: ChipsVariant.warning,
                  style: ChipsStyle.normal,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
