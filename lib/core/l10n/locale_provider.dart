import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../debug/debug_logger.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) { _load(); }
  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final v = prefs.getString(AppConstants.keyThemeMode);
      if (v == 'light') state = ThemeMode.light;
      else if (v == 'dark') state = ThemeMode.dark;

      // #region agent log
      DebugLogger.log(
        runId: 'pre',
        hypothesisId: 'H5',
        location: 'lib/core/l10n/locale_provider.dart:ThemeModeNotifier._load',
        message: 'ThemeMode loaded',
        data: {'storedValue': v, 'finalThemeMode': state.name},
      );
      // #endregion
    } catch (e) {
      // #region agent log
      DebugLogger.log(
        runId: 'pre',
        hypothesisId: 'H5',
        location: 'lib/core/l10n/locale_provider.dart:ThemeModeNotifier._load',
        message: 'ThemeMode load failed',
        data: {'error': e.toString()},
      );
      // #endregion
    }
  }
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyThemeMode, mode.name);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('ar')) { _load(); }
  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(AppConstants.keyLocale);
      if (code != null) state = Locale(code);

      // #region agent log
      DebugLogger.log(
        runId: 'pre',
        hypothesisId: 'H5',
        location: 'lib/core/l10n/locale_provider.dart:LocaleNotifier._load',
        message: 'Locale loaded',
        data: {'storedValue': code, 'finalLocale': state.languageCode},
      );
      // #endregion
    } catch (e) {
      // #region agent log
      DebugLogger.log(
        runId: 'pre',
        hypothesisId: 'H5',
        location: 'lib/core/l10n/locale_provider.dart:LocaleNotifier._load',
        message: 'Locale load failed',
        data: {'error': e.toString()},
      );
      // #endregion
    }
  }
  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyLocale, locale.languageCode);
  }
}