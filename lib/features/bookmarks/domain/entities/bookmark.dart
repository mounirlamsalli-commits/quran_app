import 'package:equatable/equatable.dart';

class Bookmark extends Equatable {
  final String id;
  final int surahNumber;
  final String surahName;
  final int ayahNumber;
  final String ayahText;
  final DateTime createdAt;
  final String? note;
  final int? juzNumber;
  final int? pageNumber;
  final String folderId;

  const Bookmark({
    required this.id,
    required this.surahNumber,
    required this.surahName,
    required this.ayahNumber,
    required this.ayahText,
    required this.createdAt,
    this.note,
    this.juzNumber,
    this.pageNumber,
    this.folderId = '',
  });

  Bookmark copyWith({
    String? id, int? surahNumber, String? surahName, int? ayahNumber,
    String? ayahText, DateTime? createdAt, String? note, int? juzNumber, int? pageNumber, String? folderId,
  }) {
    return Bookmark(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      surahName: surahName ?? this.surahName,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      ayahText: ayahText ?? this.ayahText,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
      juzNumber: juzNumber ?? this.juzNumber,
      pageNumber: pageNumber ?? this.pageNumber,
      folderId: folderId ?? this.folderId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'surahNumber': surahNumber,
      'surahName': surahName,
      'ayahNumber': ayahNumber,
      'ayahText': ayahText,
      'createdAt': createdAt.toIso8601String(),
      'note': note,
      'juzNumber': juzNumber,
      'pageNumber': pageNumber,
      'folderId': folderId,
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      id: map['id'] ?? '',
      surahNumber: map['surahNumber'] ?? 1,
      surahName: map['surahName'] ?? '',
      ayahNumber: map['ayahNumber'] ?? 1,
      ayahText: map['ayahText'] ?? '',
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      note: map['note'],
      juzNumber: map['juzNumber'],
      pageNumber: map['pageNumber'],
      folderId: map['folderId'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id];
}

class BookmarkFolder extends Equatable {
  final String id;
  final String name;
  final DateTime createdAt;

  const BookmarkFolder({required this.id, required this.name, required this.createdAt});

  @override
  List<Object?> get props => [id];
}