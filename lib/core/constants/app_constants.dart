class AppConstants {
  AppConstants._();

  // API
  static const String baseUrl = 'https://api.quran.com/api/v4';
  static const String audioBaseUrl = 'https://cdn.islamway.net/quran';

  // Quran
  static const int totalSurahs = 114;
  static const int totalAyahs = 6236;
  static const int totalJuz = 30;

  // Hive Boxes
  static const String settingsBox = 'settings_box';
  static const String bookmarksBox = 'bookmarks_box';
  static const String statisticsBox = 'statistics_box';
  static const String downloadedBox = 'downloaded_box';

  // SharedPreferences Keys
  static const String keyLocale = 'locale';
  static const String keyThemeMode = 'theme_mode';
  static const String keyQuranFontSize = 'quran_font_size';
  static const String keyLastRead = 'last_read';
  static const String keySelectedReciter = 'selected_reciter';
  static const String keySelectedTafseer = 'selected_tafseer';
  static const String keySelectedTranslation = 'selected_translation';
  static const String keyAudioSpeed = 'audio_speed';

  // Audio reciters with working URLs
  static const Map<String, String> reciters = {
    'arabdulbassitabdulsamad': 'عبد الباسط عبد الصمد',
    'ar.abdurrahmaansudais': 'عبد الرحمن السديس',
    'ar.abdulsamad': 'عبد الصمد',
    'ar.alafasy': 'مشاري راشد العفاسي',
    'ar.husary': 'محمود خليل الحصري',
    'ar.minshawi': 'محمد صديق المنشاوي',
    'ar.muhammadayyoub': 'محمد أيوب',
    'ar.saaboriqee': 'سعود الشريم',
  };

  // Tafseer IDs (from api.quran.com/api/v4/resources/tafsirs)
  static const Map<int, String> tafseers = {
    14: 'Tafsir Ibn Kathir - ابن كثير',
    91: 'Al-Sa\'di - السعدي',
    15: 'Al-Tabari - الطبري',
    93: 'Al-Tafsir al-Wasit - الوسيط',
    94: 'Tafseer Al-Baghawi - البغوي',
  };

  // Translations IDs (from api.quran.com/api/v4/resources/translations)
  static const Map<int, String> translations = {
    20: 'English - Saheeh International',
    22: 'English - Yusuf Ali',
    19: 'English - Pickthall',
    21: 'English - Yusuf Ali (Original)',
    31: 'French - Muhammad Hamidullah',
    56: 'Chinese - Ma Jian (Simplified)',
    33: 'Indonesian - Indonesian Islamic Affairs Ministry',
    136: 'French - Montada Islamic Foundation',
  };

  // Languages
  static const Map<String, String> languageNames = {
    'ar': 'العربية',
    'en': 'English',
    'fr': 'Français',
    'zgh': 'ⵜⴰⵎⴰⵣⵉⵖⵜ',
    'zh': '中文',
  };
}
