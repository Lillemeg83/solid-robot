/// Configuration for a single mini-game within a mystery.
///
/// The [type] field selects which game widget to render.
/// The [data] map contains all game-specific parameters so that new game types
/// can be added without changing the data model.
///
/// Supported types in MVP:
///   'count' — count objects and pick the correct number
///   'sort'  — (stub) drag items into categories
class MinigameConfig {
  final String type;
  final Map<String, dynamic> data;

  const MinigameConfig({
    required this.type,
    required this.data,
  });

  // ── CountGame helpers ──────────────────────────────────────────────────────

  String get question => data['question'] as String? ?? '';
  String get emoji => data['emoji'] as String? ?? '❓';
  int get correctCount => data['count'] as int? ?? 0;
  List<int> get options =>
      (data['options'] as List?)?.cast<int>() ?? [correctCount];
  String get hint => data['hint'] as String? ?? 'Se nøye på bildet!';
  String get contextText => data['contextText'] as String? ?? '';
}
