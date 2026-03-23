import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final downloadServiceProvider =
    Provider<DownloadService>((ref) => DownloadService());

class DownloadService {
  final Dio _dio = Dio();

  Future<String> getDownloadPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final audioDir = Directory('${directory.path}/audio_downloads');
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }
    return audioDir.path;
  }

  String getAudioFileName(int surahNumber, int ayahNumber, int reciterId) {
    return 's${surahNumber.toString().padLeft(3, '0')}_a${ayahNumber.toString().padLeft(3, '0')}_r$reciterId.mp3';
  }

  String getSurahFileName(int surahNumber, int reciterId) {
    return 'surah_${surahNumber.toString().padLeft(3, '0')}_r$reciterId.mp3';
  }

  Future<bool> isAudioDownloaded(
      int surahNumber, int ayahNumber, int reciterId) async {
    final path = await getDownloadPath();
    final fileName = getAudioFileName(surahNumber, ayahNumber, reciterId);
    final file = File('$path/$fileName');
    return await file.exists();
  }

  Future<bool> isSurahDownloaded(int surahNumber, int reciterId) async {
    final path = await getDownloadPath();
    final fileName = getSurahFileName(surahNumber, reciterId);
    final file = File('$path/$fileName');
    return await file.exists();
  }

  Future<String?> downloadAudio(
    String url,
    int surahNumber,
    int ayahNumber,
    int reciterId, {
    Function(double)? onProgress,
  }) async {
    try {
      final path = await getDownloadPath();
      final fileName = getAudioFileName(surahNumber, ayahNumber, reciterId);
      final filePath = '$path/$fileName';

      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            onProgress(received / total);
          }
        },
      );

      return filePath;
    } catch (e) {
      return null;
    }
  }

  Future<String?> downloadSurah(
    String url,
    int surahNumber,
    int reciterId, {
    Function(double)? onProgress,
  }) async {
    try {
      final path = await getDownloadPath();
      final fileName = getSurahFileName(surahNumber, reciterId);
      final filePath = '$path/$fileName';

      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            onProgress(received / total);
          }
        },
      );

      return filePath;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getLocalAudioPath(
      int surahNumber, int ayahNumber, int reciterId) async {
    final path = await getDownloadPath();
    final fileName = getAudioFileName(surahNumber, ayahNumber, reciterId);
    final file = File('$path/$fileName');

    if (await file.exists()) {
      return file.path;
    }

    // Check for full surah download
    final surahFileName = getSurahFileName(surahNumber, reciterId);
    final surahFile = File('$path/$surahFileName');

    if (await surahFile.exists()) {
      return surahFile.path;
    }

    return null;
  }

  Future<void> deleteDownloadedAudio(
      int surahNumber, int ayahNumber, int reciterId) async {
    final path = await getDownloadPath();
    final fileName = getAudioFileName(surahNumber, ayahNumber, reciterId);
    final file = File('$path/$fileName');

    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> deleteSurahAudio(int surahNumber, int reciterId) async {
    final path = await getDownloadPath();
    final fileName = getSurahFileName(surahNumber, reciterId);
    final file = File('$path/$fileName');

    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<List<Map<String, dynamic>>> getAllDownloads() async {
    final path = await getDownloadPath();
    final dir = Directory(path);

    if (!await dir.exists()) return [];

    final files = await dir.list().toList();
    return files.whereType<File>().map((file) {
      final name = file.path.split('/').last;
      final stat = file.statSync();
      return {
        'name': name,
        'path': file.path,
        'size': stat.size,
        'modified': stat.modified,
      };
    }).toList();
  }

  Future<int> getTotalDownloadSize() async {
    final downloads = await getAllDownloads();
    int totalSize = 0;
    for (var download in downloads) {
      totalSize += (download['size'] as int);
    }
    return totalSize;
  }

  Future<void> clearAllDownloads() async {
    final path = await getDownloadPath();
    final dir = Directory(path);

    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }
}
