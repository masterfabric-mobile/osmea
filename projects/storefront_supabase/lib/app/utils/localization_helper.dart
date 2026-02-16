import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:storefront_supabase/app/core/bloc/language/language_cubit.dart';
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class LocalizationHelper {
  static void showLanguageCurrencySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
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
                        color: OsmeaColors.grayMaterial[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // --- Language Section ---
                  OsmeaComponents.text(
                    context.resources.language,
                    textStyle: OsmeaTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildLanguageItem(context, '🇺🇸', 'English', const Locale('en')),
                  _buildLanguageItem(context, '🇹🇷', 'Türkçe', const Locale('tr')),
                  _buildLanguageItem(context, '🇩🇪', 'Deutsch', const Locale('de')),
                  _buildLanguageItem(context, '🇫🇷', 'Français', const Locale('fr')),
                  
                  const SizedBox(height: 32),
                  OsmeaComponents.divider(),
                  const SizedBox(height: 32),

                  // --- Currency Section ---
                  OsmeaComponents.text(
                    'Currency', // You might want to add this to strings.json later
                    textStyle: OsmeaTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildCurrencyItem(context, '🇺🇸', 'USD'),
                  _buildCurrencyItem(context, '🇪🇺', 'EUR'),
                  _buildCurrencyItem(context, '🇹🇷', 'TRY'),
                  _buildCurrencyItem(context, '🇬🇧', 'GBP'),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Widget _buildLanguageItem(BuildContext context, String flag, String name, Locale locale) {
    return BlocBuilder<LanguageCubit, Locale?>(
      builder: (context, currentLocale) {
        final isSelected = currentLocale?.languageCode == locale.languageCode;
        return ListTile(
          leading: OsmeaComponents.text(flag, textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(fontSize: 24)),
          title: OsmeaComponents.text(name, textStyle: OsmeaTextStyle.bodyMedium(context)),
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

  static Widget _buildCurrencyItem(BuildContext context, String flag, String code) {
    return BlocBuilder<CurrencyCubit, String>(
      builder: (context, currentCurrency) {
        final isSelected = currentCurrency == code;
        return ListTile(
          leading: OsmeaComponents.text(flag, textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(fontSize: 24)),
          title: OsmeaComponents.text(code, textStyle: OsmeaTextStyle.bodyMedium(context)),
          trailing: isSelected ? Icon(Icons.check_circle, color: OsmeaColors.black) : null,
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
