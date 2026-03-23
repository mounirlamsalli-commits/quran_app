import 'package:equatable/equatable.dart';

class Ayah extends Equatable {
  final int surahNumber;
  final int numberInSurah;
  final int numberInQuran;
  final String textUthmani;
  final int juzNumber;
  final int hizbNumber;
  final int rubElHizbNumber;
  final int sajdahNumber;
  final bool isSajdah;

  const Ayah({
    required this.surahNumber,
    required this.numberInSurah,
    required this.numberInQuran,
    required this.textUthmani,
    required this.juzNumber,
    required this.hizbNumber,
    required this.rubElHizbNumber,
    this.sajdahNumber = 0,
    this.isSajdah = false,
  });

  String get verseKey => '$surahNumber:$numberInSurah';

  @override
  List<Object?> get props => [surahNumber, numberInSurah];
}
