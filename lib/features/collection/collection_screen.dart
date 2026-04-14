import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dyredetektiv/app/theme.dart';
import 'package:dyredetektiv/data/sample_data.dart';
import 'package:dyredetektiv/models/character.dart';
import 'package:dyredetektiv/providers/progress_provider.dart';

/// The Detective Book — shows collected characters with their fun facts.
/// Characters not yet encountered appear as silhouettes.
class CollectionScreen extends ConsumerWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);

    // Only world-specific characters are collectable (not the global guides).
    final collectable =
        SampleData.characters.where((c) => c.worldId != 'all').toList();

    final collected = collectable
        .where((c) => progress.collectedCharacters.contains(c.id))
        .length;

    return Scaffold(
      backgroundColor: DdTheme.backgroundWarm,
      appBar: AppBar(
        title: const Text('Detektivboken'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.go('/map'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: DdTheme.spaceM),
            child: Row(
              children: [
                const Text('📖', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 4),
                Text(
                  '$collected / ${collectable.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Guide bubble
          Padding(
            padding: const EdgeInsets.all(DdTheme.spaceM),
            child: Container(
              padding: const EdgeInsets.all(DdTheme.spaceM),
              decoration: BoxDecoration(
                color: DdTheme.cardWhite,
                borderRadius: BorderRadius.circular(DdTheme.radiusL),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text('🦔', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: DdTheme.spaceM),
                  Expanded(
                    child: Text(
                      collected == 0
                          ? 'Løs mysterier for å møte nye dyr og legge dem til boken!'
                          : 'Du har møtt $collected dyr så langt — fantastisk!',
                      style: DdTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Character grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(DdTheme.spaceM),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: DdTheme.spaceM,
                mainAxisSpacing: DdTheme.spaceM,
                childAspectRatio: 0.82,
              ),
              itemCount: collectable.length,
              itemBuilder: (context, i) {
                final character = collectable[i];
                final isCollected =
                    progress.collectedCharacters.contains(character.id);
                return _CharacterCard(
                  character: character,
                  isCollected: isCollected,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Character card ────────────────────────────────────────────────────────────

class _CharacterCard extends StatelessWidget {
  final Character character;
  final bool isCollected;

  const _CharacterCard({
    required this.character,
    required this.isCollected,
  });

  Color _worldColor() {
    return switch (character.worldId) {
      'forest' => DdTheme.forestGreen,
      'farm' => DdTheme.farmOrange,
      'city' => DdTheme.cityBlue,
      _ => DdTheme.primaryGreen,
    };
  }

  String _worldLabel() {
    return switch (character.worldId) {
      'forest' => 'Skogen',
      'farm' => 'Gården',
      'city' => 'Byen',
      _ => '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _worldColor();

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(DdTheme.spaceM),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // World label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(DdTheme.radiusS),
              ),
              child: Text(
                _worldLabel(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: DdTheme.spaceS),

            // Emoji / silhouette
            if (isCollected)
              Text(character.emoji,
                  style: const TextStyle(fontSize: 56))
            else
              ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Colors.black87,
                  BlendMode.srcATop,
                ),
                child: Opacity(
                  opacity: 0.25,
                  child: Text(
                    character.emoji,
                    style: const TextStyle(fontSize: 56),
                  ),
                ),
              ),
            const SizedBox(height: DdTheme.spaceS),

            // Name
            Text(
              isCollected ? character.name : '???',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isCollected ? color : DdTheme.lockGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),

            // Description (only when collected)
            if (isCollected)
              Text(
                character.description,
                style: const TextStyle(
                  fontSize: 12,
                  color: DdTheme.warmBrown,
                  height: 1.35,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              )
            else
              Text(
                'Løs et mysterium for å møte dette dyret!',
                style: TextStyle(
                  fontSize: 12,
                  color: DdTheme.lockGrey,
                  fontStyle: FontStyle.italic,
                  height: 1.35,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
          ],
        ),
      ),
    );
  }
}
