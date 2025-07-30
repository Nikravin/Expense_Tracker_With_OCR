class ReceiptParser {
  // Common expense categories and their keywords
  static const Map<String, List<String>> categoryKeywords = {
    'Food': ['restaurant', 'cafe', 'food', 'pizza', 'burger', 'coffee', 'tea', 'meal', 'dining', 'kitchen', 'bakery', 'bar', 'lunch', 'dinner', 'breakfast'],
    'Transportation': ['uber', 'taxi', 'bus', 'train', 'metro', 'fuel', 'gas', 'petrol', 'parking', 'toll', 'transport'],
    'Shopping': ['mall', 'store', 'shop', 'retail', 'supermarket', 'grocery', 'market', 'clothing', 'fashion'],
    'Entertainment': ['cinema', 'movie', 'theater', 'game', 'entertainment', 'park', 'museum', 'concert', 'ticket'],
    'Healthcare': ['hospital', 'clinic', 'pharmacy', 'medical', 'doctor', 'health', 'medicine', 'drug'],
    'Utilities': ['electricity', 'water', 'gas', 'internet', 'phone', 'mobile', 'wifi', 'utility'],
    'Education': ['school', 'college', 'university', 'book', 'education', 'course', 'training'],
    'Other': []
  };

  // Common currency symbols and words
  static const List<String> currencySymbols = ['\$', '₹', '€', '£', '¥', 'USD', 'INR', 'EUR', 'GBP', 'JPY'];

  /// Parse receipt text and extract expense information
  static ReceiptData parseReceipt(String ocrText) {
    final lines = ocrText.split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty).toList();
    
    // Extract amount
    double? amount = _extractAmount(lines);
    
    // Extract merchant/vendor name
    String merchantName = _extractMerchantName(lines);
    
    // Determine category based on merchant name and text content
    String category = _determineCategory(ocrText.toLowerCase(), merchantName.toLowerCase());
    
    // Extract date (simplified - you can enhance this)
    DateTime? date = _extractDate(lines);
    
    return ReceiptData(
      amount: amount,
      merchantName: merchantName,
      category: category,
      date: date ?? DateTime.now(),
      rawText: ocrText,
    );
  }

  /// Extract monetary amount from receipt text
  static double? _extractAmount(List<String> lines) {
    final amountPatterns = [
      RegExp(r'total[:\s]*[\$₹€£¥]?\s*(\d+\.?\d*)', caseSensitive: false),
      RegExp(r'amount[:\s]*[\$₹€£¥]?\s*(\d+\.?\d*)', caseSensitive: false),
      RegExp(r'[\$₹€£¥]\s*(\d+\.?\d*)', caseSensitive: false),
      RegExp(r'(\d+\.\d{2})', caseSensitive: false), // Decimal amounts
      RegExp(r'(\d+)', caseSensitive: false), // Whole numbers
    ];

    List<double> possibleAmounts = [];

    for (String line in lines) {
      for (RegExp pattern in amountPatterns) {
        final matches = pattern.allMatches(line.toLowerCase());
        for (Match match in matches) {
          final amountStr = match.group(1);
          if (amountStr != null) {
            final amount = double.tryParse(amountStr);
            if (amount != null && amount > 0 && amount < 100000) { // Reasonable range
              possibleAmounts.add(amount);
            }
          }
        }
      }
    }

    if (possibleAmounts.isEmpty) return null;

    // Return the largest amount (likely to be the total)
    possibleAmounts.sort((a, b) => b.compareTo(a));
    return possibleAmounts.first;
  }

  /// Extract merchant/vendor name (usually the first few lines)
  static String _extractMerchantName(List<String> lines) {
    if (lines.isEmpty) return 'Unknown Merchant';
    
    // Skip very short lines and numbers-only lines
    for (String line in lines.take(5)) {
      if (line.length > 3 && !RegExp(r'^\d+$').hasMatch(line) && !line.contains(RegExp(r'[\$₹€£¥]'))) {
        return line;
      }
    }
    
    return lines.first;
  }

  /// Determine expense category based on text content
  static String _determineCategory(String text, String merchantName) {
    final combinedText = '$text $merchantName';
    
    for (String category in categoryKeywords.keys) {
      for (String keyword in categoryKeywords[category]!) {
        if (combinedText.contains(keyword)) {
          return category;
        }
      }
    }
    
    return 'Other';
  }

  /// Extract date from receipt text (basic implementation)
  static DateTime? _extractDate(List<String> lines) {
    final datePatterns = [
      RegExp(r'(\d{1,2})/(\d{1,2})/(\d{4})'), // MM/DD/YYYY or DD/MM/YYYY
      RegExp(r'(\d{1,2})-(\d{1,2})-(\d{4})'), // MM-DD-YYYY or DD-MM-YYYY
      RegExp(r'(\d{4})-(\d{1,2})-(\d{1,2})'), // YYYY-MM-DD
    ];

    for (String line in lines) {
      for (RegExp pattern in datePatterns) {
        final match = pattern.firstMatch(line);
        if (match != null) {
          try {
            int year = int.parse(match.group(3) ?? match.group(1)!);
            int month = int.parse(match.group(2)!);
            int day = int.parse(match.group(1) ?? match.group(3)!);
            
            // Basic validation
            if (year > 2000 && year <= DateTime.now().year + 1 && 
                month >= 1 && month <= 12 && 
                day >= 1 && day <= 31) {
              return DateTime(year, month, day);
            }
          } catch (e) {
            continue;
          }
        }
      }
    }
    
    return null;
  }
}

/// Data class to hold parsed receipt information
class ReceiptData {
  final double? amount;
  final String merchantName;
  final String category;
  final DateTime date;
  final String rawText;

  ReceiptData({
    required this.amount,
    required this.merchantName,
    required this.category,
    required this.date,
    required this.rawText,
  });

  @override
  String toString() {
    return 'ReceiptData(amount: $amount, merchant: $merchantName, category: $category, date: $date)';
  }
}
