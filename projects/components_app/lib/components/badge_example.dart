import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 🏷️ Badge Examples
///
/// This example page demonstrates all the available badge variants
/// in the OSMEA Components Library with different configurations.
class BadgeExample extends StatefulWidget {
  const BadgeExample({Key? key}) : super(key: key);

  @override
  State<BadgeExample> createState() => _BadgeExampleState();
}

class _BadgeExampleState extends State<BadgeExample> {
  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'badge_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIntroductionSection(),
            OsmeaComponents.sizedBox(height: 36),
            _buildSectionTitle('Badge Styles'),
            _buildStyleShowcase(),
            OsmeaComponents.sizedBox(height: 24),
            _buildSectionTitle('Standard Badge Variants'),
            _buildVariantShowcase(),
            OsmeaComponents.sizedBox(height: 24),
            _buildSectionTitle('Badge Sizes'),
            _buildSizeShowcase(),
            OsmeaComponents.sizedBox(height: 24),
            _buildSectionTitle('Badge Shapes'),
            _buildShapeShowcase(),
            OsmeaComponents.sizedBox(height: 24),
            _buildSectionTitle('Badge States'),
            _buildStateShowcase(),
            OsmeaComponents.sizedBox(height: 24),
            _buildSectionTitle('Badge with Icons'),
            _buildIconShowcase(),
            OsmeaComponents.sizedBox(height: 24),
            _buildSectionTitle('Badge Positions'),
            _buildPositionShowcase(),
            OsmeaComponents.sizedBox(height: 24),
            _buildSectionTitle('Interactive Badges'),
            _buildInteractiveShowcase(),
            OsmeaComponents.sizedBox(height: 24),
            _buildSectionTitle('Dot Badges'),
            _buildDotBadgeShowcase(),
            OsmeaComponents.sizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildIntroductionSection() {
    return OsmeaComponents.container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: OsmeaColors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: OsmeaColors.nordicBlue.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            '🏷️ MasterFabric Badge Component',
            textStyle: OsmeaTextStyle.headlineMedium(context).copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: OsmeaColors.nordicBlue,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
          OsmeaComponents.sizedBox(height: 14),
          OsmeaComponents.text(
            'Modern, minimalist badges for notifications, labels, and status indicators',
            textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
              fontSize: 16,
              color: OsmeaColors.black.withValues(alpha: 0.87),
              height: 1.4,
              letterSpacing: -0.3,
            ),
          ),
          OsmeaComponents.sizedBox(height: 30),
          OsmeaComponents.wrap(
            spacing: 20,
            runSpacing: 30,
            children: [
              _buildFeatureItem(
                title: 'Style Variants',
                description: 'Soft, normal, outlined, ghost, and mixed styles',
                badge: OsmeaComponents.row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OsmeaComponents.badge(
                      content: 'Soft',
                      shape: BadgeShape.pill,
                      style: BadgeStyle.soft,
                      variant: BadgeVariant.primary,
                    ),
                    OsmeaComponents.sizedBox(width: 8),
                    OsmeaComponents.badge(
                      content: 'Normal',
                      shape: BadgeShape.pill,
                      style: BadgeStyle.normal,
                      variant: BadgeVariant.primary,
                    ),
                  ],
                ),
              ),
              _buildFeatureItem(
                title: 'Content Types',
                description: 'Text, numbers, dots, and icons',
                badge: OsmeaComponents.row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OsmeaComponents.badge(
                      content: '42',
                      variant: BadgeVariant.success,
                      style: BadgeStyle.normal,
                    ),
                    OsmeaComponents.sizedBox(width: 8),
                    OsmeaComponents.badge(
                      size: BadgeSize.dot,
                      variant: BadgeVariant.danger,
                      style: BadgeStyle.normal,
                    ),
                  ],
                ),
              ),
              _buildFeatureItem(
                title: 'Positioning',
                description:
                    'Place badges anywhere relative to parent elements',
                badge: OsmeaComponents.badge(
                  child: OsmeaComponents.container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: OsmeaColors.ash.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.notifications,
                        size: 24,
                        color: OsmeaColors.black.withValues(alpha: 0.54)),
                  ),
                  content: '8',
                  position: BadgePosition.topRight,
                  variant: BadgeVariant.danger,
                  style: BadgeStyle.normal,
                  size: BadgeSize.extraSmall,
                ),
              ),
              _buildFeatureItem(
                title: 'Icon Badges',
                description: 'Support for both icon-only and icon+text badges',
                badge: OsmeaComponents.row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OsmeaComponents.badge(
                      content: '3',
                      variant: BadgeVariant.primary,
                      style: BadgeStyle.normal,
                      child: Icon(Icons.mail,
                          size: 22,
                          color:
                              OsmeaColors.sunsetGlow.withValues(alpha: 0.54)),
                    ),
                    OsmeaComponents.sizedBox(width: 12),
                    OsmeaComponents.badge(
                      content: null,
                      size: BadgeSize.dot,
                      variant: BadgeVariant.warning,
                      style: BadgeStyle.normal,
                      child: Icon(Icons.chat,
                          size: 22,
                          color: OsmeaColors.black.withValues(alpha: 0.54)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required String title,
    required String description,
    required Widget badge,
  }) {
    return OsmeaComponents.sizedBox(
      width: MediaQuery.of(context).size.width > 600
          ? 250
          : (MediaQuery.of(context).size.width - 60) / 2,
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.container(
            height: 70,
            alignment: Alignment.centerLeft,
            child: badge,
          ),
          OsmeaComponents.sizedBox(height: 12),
          OsmeaComponents.text(
            title,
            textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: OsmeaColors.black.withValues(alpha: 0.87),
              letterSpacing: -0.3,
            ),
          ),
          OsmeaComponents.sizedBox(height: 6),
          OsmeaComponents.text(
            description,
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              fontSize: 14,
              color: OsmeaColors.black.withValues(alpha: 0.54),
              height: 1.4,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return OsmeaComponents.container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            OsmeaColors.nordicBlue.withValues(alpha: 0.05),
            OsmeaColors.crystalBay.withValues(alpha: 0.08),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(13), // Match badge radius
        border: Border.all(
          color: OsmeaColors.nordicBlue.withValues(alpha: 0.08),
          width: 0.5,
        ),
      ),
      child: OsmeaComponents.row(
        children: [
          OsmeaComponents.container(
            width: 5,
            height: 20,
            decoration: BoxDecoration(
              color: OsmeaColors.nordicBlue,
              borderRadius: BorderRadius.circular(13), // Match badge radius
            ),
          ),
          OsmeaComponents.sizedBox(width: 12),
          OsmeaComponents.text(
            title,
            textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: OsmeaColors.nordicBlue,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantShowcase() {
    return OsmeaComponents.wrap(
      spacing: 16,
      runSpacing: 24,
      alignment: WrapAlignment.start,
      children: [
        _buildBadgeWithLabel(
            'Soft',
            OsmeaComponents.badge(
              content: 'Soft',
              variant: BadgeVariant.primary,
              shape: BadgeShape.pill,
              style: BadgeStyle.soft,
            )),
        _buildBadgeWithLabel(
            'Normal',
            OsmeaComponents.badge(
              content: 'Normal',
              variant: BadgeVariant.primary,
              shape: BadgeShape.pill,
              style: BadgeStyle.normal,
            )),
        _buildBadgeWithLabel(
            'Outlined',
            OsmeaComponents.badge(
              content: 'Outlined',
              variant: BadgeVariant.primary,
              shape: BadgeShape.pill,
              style: BadgeStyle.outlined,
            )),
        _buildBadgeWithLabel(
            'Ghost',
            OsmeaComponents.badge(
              content: 'Ghost',
              variant: BadgeVariant.primary,
              shape: BadgeShape.pill,
              style: BadgeStyle.ghost,
            )),
        _buildBadgeWithLabel(
            'Success',
            OsmeaComponents.badge(
              content: 'Success',
              variant: BadgeVariant.success,
              shape: BadgeShape.pill,
              style: BadgeStyle.soft,
            )),
        _buildBadgeWithLabel(
            'Warning',
            OsmeaComponents.badge(
              content: 'Warning',
              variant: BadgeVariant.warning,
              shape: BadgeShape.pill,
              style: BadgeStyle.soft,
            )),
        _buildBadgeWithLabel(
            'Danger',
            OsmeaComponents.badge(
              content: 'Danger',
              variant: BadgeVariant.danger,
              shape: BadgeShape.pill,
              style: BadgeStyle.soft,
            )),
        _buildBadgeWithLabel(
            'Info',
            OsmeaComponents.badge(
              content: 'Info',
              variant: BadgeVariant.info,
              shape: BadgeShape.pill,
              style: BadgeStyle.soft,
            )),
      ],
    );
  }

  Widget _buildSizeShowcase() {
    return OsmeaComponents.wrap(
      spacing: 24,
      runSpacing: 24,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildBadgeWithLabel(
            'Dot',
            OsmeaComponents.badge(
              size: BadgeSize.dot,
              variant: BadgeVariant.primary,
              style: BadgeStyle.normal,
            )),
        _buildBadgeWithLabel(
            'XS',
            OsmeaComponents.badge(
              content: '1',
              size: BadgeSize.extraSmall,
              variant: BadgeVariant.primary,
              shape: BadgeShape.circular,
              style: BadgeStyle.normal,
            )),
        _buildBadgeWithLabel(
            'Small',
            OsmeaComponents.badge(
              content: '12',
              size: BadgeSize.small,
              variant: BadgeVariant.success,
              shape: BadgeShape.rounded,
            )),
        _buildBadgeWithLabel(
            'Medium',
            OsmeaComponents.badge(
              content: '42',
              size: BadgeSize.medium,
              variant: BadgeVariant.info,
              shape: BadgeShape.pill,
            )),
        _buildBadgeWithLabel(
            'Large',
            OsmeaComponents.badge(
              content: '87',
              size: BadgeSize.large,
              variant: BadgeVariant.warning,
              shape: BadgeShape.pill,
            )),
        _buildBadgeWithLabel(
            'XL',
            OsmeaComponents.badge(
              content: '100+',
              size: BadgeSize.extraLarge,
              variant: BadgeVariant.danger,
              shape: BadgeShape.rounded,
            )),
      ],
    );
  }

  Widget _buildShapeShowcase() {
    return OsmeaComponents.wrap(
      spacing: 24,
      runSpacing: 24,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildBadgeWithLabel(
            'Circular',
            OsmeaComponents.badge(
              content: '8',
              shape: BadgeShape.circular,
              variant: BadgeVariant.primary,
              size: BadgeSize.medium,
            )),
        _buildBadgeWithLabel(
            'Rounded',
            OsmeaComponents.badge(
              content: 'New',
              shape: BadgeShape.rounded,
              variant: BadgeVariant.secondary,
              size: BadgeSize.medium,
            )),
        _buildBadgeWithLabel(
            'Pill',
            OsmeaComponents.badge(
              content: 'Popular',
              shape: BadgeShape.pill,
              variant: BadgeVariant.success,
              size: BadgeSize.medium,
            )),
        _buildBadgeWithLabel(
            'Square',
            OsmeaComponents.badge(
              content: '10',
              shape: BadgeShape.square,
              variant: BadgeVariant.info,
              size: BadgeSize.medium,
            )),
        _buildBadgeWithLabel(
            'Rectangle',
            OsmeaComponents.badge(
              content: 'Status',
              shape: BadgeShape.rectangle,
              variant: BadgeVariant.warning,
              size: BadgeSize.medium,
            )),
      ],
    );
  }

  Widget _buildStateShowcase() {
    return OsmeaComponents.wrap(
      spacing: 24,
      runSpacing: 24,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildBadgeWithLabel(
            'Enabled',
            OsmeaComponents.badge(
              content: 'Enabled',
              state: BadgeState.enabled,
              variant: BadgeVariant.primary,
              shape: BadgeShape.rounded,
            )),
        _buildBadgeWithLabel(
            'Disabled',
            OsmeaComponents.badge(
              content: 'Disabled',
              state: BadgeState.disabled,
              variant: BadgeVariant.primary,
              shape: BadgeShape.rounded,
            )),
        _buildBadgeWithLabel(
            'Active',
            OsmeaComponents.badge(
              content: 'Active',
              state: BadgeState.active,
              variant: BadgeVariant.primary,
              shape: BadgeShape.rounded,
              style: BadgeStyle.normal, // Use normal style for better contrast
              textColor:
                  OsmeaColors.white, // Ensure text is white for visibility
            )),
        _buildBadgeWithLabel(
            'Clickable',
            OsmeaComponents.badge(
              content: 'Click me',
              state: BadgeState.clickable,
              variant: BadgeVariant.primary,
              shape: BadgeShape.rounded,
              onTap: () {},
            )),
      ],
    );
  }

  Widget _buildIconShowcase() {
    return OsmeaComponents.wrap(
      spacing: 24,
      runSpacing: 24,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildBadgeWithLabel(
            'Icon Badge',
            OsmeaComponents.badge(
              child: OsmeaComponents.container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: OsmeaColors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.notifications,
                    size: 24, color: OsmeaColors.black54),
              ),
              content: '8',
              position: BadgePosition.topRight,
              variant: BadgeVariant.danger,
              style: BadgeStyle.normal,
              size: BadgeSize.extraSmall,
            )),
        _buildBadgeWithLabel(
            'Avatar Badge',
            OsmeaComponents.badge(
              child: const CircleAvatar(
                radius: 22,
                backgroundColor: OsmeaColors.grey,
                child: Icon(Icons.person, color: OsmeaColors.white),
              ),
              content: '3',
              position: BadgePosition.bottomRight,
              variant: BadgeVariant.success,
              style: BadgeStyle.normal,
              size: BadgeSize.extraSmall,
            )),
        _buildBadgeWithLabel(
            'Icon Only',
            OsmeaComponents.badge(
              child: OsmeaComponents.container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: OsmeaColors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.mail,
                    size: 24, color: OsmeaColors.black54),
              ),
              content: null,
              position: BadgePosition.topRight,
              style: BadgeStyle.normal,
              size: BadgeSize.dot,
              variant: BadgeVariant.primary,
            )),
        _buildBadgeWithLabel(
            'Button Badge',
            OsmeaComponents.badge(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: OsmeaColors.white,
                  foregroundColor: OsmeaColors.nordicBlue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: OsmeaComponents.text('Messages'),
              ),
              content: '12',
              position: BadgePosition.topRight,
              variant: BadgeVariant.warning,
              style: BadgeStyle.normal,
              size: BadgeSize.extraSmall,
            )),
        _buildBadgeWithLabel(
          'Icon + Text',
          OsmeaComponents.row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OsmeaComponents.badge(
                content: 'Inbox',
                variant: BadgeVariant.primary,
                style: BadgeStyle.soft,
                shape: BadgeShape.pill,
                padding: const EdgeInsets.only(left: 4, right: 10),
                child: OsmeaComponents.padding(
                  padding: const EdgeInsets.only(right: 4),
                  child:
                      const Icon(Icons.mail, size: 16, color: OsmeaColors.blue),
                ),
              ),
            ],
          ),
        ),
        _buildBadgeWithLabel(
          'Notification',
          OsmeaComponents.row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OsmeaComponents.badge(
                content: '8 New',
                variant: BadgeVariant.danger,
                style: BadgeStyle.normal,
                shape: BadgeShape.pill,
                padding: const EdgeInsets.only(left: 4, right: 10),
                child: OsmeaComponents.padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: const Icon(Icons.notifications,
                      size: 16, color: OsmeaColors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPositionShowcase() {
    final Widget box = OsmeaComponents.container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: OsmeaColors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: OsmeaComponents.center(
        child: OsmeaComponents.text(
          'Parent',
          fontSize: 14,
          color: OsmeaColors.black54,
        ),
      ),
    );

    return OsmeaComponents.wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        _buildBadgeWithLabel(
            'Top Right',
            OsmeaComponents.badge(
              child: box,
              content: 'TR',
              position: BadgePosition.topRight,
              variant: BadgeVariant.primary,
              style: BadgeStyle.normal,
              size: BadgeSize.extraSmall,
            )),
        _buildBadgeWithLabel(
            'Top Left',
            OsmeaComponents.badge(
              child: box,
              content: 'TL',
              position: BadgePosition.topLeft,
              variant: BadgeVariant.primary,
              style: BadgeStyle.normal,
              size: BadgeSize.extraSmall,
            )),
        _buildBadgeWithLabel(
            'Bottom Right',
            OsmeaComponents.badge(
              child: box,
              content: 'BR',
              position: BadgePosition.bottomRight,
              variant: BadgeVariant.primary,
              style: BadgeStyle.normal,
              size: BadgeSize.extraSmall,
            )),
        _buildBadgeWithLabel(
            'Bottom Left',
            OsmeaComponents.badge(
              child: box,
              content: 'BL',
              position: BadgePosition.bottomLeft,
              variant: BadgeVariant.primary,
              style: BadgeStyle.normal,
              size: BadgeSize.extraSmall,
            )),
        _buildBadgeWithLabel(
            'Center',
            OsmeaComponents.badge(
              child: box,
              content: 'C',
              position: BadgePosition.center,
              variant: BadgeVariant.primary,
              style: BadgeStyle.normal,
              size: BadgeSize.extraSmall,
            )),
      ],
    );
  }

  Widget _buildInteractiveShowcase() {
    return OsmeaComponents.wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildBadgeWithLabel(
            'Tap Badge',
            OsmeaComponents.badge(
              content: 'Tap me',
              variant: BadgeVariant.primary,
              shape: BadgeShape.pill,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: OsmeaComponents.text('Badge tapped!')),
                );
              },
            )),
        _buildBadgeWithLabel(
            'Max Count',
            OsmeaComponents.badge(
              content: 1250,
              maxCount: 999,
              variant: BadgeVariant.primary,
            )),
        _buildBadgeWithLabel(
            'Zero Count',
            OsmeaComponents.badge(
              content: 0,
              showZero: true,
              variant: BadgeVariant.neutral,
            )),
      ],
    );
  }

  Widget _buildDotBadgeShowcase() {
    return OsmeaComponents.wrap(
      spacing: 24,
      runSpacing: 24,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildBadgeWithLabel(
            'Primary Dot',
            OsmeaComponents.badge(
              size: BadgeSize.dot,
              variant: BadgeVariant.primary,
              style: BadgeStyle.normal,
            )),
        _buildBadgeWithLabel(
            'Success Dot',
            OsmeaComponents.badge(
              size: BadgeSize.dot,
              variant: BadgeVariant.success,
              style: BadgeStyle.normal,
            )),
        _buildBadgeWithLabel(
            'Warning Dot',
            OsmeaComponents.badge(
              size: BadgeSize.dot,
              variant: BadgeVariant.warning,
              style: BadgeStyle.normal,
            )),
        _buildBadgeWithLabel(
            'Danger Dot',
            OsmeaComponents.badge(
              size: BadgeSize.dot,
              variant: BadgeVariant.danger,
              style: BadgeStyle.normal,
            )),
        _buildBadgeWithLabel(
            'Info Dot',
            OsmeaComponents.badge(
              size: BadgeSize.dot,
              variant: BadgeVariant.info,
              style: BadgeStyle.normal,
            )),
        _buildBadgeWithLabel(
            'Neutral Dot',
            OsmeaComponents.badge(
              size: BadgeSize.dot,
              variant: BadgeVariant.neutral,
              style: BadgeStyle.normal,
            )),
      ],
    );
  }

  Widget _buildStyleShowcase() {
    return OsmeaComponents.wrap(
      spacing: 24,
      runSpacing: 24,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildBadgeWithLabel(
            'Normal Style',
            OsmeaComponents.badge(
              content: 'Normal',
              variant: BadgeVariant.primary,
              style: BadgeStyle.normal,
              shape: BadgeShape.pill,
            )),
        _buildBadgeWithLabel(
            'Soft Style',
            OsmeaComponents.badge(
              content: 'Soft',
              variant: BadgeVariant.primary,
              style: BadgeStyle.soft,
              shape: BadgeShape.pill,
            )),
        _buildBadgeWithLabel(
            'Outlined Style',
            OsmeaComponents.badge(
              content: 'Outlined',
              variant: BadgeVariant.primary,
              style: BadgeStyle.outlined,
              shape: BadgeShape.pill,
            )),
        _buildBadgeWithLabel(
            'Ghost Style',
            OsmeaComponents.badge(
              content: 'Ghost',
              variant: BadgeVariant.primary,
              style: BadgeStyle.ghost,
              shape: BadgeShape.pill,
            )),
        _buildBadgeWithLabel(
            'Mixed Style',
            OsmeaComponents.badge(
              content: 'Mixed',
              variant: BadgeVariant.primary,
              style: BadgeStyle.mixed,
              shape: BadgeShape.pill,
            )),
      ],
    );
  }

  Widget _buildBadgeWithLabel(String label, Widget badge) {
    return OsmeaComponents.container(
      width: 120, // Fixed width for consistent card sizes
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius:
            BorderRadius.circular(13), // Match badge radius for consistency
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          badge,
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.text(
            label,
            textStyle: OsmeaTextStyle.labelLarge(context).copyWith(
              fontSize: 14,
              color: OsmeaColors.black54,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
