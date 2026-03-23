// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Standard Moroccan Tamazight (`zgh`).
class AppLocalizationsZgh extends AppLocalizations {
  AppLocalizationsZgh([String locale = 'zgh']) : super(locale);

  @override
  String get appName => 'ⴰⵇⵓⵔⴰⵏ';

  @override
  String get home => 'ⴰⵙⵓⴷⵓ';

  @override
  String get quran => 'ⴰⵇⵓⵔⴰⵏ';

  @override
  String get search => 'ⴰⵔⵎⵓⴷ';

  @override
  String get bookmarks => 'ⵉⵙⵉⵏⴰⵏ';

  @override
  String get settings => 'ⵉⵙⵡⵓⵔⵉⵏ';

  @override
  String surahNumber(int number) {
    return 'ⵙⵓⵔⴰ $number';
  }

  @override
  String ayahCount(int count) {
    return '$count ⵏ ⵡⴰⵢⵢⴰⵜⵏ';
  }

  @override
  String get searchHint => 'ⴰⵔⵎⵓⴷ ⴷⴰⵡ ⵡⴰⵇⵓⵔⴰⵏ...';

  @override
  String searchNoResults(String query) {
    return 'ⵓⵔ ⵉⵍⵍⵉ ⴰⵡⴰⵍ ⵉ \"$query\"';
  }

  @override
  String get tafseer => 'ⴰⵙⵙⵉⵏ';

  @override
  String get translation => 'ⴰⵙⵙⵓⵔⵙ';

  @override
  String get audio => 'ⵓⵙⵙⴰⵏ';

  @override
  String get playAudio => 'ⵙⵙⵓⴼⵖ';

  @override
  String get pauseAudio => 'ⵄⵇⵇⵍ';

  @override
  String get darkMode => 'ⴰⵜⵔⴰⵔ';

  @override
  String get lightMode => 'ⴰⴱⵔⵔⴰⵇ';

  @override
  String get language => 'ⵜⵓⵜⵍⴰⵢⵜ';

  @override
  String get fontSize => 'ⵜⵉⵇⵇⴻⵏⵜ';

  @override
  String get lastRead => 'ⵉⵖⴻⴼ ⴰⵖⵍⴰ';

  @override
  String get continueReading => 'ⴽⵎⵎⵍ';

  @override
  String get readingStats => 'ⵉⵎⵙⵙⴰⵔⵏ';

  @override
  String get bookmarkAdded => 'ⵉⵔⵏⵓ';

  @override
  String get bookmarkRemoved => 'ⵉⵎⵎⵓⵜⵜ';

  @override
  String get noBookmarks => 'ⵓⵔ ⵉⵍⵍⵉ ⵓⵙⵉⵏ';

  @override
  String get meccan => 'ⵏ ⵎⴰⴽⴽⴰ';

  @override
  String get medinan => 'ⵏ ⵍⵎⴰⴷⵉⵏⴰ';

  @override
  String juz(int number) {
    return 'ⵊⵓⵣ $number';
  }

  @override
  String get reciter => 'ⴰⵏⵖⴰ';

  @override
  String get playbackSpeed => 'سرعة التلاوة';

  @override
  String get repeatMode => 'وضع التكرار';

  @override
  String get repeatAyah => 'تكرار الآية';

  @override
  String get repeatSurah => 'تكرار السورة';

  @override
  String get repeatJuz => 'تكرار الجزء';

  @override
  String get downloadAudio => 'ⵃⵓⵟⵟ';

  @override
  String get downloading => 'ⵔⴳⵍ...';

  @override
  String get downloaded => 'ⵉⵡⵡⵓⵔⵉ';

  @override
  String get todayAyah => 'ⵡⴰⵢⵢⴰⵜ ⵏ ⵡⴰⵙⵙ';

  @override
  String get streak => 'ⵉⵏⵏⴰⵏ';

  @override
  String streakDays(int count) {
    return '$count';
  }

  @override
  String completionPercent(int percent) {
    return '$percent%';
  }

  @override
  String get readingReminder => 'ⴰⵔⵡⴷ';

  @override
  String get share => 'ⵙⴽⵜⵉ';

  @override
  String get copyAyah => 'ⵔⵔⵓ';

  @override
  String get addNote => 'ⵔⵏⵓ';

  @override
  String get folderName => 'ⵉⵙⵎ';

  @override
  String get noInternet => 'ⵓⵔ ⵉⵍⵍⵉ ⵡⴰⵏⵟⴰⵏⵟ';

  @override
  String get retry => 'ⵔⵔⵓ';

  @override
  String get loading => 'ⵔⴳⵍ...';
}
