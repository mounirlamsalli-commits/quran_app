class AppConstants {
  AppConstants._();

  // API
  static const String baseUrl = 'https://api.quran.com/api/v4';
  static const String audioBaseUrl = 'https://server7.mp3quran.net';

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

  // Audio reciters with working URLs from mp3quran.net
  static const Map<String, String> reciters = {
    'Alafasy': 'مشاري راشد العفاسي',
    'Abdul_Basit': 'عبد الباسط عبد الصمد',
    'Husary': 'محمود خليل الحصري',
    'Minshawi': 'محمد صديق المنشاوي',
    'Abdurrahman_AsSudais': 'عبد الرحمن السديس',
    'Saaboriqee': 'سعود الشريم',
    'Muhammad_Ayyoub': 'محمد أيوب',
  };

  // Tafseer IDs (from api.quran.com/api/v4/resources/tafsirs)
  static const Map<int, String> tafseers = {
    14: 'ابن كثير - Ibn Kathir',
    91: 'السعدي - Al-Sa\'di',
    15: 'الطبري - Al-Tabari',
    93: 'الوسيط - Al-Wasit',
    94: 'البغوي - Al-Baghawi',
  };

  // Translations IDs (from api.quran.com/api/v4/resources/translations)
  static const Map<int, String> translations = {
    20: 'English - Saheeh International',
    22: 'English - Yusuf Ali',
    19: 'English - Pickthall',
    31: 'French - Muhammad Hamidullah',
    56: 'Chinese - Ma Jian',
    33: 'Indonesian - Ministry',
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
