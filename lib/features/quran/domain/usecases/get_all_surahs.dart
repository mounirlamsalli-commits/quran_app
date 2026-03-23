import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/surah.dart';
import '../repositories/quran_repository.dart';

class GetAllSurahs {
  final QuranRepository repository;
  const GetAllSurahs(this.repository);

  Future<Either<Failure, List<Surah>>> call() => repository.getAllSurahs();
}