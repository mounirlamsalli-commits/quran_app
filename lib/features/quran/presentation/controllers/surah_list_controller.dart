import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/surah.dart';
import '../../data/models/surah_model.dart';

final surahListProvider = FutureProvider<List<Surah>>((ref) async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.quran.com/api/v4',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ));
  final response = await dio.get('/chapters?language=ar');
  final chapters = response.data['chapters'] as List;
  return chapters.map((e) => SurahModel.fromJson(e)).toList();
});
