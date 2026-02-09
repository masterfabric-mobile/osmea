/*
 * CampaignAlertWidget
 * -------------------
 * Campaign alert with countdown timer.
 * Displays urgent campaign messages with time remaining.
 * Loads from app config.
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:storefront_supabase/utils/config_utils.dart';

/// Campaign alert widget with countdown timer
class CampaignAlertWidget extends StatefulWidget {
  final AssetConfigHelper configHelper;

  const CampaignAlertWidget({super.key, required this.configHelper});

  @override
  State<CampaignAlertWidget> createState() => _CampaignAlertWidgetState();
}

class _CampaignAlertWidgetState extends State<CampaignAlertWidget> {
  Timer? _timer;
  Duration _timeRemaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeTimer() {
    final config = _loadCampaignConfig();
    final endTimeStr = configString(config?['end_time']);

    if (endTimeStr != null) {
      try {
        final endTime = DateTime.parse(endTimeStr);
        _updateTimeRemaining(endTime);

        _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
          if (mounted) {
            _updateTimeRemaining(endTime);
          } else {
            timer.cancel();
          }
        });
      } catch (e) {
        debugPrint('Failed to parse campaign end time: $e');
      }
    } else {
      final endTime = DateTime.now().add(const Duration(hours: 24));
      _updateTimeRemaining(endTime);

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          _updateTimeRemaining(endTime);
        } else {
          timer.cancel();
        }
      });
    }
  }

  void _updateTimeRemaining(DateTime endTime) {
    final now = DateTime.now();
    final remaining = endTime.difference(now);

    if (remaining.isNegative) {
      setState(() {
        _timeRemaining = Duration.zero;
      });
      _timer?.cancel();
    } else {
      setState(() {
        _timeRemaining = remaining;
      });
    }
  }

  /// Loads campaign alert configuration
  Map<String, dynamic>? _loadCampaignConfig() {
    try {
      return widget.configHelper.getObject('home_view.campaign_alert');
    } catch (e) {
      debugPrint('Failed to load campaign alert config: $e');
      return null;
    }
  }

  /// Gets horizontal padding from config
  double _getHorizontalPadding() {
    try {
      final config = _loadCampaignConfig();
      final paddingConfig = config?['padding'] as Map<String, dynamic>?;
      if (paddingConfig != null) {
        final horizontal = (paddingConfig['horizontal'] as num?)?.toDouble();
        if (horizontal != null && horizontal > 0) {
          return horizontal;
        }
      }
    } catch (e) {
      debugPrint('Failed to load horizontal padding: $e');
    }
    return widget.configHelper.getDouble(
      'home_view.component_spacing.horizontal',
      20.0,
    );
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);

    if (days > 0) {
      return '${days}d ${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m';
    } else if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m';
    } else {
      return '${minutes.toString().padLeft(2, '0')}m';
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _loadCampaignConfig();
    final showAlert = config?['enabled'] as bool? ?? true;
    final title = configString(config?['title']) ?? 'Special Offer';
    final message = configString(config?['message']) ?? 'Limited time offer';
    final backgroundColor =
        configString(config?['background_color']) ?? '#000000';
    final textColor = configString(config?['text_color']) ?? '#FFFFFF';
    final route = configString(config?['route']);
    final categoryId = configString(config?['category_id']);
    final productId = configString(config?['product_id']);

    if (!showAlert) return const SizedBox.shrink();

    final horizontalPadding = _getHorizontalPadding();
    final bgColor = _parseColor(backgroundColor);
    final txtColor = _parseColor(textColor);

    return GestureDetector(
      onTap: () {
        if (route != null) {
          context.push(route);
        } else if (productId != null) {
          context.push('/product-detail/$productId');
        } else if (categoryId != null) {
          context.push('/categories/products/$categoryId');
        } else {
          context.push('/categories/products/all');
        }
      },
      child: OsmeaComponents.padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing16,
            vertical: context.spacing12,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(context.spacing12),
          ),
          child: OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OsmeaComponents.expanded(
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OsmeaComponents.text(
                      title,
                      textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                        fontSize:
                            context.fontSizeNormal * context.textScaleFactor,
                        fontWeight: FontWeight.w700,
                        color: txtColor,
                      ),
                    ),
                    OsmeaComponents.sizedBox(height: context.spacing4),
                    OsmeaComponents.text(
                      message,
                      textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                        fontSize:
                            context.fontSizeSmall * context.textScaleFactor,
                        color: txtColor.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              OsmeaComponents.sizedBox(width: context.spacing12),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.spacing12,
                  vertical: context.spacing8,
                ),
                decoration: BoxDecoration(
                  color: txtColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(context.spacing8),
                ),
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OsmeaComponents.text(
                      'ENDS IN',
                      textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                        fontSize:
                            context.fontSizeExtraSmall *
                            context.textScaleFactor,
                        fontWeight: FontWeight.w600,
                        color: txtColor,
                      ),
                    ),
                    OsmeaComponents.sizedBox(height: context.spacing4),
                    OsmeaComponents.text(
                      _formatDuration(_timeRemaining),
                      textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                        fontSize:
                            context.fontSizeNormal * context.textScaleFactor,
                        fontWeight: FontWeight.w700,
                        color: txtColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) {
      return OsmeaColors.black;
    }
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return OsmeaColors.black;
    }
  }
}
