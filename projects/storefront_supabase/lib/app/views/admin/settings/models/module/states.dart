import 'package:storefront_supabase/app/models/app_user.dart';

abstract class AdminSettingsState {}

class AdminSettingsInitial extends AdminSettingsState {}

class AdminSettingsLoading extends AdminSettingsState {}

class AdminSettingsLoaded extends AdminSettingsState {
  final AppUser adminUser;
  AdminSettingsLoaded(this.adminUser);
}

class AdminSettingsError extends AdminSettingsState {
  final String message;
  AdminSettingsError(this.message);
}