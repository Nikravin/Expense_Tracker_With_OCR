import 'package:expense_tracker/services/currency_service.dart';

/// Currency utility helper for easy integration across the app
class CurrencyHelper {
  // Private constructor to prevent instantiation
  CurrencyHelper._();

  /// Get the current currency symbol as a string
  static Future<String> getCurrentSymbol() async {
    final currency = await CurrencyService.getCurrentCurrency();
    return currency.symbol;
  }

  /// Get the current currency code as a string
  static Future<String> getCurrentCode() async {
    final currency = await CurrencyService.getCurrentCurrency();
    return currency.code;
  }

  /// Format any amount with current currency
  static Future<String> formatAmount(double amount) async {
    return await CurrencyService.formatAmountWithCurrentCurrency(amount);
  }

  /// Quick format with fallback to USD if error occurs
  static String formatAmountSync(double amount, {String fallbackSymbol = '\$'}) {
    return '$fallbackSymbol${amount.toStringAsFixed(2)}';
  }

  /// Check if user has set a custom currency
  static Future<bool> hasCustomCurrency() async {
    return await CurrencyService.hasSavedCurrency();
  }

  /// Get all supported currencies
  static List<CurrencyModel> getAllCurrencies() {
    return CurrencyService.supportedCurrencies;
  }

  /// Find currency by code
  static CurrencyModel? findCurrencyByCode(String code) {
    return CurrencyService.getCurrencyByCode(code);
  }
}
