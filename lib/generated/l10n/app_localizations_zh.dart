// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => '圣古兰经';

  @override
  String get home => '首页';

  @override
  String get quran => '古兰经';

  @override
  String get search => '搜索';

  @override
  String get bookmarks => '书签';

  @override
  String get settings => '设置';

  @override
  String surahNumber(int number) {
    return '第$number章';
  }

  @override
  String ayahCount(int count) {
    return '$count节';
  }

  @override
  String get searchHint => '搜索古兰经...';

  @override
  String searchNoResults(String query) {
    return '没有找到\"$query\"';
  }

  @override
  String get tafseer => '注释';

  @override
  String get translation => '翻译';

  @override
  String get audio => '音频';

  @override
  String get playAudio => '播放诵读';

  @override
  String get pauseAudio => '暂停';

  @override
  String get darkMode => '深色模式';

  @override
  String get lightMode => '浅色模式';

  @override
  String get language => '语言';

  @override
  String get fontSize => '字体大小';

  @override
  String get lastRead => '最近阅读';

  @override
  String get continueReading => '继续阅读';

  @override
  String get readingStats => '阅读统计';

  @override
  String get bookmarkAdded => '已添加书签';

  @override
  String get bookmarkRemoved => '已删除书签';

  @override
  String get noBookmarks => '暂无书签';

  @override
  String get meccan => '麦加章';

  @override
  String get medinan => '麦地那章';

  @override
  String juz(int number) {
    return '第$number篇';
  }

  @override
  String get reciter => '诵读者';

  @override
  String get playbackSpeed => '播放速度';

  @override
  String get repeatMode => '重复模式';

  @override
  String get repeatAyah => '重复经文';

  @override
  String get repeatSurah => '重复章节';

  @override
  String get repeatJuz => '重复篇章';

  @override
  String get downloadAudio => '下载音频';

  @override
  String get downloading => '下载中...';

  @override
  String get downloaded => '已下载';

  @override
  String get todayAyah => '今日经文';

  @override
  String get streak => '连续天数';

  @override
  String streakDays(int count) {
    return '$count天';
  }

  @override
  String completionPercent(int percent) {
    return '完成$percent%';
  }

  @override
  String get readingReminder => '阅读提醒';

  @override
  String get share => '分享';

  @override
  String get copyAyah => '复制经文';

  @override
  String get addNote => '添加笔记';

  @override
  String get folderName => '文件夹名称';

  @override
  String get noInternet => '无网络连接';

  @override
  String get retry => '重试';

  @override
  String get loading => '加载中...';
}
