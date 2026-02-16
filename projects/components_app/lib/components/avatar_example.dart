import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 👤 **OSMEA Avatar Examples**
///
/// Comprehensive examples demonstrating all variants, sizes, and features
/// of the OSMEA Avatar component library.
///
/// This file showcases:
/// * 📏 All size options (extraSmall to extraLarge)
/// * 🎨 All appearance variants (filled, outlined, elevated, etc.)
/// * 🖼️ Image and network image avatars
/// * 🎯 Icon and text content avatars
/// * 🔘 Interactive avatars with callbacks
/// * 🎭 Custom styling and theming options
/// * 🔲 Border customization examples

class AvatarExample extends StatefulWidget {
  const AvatarExample({super.key});

  @override
  State<AvatarExample> createState() => _AvatarExampleState();
}

class _AvatarExampleState extends State<AvatarExample> {
  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'avatar_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildSectionTitle('📏 Avatar Sizes'),
            ),
            _buildSizesSection(),
            OsmeaComponents.sizedBox(height: 32),
            OsmeaComponents.padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildSectionTitle('🎨 Avatar Appearances'),
            ),
            _buildAppearancesSection(),
            OsmeaComponents.sizedBox(height: 32),
            OsmeaComponents.padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildSectionTitle('🎯 Content Types'),
            ),
            _buildContentTypesSection(),
            OsmeaComponents.sizedBox(height: 32),
            OsmeaComponents.padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildSectionTitle('🖼️ Image Avatars'),
            ),
            _buildImageAvatarsSection(),
            OsmeaComponents.sizedBox(height: 32),
            OsmeaComponents.padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildSectionTitle('🔘 Interactive Avatars'),
            ),
            _buildInteractiveSection(),
            OsmeaComponents.sizedBox(height: 32),
            OsmeaComponents.padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildSectionTitle('🎭 Custom Styling'),
            ),
            _buildCustomStylingSection(),
            OsmeaComponents.sizedBox(height: 32),
            OsmeaComponents.padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildSectionTitle('👥 Avatar Groups'),
            ),
            _buildAvatarGroupsSection(),
            OsmeaComponents.sizedBox(height: 32),
            OsmeaComponents.padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildSectionTitle('📱 Extension Features'),
            ),
            _buildExtensionFeaturesSection(),
            OsmeaComponents.sizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return OsmeaComponents.text(
      title,
      variant: OsmeaTextVariant.headlineSmall,
      color: OsmeaColors.nordicBlue,
    );
  }

  Widget _buildSubsectionTitle(String title) {
    return OsmeaComponents.text(
      title,
      variant: OsmeaTextVariant.titleMedium,
      color: OsmeaColors.pewter,
    );
  }

  Widget _buildSizesSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('All Available Sizes'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            OsmeaComponents.column(
              children: [
                OsmeaComponents.avatar(
                  size: ComponentSize.extraSmall,
                  icon: Icons.person,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Extra Small',
                  variant: OsmeaTextVariant.labelSmall,
                ),
              ],
            ),
            OsmeaComponents.column(
              children: [
                OsmeaComponents.avatar(
                  size: ComponentSize.small,
                  icon: Icons.person,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Small',
                  variant: OsmeaTextVariant.labelSmall,
                ),
              ],
            ),
            OsmeaComponents.column(
              children: [
                OsmeaComponents.avatar(
                  size: ComponentSize.medium,
                  icon: Icons.person,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Medium',
                  variant: OsmeaTextVariant.labelSmall,
                ),
              ],
            ),
            OsmeaComponents.column(
              children: [
                OsmeaComponents.avatar(
                  size: ComponentSize.large,
                  icon: Icons.person,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Large',
                  variant: OsmeaTextVariant.labelSmall,
                ),
              ],
            ),
            OsmeaComponents.column(
              children: [
                OsmeaComponents.avatar(
                  size: ComponentSize.extraLarge,
                  icon: Icons.person,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Extra Large',
                  variant: OsmeaTextVariant.labelSmall,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppearancesSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Different Appearance Variants'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            OsmeaComponents.column(
              children: [
                OsmeaComponents.avatar(
                  appearance: ComponentAppearance.filled,
                  icon: Icons.person,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Filled',
                  variant: OsmeaTextVariant.labelSmall,
                ),
              ],
            ),
            OsmeaComponents.column(
              children: [
                OsmeaComponents.avatar(
                  appearance: ComponentAppearance.outlined,
                  icon: Icons.person,
                  borderWidth: 2.0,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Outlined',
                  variant: OsmeaTextVariant.labelSmall,
                ),
              ],
            ),
            OsmeaComponents.column(
              children: [
                OsmeaComponents.avatar(
                  appearance: ComponentAppearance.elevated,
                  icon: Icons.person,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Elevated',
                  variant: OsmeaTextVariant.labelSmall,
                ),
              ],
            ),
            OsmeaComponents.column(
              children: [
                OsmeaComponents.avatar(
                  appearance: ComponentAppearance.ghost,
                  icon: Icons.person,
                  backgroundColor: OsmeaColors.ash.withValues(alpha: 0.1),
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Ghost',
                  variant: OsmeaTextVariant.labelSmall,
                ),
              ],
            ),
            OsmeaComponents.column(
              children: [
                OsmeaComponents.avatar(
                  appearance: ComponentAppearance.flat,
                  icon: Icons.person,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Flat',
                  variant: OsmeaTextVariant.labelSmall,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContentTypesSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Icon Avatars'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            OsmeaComponents.avatar(
              icon: Icons.person,
              size: ComponentSize.medium,
            ),
            OsmeaComponents.avatar(
              icon: Icons.business,
              size: ComponentSize.medium,
              backgroundColor: OsmeaColors.forestHeart,
            ),
            OsmeaComponents.avatar(
              icon: Icons.pets,
              size: ComponentSize.medium,
              backgroundColor: OsmeaColors.sunsetGlow,
            ),
            OsmeaComponents.avatar(
              icon: Icons.music_note,
              size: ComponentSize.medium,
              backgroundColor: OsmeaColors.azureWave,
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 24),
        _buildSubsectionTitle('Text Avatars'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            OsmeaComponents.avatar(
              text: 'JD',
              size: ComponentSize.medium,
            ),
            OsmeaComponents.avatar(
              text: 'AB',
              size: ComponentSize.medium,
              backgroundColor: OsmeaColors.forestHeart,
            ),
            OsmeaComponents.avatar(
              text: 'XY',
              size: ComponentSize.medium,
              backgroundColor: OsmeaColors.sunsetGlow,
            ),
            OsmeaComponents.avatar(
              text: 'MN',
              size: ComponentSize.medium,
              backgroundColor: OsmeaColors.azureWave,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageAvatarsSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Network Image Avatars'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            OsmeaComponents.avatar(
              imageUrl: 'https://picsum.photos/200/200?random=1',
              size: ComponentSize.medium,
              onTap: () => _showSnackBar('Network avatar tapped'),
            ),
            OsmeaComponents.avatar(
              imageUrl: 'https://picsum.photos/200/200?random=2',
              size: ComponentSize.medium,
              borderWidth: 3.0,
              borderColor: OsmeaColors.nordicBlue,
              onTap: () => _showSnackBar('Bordered network avatar tapped'),
            ),
            OsmeaComponents.avatar(
              imageUrl: 'https://picsum.photos/200/200?random=3',
              size: ComponentSize.medium,
              appearance: ComponentAppearance.elevated,
              onTap: () => _showSnackBar('Elevated network avatar tapped'),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.text(
          'Note: Network images may take time to load or fail if network is unavailable.',
          variant: OsmeaTextVariant.bodySmall,
          color: OsmeaColors.pewter,
        ),
      ],
    );
  }

  Widget _buildInteractiveSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Clickable Avatars'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            OsmeaComponents.avatar(
              icon: Icons.person,
              size: ComponentSize.large,
              onTap: () => _showSnackBar('👆 Avatar tapped!'),
              semanticLabel: 'User profile avatar',
            ),
            OsmeaComponents.avatar(
              text: 'ME',
              size: ComponentSize.large,
              backgroundColor: OsmeaColors.forestHeart,
              onTap: () => _showSnackBar('👆 Text avatar tapped!'),
              onLongPress: () => _showSnackBar('👆 Avatar long pressed!'),
              semanticLabel: 'My profile avatar',
            ),
            OsmeaComponents.avatar(
              icon: Icons.add,
              size: ComponentSize.large,
              appearance: ComponentAppearance.outlined,
              borderWidth: 2.0,
              borderColor: OsmeaColors.nordicBlue,
              onTap: () => _showSnackBar('👆 Add avatar tapped!'),
              semanticLabel: 'Add new user',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomStylingSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Custom Border Styles'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            OsmeaComponents.avatar(
              icon: Icons.star,
              backgroundColor: OsmeaColors.sunsetGlow,
              borderWidth: 4.0,
              borderColor: OsmeaColors.amberFlame,
              size: ComponentSize.large,
            ),
            OsmeaComponents.avatar(
              text: 'VIP',
              backgroundColor: OsmeaColors.forestHeart,
              borderWidth: 3.0,
              borderColor: OsmeaColors.white,
              size: ComponentSize.large,
            ),
            OsmeaComponents.avatar(
              icon: Icons.verified,
              backgroundColor: OsmeaColors.azureWave,
              borderWidth: 2.0,
              borderColor: OsmeaColors.nordicBlue,
              size: ComponentSize.large,
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 24),
        _buildSubsectionTitle('Custom Border Radius'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            OsmeaComponents.avatar(
              icon: Icons.square,
              backgroundColor: OsmeaColors.nordicBlue,
              borderRadius: BorderRadius.circular(8),
              size: ComponentSize.medium,
            ),
            OsmeaComponents.avatar(
              text: 'SQ',
              backgroundColor: OsmeaColors.forestHeart,
              borderRadius: BorderRadius.circular(12),
              size: ComponentSize.medium,
            ),
            OsmeaComponents.avatar(
              icon: Icons.hexagon_outlined,
              backgroundColor: OsmeaColors.sunsetGlow,
              borderRadius: BorderRadius.circular(16),
              size: ComponentSize.medium,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAvatarGroupsSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Avatar Stack'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.row(
          children: [
            OsmeaComponents.avatar(
              text: 'JS',
              backgroundColor: OsmeaColors.nordicBlue,
            ),
            Transform.translate(
              offset: const Offset(-12, 0),
              child: OsmeaComponents.avatar(
                text: 'AB',
                backgroundColor: OsmeaColors.forestHeart,
                borderWidth: 2.0,
                borderColor: OsmeaColors.white,
              ),
            ),
            Transform.translate(
              offset: const Offset(-24, 0),
              child: OsmeaComponents.avatar(
                text: 'CD',
                backgroundColor: OsmeaColors.sunsetGlow,
                borderWidth: 2.0,
                borderColor: OsmeaColors.white,
              ),
            ),
            Transform.translate(
              offset: const Offset(-36, 0),
              child: OsmeaComponents.avatar(
                text: '+5',
                backgroundColor: OsmeaColors.pewter,
                borderWidth: 2.0,
                borderColor: OsmeaColors.white,
                onTap: () => _showSnackBar('Show all users'),
              ),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 24),
        _buildSubsectionTitle('Team Members'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildTeamMember('John Doe', 'JD', OsmeaColors.nordicBlue),
            _buildTeamMember('Alice Brown', 'AB', OsmeaColors.forestHeart),
            _buildTeamMember('Charlie Davis', 'CD', OsmeaColors.sunsetGlow),
            _buildTeamMember('Emily White', 'EW', OsmeaColors.azureWave),
          ],
        ),
      ],
    );
  }

  Widget _buildTeamMember(String name, String initials, Color color) {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.avatar(
          text: initials,
          backgroundColor: color,
          size: ComponentSize.medium,
          onTap: () => _showSnackBar('$name profile'),
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.text(
          name,
          variant: OsmeaTextVariant.labelSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildExtensionFeaturesSection() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle('Size Categories'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildExtensionDemoItem(
              'Small Sizes',
              '✅ Extra Small & Small',
              ComponentSize.small,
            ),
            _buildExtensionDemoItem(
              'Medium Size',
              '✅ Standard Size',
              ComponentSize.medium,
            ),
            _buildExtensionDemoItem(
              'Large Sizes',
              '✅ Large & Extra Large',
              ComponentSize.large,
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 24),
        _buildSubsectionTitle('Appearance Features'),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildAppearanceDemo(
              'Solid Appearance',
              'Has solid background color',
              ComponentAppearance.filled,
            ),
            _buildAppearanceDemo(
              'Transparent',
              'Uses transparent background',
              ComponentAppearance.outlined,
            ),
            _buildAppearanceDemo(
              'Has Emphasis',
              'Elevated with shadow effect',
              ComponentAppearance.elevated,
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 24),
        _buildSubsectionTitle('Responsive Design'),
        OsmeaComponents.sizedBox(height: 16),
        _buildResponsiveDemo(),
        OsmeaComponents.sizedBox(height: 24),
        _buildSubsectionTitle('Configuration'),
        OsmeaComponents.sizedBox(height: 16),
        _buildConfigurationDemo(),
        OsmeaComponents.sizedBox(height: 24),
        _buildSubsectionTitle('Content Types'),
        OsmeaComponents.sizedBox(height: 16),
        _buildContentTypeDemo(),
      ],
    );
  }

  Widget _buildExtensionDemoItem(
      String title, String status, ComponentSize size) {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.avatar(
          icon: Icons.star,
          size: size,
          backgroundColor: OsmeaColors.nordicBlue,
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.text(
          title,
          variant: OsmeaTextVariant.labelSmall,
          textAlign: TextAlign.center,
        ),
        OsmeaComponents.text(
          status,
          variant: OsmeaTextVariant.bodySmall,
          color: OsmeaColors.pewter,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAppearanceDemo(
      String title, String status, ComponentAppearance appearance) {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.avatar(
          icon: Icons.palette,
          size: ComponentSize.medium,
          appearance: appearance,
          borderWidth: appearance == ComponentAppearance.outlined ? 2.0 : 0.0,
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.text(
          title,
          variant: OsmeaTextVariant.labelSmall,
          textAlign: TextAlign.center,
        ),
        OsmeaComponents.text(
          status,
          variant: OsmeaTextVariant.bodySmall,
          color: OsmeaColors.pewter,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildResponsiveDemo() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          'Responsive Size',
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.nordicBlue,
        ),
        OsmeaComponents.sizedBox(height: 12),
        OsmeaComponents.row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OsmeaComponents.column(
              children: [
                OsmeaComponents.avatar(
                  text: 'SM',
                  size: ComponentSize.large,
                  backgroundColor: OsmeaColors.forestHeart,
                ),
                OsmeaComponents.sizedBox(height: 4),
                OsmeaComponents.text(
                  'Responsive',
                  variant: OsmeaTextVariant.labelSmall,
                ),
              ],
            ),
            OsmeaComponents.column(
              children: [
                OsmeaComponents.avatar(
                  text: 'MD',
                  size: ComponentSize.medium,
                  backgroundColor: OsmeaColors.sunsetGlow,
                ),
                OsmeaComponents.sizedBox(height: 4),
                OsmeaComponents.text(
                  'Adaptive',
                  variant: OsmeaTextVariant.labelSmall,
                ),
              ],
            ),
            OsmeaComponents.column(
              children: [
                OsmeaComponents.avatar(
                  text: 'LG',
                  size: ComponentSize.extraLarge,
                  backgroundColor: OsmeaColors.azureWave,
                ),
                OsmeaComponents.sizedBox(height: 4),
                OsmeaComponents.text(
                  'Dynamic',
                  variant: OsmeaTextVariant.labelSmall,
                ),
              ],
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 12),
        OsmeaComponents.text(
          'These avatars show different size categories without requiring responsive calculations.',
          variant: OsmeaTextVariant.bodySmall,
          color: OsmeaColors.pewter,
        ),
      ],
    );
  }

  Widget _buildConfigurationDemo() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          'Avatar Configuration',
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.nordicBlue,
        ),
        OsmeaComponents.sizedBox(height: 12),
        OsmeaComponents.wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // Demonstrate size configuration
            OsmeaComponents.column(
              children: [
                OsmeaComponents.avatar(
                  icon: Icons.settings,
                  size: ComponentSize.large,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Size: 64px',
                  variant: OsmeaTextVariant.labelSmall,
                ),
                OsmeaComponents.text(
                  'Icon: 32px',
                  variant: OsmeaTextVariant.bodySmall,
                  color: OsmeaColors.pewter,
                ),
              ],
            ),
            // Demonstrate border radius configuration
            OsmeaComponents.column(
              children: [
                OsmeaComponents.container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: OsmeaColors.nordicBlue,
                  ),
                  child: OsmeaComponents.avatar(
                    icon: Icons.border_all,
                    size: ComponentSize.medium,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Custom Border',
                  variant: OsmeaTextVariant.labelSmall,
                ),
                OsmeaComponents.text(
                  'Radius: 24px',
                  variant: OsmeaTextVariant.bodySmall,
                  color: OsmeaColors.pewter,
                ),
              ],
            ),
            // Demonstrate text style configuration
            OsmeaComponents.column(
              children: [
                OsmeaComponents.avatar(
                  text: 'TX',
                  size: ComponentSize.large,
                  backgroundColor: OsmeaColors.forestHeart,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Text Style',
                  variant: OsmeaTextVariant.labelSmall,
                ),
                OsmeaComponents.text(
                  'Font: 20px',
                  variant: OsmeaTextVariant.bodySmall,
                  color: OsmeaColors.pewter,
                ),
              ],
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 12),
        OsmeaComponents.text(
          'These avatars show standard size configurations for different avatar components.',
          variant: OsmeaTextVariant.bodySmall,
          color: OsmeaColors.pewter,
        ),
      ],
    );
  }

  Widget _buildContentTypeDemo() {
    const iconData = Icons.star;
    const textData = 'AB';
    const imageUrl = 'https://picsum.photos/200/200?random=1';

    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          'Content Type',
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.nordicBlue,
        ),
        OsmeaComponents.sizedBox(height: 12),
        OsmeaComponents.wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            OsmeaComponents.column(
              children: [
                OsmeaComponents.avatar(
                  icon: iconData,
                  size: ComponentSize.medium,
                  backgroundColor: OsmeaColors.nordicBlue,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Icon Data',
                  variant: OsmeaTextVariant.labelSmall,
                ),
                OsmeaComponents.text(
                  '✅ Icon Content',
                  variant: OsmeaTextVariant.bodySmall,
                  color: OsmeaColors.pewter,
                ),
              ],
            ),
            OsmeaComponents.column(
              children: [
                OsmeaComponents.avatar(
                  text: textData,
                  size: ComponentSize.medium,
                  backgroundColor: OsmeaColors.forestHeart,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Text Data',
                  variant: OsmeaTextVariant.labelSmall,
                ),
                OsmeaComponents.text(
                  '✅ Text Content',
                  variant: OsmeaTextVariant.bodySmall,
                  color: OsmeaColors.pewter,
                ),
              ],
            ),
            OsmeaComponents.column(
              children: [
                OsmeaComponents.avatar(
                  imageUrl: imageUrl,
                  size: ComponentSize.medium,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Image URL',
                  variant: OsmeaTextVariant.labelSmall,
                ),
                OsmeaComponents.text(
                  '✅ Image Content',
                  variant: OsmeaTextVariant.bodySmall,
                  color: OsmeaColors.pewter,
                ),
              ],
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 12),
        OsmeaComponents.text(
          'These show different content types supported by avatar components.',
          variant: OsmeaTextVariant.bodySmall,
          color: OsmeaColors.pewter,
        ),
      ],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: OsmeaComponents.text(message),
        backgroundColor: OsmeaColors.nordicBlue,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
