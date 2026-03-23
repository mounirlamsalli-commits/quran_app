import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../quran/presentation/controllers/reader_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Providers for settings
final settingsThemeModeProvider =
    StateProvider<ThemeMode>((ref) => ThemeMode.system);
final settingsLocaleProvider =
    StateProvider<Locale>((ref) => const Locale('ar'));
final settingsNotificationsProvider = StateProvider<bool>((ref) => true);
final settingsReminderTimeProvider = StateProvider<String>((ref) => '08:00');

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _selectedLocale = const Locale('ar');
  bool _notificationsEnabled = true;
  String _reminderTime = '08:00';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _themeMode = ThemeMode.values[prefs.getInt('theme_mode') ?? 0];
        _selectedLocale = Locale(prefs.getString('locale') ?? 'ar');
        _notificationsEnabled = prefs.getBool('notifications') ?? true;
        _reminderTime = prefs.getString('reminder_time') ?? '08:00';
        _isLoading = false;
      });
      // Load selected options
      final reciter = prefs.getString('selected_reciter') ?? 'ar.alafasy';
      final tafseer = prefs.getInt('selected_tafseer') ?? 14;
      final translation = prefs.getInt('selected_translation') ?? 20;
      ref.read(selectedReciterProvider.notifier).state = reciter;
      ref.read(selectedTafseerProvider.notifier).state = tafseer;
      ref.read(selectedTranslationProvider.notifier).state = translation;
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('الإعدادات')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _SectionHeader(title: 'المظهر'),
        Card(
            child: Column(children: [
          RadioListTile<ThemeMode>(
            title: const Text('تلقائي (حسب النظام)'),
            value: ThemeMode.system,
            groupValue: _themeMode,
            onChanged: (v) => _saveThemeMode(v!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('الوضع النهاري'),
            value: ThemeMode.light,
            groupValue: _themeMode,
            onChanged: (v) => _saveThemeMode(v!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('الوضع الليلي'),
            value: ThemeMode.dark,
            groupValue: _themeMode,
            onChanged: (v) => _saveThemeMode(v!),
          ),
        ])),
        const SizedBox(height: 24),
        _SectionHeader(title: 'اللغة'),
        Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
              children: AppConstants.languageNames.entries
                  .map((e) => RadioListTile<String>(
                        title: Text(e.value),
                        value: e.key,
                        groupValue: _selectedLocale.languageCode,
                        onChanged: (v) => _saveLocale(v!),
                      ))
                  .toList()),
        )),
        const SizedBox(height: 24),
        _SectionHeader(title: 'التذكيرات'),
        Card(
            child: Column(children: [
          SwitchListTile(
            title: const Text('تفعيل التذكيرات اليومية'),
            subtitle: Text(
                _notificationsEnabled ? 'التذكير في $_reminderTime' : 'معطل'),
            value: _notificationsEnabled,
            onChanged: (v) => _saveNotifications(v),
          ),
          if (_notificationsEnabled)
            ListTile(
              title: const Text('وقت التذكير'),
              trailing: Text(_reminderTime,
                  style: TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.bold)),
              onTap: _selectTime,
            ),
        ])),
        const SizedBox(height: 24),
        _SectionHeader(title: 'القراء'),
        _ReciterSelector(),
        const SizedBox(height: 24),
        _SectionHeader(title: 'التفسير'),
        _TafseerSelector(),
        const SizedBox(height: 24),
        _SectionHeader(title: 'الترجمة'),
        _TranslationSelector(),
        const SizedBox(height: 24),
        _SectionHeader(title: 'حول'),
        Card(
            child: Column(children: [
          ListTile(
              leading: Icon(Icons.info_outline, color: AppColors.primary),
              title: const Text('حول التطبيق'),
              onTap: _showAbout),
          const Divider(height: 1),
          ListTile(
              leading: Icon(Icons.star_outline, color: AppColors.primary),
              title: const Text('تقييم التطبيق'),
              onTap: () {}),
        ])),
      ]),
    );
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', mode.index);
    setState(() => _themeMode = mode);
  }

  Future<void> _saveLocale(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', code);
    setState(() => _selectedLocale = Locale(code));
  }

  Future<void> _saveNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', enabled);
    setState(() => _notificationsEnabled = enabled);
  }

  Future<void> _selectTime() async {
    final t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_reminderTime.split(':')[0]),
            minute: int.parse(_reminderTime.split(':')[1])));
    if (t != null) {
      final time =
          '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('reminder_time', time);
      setState(() => _reminderTime = time);
    }
  }

  void _showAbout() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Row(children: [
                Icon(Icons.menu_book, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text('القرآن الكريم')
              ]),
              content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('تطبيق القرآن الكريم'),
                    SizedBox(height: 8),
                    Text('الإصدار: 1.0.0'),
                    SizedBox(height: 8),
                    Text(
                        'تطبيق مجاني للقرآن الكريم مع التلاوة والتفسير والترجمة'),
                  ]),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إغلاق'))
              ],
            ));
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.primary)),
      );
}

class _ReciterSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedReciter = ref.watch(selectedReciterProvider);
    final reciterName = AppConstants.reciters[selectedReciter] ?? 'العفاسي';
    return Card(
      child: ListTile(
        title: const Text('القارئ'),
        subtitle: Text(reciterName),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showDialog(context, ref, selectedReciter),
      ),
    );
  }

  void _showDialog(BuildContext context, WidgetRef ref, String current) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('اختر القارئ'),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: ListView(
                    children: AppConstants.reciters.entries
                        .map((e) => RadioListTile<String>(
                              title: Text(e.value),
                              value: e.key,
                              groupValue: current,
                              onChanged: (v) async {
                                ref
                                    .read(selectedReciterProvider.notifier)
                                    .state = v!;
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString('selected_reciter', v);
                                if (context.mounted) Navigator.pop(context);
                              },
                            ))
                        .toList()),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إغلاق'))
              ],
            ));
  }
}

class _TafseerSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedTafseerProvider);
    final name = AppConstants.tafseers[selected] ?? 'ابن كثير';
    return Card(
      child: ListTile(
        title: const Text('التفسير'),
        subtitle: Text(name),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showDialog(context, ref, selected),
      ),
    );
  }

  void _showDialog(BuildContext context, WidgetRef ref, int current) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('اختر التفسير'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                    children: AppConstants.tafseers.entries
                        .map((e) => RadioListTile<int>(
                              title: Text(e.value),
                              value: e.key,
                              groupValue: current,
                              onChanged: (v) async {
                                ref
                                    .read(selectedTafseerProvider.notifier)
                                    .state = v!;
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setInt('selected_tafseer', v);
                                if (context.mounted) Navigator.pop(context);
                              },
                            ))
                        .toList()),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إغلاق'))
              ],
            ));
  }
}

class _TranslationSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedTranslationProvider);
    final name = AppConstants.translations[selected] ?? 'English';
    return Card(
      child: ListTile(
        title: const Text('الترجمة'),
        subtitle: Text(name),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showDialog(context, ref, selected),
      ),
    );
  }

  void _showDialog(BuildContext context, WidgetRef ref, int current) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('اختر الترجمة'),
              content: SizedBox(
                width: double.maxFinite,
                height: 350,
                child: ListView(
                    children: AppConstants.translations.entries
                        .map((e) => RadioListTile<int>(
                              title: Text(e.value),
                              value: e.key,
                              groupValue: current,
                              onChanged: (v) async {
                                ref
                                    .read(selectedTranslationProvider.notifier)
                                    .state = v!;
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setInt('selected_translation', v);
                                if (context.mounted) Navigator.pop(context);
                              },
                            ))
                        .toList()),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إغلاق'))
              ],
            ));
  }
}
