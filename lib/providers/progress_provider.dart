import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyredetektiv/core/storage/progress_repository.dart';
import 'package:dyredetektiv/models/player_progress.dart';
import 'package:dyredetektiv/providers/shared_preferences_provider.dart';

class ProgressNotifier extends StateNotifier<PlayerProgress> {
  ProgressNotifier(this._repo) : super(PlayerProgress.empty()) {
    _load();
  }

  final ProgressRepository _repo;

  Future<void> _load() async {
    state = await _repo.loadProgress();
  }

  /// Records the result of a solved mystery and persists it.
  Future<void> completeMystery(String mysteryId, int stars) async {
    final updatedStars = Map<String, int>.from(state.mysteryStars)
      ..[mysteryId] = stars;

    final updatedCompleted =
        state.isCompleted(mysteryId)
            ? state.completedMysteries
            : [...state.completedMysteries, mysteryId];

    state = state.copyWith(
      mysteryStars: updatedStars,
      completedMysteries: updatedCompleted,
    );
    await _repo.saveProgress(state);
  }

  /// Adds a character to the detective book.
  Future<void> collectCharacter(String characterId) async {
    if (state.collectedCharacters.contains(characterId)) return;
    state = state.copyWith(
      collectedCharacters: [...state.collectedCharacters, characterId],
    );
    await _repo.saveProgress(state);
  }

  /// Wipes all progress (callable from the parent dashboard).
  Future<void> resetProgress() async {
    state = PlayerProgress.empty();
    await _repo.clearProgress();
  }
}

final progressProvider =
    StateNotifierProvider<ProgressNotifier, PlayerProgress>((ref) {
  return ProgressNotifier(ref.watch(progressRepositoryProvider));
});
