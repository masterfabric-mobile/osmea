import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:storefront_supabase/app/core/bloc/language/language_cubit.dart';
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

import 'models/settings_view_model.dart';
import 'models/module/states.dart';

class SettingsView
    extends MasterViewCubit<SettingsViewModel, SettingsState> {
  SettingsView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  }) : super(
          horizontalPadding: const PaddingVisibility.disabled(),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(
              context.resources.settings,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            size: AppBarSize.large,
            elevation: 0,
            titleSpacing: 0.0,
            leading: OsmeaComponents.iconButton(
              onPressed: () => goRoute('/profile'),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        );

  @override
  void initialContent(
    SettingsViewModel viewModel,
    BuildContext context,
  ) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    SettingsViewModel viewModel,
    SettingsState state,
  ) {
    if (state is SettingsErrorState) {
      return buildError(
        state.message,
        onRetry: () => viewModel.initial(),
      );
    }

    if (state is SettingsLoadedState) {
      return ListView(
        children: [
          OsmeaComponents.listItem(
            title: OsmeaComponents.text(context.resources.language),
            leading: const Icon(Icons.language),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageSheet(context),
          ),
          BlocBuilder<CurrencyCubit, String>(
            builder: (context, currency) {
              return OsmeaComponents.listItem(
                title: OsmeaComponents.text('Currency ($currency)'),
                leading: const Icon(Icons.attach_money),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showCurrencySheet(context),
              );
            },
          ),
        ],
      );
    }

    return Center(
      child: OsmeaComponents.loading(
        type: LoadingType.circularFade,
        size: 36,
        color: OsmeaColors.black,
      ),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    OsmeaComponents.bottomSheet(
      child: OsmeaComponents.column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OsmeaComponents.listItem(
            leading: const Text('🇺🇸'),
            title: const Text('English'),
            onTap: () {
              final locale = const Locale('en');
              context.read<LanguageCubit>().changeLanguage(locale);
              Navigator.pop(context);
            },
          ),
          OsmeaComponents.listItem(
            leading: const Text('🇹🇷'),
            title: const Text('Türkçe'),
            onTap: () {
              final locale = const Locale('tr');
              context.read<LanguageCubit>().changeLanguage(locale);
              Navigator.pop(context);
            },
          ),
          OsmeaComponents.listItem(
            leading: const Text('🇩🇪'),
            title: const Text('Deutsch'),
            onTap: () {
              final locale = const Locale('de');
              context.read<LanguageCubit>().changeLanguage(locale);
              Navigator.pop(context);
            },
          ),
          OsmeaComponents.listItem(
            leading: const Text('🇫🇷'),
            title: const Text('Français'),
            onTap: () {
              final locale = const Locale('fr');
              context.read<LanguageCubit>().changeLanguage(locale);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showCurrencySheet(BuildContext context) {
    OsmeaComponents.bottomSheet(
      child: OsmeaComponents.column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OsmeaComponents.listItem(
            leading: const Text('🇺🇸'),
            title: const Text('USD'),
            onTap: () {
              context.read<CurrencyCubit>().changeCurrency('USD');
              Navigator.pop(context);
            },
          ),
          OsmeaComponents.listItem(
            leading: const Text('🇪🇺'),
            title: const Text('EUR'),
            onTap: () {
              context.read<CurrencyCubit>().changeCurrency('EUR');
              Navigator.pop(context);
            },
          ),
          OsmeaComponents.listItem(
            leading: const Text('🇹🇷'),
            title: const Text('TRY'),
            onTap: () {
              context.read<CurrencyCubit>().changeCurrency('TRY');
              Navigator.pop(context);
            },
          ),
          OsmeaComponents.listItem(
            leading: const Text('🇬🇧'),
            title: const Text('GBP'),
            onTap: () {
              context.read<CurrencyCubit>().changeCurrency('GBP');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
