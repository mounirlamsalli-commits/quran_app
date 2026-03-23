import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:dio/dio.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

class SearchFilters {
  final bool inArabic;
  final bool inTranslation;
  final int? surahFilter;
  final int? juzFilter;
  
  const SearchFilters({this.inArabic = true, this.inTranslation = false, this.surahFilter, this.juzFilter});
  
  SearchFilters copyWith({bool? inArabic, bool? inTranslation, int? surahFilter, int? juzFilter}) {
    return SearchFilters(
      inArabic: inArabic ?? this.inArabic,
      inTranslation: inTranslation ?? this.inTranslation,
      surahFilter: surahFilter,
      juzFilter: juzFilter,
    );
  }
}

final searchFiltersProvider = StateProvider<SearchFilters>((ref) => const SearchFilters());

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _ctrl = TextEditingController();
  String _query = '';
  bool _showFilters = false;

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: 'ابحث في القرآن الكريم...',
            hintTextDirection: TextDirection.rtl,
            border: InputBorder.none,
            suffixIcon: IconButton(icon: const Icon(Icons.filter_list), onPressed: () => setState(() => _showFilters = !_showFilters)),
            prefixIcon: _query.isNotEmpty ? IconButton(icon: const Icon(Icons.clear), onPressed: () { _ctrl.clear(); setState(() => _query = ''); }) : null,
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
      ),
      body: Column(children: [
        if (_showFilters) _FilterPanel(),
        Expanded(child: _query.isEmpty ? _SearchHistory() : _SearchResults(query: _query)),
      ]),
    );
  }
}

class _FilterPanel extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(searchFiltersProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text('خيارات البحث', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 12),
        Row(children: [
          FilterChip(label: const Text('في النص العربي'), selected: filters.inArabic, onSelected: (v) => ref.read(searchFiltersProvider.notifier).state = filters.copyWith(inArabic: v)),
          const SizedBox(width: 8),
          FilterChip(label: const Text('في الترجمة'), selected: filters.inTranslation, onSelected: (v) => ref.read(searchFiltersProvider.notifier).state = filters.copyWith(inTranslation: v)),
        ]),
        const SizedBox(height: 12),
        DropdownButtonFormField<int?>(
          value: filters.surahFilter,
          decoration: const InputDecoration(labelText: 'السورة', border: OutlineInputBorder()),
          items: [const DropdownMenuItem(value: null, child: Text('كل السور')), ...List.generate(114, (i) => DropdownMenuItem(value: i + 1, child: Text('سورة ${i + 1}')))],
          onChanged: (v) => ref.read(searchFiltersProvider.notifier).state = filters.copyWith(surahFilter: v),
        ),
      ]),
    );
  }
}

class _SearchHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recentSearches = ['الرحمن', 'آية الكرسي', 'سورة يس', 'ربنا آتنا'];
    return ListView(padding: const EdgeInsets.all(16), children: [
      Text('آخر عمليات البحث', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.secondary)),
      const SizedBox(height: 8),
      ...recentSearches.map((q) => ListTile(
        leading: const Icon(Icons.history, size: 18),
        title: Text(q, textDirection: TextDirection.rtl),
        trailing: const Icon(Icons.north_west, size: 14),
        onTap: () {},
      )),
      const Divider(height: 32),
      Text('اقتراحات', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.secondary)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: ['سورة البقرة', 'سورة الكهف', 'سورة مريم', 'آية الكرسي', 'سورة يوسف', 'سورة الرحمن'].map((s) => ActionChip(label: Text(s), onPressed: () {})).toList()),
    ]);
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
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 12), Text('خطأ: $e'),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () => ref.invalidate(searchResultsProvider(query)), child: const Text('إعادة المحاولة')),
        ]),
      ),
      data: (results) => results.isEmpty
          ? const Center(child: Text('لا توجد نتائج'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: results.length,
              itemBuilder: (context, i) => _SearchResultCard(result: results[i]),
            ),
    );
  }
}

final searchResultsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, query) async {
  if (query.trim().isEmpty) return [];
  final dio = Dio();
  try {
    final response = await dio.get('https://api.quran.com/api/v4/search', queryParameters: {'q': query, 'size': 20});
    final results = response.data['search']['results'] as List? ?? [];
    return results.map((r) {
      final map = r as Map<String, dynamic>;
      return {
        'text': map['text'] ?? '',
        'surah_number': map['surah_number'] ?? map['verse_id'] ?? '',
        'surah_name_arabic': map['surah_name_arabic'] ?? '',
        'verse_number': map['verse_number'] ?? '',
        'verse_key': map['verse_key'] ?? '',
      };
    }).toList();
  } catch (e) {
    return [];
  }
});

class _SearchResultCard extends StatelessWidget {
  final Map<String, dynamic> result;
  const _SearchResultCard({required this.result});
  
  @override
  Widget build(BuildContext context) {
    final text = (result['text'] ?? '').toString();
    final surahName = result['surah_name_arabic'] ?? '';
    final ayahNum = result['verse_number'] ?? '';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Text('سورة $surahName - آية $ayahNum', style: const TextStyle(fontSize: 12, color: AppColors.primary)),
            ),
            const SizedBox(height: 8),
            Text(text, style: const TextStyle(fontFamily: 'UthmanicHafs', fontSize: 18), textDirection: TextDirection.rtl, maxLines: 2, overflow: TextOverflow.ellipsis),
          ]),
        ),
      ),
    );
  }
}