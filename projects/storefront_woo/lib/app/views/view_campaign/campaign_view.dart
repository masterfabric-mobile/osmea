/*
 * CampaignView
 * ------------
 * Full-screen campaign image display view.
 * Shows campaign images from app_config.json for 1.5 seconds,
 * then navigates to home screen.
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/utils/unified_loading_widget.dart';

/// Campaign view that displays full-screen campaign images
class CampaignView extends StatefulWidget {
  final Function(String) goRoute;

  const CampaignView({
    super.key,
    required this.goRoute,
  });

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

  /// Initialize fade-in and scale animations
  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
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

  /// Start timer to navigate to home after 1.5 seconds
  void _startNavigationTimer() {
    _navigationTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        debugPrint('🎯 Campaign view completed, navigating to home');
        widget.goRoute('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: OsmeaColors.white,
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
              errorWidget: Container(
                width: double.infinity,
                height: double.infinity,
                color: OsmeaColors.grayMaterial[50],
                alignment: Alignment.center,
                child: Icon(
                  Icons.image_outlined,
                  color: OsmeaColors.grayMaterial[400],
                  size: 64,
                ),
              ),
            ),
          ),
        // Optional: Gradient overlay for text readability
        if (currentCampaign.title != null || currentCampaign.subtitle != null)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    OsmeaColors.thunder.withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ),
        // Optional: Text overlay
        if (currentCampaign.title != null || currentCampaign.subtitle != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(context.spacing24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (currentCampaign.title != null)
                    OsmeaComponents.text(
                      currentCampaign.title!,
                      textStyle: OsmeaTextStyle.headlineMedium(context).copyWith(
                        fontWeight: FontWeight.w700,
                        color: OsmeaColors.white,
                        shadows: [
                          Shadow(
                            color: OsmeaColors.thunder,
                            blurRadius: context.blurRadius4,
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (currentCampaign.title != null &&
                      currentCampaign.subtitle != null)
                    OsmeaComponents.sizedBox(height: context.spacing8),
                  if (currentCampaign.subtitle != null)
                    OsmeaComponents.text(
                      currentCampaign.subtitle!,
                      textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                        color: OsmeaColors.white,
                        shadows: [
                          Shadow(
                            color: OsmeaColors.thunder,
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
          ),
        ],
      ),
    );
  }
}

/// Campaign image item model
class CampaignImageItem {
  final String imageUrl;
  final String? title;
  final String? subtitle;

  CampaignImageItem({
    required this.imageUrl,
    this.title,
    this.subtitle,
  });
}

