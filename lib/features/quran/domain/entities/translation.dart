import 'package:equatable/equatable.dart';

class AyahTranslation extends Equatable {
  final int    ayahKey;   // surah * 1000 + ayah
  final String languageCode;
  final String text;

  const AyahTranslation({
    required this.ayahKey,
    required this.languageCode,
    required this.text,
  });

  @override
  List<Object?> get props => [ayahKey, languageCode];
}