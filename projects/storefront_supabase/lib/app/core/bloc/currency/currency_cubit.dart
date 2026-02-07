import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyCubit extends Cubit<String> {
  CurrencyCubit() : super('USD') {
    _loadSavedCurrency();
  }

  Future<void> _loadSavedCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final String? currencyCode = prefs.getString('currency_code');

    if (currencyCode != null) {
      emit(currencyCode);
    } else {
      // Default to USD
      emit('USD');
    }
  }

  Future<void> changeCurrency(String currencyCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency_code', currencyCode);
    emit(currencyCode);
  }
}
