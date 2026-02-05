/*
 * ScrollingBannerWidget
 * ---------------------
 * Horizontally scrolling banner showing open source project info.
 * Loads from local app_config.json directly.
 * Uses seamless infinite scroll animation.
 */

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/utils/config_utils.dart';

/// Scrolling banner widget
class ScrollingBannerWidget extends StatefulWidget {
  final AssetConfigHelper configHelper;

  const ScrollingBannerWidget({
    super.key,
    required this.configHelper,
  });

  @override
  State<ScrollingBannerWidget> createState() => _ScrollingBannerWidgetState();
}

class _ScrollingBannerWidgetState extends State<ScrollingBannerWidget>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _localConfig;
  bool _isLoading = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _loadLocalConfig();
  }

  /// Load local app_config.json directly
  Future<void> _loadLocalConfig() async {
    try {
      final configString = await rootBundle.loadString(
        'assets/app_config.json',
      );
      final config = json.decode(configString) as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          _localConfig = config;
          _isLoading = false;
        });
        _initializeAnimation();
      }
    } catch (e) {
      debugPrint('❌ Failed to load local app_config.json: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Initialize animation
  void _initializeAnimation() {
    final config = _loadBannerConfig();
    final duration = (config?['animation_duration'] as num?)?.toInt() ?? 15;

    _animationController = AnimationController(
      duration: Duration(seconds: duration),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Loads scrolling banner configuration from local config
  Map<String, dynamic>? _loadBannerConfig() {
    try {
      final homeView = _localConfig?['home_view'] as Map<String, dynamic>?;
      return homeView?['scrolling_banner'] as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('Failed to load scrolling banner config: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox.shrink();
    }

    final config = _loadBannerConfig();
    final enabled = config?['enabled'] as bool? ?? false;

    if (!enabled) return const SizedBox.shrink();

    final text = configString(config?['text']) ?? 'Masterfabric Store is an open source project';
    final link = configString(config?['link']);
    final backgroundColor = configString(config?['background_color']) ?? '#000000';
    final textColor = configString(config?['text_color']) ?? '#FFFFFF';
    final height = (config?['height'] as num?)?.toDouble() ?? 40.0;
    final fontSize = (config?['font_size'] as num?)?.toDouble() ?? 14.0;
    final paddingConfig = config?['padding'] as Map<String, dynamic>?;
    final verticalPadding = (paddingConfig?['vertical'] as num?)?.toDouble() ?? 8.0;

    // Compact dimensions to reduce spacing above and below
    final compactHeight = height * 0.8; // 40 -> 32px
    final compactPadding = verticalPadding * 0.6; // 8 -> 4.8px

    return GestureDetector(
      onTap: () async {
        if (link != null && link.isNotEmpty) {
          final uri = Uri.parse(link);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      },
      child: Container(
        height: compactHeight,
        width: double.infinity,
        color: _parseColor(backgroundColor),
        padding: EdgeInsets.symmetric(vertical: compactPadding),
        child: _MarqueeText(
          text: text,
          textColor: _parseColor(textColor),
          fontSize: fontSize,
          animation: _animationController,
        ),
      ),
    );
  }

  /// Parse hex color string to Color
  Color _parseColor(String colorString) {
    try {
      final hex = colorString.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return OsmeaColors.black;
    }
  }
}

/// Marquee text widget for seamless scrolling
class _MarqueeText extends AnimatedWidget {
  final String text;
  final Color textColor;
  final double fontSize;

  const _MarqueeText({
    required this.text,
    required this.textColor,
    required this.fontSize,
    required Animation<double> animation,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // Create the text widget
        final textWidget = Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.visible,
        );

        // Measure text width
        final textPainter = TextPainter(
          text: TextSpan(
            text: text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout();

        final textWidth = textPainter.width;
        final spacing = 32.0; // Space between repeated texts
        final totalWidth = textWidth + spacing;

        return ClipRect(
          child: OverflowBox(
            alignment: Alignment.centerLeft,
            minWidth: 0,
            maxWidth: double.infinity,
            child: Transform.translate(
              offset: Offset(
                -animation.value * totalWidth,
                0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  textWidget,
                  SizedBox(width: spacing),
                  textWidget,
                  SizedBox(width: spacing),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
