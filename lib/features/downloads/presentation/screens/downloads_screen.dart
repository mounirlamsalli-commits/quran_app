import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/repositories/download_repository_impl.dart';
import '../../domain/entities/download.dart';
import 'dart:async';

final downloadedSurahsProvider = FutureProvider<List<DownloadedSurah>>((ref) async {
  final repo = DownloadRepositoryImpl();
  final result = await repo.getDownloadedSurahs();
  return result.fold((failure) => [], (surahs) => surahs);
});

final downloadProgressProvider = StateProvider<DownloadProgress>((ref) => 
  const DownloadProgress(downloaded: 0, total: 0, percentage: 0, status: DownloadStatus.pending));

class DownloadsScreen extends ConsumerStatefulWidget {
  const DownloadsScreen({super.key});
  @override
  ConsumerState<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends ConsumerState<DownloadsScreen> {
  StreamSubscription<DownloadProgress>? _progressSubscription;

  @override
  void initState() {
    super.initState();
    _listenToProgress();
  }

  @override
  void dispose() {
    _progressSubscription?.cancel();
    super.dispose();
  }

  void _listenToProgress() {
    final repo = DownloadRepositoryImpl();
    _progressSubscription = repo.getDownloadProgress().listen((progress) {
      ref.read(downloadProgressProvider.notifier).state = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    final downloadedAsync = ref.watch(downloadedSurahsProvider);
    final progress = ref.watch(downloadProgressProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('التحميلات')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        if (progress.status != DownloadStatus.pending) _ProgressCard(progress: progress),
        const SizedBox(height: 16),
        _SectionHeader(title: 'تحميل سور جديدة'),
        _DownloadSurahsList(),
        const SizedBox(height: 24),
        _SectionHeader(title: 'السور المحملة'),
        downloadedAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('خطأ: $e')),
          data: (surahs) => surahs.isEmpty
              ? const Center(child: Padding(padding: EdgeInsets.all(32), child: Text('لا توجد سور محملة')))
              : _DownloadedSurahsList(surahs: surahs),
        ),
      ]),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final DownloadProgress progress;
  const _ProgressCard({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: progress.status == DownloadStatus.failed ? AppColors.error.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(children: [
            if (progress.status == DownloadStatus.downloading)
              const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
            if (progress.status == DownloadStatus.completed)
              const Icon(Icons.check_circle, color: AppColors.success, size: 24),
            if (progress.status == DownloadStatus.failed)
              const Icon(Icons.error, color: AppColors.error, size: 24),
            const SizedBox(width: 12),
            Expanded(child: Text(
              progress.status == DownloadStatus.downloading ? 'جاري التحميل... ${progress.percentage.toInt()}%'
                : progress.status == DownloadStatus.completed ? 'تم التحميل بنجاح'
                : 'فشل التحميل: ${progress.error ?? "خطأ غير معروف"}',
              style: Theme.of(context).textTheme.bodyMedium,
            )),
          ]),
          if (progress.status == DownloadStatus.downloading) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(value: progress.percentage / 100, color: AppColors.primary),
          ],
        ]),
      ),
    );
  }
}

class _DownloadSurahsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        final surahNumber = index + 1;
        final surahNames = ['الفاتحة', 'البقرة', 'آل عمران', 'النساء', 'المائدة', 'الأنعام', 'الأعراف', 'الأنفال', 'التوبة', 'يونس'];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Center(child: Text('${surahNumber}', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
            ),
            title: Text(surahNames[index]),
            subtitle: Text('سورة ${surahNumber}'),
            trailing: IconButton(
              icon: const Icon(Icons.download),
              onPressed: () => _showReciterDialog(context, ref, surahNumber),
            ),
          ),
        );
      },
    );
  }

  void _showReciterDialog(BuildContext context, WidgetRef ref, int surahNumber) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('اختر القارئ'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(children: AppConstants.reciters.entries.map((e) => ListTile(
            title: Text(e.value),
            trailing: const Icon(Icons.download),
            onTap: () {
              Navigator.pop(context);
              _startDownload(context, ref, surahNumber, e.key);
            },
          )).toList()),
        ),
      ),
    );
  }

  Future<void> _startDownload(BuildContext context, WidgetRef ref, int surahNumber, String reciterId) async {
    final repo = DownloadRepositoryImpl();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('بدء التحميل...')));
    await repo.downloadSurah(surahNumber, reciterId);
    ref.invalidate(downloadedSurahsProvider);
  }
}

class _DownloadedSurahsList extends ConsumerWidget {
  final List<DownloadedSurah> surahs;
  const _DownloadedSurahsList({required this.surahs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: surahs.length,
      itemBuilder: (context, index) {
        final surah = surahs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.offline_pin, color: AppColors.secondary),
            ),
            title: Text(surah.surahName),
            subtitle: Text('${surah.reciterName} • ${surah.sizeFormatted}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: () => _confirmDelete(context, ref, surah),
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, DownloadedSurah surah) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف السورة'),
        content: Text('هل تريد حذف ${surah.surahName} من التحميلات؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final repo = DownloadRepositoryImpl();
              await repo.deleteDownloadedSurah(surah.surahNumber);
              ref.invalidate(downloadedSurahsProvider);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary)),
  );
  }
}