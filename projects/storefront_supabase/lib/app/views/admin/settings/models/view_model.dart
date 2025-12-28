import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/models/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'states.dart';

@injectable
class AdminSettingsViewModel extends BaseViewModelCubit<AdminSettingsState> {
  final SupabaseClient _supabaseClient;

  AdminSettingsViewModel(this._supabaseClient) : super(AdminSettingsInitial());

  Future<void> fetchAdminInfo() async {
    stateChanger(AdminSettingsLoading());
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        stateChanger(AdminSettingsError('Admin user not logged in.'));
        return;
      }
      final response = await _supabaseClient
          .from('users') // Assuming admin info is in the users table
          .select()
          .eq('id', userId)
          .single();
      
      final adminUser = AppUser.fromJson(response);
      stateChanger(AdminSettingsLoaded(adminUser));
    } catch (e) {
      stateChanger(AdminSettingsError('Failed to load admin info: $e'));
    }
  }
}
