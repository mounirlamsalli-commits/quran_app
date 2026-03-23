import 'package:equatable/equatable.dart';

class Surah extends Equatable {
  final int    number;
  final String nameArabic;
  final String nameSimple;
  final String nameTranslation;
  final int    ayahCount;
  final String revelationPlace; // mecca | medina
  final int    juzStart;

  const Surah({
    required this.number,
    required this.nameArabic,
    required this.nameSimple,
    required this.nameTranslation,
    required this.ayahCount,
    required this.revelationPlace,
    required this.juzStart,
  });

  bool get isMeccan => revelationPlace == 'mecca';

  @override
  List<Object?> get props => [number];
}