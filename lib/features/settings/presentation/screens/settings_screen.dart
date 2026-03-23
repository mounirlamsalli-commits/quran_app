import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/locale_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../quran/presentation/controllers/reader_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final selectedReciter = ref.watch(selectedReciterProvider);
    final selectedTafseer = ref.watch(selectedTafseerProvider);
    final selectedTranslation = ref.watch(selectedTranslationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        children: [
          _SectionHeader(title: 'المظهر'),
          SwitchListTile(
            title: const Text('الوضع الليلي'),
            subtitle: Text(themeMode == ThemeMode.dark ? 'مفعّل' : 'معطّل'),
            secondary: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode_outlined,
              color: AppColors.primary,
            ),
            value: themeMode == ThemeMode.dark,
            activeColor: AppColors.primary,
            onChanged: (v) => ref
                .read(themeModeProvider.notifier)
                .setThemeMode(v ? ThemeMode.dark : ThemeMode.light),
          ),
          const Divider(),
          _SectionHeader(title: 'لغة الواجهة'),
          ...AppConstants.languageNames.entries.map(
            (e) => RadioListTile<Locale>(
              title: Text(e.value),
              secondary: Text(
                e.key.toUpperCase(),
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600),
              ),
              value: Locale(e.key),
              groupValue: locale,
              activeColor: AppColors.primary,
              onChanged: (v) {
                if (v != null) ref.read(localeProvider.notifier).setLocale(v);
              },
            ),
          ),
          const Divider(),
          _SectionHeader(title: 'التلاوة الصوتية'),
          ...AppConstants.reciters.entries.map(
            (e) => RadioListTile<String>(
              title: Text(e.value),
              value: e.key,
              groupValue: selectedReciter,
              activeColor: AppColors.primary,
              onChanged: (v) {
                if (v != null) {
                  ref.read(selectedReciterProvider.notifier).state = v;
                }
              },
            ),
          ),
          const Divider(),
          _SectionHeader(title: 'التفسير'),
          ...AppConstants.tafseers.entries.map(
            (e) => RadioListTile<int>(
              title: Text(e.value),
              value: e.key,
              groupValue: selectedTafseer,
              activeColor: AppColors.primary,
              onChanged: (v) {
                if (v != null) {
                  ref.read(selectedTafseerProvider.notifier).state = v;
                }
              },
            ),
          ),
          const Divider(),
          _SectionHeader(title: 'الترجمة'),
          ...AppConstants.translations.entries.map(
            (e) => RadioListTile<int>(
              title: Text(e.value),
              value: e.key,
              groupValue: selectedTranslation,
              activeColor: AppColors.primary,
              onChanged: (v) {
                if (v != null) {
                  ref.read(selectedTranslationProvider.notifier).state = v;
                }
              },
            ),
          ),
          const Divider(),
          _SectionHeader(title: 'الملفات المحملة'),
          ListTile(
            leading: const Icon(Icons.download_for_offline,
                color: AppColors.primary),
            title: const Text('إدارة التحميلات'),
            subtitle: const Text('عرض وحذف الملفات الصوتية المحملة'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => context.push(AppRoutes.downloads),
          ),
          const Divider(),
          _SectionHeader(title: 'عن التطبيق'),
          const ListTile(
            leading: Icon(Icons.info_outline, color: AppColors.secondary),
            title: Text('القرآن الكريم'),
            subtitle: Text('الإصدار 1.0.0'),
          ),
          const ListTile(
            leading: Icon(Icons.code, color: AppColors.secondary),
            title: Text('المصدر'),
            subtitle: Text('Quran.com API'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
        child: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.secondary,
                letterSpacing: 0.5,
              ),
        ),
      );
}
