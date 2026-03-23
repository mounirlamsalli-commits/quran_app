import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/ayah.dart';
import '../repositories/quran_repository.dart';

class GetSurahAyahs {
  final QuranRepository repository;
  const GetSurahAyahs(this.repository);

  Future<Either<Failure, List<Ayah>>> call(int surahNumber) =>
      repository.getAyahsBySurah(surahNumber);
}