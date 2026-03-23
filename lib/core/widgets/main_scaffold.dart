import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.path;
    if (loc.startsWith(AppRoutes.home))       return 0;
    if (loc.startsWith(AppRoutes.surahList))  return 1;
    if (loc.startsWith(AppRoutes.search))     return 2;
    if (loc.startsWith(AppRoutes.bookmarks))  return 3;
    if (loc.startsWith(AppRoutes.settings))   return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex(context),
        onDestinationSelected: (i) {
          switch (i) {
            case 0: context.go(AppRoutes.home);
            case 1: context.go(AppRoutes.surahList);
            case 2: context.go(AppRoutes.search);
            case 3: context.go(AppRoutes.bookmarks);
            case 4: context.go(AppRoutes.settings);
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined),     selectedIcon: Icon(Icons.home),      label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'القرآن'),
          NavigationDestination(icon: Icon(Icons.search_outlined),    selectedIcon: Icon(Icons.search),    label: 'البحث'),
          NavigationDestination(icon: Icon(Icons.bookmark_outline),   selectedIcon: Icon(Icons.bookmark),  label: 'الإشارات'),
          NavigationDestination(icon: Icon(Icons.settings_outlined),  selectedIcon: Icon(Icons.settings),  label: 'الإعدادات'),
        ],
      ),
    );
  }
}