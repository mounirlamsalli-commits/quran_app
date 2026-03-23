import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/bookmark.dart';
import '../../data/repositories/bookmarks_repository_impl.dart';

final bookmarksProvider = StateNotifierProvider<BookmarksNotifier, AsyncValue<List<Bookmark>>>((ref) {
  return BookmarksNotifier();
});

class BookmarksNotifier extends StateNotifier<AsyncValue<List<Bookmark>>> {
  BookmarksNotifier() : super(const AsyncValue.loading()) { load(); }

  Future<void> load() async {
    state = const AsyncValue.loading();
    final repo = BookmarksRepositoryImpl();
    final result = await repo.getAllBookmarks();
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (bookmarks) => state = AsyncValue.data(bookmarks),
    );
  }

  Future<void> add(Bookmark bookmark) async {
    final repo = BookmarksRepositoryImpl();
    await repo.addBookmark(bookmark);
    await load();
  }

  Future<void> remove(String id) async {
    final repo = BookmarksRepositoryImpl();
    await repo.removeBookmark(id);
    await load();
  }

  Future<void> update(Bookmark bookmark) async {
    final repo = BookmarksRepositoryImpl();
    await repo.updateBookmark(bookmark);
    await load();
  }
}

final lastReadProvider = StateNotifierProvider<LastReadNotifier, Bookmark?>((ref) {
  return LastReadNotifier();
});

class LastReadNotifier extends StateNotifier<Bookmark?> {
  LastReadNotifier() : super(null) { load(); }

  Future<void> load() async {
    final repo = BookmarksRepositoryImpl();
    final result = await repo.getLastReadBookmark();
    result.fold((_) {}, (bookmark) => state = bookmark);
  }

  Future<void> set(Bookmark bookmark) async {
    final repo = BookmarksRepositoryImpl();
    await repo.setLastRead(bookmark);
    state = bookmark;
  }
}