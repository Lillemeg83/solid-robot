import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dyredetektiv/app/theme.dart';
import 'package:dyredetektiv/data/sample_data.dart';
import 'package:dyredetektiv/providers/progress_provider.dart';
import 'package:dyredetektiv/providers/settings_provider.dart';
import 'package:dyredetektiv/widgets/dd_button.dart';

/// Parent dashboard: statistics, settings and data management.
/// Accessible only through the cognitive gate.
class ParentDashboardScreen extends ConsumerWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final settings = ref.watch(settingsProvider);

    final totalMysteries = SampleData.mysteries.length;
    final solvedMysteries = progress.completedMysteries.length;
    final totalStars = progress.totalStars;
    final maxStars = totalMysteries * 3;

    return Scaffold(
      backgroundColor: DdTheme.backgroundWarm,
      appBar: AppBar(
        title: const Text('Foreldreseksjon'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DdTheme.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Statistics ──────────────────────────────────────────────────
            _SectionHeader(title: '📊  Fremgang'),
            const SizedBox(height: DdTheme.spaceM),
            _StatsRow(
              items: [
                _StatItem(
                  label: 'Løste saker',
                  value: '$solvedMysteries / $totalMysteries',
                  emoji: '🔍',
                  color: DdTheme.primaryGreen,
                ),
                _StatItem(
                  label: 'Stjerner',
                  value: '$totalStars / $maxStars',
                  emoji: '⭐',
                  color: DdTheme.warmOrange,
                ),
              ],
            ),
            const SizedBox(height: DdTheme.spaceM),

            // Per-world breakdown
            ...SampleData.worlds.map((world) {
              final worldMysteries = SampleData.mysteriesForWorld(world.id);
              final solved = worldMysteries
                  .where((m) => progress.isCompleted(m.id))
                  .length;
              final stars = worldMysteries.fold<int>(
                  0, (s, m) => s + progress.starsFor(m.id));
              return _WorldRow(
                world: world,
                solved: solved,
                total: worldMysteries.length,
                stars: stars,
                maxStars: worldMysteries.length * 3,
              );
            }),

            const SizedBox(height: DdTheme.spaceXL),

            // ── Sound settings ──────────────────────────────────────────────
            _SectionHeader(title: '🔊  Lyd'),
            const SizedBox(height: DdTheme.spaceM),
            _SettingsCard(
              children: [
                _ToggleRow(
                  label: 'Lydeffekter',
                  emoji: '🔔',
                  value: settings.soundEnabled,
                  onChanged: (_) =>
                      ref.read(settingsProvider.notifier).toggleSound(),
                ),
                const Divider(height: 1),
                _ToggleRow(
                  label: 'Musikk',
                  emoji: '🎵',
                  value: settings.musicEnabled,
                  onChanged: (_) =>
                      ref.read(settingsProvider.notifier).toggleMusic(),
                ),
              ],
            ),

            const SizedBox(height: DdTheme.spaceXL),

            // ── Premium (stub) ──────────────────────────────────────────────
            _SectionHeader(title: '⭐  Premium'),
            const SizedBox(height: DdTheme.spaceM),
            _SettingsCard(
              children: [
                Padding(
                  padding: const EdgeInsets.all(DdTheme.spaceM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Fjern reklame',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: DdTheme.warmBrown,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Engangskjøp for å fjerne alle annonser fra spillet.',
                        style: TextStyle(
                          fontSize: 14,
                          color: DdTheme.warmBrown.withOpacity(0.65),
                        ),
                      ),
                      const SizedBox(height: DdTheme.spaceM),
                      DdButton(
                        label: 'Kjøp reklamefri (39 kr)',
                        emoji: '🚫',
                        backgroundColor: DdTheme.warmOrange,
                        onPressed: () => _showComingSoon(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: DdTheme.spaceXL),

            // ── Data & privacy ──────────────────────────────────────────────
            _SectionHeader(title: '🔒  Personvern og data'),
            const SizedBox(height: DdTheme.spaceM),
            _SettingsCard(
              children: [
                ListTile(
                  leading: const Text('📄', style: TextStyle(fontSize: 24)),
                  title: const Text('Personvernerklæring',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                  onTap: () => _showComingSoon(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Text('🗑️', style: TextStyle(fontSize: 22)),
                  title: const Text('Slett all spilldata',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Fjerner all fremgang og innstillinger'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _confirmDelete(context, ref),
                ),
              ],
            ),

            const SizedBox(height: DdTheme.spaceXXL),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kommer snart!')),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DdTheme.radiusL),
        ),
        title: const Text('Slett all data?',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text(
            'All fremgang, stjerner og samlegjenstander slettes permanent.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Avbryt'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(progressProvider.notifier).resetProgress();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All spilldata slettet.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: DdTheme.errorRed),
            child:
                const Text('Slett', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: DdTheme.warmBrown,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(children: children),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final List<_StatItem> items;
  const _StatsRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items
          .map(
            (item) => Expanded(
              child: Card(
                margin: const EdgeInsets.only(right: DdTheme.spaceS),
                child: Padding(
                  padding: const EdgeInsets.all(DdTheme.spaceM),
                  child: Column(
                    children: [
                      Text(item.emoji,
                          style: const TextStyle(fontSize: 32)),
                      const SizedBox(height: 4),
                      Text(
                        item.value,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: item.color,
                        ),
                      ),
                      Text(
                        item.label,
                        style: const TextStyle(
                            fontSize: 12, color: DdTheme.lockGrey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  final String emoji;
  final Color color;
  const _StatItem(
      {required this.label,
      required this.value,
      required this.emoji,
      required this.color});
}

class _WorldRow extends StatelessWidget {
  final world;
  final int solved;
  final int total;
  final int stars;
  final int maxStars;

  const _WorldRow({
    required this.world,
    required this.solved,
    required this.total,
    required this.stars,
    required this.maxStars,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DdTheme.spaceS),
      child: Row(
        children: [
          Text(world.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: DdTheme.spaceS),
          Expanded(
            child: Text(
              world.name,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '$solved/$total saker  ·  $stars/$maxStars ⭐',
            style: const TextStyle(fontSize: 13, color: DdTheme.lockGrey),
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final String emoji;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    required this.emoji,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Text(emoji, style: const TextStyle(fontSize: 24)),
      title:
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      value: value,
      activeColor: DdTheme.primaryGreen,
      onChanged: onChanged,
    );
  }
}
