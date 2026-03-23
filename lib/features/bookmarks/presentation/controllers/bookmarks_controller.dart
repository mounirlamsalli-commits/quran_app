import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/bookmark.dart';

const _kBookmarksKey = 'bookmarks_list';

final bookmarksProvider = StateNotifierProvider<BookmarksNotifier, List<Bookmark>>(
  (ref) => BookmarksNotifier(),
);

class BookmarksNotifier extends StateNotifier<List<Bookmark>> {
  BookmarksNotifier() : super([]) { _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kBookmarksKey);
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      state = list.map((e) => _fromJson(e)).toList();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kBookmarksKey, jsonEncode(state.map(_toJson).toList()));
  }

  bool isBookmarked(int surahNumber, int ayahNumber) {
    return state.any((b) => b.surahNumber == surahNumber && b.ayahNumber == ayahNumber);
  }

  Future<void> addBookmark({
    required int surahNumber,
    required int ayahNumber,
    required String ayahText,
    String customName = '',
  }) async {
    final bookmark = Bookmark(
      id: '${surahNumber}_$ayahNumber',
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      ayahText: ayahText,
      customName: customName.isEmpty ? 'سورة $surahNumber - آية $ayahNumber' : customName,
      folderId: 'default',
      createdAt: DateTime.now(),
    );
    state = [...state.where((b) => b.id != bookmark.id), bookmark];
    await _save();
  }

  Future<void> removeBookmark(int surahNumber, int ayahNumber) async {
    state = state.where((b) => !(b.surahNumber == surahNumber && b.ayahNumber == ayahNumber)).toList();
    await _save();
  }

  Future<void> toggleBookmark({
    required int surahNumber,
    required int ayahNumber,
    required String ayahText,
  }) async {
    if (isBookmarked(surahNumber, ayahNumber)) {
      await removeBookmark(surahNumber, ayahNumber);
    } else {
      await addBookmark(surahNumber: surahNumber, ayahNumber: ayahNumber, ayahText: ayahText);
    }
  }

  static Map<String, dynamic> _toJson(Bookmark b) => {
    'id': b.id,
    'surahNumber': b.surahNumber,
    'ayahNumber': b.ayahNumber,
    'ayahText': b.ayahText,
    'customName': b.customName,
    'folderId': b.folderId,
    'createdAt': b.createdAt.toIso8601String(),
    'note': b.note,
  };

  static Bookmark _fromJson(Map<String, dynamic> j) => Bookmark(
    id: j['id'],
    surahNumber: j['surahNumber'],
    ayahNumber: j['ayahNumber'],
    ayahText: j['ayahText'],
    customName: j['customName'],
    folderId: j['folderId'],
    createdAt: DateTime.parse(j['createdAt']),
    note: j['note'],
  );
}