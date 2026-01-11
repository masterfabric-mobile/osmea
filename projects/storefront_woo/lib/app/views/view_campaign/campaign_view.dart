/*
 * CampaignView
 * ------------
 * Full-screen campaign image display view.
 * Shows campaign images from app_config.json for 1.5 seconds,
 * then navigates to home screen.
 */

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/utils/unified_loading_widget.dart';
import 'package:storefront_woo/gen/translations.g.dart';

/// Campaign view that displays full-screen campaign images
class CampaignView extends StatefulWidget {
  final Function(String) goRoute;

  const CampaignView({super.key, required this.goRoute});

  @override
  State<CampaignView> createState() => _CampaignViewState();
}

class _CampaignViewState extends State<CampaignView>
    with SingleTickerProviderStateMixin {
  Timer? _navigationTimer;
  AssetConfigHelper? _configHelper;
  List<CampaignImageItem> _campaignImages = [];
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadCampaignConfig();
    _startNavigationTimer();
    // Start animation immediately for smooth fade-in effect
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  /// Get animation config from app_config.json
  Map<String, dynamic>? _getAnimationConfig() {
    try {
      return _configHelper?.getObject('campaign_view.animation');
    } catch (e) {
      debugPrint('⚠️ Failed to load animation config: $e');
      return null;
    }
  }

  /// Initialize fade-in and scale animations
  void _initializeAnimations() {
    final animConfig = _getAnimationConfig();
    final duration = Duration(
      milliseconds:
          (animConfig?['duration_milliseconds'] as num?)?.toInt() ?? 800,
    );

    _animationController = AnimationController(vsync: this, duration: duration);

    final fadeBegin = (animConfig?['fade_begin'] as num?)?.toDouble() ?? 0.0;
    final fadeEnd = (animConfig?['fade_end'] as num?)?.toDouble() ?? 1.0;
    final scaleBegin = (animConfig?['scale_begin'] as num?)?.toDouble() ?? 0.8;
    final scaleEnd = (animConfig?['scale_end'] as num?)?.toDouble() ?? 1.0;
    final curveName = animConfig?['curve'] as String? ?? 'easeInOut';

    final curve = _getCurveFromString(curveName);

    _fadeAnimation = Tween<double>(
      begin: fadeBegin,
      end: fadeEnd,
    ).animate(CurvedAnimation(parent: _animationController, curve: curve));

    _scaleAnimation = Tween<double>(begin: scaleBegin, end: scaleEnd).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  /// Get curve from string name
  Curve _getCurveFromString(String curveName) {
    switch (curveName.toLowerCase()) {
      case 'easeinout':
        return Curves.easeInOut;
      case 'easein':
        return Curves.easeIn;
      case 'easeout':
        return Curves.easeOut;
      case 'linear':
        return Curves.linear;
      default:
        return Curves.easeInOut;
    }
  }

  /// Load campaign configuration from app_config.json
  void _loadCampaignConfig() {
    _configHelper = AssetConfigHelper();

    // Load config asynchronously
    _configHelper?.loadConfig('assets/app_config.json').then((_) {
      if (mounted) {
        setState(() {
          _campaignImages = _getCampaignImages();
        });
      }
    });
  }

  /// Get campaign images from config
  List<CampaignImageItem> _getCampaignImages() {
    try {
      final config = _configHelper?.getObject('home_view.campaign_cards');
      if (config == null) return [];

      final List<dynamic>? itemsList = config['items'] as List<dynamic>?;
      if (itemsList == null || itemsList.isEmpty) return [];

      return itemsList
          .map((item) {
            final map = item as Map<String, dynamic>;
            return CampaignImageItem(
              imageUrl: map['imageUrl'] as String? ?? '',
              title: map['title'] as String?,
              subtitle: map['subtitle'] as String?,
            );
          })
          .where((item) => item.imageUrl.isNotEmpty)
          .toList();
    } catch (e) {
      debugPrint('⚠️ Failed to load campaign images: $e');
      return [];
    }
  }

  /// Get navigation timer duration from config
  Duration _getNavigationTimerDuration() {
    try {
      final navConfig = _configHelper?.getObject('campaign_view.navigation');
      final durationMs =
          (navConfig?['timer_duration_milliseconds'] as num?)?.toInt() ?? 1500;
      return Duration(milliseconds: durationMs);
    } catch (e) {
      debugPrint('⚠️ Failed to load navigation timer config: $e');
      return const Duration(milliseconds: 1500);
    }
  }

  /// Start timer to navigate to home after configured duration
  void _startNavigationTimer() {
    final duration = _getNavigationTimerDuration();
    _navigationTimer = Timer(duration, () {
      if (mounted) {
        debugPrint('🎯 Campaign view completed, navigating to home');
        widget.goRoute('/home');
      }
    });
  }

  /// Get background color from config
  Color _getBackgroundColor() {
    try {
      final colorString =
          _configHelper?.getString('campaign_view.backgroundColor') ??
          '#FFFFFF';
      if (colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load background color: $e');
    }
    return OsmeaColors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: _getBackgroundColor(),
        child: _campaignImages.isEmpty
            ? _buildLoadingState()
            : _buildCampaignImage(),
      ),
    );
  }

  /// Build loading state while config is loading
  Widget _buildLoadingState() {
    return UnifiedLoadingWidget(goRoute: widget.goRoute);
  }

  /// Build full-screen campaign image
  Widget _buildCampaignImage() {
    // If no campaign images available, navigate to home immediately
    if (_campaignImages.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.goRoute('/home');
        }
      });
      return UnifiedLoadingWidget(goRoute: widget.goRoute);
    }

    // Ensure currentIndex is valid
    if (_currentIndex >= _campaignImages.length) {
      _currentIndex = 0;
    }

    final currentCampaign = _campaignImages[_currentIndex];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen campaign image with scale animation
          ScaleTransition(
            scale: _scaleAnimation,
            alignment: Alignment.center,
            child: OsmeaComponents.image(
              imageUrl: currentCampaign.imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              variant: ImageVariant.normal,
              borderRadius: BorderRadius.zero,
              cacheWidth: null, // Full resolution for full-screen
              showLoadingIndicator: true,
              errorWidget: _buildErrorWidget(),
            ),
          ),
          // Optional: Gradient overlay for text readability
          if (_shouldShowGradientOverlay(currentCampaign))
            _buildGradientOverlay(),
          // Optional: Text overlay
          if (currentCampaign.title != null || currentCampaign.subtitle != null)
            _buildTextOverlay(context, currentCampaign),
        ],
      ),
    );
  }

  /// Build error widget with config colors
  Widget _buildErrorWidget() {
    try {
      final errorConfig = _configHelper?.getObject(
        'campaign_view.error_widget',
      );
      final bgColorString =
          errorConfig?['backgroundColor'] as String? ?? '#F9FAFB';
      final iconColorString = errorConfig?['iconColor'] as String? ?? '#9CA3AF';
      final iconSize = (errorConfig?['iconSize'] as num?)?.toDouble() ?? 64.0;

      Color getColor(String colorString, Color fallback) {
        if (colorString.startsWith('#')) {
          final hexString = colorString.substring(1);
          if (hexString.length == 6) {
            return Color(int.parse('FF$hexString', radix: 16));
          } else if (hexString.length == 8) {
            return Color(int.parse(hexString, radix: 16));
          }
        }
        return fallback;
      }

      return Container(
        width: double.infinity,
        height: double.infinity,
        color: getColor(bgColorString, OsmeaColors.grayMaterial[50]!),
        alignment: Alignment.center,
        child: Icon(
          Icons.image_outlined,
          color: getColor(iconColorString, OsmeaColors.grayMaterial[400]!),
          size: iconSize,
        ),
      );
    } catch (e) {
      debugPrint('⚠️ Failed to build error widget: $e');
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: OsmeaColors.grayMaterial[50],
        alignment: Alignment.center,
        child: Icon(
          Icons.image_outlined,
          color: OsmeaColors.grayMaterial[400],
          size: 64,
        ),
      );
    }
  }

  /// Check if gradient overlay should be shown
  bool _shouldShowGradientOverlay(CampaignImageItem campaign) {
    try {
      final gradientConfig = _configHelper?.getObject(
        'campaign_view.gradient_overlay',
      );
      final enabled = gradientConfig?['enabled'] as bool? ?? true;
      return enabled && (campaign.title != null || campaign.subtitle != null);
    } catch (e) {
      debugPrint('⚠️ Failed to check gradient overlay: $e');
      return campaign.title != null || campaign.subtitle != null;
    }
  }

  /// Build gradient overlay with config colors
  Widget _buildGradientOverlay() {
    try {
      final gradientConfig = _configHelper?.getObject(
        'campaign_view.gradient_overlay',
      );
      final startColorString =
          gradientConfig?['startColor'] as String? ?? '#00000000';
      final endColorString =
          gradientConfig?['endColor'] as String? ?? '#000000';
      final endColorOpacity =
          (gradientConfig?['endColorOpacity'] as num?)?.toDouble() ?? 0.6;
      final beginStr = gradientConfig?['begin'] as String? ?? 'topCenter';
      final endStr = gradientConfig?['end'] as String? ?? 'bottomCenter';

      Color getColor(String colorString, Color fallback) {
        if (colorString.startsWith('#')) {
          final hexString = colorString.substring(1);
          if (hexString.length == 6) {
            return Color(int.parse('FF$hexString', radix: 16));
          } else if (hexString.length == 8) {
            return Color(int.parse(hexString, radix: 16));
          }
        }
        return fallback;
      }

      Alignment getAlignment(String alignStr) {
        switch (alignStr.toLowerCase()) {
          case 'topcenter':
            return Alignment.topCenter;
          case 'bottomcenter':
            return Alignment.bottomCenter;
          case 'topleft':
            return Alignment.topLeft;
          case 'topright':
            return Alignment.topRight;
          case 'bottomleft':
            return Alignment.bottomLeft;
          case 'bottomright':
            return Alignment.bottomRight;
          case 'center':
            return Alignment.center;
          default:
            return Alignment.topCenter;
        }
      }

      return Positioned.fill(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: getAlignment(beginStr),
              end: getAlignment(endStr),
              colors: [
                getColor(startColorString, Colors.transparent),
                getColor(
                  endColorString,
                  OsmeaColors.black,
                ).withOpacity(endColorOpacity),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint('⚠️ Failed to build gradient overlay: $e');
      return Positioned.fill(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, OsmeaColors.black.withOpacity(0.6)],
            ),
          ),
        ),
      );
    }
  }

  /// Get translated text from slang or return original text
  /// If the text starts with '@', it's treated as a translation key
  String _getTranslatedText(BuildContext context, String? text) {
    if (text == null || text.isEmpty) return '';
    // If text starts with '@', treat it as a translation key
    if (text.startsWith('@')) {
      final key = text.substring(1);
      try {
        // Try to get translation from campaign namespace
        switch (key) {
          case 'campaign.title':
            return context.t.campaignView.title;
          case 'campaign.subtitle':
            return context.t.campaignView.subtitle;
          default:
            // Try direct access to translations
            return context.t[key] ?? text;
        }
      } catch (e) {
        debugPrint('⚠️ Failed to translate key: $key - $e');
        return text;
      }
    }
    // Return original text if not a translation key
    return text;
  }

  /// Build text overlay with config colors
  Widget _buildTextOverlay(BuildContext context, CampaignImageItem campaign) {
    try {
      final textConfig = _configHelper?.getObject('campaign_view.text_overlay');
      final titleConfig = textConfig?['title'] as Map<String, dynamic>?;
      final subtitleConfig = textConfig?['subtitle'] as Map<String, dynamic>?;
      final padding = (textConfig?['padding'] as num?)?.toDouble() ?? 24.0;

      Color getColor(String? colorString, Color fallback) {
        if (colorString != null && colorString.startsWith('#')) {
          final hexString = colorString.substring(1);
          if (hexString.length == 6) {
            return Color(int.parse('FF$hexString', radix: 16));
          } else if (hexString.length == 8) {
            return Color(int.parse(hexString, radix: 16));
          }
        }
        return fallback;
      }

      final titleColor = getColor(
        titleConfig?['color'] as String?,
        OsmeaColors.white,
      );
      final titleShadowColor = getColor(
        titleConfig?['shadowColor'] as String?,
        OsmeaColors.black,
      );
      final titleShadowBlur =
          (titleConfig?['shadowBlur'] as num?)?.toDouble() ?? 4.0;
      final titleFontWeight =
          (titleConfig?['fontWeight'] as num?)?.toInt() ?? 700;
      final titleMaxLines = (titleConfig?['maxLines'] as num?)?.toInt() ?? 2;

      final subtitleColor = getColor(
        subtitleConfig?['color'] as String?,
        OsmeaColors.white,
      );
      final subtitleShadowColor = getColor(
        subtitleConfig?['shadowColor'] as String?,
        OsmeaColors.black,
      );
      final subtitleShadowBlur =
          (subtitleConfig?['shadowBlur'] as num?)?.toDouble() ?? 4.0;
      final subtitleMaxLines =
          (subtitleConfig?['maxLines'] as num?)?.toInt() ?? 1;

      // Get translated texts
      final translatedTitle = _getTranslatedText(context, campaign.title);
      final translatedSubtitle = _getTranslatedText(context, campaign.subtitle);

      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (translatedTitle.isNotEmpty)
                OsmeaComponents.text(
                  translatedTitle,
                  textStyle: OsmeaTextStyle.headlineMedium(context).copyWith(
                    fontWeight: FontWeight.values.firstWhere(
                      (w) => w.value == titleFontWeight,
                      orElse: () => FontWeight.w700,
                    ),
                    color: titleColor,
                    shadows: [
                      Shadow(
                        color: titleShadowColor,
                        blurRadius: titleShadowBlur,
                      ),
                    ],
                  ),
                  maxLines: titleMaxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              if (translatedTitle.isNotEmpty && translatedSubtitle.isNotEmpty)
                OsmeaComponents.sizedBox(height: context.spacing8),
              if (translatedSubtitle.isNotEmpty)
                OsmeaComponents.text(
                  translatedSubtitle,
                  textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                    color: subtitleColor,
                    shadows: [
                      Shadow(
                        color: subtitleShadowColor,
                        blurRadius: subtitleShadowBlur,
                      ),
                    ],
                  ),
                  maxLines: subtitleMaxLines,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint('⚠️ Failed to build text overlay: $e');
      // Fallback to default with translations
      final translatedTitle = _getTranslatedText(context, campaign.title);
      final translatedSubtitle = _getTranslatedText(context, campaign.subtitle);

      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: EdgeInsets.all(context.spacing24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (translatedTitle.isNotEmpty)
                OsmeaComponents.text(
                  translatedTitle,
                  textStyle: OsmeaTextStyle.headlineMedium(context).copyWith(
                    fontWeight: FontWeight.w700,
                    color: OsmeaColors.white,
                    shadows: [
                      Shadow(
                        color: OsmeaColors.black,
                        blurRadius: context.blurRadius4,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              if (translatedTitle.isNotEmpty && translatedSubtitle.isNotEmpty)
                OsmeaComponents.sizedBox(height: context.spacing8),
              if (translatedSubtitle.isNotEmpty)
                OsmeaComponents.text(
                  translatedSubtitle,
                  textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                    color: OsmeaColors.white,
                    shadows: [
                      Shadow(
                        color: OsmeaColors.black,
                        blurRadius: context.blurRadius4,
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      );
    }
  }
}

/// Campaign image item model
class CampaignImageItem {
  final String imageUrl;
  final String? title;
  final String? subtitle;

  CampaignImageItem({required this.imageUrl, this.title, this.subtitle});
}
