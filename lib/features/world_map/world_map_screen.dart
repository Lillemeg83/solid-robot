import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dyredetektiv/app/theme.dart';
import 'package:dyredetektiv/data/sample_data.dart';
import 'package:dyredetektiv/models/world.dart';
import 'package:dyredetektiv/providers/progress_provider.dart';
import 'package:dyredetektiv/widgets/dd_button.dart';

class WorldMapScreen extends ConsumerWidget {
  const WorldMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);

    return Scaffold(
      backgroundColor: DdTheme.backgroundWarm,
      appBar: AppBar(
        title: const Text('Velg en verden'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.go('/'),
        ),
        actions: [
          // Shortcut to detective book
          IconButton(
            tooltip: 'Detektivboken',
            onPressed: () => context.go('/collection'),
            icon: const Text('📖', style: TextStyle(fontSize: 22)),
          ),
          // Total stars counter
          Padding(
            padding: const EdgeInsets.only(right: DdTheme.spaceM),
            child: Row(
              children: [
                const Icon(Icons.star_rounded, color: DdTheme.starGold, size: 22),
                const SizedBox(width: 4),
                Text(
                  '${progress.totalStars}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
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
          const SizedBox(height: DdTheme.spaceM),
          // Guide speech bubble
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: DdTheme.spaceL),
            child: Container(
              padding: const EdgeInsets.all(DdTheme.spaceM),
              decoration: BoxDecoration(
                color: DdTheme.cardWhite,
                borderRadius: BorderRadius.circular(DdTheme.radiusL),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text('🦔', style: TextStyle(fontSize: 36)),
                  const SizedBox(width: DdTheme.spaceM),
                  Expanded(
                    child: Text(
                      'Velg en verden du vil utforske! Løs mysterier for å låse opp nye steder.',
                      style: DdTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: DdTheme.spaceM),

          // World cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: DdTheme.spaceM,
                vertical: DdTheme.spaceS,
              ),
              itemCount: SampleData.worlds.length,
              itemBuilder: (context, i) {
                final world = SampleData.worlds[i];
                final isUnlocked = progress.totalStars >= world.requiredStarsToUnlock;
                return _WorldCard(
                  world: world,
                  isUnlocked: isUnlocked,
                  starsEarned: _starsForWorld(progress, world.id),
                  requiredStars: world.requiredStarsToUnlock,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int _starsForWorld(progress, String worldId) {
    return SampleData.mysteriesForWorld(worldId)
        .fold(0, (sum, m) => sum + progress.starsFor(m.id));
  }
}

// ── World card ────────────────────────────────────────────────────────────────

class _WorldCard extends StatelessWidget {
  final World world;
  final bool isUnlocked;
  final int starsEarned;
  final int requiredStars;

  const _WorldCard({
    required this.world,
    required this.isUnlocked,
    required this.starsEarned,
    required this.requiredStars,
  });

  @override
  Widget build(BuildContext context) {
    final maxStars = SampleData.mysteriesForWorld(world.id).length * 3;

    return Opacity(
      opacity: isUnlocked ? 1.0 : 0.6,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(DdTheme.radiusL),
          onTap: isUnlocked
              ? () => context.go('/world/${world.id}')
              : null,
          child: Container(
            padding: const EdgeInsets.all(DdTheme.spaceL),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DdTheme.radiusL),
              gradient: LinearGradient(
                colors: [
                  world.primaryColor.withOpacity(0.15),
                  world.secondaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                // World emoji
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: world.primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      world.emoji,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                const SizedBox(width: DdTheme.spaceL),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            world.name,
                            style: DdTheme.headlineMedium.copyWith(
                              color: world.primaryColor,
                            ),
                          ),
                          if (!isUnlocked) ...[
                            const SizedBox(width: DdTheme.spaceS),
                            const Icon(Icons.lock_rounded,
                                size: 20, color: DdTheme.lockGrey),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(world.description,
                          style: DdTheme.bodyMedium.copyWith(fontSize: 14)),
                      const SizedBox(height: DdTheme.spaceS),
                      if (isUnlocked)
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: DdTheme.starGold, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              '$starsEarned / $maxStars stjerner',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: DdTheme.warmBrown,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          'Trenger $requiredStars ⭐ totalt for å låse opp',
                          style: const TextStyle(
                            fontSize: 13,
                            color: DdTheme.lockGrey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
                if (isUnlocked)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: world.primaryColor,
                    size: 32,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
