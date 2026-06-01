import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme Provider for managing light and dark mode
class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'isDarkMode';
  static const String _currencyKey = 'selectedCurrency';
  static const String _notificationsKey = 'notificationsEnabled';

  bool _isDarkMode = false;
  String _selectedCurrency = '₹';
  bool _notificationsEnabled = true;

  bool get isDarkMode => _isDarkMode;
  String get selectedCurrency => _selectedCurrency;
  bool get notificationsEnabled => _notificationsEnabled;

  ThemeProvider() {
    _loadPreferences();
  }

  /// Load preferences from local storage
  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_themeKey) ?? false;
      _selectedCurrency = prefs.getString(_currencyKey) ?? '₹';
      _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    }
  }

  /// Toggle dark mode
  Future<void> toggleDarkMode() async {
    try {
      _isDarkMode = !_isDarkMode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode);
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling dark mode: $e');
    }
  }

  /// Change currency
  Future<void> changeCurrency(String currency) async {
    try {
      _selectedCurrency = currency;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currencyKey, currency);
      notifyListeners();
    } catch (e) {
      debugPrint('Error changing currency: $e');
    }
  }

  /// Toggle notifications
  Future<void> toggleNotifications() async {
    try {
      _notificationsEnabled = !_notificationsEnabled;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationsKey, _notificationsEnabled);
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling notifications: $e');
    }
  }

  /// Get light theme
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6366F1),
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Get dark theme
  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6366F1),
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
