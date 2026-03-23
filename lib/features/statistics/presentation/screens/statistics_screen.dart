import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إحصائيات القراءة')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StatCard(label: 'سلسلة الأيام', value: '7 أيام', icon: Icons.local_fire_department, color: AppColors.warning),
          const SizedBox(height: 12),
          _StatCard(label: 'إتمام القرآن', value: '12%', icon: Icons.check_circle_outline, color: AppColors.secondary),
          const SizedBox(height: 12),
          _StatCard(label: 'إجمالي الآيات', value: '748 آية', icon: Icons.auto_stories, color: AppColors.primary),
          const SizedBox(height: 12),
          _StatCard(label: 'وقت القراءة اليوم', value: '45 دقيقة', icon: Icons.access_time, color: AppColors.info),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodyMedium),
                Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color)),
              ],
            )),
          ],
        ),
      ),
    );
  }
}