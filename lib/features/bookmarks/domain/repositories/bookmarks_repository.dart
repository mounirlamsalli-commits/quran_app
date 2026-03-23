import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/bookmark.dart';

abstract class BookmarksRepository {
  Future<Either<Failure, List<Bookmark>>> getAllBookmarks();
  Future<Either<Failure, List<Bookmark>>> getBookmarksBySurah(int surahNumber);
  Future<Either<Failure, void>> addBookmark(Bookmark bookmark);
  Future<Either<Failure, void>> removeBookmark(String id);
  Future<Either<Failure, void>> updateBookmark(Bookmark bookmark);
  Future<Either<Failure, Bookmark?>> getLastReadBookmark();
  Future<Either<Failure, void>> setLastRead(Bookmark bookmark);
}