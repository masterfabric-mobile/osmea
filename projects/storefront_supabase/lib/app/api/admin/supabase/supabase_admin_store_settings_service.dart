import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_store_settings_service.dart';
import 'package:storefront_supabase/app/models/admin_setting.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Injectable(as: AdminStoreSettingsService)
class SupabaseAdminStoreSettingsService implements AdminStoreSettingsService {
  final SupabaseClient _client;

  SupabaseAdminStoreSettingsService(this._client);

  @override
  Future<List<AdminSetting>> listSettings() async {
    final res = await _client
        .from('admin_settings')
        .select()
        .order('key', ascending: true);
    return (res as List)
        .map((e) => AdminSetting.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AdminSetting?> getSetting(String key) async {
    final res = await _client
        .from('admin_settings')
        .select()
        .eq('key', key)
        .maybeSingle();
    if (res == null) return null;
    return AdminSetting.fromJson(res);
  }

  @override
  Future<AdminSetting> setSetting(String key, String value) async {
    final now = DateTime.now().toUtc().toIso8601String();
    final data = {'key': key, 'value': value, 'updated_at': now};
    final res = await _client
        .from('admin_settings')
        .upsert(data, onConflict: 'key')
        .select()
        .single();
    return AdminSetting.fromJson(res);
  }
}
