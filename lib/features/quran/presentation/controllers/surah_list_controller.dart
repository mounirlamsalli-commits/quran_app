import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/surah.dart';
import '../../data/models/surah_model.dart';

final _dio = Dio(BaseOptions(
  baseUrl: 'https://api.quran.com/api/v4',
  connectTimeout: const Duration(seconds: 15),
  receiveTimeout: const Duration(seconds: 20),
));

final surahListProvider = FutureProvider<List<Surah>>((ref) async {
  final response = await _dio.get('/chapters?language=ar');
  final chapters = response.data['chapters'] as List;
  return chapters.map((e) => SurahModel.fromJson(e)).toList();
});