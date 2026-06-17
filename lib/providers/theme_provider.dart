import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'isDarkMode';
  static const String _currencyKey = 'selectedCurrency';
  static const String _notificationsKey = 'notificationsEnabled';

  // Dark mode ON by default — matches the Finance AI brand aesthetic
  bool _isDarkMode = true;
  String _selectedCurrency = '₹';
  bool _notificationsEnabled = true;

  bool get isDarkMode => _isDarkMode;
  String get selectedCurrency => _selectedCurrency;
  bool get notificationsEnabled => _notificationsEnabled;

  ThemeProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_themeKey) ?? true;
      _selectedCurrency = prefs.getString(_currencyKey) ?? '₹';
      _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    }
  }

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

  // ─── DARK THEME ────────────────────────────────────────────────────────────
  static ThemeData getDarkTheme() {
    const Color bg = Color(0xFF050D1F);
    const Color surface = Color(0xFF091428);
    const Color card = Color(0xFF0D1E3C);
    const Color primary = Color(0xFF2979FF);
    const Color secondary = Color(0xFF00E5FF);
    const Color border = Color(0xFF1A3A6B);
    const Color textPrimary = Color(0xFFFFFFFF);
    const Color textSecondary = Color(0xFF8BA3C9);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        background: bg,
        surface: surface,
        primary: primary,
        secondary: secondary,
        tertiary: Color(0xFFFFB300),
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: textPrimary,
        surfaceVariant: card,
        onSurfaceVariant: textSecondary,
        outline: border,
        error: Color(0xFFFF1744),
        onError: Colors.white,
        primaryContainer: Color(0xFF0D2552),
        onPrimaryContainer: Color(0xFF82B1FF),
        secondaryContainer: Color(0xFF003B4D),
        onSecondaryContainer: Color(0xFF80DEEA),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: textPrimary),
        actionsIconTheme: IconThemeData(color: textSecondary),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: Color(0xFF4A6080)),
        prefixIconColor: primary,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFF1744)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFF1744), width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primary.withOpacity(0.18),
        iconTheme: MaterialStateProperty.all(
          const IconThemeData(color: textSecondary),
        ),
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(color: textSecondary, fontSize: 12),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? primary
              : textSecondary,
        ),
        trackColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? primary.withOpacity(0.3)
              : border,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected) ? primary : null,
        ),
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 1),
      listTileTheme: const ListTileThemeData(
        textColor: textPrimary,
        iconColor: textSecondary,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface,
        modalBackgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(color: textSecondary, fontSize: 14),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimary),
        displayMedium: TextStyle(color: textPrimary),
        displaySmall: TextStyle(color: textPrimary),
        headlineLarge: TextStyle(color: textPrimary),
        headlineMedium: TextStyle(color: textPrimary),
        headlineSmall:
            TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        titleLarge:
            TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        titleMedium:
            TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        titleSmall:
            TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: Color(0xFFD0E0F0)),
        bodyMedium: TextStyle(color: Color(0xFFD0E0F0)),
        bodySmall: TextStyle(color: textSecondary),
        labelLarge: TextStyle(
            color: Color(0xFFD0E0F0), fontWeight: FontWeight.w600),
        labelMedium: TextStyle(color: textSecondary),
        labelSmall: TextStyle(color: textSecondary, fontSize: 11),
      ),
    );
  }

  // ─── LIGHT THEME ───────────────────────────────────────────────────────────
  static ThemeData getLightTheme() {
    const Color primary = Color(0xFF2979FF);
    const Color secondary = Color(0xFF00BCD4);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        secondary: secondary,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFF1744)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFF1744), width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
