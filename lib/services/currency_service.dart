import 'package:hive/hive.dart';
import 'package:expense_tracker/model/user_local_data_model.dart';

class CurrencyModel {
  final String code;
  final String symbol;
  final String name;

  CurrencyModel({
    required this.code,
    required this.symbol,
    required this.name,
  });

  // Convert from Hive model
  factory CurrencyModel.fromHive(CurrencyLocalData hiveData) {
    return CurrencyModel(
      code: hiveData.code,
      symbol: hiveData.symbol,
      name: hiveData.name,
    );
  }

  // Convert to Hive model
  CurrencyLocalData toHive() {
    return CurrencyLocalData(
      code: code,
      symbol: symbol,
      name: name,
    );
  }
}

class CurrencyService {
  static const String _currencyBoxName = 'currencyBox';
  static const String _currentCurrencyKey = 'currentCurrency';

  // Supported currencies
  static final List<CurrencyModel> supportedCurrencies = [
    CurrencyModel(code: 'USD', symbol: '\$', name: 'US Dollar'),
    CurrencyModel(code: 'EUR', symbol: '€', name: 'Euro'),
    CurrencyModel(code: 'GBP', symbol: '£', name: 'British Pound'),
    CurrencyModel(code: 'JPY', symbol: '¥', name: 'Japanese Yen'),
    CurrencyModel(code: 'INR', symbol: '₹', name: 'Indian Rupee'),
    CurrencyModel(code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar'),
    CurrencyModel(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar'),
    CurrencyModel(code: 'CHF', symbol: 'CHF', name: 'Swiss Franc'),
    CurrencyModel(code: 'CNY', symbol: '¥', name: 'Chinese Yuan'),
    CurrencyModel(code: 'KRW', symbol: '₩', name: 'South Korean Won'),
  ];

  // Initialize Hive box
  static Future<Box<CurrencyLocalData>> _getCurrencyBox() async {
    if (!Hive.isBoxOpen(_currencyBoxName)) {
      return await Hive.openBox<CurrencyLocalData>(_currencyBoxName);
    }
    return Hive.box<CurrencyLocalData>(_currencyBoxName);
  }

  // Get current selected currency
  static Future<CurrencyModel> getCurrentCurrency() async {
    try {
      final box = await _getCurrencyBox();
      final currencyData = box.get(_currentCurrencyKey);
      
      if (currencyData != null) {
        return CurrencyModel.fromHive(currencyData);
      }
    } catch (e) {
      print('Error getting current currency: $e');
    }
    
    // Return default currency if none saved or error occurred
    return CurrencyModel(code: 'INR', symbol: '₹', name: 'Indian Rupee');
  }

  // Save selected currency
  static Future<void> saveCurrency(CurrencyModel currency) async {
    try {
      final box = await _getCurrencyBox();
      await box.put(_currentCurrencyKey, currency.toHive());
    } catch (e) {
      print('Error saving currency: $e');
      throw Exception('Failed to save currency: $e');
    }
  }

  // Get currency by code
  static CurrencyModel? getCurrencyByCode(String code) {
    try {
      return supportedCurrencies.firstWhere((currency) => currency.code == code);
    } catch (e) {
      return supportedCurrencies.firstWhere((currency) => currency.code == 'INR'); // Default to INR
    }
  }

  // Initialize currency service (call this on app startup if needed)
  static Future<void> initialize() async {
    try {
      await _getCurrencyBox();
      print('Currency service initialized successfully');
    } catch (e) {
      print('Error initializing currency service: $e');
    }
  }

  // Clear all currency data (useful for debugging or reset)
  static Future<void> clearCurrencyData() async {
    try {
      final box = await _getCurrencyBox();
      await box.clear();
      print('Currency data cleared');
    } catch (e) {
      print('Error clearing currency data: $e');
    }
  }

  // Check if currency is already saved
  static Future<bool> hasSavedCurrency() async {
    try {
      final box = await _getCurrencyBox();
      return box.containsKey(_currentCurrencyKey);
    } catch (e) {
      print('Error checking saved currency: $e');
      return false;
    }
  }

  // Format amount with selected currency
  static String formatAmount(double amount, {CurrencyModel? currency}) {
    final curr = currency ?? CurrencyModel(code: 'INR', symbol: '₹', name: 'Indian Rupee');
    return '${curr.symbol}${amount.toStringAsFixed(2)}';
  }

  // Format amount with current saved currency
  static Future<String> formatAmountWithCurrentCurrency(double amount) async {
    final currency = await getCurrentCurrency();
    return formatAmount(amount, currency: currency);
  }
}
