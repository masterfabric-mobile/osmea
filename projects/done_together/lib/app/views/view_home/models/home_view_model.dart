import 'package:core/core.dart'
    hide
        BuildContextTranslationsExtension,
        AppLocaleUtils,
        LocaleSettings,
        TranslationProvider;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:done_together/app/views/view_home/models/module/states.dart';

class HomeViewModel extends BaseViewModelCubit<HomeState> {
  HomeViewModel() : super(HomeInitialState());

  Future<void> initial() async {
    stateChanger(HomeLoadingState());

    try {
      final user = Supabase.instance.client.auth.currentUser;
      final userName = user?.userMetadata?['username'] as String? ??
          user?.email?.split('@').first;

      stateChanger(HomeLoadedState(userName: userName));
    } catch (e) {
      // Supabase not initialized (no URL/key in config) or auth error → show home without user name
      debugPrint('HomeViewModel.initial: $e');
      stateChanger(HomeLoadedState(userName: null));
    }
  }
}
