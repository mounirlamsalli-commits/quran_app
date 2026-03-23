import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/ayah.dart';
import '../../data/models/ayah_model.dart';

final _dio = Dio(BaseOptions(
  baseUrl: AppConstants.baseUrl,
  connectTimeout: const Duration(seconds: 15),
  receiveTimeout: const Duration(seconds: 30),
));

// Ayahs provider
final surahAyahsProvider =
    FutureProvider.family<List<Ayah>, int>((ref, surahNumber) async {
  final response = await _dio.get(
    '/verses/by_chapter/$surahNumber',
    queryParameters: {
      'language': 'ar',
      'fields': 'text_uthmani,text_imlaei,juz_number,hizb_number,page_number',
      'per_page': 300,
    },
  );
  final verses = response.data['verses'] as List;
  return verses.map((e) => AyahModel.fromJson(e)).toList();
});

// Selected tafseer - simple StateProvider
final selectedTafseerProvider = StateProvider<int>((ref) => 14);

// Selected translation - simple StateProvider
final selectedTranslationProvider = StateProvider<int>((ref) => 20);

// Selected reciter - simple StateProvider
final selectedReciterProvider = StateProvider<String>((ref) => 'ar.alafasy');

// Tafseer provider
final tafseerProvider = FutureProvider.family<List<Map<String, dynamic>>, int>(
    (ref, surahNumber) async {
  final tafseerId = ref.watch(selectedTafseerProvider);
  final ayahsAsync = ref.watch(surahAyahsProvider(surahNumber));

  return ayahsAsync.when(
    data: (ayahs) async {
      final List<Map<String, dynamic>> tafsirs = [];
      for (var i = 0; i < ayahs.length; i++) {
        final ayah = ayahs[i];
        try {
          final response =
              await _dio.get('/tafsirs/$tafseerId/by_ayah/${ayah.verseKey}');
          final tafsir = response.data['tafsir'];
          tafsirs.add({
            'text': (tafsir['text'] ?? '')
                .toString()
                .replaceAll(RegExp(r'<[^>]*>'), '')
                .trim(),
            'verse_key': ayah.verseKey,
            'ayah_number': ayah.numberInSurah,
          });
        } catch (e) {
          tafsirs.add({
            'text': 'التفسير غير متاح',
            'verse_key': ayah.verseKey,
            'ayah_number': ayah.numberInSurah,
          });
        }
      }
      return tafsirs;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Translation provider
final translationProvider =
    FutureProvider.family<List<Map<String, dynamic>>, int>(
        (ref, surahNumber) async {
  final translationId = ref.watch(selectedTranslationProvider);
  try {
    final response = await _dio.get(
      '/verses/by_chapter/$surahNumber',
      queryParameters: {
        'translations': translationId.toString(),
        'fields': 'text_uthmani',
        'per_page': 300,
      },
    );
    final verses = response.data['verses'] as List;
    return verses.map((v) {
      final translations = v['translations'] as List?;
      final transText = translations != null && translations.isNotEmpty
          ? (translations[0]['text'] ?? '')
              .toString()
              .replaceAll(RegExp(r'<[^>]*>'), '')
          : '';
      return {
        'text': transText,
        'verse_key': v['verse_key'] ?? '',
        'number_in_surah': v['verse_number'] ?? 0,
      };
    }).toList();
  } catch (e) {
    return [];
  }
});

// Audio URL builder
String getAudioUrl(String reciterId, int surah, int ayah) {
  final surahStr = surah.toString().padLeft(3, '0');
  final ayahStr = ayah.toString().padLeft(3, '0');
  return 'https://cdn.islamway.net/quran/$reciterId/$surahStr$ayahStr.mp3';
}

final isPlayingProvider = StateProvider<bool>((ref) => false);
final currentAyahProvider = StateProvider<int>((ref) => 1);
final audioSpeedProvider = StateProvider<double>((ref) => 1.0);
