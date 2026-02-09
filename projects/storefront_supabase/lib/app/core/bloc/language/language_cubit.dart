import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class LanguageCubit extends Cubit<Locale?> {
  LanguageCubit() : super(null) {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString('language_code');
    final String? countryCode = prefs.getString('country_code');

    if (languageCode != null) {
      final locale = Locale(languageCode, countryCode);
      final appLocale = AppLocaleUtils.parseLocaleParts(
        languageCode: languageCode,
        countryCode: countryCode,
      );
      await LocaleSettings.setLocale(appLocale);
      emit(locale);
    } else {
      await LocaleSettings.useDeviceLocale();
      final currentLocale = LocaleSettings.currentLocale;
      emit(Locale(currentLocale.languageCode, currentLocale.countryCode));
    }
  }

  Future<void> changeLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    if (locale.countryCode != null) {
      await prefs.setString('country_code', locale.countryCode!);
    } else {
      await prefs.remove('country_code');
    }
    
    final appLocale = AppLocaleUtils.parseLocaleParts(
      languageCode: locale.languageCode,
      countryCode: locale.countryCode,
    );
    await LocaleSettings.setLocale(appLocale);
    
    emit(locale);
  }
}
