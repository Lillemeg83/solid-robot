import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyredetektiv/core/storage/progress_repository.dart';
import 'package:dyredetektiv/models/player_progress.dart';
import 'package:dyredetektiv/providers/shared_preferences_provider.dart';

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier(this._repo) : super(const AppSettings()) {
    state = _repo.loadSettings();
  }

  final ProgressRepository _repo;

  void toggleSound() {
    state = state.copyWith(soundEnabled: !state.soundEnabled);
    _repo.saveSettings(state);
  }

  void toggleMusic() {
    state = state.copyWith(musicEnabled: !state.musicEnabled);
    _repo.saveSettings(state);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier(ref.watch(progressRepositoryProvider));
});
