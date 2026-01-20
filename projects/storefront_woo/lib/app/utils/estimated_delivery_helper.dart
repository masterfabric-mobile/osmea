import 'package:flutter/material.dart';
import 'package:core/core.dart';

typedef DeliveryDaysRange = ({int minDays, int maxDays});
typedef DeliveryDateRange = ({DateTime startDate, DateTime endDate});

class EstimatedDeliveryHelper {
  static DeliveryDaysRange? tryParseDaysRange(String? deliveryTime) {
    if (deliveryTime == null) return null;
    final text = deliveryTime.trim();
    if (text.isEmpty) return null;

    // Common patterns:
    // - "3-5 business days"
    // - "1 - 2 days"
    // - "7 days"
    final rangeMatch = RegExp(r'(\d+)\s*-\s*(\d+)').firstMatch(text);
    if (rangeMatch != null) {
      final a = int.tryParse(rangeMatch.group(1) ?? '');
      final b = int.tryParse(rangeMatch.group(2) ?? '');
      if (a != null && b != null) {
        final minDays = a <= b ? a : b;
        final maxDays = a <= b ? b : a;
        if (minDays <= 0 && maxDays <= 0) return null;
        return (minDays: minDays <= 0 ? 1 : minDays, maxDays: maxDays <= 0 ? 1 : maxDays);
      }
    }

    final singleMatch = RegExp(r'(\d+)').firstMatch(text);
    if (singleMatch != null) {
      final d = int.tryParse(singleMatch.group(1) ?? '');
      if (d != null && d > 0) return (minDays: d, maxDays: d);
    }

    return null;
  }

  static String _formatDate(BuildContext context, DateTime dt, String formatStyle) {
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

  static DateTime _estimateBaseDate({
    required DateTime now,
    required bool cutoffAffectsEstimate,
    required int cutoffHour,
    required int cutoffMinute,
  }) {
    if (!cutoffAffectsEstimate) return now;
    final todayCutoff = DateTime(now.year, now.month, now.day, cutoffHour, cutoffMinute);
    if (now.isBefore(todayCutoff)) return now;
    return now.add(const Duration(days: 1));
  }

  static String estimatedDeliveryLabel({AssetConfigHelper? configHelper}) {
    final helper = configHelper ?? AssetConfigHelper();
    return helper.getString(
      'product_detail_view.delivery.estimated_label',
      'Estimated delivery',
    );
  }

  /// Returns a formatted delivery estimate like:
  /// - "Jan 27" (single)
  /// - "Jan 27 - Jan 29" (range)
  ///
  /// Priority:
  /// 1) Parse from [deliveryTime] (e.g. "3-5 business days")
  /// 2) Fallback to config `product_detail_view.delivery.estimated_min_days/max_days`
  static String estimatedDeliveryValue(
    BuildContext context, {
    required String? deliveryTime,
    AssetConfigHelper? configHelper,
  }) {
    final range = estimatedDeliveryDates(
      context,
      deliveryTime: deliveryTime,
      configHelper: configHelper,
    );
    if (range == null) return '';

    final helper = configHelper ?? AssetConfigHelper();
    final dateFormatStyle = helper.getString(
      'product_detail_view.delivery.date_format',
      'medium',
    );
    final singleTemplate = helper.getString(
      'product_detail_view.delivery.estimated_date_single_template',
      '{date}',
    );
    final rangeTemplate = helper.getString(
      'product_detail_view.delivery.estimated_date_range_template',
      '{startDate} - {endDate}',
    );

    final startLabel = _formatDate(context, range.startDate, dateFormatStyle);
    final endLabel = _formatDate(context, range.endDate, dateFormatStyle);

    if (range.startDate.isAtSameMomentAs(range.endDate)) {
      return singleTemplate.replaceAll('{date}', startLabel);
    }

    return rangeTemplate
        .replaceAll('{startDate}', startLabel)
        .replaceAll('{endDate}', endLabel);
  }

  static String estimatedDeliveryValueWithOffsets(
    BuildContext context, {
    required String? deliveryTime,
    int minAdditionalDays = 0,
    int maxAdditionalDays = 0,
    AssetConfigHelper? configHelper,
  }) {
    final range = estimatedDeliveryDates(
      context,
      deliveryTime: deliveryTime,
      minAdditionalDays: minAdditionalDays,
      maxAdditionalDays: maxAdditionalDays,
      configHelper: configHelper,
    );
    if (range == null) return '';

    final helper = configHelper ?? AssetConfigHelper();
    final dateFormatStyle = helper.getString(
      'product_detail_view.delivery.date_format',
      'medium',
    );
    final singleTemplate = helper.getString(
      'product_detail_view.delivery.estimated_date_single_template',
      '{date}',
    );
    final rangeTemplate = helper.getString(
      'product_detail_view.delivery.estimated_date_range_template',
      '{startDate} - {endDate}',
    );

    final startLabel = _formatDate(context, range.startDate, dateFormatStyle);
    final endLabel = _formatDate(context, range.endDate, dateFormatStyle);

    if (range.startDate.isAtSameMomentAs(range.endDate)) {
      return singleTemplate.replaceAll('{date}', startLabel);
    }

    return rangeTemplate
        .replaceAll('{startDate}', startLabel)
        .replaceAll('{endDate}', endLabel);
  }

  static String formatDateRange(
    BuildContext context, {
    required DateTime startDate,
    required DateTime endDate,
    AssetConfigHelper? configHelper,
  }) {
    final helper = configHelper ?? AssetConfigHelper();
    final dateFormatStyle = helper.getString(
      'product_detail_view.delivery.date_format',
      'medium',
    );
    final singleTemplate = helper.getString(
      'product_detail_view.delivery.estimated_date_single_template',
      '{date}',
    );
    final rangeTemplate = helper.getString(
      'product_detail_view.delivery.estimated_date_range_template',
      '{startDate} - {endDate}',
    );

    final startLabel = _formatDate(context, startDate, dateFormatStyle);
    final endLabel = _formatDate(context, endDate, dateFormatStyle);

    final s = DateUtils.dateOnly(startDate);
    final e = DateUtils.dateOnly(endDate);

    if (s.isAtSameMomentAs(e)) {
      return singleTemplate.replaceAll('{date}', startLabel);
    }

    return rangeTemplate
        .replaceAll('{startDate}', startLabel)
        .replaceAll('{endDate}', endLabel);
  }

  static DeliveryDateRange? estimatedDeliveryDates(
    BuildContext context, {
    required String? deliveryTime,
    int minAdditionalDays = 0,
    int maxAdditionalDays = 0,
    AssetConfigHelper? configHelper,
  }) {
    final helper = configHelper ?? AssetConfigHelper();

    final parsed = tryParseDaysRange(deliveryTime);
    final minDays = parsed?.minDays ??
        helper.getInt('product_detail_view.delivery.estimated_min_days', 2);
    final maxDays = parsed?.maxDays ??
        helper.getInt('product_detail_view.delivery.estimated_max_days', 5);

    if (minDays <= 0 && maxDays <= 0) return null;

    final safeMin = minDays > 0 ? minDays : 1;
    final safeMax = maxDays > 0 ? maxDays : safeMin;
    final normalizedMinBase = safeMin <= safeMax ? safeMin : safeMax;
    final normalizedMaxBase = safeMin <= safeMax ? safeMax : safeMin;

    final addMin = minAdditionalDays < 0 ? 0 : minAdditionalDays;
    final addMax = maxAdditionalDays < 0 ? 0 : maxAdditionalDays;
    final normalizedMin = normalizedMinBase + addMin;
    final normalizedMax = normalizedMaxBase + (addMax >= addMin ? addMax : addMin);

    final cutoffHour = helper.getInt('product_detail_view.delivery.cutoff_hour', 16);
    final cutoffMinute = helper.getInt('product_detail_view.delivery.cutoff_minute', 0);
    final cutoffAffectsEstimate = helper.getBool(
      'product_detail_view.delivery.cutoff_affects_estimate',
      true,
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
    if (normalizedMin == normalizedMax) {
      return (startDate: startDate, endDate: startDate);
    }
    return (startDate: startDate, endDate: endDate);
  }
}

