import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/reciter.dart';
import '../../domain/repositories/audio_repository.dart';
import '../datasources/audio_datasource.dart';

@LazySingleton(as: AudioRepository)
class AudioRepositoryImpl implements AudioRepository {
  final AudioDataSource _dataSource;
  final AudioPlayer _player = AudioPlayer();

  AudioRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<Reciter>>> getReciters() async {
    try {
      return Right(await _dataSource.getReciters());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getAudioUrl(String reciterId, int surahNumber, int ayahNumber) async {
    try {
      return Right(_dataSource.getAudioUrl(reciterId, surahNumber, ayahNumber));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Duration> get positionStream => _player.positionStream;
  
  @override
  Stream<Duration> get durationStream => _player.durationStream.where((d) => d != null).cast<Duration>();
  
  @override
  Stream<bool> get playingStream => _player.playingStream;

  @override
  Future<void> play(String url) async {
    await _player.setUrl(url);
    await _player.play();
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    await _player.seek(Duration.zero);
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  @override
  void dispose() => _player.dispose();
}