import 'package:equatable/equatable.dart';

class ReadingStats extends Equatable {
  final int totalAyahsRead;
  final int totalMinutesRead;
  final int currentStreak;
  final int longestStreak;
  final double quranCompletionPercentage;
  final int juzCompleted;
  final int hizbCompleted;
  final int surahsCompleted;
  final List<DailyStats> weeklyStats;
  final Map<int, double> juzProgress;
  final DateTime lastReadDate;

  const ReadingStats({
    required this.totalAyahsRead,
    required this.totalMinutesRead,
    required this.currentStreak,
    required this.longestStreak,
    required this.quranCompletionPercentage,
    required this.juzCompleted,
    required this.hizbCompleted,
    required this.surahsCompleted,
    required this.weeklyStats,
    required this.juzProgress,
    required this.lastReadDate,
  });

  ReadingStats copyWith({
    int? totalAyahsRead, int? totalMinutesRead, int? currentStreak, int? longestStreak,
    double? quranCompletionPercentage, int? juzCompleted, int? hizbCompleted, int? surahsCompleted,
    List<DailyStats>? weeklyStats, Map<int, double>? juzProgress, DateTime? lastReadDate,
  }) {
    return ReadingStats(
      totalAyahsRead: totalAyahsRead ?? this.totalAyahsRead,
      totalMinutesRead: totalMinutesRead ?? this.totalMinutesRead,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      quranCompletionPercentage: quranCompletionPercentage ?? this.quranCompletionPercentage,
      juzCompleted: juzCompleted ?? this.juzCompleted,
      hizbCompleted: hizbCompleted ?? this.hizbCompleted,
      surahsCompleted: surahsCompleted ?? this.surahsCompleted,
      weeklyStats: weeklyStats ?? this.weeklyStats,
      juzProgress: juzProgress ?? this.juzProgress,
      lastReadDate: lastReadDate ?? this.lastReadDate,
    );
  }

  @override
  List<Object?> get props => [totalAyahsRead, totalMinutesRead, currentStreak, lastReadDate];
}

class DailyStats extends Equatable {
  final DateTime date;
  final int ayahsRead;
  final int minutesRead;
  final int pagesRead;

  const DailyStats({required this.date, required this.ayahsRead, required this.minutesRead, required this.pagesRead});

  @override
  List<Object?> get props => [date, ayahsRead, minutesRead, pagesRead];
}