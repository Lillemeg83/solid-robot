import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dyredetektiv/models/player_progress.dart';

/// Persists [PlayerProgress] and [AppSettings] to SharedPreferences.
class ProgressRepository {
  static const _progressKey = 'player_progress';
  static const _soundKey = 'sound_enabled';
  static const _musicKey = 'music_enabled';

  final SharedPreferences _prefs;

  const ProgressRepository(this._prefs);

  // ── Progress ───────────────────────────────────────────────────────────────

  Future<PlayerProgress> loadProgress() async {
    final raw = _prefs.getString(_progressKey);
    if (raw == null) return PlayerProgress.empty();
    try {
      return PlayerProgress.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return PlayerProgress.empty();
    }
  }

  Future<void> saveProgress(PlayerProgress progress) async {
    await _prefs.setString(_progressKey, jsonEncode(progress.toJson()));
  }

  Future<void> clearProgress() async {
    await _prefs.remove(_progressKey);
  }

  // ── Settings ───────────────────────────────────────────────────────────────

  AppSettings loadSettings() => AppSettings(
        soundEnabled: _prefs.getBool(_soundKey) ?? true,
        musicEnabled: _prefs.getBool(_musicKey) ?? true,
      );

  Future<void> saveSettings(AppSettings settings) async {
    await _prefs.setBool(_soundKey, settings.soundEnabled);
    await _prefs.setBool(_musicKey, settings.musicEnabled);
  }
}
