import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dyredetektiv/app/theme.dart';
import 'package:dyredetektiv/data/sample_data.dart';
import 'package:dyredetektiv/models/mystery.dart';
import 'package:dyredetektiv/models/world.dart';
import 'package:dyredetektiv/providers/progress_provider.dart';
import 'package:dyredetektiv/widgets/star_display.dart';

class MysteryListScreen extends ConsumerWidget {
  final String worldId;

  const MysteryListScreen({required this.worldId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final world = SampleData.worldById(worldId);
    final mysteries = SampleData.mysteriesForWorld(worldId);
    final progress = ref.watch(progressProvider);

    if (world == null) {
      return const Scaffold(body: Center(child: Text('Verden ikke funnet')));
    }

    return Scaffold(
      backgroundColor: DdTheme.backgroundWarm,
      appBar: AppBar(
        backgroundColor: world.primaryColor,
        title: Text('${world.emoji}  ${world.name}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.go('/map'),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(DdTheme.spaceM),
        itemCount: mysteries.length,
        itemBuilder: (context, i) {
          final mystery = mysteries[i];
          // A mystery is playable if it's the first, or the previous one is done.
          final isUnlocked = i == 0 ||
              progress.isCompleted(mysteries[i - 1].id);
          final stars = progress.starsFor(mystery.id);
          final isCompleted = progress.isCompleted(mystery.id);

          return _MysteryCard(
            mystery: mystery,
            world: world,
            index: i,
            isUnlocked: isUnlocked,
            isCompleted: isCompleted,
            stars: stars,
          );
        },
      ),
    );
  }
}

// ── Mystery card ──────────────────────────────────────────────────────────────

class _MysteryCard extends StatelessWidget {
  final Mystery mystery;
  final World world;
  final int index;
  final bool isUnlocked;
  final bool isCompleted;
  final int stars;

  const _MysteryCard({
    required this.mystery,
    required this.world,
    required this.index,
    required this.isUnlocked,
    required this.isCompleted,
    required this.stars,
  });

  @override
  Widget build(BuildContext context) {
    final character = SampleData.characterById(mystery.characterId);

    return Opacity(
      opacity: isUnlocked ? 1.0 : 0.55,
      child: Card(
        margin: const EdgeInsets.only(bottom: DdTheme.spaceM),
        child: InkWell(
          borderRadius: BorderRadius.circular(DdTheme.radiusL),
          onTap: isUnlocked
              ? () => context.go('/mystery/${mystery.id}')
              : null,
          child: Padding(
            padding: const EdgeInsets.all(DdTheme.spaceM),
            child: Row(
              children: [
                // Case number badge
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? world.primaryColor
                        : isUnlocked
                            ? world.primaryColor.withOpacity(0.15)
                            : DdTheme.lockGrey.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 24)
                        : isUnlocked
                            ? Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                  color: world.primaryColor,
                                ),
                              )
                            : const Icon(Icons.lock_rounded,
                                color: DdTheme.lockGrey, size: 22),
                  ),
                ),
                const SizedBox(width: DdTheme.spaceM),

                // Title + character + stars
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mystery.title,
                        style: DdTheme.headlineMedium.copyWith(fontSize: 17),
                      ),
                      if (character != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          '${character.emoji}  ${character.name}',
                          style: DdTheme.bodyMedium.copyWith(fontSize: 13),
                        ),
                      ],
                      if (isCompleted) ...[
                        const SizedBox(height: DdTheme.spaceS),
                        StarDisplay(earned: stars),
                      ],
                      if (!isUnlocked) ...[
                        const SizedBox(height: 4),
                        const Text(
                          'Løs forrige sak for å låse opp',
                          style: TextStyle(
                            fontSize: 12,
                            color: DdTheme.lockGrey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isUnlocked)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: world.primaryColor,
                    size: 28,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
