import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/reading_stats.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});
  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إحصائيات القراءة')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _WeeklyStreakCard(),
        const SizedBox(height: 16),
        _OverallProgressCard(),
        const SizedBox(height: 16),
        _WeeklyChartCard(),
        const SizedBox(height: 16),
        _DetailedStatsCard(),
        const SizedBox(height: 16),
        _JuzProgressCard(),
      ]),
    );
  }
}

class _WeeklyStreakCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('سلسلة الأيام', style: Theme.of(context).textTheme.titleMedium),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
              child: Row(children: [
                Icon(Icons.local_fire_department, color: AppColors.warning, size: 20),
                const SizedBox(width: 4),
                Text('7 أيام', style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold)),
              ]),
            ),
          ]),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(7, (i) {
            final isRead = i < 5;
            final day = ['س', 'ح', 'ن', 'ث', 'ر', 'خ', 'ج'][i];
            return Column(children: [
              Text(day, style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 4),
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isRead ? AppColors.secondary : AppColors.dividerLight,
                ),
                child: Icon(isRead ? Icons.check : Icons.close, size: 16, color: Colors.white),
              ),
            ]);
          })),
        ]),
      ),
    );
  }
}

class _OverallProgressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('نسبة إتمام القرآن', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                LinearProgressIndicator(value: 0.62, color: AppColors.primary, backgroundColor: AppColors.primary.withOpacity(0.2)),
                const SizedBox(height: 8),
                Text('62%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
                Text('من القرآن الكريم', style: Theme.of(context).textTheme.labelSmall),
              ]),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 80, height: 80,
              child: CircularProgressIndicator(value: 0.62, strokeWidth: 8, color: AppColors.primary, backgroundColor: AppColors.primary.withOpacity(0.2)),
            ),
          ]),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _StatMini(label: 'الأجزاء', value: '19/30'),
            _StatMini(label: 'الأحزاب', value: '38/60'),
            _StatMini(label: 'السور', value: '89/114'),
          ]),
        ]),
      ),
    );
  }
}

class _StatMini extends StatelessWidget {
  final String label, value;
  const _StatMini({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary)),
      Text(label, style: Theme.of(context).textTheme.labelSmall),
    ]);
  }
}

class _WeeklyChartCard extends StatelessWidget {
  final List<int> weeklyMinutes = const [25, 40, 30, 55, 20, 45, 35];
  final List<String> days = const ['س', 'ح', 'ن', 'ث', 'ر', 'خ', 'ج'];

  @override
  Widget build(BuildContext context) {
    final maxVal = weeklyMinutes.reduce((a, b) => a > b ? a : b).toDouble();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('وقت القراءة الأسبوعي (دقائق)', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          SizedBox(height: 150, child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(7, (i) {
            final height = (weeklyMinutes[i] / maxVal) * 120;
            return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text('${weeklyMinutes[i]}', style: TextStyle(fontSize: 10, color: AppColors.primary)),
              const SizedBox(height: 2),
              Container(
                width: 24, height: height,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                ),
              ),
              const SizedBox(height: 4),
              Text(days[i], style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
            ]);
          }))),
        ]),
      ),
    );
  }
}

class _DetailedStatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('إحصائيات مفصلة', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          _StatRow(icon: Icons.auto_stories, label: 'إجمالي الآيات المقروءة', value: '3,862 آية'),
          const Divider(height: 24),
          _StatRow(icon: Icons.schedule, label: 'إجمالي وقت القراءة', value: '45 ساعة'),
          const Divider(height: 24),
          _StatRow(icon: Icons.calendar_today, label: 'أيام القراءة هذا الشهر', value: '18 يوم'),
          const Divider(height: 24),
          _StatRow(icon: Icons.play_circle_outline, label: 'وقت الاستماع', value: '12 ساعة'),
          const Divider(height: 24),
          _StatRow(icon: Icons.bookmark_outline, label: 'الإشارات المرجعية', value: '25'),
        ]),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _StatRow({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      const SizedBox(width: 16),
      Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
      Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary)),
    ]);
  }
}

class _JuzProgressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('تقدم الأجزاء', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: List.generate(30, (i) {
            final completed = i < 19;
            final inProgress = i == 19;
            return Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: completed ? AppColors.secondary : inProgress ? AppColors.primary.withOpacity(0.3) : AppColors.dividerLight,
              ),
              child: Center(child: Text('${i + 1}', style: TextStyle(
                color: completed || inProgress ? Colors.white : AppColors.onSurfaceLight.withOpacity(0.5),
                fontWeight: FontWeight.bold,
              ))),
            );
          })),
        ]),
      ),
    );
  }
}