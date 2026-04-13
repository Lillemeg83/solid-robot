/// Immutable snapshot of the player's progress.
class PlayerProgress {
  /// Maps mysteryId → stars earned (1–3). Not present = not completed.
  final Map<String, int> mysteryStars;

  /// IDs of mysteries that have been fully solved at least once.
  final List<String> completedMysteries;

  /// IDs of characters added to the detective book.
  final List<String> collectedCharacters;

  const PlayerProgress({
    this.mysteryStars = const {},
    this.completedMysteries = const [],
    this.collectedCharacters = const [],
  });

  factory PlayerProgress.empty() => const PlayerProgress();

  bool isCompleted(String mysteryId) => completedMysteries.contains(mysteryId);

  int starsFor(String mysteryId) => mysteryStars[mysteryId] ?? 0;

  int get totalStars => mysteryStars.values.fold(0, (a, b) => a + b);

  PlayerProgress copyWith({
    Map<String, int>? mysteryStars,
    List<String>? completedMysteries,
    List<String>? collectedCharacters,
  }) {
    return PlayerProgress(
      mysteryStars: mysteryStars ?? this.mysteryStars,
      completedMysteries: completedMysteries ?? this.completedMysteries,
      collectedCharacters: collectedCharacters ?? this.collectedCharacters,
    );
  }

  // ── JSON serialisation ────────────────────────────────────────────────────

  Map<String, dynamic> toJson() => {
        'mysteryStars': mysteryStars,
        'completedMysteries': completedMysteries,
        'collectedCharacters': collectedCharacters,
      };

  factory PlayerProgress.fromJson(Map<String, dynamic> json) => PlayerProgress(
        mysteryStars: Map<String, int>.from(json['mysteryStars'] as Map? ?? {}),
        completedMysteries:
            List<String>.from(json['completedMysteries'] as List? ?? []),
        collectedCharacters:
            List<String>.from(json['collectedCharacters'] as List? ?? []),
      );
}

// ── App settings (stored alongside progress) ─────────────────────────────────

class AppSettings {
  final bool soundEnabled;
  final bool musicEnabled;

  const AppSettings({
    this.soundEnabled = true,
    this.musicEnabled = true,
  });

  AppSettings copyWith({bool? soundEnabled, bool? musicEnabled}) => AppSettings(
        soundEnabled: soundEnabled ?? this.soundEnabled,
        musicEnabled: musicEnabled ?? this.musicEnabled,
      );
}
