import 'package:equatable/equatable.dart';

class ReadingStats extends Equatable {
  final int    totalAyahsRead;
  final int    totalMinutesRead;
  final int    currentStreak;
  final int    longestStreak;
  final double completionPercent;
  final Map<String, int> dailyAyahs;    // date → count
  final Map<String, int> dailyMinutes;  // date → minutes
  final Map<int, bool>   readSurahs;    // surahNumber → completed

  const ReadingStats({
    required this.totalAyahsRead,
    required this.totalMinutesRead,
    required this.currentStreak,
    required this.longestStreak,
    required this.completionPercent,
    required this.dailyAyahs,
    required this.dailyMinutes,
    required this.readSurahs,
  });

  @override
  List<Object?> get props => [totalAyahsRead, currentStreak];
}