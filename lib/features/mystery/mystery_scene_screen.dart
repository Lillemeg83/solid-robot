import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dyredetektiv/app/theme.dart';
import 'package:dyredetektiv/data/sample_data.dart';
import 'package:dyredetektiv/widgets/character_dialog.dart';
import 'package:dyredetektiv/widgets/dd_button.dart';

/// Shows the mystery intro: scene description, character speech and clues.
/// The player reads the clues and then taps "Start mysteriet!".
class MysterySceneScreen extends StatefulWidget {
  final String mysteryId;

  const MysterySceneScreen({required this.mysteryId, super.key});

  @override
  State<MysterySceneScreen> createState() => _MysterySceneScreenState();
}

class _MysterySceneScreenState extends State<MysterySceneScreen> {
  int _revealedClues = 0;

  @override
  Widget build(BuildContext context) {
    final mystery = SampleData.mysteryById(widget.mysteryId);
    if (mystery == null) {
      return const Scaffold(body: Center(child: Text('Sak ikke funnet')));
    }

    final character = SampleData.characterById(mystery.characterId);
    final world = SampleData.worldById(mystery.worldId);
    final worldColor = world?.primaryColor ?? DdTheme.primaryGreen;

    return Scaffold(
      backgroundColor: DdTheme.backgroundWarm,
      appBar: AppBar(
        backgroundColor: worldColor,
        title: Text(mystery.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.go('/world/${mystery.worldId}'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DdTheme.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Scene description banner
            _SceneBanner(
              description: mystery.sceneDescription,
              worldColor: worldColor,
            ),
            const SizedBox(height: DdTheme.spaceL),

            // Character intro dialog
            if (character != null)
              CharacterDialog(
                character: character,
                text: mystery.introText,
              ),
            const SizedBox(height: DdTheme.spaceXL),

            // Clues section
            const Text(
              '🔍  Ledetråder',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: DdTheme.warmBrown,
              ),
            ),
            const SizedBox(height: DdTheme.spaceM),

            // Tap to reveal clues one at a time
            ...List.generate(mystery.clues.length, (i) {
              final revealed = i <= _revealedClues - 1;
              if (i > _revealedClues) return const SizedBox.shrink();
              return _ClueCard(
                clue: mystery.clues[i],
                isRevealed: revealed,
                onReveal: () => setState(() => _revealedClues++),
              );
            }),

            // Prompt to reveal more clues
            if (_revealedClues < mystery.clues.length) ...[
              const SizedBox(height: DdTheme.spaceM),
              Center(
                child: TextButton.icon(
                  onPressed: () => setState(() => _revealedClues++),
                  icon: const Icon(Icons.search_rounded),
                  label: const Text(
                    'Se neste ledetråd',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: worldColor,
                  ),
                ),
              ),
            ],

            const SizedBox(height: DdTheme.spaceXXL),

            // Start mystery button — enabled once at least 1 clue revealed
            DdButton(
              label: 'Start mysteriet!',
              emoji: '🕵️',
              backgroundColor: worldColor,
              height: 68,
              fontSize: 20,
              width: double.infinity,
              onPressed: _revealedClues > 0
                  ? () => context.go('/minigame/${mystery.id}')
                  : null,
            ),

            if (_revealedClues == 0)
              Padding(
                padding: const EdgeInsets.only(top: DdTheme.spaceS),
                child: Center(
                  child: Text(
                    'Les ledetråder først!',
                    style: TextStyle(
                      fontSize: 14,
                      color: DdTheme.warmBrown.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: DdTheme.spaceXL),
          ],
        ),
      ),
    );
  }
}

// ── Scene banner ──────────────────────────────────────────────────────────────

class _SceneBanner extends StatelessWidget {
  final String description;
  final Color worldColor;

  const _SceneBanner({required this.description, required this.worldColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DdTheme.spaceL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [worldColor.withValues(alpha: 0.2), worldColor.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DdTheme.radiusL),
        border: Border.all(color: worldColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Text('🌄', style: TextStyle(fontSize: 32)),
          const SizedBox(width: DdTheme.spaceM),
          Expanded(
            child: Text(description, style: DdTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

// ── Clue card ─────────────────────────────────────────────────────────────────

class _ClueCard extends StatelessWidget {
  final String clue;
  final bool isRevealed;
  final VoidCallback onReveal;

  const _ClueCard({
    required this.clue,
    required this.isRevealed,
    required this.onReveal,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DdTheme.spaceS),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(DdTheme.spaceM),
        decoration: BoxDecoration(
          color: isRevealed
              ? DdTheme.cardWhite
              : DdTheme.cardWhite.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(DdTheme.radiusM),
          boxShadow: isRevealed
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(clue, style: DdTheme.bodyLarge),
      ),
    );
  }
}
