import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/bookmarks_controller.dart';
import '../../domain/entities/bookmark.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingBookmark = ref.watch(lastReadingBookmarkProvider);
    final memorizationBookmark = ref.watch(lastMemorizationBookmarkProvider);
    final reviewBookmark = ref.watch(lastReviewBookmarkProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشارات المرجعية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'حذف الكل',
            onPressed: () => _confirmDeleteAll(context, ref),
          ),
        ],
      ),
      body: readingBookmark == null &&
              memorizationBookmark == null &&
              reviewBookmark == null
          ? const _EmptyBookmarks()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (readingBookmark != null)
                  _BookmarkCard(
                    bookmark: readingBookmark,
                    type: BookmarkType.reading,
                    color: Colors.blue,
                    icon: Icons.menu_book,
                    title: 'إشارة التلاوة',
                    subtitle: 'آخر موضع وصلت إليه في التلاوة',
                  ),
                if (memorizationBookmark != null)
                  _BookmarkCard(
                    bookmark: memorizationBookmark,
                    type: BookmarkType.memorization,
                    color: Colors.green,
                    icon: Icons.school,
                    title: 'إشارة الحفظ',
                    subtitle: 'الآية التي تحفظها حالياً',
                  ),
                if (reviewBookmark != null)
                  _BookmarkCard(
                    bookmark: reviewBookmark,
                    type: BookmarkType.review,
                    color: Colors.orange,
                    icon: Icons.refresh,
                    title: 'إشارة المراجعة',
                    subtitle: 'الآية التي تراجعها',
                  ),
              ],
            ),
    );
  }

  void _confirmDeleteAll(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف جميع الإشارات'),
        content: const Text('هل أنت متأكد من حذف جميع الإشارات المرجعية؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(bookmarksProvider.notifier)
                  .removeBookmarkByType(BookmarkType.reading);
              ref
                  .read(bookmarksProvider.notifier)
                  .removeBookmarkByType(BookmarkType.memorization);
              ref
                  .read(bookmarksProvider.notifier)
                  .removeBookmarkByType(BookmarkType.review);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _EmptyBookmarks extends StatelessWidget {
  const _EmptyBookmarks();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_outline,
              size: 72, color: AppColors.primary.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text('لا توجد إشارات مرجعية بعد',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'اضغط على أيقونة الإشارة في أي آية لإضافة إشارة',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _BookmarkCard extends ConsumerWidget {
  final Bookmark bookmark;
  final BookmarkType type;
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;

  const _BookmarkCard({
    required this.bookmark,
    required this.type,
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () =>
            context.go('${AppRoutes.surahList}/${bookmark.surahNumber}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      ref
                          .read(bookmarksProvider.notifier)
                          .removeBookmarkByType(type);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('تمت إزالة $title'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'سورة ${bookmark.surahNumber} - آية ${bookmark.ayahNumber}',
                      style: TextStyle(
                          fontSize: 12,
                          color: color,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    _formatDate(bookmark.createdAt),
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                bookmark.ayahText,
                style: const TextStyle(
                    fontFamily: 'UthmanicHafs', fontSize: 20, height: 2),
                textDirection: TextDirection.rtl,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
