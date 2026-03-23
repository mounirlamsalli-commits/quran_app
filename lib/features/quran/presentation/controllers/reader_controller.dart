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

// Selected tafseer - default Ibn Kathir (14)
final selectedTafseerProvider = StateProvider<int>((ref) => 14);

// Selected translation - default English Saheeh (20)
final selectedTranslationProvider = StateProvider<int>((ref) => 20);

// Selected reciter
final selectedReciterProvider = StateProvider<String>((ref) => 'Alafasy');

// Tafseer provider - loads tafseer for each ayah
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

// Audio URL - uses mp3quran.net which is reliable
String getAudioUrl(String reciterKey, int surah, int ayah) {
  final surahStr = surah.toString().padLeft(3, '0');
  final ayahStr = ayah.toString().padLeft(3, '0');
  return 'https://server7.mp3quran.net/afs/$surahStr$ayahStr.mp3';
}

final isPlayingProvider = StateProvider<bool>((ref) => false);
final currentAyahProvider = StateProvider<int>((ref) => 1);
final audioSpeedProvider = StateProvider<double>((ref) => 1.0);

// Selected ayah for showing options (tafseer, bookmark, share)
final selectedAyahForOptionsProvider = StateProvider<Ayah?>((ref) => null);

// Tafseer for a specific ayah
final tafseerByAyahProvider =
    FutureProvider.family<String, Map<String, int>>((ref, params) async {
  final surahNumber = params['surah']!;
  final ayahNumber = params['ayah']!;
  final tafseerId = ref.watch(selectedTafseerProvider);
  final verseKey =
      '${surahNumber.toString().padLeft(3, '0')}:${ayahNumber.toString().padLeft(3, '0')}';

  try {
    final response = await _dio.get('/tafsirs/$tafseerId/by_ayah/$verseKey');
    final tafsir = response.data['tafsir'];
    return (tafsir['text'] ?? '')
        .toString()
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();
  } catch (e) {
    return 'التفسير غير متاح';
  }
});
