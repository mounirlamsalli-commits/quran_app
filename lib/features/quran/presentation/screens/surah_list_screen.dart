import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/surah_list_controller.dart';

class SurahListScreen extends ConsumerWidget {
  const SurahListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('القرآن الكريم')),
      body: surahsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 48, color: AppColors.primary),
              const SizedBox(height: 16),
              Text('$e', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(surahListProvider),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
        data: (surahs) => ListView.separated(
          itemCount: surahs.length,
          separatorBuilder: (_, __) => const Divider(height: 0),
          itemBuilder: (context, i) {
            final s = surahs[i];
            return ListTile(
              onTap: () => context.go('${AppRoutes.surahList}/${s.number}'),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${s.number}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              title: Text(
                s.nameArabic,
                style: const TextStyle(fontFamily: 'Amiri', fontSize: 16),
                textDirection: TextDirection.rtl,
              ),
              subtitle: Text(
                '${s.isMeccan ? "مكية" : "مدنية"} · ${s.ayahCount} آية',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                textDirection: TextDirection.rtl,
              ),
              trailing: const Icon(Icons.chevron_left, size: 18),
            );
          },
        ),
      ),
    );
  }
}