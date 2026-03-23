import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/di/injection.dart';
import 'core/l10n/locale_provider.dart';
import 'core/debug/debug_logger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n/app_localizations.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    // #region agent log
    DebugLogger.log(
      runId: 'pre',
      hypothesisId: 'H6',
      location: 'lib/main.dart:FlutterError.onError',
      message: 'Flutter framework error',
      data: {'exception': details.exceptionAsString()},
    );
    // #endregion
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    // #region agent log
    DebugLogger.log(
      runId: 'pre',
      hypothesisId: 'H6',
      location: 'lib/main.dart:PlatformDispatcher.onError',
      message: 'Uncaught async error',
      data: {'error': error.toString()},
    );
    // #endregion
    return false;
  };

  // #region agent log
  DebugLogger.log(
    runId: 'pre',
    hypothesisId: 'H0',
    location: 'lib/main.dart:main',
    message: 'main() entered',
    data: {'cwd': Directory.current.path},
  );
  // #endregion

  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Hive.initFlutter();
    // #region agent log
    DebugLogger.log(
      runId: 'pre',
      hypothesisId: 'H1',
      location: 'lib/main.dart:main',
      message: 'Hive.initFlutter succeeded',
    );
    // #endregion
  } catch (e) {
    // #region agent log
    DebugLogger.log(
      runId: 'pre',
      hypothesisId: 'H1',
      location: 'lib/main.dart:main',
      message: 'Hive.initFlutter failed',
      data: {'error': e.toString()},
    );
    // #endregion
    rethrow;
  }

  try {
    await configureDependencies();
    // #region agent log
    DebugLogger.log(
      runId: 'pre',
      hypothesisId: 'H2',
      location: 'lib/main.dart:main',
      message: 'configureDependencies succeeded',
    );
    // #endregion
  } catch (e) {
    // #region agent log
    DebugLogger.log(
      runId: 'pre',
      hypothesisId: 'H2',
      location: 'lib/main.dart:main',
      message: 'configureDependencies failed',
      data: {'error': e.toString()},
    );
    // #endregion
    rethrow;
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // #region agent log
  DebugLogger.log(
    runId: 'pre',
    hypothesisId: 'H3',
    location: 'lib/main.dart:main',
    message: 'calling runApp(QuranApp)',
  );
  // #endregion
  runApp(const ProviderScope(child: QuranApp()));
}

class QuranApp extends ConsumerWidget {
  static bool _didLogFirstBuild = false;
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale   = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final router   = ref.watch(appRouterProvider);

    if (!_didLogFirstBuild) {
      _didLogFirstBuild = true;
      // #region agent log
      DebugLogger.log(
        runId: 'pre',
        hypothesisId: 'H4',
        location: 'lib/main.dart:QuranApp.build',
        message: 'QuranApp first build',
        data: {
          'locale': locale.languageCode,
          'themeMode': themeMode.name,
          'routerType': router.runtimeType.toString(),
        },
      );
      // #endregion
    }

    return MaterialApp.router(
      title: 'القرآن الكريم',
      locale: locale,
      themeMode: themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
      supportedLocales: const [
        Locale('ar'), Locale('en'), Locale('fr'), Locale('zh'), Locale('zgh'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
