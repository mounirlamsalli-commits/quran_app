import '../../domain/entities/ayah.dart';

class AyahModel extends Ayah {
  const AyahModel({
    required super.surahNumber,
    required super.numberInSurah,
    required super.numberInQuran,
    required super.textUthmani,
    required super.juzNumber,
    required super.hizbNumber,
    required super.rubElHizbNumber,
    super.sajdahNumber,
    super.isSajdah,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      surahNumber:     json['chapter_id'] ?? 0,
      numberInSurah:   json['verse_number'] ?? 0,
      numberInQuran:   json['verse_number'] ?? 0,
      textUthmani:     json['text_uthmani'] ?? '',
      juzNumber:       json['juz_number'] ?? 1,
      hizbNumber:      json['hizb_number'] ?? 1,
      rubElHizbNumber: json['rub_el_hizb_number'] ?? 1,
      sajdahNumber:    json['sajdah_number'] ?? 0,
      isSajdah:        json['sajdah_number'] != null,
    );
  }
}