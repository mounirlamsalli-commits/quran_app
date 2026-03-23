import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/surah.dart';
import '../entities/ayah.dart';
import '../entities/translation.dart';

abstract class QuranRepository {
  Future<Either<Failure, List<Surah>>>          getAllSurahs();
  Future<Either<Failure, Surah>>                getSurahByNumber(int number);
  Future<Either<Failure, List<Ayah>>>           getAyahsBySurah(int surahNumber);
  Future<Either<Failure, List<AyahTranslation>>>getTranslation(int surahNumber, int translationId);
  Future<Either<Failure, String>>               getTafseer(int surahNumber, int ayahNumber, String tafseerId);
}