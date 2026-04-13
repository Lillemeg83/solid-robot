import 'package:dyredetektiv/models/minigame_config.dart';

/// A mystery/case that the player must solve.
class Mystery {
  final String id;
  final String worldId;
  final String title;
  final String characterId;

  /// Short intro text spoken by the character.
  final String introText;

  /// Scene description shown as background flavour text.
  final String sceneDescription;

  /// Clue texts shown in the scene before starting the mini-games.
  final List<String> clues;

  /// Ordered list of mini-games to complete.
  final List<MinigameConfig> minigames;

  /// Display order within the world (1-indexed).
  final int sortOrder;

  const Mystery({
    required this.id,
    required this.worldId,
    required this.title,
    required this.characterId,
    required this.introText,
    required this.sceneDescription,
    required this.clues,
    required this.minigames,
    required this.sortOrder,
  });
}
