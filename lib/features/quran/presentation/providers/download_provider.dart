import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/download_service.dart';

final downloadProvider =
    StateNotifierProvider<DownloadNotifier, AsyncValue<Map<String, dynamic>>>(
  (ref) => DownloadNotifier(ref.read(downloadServiceProvider)),
);

final downloadsListProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.read(downloadServiceProvider);
  return await service.getAllDownloads();
});

final downloadSizeProvider = FutureProvider<int>((ref) async {
  final service = ref.read(downloadServiceProvider);
  return await service.getTotalDownloadSize();
});

class DownloadNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final DownloadService _service;

  DownloadNotifier(this._service) : super(const AsyncValue.data({}));

  Future<bool> downloadAyah(
      int surahNumber, int ayahNumber, int reciterId, String url) async {
    state = const AsyncValue.loading();

    try {
      final path = await _service.downloadAudio(
        url,
        surahNumber,
        ayahNumber,
        reciterId,
        onProgress: (progress) {
          state = AsyncValue.data({
            'progress': progress,
            'type': 'ayah',
            'surah': surahNumber,
            'ayah': ayahNumber,
          });
        },
      );

      if (path != null) {
        state = const AsyncValue.data({'complete': true});
        return true;
      }
      state = AsyncValue.error('Failed to download', StackTrace.current);
      return false;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> downloadSurah(int surahNumber, int reciterId, String url) async {
    state = const AsyncValue.loading();

    try {
      final path = await _service.downloadSurah(
        url,
        surahNumber,
        reciterId,
        onProgress: (progress) {
          state = AsyncValue.data({
            'progress': progress,
            'type': 'surah',
            'surah': surahNumber,
          });
        },
      );

      if (path != null) {
        state = const AsyncValue.data({'complete': true});
        return true;
      }
      state = AsyncValue.error('Failed to download', StackTrace.current);
      return false;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<void> deleteAyah(
      int surahNumber, int ayahNumber, int reciterId) async {
    await _service.deleteDownloadedAudio(surahNumber, ayahNumber, reciterId);
  }

  Future<void> deleteSurah(int surahNumber, int reciterId) async {
    await _service.deleteSurahAudio(surahNumber, reciterId);
  }

  Future<void> clearAllDownloads() async {
    await _service.clearAllDownloads();
  }

  Future<String?> getLocalPath(
      int surahNumber, int ayahNumber, int reciterId) async {
    return await _service.getLocalAudioPath(surahNumber, ayahNumber, reciterId);
  }

  Future<bool> isDownloaded(
      int surahNumber, int ayahNumber, int reciterId) async {
    return await _service.isAudioDownloaded(surahNumber, ayahNumber, reciterId);
  }
}
