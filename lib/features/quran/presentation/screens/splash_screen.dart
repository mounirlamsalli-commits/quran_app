import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/debug/debug_logger.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    // #region agent log
    DebugLogger.log(
      runId: 'pre',
      hypothesisId: 'H7',
      location: 'lib/features/quran/presentation/screens/splash_screen.dart:initState',
      message: 'Splash initState entered',
    );
    // #endregion

    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
    Future.delayed(const Duration(seconds: 2), () {
      // #region agent log
      DebugLogger.log(
        runId: 'pre',
        hypothesisId: 'H7',
        location: 'lib/features/quran/presentation/screens/splash_screen.dart:delayedGo',
        message: 'Splash delayed callback fired',
        data: {'mounted': mounted},
      );
      // #endregion

      if (!mounted) return;
      try {
        context.go(AppRoutes.home);
        // #region agent log
        DebugLogger.log(
          runId: 'pre',
          hypothesisId: 'H7',
          location: 'lib/features/quran/presentation/screens/splash_screen.dart:delayedGo',
          message: 'Splash navigation to home called',
        );
        // #endregion
      } catch (e) {
        // #region agent log
        DebugLogger.log(
          runId: 'pre',
          hypothesisId: 'H7',
          location: 'lib/features/quran/presentation/screens/splash_screen.dart:delayedGo',
          message: 'Splash navigation failed',
          data: {'error': e.toString()},
        );
        // #endregion
        rethrow;
      }
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                style: TextStyle(
                  fontFamily: 'UthmanicHafs',
                  fontSize: 26,
                  color: AppColors.primary,
                  height: 2,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: const Icon(Icons.menu_book, size: 40, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              Text(
                'القرآن الكريم',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onBackgroundLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}