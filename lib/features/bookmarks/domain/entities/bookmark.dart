import 'package:equatable/equatable.dart';

enum BookmarkType {
  reading, // إشارة التلاوة
  memorization, // إشارة الحفظ
  review, // إشارة المراجعة
}

extension BookmarkTypeExtension on BookmarkType {
  String get displayName {
    switch (this) {
      case BookmarkType.reading:
        return 'تلاوة';
      case BookmarkType.memorization:
        return 'حفظ';
      case BookmarkType.review:
        return 'مراجعة';
    }
  }

  String get iconName {
    switch (this) {
      case BookmarkType.reading:
        return 'reading';
      case BookmarkType.memorization:
        return 'memorization';
      case BookmarkType.review:
        return 'review';
    }
  }
}

class Bookmark extends Equatable {
  final String id;
  final int surahNumber;
  final int ayahNumber;
  final String ayahText;
  final BookmarkType type;
  final DateTime createdAt;
  final String? note;

  const Bookmark({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.ayahText,
    required this.type,
    required this.createdAt,
    this.note,
  });

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      id: map['id'] ?? '',
      surahNumber: map['surahNumber'] ?? 1,
      ayahNumber: map['ayahNumber'] ?? 1,
      ayahText: map['ayahText'] ?? '',
      type: BookmarkType.values.firstWhere(
        (e) => e.name == (map['type'] ?? 'reading'),
        orElse: () => BookmarkType.reading,
      ),
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
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'note': note,
    };
  }

  Bookmark copyWith({
    String? id,
    int? surahNumber,
    int? ayahNumber,
    String? ayahText,
    BookmarkType? type,
    DateTime? createdAt,
    String? note,
  }) {
    return Bookmark(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      ayahText: ayahText ?? this.ayahText,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [id];
}
