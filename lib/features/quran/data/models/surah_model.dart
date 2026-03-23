import '../../domain/entities/surah.dart';

class SurahModel extends Surah {
  const SurahModel({
    required super.number,
    required super.nameArabic,
    required super.nameSimple,
    required super.nameTranslation,
    required super.ayahCount,
    required super.revelationPlace,
    required super.juzStart,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number:          json['id'],
      nameArabic:      json['name_arabic'] ?? '',
      nameSimple:      json['name_simple'] ?? '',
      nameTranslation: json['translated_name']?['name'] ?? '',
      ayahCount:       json['verses_count'] ?? 0,
      revelationPlace: json['revelation_place'] ?? 'mecca',
      juzStart:        json['pages']?[0] ?? 1,
    );
  }
}
