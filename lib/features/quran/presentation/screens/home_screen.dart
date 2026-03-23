import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('القرآن الكريم')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _ContinueReadingCard(),
          SizedBox(height: 16),
          _TodayAyahCard(),
          SizedBox(height: 16),
          _StatsRow(),
        ],
      ),
    );
  }
}

class _ContinueReadingCard extends StatelessWidget {
  const _ContinueReadingCard();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.play_circle_outline, color: AppColors.primary),
                Text('استكمال القراءة',
                  style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 8),
            Text('سورة البقرة — الآية 255',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
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
      color: AppColors.primary.withOpacity(0.06),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('آية اليوم', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.primary)),
            const SizedBox(height: 12),
            Text(
              'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
              style: TextStyle(fontFamily: 'UthmanicHafs', fontSize: 22, height: 2),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text('سورة الشرح - الآية 6', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.secondary)),
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
        Expanded(child: _StatCard(icon: Icons.local_fire_department, value: '7', label: 'أيام متواصلة', color: AppColors.warning)),
        const SizedBox(width: 12),
        Expanded(child: _StatCard(icon: Icons.check_circle_outline, value: '12%', label: 'إتمام القرآن', color: AppColors.secondary)),
        const SizedBox(width: 12),
        Expanded(child: _StatCard(icon: Icons.access_time, value: '45 د', label: 'قراءة اليوم', color: AppColors.primary)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _StatCard({required this.icon, required this.value, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color)),
            Text(label, style: Theme.of(context).textTheme.labelSmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}