import 'package:expense_tracker/screens/profile/bloc/app_theme/app_theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppTheme {
  // Background Colors
  static Color backgroundColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? const Color(0xFF121212) : Colors.grey.shade100;
  }

  static Color surfaceColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? const Color(0xFF1E1E1E) : Colors.white;
  }

  static Color cardColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? const Color(0xFF2C2C2C) : Colors.white;
  }

  // Text Colors
  static Color onBackgroundColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? Colors.white : Colors.black;
  }

  static Color onSurfaceColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? Colors.white : Colors.black;
  }

  static Color secondaryTextColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? Colors.grey.shade300 : Colors.grey.shade600;
  }

  static Color hintTextColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? Colors.grey.shade500 : Colors.grey.shade400;
  }

  // Primary Colors
  static Color primaryColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark 
        ? const Color.fromARGB(255, 87, 99, 236)
        : const Color.fromARGB(255, 67, 79, 216);
  }

  static Color onPrimaryColor(BuildContext context) {
    return Colors.white;
  }

  static Color primaryVariantColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark 
        ? const Color.fromARGB(255, 67, 79, 200)
        : const Color.fromARGB(255, 47, 59, 180);
  }

  // Secondary Colors
  static Color secondaryColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark
        ? const Color.fromARGB(255, 126, 78, 246)
        : const Color.fromARGB(255, 106, 58, 226);
  }

  static Color onSecondaryColor(BuildContext context) {
    return Colors.white;
  }

  static Color secondarySecondColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark
        ? const Color(0XFFE584F7)
        : const Color(0XFFE064F7);
  }

  // Tertiary Colors
  static Color tertiaryColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark
        ? const Color(0XFFFF9D7C)
        : const Color(0XFFFF8D6C);
  }

  // Status Colors
  static Color successColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? const Color(0xFF4CAF50) : const Color(0xFF2E7D32);
  }

  static Color errorColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? const Color(0xFFEF5350) : const Color(0xFFD32F2F);
  }

  static Color warningColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? const Color(0xFFFF9800) : const Color(0xFFE65100);
  }

  static Color infoColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? const Color(0xFF2196F3) : const Color(0xFF1565C0);
  }

  // Border and Outline Colors
  static Color outlineColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? Colors.grey.shade700 : Colors.grey.shade300;
  }

  static Color dividerColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? Colors.grey.shade800 : Colors.grey.shade200;
  }

  static Color borderColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? Colors.grey.shade600 : Colors.grey.shade400;
  }

  // Navigation Colors
  static Color bottomNavigationBarColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? const Color(0xFF1E1E1E) : Colors.white;
  }

  static Color bottomNavigationBarSelectedColor(BuildContext context) {
    return primaryColor(context);
  }

  static Color bottomNavigationBarUnselectedColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? Colors.grey.shade500 : Colors.grey.shade600;
  }

  static Color bottomNavigationBarAddBigButtonColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? const Color(0xFF2C2C2C) : Colors.white;
  }

  // AppBar Colors
  static Color appBarColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? const Color(0xFF1E1E1E) : Colors.white;
  }

  static Color appBarTextColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? Colors.white : Colors.black;
  }

  static Color appBarIconColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? Colors.white : Colors.black;
  }

  // Transaction and Container Colors
  static Color transactionBoxColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? const Color(0xFF2C2C2C) : Colors.white;
  }

  static Color transactionBackIconColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? const Color(0xFF2C2C2C) : Colors.white;
  }

  // Input Field Colors
  static Color inputFieldColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade50;
  }

  static Color inputBorderColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? Colors.grey.shade600 : Colors.grey.shade300;
  }

  static Color inputFocusedBorderColor(BuildContext context) {
    return primaryColor(context);
  }

  // Button Colors
  static Color elevatedButtonColor(BuildContext context) {
    return primaryColor(context);
  }

  static Color elevatedButtonTextColor(BuildContext context) {
    return Colors.white;
  }

  static Color textButtonColor(BuildContext context) {
    return primaryColor(context);
  }

  static Color outlinedButtonBorderColor(BuildContext context) {
    return primaryColor(context);
  }

  static Color outlinedButtonTextColor(BuildContext context) {
    return primaryColor(context);
  }

  // Shadow Colors
  static Color shadowColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.2);
  }

  // Floating Action Button Colors
  static Color fabColor(BuildContext context) {
    return primaryColor(context);
  }

  static Color fabIconColor(BuildContext context) {
    return Colors.white;
  }

  // Dialog Colors
  static Color dialogColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? const Color(0xFF2C2C2C) : Colors.white;
  }

  // Snackbar Colors
  static Color snackbarColor(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return isDark ? const Color(0xFF2C2C2C) : const Color(0xFF323232);
  }

  static Color snackbarTextColor(BuildContext context) {
    return Colors.white;
  }

  static bool _isDarkMode(BuildContext context) {
    try {
      final themeState = context.watch<AppThemeBloc>().state;
      if (themeState is AppThemeLoadedState) {
        return themeState.isDark;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}