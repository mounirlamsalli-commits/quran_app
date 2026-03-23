import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  // خط واجهة التطبيق
  static const String _uiFont     = 'Amiri';
  // خط نص القرآن
  static const String quranFont   = 'UthmanicHafs';

  static TextTheme get textTheme => const TextTheme(
    displayLarge:  TextStyle(fontFamily: _uiFont, fontSize: 32, fontWeight: FontWeight.w400),
    displayMedium: TextStyle(fontFamily: _uiFont, fontSize: 28, fontWeight: FontWeight.w400),
    headlineLarge: TextStyle(fontFamily: _uiFont, fontSize: 24, fontWeight: FontWeight.w600),
    headlineMedium:TextStyle(fontFamily: _uiFont, fontSize: 20, fontWeight: FontWeight.w600),
    titleLarge:    TextStyle(fontFamily: _uiFont, fontSize: 18, fontWeight: FontWeight.w600),
    titleMedium:   TextStyle(fontFamily: _uiFont, fontSize: 16, fontWeight: FontWeight.w500),
    titleSmall:    TextStyle(fontFamily: _uiFont, fontSize: 14, fontWeight: FontWeight.w500),
    bodyLarge:     TextStyle(fontFamily: _uiFont, fontSize: 16, fontWeight: FontWeight.w400, height: 1.7),
    bodyMedium:    TextStyle(fontFamily: _uiFont, fontSize: 14, fontWeight: FontWeight.w400, height: 1.6),
    bodySmall:     TextStyle(fontFamily: _uiFont, fontSize: 12, fontWeight: FontWeight.w400),
    labelLarge:    TextStyle(fontFamily: _uiFont, fontSize: 14, fontWeight: FontWeight.w500),
    labelMedium:   TextStyle(fontFamily: _uiFont, fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall:    TextStyle(fontFamily: _uiFont, fontSize: 10, fontWeight: FontWeight.w400),
  );

  // أحجام خط القرآن المتاحة
  static const List<double> quranFontSizes = [18, 20, 22, 24, 26, 28, 32];
  static const double defaultQuranFontSize = 22;
}
