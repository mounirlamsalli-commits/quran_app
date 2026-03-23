import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';

extension ContextExtensions on BuildContext {
  AppLocalizations get l10n    => AppLocalizations.of(this);
  ThemeData        get theme   => Theme.of(this);
  ColorScheme      get colors  => Theme.of(this).colorScheme;
  TextTheme        get texts   => Theme.of(this).textTheme;
  Size             get size    => MediaQuery.sizeOf(this);
  bool             get isRTL   => Directionality.of(this) == TextDirection.rtl;
  bool             get isDark  => Theme.of(this).brightness == Brightness.dark;
}
