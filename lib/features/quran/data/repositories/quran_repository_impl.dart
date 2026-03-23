import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/surah.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/translation.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/quran_remote_datasource.dart';

@LazySingleton(as: QuranRepository)
class QuranRepositoryImpl implements QuranRepository {
  final QuranRemoteDataSource _remote;
  QuranRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<Surah>>> getAllSurahs() async {
    try {
      return Right(await _remote.getAllSurahs());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Surah>> getSurahByNumber(int number) async {
    try {
      final surahs = await _remote.getAllSurahs();
      final surah = surahs.firstWhere((s) => s.number == number);
      return Right(surah);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Ayah>>> getAyahsBySurah(int surahNumber) async {
    try {
      return Right(await _remote.getAyahsBySurah(surahNumber));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AyahTranslation>>> getTranslation(int surahNumber, int translationId) async {
    try {
      final verses = await _remote.getTranslation(surahNumber, translationId);
      final translations = verses.map((v) {
        final t = (v['translations'] as List?)?.first;
        return AyahTranslation(
          ayahKey:      v['verse_number'] ?? 0,
          languageCode: 'en',
          text:         t?['text'] ?? '',
        );
      }).toList();
      return Right(translations);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getTafseer(int surahNumber, int ayahNumber, String tafseerId) async {
    try {
      return Right(await _remote.getTafseer(surahNumber, ayahNumber, tafseerId));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
