import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/repositories/bookmarks_repository.dart';

@LazySingleton(as: BookmarksRepository)
class BookmarksRepositoryImpl implements BookmarksRepository {
  late Box<Map> _box;

  BookmarksRepositoryImpl() { _init(); }

  Future<void> _init() async {
    _box = await Hive.openBox<Map>(AppConstants.bookmarksBox);
  }

  String _generateId() => DateTime.now().millisecondsSinceEpoch.toString();

  @override
  Future<Either<Failure, List<Bookmark>>> getAllBookmarks() async {
    try {
      final bookmarks = _box.values.map((e) => Bookmark.fromMap(Map<String, dynamic>.from(e))).toList();
      bookmarks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Right(bookmarks);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Bookmark>>> getBookmarksBySurah(int surahNumber) async {
    try {
      final bookmarks = _box.values
          .map((e) => Bookmark.fromMap(Map<String, dynamic>.from(e)))
          .where((b) => b.surahNumber == surahNumber)
          .toList();
      return Right(bookmarks);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addBookmark(Bookmark bookmark) async {
    try {
      final id = bookmark.id.isEmpty ? _generateId() : bookmark.id;
      await _box.put(id, bookmark.copyWith(id: id).toMap());
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeBookmark(String id) async {
    try {
      await _box.delete(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateBookmark(Bookmark bookmark) async {
    try {
      await _box.put(bookmark.id, bookmark.toMap());
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Bookmark?>> getLastReadBookmark() async {
    try {
      final box = await Hive.openBox<dynamic>(AppConstants.settingsBox);
      final data = box.get('lastRead') as Map<dynamic, dynamic>?;
      if (data == null) return const Right(null);
      return Right(Bookmark.fromMap(Map<String, dynamic>.from(data)));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setLastRead(Bookmark bookmark) async {
    try {
      final box = await Hive.openBox<dynamic>(AppConstants.settingsBox);
      await box.put('lastRead', bookmark.toMap());
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}