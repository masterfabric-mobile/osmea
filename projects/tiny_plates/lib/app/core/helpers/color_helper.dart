import 'package:flutter/material.dart';

/// Hex color string to [Color]. Use for config/URL values (e.g. #RRGGBB or RRGGBB).
Color colorFromHex(String? hex, {Color fallback = const Color(0xFFFFFFFF)}) {
  if (hex == null || hex.isEmpty) return fallback;
  try {
    final h = hex.replaceAll('#', '');
    if (h.length == 6) return Color(int.parse('FF$h', radix: 16));
    if (h.length == 8) return Color(int.parse(h, radix: 16));
    return fallback;
  } catch (_) {
    return fallback;
  }
}
