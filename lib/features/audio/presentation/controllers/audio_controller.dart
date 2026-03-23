import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../domain/entities/reciter.dart';
import '../../../../core/constants/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() => player.dispose());
  return player;
});

final recitersListProvider = FutureProvider<List<Reciter>>((ref) async {
  final dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));
  try {
    final response = await dio.get('/resources/audio_reciters', queryParameters: {'language': 'ar'});
    final reciters = response.data['reciters'] as List;
    return reciters.map((r) => Reciter(
      id: r['id'].toString(),
      nameArabic: r['reciter_name'] ?? r['translated_name']?['name'] ?? r['name'] ?? '',
      nameEnglish: r['reciter_name'] ?? '',
      style: r['recitation_style'] ?? '',
    )).toList();
  } catch (e) {
    return AppConstants.reciters.entries.map((e) => Reciter(
      id: e.key, nameArabic: e.value, nameEnglish: e.value, style: '',
    )).toList();
  }
});

final selectedReciterNotifierProvider = StateNotifierProvider<SelectedReciterNotifier, String>((ref) {
  return SelectedReciterNotifier();
});

class SelectedReciterNotifier extends StateNotifier<String> {
  SelectedReciterNotifier() : super('7') { _load(); }
  
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(AppConstants.keySelectedReciter) ?? '7';
  }
  
  Future<void> set(String id) async {
    state = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keySelectedReciter, id);
  }
}

final audioSpeedNotifierProvider = StateNotifierProvider<AudioSpeedNotifier, double>((ref) {
  return AudioSpeedNotifier();
});

class AudioSpeedNotifier extends StateNotifier<double> {
  AudioSpeedNotifier() : super(1.0) { _load(); }
  
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getDouble(AppConstants.keyAudioSpeed) ?? 1.0;
  }
  
  Future<void> set(double speed) async {
    state = speed;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(AppConstants.keyAudioSpeed, speed);
  }
}

final repeatModeNotifierProvider = StateNotifierProvider<RepeatModeNotifier, RepeatMode>((ref) {
  return RepeatModeNotifier();
});

class RepeatModeNotifier extends StateNotifier<RepeatMode> {
  RepeatModeNotifier() : super(RepeatMode.none);
  
  void cycle() {
    final modes = RepeatMode.values;
    state = modes[(modes.indexOf(state) + 1) % modes.length];
  }
}

final audioPositionProvider = StateProvider<Duration>((ref) => Duration.zero);
final audioDurationProvider = StateProvider<Duration>((ref) => Duration.zero);