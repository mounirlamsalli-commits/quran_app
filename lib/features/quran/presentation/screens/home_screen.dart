import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/surah_list_controller.dart';
import '../../../bookmarks/presentation/controllers/bookmarks_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('القرآن الكريم')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _ContinueReadingCard(),
          const SizedBox(height: 16),
          const _TodayAyahCard(),
          const SizedBox(height: 16),
          const _StatsRow(),
          const SizedBox(height: 16),
          _QuickAccessSurahs(),
        ],
      ),
    );
  }
}

class _ContinueReadingCard extends ConsumerWidget {
  const _ContinueReadingCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingBookmark = ref.watch(lastReadingBookmarkProvider);

    if (readingBookmark == null) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () =>
          context.go('${AppRoutes.surahList}/${readingBookmark.surahNumber}'),
      borderRadius: BorderRadius.circular(12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.play_circle_outline,
                    color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('استكمال القراءة',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                        'سورة ${readingBookmark.surahNumber} — الآية ${readingBookmark.ayahNumber}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodayAyahCard extends StatelessWidget {
  const _TodayAyahCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('آية اليوم',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: AppColors.primary)),
            const SizedBox(height: 14),
            const Text(
              'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
              style: TextStyle(
                  fontFamily: 'UthmanicHafs', fontSize: 24, height: 2),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text('سورة الشرح - الآية 6',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.secondary)),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _StatCard(
                icon: Icons.local_fire_department,
                value: '7',
                label: 'أيام متواصلة',
                color: AppColors.warning)),
        const SizedBox(width: 10),
        Expanded(
            child: _StatCard(
                icon: Icons.check_circle_outline,
                value: '12%',
                label: 'إتمام القرآن',
                color: AppColors.secondary)),
        const SizedBox(width: 10),
        Expanded(
            child: _StatCard(
                icon: Icons.access_time,
                value: '45 د',
                label: 'قراءة اليوم',
                color: AppColors.primary)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value, label;
  final Color color;
  const _StatCard(
      {required this.icon,
      required this.value,
      required this.label,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: color)),
            Text(label,
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _QuickAccessSurahs extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahListProvider);
    return surahsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (surahs) {
        final quick = surahs.take(10).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('سور مقترحة',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: AppColors.secondary)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: quick
                  .map((s) => GestureDetector(
                        onTap: () =>
                            context.go('${AppRoutes.surahList}/${s.number}'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.primary.withOpacity(0.2)),
                          ),
                          child: Text(s.nameArabic,
                              style: const TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 14,
                                  color: AppColors.primary)),
                        ),
                      ))
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}
