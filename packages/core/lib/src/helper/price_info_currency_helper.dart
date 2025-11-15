
/// 💰 **OSMEA Currency Helper**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Comprehensive currency formatting and conversion utilities for multi-currency
/// e-commerce applications with localized formatting support.
///
/// ## Features
/// - **Multi-Currency Support**: 13+ supported currencies with native formatting
/// - **Localized Formatting**: Regional number formatting (thousand/decimal separators)
/// - **Symbol Management**: Primary symbols and alternate units (₺ vs TL)
/// - **Price Parsing**: Parse formatted price strings back to numeric values
/// - **Symbol Positioning**: Prefix/suffix positioning based on currency standards
/// - **Input Validation**: Safe parsing with fallback values
/// - **Extension Methods**: Convenient number-to-currency extensions
/// - **Default Handling**: Graceful fallbacks for unsupported currencies
/// - **Multiplier Support**: Currency conversion with custom multipliers
/// - **Arabic Support**: RTL currency symbols and formatting
/// - **European Standards**: EU-compliant number formatting
/// - **API Integration**: Easy integration with e-commerce APIs
/// - **Performance Optimized**: Cached configurations for fast formatting
///
/// ## Supported Currencies
/// - **TRY** (Turkish Lira): ₺1.234,56 or 1.234,56 TL
/// - **USD** (US Dollar): $1,234.56
/// - **EUR** (Euro): €1.234,56
/// - **GBP** (British Pound): £1,234.56
/// - **RUB** (Russian Ruble): 1 234,56 ₽ or 1 234,56 RUB
/// - **AED** (UAE Dirham): 1,234.56 د.إ or 1,234.56 AED
/// - **RON** (Romanian Leu): LEI1.234,56
/// - **SAR** (Saudi Riyal): 1,234.56 ر.س
/// - **QAR** (Qatari Riyal): 1,234.56 ر.ق
/// - **KWD** (Kuwaiti Dinar): 1,234.56 د.ك
/// - **CHF** (Swiss Franc): CHF1,234.56
/// - **CAD** (Canadian Dollar): CAD1,234.56
/// - **AUD** (Australian Dollar): AUD1,234.56
///
/// ## Usage Examples
/// ```dart
/// import 'package:core/core.dart';
///
/// // Set global currency
/// CurrencyHelper.setCurrency('try');
///
/// // Basic price formatting
/// String price1 = CurrencyHelper.formatPrice(1234.56); // ₺1.234,56
/// String price2 = CurrencyHelper.formatPrice(1234.56, currencyCode: 'usd'); // $1,234.56
/// String price3 = CurrencyHelper.formatPrice(1234.56, useAlternateUnit: true); // 1.234,56 TL
///
/// // Using extension methods
/// String price4 = 1234.56.toCurrency(); // ₺1.234,56
/// String price5 = 1234.56.toCurrency(currencyCode: 'eur'); // €1.234,56
/// String price6 = 1234.56.toCurrency(decimalPlaces: 0); // ₺1.235
/// String price7 = 1000.00.toCurrency(currencyCode: 'gbp'); // £1,000.00
/// String price8 = 1000.00.toCurrency(currencyCode: 'gbp', removeTrailingZeros: true); // £1,000
///
/// // Parse formatted prices back to numbers
/// double? amount1 = CurrencyHelper.parsePriceToDouble('₺1.234,56'); // 1234.56
/// double? amount2 = CurrencyHelper.parsePriceToDouble('$1,234.56'); // 1234.56
/// double? amount3 = CurrencyHelper.parsePriceToDouble('1.234,56 TL'); // 1234.56
///
/// // Currency symbol management
/// String symbol1 = CurrencyHelper.getCurrencySymbol(); // ₺
/// String symbol2 = CurrencyHelper.getCurrencySymbol(currencyCode: 'usd'); // $
/// String symbol3 = CurrencyHelper.getCurrencySymbol(useAlternateUnit: true); // TL
///
/// // Currency validation and info
/// bool supported = CurrencyHelper.isCurrencySupported('eur'); // true
/// List<String> currencies = CurrencyHelper.getSupportedCurrencies(); // ['try', 'usd', ...]
/// String fallback = CurrencyHelper.getDefaultPrice(); // ₺0,00
///
/// // API integration with multipliers
/// double? converted = CurrencyHelper.parsePriceToDouble(
///   '₺100,00',
///   multiplier: 0.85, // EUR conversion rate
/// ); // 85.0
/// ```
class PriceInfoCurrencyHelper {
  // ============================================================================
  // 🌍 GLOBAL CURRENCY CONFIGURATION
  // ============================================================================

  static String? _currentCurrencyCode;
  
  /// 🌍 **Set Global Currency**
  ///
  /// Sets the current currency code for the application.
  ///
  /// Example: `CurrencyHelper.setCurrency('usd')` → Sets USD as default currency
  static void setCurrency(String currencyCode) {
    _currentCurrencyCode = currencyCode.toLowerCase();
  }
  
  /// 🌍 **Get Current Currency**
  ///
  /// Returns the currently set currency code, defaults to Turkish Lira.
  ///
  /// Example: `CurrencyHelper.currentCurrency` → `'try'`
  static String get currentCurrency => _currentCurrencyCode ?? 'try';

  // ============================================================================
  // ⚙️ CURRENCY CONFIGURATION MAP
  // ============================================================================
  
  /// ⚙️ **Currency Configuration Database**
  ///
  /// Comprehensive configuration for all supported currencies including:
  /// - Primary symbols (₺, $, €, etc.)
  /// - Alternate units (TL, USD, EUR, etc.)
  /// - Thousand separators (., ,, space)
  /// - Decimal separators (, .)
  /// - Symbol positioning (prefix/suffix)
  static const Map<String, CurrencyConfig> _currencyConfigs = {
    'try': CurrencyConfig(
      symbol: '₺',
      alternateUnit: 'TL',
      thousandSeparator: '.',
      decimalSeparator: ',',
      symbolPosition: CurrencySymbolPosition.prefix,
    ),
    'usd': CurrencyConfig(
      symbol: '\$',
      thousandSeparator: ',',
      decimalSeparator: '.',
      symbolPosition: CurrencySymbolPosition.prefix,
    ),
    'eur': CurrencyConfig(
      symbol: '€',
      thousandSeparator: '.',
      decimalSeparator: ',',
      symbolPosition: CurrencySymbolPosition.prefix,
    ),
    'gbp': CurrencyConfig(
      symbol: '£',
      thousandSeparator: ',',
      decimalSeparator: '.',
      symbolPosition: CurrencySymbolPosition.prefix,
    ),
    'rub': CurrencyConfig(
      symbol: '₽',
      alternateUnit: 'RUB',
      thousandSeparator: ' ',
      decimalSeparator: ',',
      symbolPosition: CurrencySymbolPosition.suffix,
    ),
    'aed': CurrencyConfig(
      symbol: 'د.إ',
      alternateUnit: 'AED',
      thousandSeparator: ',',
      decimalSeparator: '.',
      symbolPosition: CurrencySymbolPosition.suffix,
    ),
    'ron': CurrencyConfig(
      symbol: 'LEI',
      thousandSeparator: '.',
      decimalSeparator: ',',
      symbolPosition: CurrencySymbolPosition.prefix,
    ),
    'sar': CurrencyConfig(
      symbol: 'ر.س',
      thousandSeparator: ',',
      decimalSeparator: '.',
      symbolPosition: CurrencySymbolPosition.suffix,
    ),
    'qar': CurrencyConfig(
      symbol: 'ر.ق',
      thousandSeparator: ',',
      decimalSeparator: '.',
      symbolPosition: CurrencySymbolPosition.suffix,
    ),
    'kwd': CurrencyConfig(
      symbol: 'د.ك',
      thousandSeparator: ',',
      decimalSeparator: '.',
      symbolPosition: CurrencySymbolPosition.suffix,
    ),
    'chf': CurrencyConfig(
      symbol: 'CHF',
      thousandSeparator: ',',
      decimalSeparator: '.',
      symbolPosition: CurrencySymbolPosition.prefix,
    ),
    'cad': CurrencyConfig(
      symbol: 'CAD',
      thousandSeparator: ',',
      decimalSeparator: '.',
      symbolPosition: CurrencySymbolPosition.prefix,
    ),
    'aud': CurrencyConfig(
      symbol: 'AUD',
      thousandSeparator: ',',
      decimalSeparator: '.',
      symbolPosition: CurrencySymbolPosition.prefix,
    ),
  };

  // ============================================================================
  // 💰 PRICE FORMATTING METHODS
  // ============================================================================

  /// 💰 **Universal Price Formatter**
  ///
  /// Formats any numeric value to a localized price string with currency symbol.
  /// Handles different data types (int, double, string) and applies appropriate
  /// formatting based on the specified or current currency configuration.
  ///
  /// **Parameters:**
  /// - `amount`: Numeric value to format (int, double, or string)
  /// - `currencyCode`: Override currency (optional, uses current if not specified)
  /// - `useAlternateUnit`: Use alternate unit instead of symbol (TL instead of ₺)
  /// - `decimalPlaces`: Number of decimal places (default: 2)
  /// - `removeTrailingZeros`: Remove trailing zeros from decimal part (default: false)
  ///
  /// **Returns:** Formatted price string or default price on error
  ///
  /// Example: `formatPrice(1234.56, currencyCode: 'try')` → `₺1.234,56`
  /// Example: `formatPrice(1000.00, currencyCode: 'gbp')` → `£1,000.00`
  /// Example: `formatPrice(1000.00, currencyCode: 'gbp', removeTrailingZeros: true)` → `£1,000`
  static String formatPrice(
    dynamic amount, {
    String? currencyCode,
    bool useAlternateUnit = false,
    int decimalPlaces = 2,
    bool removeTrailingZeros = false,
  }) {
    if (amount == null) return getDefaultPrice();
    
    final currency = currencyCode?.toLowerCase() ?? currentCurrency;
    final config = _currencyConfigs[currency];
    
    if (config == null) return getDefaultPrice();
    
    final numericAmount = _parseAmount(amount);
    if (numericAmount == null) return getDefaultPrice();
    
    final formattedNumber = _formatNumber(
      numericAmount,
      config.thousandSeparator,
      config.decimalSeparator,
      decimalPlaces,
      removeTrailingZeros: removeTrailingZeros,
    );
    
    final symbol = useAlternateUnit && config.alternateUnit != null
        ? config.alternateUnit!
        : config.symbol;
    
    return config.symbolPosition == CurrencySymbolPosition.prefix
        ? '$symbol$formattedNumber'
        : '$formattedNumber $symbol';
  }

  /// 💱 **Currency Symbol Extractor**
  ///
  /// Returns only the currency symbol without any formatting or amount.
  /// Useful for displaying currency indicators in UI components.
  ///
  /// **Parameters:**
  /// - `currencyCode`: Currency to get symbol for (optional, uses current if not specified)
  /// - `useAlternateUnit`: Return alternate unit instead of symbol (TL vs ₺)
  ///
  /// **Returns:** Currency symbol string or default symbol (₺) on error
  ///
  /// Example: `getCurrencySymbol(currencyCode: 'usd')` → `$`
  static String getCurrencySymbol({
    String? currencyCode,
    bool useAlternateUnit = false,
  }) {
    final currency = currencyCode?.toLowerCase() ?? currentCurrency;
    final config = _currencyConfigs[currency];
    
    if (config == null) return '₺';
    
    return useAlternateUnit && config.alternateUnit != null
        ? config.alternateUnit!
        : config.symbol;
  }

  // ============================================================================
  // 🔄 PRICE PARSING METHODS
  // ============================================================================

  /// 🔄 **Price String Parser**
  ///
  /// Converts a formatted price string back to a numeric double value.
  /// Automatically handles different currency formats, removes symbols,
  /// and applies regional formatting rules for parsing.
  ///
  /// **Parameters:**
  /// - `priceString`: Formatted price string to parse
  /// - `currencyCode`: Currency format to use for parsing (optional)
  /// - `multiplier`: Conversion multiplier for currency exchange (default: 1.0)
  ///
  /// **Returns:** Parsed double value or null if parsing fails
  ///
  /// Example: `parsePriceToDouble('₺1.234,56')` → `1234.56`
  static double? parsePriceToDouble(
    String? priceString, {
    String? currencyCode,
    double multiplier = 1.0,
  }) {
    if (priceString == null || priceString.isEmpty) return null;
    
    final currency = currencyCode?.toLowerCase() ?? currentCurrency;
    final config = _currencyConfigs[currency];
    
    if (config == null) return null;
    
    // Remove currency symbols and clean the string
    String cleanPrice = priceString;
    
    // Remove common currency symbols
    final currencySymbols = _currencyConfigs.values
        .map((c) => [c.symbol, c.alternateUnit])
        .expand((symbols) => symbols)
        .where((s) => s != null)
        .map((s) => RegExp.escape(s!))
        .join('|');
    
    cleanPrice = cleanPrice.replaceAll(RegExp('[$currencySymbols]'), '');
    cleanPrice = cleanPrice.replaceAll(RegExp(r'\s+'), ''); // Remove spaces
    cleanPrice = cleanPrice.replaceAll('\u00A0', ''); // Remove non-breaking spaces
    cleanPrice = cleanPrice.replaceAll('\u200F', ''); // Remove RTL marks
    
    // Handle thousand separators and decimal separators
    if (config.thousandSeparator != config.decimalSeparator) {
      // Remove thousand separators first
      cleanPrice = cleanPrice.replaceAll(config.thousandSeparator, '');
      // Replace decimal separator with standard dot
      cleanPrice = cleanPrice.replaceAll(config.decimalSeparator, '.');
    }
    
    try {
      final amount = double.parse(cleanPrice);
      return amount * multiplier;
    } catch (e) {
      return null;
    }
  }

  // ============================================================================
  // 🛡️ UTILITY & VALIDATION METHODS
  // ============================================================================

  /// 🛡️ **Default Price Provider**
  ///
  /// Returns the default formatted price string in Turkish Lira format.
  /// Used as a fallback when formatting operations fail.
  ///
  /// **Returns:** Default price string `₺0,00`
  ///
  /// Example: `getDefaultPrice()` → `₺0,00`
  static String getDefaultPrice() => '₺0,00';

  /// 🛡️ **Currency Support Validator**
  ///
  /// Checks if a given currency code is supported by the helper.
  /// Case-insensitive validation against the configuration database.
  ///
  /// **Parameters:**
  /// - `currencyCode`: Currency code to validate (e.g., 'USD', 'eur')
  ///
  /// **Returns:** True if supported, false otherwise
  ///
  /// Example: `isCurrencySupported('eur')` → `true`
  static bool isCurrencySupported(String currencyCode) {
    return _currencyConfigs.containsKey(currencyCode.toLowerCase());
  }

  /// 🛡️ **Supported Currencies List**
  ///
  /// Returns a list of all supported currency codes.
  /// Useful for building currency selection UI components.
  ///
  /// **Returns:** List of currency codes in lowercase
  ///
  /// Example: `getSupportedCurrencies()` → `['try', 'usd', 'eur', ...]`
  static List<String> getSupportedCurrencies() {
    return _currencyConfigs.keys.toList();
  }

  // ============================================================================
  // 🔧 PRIVATE HELPER METHODS
  // ============================================================================

  /// 🔧 **Private Amount Parser**
  ///
  /// Internal method to safely convert various data types to double.
  /// Handles int, double, and string inputs with error handling.
  static double? _parseAmount(dynamic amount) {
    if (amount is double) return amount;
    if (amount is int) return amount.toDouble();
    if (amount is String) {
      try {
        return double.parse(amount);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// 🔧 **Private Number Formatter**
  ///
  /// Internal method to format numbers with thousand and decimal separators.
  /// Handles different regional formatting standards.
  static String _formatNumber(
    double amount,
    String thousandSep,
    String decimalSep,
    int decimalPlaces, {
    bool removeTrailingZeros = false,
  }) {
    // Split into integer and decimal parts
    final parts = amount.toStringAsFixed(decimalPlaces).split('.');
    final integerPart = parts[0];
    var decimalPart = parts.length > 1 ? parts[1] : '';
    
    // Remove trailing zeros if requested
    if (removeTrailingZeros && decimalPart.isNotEmpty) {
      decimalPart = decimalPart.replaceAll(RegExp(r'0+$'), '');
    }
    
    // Add thousand separators
    final formattedInteger = _addThousandSeparators(integerPart, thousandSep);
    
    // Combine parts
    if (decimalPlaces > 0 && decimalPart.isNotEmpty) {
      return '$formattedInteger$decimalSep$decimalPart';
    } else {
      return formattedInteger;
    }
  }

  /// 🔧 **Private Thousand Separator Formatter**
  ///
  /// Internal method to add thousand separators to integer part of numbers.
  /// Efficiently handles large numbers with proper separator placement.
  static String _addThousandSeparators(String number, String separator) {
    if (number.length <= 3) return number;
    
    final buffer = StringBuffer();
    final reversed = number.split('').reversed.toList();
    
    for (int i = 0; i < reversed.length; i++) {
      if (i != 0 && i % 3 == 0) {
        buffer.write(separator);
      }
      buffer.write(reversed[i]);
    }
    
    return buffer.toString().split('').reversed.join();
  }
}

// ============================================================================
// 📊 CURRENCY CONFIGURATION MODELS
// ============================================================================

/// 📊 **Currency Configuration Model**
///
/// Immutable configuration class that defines formatting rules for each currency.
/// Contains all necessary information for proper currency display and parsing.
///
/// **Properties:**
/// - `symbol`: Primary currency symbol (₺, $, €, etc.)
/// - `alternateUnit`: Alternate text representation (TL, USD, EUR, etc.)
/// - `thousandSeparator`: Character used for thousand grouping
/// - `decimalSeparator`: Character used for decimal separation
/// - `symbolPosition`: Whether symbol appears before or after the amount
class CurrencyConfig {
  final String symbol;
  final String? alternateUnit;
  final String thousandSeparator;
  final String decimalSeparator;
  final CurrencySymbolPosition symbolPosition;

  const CurrencyConfig({
    required this.symbol,
    this.alternateUnit,
    required this.thousandSeparator,
    required this.decimalSeparator,
    required this.symbolPosition,
  });
}

/// 📊 **Currency Symbol Position Enum**
///
/// Defines whether currency symbols should appear before (prefix) or after (suffix) 
/// the monetary amount according to regional standards.
///
/// **Values:**
/// - `prefix`: Symbol before amount (e.g., $100, €100)
/// - `suffix`: Symbol after amount (e.g., 100₽, 100 د.إ)
enum CurrencySymbolPosition { prefix, suffix }

// ============================================================================
// 🚀 EXTENSION METHODS
// ============================================================================

/// 🚀 **Number to Currency Extension**
///
/// Convenient extension methods on `num` type for easy currency formatting.
/// Provides a fluent API for converting numbers to currency strings.
///
/// **Usage:**
/// ```dart
/// 1234.56.toCurrency() // ₺1.234,56
/// 1000.toCurrency(currencyCode: 'usd') // $1,000.00
/// 999.99.toCurrency(decimalPlaces: 0) // ₺1.000
/// ```
extension CurrencyExtension on num {
  /// 🚀 **Convert Number to Currency**
  ///
  /// Formats this number as a currency string using the specified options.
  /// Provides the same functionality as `CurrencyHelper.formatPrice()` but
  /// with a more convenient syntax for inline usage.
  ///
  /// **Parameters:**
  /// - `currencyCode`: Currency to format as (optional, uses current if not specified)
  /// - `useAlternateUnit`: Use alternate unit instead of symbol
  /// - `decimalPlaces`: Number of decimal places to display
  /// - `removeTrailingZeros`: Remove trailing zeros from decimal part (default: false)
  ///
  /// **Returns:** Formatted currency string
  ///
  /// Example: `1234.56.toCurrency(currencyCode: 'eur')` → `€1.234,56`
  /// Example: `1000.00.toCurrency(currencyCode: 'gbp')` → `£1,000.00`
  /// Example: `1000.00.toCurrency(currencyCode: 'gbp', removeTrailingZeros: true)` → `£1,000`
  String toCurrency({
    String? currencyCode,
    bool useAlternateUnit = false,
    int decimalPlaces = 2,
    bool removeTrailingZeros = false,
  }) {
    return PriceInfoCurrencyHelper.formatPrice(
      this,
      currencyCode: currencyCode,
      useAlternateUnit: useAlternateUnit,
      decimalPlaces: decimalPlaces,
      removeTrailingZeros: removeTrailingZeros,
    );
  }
}

// ============================================================================
// 📖 COMPREHENSIVE USAGE DOCUMENTATION
// ============================================================================

/// **📖 COMPREHENSIVE USAGE EXAMPLES**
///
/// This section provides extensive examples for all functionality:
///
/// ## **Basic Usage**
/// ```dart
/// // Set global currency once in your app
/// CurrencyHelper.setCurrency('try');
/// 
/// // Format basic prices
/// String price1 = CurrencyHelper.formatPrice(1234.56); // ₺1.234,56
/// String price2 = CurrencyHelper.formatPrice(1234.56, currencyCode: 'usd'); // $1,234.56
/// String price3 = CurrencyHelper.formatPrice(1234.56, useAlternateUnit: true); // 1.234,56 TL
/// String price4 = CurrencyHelper.formatPrice(1234.567, decimalPlaces: 3); // ₺1.234,567
/// ```
///
/// ## **Extension Methods**
/// ```dart
/// // Using convenient extension methods
/// String price1 = 1234.56.toCurrency(); // ₺1.234,56
/// String price2 = 1234.56.toCurrency(currencyCode: 'eur'); // €1.234,56
/// String price3 = 1234.56.toCurrency(decimalPlaces: 0); // ₺1.235
/// String price4 = 99.99.toCurrency(useAlternateUnit: true); // 99,99 TL
/// 
/// // Works with integers too
/// String price5 = 1000.toCurrency(); // ₺1.000,00
/// String price6 = 500.toCurrency(currencyCode: 'usd'); // $500.00
/// ```
///
/// ## **Price Parsing**
/// ```dart
/// // Parse formatted prices back to numbers
/// double? amount1 = CurrencyHelper.parsePriceToDouble('₺1.234,56'); // 1234.56
/// double? amount2 = CurrencyHelper.parsePriceToDouble('$1,234.56'); // 1234.56
/// double? amount3 = CurrencyHelper.parsePriceToDouble('1.234,56 TL'); // 1234.56
/// double? amount4 = CurrencyHelper.parsePriceToDouble('€1.234,56'); // 1234.56
/// 
/// // With currency conversion
/// double? converted = CurrencyHelper.parsePriceToDouble(
///   '₺100,00',
///   multiplier: 0.85, // EUR conversion rate
/// ); // 85.0
/// ```
///
/// ## **Symbol Management**
/// ```dart
/// // Get currency symbols
/// String symbol1 = CurrencyHelper.getCurrencySymbol(); // ₺ (current currency)
/// String symbol2 = CurrencyHelper.getCurrencySymbol(currencyCode: 'usd'); // $
/// String symbol3 = CurrencyHelper.getCurrencySymbol(useAlternateUnit: true); // TL
/// String symbol4 = CurrencyHelper.getCurrencySymbol(currencyCode: 'aed'); // د.إ
/// ```
///
/// ## **Validation & Utilities**
/// ```dart
/// // Check currency support
/// bool supported1 = CurrencyHelper.isCurrencySupported('eur'); // true
/// bool supported2 = CurrencyHelper.isCurrencySupported('xyz'); // false
/// 
/// // Get all supported currencies
/// List<String> currencies = CurrencyHelper.getSupportedCurrencies();
/// // Returns: ['try', 'usd', 'eur', 'gbp', 'rub', 'aed', 'ron', 'sar', 'qar', 'kwd', 'chf', 'cad', 'aud']
/// 
/// // Fallback handling
/// String fallback = CurrencyHelper.getDefaultPrice(); // ₺0,00
/// ```
///
/// ## **E-commerce Integration**
/// ```dart
/// // Product price display
/// class Product {
///   final double price;
///   final String currencyCode;
///   
///   String get formattedPrice => price.toCurrency(currencyCode: currencyCode);
/// }
/// 
/// // Cart totals with different currencies
/// double cartTotal = 299.99;
/// String displayPrice = cartTotal.toCurrency(); // Uses current currency
/// 
/// // API response parsing
/// Map<String, dynamic> apiResponse = {'price': '₺1.299,99'};
/// double? numericPrice = CurrencyHelper.parsePriceToDouble(apiResponse['price']);
/// ```
///
/// ## **Multi-Language Support**
/// ```dart
/// // Switch currencies based on user locale
/// void switchCurrencyByLocale(String locale) {
///   switch (locale) {
///     case 'tr_TR':
///       CurrencyHelper.setCurrency('try');
///       break;
///     case 'en_US':
///       CurrencyHelper.setCurrency('usd');
///       break;
///     case 'de_DE':
///       CurrencyHelper.setCurrency('eur');
///       break;
///     default:
///       CurrencyHelper.setCurrency('try');
///   }
/// }
/// ```
