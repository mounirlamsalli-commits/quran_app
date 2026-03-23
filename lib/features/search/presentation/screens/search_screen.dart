import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';

final _dio = Dio(BaseOptions(
  baseUrl: 'https://api.quran.com/api/v4',
  connectTimeout: const Duration(seconds: 15),
  receiveTimeout: const Duration(seconds: 20),
));

final searchQueryProvider = StateProvider<String>((ref) => '');
final searchHistoryProvider = StateProvider<List<String>>((ref) => []);

final searchResultsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final response = await _dio.get(
    '/search',
    queryParameters: {'q': query, 'size': 20, 'language': 'ar'},
  );
  final results = response.data['search']['results'] as List? ?? [];
  return results.cast<Map<String, dynamic>>();
});

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() { _ctrl.dispose(); _focus.dispose(); super.dispose(); }

  void _submit(String q) {
    if (q.trim().isEmpty) return;
    ref.read(searchQueryProvider.notifier).state = q.trim();
    final history = ref.read(searchHistoryProvider);
    if (!history.contains(q.trim())) {
      ref.read(searchHistoryProvider.notifier).state = [q.trim(), ...history.take(9)];
    }
    _focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        title: TextField(
          controller: _ctrl,
          focusNode: _focus,
          autofocus: true,
          textDirection: TextDirection.rtl,
          textInputAction: TextInputAction.search,
          onSubmitted: _submit,
          decoration: InputDecoration(
            hintText: 'ابحث في القرآن الكريم...',
            hintTextDirection: TextDirection.rtl,
            border: InputBorder.none,
            suffixIcon: query.isNotEmpty
                ? IconButton(icon: const Icon(Icons.clear, size: 18), onPressed: () {
                    _ctrl.clear();
                    ref.read(searchQueryProvider.notifier).state = '';
                  })
                : const Icon(Icons.search, color: AppColors.primary),
          ),
        ),
      ),
      body: query.isEmpty
          ? _SearchHome(onTap: (q) { _ctrl.text = q; _submit(q); })
          : _SearchResults(query: query),
    );
  }
}

class _SearchHome extends ConsumerWidget {
  final void Function(String) onTap;
  const _SearchHome({required this.onTap});

  static const _suggestions = ['الرحمن', 'آية الكرسي', 'إن مع العسر يسرا', 'ولا تقنطوا', 'حسبنا الله', 'الصبر'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(searchHistoryProvider);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (history.isNotEmpty) ...[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            TextButton(
              onPressed: () => ref.read(searchHistoryProvider.notifier).state = [],
              child: const Text('مسح', style: TextStyle(color: AppColors.primary)),
            ),
            Text('آخر عمليات البحث',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.secondary)),
          ]),
          ...history.map((q) => ListTile(
            onTap: () => onTap(q),
            leading: const Icon(Icons.history, size: 18, color: AppColors.primary),
            title: Text(q, textDirection: TextDirection.rtl),
            trailing: const Icon(Icons.north_west, size: 14),
          )),
          const Divider(height: 28),
        ],
        Text('اقتراحات',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.secondary),
            textDirection: TextDirection.rtl),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8, runSpacing: 8, alignment: WrapAlignment.end,
          children: _suggestions.map((s) => GestureDetector(
            onTap: () => onTap(s),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Text(s, style: const TextStyle(fontSize: 13, color: AppColors.primary)),
            ),
          )).toList(),
        ),
      ],
    );
  }
}

class _SearchResults extends ConsumerWidget {
  final String query;
  const _SearchResults({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(searchResultsProvider(query));
    return resultsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.search_off, size: 48, color: AppColors.primary),
          const SizedBox(height: 12),
          Text('حدث خطأ', textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => ref.invalidate(searchResultsProvider(query)),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('إعادة المحاولة'),
          ),
        ]),
      ),
      data: (results) {
        if (results.isEmpty) return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.search_off, size: 56, color: AppColors.primary),
            const SizedBox(height: 16),
            Text('لا نتائج لـ "$query"', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('جرّب كلمات أخرى', style: Theme.of(context).textTheme.bodySmall),
          ]),
        );
        return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text('${results.length} نتيجة لـ "$query"',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary),
                textDirection: TextDirection.rtl),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: results.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, i) {
                final r = results[i];
                final verseKey = r['verse_key'] ?? '';
                final parts = verseKey.split(':');
                final surahNum = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 1 : 1;
                final text = (r['text'] ?? '').toString().trim();
                return ListTile(
                  onTap: () => context.go('${AppRoutes.surahList}/$surahNum'),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(text,
                    style: const TextStyle(fontFamily: 'UthmanicHafs', fontSize: 18, height: 1.9),
                    textDirection: TextDirection.rtl, maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(verseKey,
                            style: const TextStyle(fontSize: 11, color: AppColors.secondary)),
                      ),
                    ]),
                  ),
                );
              },
            ),
          ),
        ]);
      },
    );
  }
}
