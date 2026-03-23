import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_zgh.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
    Locale('zgh'),
    Locale('zh')
  ];

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'القرآن الكريم'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get home;

  /// No description provided for @quran.
  ///
  /// In ar, this message translates to:
  /// **'القرآن'**
  String get quran;

  /// No description provided for @search.
  ///
  /// In ar, this message translates to:
  /// **'البحث'**
  String get search;

  /// No description provided for @bookmarks.
  ///
  /// In ar, this message translates to:
  /// **'الإشارات'**
  String get bookmarks;

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// No description provided for @surahNumber.
  ///
  /// In ar, this message translates to:
  /// **'سورة {number}'**
  String surahNumber(int number);

  /// No description provided for @ayahCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} آية'**
  String ayahCount(int count);

  /// No description provided for @searchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث في القرآن الكريم...'**
  String get searchHint;

  /// No description provided for @searchNoResults.
  ///
  /// In ar, this message translates to:
  /// **'لا نتائج لـ \"{query}\"'**
  String searchNoResults(String query);

  /// No description provided for @tafseer.
  ///
  /// In ar, this message translates to:
  /// **'التفسير'**
  String get tafseer;

  /// No description provided for @translation.
  ///
  /// In ar, this message translates to:
  /// **'الترجمة'**
  String get translation;

  /// No description provided for @audio.
  ///
  /// In ar, this message translates to:
  /// **'التلاوة'**
  String get audio;

  /// No description provided for @playAudio.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل التلاوة'**
  String get playAudio;

  /// No description provided for @pauseAudio.
  ///
  /// In ar, this message translates to:
  /// **'إيقاف التلاوة'**
  String get pauseAudio;

  /// No description provided for @darkMode.
  ///
  /// In ar, this message translates to:
  /// **'الوضع الليلي'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In ar, this message translates to:
  /// **'الوضع النهاري'**
  String get lightMode;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @fontSize.
  ///
  /// In ar, this message translates to:
  /// **'حجم الخط'**
  String get fontSize;

  /// No description provided for @lastRead.
  ///
  /// In ar, this message translates to:
  /// **'آخر قراءة'**
  String get lastRead;

  /// No description provided for @continueReading.
  ///
  /// In ar, this message translates to:
  /// **'استكمال القراءة'**
  String get continueReading;

  /// No description provided for @readingStats.
  ///
  /// In ar, this message translates to:
  /// **'إحصائيات القراءة'**
  String get readingStats;

  /// No description provided for @bookmarkAdded.
  ///
  /// In ar, this message translates to:
  /// **'تمت إضافة الإشارة'**
  String get bookmarkAdded;

  /// No description provided for @bookmarkRemoved.
  ///
  /// In ar, this message translates to:
  /// **'تمت إزالة الإشارة'**
  String get bookmarkRemoved;

  /// No description provided for @noBookmarks.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إشارات مرجعية بعد'**
  String get noBookmarks;

  /// No description provided for @meccan.
  ///
  /// In ar, this message translates to:
  /// **'مكية'**
  String get meccan;

  /// No description provided for @medinan.
  ///
  /// In ar, this message translates to:
  /// **'مدنية'**
  String get medinan;

  /// No description provided for @juz.
  ///
  /// In ar, this message translates to:
  /// **'الجزء {number}'**
  String juz(int number);

  /// No description provided for @reciter.
  ///
  /// In ar, this message translates to:
  /// **'القارئ'**
  String get reciter;

  /// No description provided for @playbackSpeed.
  ///
  /// In ar, this message translates to:
  /// **'سرعة التلاوة'**
  String get playbackSpeed;

  /// No description provided for @repeatMode.
  ///
  /// In ar, this message translates to:
  /// **'وضع التكرار'**
  String get repeatMode;

  /// No description provided for @repeatAyah.
  ///
  /// In ar, this message translates to:
  /// **'تكرار الآية'**
  String get repeatAyah;

  /// No description provided for @repeatSurah.
  ///
  /// In ar, this message translates to:
  /// **'تكرار السورة'**
  String get repeatSurah;

  /// No description provided for @repeatJuz.
  ///
  /// In ar, this message translates to:
  /// **'تكرار الجزء'**
  String get repeatJuz;

  /// No description provided for @downloadAudio.
  ///
  /// In ar, this message translates to:
  /// **'تحميل التلاوة'**
  String get downloadAudio;

  /// No description provided for @downloading.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحميل...'**
  String get downloading;

  /// No description provided for @downloaded.
  ///
  /// In ar, this message translates to:
  /// **'تم التحميل'**
  String get downloaded;

  /// No description provided for @todayAyah.
  ///
  /// In ar, this message translates to:
  /// **'آية اليوم'**
  String get todayAyah;

  /// No description provided for @streak.
  ///
  /// In ar, this message translates to:
  /// **'أيام متواصلة'**
  String get streak;

  /// No description provided for @streakDays.
  ///
  /// In ar, this message translates to:
  /// **'{count} يوم'**
  String streakDays(int count);

  /// No description provided for @completionPercent.
  ///
  /// In ar, this message translates to:
  /// **'إتمام القرآن {percent}%'**
  String completionPercent(int percent);

  /// No description provided for @readingReminder.
  ///
  /// In ar, this message translates to:
  /// **'تذكير القراءة'**
  String get readingReminder;

  /// No description provided for @share.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة'**
  String get share;

  /// No description provided for @copyAyah.
  ///
  /// In ar, this message translates to:
  /// **'نسخ الآية'**
  String get copyAyah;

  /// No description provided for @addNote.
  ///
  /// In ar, this message translates to:
  /// **'إضافة ملاحظة'**
  String get addNote;

  /// No description provided for @folderName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المجلد'**
  String get folderName;

  /// No description provided for @noInternet.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد اتصال بالإنترنت'**
  String get noInternet;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحميل...'**
  String get loading;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr', 'zgh', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'zgh':
      return AppLocalizationsZgh();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
