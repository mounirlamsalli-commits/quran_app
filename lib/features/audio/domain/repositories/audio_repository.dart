import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/reciter.dart';

abstract class AudioRepository {
  Future<Either<Failure, List<Reciter>>> getReciters();
  Future<Either<Failure, String>> getAudioUrl(String reciterId, int surahNumber, int ayahNumber);
  Stream<Duration> get positionStream;
  Stream<Duration> get durationStream;
  Stream<bool> get playingStream;
  Future<void> play(String url);
  Future<void> pause();
  Future<void> stop();
  Future<void> seek(Duration position);
  Future<void> setSpeed(double speed);
  void dispose();
}