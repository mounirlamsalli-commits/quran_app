import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/quran/presentation/screens/splash_screen.dart';
import '../../features/quran/presentation/screens/home_screen.dart';
import '../../features/quran/presentation/screens/surah_list_screen.dart';
import '../../features/quran/presentation/screens/reader_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/bookmarks/presentation/screens/bookmarks_screen.dart';
import '../../features/statistics/presentation/screens/statistics_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../widgets/main_scaffold.dart';

class AppRoutes {
  static const splash     = '/';
  static const home       = '/home';
  static const surahList  = '/quran';
  static const reader     = '/quran/:surahNumber';
  static const search     = '/search';
  static const bookmarks  = '/bookmarks';
  static const statistics = '/statistics';
  static const settings   = '/settings';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(path: AppRoutes.splash,    builder: (_, __) => const SplashScreen()),
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(path: AppRoutes.home,       builder: (_, __) => const HomeScreen()),
          GoRoute(path: AppRoutes.surahList,  builder: (_, __) => const SurahListScreen()),
          GoRoute(
            path: AppRoutes.reader,
            builder: (_, state) => ReaderScreen(
              surahNumber: int.parse(state.pathParameters['surahNumber'] ?? '1'),
            ),
          ),
          GoRoute(path: AppRoutes.search,     builder: (_, __) => const SearchScreen()),
          GoRoute(path: AppRoutes.bookmarks,  builder: (_, __) => const BookmarksScreen()),
          GoRoute(path: AppRoutes.statistics, builder: (_, __) => const StatisticsScreen()),
          GoRoute(path: AppRoutes.settings,   builder: (_, __) => const SettingsScreen()),
        ],
      ),
    ],
  );
});
