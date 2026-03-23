import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/bookmark.dart';

const _kBookmarksKey = 'bookmarks_list_v2';

final bookmarksProvider =
    StateNotifierProvider<BookmarksNotifier, List<Bookmark>>(
  (ref) => BookmarksNotifier(),
);

// Provider for each bookmark type (only last bookmark per type)
final lastReadingBookmarkProvider = Provider<Bookmark?>((ref) {
  final bookmarks = ref.watch(bookmarksProvider);
  return bookmarks.where((b) => b.type == BookmarkType.reading).fold<Bookmark?>(
      null,
      (prev, curr) =>
          prev == null || curr.createdAt.isAfter(prev.createdAt) ? curr : prev);
});

final lastMemorizationBookmarkProvider = Provider<Bookmark?>((ref) {
  final bookmarks = ref.watch(bookmarksProvider);
  return bookmarks
      .where((b) => b.type == BookmarkType.memorization)
      .fold<Bookmark?>(
          null,
          (prev, curr) => prev == null || curr.createdAt.isAfter(prev.createdAt)
              ? curr
              : prev);
});

final lastReviewBookmarkProvider = Provider<Bookmark?>((ref) {
  final bookmarks = ref.watch(bookmarksProvider);
  return bookmarks.where((b) => b.type == BookmarkType.review).fold<Bookmark?>(
      null,
      (prev, curr) =>
          prev == null || curr.createdAt.isAfter(prev.createdAt) ? curr : prev);
});

class BookmarksNotifier extends StateNotifier<List<Bookmark>> {
  BookmarksNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kBookmarksKey);
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      state = list.map((e) => Bookmark.fromMap(e)).toList();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _kBookmarksKey, jsonEncode(state.map((b) => b.toMap()).toList()));
  }

  bool isBookmarked(int surahNumber, int ayahNumber, [BookmarkType? type]) {
    if (type != null) {
      return state.any((b) =>
          b.surahNumber == surahNumber &&
          b.ayahNumber == ayahNumber &&
          b.type == type);
    }
    return state
        .any((b) => b.surahNumber == surahNumber && b.ayahNumber == ayahNumber);
  }

  // Add bookmark with type - keeps only the last bookmark per type
  Future<void> addBookmark({
    required int surahNumber,
    required int ayahNumber,
    required String ayahText,
    required BookmarkType type,
    String? note,
  }) async {
    // Remove previous bookmark of the same type
    state = state.where((b) => b.type != type).toList();

    final bookmark = Bookmark(
      id: '${type.name}_${surahNumber}_$ayahNumber',
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      ayahText: ayahText,
      type: type,
      createdAt: DateTime.now(),
      note: note,
    );

    state = [...state, bookmark];
    await _save();
  }

  Future<void> removeBookmark(String id) async {
    state = state.where((b) => b.id != id).toList();
    await _save();
  }

  Future<void> removeBookmarkByType(BookmarkType type) async {
    state = state.where((b) => b.type != type).toList();
    await _save();
  }

  Future<void> toggleBookmark({
    required int surahNumber,
    required int ayahNumber,
    required String ayahText,
    required BookmarkType type,
  }) async {
    final existing = state.firstWhere(
      (b) => b.type == type,
      orElse: () => Bookmark(
        id: '',
        surahNumber: 0,
        ayahNumber: 0,
        ayahText: '',
        type: type,
        createdAt: DateTime.now(),
      ),
    );

    if (existing.id.isNotEmpty) {
      await removeBookmark(existing.id);
    }

    await addBookmark(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      ayahText: ayahText,
      type: type,
    );
  }

  Bookmark? getLastBookmarkOfType(BookmarkType type) {
    final bookmarksOfType = state.where((b) => b.type == type).toList();
    if (bookmarksOfType.isEmpty) return null;

    return bookmarksOfType.reduce(
        (prev, curr) => curr.createdAt.isAfter(prev.createdAt) ? curr : prev);
  }

  List<Bookmark> getBookmarksByType(BookmarkType type) {
    return state.where((b) => b.type == type).toList();
  }
}
