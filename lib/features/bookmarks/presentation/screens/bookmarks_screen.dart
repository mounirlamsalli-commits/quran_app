import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../presentation/controllers/bookmarks_controller.dart';
import '../../domain/entities/bookmark.dart';

class BookmarksScreen extends ConsumerStatefulWidget {
  const BookmarksScreen({super.key});
  @override
  ConsumerState<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen> {
  @override
  Widget build(BuildContext context) {
    final bookmarksAsync = ref.watch(bookmarksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشارات المرجعية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortDialog(context),
          ),
        ],
      ),
      body: bookmarksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text('خطأ: $e'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => ref.read(bookmarksProvider.notifier).load(),
              child: const Text('إعادة المحاولة')),
          ]),
        ),
        data: (bookmarks) => bookmarks.isEmpty
            ? const Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.bookmark_outline, size: 64, color: AppColors.primary),
                  SizedBox(height: 16),
                  Text('لا توجد إشارات مرجعية بعد'),
                  SizedBox(height: 8),
                  Text('اضغط على أيقونة الإشارة أثناء القراءة لإضافتها', style: TextStyle(color: AppColors.secondary)),
                ]),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookmarks.length,
                itemBuilder: (context, i) => _BookmarkCard(bookmark: bookmarks[i]),
              ),
      ),
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('ترتيب حسب'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(title: const Text('الأحدث'), onTap: () => Navigator.pop(context)),
          ListTile(title: const Text('الأقدم'), onTap: () => Navigator.pop(context)),
          ListTile(title: const Text('السورة'), onTap: () => Navigator.pop(context)),
          ListTile(title: const Text('الصفحة'), onTap: () => Navigator.pop(context)),
        ]),
      ),
    );
  }
}

class _BookmarkCard extends ConsumerWidget {
  final Bookmark bookmark;
  const _BookmarkCard({required this.bookmark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/quran/${bookmark.surahNumber}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text('سورة ${bookmark.surahName} - آية ${bookmark.ayahNumber}',
                  style: const TextStyle(fontSize: 12, color: AppColors.secondary)),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 20),
                onSelected: (v) {
                  if (v == 'delete') ref.read(bookmarksProvider.notifier).remove(bookmark.id);
                  if (v == 'edit') _showEditNoteDialog(context, ref);
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text('تعديل الملاحظة')),
                  const PopupMenuItem(value: 'delete', child: Text('حذف', style: TextStyle(color: AppColors.error))),
                ],
              ),
            ]),
            const SizedBox(height: 8),
            Text(bookmark.ayahText,
              style: TextStyle(fontFamily: 'UthmanicHafs', fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
              textDirection: TextDirection.rtl, maxLines: 2, overflow: TextOverflow.ellipsis),
            if (bookmark.note != null && bookmark.note!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
                child: Row(children: [
                  Icon(Icons.note, size: 16, color: AppColors.primary.withOpacity(0.7)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(bookmark.note!, style: TextStyle(fontSize: 12, color: AppColors.primary.withOpacity(0.8)))),
                ]),
              ),
            ],
            const SizedBox(height: 8),
            Text(_formatDate(bookmark.createdAt), style: Theme.of(context).textTheme.labelSmall),
          ]),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day}/${d.month}/${d.year}';
  }

  void _showEditNoteDialog(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController(text: bookmark.note);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تعديل الملاحظة'),
        content: TextField(controller: ctrl, maxLines: 3, decoration: const InputDecoration(hintText: 'أضف ملاحظة...')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              ref.read(bookmarksProvider.notifier).update(bookmark.copyWith(note: ctrl.text));
              Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}