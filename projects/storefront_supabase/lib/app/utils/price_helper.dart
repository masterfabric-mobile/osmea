import 'package:intl/intl.dart';

class PriceHelper {
  // Hardcoded rates for reference. Base is USD.
  static const Map<String, double> _rates = {
    'USD': 1.0,
    'EUR': 0.92,
    'TRY': 34.0,
    'GBP': 0.79,
  };

  static double convert(double priceInUsd, String targetCurrency) {
    final rate = _rates[targetCurrency] ?? 1.0;
    return priceInUsd * rate;
  }

  static String format(double priceInUsd, String currencyCode, String locale) {
    final convertedPrice = convert(priceInUsd, currencyCode);
    
    // simpleCurrency automatically determines symbol based on currency code (name)
    // and formatting (decimal separators) based on locale.
    final formatter = NumberFormat.simpleCurrency(
      locale: locale,
      name: currencyCode,
    );
    return formatter.format(convertedPrice);
  }
}
