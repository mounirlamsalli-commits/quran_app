import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/download.dart';

@LazySingleton(as: DownloadRepository)
class DownloadRepositoryImpl implements DownloadRepository {
  final Dio _dio;
  late Box<Map> _box;
  CancelToken? _cancelToken;
  final StreamController<DownloadProgress> _progressController = StreamController<DownloadProgress>.broadcast();

  DownloadRepositoryImpl() : _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(minutes: 10),
  ));

  Future<void> _init() async {
    _box = await Hive.openBox<Map>(AppConstants.downloadedBox);
  }

  @override
  Future<Either<Failure, List<DownloadedSurah>>> getDownloadedSurahs() async {
    try {
      await _init();
      final surahs = _box.values.map((e) {
        final map = Map<String, dynamic>.from(e);
        return DownloadedSurah(
          surahNumber: map['surahNumber'],
          surahName: map['surahName'],
          ayahCount: map['ayahCount'],
          reciterId: map['reciterId'],
          reciterName: map['reciterName'],
          sizeInBytes: map['sizeInBytes'],
          downloadedAt: DateTime.parse(map['downloadedAt']),
        );
      }).toList();
      return Right(surahs);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> downloadSurah(int surahNumber, String reciterId) async {
    try {
      await _init();
      _cancelToken = CancelToken();
      
      final directory = await getApplicationDocumentsDirectory();
      final surahDir = Directory('${directory.path}/audio/$reciterId');
      if (!await surahDir.exists()) await surahDir.create(recursive: true);

      final surahNames = ['الفاتحة', 'البقرة', 'آل عمران', 'النساء', 'المائدة'];
      final ayahCounts = [7, 286, 200, 176, 120];
      final ayahCount = ayahCounts.length > surahNumber - 1 ? ayahCounts[surahNumber - 1] : 100;
      var totalSize = 0;

      for (var ayah = 1; ayah <= ayahCount; ayah++) {
        if (_cancelToken!.isCancelled) break;
        
        final url = 'https://verses.quran.com/$reciterId/${surahNumber.toString().padLeft(3, '0')}${ayah.toString().padLeft(3, '0')}.mp3';
        final filePath = '${surahDir.path}/${surahNumber.toString().padLeft(3, '0')}_${ayah.toString().padLeft(3, '0')}.mp3';
        
        _progressController.add(DownloadProgress(
          downloaded: ayah,
          total: ayahCount,
          percentage: (ayah / ayahCount) * 100,
          status: DownloadStatus.downloading,
        ));

        await _dio.download(url, filePath, cancelToken: _cancelToken);
        final file = File(filePath);
        if (await file.exists()) totalSize += await file.length();
      }

      await _box.put('$surahNumber', {
        'surahNumber': surahNumber,
        'surahName': surahNames.length > surahNumber - 1 ? surahNames[surahNumber - 1] : 'سورة $surahNumber',
        'ayahCount': ayahCount,
        'reciterId': reciterId,
        'reciterName': AppConstants.reciters[reciterId] ?? reciterId,
        'sizeInBytes': totalSize,
        'downloadedAt': DateTime.now().toIso8601String(),
      });

      _progressController.add(DownloadProgress(
        downloaded: ayahCount,
        total: ayahCount,
        percentage: 100,
        status: DownloadStatus.completed,
      ));

      return const Right(null);
    } catch (e) {
      _progressController.add(DownloadProgress(
        downloaded: 0, total: 0, percentage: 0,
        status: DownloadStatus.failed, error: e.toString(),
      ));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDownloadedSurah(int surahNumber) async {
    try {
      await _init();
      final directory = await getApplicationDocumentsDirectory();
      final surahDir = Directory('${directory.path}/audio');
      if (await surahDir.exists()) {
        await for (final entity in surahDir.list(recursive: true)) {
          if (entity is File && entity.path.contains('/${surahNumber.toString().padLeft(3, '0')}_')) {
            await entity.delete();
          }
        }
      }
      await _box.delete('$surahNumber');
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isSurahDownloaded(int surahNumber) async {
    try {
      await _init();
      return Right(_box.containsKey('$surahNumber'));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Stream<DownloadProgress> getDownloadProgress() => _progressController.stream;

  @override
  Future<Either<Failure, void>> cancelDownload() async {
    try {
      _cancelToken?.cancel('Download cancelled by user');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalDownloadSize() async {
    try {
      await _init();
      var total = 0;
      for (final value in _box.values) {
        final map = Map<String, dynamic>.from(value);
        total += map['sizeInBytes'] as int? ?? 0;
      }
      return Right(total);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  void dispose() {
    _progressController.close();
  }
}