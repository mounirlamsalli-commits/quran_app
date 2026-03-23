// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'القرآن الكريم';

  @override
  String get home => 'الرئيسية';

  @override
  String get quran => 'القرآن';

  @override
  String get search => 'البحث';

  @override
  String get bookmarks => 'الإشارات';

  @override
  String get settings => 'الإعدادات';

  @override
  String surahNumber(int number) {
    return 'سورة $number';
  }

  @override
  String ayahCount(int count) {
    return '$count آية';
  }

  @override
  String get searchHint => 'ابحث في القرآن الكريم...';

  @override
  String searchNoResults(String query) {
    return 'لا نتائج لـ $query';
  }

  @override
  String get tafseer => 'التفسير';

  @override
  String get translation => 'الترجمة';

  @override
  String get audio => 'التلاوة';

  @override
  String get playAudio => 'تشغيل التلاوة';

  @override
  String get pauseAudio => 'إيقاف التلاوة';

  @override
  String get darkMode => 'الوضع الليلي';

  @override
  String get lightMode => 'الوضع النهاري';

  @override
  String get language => 'اللغة';

  @override
  String get fontSize => 'حجم الخط';

  @override
  String get lastRead => 'آخر قراءة';

  @override
  String get continueReading => 'استكمال القراءة';

  @override
  String get readingStats => 'إحصائيات القراءة';

  @override
  String get bookmarkAdded => 'تمت إضافة الإشارة';

  @override
  String get bookmarkRemoved => 'تمت إزالة الإشارة';

  @override
  String get noBookmarks => 'لا توجد إشارات مرجعية بعد';

  @override
  String get meccan => 'مكية';

  @override
  String get medinan => 'مدنية';

  @override
  String juz(int number) {
    return 'الجزء $number';
  }

  @override
  String get reciter => 'القارئ';

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
  String get downloadAudio => 'تحميل التلاوة';

  @override
  String get downloading => 'جاري التحميل...';

  @override
  String get downloaded => 'تم التحميل';

  @override
  String get todayAyah => 'آية اليوم';

  @override
  String get streak => 'أيام متواصلة';

  @override
  String streakDays(int count) {
    return '$count يوم';
  }

  @override
  String completionPercent(int percent) {
    return 'إتمام القرآن $percent%';
  }

  @override
  String get readingReminder => 'تذكير القراءة';

  @override
  String get share => 'مشاركة';

  @override
  String get copyAyah => 'نسخ الآية';

  @override
  String get addNote => 'إضافة ملاحظة';

  @override
  String get folderName => 'اسم المجلد';

  @override
  String get noInternet => 'لا يوجد اتصال بالإنترنت';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get loading => 'جاري التحميل...';
}
