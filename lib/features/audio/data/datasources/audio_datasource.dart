import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/reciter.dart';

abstract class AudioDataSource {
  Future<List<Reciter>> getReciters();
  String getAudioUrl(String reciterId, int surahNumber, int ayahNumber);
}

@LazySingleton(as: AudioDataSource)
class AudioDataSourceImpl implements AudioDataSource {
  final Dio _dio;
  
  AudioDataSourceImpl() : _dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
  ));

  @override
  Future<List<Reciter>> getReciters() async {
    final response = await _dio.get('/resources/audio_reciters', queryParameters: {'language': 'ar'});
    final reciters = response.data['reciters'] as List;
    return reciters.map((r) => Reciter(
      id: r['id'].toString(),
      nameArabic: r['translated_name']?['name'] ?? r['name'] ?? '',
      nameEnglish: r['recitation_style'] ?? '',
      style: r['recitation_style'] ?? '',
    )).toList();
  }

  @override
  String getAudioUrl(String reciterId, int surahNumber, int ayahNumber) {
    final paddedSurah = surahNumber.toString().padLeft(3, '0');
    final paddedAyah = ayahNumber.toString().padLeft(3, '0');
    return '${AppConstants.audioBaseUrl}/$reciterId/$paddedSurah$paddedAyah.mp3';
  }
}