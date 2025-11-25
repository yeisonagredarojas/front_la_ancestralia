import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Modo de tema personalizado
enum AppThemeMode {
  light,
  dark,
  background,
}

class SettingsProvider extends ChangeNotifier {
  Locale _locale = const Locale('es', '');
  AppThemeMode _themeMode = AppThemeMode.light;

  Locale get locale => _locale;
  AppThemeMode get themeMode => _themeMode;

  SettingsProvider() {
    _loadSettings();
  }

  /// Carga los ajustes guardados (idioma y tema)
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Cargar idioma (por defecto español)
    final languageCode = prefs.getString('language_code') ?? 'es';
    _locale = Locale(languageCode, '');

    // Cargar tema (por defecto claro)
    final themeModeString = prefs.getString('theme_mode') ?? 'light';
    _themeMode = AppThemeMode.values.firstWhere(
      (e) => e.toString() == 'AppThemeMode.$themeModeString',
      orElse: () => AppThemeMode.light,
    );

    notifyListeners();
  }

  /// Cambiar el idioma de la app
  // Future<void> changeLocale(String languageCode) async {
  //   _locale = Locale(languageCode, '');
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('language_code', languageCode);
  //   notifyListeners();
  // }

  Future<void> changeLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    
    _locale = Locale(languageCode, '');
    notifyListeners();
    
    print('💾 Idioma guardado en SettingsProvider');
    print('🔑 Clave: language_code');
    print('📝 Valor: $languageCode');
  }


  /// Cambiar el modo de tema
  Future<void> changeTheme(AppThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.toString().split('.').last);
    notifyListeners();
  }

  /// Obtiene el tema actual según la configuración
  ThemeData getThemeData() {
    switch (_themeMode) {
      case AppThemeMode.light:
        return _lightTheme();
      case AppThemeMode.dark:
        return _darkTheme();
      case AppThemeMode.background:
        return _backgroundTheme();
    }
  }

  // 🔆 Tema claro
  ThemeData _lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.grey[50],
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
      ),
    );
  }

  // 🌙 Tema oscuro
  ThemeData _darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        color: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
      ),
    );
  }

  // 🌌 Tema transparente con fondo de imagen o video
  ThemeData _backgroundTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.indigo.withOpacity(0.8),
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 8,
        color: Colors.black.withOpacity(0.6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.black.withOpacity(0.5),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
      ),
    );
  }
}
