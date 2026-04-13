/// A character in the game — could be an NPC animal or the guide Mira.
class Character {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final String worldId; // which world this character lives in ('all' for Mira)

  const Character({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.worldId,
  });
}
