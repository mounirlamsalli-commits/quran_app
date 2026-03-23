import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/download_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../quran/presentation/providers/download_provider.dart';

class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadsAsync = ref.watch(downloadsListProvider);
    final totalSizeAsync = ref.watch(downloadSizeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('التحميلات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => _showClearAllDialog(context, ref),
            tooltip: 'مسح الكل',
          ),
        ],
      ),
      body: downloadsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (downloads) {
          if (downloads.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد ملفات محملة',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'قم بتحميل الملفات الصوتية أثناء الاتصال بالإنترنت',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.storage, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'إجمالي المساحة المستخدمة',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          totalSizeAsync.when(
                            data: (size) => Text(
                              _formatFileSize(size),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            loading: () => const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            error: (_, __) => const Text('--'),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${downloads.length} ملف',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: downloads.length,
                  itemBuilder: (context, index) {
                    final download = downloads[index];
                    final fileName = download['name'] as String;
                    final size = download['size'] as int;
                    final modified = download['modified'] as DateTime;

                    // Parse file name to get surah and ayah info
                    final parts = _parseFileName(fileName);

                    return Dismissible(
                      key: Key(fileName),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) async {
                        final file = File(download['path'] as String);
                        if (await file.exists()) {
                          await file.delete();
                        }
                        ref.invalidate(downloadsListProvider);
                        ref.invalidate(downloadSizeProvider);
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Icon(
                            Icons.audio_file,
                            color: AppColors.primary,
                          ),
                        ),
                        title: Text(
                          parts['isSurah'] == true
                              ? 'سورة ${parts['surah']}'
                              : 'آية ${parts['ayah']} من سورة ${parts['surah']}',
                        ),
                        subtitle: Text(
                          '${_formatFileSize(size)} • ${_formatDate(modified)}',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.play_circle_outline),
                          onPressed: () => _playDownloadedAudio(
                              context, download['path'] as String),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Map<String, dynamic> _parseFileName(String fileName) {
    // Format: s001_a001_r1.mp3 or surah_001_r1.mp3
    final result = <String, dynamic>{
      'surah': 0,
      'ayah': 0,
      'isSurah': false,
    };

    if (fileName.startsWith('s')) {
      // Single ayah file
      final match = RegExp(r's(\d+)_a(\d+)_r(\d+)\.mp3').firstMatch(fileName);
      if (match != null) {
        result['surah'] = int.tryParse(match.group(1)!) ?? 0;
        result['ayah'] = int.tryParse(match.group(2)!) ?? 0;
        result['isSurah'] = false;
      }
    } else if (fileName.startsWith('surah')) {
      // Full surah file
      final match = RegExp(r'surah_(\d+)_r(\d+)\.mp3').firstMatch(fileName);
      if (match != null) {
        result['surah'] = int.tryParse(match.group(1)!) ?? 0;
        result['isSurah'] = true;
      }
    }

    return result;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showClearAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('مسح جميع التحميلات'),
        content: const Text('هل أنت متأكد من حذف جميع الملفات المحملة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              final service = ref.read(downloadServiceProvider);
              await service.clearAllDownloads();
              ref.invalidate(downloadsListProvider);
              ref.invalidate(downloadSizeProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('مسح', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _playDownloadedAudio(BuildContext context, String filePath) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم تشغيل الملف...')),
    );
  }
}
