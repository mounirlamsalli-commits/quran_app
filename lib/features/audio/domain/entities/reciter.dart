import 'package:equatable/equatable.dart';

class Reciter extends Equatable {
  final String id;
  final String nameArabic;
  final String nameEnglish;
  final String style;

  const Reciter({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.style,
  });

  @override
  List<Object?> get props => [id];
}

enum RepeatMode { none, ayah, surah, juz }