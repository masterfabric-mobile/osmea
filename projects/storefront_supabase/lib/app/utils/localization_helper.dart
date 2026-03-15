import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:storefront_supabase/app/core/config/config_di.dart';
import 'package:storefront_supabase/app/core/bloc/language/language_cubit.dart';
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';
import 'package:storefront_supabase/services/store_config_service.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class LocalizationHelper {
  static const List<String> _currencyCodes = ['USD', 'EUR', 'TRY', 'GBP'];
  static const Map<String, String> _currencyFlags = {
    'USD': '🇺🇸',
    'EUR': '🇪🇺',
    'TRY': '🇹🇷',
    'GBP': '🇬🇧',
  };

  static void showLanguageCurrencySheet(BuildContext context) {
    final storeDefault =
        getIt<StoreConfigService>().defaultCurrencyCode.toUpperCase();
    final ordered = List<String>.from(_currencyCodes)
      ..remove(storeDefault);
    ordered.insert(0, storeDefault);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: OsmeaColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          color: OsmeaColors.white,
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            maxChildSize: 0.9,
            minChildSize: 0.4,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: OsmeaColors.silver,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    OsmeaComponents.text(
                      context.resources.language,
                      textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: OsmeaColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLanguageItem(context, '🇺🇸', 'English', const Locale('en')),
                    _buildLanguageItem(context, '🇹🇷', 'Türkçe', const Locale('tr')),
                    _buildLanguageItem(context, '🇩🇪', 'Deutsch', const Locale('de')),
                    _buildLanguageItem(context, '🇫🇷', 'Français', const Locale('fr')),
                    const SizedBox(height: 32),
                    Divider(height: 1, color: OsmeaColors.silver),
                    const SizedBox(height: 32),
                  OsmeaComponents.text(
                    context.resources.currency,
                    textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: OsmeaColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (final code in ordered)
                      _buildCurrencyItem(
                        context,
                        _currencyFlags[code] ?? '',
                        code,
                        isStoreDefault: code == storeDefault,
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  static Widget _buildLanguageItem(BuildContext context, String flag, String name, Locale locale) {
    return BlocBuilder<LanguageCubit, Locale?>(
      builder: (context, currentLocale) {
        final isSelected = currentLocale?.languageCode == locale.languageCode;
        return ListTile(
          tileColor: OsmeaColors.white,
          leading: OsmeaComponents.text(flag, textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(fontSize: 24)),
          title: OsmeaComponents.text(name, textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(color: OsmeaColors.black)),
          trailing: isSelected ? Icon(Icons.check_circle, color: OsmeaColors.black) : null,
          onTap: () {
            context.read<LanguageCubit>().changeLanguage(locale);
            Navigator.pop(context);
          },
          contentPadding: EdgeInsets.zero,
        );
      },
    );
  }

  static Widget _buildCurrencyItem(
    BuildContext context,
    String flag,
    String code, {
    bool isStoreDefault = false,
  }) {
    return BlocBuilder<CurrencyCubit, String>(
      builder: (context, currentCurrency) {
        final isSelected = currentCurrency == code;
        final title = isStoreDefault
            ? '$code (${context.resources.defaultLabel})'
            : code;
        return ListTile(
          tileColor: OsmeaColors.white,
          leading: OsmeaComponents.text(
            flag,
            textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(fontSize: 24),
          ),
          title: OsmeaComponents.text(
            title,
            textStyle: OsmeaTextStyle.bodyMedium(context)
                .copyWith(color: OsmeaColors.black),
          ),
          trailing:
              isSelected ? Icon(Icons.check_circle, color: OsmeaColors.black) : null,
          onTap: () {
            context.read<CurrencyCubit>().changeCurrency(code);
            Navigator.pop(context);
          },
          contentPadding: EdgeInsets.zero,
        );
      },
    );
  }
}
