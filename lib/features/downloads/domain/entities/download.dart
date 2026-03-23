import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

class DownloadProgress {
  final int downloaded;
  final int total;
  final double percentage;
  final DownloadStatus status;
  final String? error;

  const DownloadProgress({
    required this.downloaded,
    required this.total,
    required this.percentage,
    required this.status,
    this.error,
  });

  bool get isComplete => status == DownloadStatus.completed;
  bool get isFailed => status == DownloadStatus.failed;
  bool get isDownloading => status == DownloadStatus.downloading;
}

enum DownloadStatus { pending, downloading, completed, failed }

abstract class DownloadRepository {
  Future<Either<Failure, List<DownloadedSurah>>> getDownloadedSurahs();
  Future<Either<Failure, void>> downloadSurah(int surahNumber, String reciterId);
  Future<Either<Failure, void>> deleteDownloadedSurah(int surahNumber);
  Future<Either<Failure, bool>> isSurahDownloaded(int surahNumber);
  Stream<DownloadProgress> getDownloadProgress();
  Future<Either<Failure, void>> cancelDownload();
  Future<Either<Failure, int>> getTotalDownloadSize();
}

class DownloadedSurah {
  final int surahNumber;
  final String surahName;
  final int ayahCount;
  final String reciterId;
  final String reciterName;
  final int sizeInBytes;
  final DateTime downloadedAt;

  const DownloadedSurah({
    required this.surahNumber,
    required this.surahName,
    required this.ayahCount,
    required this.reciterId,
    required this.reciterName,
    required this.sizeInBytes,
    required this.downloadedAt,
  });

  String get sizeFormatted {
    if (sizeInBytes < 1024) return '$sizeInBytes B';
    if (sizeInBytes < 1024 * 1024) return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}