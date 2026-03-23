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
    final bookmarks = ref.watch(bookmarksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشارات المرجعية'),
        actions: [
          if (bookmarks.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'حذف الكل',
              onPressed: () => _confirmDeleteAll(context, ref),
            ),
        ],
      ),
      body: bookmarks.isEmpty
          ? const _EmptyBookmarks()
          : _BookmarksList(bookmarks: bookmarks),
    );
  }

  void _confirmDeleteAll(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف جميع الإشارات'),
        content: const Text('هل أنت متأكد من حذف جميع الإشارات المرجعية؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              for (final b in ref.read(bookmarksProvider)) {
                ref.read(bookmarksProvider.notifier).removeBookmark(b.surahNumber, b.ayahNumber);
              }
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
          Icon(Icons.bookmark_outline, size: 72, color: AppColors.primary.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text('لا توجد إشارات مرجعية بعد',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'اضغط مطولاً على أي آية في شاشة القراءة لإضافة إشارة',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _BookmarksList extends ConsumerWidget {
  final List<Bookmark> bookmarks;
  const _BookmarksList({required this.bookmarks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sorted = [...bookmarks]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: sorted.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final b = sorted[i];
        return Dismissible(
          key: Key(b.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            ref.read(bookmarksProvider.notifier).removeBookmark(b.surahNumber, b.ayahNumber);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تمت إزالة الإشارة'), duration: Duration(seconds: 2)),
            );
          },
          child: InkWell(
            onTap: () => context.go('${AppRoutes.surahList}/${b.surahNumber}'),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'سورة ${b.surahNumber} - آية ${b.ayahNumber}',
                          style: const TextStyle(fontSize: 11, color: AppColors.primary),
                        ),
                      ),
                      const Icon(Icons.bookmark, size: 16, color: AppColors.primary),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    b.ayahText,
                    style: const TextStyle(fontFamily: 'UthmanicHafs', fontSize: 18, height: 1.9),
                    textDirection: TextDirection.rtl,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    b.customName,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}