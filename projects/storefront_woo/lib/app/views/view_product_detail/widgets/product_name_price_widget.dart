/*
 * Product Name Price Widget
 * --------------------------
 * Widget for displaying product name and price.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';
import 'package:storefront_woo/gen/translations.g.dart';

/// Widget for displaying product name and price
class ProductNamePriceWidget extends StatelessWidget {
  final ProductDetailLoadedState state;

  const ProductNamePriceWidget({
    super.key,
    required this.state,
  });

  String _formatDate(BuildContext context, DateTime dt, String formatStyle) {
    final localizations = MaterialLocalizations.of(context);
    switch (formatStyle) {
      case 'short':
        return localizations.formatShortDate(dt);
      case 'full':
        return localizations.formatFullDate(dt);
      case 'medium':
      default:
        return localizations.formatMediumDate(dt);
    }
  }

  /// Get color from config
  Color _getColorFromConfig(String key, Color fallback) {
    try {
      final configHelper = AssetConfigHelper();
      final colorString = configHelper.getString('product_detail_view.name_and_price.$key');
      if (colorString.isNotEmpty && colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load name_and_price color $key: $e');
    }
    return fallback;
  }

  DateTime _estimateBaseDate({
    required DateTime now,
    required bool cutoffAffectsEstimate,
    required int cutoffHour,
    required int cutoffMinute,
  }) {
    if (!cutoffAffectsEstimate) return now;
    final todayCutoff = DateTime(now.year, now.month, now.day, cutoffHour, cutoffMinute);
    if (now.isBefore(todayCutoff)) return now;
    // After cutoff: treat “order time” as tomorrow.
    return now.add(const Duration(days: 1));
  }

  String _estimatedDeliveryText(BuildContext context) {
    final configHelper = AssetConfigHelper();
    final display = configHelper.getString(
      'product_detail_view.delivery.estimated_display',
      'date',
    );
    final minDays = configHelper.getInt(
      'product_detail_view.delivery.estimated_min_days',
      2,
    );
    final maxDays = configHelper.getInt(
      'product_detail_view.delivery.estimated_max_days',
      5,
    );

    if (minDays <= 0 && maxDays <= 0) return '';

    final safeMin = minDays > 0 ? minDays : 1;
    final safeMax = maxDays > 0 ? maxDays : safeMin;
    final normalizedMin = safeMin <= safeMax ? safeMin : safeMax;
    final normalizedMax = safeMin <= safeMax ? safeMax : safeMin;

    // Fallback: keep “days” mode available via config.
    if (display == 'days') {
      final exactTemplate = configHelper.getString(
        'product_detail_view.delivery.estimated_exact_template',
        '{days} days later',
      );
      final rangeTemplate = configHelper.getString(
        'product_detail_view.delivery.estimated_range_template',
        '{minDays}-{maxDays} days',
      );

      if (normalizedMin == normalizedMax) {
        return exactTemplate.replaceAll('{days}', normalizedMin.toString());
      }

      return rangeTemplate
          .replaceAll('{minDays}', normalizedMin.toString())
          .replaceAll('{maxDays}', normalizedMax.toString());
    }

    // Default: net date / date range
    final cutoffHour = configHelper.getInt('product_detail_view.delivery.cutoff_hour', 16);
    final cutoffMinute = configHelper.getInt('product_detail_view.delivery.cutoff_minute', 0);
    final cutoffAffectsEstimate = configHelper.getBool(
      'product_detail_view.delivery.cutoff_affects_estimate',
      true,
    );
    final dateFormatStyle = configHelper.getString(
      'product_detail_view.delivery.date_format',
      'medium',
    );
    final singleTemplate = configHelper.getString(
      'product_detail_view.delivery.estimated_date_single_template',
      '{date}',
    );
    final rangeTemplate = configHelper.getString(
      'product_detail_view.delivery.estimated_date_range_template',
      '{startDate} - {endDate}',
    );

    final now = DateTime.now();
    final base = _estimateBaseDate(
      now: now,
      cutoffAffectsEstimate: cutoffAffectsEstimate,
      cutoffHour: cutoffHour,
      cutoffMinute: cutoffMinute,
    );
    final startDate = base.add(Duration(days: normalizedMin));
    final endDate = base.add(Duration(days: normalizedMax));
    final startLabel = _formatDate(context, startDate, dateFormatStyle);
    final endLabel = _formatDate(context, endDate, dateFormatStyle);

    // Treat equal min/max as a single “exact” estimate (e.g., 7 days later).
    if (normalizedMin == normalizedMax) {
      return singleTemplate
          .replaceAll('{date}', startLabel)
          .replaceAll('{days}', normalizedMin.toString());
    }

    return rangeTemplate
        .replaceAll('{startDate}', startLabel)
        .replaceAll('{endDate}', endLabel)
        .replaceAll('{minDays}', normalizedMin.toString())
        .replaceAll('{maxDays}', normalizedMax.toString());
  }

  DateTime _nextCutoff(DateTime now, {int hour = 16, int minute = 0}) {
    final todayCutoff = DateTime(now.year, now.month, now.day, hour, minute);
    if (now.isBefore(todayCutoff)) return todayCutoff;
    final tomorrow = now.add(const Duration(days: 1));
    return DateTime(tomorrow.year, tomorrow.month, tomorrow.day, hour, minute);
  }

  String _formatHms(Duration d) {
    final totalSeconds = d.inSeconds.clamp(0, 24 * 3600 * 365);
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(h)}:${two(m)}:${two(s)}';
  }

  @override
  Widget build(BuildContext context) {
    final nameColor = _getColorFromConfig('nameColor', OsmeaColors.black);
    final configHelper = AssetConfigHelper();
    final infoBorder = _getColorFromConfig(
      'deliveryInfoBorderColor',
      OsmeaColors.grayMaterial[200] ?? OsmeaColors.silver,
    );
    final infoIcon = _getColorFromConfig(
      'deliveryInfoIconColor',
      OsmeaColors.black,
    );
    final infoText = _getColorFromConfig(
      'deliveryInfoTextColor',
      OsmeaColors.thunder,
    );
    final deliveryDateTextColor = _getColorFromConfig(
      'deliveryDateTextColor',
      OsmeaColors.black,
    );
    
    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing16,
        vertical: context.spacing12,
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: context.crossStart,
        children: [
          // Product name only - price is shown in footer
          OsmeaComponents.text(
            state.product.name ?? context.t.productDetailView.unknownProduct,
            textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
              height: 1.3,
              color: nameColor,
            ),
          ),

          OsmeaComponents.sizedBox(height: context.spacing10),

          // Delivery / service info (estimated delivery, etc.)
          Builder(
            builder: (context) {
              final showCutoffCountdown = configHelper.getBool(
                'product_detail_view.delivery.show_cutoff_countdown',
                true,
              );
              final cutoffHour = configHelper.getInt(
                'product_detail_view.delivery.cutoff_hour',
                16,
              );
              final cutoffMinute = configHelper.getInt(
                'product_detail_view.delivery.cutoff_minute',
                0,
              );
              final showCutoffTime = configHelper.getBool(
                'product_detail_view.delivery.show_cutoff_time',
                false,
              );

              final label = configHelper.getString(
                'product_detail_view.delivery.estimated_label',
                'Estimated delivery',
              );
              final deliveryText = _estimatedDeliveryText(context);

              final cutoffTitle = configHelper.getString(
                'product_detail_view.delivery.cutoff_title',
                'Order within',
              );

              final muted = infoText.withValues(alpha: 0.72);
              final dividerColor = infoBorder.withValues(alpha: 0.55);

              return Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left block
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_shipping_outlined,
                                size: context.iconSizeSmall,
                                color: infoIcon,
                              ),
                              SizedBox(width: context.spacing10),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: OsmeaTextStyle.bodySmall(context)
                                          .copyWith(
                                        color: muted,
                                        fontWeight: FontWeight.w600,
                                        height: 1.1,
                                      ),
                                    ),
                                    SizedBox(height: context.spacing2),
                                    Text(
                                      deliveryText,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: OsmeaTextStyle.titleSmall(context)
                                          .copyWith(
                                        color: deliveryDateTextColor,
                                        fontWeight: FontWeight.w800,
                                        height: 1.05,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (showCutoffCountdown) ...[
                          SizedBox(width: context.spacing12),
                          VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: dividerColor,
                          ),
                          SizedBox(width: context.spacing12),
                          // Right block (countdown)
                          StreamBuilder<int>(
                            stream: Stream.periodic(
                              const Duration(seconds: 1),
                              (i) => i,
                            ),
                            builder: (context, _) {
                              final now = DateTime.now();
                              final cutoff = _nextCutoff(
                                now,
                                hour: cutoffHour,
                                minute: cutoffMinute,
                              );
                              final remaining = cutoff.difference(now);
                              final cutoffText =
                                  '${cutoffHour.toString().padLeft(2, '0')}:${cutoffMinute.toString().padLeft(2, '0')}';

                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    size: context.iconSizeExtraSmall,
                                    color: muted,
                                  ),
                                  SizedBox(width: context.spacing8),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        cutoffTitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: OsmeaTextStyle.bodySmall(context)
                                            .copyWith(
                                          color: muted,
                                          fontWeight: FontWeight.w600,
                                          height: 1.1,
                                        ),
                                      ),
                                      SizedBox(height: context.spacing2),
                                      Text(
                                        _formatHms(remaining),
                                        style: OsmeaTextStyle.titleSmall(context)
                                            .copyWith(
                                          color: deliveryDateTextColor,
                                          fontWeight: FontWeight.w800,
                                          height: 1.05,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                      if (showCutoffTime) ...[
                                        SizedBox(height: context.spacing2),
                                        Text(
                                          cutoffText,
                                          style: OsmeaTextStyle.bodySmall(context)
                                              .copyWith(
                                            color: muted.withValues(alpha: 0.9),
                                            fontWeight: FontWeight.w600,
                                            height: 1.1,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: context.spacing10),
                  Divider(height: 1, thickness: 1, color: dividerColor),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

