import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/surah_model.dart';
import '../models/ayah_model.dart';

abstract class QuranRemoteDataSource {
  Future<List<SurahModel>> getAllSurahs();
  Future<List<AyahModel>> getAyahsBySurah(int surahNumber);
  Future<String> getTafseer(int surahNumber, int ayahNumber, String tafseerId);
  Future<List<Map<String, dynamic>>> getTranslation(int surahNumber, int translationId);
}

@LazySingleton(as: QuranRemoteDataSource)
class QuranRemoteDataSourceImpl implements QuranRemoteDataSource {
  final Dio _dio;
  QuranRemoteDataSourceImpl()
      : _dio = Dio(BaseOptions(
          baseUrl: AppConstants.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
        ));

  @override
  Future<List<SurahModel>> getAllSurahs() async {
    final response = await _dio.get('/chapters?language=ar');
    final chapters = response.data['chapters'] as List;
    return chapters.map((e) => SurahModel.fromJson(e)).toList();
  }

  @override
  Future<List<AyahModel>> getAyahsBySurah(int surahNumber) async {
    final response = await _dio.get(
      '/verses/by_chapter/$surahNumber',
      queryParameters: {
        'language': 'ar',
        'fields': 'text_uthmani,juz_number,hizb_number,rub_el_hizb_number,sajdah_number',
        'per_page': 300,
      },
    );
    final verses = response.data['verses'] as List;
    return verses.map((e) => AyahModel.fromJson(e)).toList();
  }

  @override
  Future<String> getTafseer(int surahNumber, int ayahNumber, String tafseerId) async {
    final response = await _dio.get('/tafsirs/$tafseerId/by_ayah/$surahNumber:$ayahNumber');
    return response.data['tafsir']['text'] ?? '';
  }

  @override
  Future<List<Map<String, dynamic>>> getTranslation(int surahNumber, int translationId) async {
    final response = await _dio.get(
      '/verses/by_chapter/$surahNumber',
      queryParameters: {'translations': translationId, 'per_page': 300},
    );
    final verses = response.data['verses'] as List;
    return verses.cast<Map<String, dynamic>>();
  }
}
