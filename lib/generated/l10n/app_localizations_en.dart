// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Holy Quran';

  @override
  String get home => 'Home';

  @override
  String get quran => 'Quran';

  @override
  String get search => 'Search';

  @override
  String get bookmarks => 'Bookmarks';

  @override
  String get settings => 'Settings';

  @override
  String surahNumber(int number) {
    return 'Surah $number';
  }

  @override
  String ayahCount(int count) {
    return '$count verses';
  }

  @override
  String get searchHint => 'Search the Holy Quran...';

  @override
  String searchNoResults(String query) {
    return 'No results for $query';
  }

  @override
  String get tafseer => 'Tafseer';

  @override
  String get translation => 'Translation';

  @override
  String get audio => 'Audio';

  @override
  String get playAudio => 'Play recitation';

  @override
  String get pauseAudio => 'Pause recitation';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get lightMode => 'Light mode';

  @override
  String get language => 'Language';

  @override
  String get fontSize => 'Font size';

  @override
  String get lastRead => 'Last read';

  @override
  String get continueReading => 'Continue reading';

  @override
  String get readingStats => 'Reading statistics';

  @override
  String get bookmarkAdded => 'Bookmark added';

  @override
  String get bookmarkRemoved => 'Bookmark removed';

  @override
  String get noBookmarks => 'No bookmarks yet';

  @override
  String get meccan => 'Meccan';

  @override
  String get medinan => 'Medinan';

  @override
  String juz(int number) {
    return 'Juz $number';
  }

  @override
  String get reciter => 'Reciter';

  @override
  String get playbackSpeed => 'Playback speed';

  @override
  String get repeatMode => 'Repeat mode';

  @override
  String get repeatAyah => 'Repeat verse';

  @override
  String get repeatSurah => 'Repeat surah';

  @override
  String get repeatJuz => 'Repeat juz';

  @override
  String get downloadAudio => 'Download audio';

  @override
  String get downloading => 'Downloading...';

  @override
  String get downloaded => 'Downloaded';

  @override
  String get todayAyah => 'Verse of the day';

  @override
  String get streak => 'Day streak';

  @override
  String streakDays(int count) {
    return '$count days';
  }

  @override
  String completionPercent(int percent) {
    return 'Quran completion $percent%';
  }

  @override
  String get readingReminder => 'Reading reminder';

  @override
  String get share => 'Share';

  @override
  String get copyAyah => 'Copy verse';

  @override
  String get addNote => 'Add note';

  @override
  String get folderName => 'Folder name';

  @override
  String get noInternet => 'No internet connection';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';
}
