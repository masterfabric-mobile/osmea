import 'package:supabase_flutter/supabase_flutter.dart';

/// Brand bucket: tam URL ise aynen döner, değilse storage path kabul edip public URL üretir.
/// Ana sayfa ve search ekranında aynı görsellerin görünmesi için kullanılır.
String? resolveBrandLogoUrl(SupabaseClient client, String? url) {
  if (url == null || url.trim().isEmpty) return null;
  final trimmed = url.trim();
  if (trimmed.toLowerCase().startsWith('http://') ||
      trimmed.toLowerCase().startsWith('https://')) {
    return trimmed;
  }
  try {
    final path = trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;
    return client.storage.from('brand').getPublicUrl(path);
  } catch (_) {
    return url;
  }
}
