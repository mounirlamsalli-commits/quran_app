import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/download_service.dart';
import '../controllers/reader_controller.dart';
import '../providers/download_provider.dart';
import '../../../bookmarks/presentation/controllers/bookmarks_controller.dart';
import '../../../bookmarks/domain/entities/bookmark.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final int surahNumber;
  const ReaderScreen({super.key, required this.surahNumber});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  double _fontSize = 22;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('سورة ${widget.surahNumber}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: _showFontSizeSheet,
            tooltip: 'حجم الخط',
          ),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: AppColors.primary,
          indicatorColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'القرآن'),
            Tab(text: 'التفسير'),
            Tab(text: 'الترجمة'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _QuranTab(surahNumber: widget.surahNumber, fontSize: _fontSize),
          _TafseerTab(surahNumber: widget.surahNumber),
          _TranslationTab(surahNumber: widget.surahNumber),
        ],
      ),
      bottomNavigationBar: _AudioPlayerBar(surahNumber: widget.surahNumber),
    );
  }

  void _showFontSizeSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, set) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('حجم خط القرآن',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                style:
                    TextStyle(fontFamily: 'UthmanicHafs', fontSize: _fontSize),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
              Slider(
                min: 18,
                max: 36,
                divisions: 9,
                value: _fontSize,
                activeColor: AppColors.primary,
                onChanged: (v) {
                  set(() => _fontSize = v);
                  setState(() => _fontSize = v);
                },
              ),
              Text('${_fontSize.toInt()} px',
                  style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Quran Tab ─────────────────────────────────────────────────────────────────
class _QuranTab extends ConsumerWidget {
  final int surahNumber;
  final double fontSize;
  const _QuranTab({required this.surahNumber, required this.fontSize});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ayahsAsync = ref.watch(surahAyahsProvider(surahNumber));
    final currentAyah = ref.watch(currentAyahProvider);
    final isPlaying = ref.watch(isPlayingProvider);
    final readingBookmark = ref.watch(lastReadingBookmarkProvider);
    final memorizationBookmark = ref.watch(lastMemorizationBookmarkProvider);
    final reviewBookmark = ref.watch(lastReviewBookmarkProvider);

    // Check if current ayah is bookmarked with any type
    Bookmark? getBookmarkForAyah(int ayahNum) {
      if (readingBookmark?.surahNumber == surahNumber &&
          readingBookmark?.ayahNumber == ayahNum) {
        return readingBookmark;
      }
      if (memorizationBookmark?.surahNumber == surahNumber &&
          memorizationBookmark?.ayahNumber == ayahNum) {
        return memorizationBookmark;
      }
      if (reviewBookmark?.surahNumber == surahNumber &&
          reviewBookmark?.ayahNumber == ayahNum) {
        return reviewBookmark;
      }
      return null;
    }

    return ayahsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorWidget(
        message: '$e',
        onRetry: () => ref.invalidate(surahAyahsProvider(surahNumber)),
      ),
      data: (ayahs) => ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        itemCount: ayahs.length,
        itemBuilder: (context, i) {
          final ayah = ayahs[i];
          final isCurrentlyPlaying =
              ayah.numberInSurah == currentAyah && isPlaying;
          final bookmark = getBookmarkForAyah(ayah.numberInSurah);
          final isBookmarked = bookmark != null;

          return GestureDetector(
            onTap: () => ref.read(currentAyahProvider.notifier).state =
                ayah.numberInSurah,
            onLongPress: () => _showAyahMenu(
                context, ref, ayah.numberInSurah, ayah.textUthmani),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isCurrentlyPlaying
                    ? AppColors.primary.withOpacity(0.08)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isCurrentlyPlaying
                      ? AppColors.primary.withOpacity(0.4)
                      : AppColors.primary.withOpacity(0.07),
                ),
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCurrentlyPlaying
                                ? AppColors.primary
                                : AppColors.primary.withOpacity(0.1),
                          ),
                          child: Center(
                            child: Text(
                              '${ayah.numberInSurah}',
                              style: TextStyle(
                                fontSize: 11,
                                color: isCurrentlyPlaying
                                    ? Colors.white
                                    : AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => _showBookmarkTypeSelector(
                            context,
                            ref,
                            ayah.numberInSurah,
                            ayah.textUthmani,
                          ),
                          child: Icon(
                            isBookmarked
                                ? (bookmark?.type == BookmarkType.memorization
                                    ? Icons.school
                                    : bookmark?.type == BookmarkType.review
                                        ? Icons.refresh
                                        : Icons.menu_book)
                                : Icons.bookmark_outline,
                            size: 16,
                            color: isBookmarked
                                ? AppColors.primary
                                : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        ayah.textUthmani,
                        style: TextStyle(
                          fontFamily: 'UthmanicHafs',
                          fontSize: fontSize,
                          height: 2.2,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAyahMenu(
      BuildContext context, WidgetRef ref, int ayahNumber, String text) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.menu_book_outlined,
                  color: AppColors.secondary),
              title: const Text('التفسير'),
              onTap: () {
                Navigator.pop(context);
                _showAyahTafseer(context, ayahNumber);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.share_outlined, color: AppColors.secondary),
              title: const Text('مشاركة'),
              onTap: () {
                Navigator.pop(context);
                Share.share(
                  '﴿$text﴾ [سورة ${surahNumber}: $ayahNumber]',
                  subject: 'مشاركة آية من القرآن الكريم',
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.download_outlined,
                  color: AppColors.secondary),
              title: const Text('تحميل الصوت'),
              onTap: () {
                Navigator.pop(context);
                _downloadAyahAudio(context, ref, ayahNumber);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_add_outlined,
                  color: AppColors.primary),
              title: const Text('إضافة إشارة'),
              onTap: () {
                Navigator.pop(context);
                _showBookmarkTypeSelector(context, ref, ayahNumber, text);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBookmarkTypeSelector(
      BuildContext context, WidgetRef ref, int ayahNumber, String text) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'اختر نوع الإشارة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.menu_book, color: Colors.blue),
              title: const Text('إشارة التلاوة'),
              subtitle: const Text('آخر موضع وصلت إليه في التلاوة'),
              onTap: () {
                Navigator.pop(context);
                ref.read(bookmarksProvider.notifier).addBookmark(
                      surahNumber: surahNumber,
                      ayahNumber: ayahNumber,
                      ayahText: text,
                      type: BookmarkType.reading,
                    );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تحديث إشارة التلاوة'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.school, color: Colors.green),
              title: const Text('إشارة الحفظ'),
              subtitle: const Text('الآية التي تحفظها حالياً'),
              onTap: () {
                Navigator.pop(context);
                ref.read(bookmarksProvider.notifier).addBookmark(
                      surahNumber: surahNumber,
                      ayahNumber: ayahNumber,
                      ayahText: text,
                      type: BookmarkType.memorization,
                    );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تحديث إشارة الحفظ'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.refresh, color: Colors.orange),
              title: const Text('إشارة المراجعة'),
              subtitle: const Text('الآية التي تراجعها'),
              onTap: () {
                Navigator.pop(context);
                ref.read(bookmarksProvider.notifier).addBookmark(
                      surahNumber: surahNumber,
                      ayahNumber: ayahNumber,
                      ayahText: text,
                      type: BookmarkType.review,
                    );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تحديث إشارة المراجعة'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAyahTafseer(BuildContext context, int ayahNumber) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollController) => Consumer(
          builder: (context, ref, _) {
            final tafseerAsync = ref.watch(tafseerByAyahProvider(
                {'surah': surahNumber, 'ayah': ayahNumber}));
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'التفسير - سورة $surahNumber: $ayahNumber',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Expanded(
                    child: tafseerAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('خطأ: $e')),
                      data: (tafseer) => SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          tafseer.isNotEmpty
                              ? tafseer
                              : 'لا يوجد تفسير متاح لهذه الآية',
                          style: const TextStyle(fontSize: 16, height: 1.8),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _downloadAyahAudio(
      BuildContext context, WidgetRef ref, int ayahNumber) async {
    final downloadService = ref.read(downloadServiceProvider);
    const reciterId = 1; // Default reciter ID for mp3quran.net

    // Build audio URL using the working mp3quran.net format
    final paddedSurah = surahNumber.toString().padLeft(3, '0');
    final paddedAyah = ayahNumber.toString().padLeft(3, '0');
    final audioUrl =
        'https://server7.mp3quran.net/afs/$paddedSurah$paddedAyah.mp3';

    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        content: Text('جاري تحميل الصوت...'),
        duration: Duration(seconds: 1),
      ),
    );

    final path = await downloadService.downloadAudio(
      audioUrl,
      surahNumber,
      ayahNumber,
      reciterId,
      onProgress: (progress) {
        // Progress could be shown here if needed
      },
    );

    if (path != null) {
      scaffold.showSnackBar(
        const SnackBar(
          content: Text('تم تحميل الصوت بنجاح'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      scaffold.showSnackBar(
        const SnackBar(
          content: Text('فشل تحميل الصوت'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

// ── Tafseer Tab ───────────────────────────────────────────────────────────────
class _TafseerTab extends ConsumerWidget {
  final int surahNumber;
  const _TafseerTab({required this.surahNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tafseerAsync = ref.watch(tafseerProvider(surahNumber));

    return tafseerAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorWidget(
        message: '$e',
        onRetry: () => ref.invalidate(tafseerProvider(surahNumber)),
      ),
      data: (verses) {
        if (verses.isEmpty)
          return const Center(child: Text('لا يوجد تفسير متاح'));
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: verses.length,
          itemBuilder: (context, i) {
            final verse = verses[i];
            final tafsirs = verse['tafsirs'] as List?;
            final text = tafsirs != null && tafsirs.isNotEmpty
                ? (tafsirs.first['text'] ?? '')
                    .toString()
                    .replaceAll(RegExp(r'<[^>]*>'), '')
                    .trim()
                : '';
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'آية ${verse['verse_number']}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 8),
                  text.isEmpty
                      ? Text('لا يوجد تفسير لهذه الآية',
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 13))
                      : Text(
                          text,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(height: 1.9),
                          textDirection: TextDirection.rtl,
                        ),
                  const Divider(height: 28),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ── Translation Tab ───────────────────────────────────────────────────────────
class _TranslationTab extends ConsumerWidget {
  final int surahNumber;
  const _TranslationTab({required this.surahNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ayahsAsync = ref.watch(surahAyahsProvider(surahNumber));
    final translAsync = ref.watch(translationProvider(surahNumber));

    return ayahsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (ayahs) => translAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorWidget(
          message: '$e',
          onRetry: () => ref.invalidate(translationProvider(surahNumber)),
        ),
        data: (transl) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: ayahs.length,
          itemBuilder: (context, i) {
            if (i >= transl.length) return const SizedBox();
            final ayah = ayahs[i];
            final translations = transl[i]['translations'] as List?;
            final translText = translations != null && translations.isNotEmpty
                ? (translations.first['text'] ?? '')
                    .toString()
                    .replaceAll(RegExp(r'<[^>]*>'), '')
                    .trim()
                : '';
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'آية ${ayah.numberInSurah}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.secondary),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ayah.textUthmani,
                    style: const TextStyle(
                        fontFamily: 'UthmanicHafs', fontSize: 20, height: 2.2),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    translText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.65),
                          height: 1.6,
                        ),
                  ),
                  const Divider(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Audio Player Bar ──────────────────────────────────────────────────────────
class _AudioPlayerBar extends ConsumerWidget {
  final int surahNumber;
  const _AudioPlayerBar({required this.surahNumber});

  static const Map<int, String> _reciters = {
    7: 'مصطفى إسماعيل',
    1: 'عبد الباسط',
    5: 'الحصري',
    12: 'العفاسي',
    9: 'الغامدي',
    3: 'محمد أيوب',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaying = ref.watch(isPlayingProvider);
    final currentAyah = ref.watch(currentAyahProvider);
    final selectedReciter = ref.watch(selectedReciterProvider);
    final reciterName =
        AppConstants.reciters[selectedReciter] ?? selectedReciter;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.skip_previous_rounded),
              iconSize: 22,
              onPressed: currentAyah > 1
                  ? () => ref.read(currentAyahProvider.notifier).state =
                      currentAyah - 1
                  : null,
            ),
            GestureDetector(
              onTap: () =>
                  ref.read(isPlayingProvider.notifier).state = !isPlaying,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.12),
                ),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.skip_next_rounded),
              iconSize: 22,
              onPressed: () => ref.read(currentAyahProvider.notifier).state =
                  currentAyah + 1,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(reciterName,
                      style: Theme.of(context).textTheme.labelMedium),
                  Text('آية $currentAyah',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: AppColors.primary)),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.person_outline, size: 20),
              tooltip: 'اختر القارئ',
              onSelected: (v) {
                ref.read(selectedReciterProvider.notifier).state = v;
              },
              itemBuilder: (_) => AppConstants.reciters.entries
                  .map((e) => PopupMenuItem(
                        value: e.key,
                        child: Row(
                          children: [
                            if (e.key == selectedReciter)
                              const Icon(Icons.check,
                                  size: 16, color: AppColors.primary),
                            if (e.key != selectedReciter)
                              const SizedBox(width: 16),
                            const SizedBox(width: 8),
                            Text(e.value),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error Widget ──────────────────────────────────────────────────────────────
class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              'تعذّر تحميل البيانات',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
