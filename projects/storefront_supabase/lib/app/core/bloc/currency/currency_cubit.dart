import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storefront_supabase/services/store_config_service.dart';

class CurrencyCubit extends Cubit<String> {
  CurrencyCubit(this._storeConfig) : super(_storeConfig.defaultCurrencyCode) {
    _loadSavedCurrency();
  }

  final StoreConfigService _storeConfig;

  Future<void> _loadSavedCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final String? currencyCode = prefs.getString('currency_code');

    if (currencyCode != null) {
      emit(currencyCode);
    } else {
      emit(_storeConfig.defaultCurrencyCode);
    }
  }

  Future<void> changeCurrency(String currencyCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency_code', currencyCode);
    emit(currencyCode);
  }
}
