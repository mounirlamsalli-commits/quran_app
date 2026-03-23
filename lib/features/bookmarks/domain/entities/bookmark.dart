import 'package:equatable/equatable.dart';

class Bookmark extends Equatable {
  final String id;
  final int surahNumber;
  final int ayahNumber;
  final String ayahText;
  final String customName;
  final String folderId;
  final DateTime createdAt;
  final String? note;

  const Bookmark({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.ayahText,
    required this.customName,
    required this.folderId,
    required this.createdAt,
    this.note,
  });

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      id: map['id'] ?? '',
      surahNumber: map['surahNumber'] ?? 1,
      ayahNumber: map['ayahNumber'] ?? 1,
      ayahText: map['ayahText'] ?? '',
      customName: map['customName'] ?? '',
      folderId: map['folderId'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      note: map['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'ayahText': ayahText,
      'customName': customName,
      'folderId': folderId,
      'createdAt': createdAt.toIso8601String(),
      'note': note,
    };
  }

  Bookmark copyWith({
    String? id,
    int? surahNumber,
    int? ayahNumber,
    String? ayahText,
    String? customName,
    String? folderId,
    DateTime? createdAt,
    String? note,
  }) {
    return Bookmark(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      ayahText: ayahText ?? this.ayahText,
      customName: customName ?? this.customName,
      folderId: folderId ?? this.folderId,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [id];
}

class BookmarkFolder extends Equatable {
  final String id;
  final String name;
  final DateTime createdAt;

  const BookmarkFolder({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}
