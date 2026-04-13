import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dyredetektiv/app/theme.dart';
import 'package:dyredetektiv/data/sample_data.dart';
import 'package:dyredetektiv/features/minigames/count/count_game_widget.dart';
import 'package:dyredetektiv/models/minigame_config.dart';

/// Hosts all mini-games for a given mystery, cycling through them in order.
/// Tracks hint usage to compute the final star rating.
///
/// Star rules:
///   0 hints used  → 3 stars
///   1 hint used   → 2 stars
///   2+ hints used → 1 star
class MinigameScreen extends StatefulWidget {
  final String mysteryId;

  const MinigameScreen({required this.mysteryId, super.key});

  @override
  State<MinigameScreen> createState() => _MinigameScreenState();
}

class _MinigameScreenState extends State<MinigameScreen> {
  int _gameIndex = 0;
  int _hintsUsed = 0;
  bool _transitioning = false;

  void _onGameCompleted(bool correct) {
    if (_transitioning) return;
    final mystery = SampleData.mysteryById(widget.mysteryId)!;

    if (_gameIndex < mystery.minigames.length - 1) {
      // Move to next mini-game with a brief transition
      setState(() {
        _transitioning = true;
      });
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          setState(() {
            _gameIndex++;
            _transitioning = false;
          });
        }
      });
    } else {
      // All games done — compute stars and navigate to reward
      final stars = _hintsUsed == 0
          ? 3
          : _hintsUsed == 1
              ? 2
              : 1;
      context.go('/reward/${widget.mysteryId}/$stars');
    }
  }

  void _onHintUsed() {
    setState(() => _hintsUsed++);
  }

  @override
  Widget build(BuildContext context) {
    final mystery = SampleData.mysteryById(widget.mysteryId);
    if (mystery == null) {
      return const Scaffold(body: Center(child: Text('Sak ikke funnet')));
    }

    final world = SampleData.worldById(mystery.worldId);
    final worldColor = world?.primaryColor ?? DdTheme.primaryGreen;
    final config = mystery.minigames[_gameIndex];
    final totalGames = mystery.minigames.length;

    return Scaffold(
      backgroundColor: DdTheme.backgroundWarm,
      appBar: AppBar(
        backgroundColor: worldColor,
        title: Text('Sak: ${mystery.title}'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Avslutt',
          onPressed: () => _confirmExit(context, mystery.worldId),
        ),
        bottom: totalGames > 1
            ? PreferredSize(
                preferredSize: const Size.fromHeight(6),
                child: _ProgressBar(
                  current: _gameIndex + 1,
                  total: totalGames,
                  color: worldColor,
                ),
              )
            : null,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _transitioning
            ? const Center(child: _TransitionWidget())
            : KeyedSubtree(
                key: ValueKey(_gameIndex),
                child: _buildGame(config),
              ),
      ),
    );
  }

  Widget _buildGame(MinigameConfig config) {
    switch (config.type) {
      case 'count':
        return CountGameWidget(
          config: config,
          onCompleted: _onGameCompleted,
          onHintUsed: _onHintUsed,
        );
      default:
        // Stub for unsupported game types
        return _UnsupportedGame(
          type: config.type,
          onCompleted: () => _onGameCompleted(true),
        );
    }
  }

  void _confirmExit(BuildContext context, String worldId) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DdTheme.radiusL),
        ),
        title: const Text('Avslutt saken?',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text(
            'Fremgangen din i denne saken lagres ikke hvis du avslutter nå.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fortsett'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/world/$worldId');
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: DdTheme.errorRed),
            child: const Text('Avslutt', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ── Progress bar ──────────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  final int current;
  final int total;
  final Color color;

  const _ProgressBar({
    required this.current,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: current / total,
      backgroundColor: Colors.white30,
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
      minHeight: 6,
    );
  }
}

// ── Transition widget ─────────────────────────────────────────────────────────

class _TransitionWidget extends StatelessWidget {
  const _TransitionWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('✅', style: TextStyle(fontSize: 64)),
        const SizedBox(height: DdTheme.spaceM),
        Text(
          'Bra jobbet! Neste oppgave...',
          style: DdTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ── Stub for unsupported game types ───────────────────────────────────────────

class _UnsupportedGame extends StatelessWidget {
  final String type;
  final VoidCallback onCompleted;

  const _UnsupportedGame({required this.type, required this.onCompleted});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DdTheme.spaceXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔧', style: TextStyle(fontSize: 64)),
            const SizedBox(height: DdTheme.spaceL),
            Text(
              'Spill-type "$type" kommer snart!',
              style: DdTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DdTheme.spaceXL),
            ElevatedButton(
              onPressed: onCompleted,
              child: const Text('Fortsett'),
            ),
          ],
        ),
      ),
    );
  }
}
