import 'package:flutter/material.dart';
import 'package:dyredetektiv/app/theme.dart';
import 'package:dyredetektiv/models/character.dart';
import 'package:dyredetektiv/data/sample_data.dart';
import 'package:dyredetektiv/widgets/cute_fox_detective.dart';

/// Speech bubble with character emoji — used for intro text and hints.
class CharacterDialog extends StatelessWidget {
  final Character character;
  final String text;
  final Color? bubbleColor;
  final double emojiSize;

  const CharacterDialog({
    required this.character,
    required this.text,
    this.bubbleColor,
    this.emojiSize = 52,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = bubbleColor ?? DdTheme.cardWhite;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Character avatar — initial letter + emoji overlay
        _CharacterAvatar(character: character),
        const SizedBox(width: DdTheme.spaceM),
        // Speech bubble
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(DdTheme.spaceM),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(DdTheme.radiusL),
                bottomLeft: Radius.circular(DdTheme.radiusL),
                bottomRight: Radius.circular(DdTheme.radiusL),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  character.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: DdTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: DdTheme.spaceXS),
                Text(text, style: DdTheme.bodyLarge),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Character avatar ──────────────────────────────────────────────────────────

/// Circular avatar showing the character initial (always renders) with
/// the emoji in a small badge at the bottom-right (renders if font supports it).
class _CharacterAvatar extends StatelessWidget {
  final Character character;

  const _CharacterAvatar({required this.character});

  @override
  Widget build(BuildContext context) {
    final initial = character.name.isNotEmpty
        ? character.name.substring(0, 1).toUpperCase()
        : '?';
    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        children: [
          // Main circle — detective fox for Mira, emoji+initial for others
          if (character.id == 'mira')
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    DdTheme.warmOrange.withValues(alpha: 0.3),
                    DdTheme.warmOrange.withValues(alpha: 0.08),
                  ],
                ),
                border: Border.all(color: DdTheme.warmOrange, width: 2.5),
              ),
              child: const Center(child: CuteFoxDetective(size: 44)),
            )
          else
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    DdTheme.lightGreen.withValues(alpha: 0.55),
                    DdTheme.lightGreen.withValues(alpha: 0.15),
                  ],
                ),
                border: Border.all(color: DdTheme.lightGreen, width: 2.5),
              ),
              child: Center(
                child: Text(
                  character.emoji,
                  style: const TextStyle(fontSize: 34),
                ),
              ),
            ),
          // Emoji badge bottom-right (if emoji doesn't render the initial is enough)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black12)],
              ),
              child: Center(
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: DdTheme.primaryGreen,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Context card shown at the top of mini-games.
/// Displays the flavour text as a Mira speech bubble when possible.
class GameContextCard extends StatelessWidget {
  final String text;

  const GameContextCard({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    final mira = SampleData.characterById('mira');
    if (mira == null) {
      return Container(
        padding: const EdgeInsets.all(DdTheme.spaceM),
        decoration: BoxDecoration(
          color: DdTheme.lightGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(DdTheme.radiusM),
        ),
        child: Text(text, style: DdTheme.bodyMedium),
      );
    }
    return CharacterDialog(character: mira, text: text);
  }
}

/// Hint bubble shown by Professor Padde when the player is stuck.
class HintBubble extends StatelessWidget {
  final String hint;

  const HintBubble({required this.hint, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DdTheme.spaceM),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4),
        borderRadius: BorderRadius.circular(DdTheme.radiusL),
        border: Border.all(color: DdTheme.starGold, width: 2),
      ),
      child: Row(
        children: [
          const Text('🐸', style: TextStyle(fontSize: 32)),
          const SizedBox(width: DdTheme.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Professor Padde sier:',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: DdTheme.warmOrange,
                  ),
                ),
                const SizedBox(height: 2),
                Text(hint, style: DdTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
