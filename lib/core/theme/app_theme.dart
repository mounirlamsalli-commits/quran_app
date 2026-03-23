import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary:        AppColors.primary,
      secondary:      AppColors.secondary,
      surface:        AppColors.surfaceLight,
      background:     AppColors.backgroundLight,
      error:          AppColors.error,
      onPrimary:      Colors.white,
      onSecondary:    Colors.white,
      onSurface:      AppColors.onSurfaceLight,
      onBackground:   AppColors.onBackgroundLight,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    textTheme: AppTextStyles.textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      centerTitle: true,
      titleTextStyle: AppTextStyles.textTheme.titleMedium?.copyWith(
        color: AppColors.onBackgroundLight,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: AppColors.onBackgroundLight),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.backgroundLight,
      indicatorColor: AppColors.primaryLight,
      labelTextStyle: WidgetStateProperty.all(
        AppTextStyles.textTheme.labelSmall,
      ),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.dividerLight, thickness: 0.5),
    cardTheme: CardThemeData(
      color: AppColors.surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.dividerLight, width: 0.5),
      ),
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary:        AppColors.primary,
      secondary:      AppColors.secondary,
      surface:        AppColors.surfaceDark,
      background:     AppColors.backgroundDark,
      error:          AppColors.error,
      onPrimary:      AppColors.backgroundDark,
      onSecondary:    AppColors.backgroundDark,
      onSurface:      AppColors.onSurfaceDark,
      onBackground:   AppColors.onBackgroundDark,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: AppTextStyles.textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      centerTitle: true,
      titleTextStyle: AppTextStyles.textTheme.titleMedium?.copyWith(
        color: AppColors.onBackgroundDark,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: AppColors.onBackgroundDark),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      indicatorColor: AppColors.primaryDark,
      labelTextStyle: WidgetStateProperty.all(
        AppTextStyles.textTheme.labelSmall,
      ),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.dividerDark, thickness: 0.5),
    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.dividerDark, width: 0.5),
      ),
    ),
  );
}
