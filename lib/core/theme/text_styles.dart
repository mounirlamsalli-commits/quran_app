import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle quranText({double fontSize = 22, Color? color}) => TextStyle(
    fontFamily: 'UthmanicHafs',
    fontSize: fontSize,
    color: color ?? AppColors.primary,
    height: 2.0,
    letterSpacing: 0.5,
  );

  static const TextStyle heading1 = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
  static const TextStyle heading2 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  static const TextStyle heading3 = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static const TextStyle body     = TextStyle(fontSize: 14, height: 1.6);
  static TextStyle caption(BuildContext context) => TextStyle(
    fontSize: 12, 
    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
  );
  static const TextStyle surahName = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w700,
    fontFamily: 'UthmanicHafs',
  );
}
