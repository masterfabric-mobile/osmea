// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:osmea_components/src/components/buttons/button.dart';
import 'package:osmea_components/src/components/text/text.dart';
import 'package:osmea_components/src/components/column/column.dart';
import 'package:osmea_components/src/components/row/row.dart';
import 'package:osmea_components/src/core/container_widget.dart';
import 'package:osmea_components/src/enums/enums.dart';
import 'package:osmea_components/src/styles/colors.dart';
import 'package:osmea_components/src/utils/card_extensions.dart';

/// 🃏 **OSMEA Card System**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// A comprehensive card system with three main categories:
/// * 📝 Basic Cards - Simple content cards
/// * 🖼️ Image Cards - Cards with image content
/// * 🔘 Action Cards - Cards with interactive elements
///
/// {@category Components}
/// {@subCategory Cards}
///
/// **Features:**
/// * 🎨 Material Design 3 styling
/// * 📱 Responsive design
/// * 🌗 Theme-aware colors
/// * 🎭 Hover and focus states
/// * 🔄 Animation support
/// * 📏 Multiple size variants
/// * 🎯 Custom styling options
///
/// **Card Types:**
/// ```dart
/// // Basic Card
/// OsmeaBasicCard(
///   title: 'Card Title',
///   content: 'Card content here',
/// )
///
/// // Image Card
/// OsmeaImageCard(
///   title: 'Image Card',
///   imageUrl: 'assets/image.jpg',
///   content: 'Description text',
/// )
///
/// // Action Card
/// OsmeaActionCard(
///   title: 'Action Card',
///   content: 'Interactive card',
///   primaryAction: 'Confirm',
///   onPrimaryPressed: () {},
/// )
/// ```

/// 🃏 **Base OSMEA Card**
///
/// Base class for all card components.
/// Provides common styling and behavior for card variants.
class _OsmeaBaseCard extends CoreContainer {
  const _OsmeaBaseCard({
    super.key,
    super.customTheme,
    this.variant = ComponentAppearance.elevated,
    this.size = ComponentSize.medium,
    this.onTap,
    this.elevation,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.shadowColor,
    this.isClickable = false,
    super.margin,
    super.padding, // 🔧 Added missing padding parameter
    super.width,
    this.height,
    super.child,
  });

  /// 🎨 Visual style variant of the card
  final ComponentAppearance variant;

  /// 📏 Size variant of the card
  final ComponentSize size;

  /// 🖱️ Callback when card is tapped
  final VoidCallback? onTap;

  /// 📈 Custom elevation override
  final double? elevation;

  /// ⭕ Custom border radius override
  final BorderRadius? borderRadius;

  /// 🎨 Custom background color
  final Color? backgroundColor;

  /// 🔲 Custom border color
  final Color? borderColor;

  /// 📏 Custom border width
  final double? borderWidth;

  /// 🌫️ Custom shadow color
  final Color? shadowColor;

  /// 🖱️ Whether the card is clickable
  final bool isClickable;

  /// 📏 Custom height of the card
  @override
  final double? height;

  /// Get effective padding based on card size
  EdgeInsets _cardPadding(BuildContext context) => size.cardPadding(context);

  /// Get effective border radius
  BorderRadius _getBorderRadius(BuildContext context) {
    return borderRadius ?? size.cardBorderRadius(context);
  }

  /// Get card decoration based on variant
  Decoration _getCardDecoration(BuildContext context) {
    final effectiveBorderRadius = _getBorderRadius(context);
    final theme = Theme.of(context);

    switch (variant) {
      case ComponentAppearance.elevated:
        return BoxDecoration(
          color: backgroundColor ?? theme.cardColor,
          borderRadius: effectiveBorderRadius,
          boxShadow: [
            BoxShadow(
              color: shadowColor ?? theme.shadowColor.withValues(alpha: 0.15),
              blurRadius: elevation ?? 4.0,
              offset: Offset(0, elevation ?? 2.0),
            ),
          ],
        );

      case ComponentAppearance.outlined:
        return BoxDecoration(
          color: backgroundColor ?? theme.cardColor,
          borderRadius: effectiveBorderRadius,
          border: Border.all(
            color: borderColor ?? theme.dividerColor,
            width: borderWidth ?? 1.0,
          ),
        );

      case ComponentAppearance.filled:
        return BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
          borderRadius: effectiveBorderRadius,
        );

      case ComponentAppearance.ghost:
        return BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: effectiveBorderRadius,
        );

      case ComponentAppearance.flat:
        return BoxDecoration(
          color: backgroundColor ?? theme.cardColor,
          borderRadius: effectiveBorderRadius,
        );
    }
  }

  @override
  Widget buildWidget(BuildContext context) {
    Widget card = Container(
      width: width,
      height: height,
      margin: margin,
      padding: _cardPadding(context),
      decoration: _getCardDecoration(context),
      child: child,
    );

    if (isClickable && onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: _getBorderRadius(context),
          child: card,
        ),
      );
    }

    return card;
  }
}

/// 📝 **OSMEA Basic Card**
///
/// A simple card component for displaying basic content with title and description.
/// Perfect for information display, feature lists, and content previews.
///
/// **Features:**
/// * 🏷️ Title and subtitle support
/// * 📝 Rich content area
/// * 🎨 Customizable styling
/// * 🖱️ Optional click interaction
///
/// **Example:**
/// ```dart
/// OsmeaBasicCard(
///   title: 'Feature Card',
///   subtitle: 'Premium Feature',
///   content: 'This card showcases a premium feature with detailed description.',
///   variant: ComponentAppearance.elevated,
///   size: ComponentSize.medium,
///   height: 200,
///   onTap: () => print('Card tapped'),
/// )
/// ```
class OsmeaBasicCard extends _OsmeaBaseCard {
  const OsmeaBasicCard({
    super.key,
    super.customTheme,
    super.variant,
    super.size,
    super.onTap,
    super.elevation,
    super.borderRadius,
    super.backgroundColor,
    super.borderColor,
    super.borderWidth,
    super.shadowColor,
    super.margin,
    super.padding, // 🔧 Added missing padding parameter
    super.width,
    super.height,
    this.title,
    this.subtitle,
    this.content,
    this.titleStyle,
    this.subtitleStyle,
    this.contentStyle,
    this.titleColor,
    this.subtitleColor,
    this.contentColor,
    this.spacing,
    this.customContent,
  }) : super(isClickable: onTap != null);

  /// 🏷️ Main title text
  final String? title;

  /// 📄 Subtitle text
  final String? subtitle;

  /// 📝 Main content text
  final String? content;

  /// 🎨 Custom title text style
  final TextStyle? titleStyle;

  /// 🎨 Custom subtitle text style
  final TextStyle? subtitleStyle;

  /// 🎨 Custom content text style
  final TextStyle? contentStyle;

  /// 🎯 Custom title color
  final Color? titleColor;

  /// 🎯 Custom subtitle color
  final Color? subtitleColor;

  /// 🎯 Custom content color
  final Color? contentColor;

  /// 📏 Custom spacing between elements
  final double? spacing;

  /// 🎨 Custom content widget (overrides text content)
  final Widget? customContent;

  @override
  Widget buildWidget(BuildContext context) {
    return _OsmeaBaseCard(
      key: key,
      customTheme: customTheme,
      variant: variant,
      size: size,
      onTap: onTap,
      elevation: elevation,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadowColor: shadowColor,
      margin: margin,
      width: width,
      height: height,
      isClickable: isClickable,
      child: _buildCardContent(context),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    if (customContent != null) {
      return customContent!;
    }

    final effectiveSpacing = spacing ?? 16.0;
    final children = <Widget>[];

    // Add title
    if (title != null) {
      children.add(
        OsmeaText(
          title!,
          variant: _getTitleVariant(),
          color: titleColor,
          style: titleStyle,
        ),
      );
    }

    // Add spacing after title
    if (title != null && (subtitle != null || content != null)) {
      children.add(SizedBox(height: effectiveSpacing * 0.5));
    }

    // Add subtitle
    if (subtitle != null) {
      children.add(
        OsmeaText(
          subtitle!,
          variant: _getSubtitleVariant(),
          color: subtitleColor ?? OsmeaColors.pewter,
          style: subtitleStyle,
        ),
      );
    }

    // Add spacing after subtitle
    if (subtitle != null && content != null) {
      children.add(SizedBox(height: effectiveSpacing));
    }

    // Add content
    if (content != null) {
      children.add(
        OsmeaText(
          content!,
          variant: _getContentVariant(),
          color: contentColor,
          style: contentStyle,
        ),
      );
    }

    return OsmeaColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  OsmeaTextVariant _getTitleVariant() {
    switch (size) {
      case ComponentSize.extraSmall:
        return OsmeaTextVariant.titleSmall;
      case ComponentSize.small:
        return OsmeaTextVariant.titleSmall;
      case ComponentSize.medium:
        return OsmeaTextVariant.titleMedium;
      case ComponentSize.large:
        return OsmeaTextVariant.titleLarge;
      case ComponentSize.extraLarge:
        return OsmeaTextVariant.titleLarge;
    }
  }

  OsmeaTextVariant _getSubtitleVariant() {
    switch (size) {
      case ComponentSize.extraSmall:
        return OsmeaTextVariant.labelSmall;
      case ComponentSize.small:
        return OsmeaTextVariant.labelSmall;
      case ComponentSize.medium:
        return OsmeaTextVariant.labelMedium;
      case ComponentSize.large:
        return OsmeaTextVariant.labelLarge;
      case ComponentSize.extraLarge:
        return OsmeaTextVariant.labelLarge;
    }
  }

  OsmeaTextVariant _getContentVariant() {
    switch (size) {
      case ComponentSize.extraSmall:
        return OsmeaTextVariant.bodySmall;
      case ComponentSize.small:
        return OsmeaTextVariant.bodySmall;
      case ComponentSize.medium:
        return OsmeaTextVariant.bodyMedium;
      case ComponentSize.large:
        return OsmeaTextVariant.bodyLarge;
      case ComponentSize.extraLarge:
        return OsmeaTextVariant.bodyLarge;
    }
  }
}

/// 🖼️ **OSMEA Image Card**
///
/// A card component designed for displaying image content with optional text overlay.
/// Perfect for galleries, product cards, article previews, and media content.
///
/// **Features:**
/// * 🖼️ Image display with multiple sources
/// * 📝 Title and description overlay
/// * 🎭 Image fit and alignment options
/// * 🔄 Loading and error states
/// * 🎨 Gradient overlay support
/// * 📏 Text overflow control for consistent heights
///
/// **Example:**
/// ```dart
/// OsmeaImageCard(
///   title: 'Beautiful Landscape',
///   subtitle: 'Nature Photography',
///   imageUrl: 'https://example.com/image.jpg',
///   height: 250,
///   imageHeight: 200,
///   titleMaxLines: 2,
///   textOverflow: TextOverflow.ellipsis,
///   imagePosition: ComponentPosition.top,
///   onTap: () => print('Image card tapped'),
/// )
/// ```
class OsmeaImageCard extends _OsmeaBaseCard {
  const OsmeaImageCard({
    super.key,
    super.customTheme,
    super.variant,
    super.size,
    super.onTap,
    super.elevation,
    super.borderRadius,
    super.backgroundColor,
    super.borderColor,
    super.shadowColor,
    super.margin,
    super.padding, // 🔧 Added missing padding parameter
    super.width,
    super.height,
    this.title,
    this.subtitle,
    this.subtitle2,
    this.content,
    this.imageUrl,
    this.imageAsset,
    this.imageWidget,
    this.imageHeight,
    this.imagePosition = ComponentPosition.top,
    this.imageFit = BoxFit.cover,
    this.imageAlignment = Alignment.center,
    this.showOverlay = false,
    this.overlayGradient,
    this.titleStyle,
    this.subtitleStyle,
    this.subtitle2Style,
    this.contentStyle,
    this.titleColor,
    this.subtitleColor,
    this.subtitle2Color,
    this.contentColor,
    this.spacing,
    this.loadingWidget,
    this.errorWidget,
    this.semanticLabel,
    this.badge,
    this.badgePosition = BadgePosition.topRight,
    this.imageBorderRadius,
    this.child,
    // 📏 Text overflow control parameters
    this.titleMaxLines = 2,
    this.subtitleMaxLines = 1,
    this.subtitle2MaxLines = 1,
    this.contentMaxLines = 3,
    this.textOverflow = TextOverflow.ellipsis,
    this.textAreaHeight,
    this.maintainAspectRatio = false,
  }) : super(isClickable: onTap != null);

  /// 🏷️ Main title text
  final String? title;

  /// 📄 Subtitle text
  final String? subtitle;

  /// � Second subtitle text (for price comparison)
  final String? subtitle2;

  /// �📝 Content description
  final String? content;

  /// 🌐 Network image URL
  final String? imageUrl;

  /// 📁 Local asset image path
  final String? imageAsset;

  /// 🎨 Custom image widget
  final Widget? imageWidget;

  /// 📏 Height of the image area
  final double? imageHeight;

  /// 📍 Position of image relative to content
  final ComponentPosition imagePosition;

  /// 🔄 How the image should fit in its container
  final BoxFit imageFit;

  /// 📐 Alignment of the image within its container
  final Alignment imageAlignment;

  /// 🎭 Whether to show overlay on image
  final bool showOverlay;

  /// 🌈 Custom gradient overlay
  final Gradient? overlayGradient;

  /// 🎨 Custom title text style
  final TextStyle? titleStyle;

  /// 🎨 Custom subtitle text style
  final TextStyle? subtitleStyle;

  /// 🎨 Custom subtitle2 text style
  final TextStyle? subtitle2Style;

  /// 🎨 Custom content text style
  final TextStyle? contentStyle;

  /// 🎯 Custom title color
  final Color? titleColor;

  /// 🎯 Custom subtitle color
  final Color? subtitleColor;

  /// 🎯 Custom subtitle2 color
  final Color? subtitle2Color;

  /// 🎯 Custom content color
  final Color? contentColor;

  /// 📏 Custom spacing between elements
  final double? spacing;

  /// 🔄 Widget to show while image is loading
  final Widget? loadingWidget;

  /// ❌ Widget to show when image fails to load
  final Widget? errorWidget;

  /// ♿ Semantic label for accessibility
  final String? semanticLabel;

  final Widget? badge;
  final BadgePosition badgePosition;
  final BorderRadius? imageBorderRadius;

  /// 🎨 Custom child widget to display alongside content
  @override
  final Widget? child;

  // 📏 **TEXT OVERFLOW CONTROL PARAMETERS**

  /// 📝 Maximum lines for title text (prevents height inconsistency)
  final int? titleMaxLines;

  /// 📝 Maximum lines for subtitle text
  final int? subtitleMaxLines;

  /// 📝 Maximum lines for subtitle2 text
  final int? subtitle2MaxLines;

  /// 📝 Maximum lines for content text
  final int? contentMaxLines;

  /// ✂️ Text overflow behavior (ellipsis, fade, clip, visible)
  final TextOverflow textOverflow;

  /// 📏 Fixed height for text area (ensures consistent card heights)
  final double? textAreaHeight;

  /// 🔄 Whether to maintain aspect ratio for consistent sizing
  final bool maintainAspectRatio;

  @override
  Widget buildWidget(BuildContext context) {
    return _OsmeaBaseCard(
      key: key,
      customTheme: customTheme,
      variant: variant,
      size: size,
      onTap: onTap,
      elevation: elevation,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      shadowColor: shadowColor,
      margin: margin,
      width: width,
      height: height,
      isClickable: isClickable,
      child: _buildCardContent(context),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    final imageWidget = _buildImageWidget(context);
    final textContent = _buildTextContent(context);

    if (imagePosition.isVerticalImage) {
      return OsmeaColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: maintainAspectRatio ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (imagePosition == ComponentPosition.top) ...[
            if (imageWidget != null) imageWidget,
            if (imageWidget != null && textContent != null)
              SizedBox(height: spacing ?? 16.0),
            if (textContent != null)
              maintainAspectRatio ? Expanded(child: textContent) : textContent,
          ] else ...[
            if (textContent != null)
              maintainAspectRatio ? Expanded(child: textContent) : textContent,
            if (textContent != null && imageWidget != null)
              SizedBox(height: spacing ?? 16.0),
            if (imageWidget != null) imageWidget,
          ],
          if (child != null) child!,
        ],
      );
    } else if (imagePosition.isHorizontalImage) {
      final isLeftPosition = imagePosition == ComponentPosition.left ||
          imagePosition == ComponentPosition.start;
      return OsmeaRow(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLeftPosition) ...[
            if (imageWidget != null)
              Flexible(
                flex: imageHeight != null ? 0 : 1,
                child: imageWidget,
              ),
            if (imageWidget != null && textContent != null)
              SizedBox(width: spacing ?? 16.0),
            if (textContent != null) Expanded(flex: 2, child: textContent),
          ] else ...[
            if (textContent != null) Expanded(flex: 2, child: textContent),
            if (textContent != null && imageWidget != null)
              SizedBox(width: spacing ?? 16.0),
            if (imageWidget != null)
              Flexible(
                flex: imageHeight != null ? 0 : 1,
                child: imageWidget,
              ),
          ],
          if (child != null) child!,
        ],
      );
    } else if (imagePosition.isBackgroundImage) {
      return Stack(
        children: [
          if (imageWidget != null) Positioned.fill(child: imageWidget),
          if (showOverlay) _buildOverlay(),
          if (textContent != null) textContent,
          if (child != null) child!,
        ],
      );
    } else if (imagePosition == ComponentPosition.center) {
      return OsmeaRow(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageWidget != null) imageWidget,
          if (imageWidget != null && textContent != null)
            SizedBox(width: spacing ?? 16.0),
          if (textContent != null) Expanded(child: textContent),
          if (child != null) child!,
        ],
      );
    }

    // Fallback for other positions
    return OsmeaColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: maintainAspectRatio ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (imageWidget != null) imageWidget,
        if (imageWidget != null && textContent != null)
          SizedBox(height: spacing ?? 16.0),
        if (textContent != null)
          maintainAspectRatio ? Expanded(child: textContent) : textContent,
        if (child != null) child!,
      ],
    );
  }

  Widget? _buildImageWidget(BuildContext context) {
    Widget? image;

    if (imageWidget != null) {
      image = imageWidget!;
    } else if (imageUrl != null) {
      image = Image.network(
        imageUrl!,
        fit: imageFit,
        alignment: imageAlignment,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return loadingWidget ?? _buildDefaultLoading(context);
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _buildDefaultError(context);
        },
        semanticLabel: semanticLabel,
      );
    } else if (imageAsset != null) {
      image = Image.asset(
        imageAsset!,
        fit: imageFit,
        alignment: imageAlignment,
        semanticLabel: semanticLabel,
      );
    }

    if (image == null) return null;

    // Wrap with height constraint if specified
    if (imageHeight != null) {
      if (imagePosition.isHorizontalImage) {
        image = SizedBox(
          height: imageHeight,
          width: imageHeight! * 1.2,
          child: image,
        );
      } else {
        image = SizedBox(
          height: imageHeight,
          width: double.infinity,
          child: image,
        );
      }
    }

    // Add border radius for non-background images
    if (!imagePosition.isBackgroundImage) {
      final BorderRadius effectiveImageBorderRadius = imageBorderRadius ??
          (borderRadius ??
              (size == ComponentSize.small
                  ? BorderRadius.circular(4.0)
                  : size == ComponentSize.medium
                      ? BorderRadius.circular(8.0)
                      : BorderRadius.circular(12.0)));
      image = ClipRRect(
        borderRadius: effectiveImageBorderRadius,
        child: image,
      );
    }

    // Only overlay badge if image exists and badge is provided
    if (badge != null) {
      image = Stack(
        clipBehavior: Clip.none,
        children: [
          image,
          Positioned(
            left: badgePosition == BadgePosition.topLeft ||
                    badgePosition == BadgePosition.bottomLeft
                ? 0.0
                : null,
            right: badgePosition == BadgePosition.topRight ||
                    badgePosition == BadgePosition.bottomRight
                ? 0.0
                : null,
            top: badgePosition == BadgePosition.topLeft ||
                    badgePosition == BadgePosition.topRight
                ? 0.0
                : null,
            bottom: badgePosition == BadgePosition.bottomLeft ||
                    badgePosition == BadgePosition.bottomRight
                ? 0.0
                : null,
            child: badge!,
          ),
        ],
      );
    }

    return image;
  }

  Widget? _buildTextContent(BuildContext context) {
    if (title == null && subtitle == null && content == null) {
      return null;
    }

    final effectiveSpacing = spacing ?? 8.0;
    final children = <Widget>[];

    // Add title with maxLines control
    if (title != null) {
      children.add(
        OsmeaText(
          title!,
          variant: _getTitleVariant(),
          color: titleColor ?? (showOverlay ? Colors.white : null),
          style: titleStyle,
          maxLines: titleMaxLines,
          overflow: textOverflow,
        ),
      );
    }

    // Add spacing after title
    if (title != null &&
        (subtitle != null || subtitle2 != null || content != null)) {
      children.add(SizedBox(height: effectiveSpacing));
    }

    // Add subtitle(s) with maxLines control - side by side if both exist
    if (subtitle != null || subtitle2 != null) {
      if (subtitle != null && subtitle2 != null) {
        // Both subtitles exist - display side by side
        children.add(
          OsmeaRow(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              OsmeaText(
                subtitle!,
                variant: _getSubtitleVariant(),
                color: subtitleColor ??
                    (showOverlay ? Colors.white70 : OsmeaColors.pewter),
                style: subtitleStyle,
                maxLines: subtitleMaxLines,
                overflow: textOverflow,
              ),
              SizedBox(width: effectiveSpacing),
              OsmeaText(
                subtitle2!,
                variant: _getSubtitleVariant(),
                color: subtitle2Color ??
                    (showOverlay ? Colors.white70 : OsmeaColors.pewter),
                style: subtitle2Style,
                maxLines: subtitle2MaxLines,
                overflow: textOverflow,
              ),
            ],
          ),
        );
      } else if (subtitle != null) {
        // Only first subtitle exists
        children.add(
          OsmeaText(
            subtitle!,
            variant: _getSubtitleVariant(),
            color: subtitleColor ??
                (showOverlay ? Colors.white70 : OsmeaColors.pewter),
            style: subtitleStyle,
            maxLines: subtitleMaxLines,
            overflow: textOverflow,
          ),
        );
      } else if (subtitle2 != null) {
        // Only second subtitle exists
        children.add(
          OsmeaText(
            subtitle2!,
            variant: _getSubtitleVariant(),
            color: subtitle2Color ??
                (showOverlay ? Colors.white70 : OsmeaColors.pewter),
            style: subtitle2Style,
            maxLines: subtitle2MaxLines,
            overflow: textOverflow,
          ),
        );
      }
    }

    // Add spacing after subtitle(s)
    if ((subtitle != null || subtitle2 != null) && content != null) {
      children.add(SizedBox(height: effectiveSpacing));
    }

    // Add content with maxLines control
    if (content != null) {
      children.add(
        OsmeaText(
          content!,
          variant: _getContentVariant(),
          color: contentColor ?? (showOverlay ? Colors.white : null),
          style: contentStyle,
          maxLines: contentMaxLines,
          overflow: textOverflow,
        ),
      );
    }

    Widget textContent = OsmeaColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: maintainAspectRatio ? MainAxisSize.max : MainAxisSize.min,
      children: children,
    );

    // Apply fixed text area height if specified
    if (textAreaHeight != null) {
      textContent = SizedBox(
        height: textAreaHeight,
        child: textContent,
      );
    } else if (maintainAspectRatio) {
      // Force consistent height when maintainAspectRatio is true
      textContent = Expanded(
        child: textContent,
      );
    }

    return textContent;
  }

  Widget _buildOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: overlayGradient ??
            LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.7),
              ],
            ),
      ),
    );
  }

  Widget _buildDefaultLoading(BuildContext context) {
    return Container(
      height: imageHeight ?? 150,
      color: OsmeaColors.ash,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildDefaultError(BuildContext context) {
    return Container(
      height: imageHeight ?? 150,
      color: OsmeaColors.ash,
      child: const Center(
        child: Icon(
          Icons.error_outline,
          color: Colors.grey,
          size: 32,
        ),
      ),
    );
  }

  OsmeaTextVariant _getTitleVariant() {
    switch (size) {
      case ComponentSize.extraSmall:
        return OsmeaTextVariant.titleSmall;
      case ComponentSize.small:
        return OsmeaTextVariant.titleSmall;
      case ComponentSize.medium:
        return OsmeaTextVariant.titleMedium;
      case ComponentSize.large:
        return OsmeaTextVariant.titleLarge;
      case ComponentSize.extraLarge:
        return OsmeaTextVariant.titleLarge;
    }
  }

  OsmeaTextVariant _getSubtitleVariant() {
    switch (size) {
      case ComponentSize.extraSmall:
        return OsmeaTextVariant.labelSmall;
      case ComponentSize.small:
        return OsmeaTextVariant.labelSmall;
      case ComponentSize.medium:
        return OsmeaTextVariant.labelMedium;
      case ComponentSize.large:
        return OsmeaTextVariant.labelLarge;
      case ComponentSize.extraLarge:
        return OsmeaTextVariant.labelLarge;
    }
  }

  OsmeaTextVariant _getContentVariant() {
    switch (size) {
      case ComponentSize.extraSmall:
        return OsmeaTextVariant.bodySmall;
      case ComponentSize.small:
        return OsmeaTextVariant.bodySmall;
      case ComponentSize.medium:
        return OsmeaTextVariant.bodyMedium;
      case ComponentSize.large:
        return OsmeaTextVariant.bodyLarge;
      case ComponentSize.extraLarge:
        return OsmeaTextVariant.bodyLarge;
    }
  }
}

/// 🔘 **OSMEA Action Card**
///
/// An interactive card component with built-in action buttons.
/// Perfect for decision dialogs, confirmation cards, and interactive content.
///
/// **Features:**
/// * 🔘 Primary and secondary action buttons
/// * 📝 Title, subtitle, and content areas
/// * 🎭 Button customization options
/// * 🎨 Action area styling
/// * 📱 Responsive button layout
///
/// **Example:**
/// ```dart
/// OsmeaActionCard(
///   title: 'Confirm Action',
///   content: 'Are you sure you want to proceed with this action?',
///   height: 180,
///   primaryAction: 'Confirm',
///   secondaryAction: 'Cancel',
///   onPrimaryPressed: () => print('Confirmed'),
///   onSecondaryPressed: () => print('Cancelled'),
///   primaryVariant: ButtonVariant.primary,
///   secondaryVariant: ButtonVariant.outlined,
/// )
/// ```
class OsmeaActionCard extends _OsmeaBaseCard {
  const OsmeaActionCard({
    super.key,
    super.customTheme,
    super.variant,
    super.size,
    super.elevation,
    super.borderRadius,
    super.backgroundColor,
    super.borderColor,
    super.shadowColor,
    super.margin,
    super.padding, // 🔧 Added missing padding parameter
    super.width,
    super.height,
    this.title,
    this.subtitle,
    this.content,
    this.primaryAction,
    this.secondaryAction,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.primaryVariant = ButtonVariant.primary,
    this.secondaryVariant = ButtonVariant.outlined,
    this.primarySize,
    this.secondarySize,
    this.primaryIcon,
    this.secondaryIcon,
    this.buttonLayout = ComponentOrientation.horizontal,
    this.actionSpacing,
    this.contentSpacing,
    this.titleStyle,
    this.subtitleStyle,
    this.contentStyle,
    this.titleColor,
    this.subtitleColor,
    this.contentColor,
    this.customContent,
    this.customActions,
    this.leading,
    this.trailing,
    this.onCardTap,
    this.backgroundGradient,
  });

  final String? title;
  final String? subtitle;
  final String? content;

  final String? primaryAction;
  final String? secondaryAction;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final ButtonVariant primaryVariant;
  final ButtonVariant secondaryVariant;
  final ButtonSize? primarySize;
  final ButtonSize? secondarySize;
  final Widget? primaryIcon;
  final Widget? secondaryIcon;
  final ComponentOrientation buttonLayout;
  final double? actionSpacing;
  final double? contentSpacing;

  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? contentStyle;
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? contentColor;

  final Widget? customContent;
  final Widget? customActions;

  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onCardTap;
  final Gradient? backgroundGradient;

  @override
  Widget buildWidget(BuildContext context) {
    return _OsmeaBaseCard(
      key: key,
      customTheme: customTheme,
      variant: variant,
      size: size,
      elevation: elevation,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadowColor: shadowColor,
      margin: margin,
      width: width,
      height: height,
      isClickable: onCardTap != null,
      onTap: onCardTap,
      child: SizedBox(
        width: double.infinity, // Ensure full width
        child: _buildCardContent(context),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    final contentWidget = _buildContentArea(context);
    final actionsWidget = _buildActionsArea(context);
    final effectiveContentSpacing = contentSpacing ?? 20.0;

    return SizedBox(
      width: double.infinity, // Ensure full width
      child: OsmeaColumn(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Stretch children to full width
        mainAxisSize: MainAxisSize.min,
        children: [
          if (contentWidget != null) contentWidget,
          if (contentWidget != null && actionsWidget != null)
            SizedBox(height: effectiveContentSpacing),
          if (actionsWidget != null) actionsWidget,
        ],
      ),
    );
  }

  Widget? _buildContentArea(BuildContext context) {
    if (customContent != null) return customContent!;
    if (title == null && subtitle == null && content == null) return null;

    final List<Widget> children = [];

    // Add title
    if (title != null) {
      children.add(
        SizedBox(
          width: double.infinity, // Full width
          child: OsmeaText(
            title!,
            variant: _getTitleVariant(),
            color: titleColor,
            style: titleStyle,
          ),
        ),
      );
    }

    // Add subtitle
    if (subtitle != null) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(height: 8));
      }
      children.add(
        SizedBox(
          width: double.infinity, // Full width
          child: OsmeaText(
            subtitle!,
            variant: _getSubtitleVariant(),
            color: subtitleColor ?? OsmeaColors.pewter,
            style: subtitleStyle,
          ),
        ),
      );
    }

    // Add content
    if (content != null) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(height: 16));
      }
      children.add(
        SizedBox(
          width: double.infinity, // Full width
          child: OsmeaText(
            content!,
            variant: _getContentVariant(),
            color: contentColor,
            style: contentStyle?.copyWith(height: 1.5) ??
                const TextStyle(height: 1.5),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity, // Ensure the container takes full width
      child: OsmeaColumn(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Stretch children to full width
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  Widget? _buildActionsArea(BuildContext context) {
    if (customActions != null) return customActions!;

    final List<Widget> buttons = [];
    final effectiveButtonSize = _getEffectiveButtonSize();
    final effectiveActionSpacing = actionSpacing ?? 16.0;

    if (secondaryAction != null) {
      buttons.add(
        OsmeaButton(
          text: secondaryAction!,
          variant: secondaryVariant,
          size: effectiveButtonSize,
          icon: secondaryIcon,
          onPressed: onSecondaryPressed,
        ),
      );
    }

    if (primaryAction != null) {
      buttons.add(
        OsmeaButton(
          text: primaryAction!,
          variant: primaryVariant,
          size: effectiveButtonSize,
          icon: primaryIcon,
          onPressed: onPrimaryPressed,
        ),
      );
    }

    if (buttons.isEmpty) return null;

    switch (buttonLayout) {
      case ComponentOrientation.horizontal:
        return SizedBox(
          width: double.infinity,
          child: OsmeaRow(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (secondaryAction != null && primaryAction != null) ...[
                Expanded(
                  child: OsmeaButton(
                    text: secondaryAction!,
                    variant: secondaryVariant,
                    size: effectiveButtonSize,
                    icon: secondaryIcon,
                    onPressed: onSecondaryPressed,
                  ),
                ),
                SizedBox(width: effectiveActionSpacing),
                Expanded(
                  child: OsmeaButton(
                    text: primaryAction!,
                    variant: primaryVariant,
                    size: effectiveButtonSize,
                    icon: primaryIcon,
                    onPressed: onPrimaryPressed,
                  ),
                ),
              ] else if (primaryAction != null) ...[
                Expanded(
                  child: OsmeaButton(
                    text: primaryAction!,
                    variant: primaryVariant,
                    size: effectiveButtonSize,
                    icon: primaryIcon,
                    onPressed: onPrimaryPressed,
                  ),
                ),
              ] else if (secondaryAction != null) ...[
                Expanded(
                  child: OsmeaButton(
                    text: secondaryAction!,
                    variant: secondaryVariant,
                    size: effectiveButtonSize,
                    icon: secondaryIcon,
                    onPressed: onSecondaryPressed,
                  ),
                ),
              ],
            ],
          ),
        );
      case ComponentOrientation.vertical:
        return OsmeaColumn(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: _buildVerticalButtonList(buttons, effectiveActionSpacing),
        );
    }
  }

  List<Widget> _buildVerticalButtonList(List<Widget> buttons, double spacing) {
    if (buttons.isEmpty) return [];

    final List<Widget> result = [];

    // Add primary button first (if exists)
    if (primaryAction != null) {
      result.add(
        SizedBox(
          width: double.infinity,
          child: OsmeaButton(
            text: primaryAction!,
            variant: primaryVariant,
            size: _getEffectiveButtonSize(),
            icon: primaryIcon,
            onPressed: onPrimaryPressed,
          ),
        ),
      );
    }

    // Add spacing between buttons
    if (primaryAction != null && secondaryAction != null) {
      result.add(SizedBox(height: spacing));
    }

    // Add secondary button second (if exists)
    if (secondaryAction != null) {
      result.add(
        SizedBox(
          width: double.infinity,
          child: OsmeaButton(
            text: secondaryAction!,
            variant: secondaryVariant,
            size: _getEffectiveButtonSize(),
            icon: secondaryIcon,
            onPressed: onSecondaryPressed,
          ),
        ),
      );
    }

    return result;
  }

  ButtonSize _getEffectiveButtonSize() {
    if (primarySize != null) return primarySize!;
    if (secondarySize != null) return secondarySize!;
    switch (size) {
      case ComponentSize.extraSmall:
        return ButtonSize.extraSmall;
      case ComponentSize.small:
        return ButtonSize.small;
      case ComponentSize.medium:
        return ButtonSize.medium;
      case ComponentSize.large:
        return ButtonSize.large;
      case ComponentSize.extraLarge:
        return ButtonSize.extraLarge;
    }
  }

  OsmeaTextVariant _getTitleVariant() {
    switch (size) {
      case ComponentSize.extraSmall:
        return OsmeaTextVariant.titleSmall;
      case ComponentSize.small:
        return OsmeaTextVariant.titleSmall;
      case ComponentSize.medium:
        return OsmeaTextVariant.titleMedium;
      case ComponentSize.large:
        return OsmeaTextVariant.titleLarge;
      case ComponentSize.extraLarge:
        return OsmeaTextVariant.titleLarge;
    }
  }

  OsmeaTextVariant _getSubtitleVariant() {
    switch (size) {
      case ComponentSize.extraSmall:
        return OsmeaTextVariant.labelSmall;
      case ComponentSize.small:
        return OsmeaTextVariant.labelSmall;
      case ComponentSize.medium:
        return OsmeaTextVariant.labelMedium;
      case ComponentSize.large:
        return OsmeaTextVariant.labelLarge;
      case ComponentSize.extraLarge:
        return OsmeaTextVariant.labelLarge;
    }
  }

  OsmeaTextVariant _getContentVariant() {
    switch (size) {
      case ComponentSize.extraSmall:
        return OsmeaTextVariant.bodySmall;
      case ComponentSize.small:
        return OsmeaTextVariant.bodySmall;
      case ComponentSize.medium:
        return OsmeaTextVariant.bodyMedium;
      case ComponentSize.large:
        return OsmeaTextVariant.bodyLarge;
      case ComponentSize.extraLarge:
        return OsmeaTextVariant.bodyLarge;
    }
  }
}
