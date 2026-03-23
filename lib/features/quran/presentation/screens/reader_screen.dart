import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/reader_controller.dart';
import '../../../audio/presentation/controllers/audio_controller.dart' as audio;
import 'package:just_audio/just_audio.dart';
import '../../../../core/constants/app_constants.dart';

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
              onPressed: _showFontSizeSheet),
          IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: _showSettingsSheet),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: AppColors.primary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'القرآن'),
            Tab(text: 'التفسير'),
            Tab(text: 'الترجمة')
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
              Text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                  style: TextStyle(
                      fontFamily: 'UthmanicHafs', fontSize: _fontSize),
                  textDirection: TextDirection.rtl),
              Slider(
                  min: 18,
                  max: 40,
                  divisions: 11,
                  value: _fontSize,
                  activeColor: AppColors.primary,
                  onChanged: (v) {
                    set(() => _fontSize = v);
                    setState(() => _fontSize = v);
                  }),
              Text('${_fontSize.toInt()} px',
                  style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (ctx, scrollCtrl) => Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(controller: scrollCtrl, children: [
            Text('إعدادات القراءة',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildReciterSelector(),
            const Divider(height: 24),
            _buildTafseerSelector(),
            const Divider(height: 24),
            _buildTranslationSelector(),
          ]),
        ),
      ),
    );
  }

  Widget _buildReciterSelector() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('القارئ', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 8),
      Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.reciters.entries
              .map(
                (e) => ChoiceChip(
                  label: Text(e.value, style: const TextStyle(fontSize: 12)),
                  selected: ref.watch(selectedReciterProvider) == e.key,
                  onSelected: (_) =>
                      ref.read(selectedReciterProvider.notifier).state = e.key,
                ),
              )
              .toList()),
    ]);
  }

  Widget _buildTafseerSelector() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('التفسير', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 8),
      Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.tafseers.entries
              .map(
                (e) => ChoiceChip(
                  label: Text(e.value.split(' - ').first,
                      style: const TextStyle(fontSize: 12)),
                  selected: ref.watch(selectedTafseerProvider) == e.key,
                  onSelected: (_) {
                    ref.read(selectedTafseerProvider.notifier).state = e.key;
                    ref.invalidate(tafseerProvider(widget.surahNumber));
                  },
                ),
              )
              .toList()),
    ]);
  }

  Widget _buildTranslationSelector() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('الترجمة', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 8),
      Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.translations.entries
              .map(
                (e) => ChoiceChip(
                  label: Text(e.value.split(' - ').last,
                      style: const TextStyle(fontSize: 12)),
                  selected: ref.watch(selectedTranslationProvider) == e.key,
                  onSelected: (_) {
                    ref.read(selectedTranslationProvider.notifier).state =
                        e.key;
                    ref.invalidate(translationProvider(widget.surahNumber));
                  },
                ),
              )
              .toList()),
    ]);
  }
}

class _QuranTab extends ConsumerWidget {
  final int surahNumber;
  final double fontSize;
  const _QuranTab({required this.surahNumber, required this.fontSize});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ayahsAsync = ref.watch(surahAyahsProvider(surahNumber));
    final currentAyah = ref.watch(currentAyahProvider);
    return ayahsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.error_outline, size: 48, color: AppColors.error),
        const SizedBox(height: 12),
        Text('خطأ في تحميل الآيات',
            style: Theme.of(context).textTheme.bodyLarge),
        TextButton(
            onPressed: () => ref.invalidate(surahAyahsProvider(surahNumber)),
            child: const Text('إعادة المحاولة')),
      ])),
      data: (ayahs) => ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemCount: ayahs.length,
        itemBuilder: (context, i) {
          final ayah = ayahs[i];
          final isPlaying =
              ayah.numberInSurah == currentAyah && ref.watch(isPlayingProvider);
          return GestureDetector(
            onTap: () => ref.read(currentAyahProvider.notifier).state =
                ayah.numberInSurah,
            child: Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isPlaying
                    ? AppColors.primary.withOpacity(0.08)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: isPlaying
                        ? AppColors.primary.withOpacity(0.4)
                        : AppColors.primary.withOpacity(0.08)),
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isPlaying
                              ? AppColors.primary
                              : AppColors.primary.withOpacity(0.12)),
                      child: Center(
                          child: Text('${ayah.numberInSurah}',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: isPlaying
                                      ? Colors.white
                                      : AppColors.primary,
                                  fontWeight: FontWeight.w600))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(ayah.textUthmani,
                            style: TextStyle(
                                fontFamily: 'UthmanicHafs',
                                fontSize: fontSize,
                                height: 2.2),
                            textDirection: TextDirection.rtl)),
                    if (ayah.isSajdah) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.do_not_disturb,
                          size: 20, color: AppColors.secondary),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TafseerTab extends ConsumerWidget {
  final int surahNumber;
  const _TafseerTab({required this.surahNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tafseerAsync = ref.watch(tafseerProvider(surahNumber));
    final tafseerId = ref.watch(selectedTafseerProvider);
    final tafseerName = AppConstants.tafseers[tafseerId] ?? 'التفسير';

    return Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Theme.of(context).colorScheme.surface,
        child: Row(children: [
          Icon(Icons.menu_book, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(tafseerName.split(' - ').first,
              style: Theme.of(context).textTheme.labelMedium),
        ]),
      ),
      Expanded(
          child: tafseerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 12),
          Text('خطأ في تحميل التفسير'),
          TextButton(
              onPressed: () => ref.invalidate(tafseerProvider(surahNumber)),
              child: const Text('إعادة المحاولة')),
        ])),
        data: (tafsirs) => tafsirs.isEmpty
            ? const Center(child: Text('لا يوجد تفسير متاح'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tafsirs.length,
                itemBuilder: (context, i) {
                  final t = tafsirs[i];
                  final text = (t['text'] ?? '').toString().trim();
                  final ayahNum = t['ayah_number'] ?? 0;
                  final verseKey = t['verse_key'] ?? '';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20)),
                            child: Text('آية $ayahNum',
                                style: const TextStyle(
                                    fontSize: 12, color: AppColors.primary)),
                          ),
                          const SizedBox(height: 8),
                          Text(text,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(height: 1.8),
                              textDirection: TextDirection.rtl),
                          const Divider(height: 28),
                        ]),
                  );
                },
              ),
      )),
    ]);
  }
}

class _TranslationTab extends ConsumerWidget {
  final int surahNumber;
  const _TranslationTab({required this.surahNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ayahsAsync = ref.watch(surahAyahsProvider(surahNumber));
    final translAsync = ref.watch(translationProvider(surahNumber));
    final translationId = ref.watch(selectedTranslationProvider);
    final translationName =
        AppConstants.translations[translationId] ?? 'Translation';

    return Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Theme.of(context).colorScheme.surface,
        child: Row(children: [
          Icon(Icons.translate, size: 18, color: AppColors.secondary),
          const SizedBox(width: 8),
          Text(translationName, style: Theme.of(context).textTheme.labelMedium),
        ]),
      ),
      Expanded(
          child: ayahsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (ayahs) => translAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                const Icon(Icons.error_outline,
                    size: 48, color: AppColors.error),
                const SizedBox(height: 12),
                Text('خطأ في تحميل الترجمة'),
                TextButton(
                    onPressed: () =>
                        ref.invalidate(translationProvider(surahNumber)),
                    child: const Text('إعادة المحاولة')),
              ])),
          data: (transl) => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ayahs.length,
            itemBuilder: (context, i) {
              final ayah = ayahs[i];
              final translText =
                  i < transl.length ? (transl[i]['text'] ?? '') : '';
              final ayahNum = ayah.numberInSurah;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text('آية $ayahNum',
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.secondary)),
                      ),
                      const SizedBox(height: 8),
                      Text(ayah.textUthmani,
                          style: const TextStyle(
                              fontSize: 20, fontFamily: 'UthmanicHafs'),
                          textDirection: TextDirection.rtl),
                      const SizedBox(height: 8),
                      Text(translText,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: AppColors.secondary, height: 1.7),
                          textDirection: TextDirection.rtl),
                      const Divider(height: 28),
                    ]),
              );
            },
          ),
        ),
      )),
    ]);
  }
}

class _AudioPlayerBar extends ConsumerWidget {
  final int surahNumber;
  const _AudioPlayerBar({required this.surahNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaying = ref.watch(isPlayingProvider);
    final currentAyah = ref.watch(currentAyahProvider);
    final selectedReciter = ref.watch(selectedReciterProvider);
    final reciterName = AppConstants.reciters[selectedReciter] ?? 'القارئ';
    final player = ref.watch(audio.audioPlayerProvider);

    Future<void> playAyah() async {
      final url = getAudioUrl(selectedReciter, surahNumber, currentAyah);
      try {
        await player.setUrl(url);
        await player.setSpeed(ref.read(audioSpeedProvider));
        await player.play();
        ref.read(isPlayingProvider.notifier).state = true;
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('تعذر تشغيل التلاوة - جرب قارئ آخر')));
        }
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(children: [
        IconButton(
            icon: const Icon(Icons.skip_previous_rounded),
            onPressed: currentAyah > 1
                ? () => ref.read(currentAyahProvider.notifier).state =
                    currentAyah - 1
                : null),
        GestureDetector(
          onTap: () async {
            if (isPlaying) {
              await player.pause();
              ref.read(isPlayingProvider.notifier).state = false;
            } else {
              await playAyah();
            }
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.12)),
            child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: AppColors.primary,
                size: 28),
          ),
        ),
        IconButton(
            icon: const Icon(Icons.skip_next_rounded),
            onPressed: () =>
                ref.read(currentAyahProvider.notifier).state = currentAyah + 1),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(reciterName,
                    style: Theme.of(context).textTheme.labelMedium,
                    overflow: TextOverflow.ellipsis),
                Text('آية $currentAyah',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: AppColors.primary)),
              ]),
        ),
        IconButton(
            icon: const Icon(Icons.speed, size: 20),
            onPressed: () => _showSpeedDialog(context, ref)),
        PopupMenuButton<String>(
          icon: const Icon(Icons.person_outline, size: 20),
          tooltip: 'اختر القارئ',
          onSelected: (v) =>
              ref.read(selectedReciterProvider.notifier).state = v,
          itemBuilder: (_) => AppConstants.reciters.entries
              .map((e) => PopupMenuItem(value: e.key, child: Text(e.value)))
              .toList(),
        ),
      ]),
    );
  }

  void _showSpeedDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('سرعة التلاوة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...[0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
                .map((s) => RadioListTile<double>(
                      title: Text(s == 1.0 ? 'عادي' : '${s}x'),
                      value: s,
                      groupValue: ref.read(audioSpeedProvider),
                      onChanged: (v) {
                        ref.read(audioSpeedProvider.notifier).state = v ?? 1.0;
                        Navigator.pop(context);
                      },
                    )),
          ],
        ),
      ),
    );
  }
}
