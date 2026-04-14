import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dyredetektiv/app/theme.dart';
import 'package:dyredetektiv/data/sample_data.dart';
import 'package:dyredetektiv/models/mystery.dart';
import 'package:dyredetektiv/models/world.dart';
import 'package:dyredetektiv/providers/progress_provider.dart';
import 'package:dyredetektiv/widgets/animated_animal.dart';
import 'package:dyredetektiv/widgets/cute_fox_detective.dart';

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

    // Current position = index of first uncompleted mystery (or past end = all done)
    int currentIndex =
        mysteries.indexWhere((m) => !progress.isCompleted(m.id));
    if (currentIndex == -1) currentIndex = mysteries.length;

    return Scaffold(
      backgroundColor: world.secondaryColor,
      appBar: AppBar(
        backgroundColor: world.primaryColor,
        foregroundColor: Colors.white,
        title: Text('${world.emoji}  ${world.name}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.go('/map'),
        ),
      ),
      body: _GameBoard(
        mysteries: mysteries,
        world: world,
        progress: progress,
        currentIndex: currentIndex,
        onTap: (m) => context.go('/mystery/${m.id}'),
      ),
    );
  }
}

// ── Game board ────────────────────────────────────────────────────────────────

class _GameBoard extends StatelessWidget {
  final List<Mystery> mysteries;
  final World world;
  final dynamic progress;
  final int currentIndex;
  final void Function(Mystery) onTap;

  const _GameBoard({
    required this.mysteries,
    required this.world,
    required this.progress,
    required this.currentIndex,
    required this.onTap,
  });

  static const double _boardHeight = 520;
  static const double _nodeR = 40.0;

  // Node 0 = first mystery (bottom), node n-1 = last (top).
  // Alternates left / right to create a winding path.
  static List<Offset> _positions(double width, int count) {
    if (count == 0) return [];
    if (count == 1) return [Offset(width * 0.50, _boardHeight * 0.55)];
    const yBottom = _boardHeight * 0.82;
    const yTop = _boardHeight * 0.18;
    final yRange = yBottom - yTop;
    return List.generate(count, (i) {
      final t = i / (count - 1); // 0..1  bottom→top
      final y = yBottom - t * yRange;
      final x = i.isEven ? width * 0.22 : width * 0.72;
      return Offset(x, y);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final positions = _positions(w, mysteries.length);

        final board = SizedBox(
          width: w,
          height: _boardHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Soft gradient sky
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        world.primaryColor.withValues(alpha: 0.08),
                        world.secondaryColor,
                      ],
                    ),
                  ),
                ),
              ),

              // Ground strip at the bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: world.primaryColor.withValues(alpha: 0.15),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(DdTheme.radiusL),
                    ),
                  ),
                ),
              ),

              // Floating background decorations
              _BoardDecorations(world: world, width: w),

              // Dashed path connecting nodes
              CustomPaint(
                size: Size(w, _boardHeight),
                painter: _PathPainter(
                  positions: positions,
                  color: world.primaryColor.withValues(alpha: 0.45),
                ),
              ),

              // Mystery nodes (bottom to top)
              for (int i = 0; i < mysteries.length; i++)
                _MysteryNode(
                  mystery: mysteries[i],
                  world: world,
                  index: i,
                  position: positions[i],
                  isUnlocked: i == 0 ||
                      progress.isCompleted(mysteries[i - 1].id),
                  isCompleted: progress.isCompleted(mysteries[i].id),
                  stars: progress.starsFor(mysteries[i].id),
                  onTap: onTap,
                ),

              // Animated player (Mira) above current node
              if (currentIndex < mysteries.length)
                _PlayerMira(
                  world: world,
                  position: positions[currentIndex],
                ),

              // Trophy when all mysteries complete
              if (currentIndex == mysteries.length && mysteries.isNotEmpty)
                _TrophyBadge(position: positions.last, world: world),
            ],
          ),
        );

        return SingleChildScrollView(child: board);
      },
    );
  }
}

// ── Path painter ──────────────────────────────────────────────────────────────

class _PathPainter extends CustomPainter {
  final List<Offset> positions;
  final Color color;

  const _PathPainter({required this.positions, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (positions.length < 2) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < positions.length - 1; i++) {
      _drawDashed(canvas, paint, positions[i], positions[i + 1]);
    }
  }

  void _drawDashed(Canvas canvas, Paint paint, Offset a, Offset b) {
    const dash = 14.0;
    const gap = 10.0;
    final delta = b - a;
    final dist = delta.distance;
    if (dist == 0) return;
    final dir = delta / dist;
    double d = 0;
    bool on = true;
    while (d < dist) {
      final seg = on ? dash : gap;
      final end = math.min(d + seg, dist);
      if (on) canvas.drawLine(a + dir * d, a + dir * end, paint);
      d += seg;
      on = !on;
    }
  }

  @override
  bool shouldRepaint(_PathPainter old) => false;
}

// ── Mystery node ──────────────────────────────────────────────────────────────

class _MysteryNode extends StatelessWidget {
  final Mystery mystery;
  final World world;
  final int index;
  final Offset position;
  final bool isUnlocked;
  final bool isCompleted;
  final int stars;
  final void Function(Mystery) onTap;

  const _MysteryNode({
    required this.mystery,
    required this.world,
    required this.index,
    required this.position,
    required this.isUnlocked,
    required this.isCompleted,
    required this.stars,
    required this.onTap,
  });

  static const double _r = 40;

  @override
  Widget build(BuildContext context) {
    final character = SampleData.characterById(mystery.characterId);
    final nodeColor = isCompleted
        ? world.primaryColor
        : isUnlocked
            ? Colors.white
            : Colors.grey.shade200;
    final borderColor = isCompleted
        ? world.primaryColor
        : isUnlocked
            ? world.primaryColor
            : Colors.grey.shade400;

    return Positioned(
      left: position.dx - _r,
      top: position.dy - _r,
      child: GestureDetector(
        onTap: isUnlocked ? () => onTap(mystery) : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circle node
            Container(
              width: _r * 2,
              height: _r * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: nodeColor,
                border: Border.all(color: borderColor, width: 4),
                boxShadow: isUnlocked
                    ? [
                        BoxShadow(
                          color: world.primaryColor.withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: isCompleted
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '⭐' * stars.clamp(1, 3),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      )
                    : isUnlocked
                        ? Text(
                            character?.emoji ?? '${index + 1}',
                            style: const TextStyle(fontSize: 30),
                          )
                        : const Icon(
                            Icons.lock_rounded,
                            color: Colors.grey,
                            size: 26,
                          ),
              ),
            ),
            const SizedBox(height: 6),
            // Label
            SizedBox(
              width: 110,
              child: Text(
                mystery.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isUnlocked
                      ? DdTheme.warmBrown
                      : Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Animated Mira at current node ────────────────────────────────────────────

class _PlayerMira extends StatelessWidget {
  final World world;
  final Offset position;

  const _PlayerMira({required this.world, required this.position});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx - 34,
      top: position.dy - 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CuteFoxDetective(size: 52),
          const SizedBox(height: 3),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: world.primaryColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: world.primaryColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              'Mira',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Trophy when all complete ──────────────────────────────────────────────────

class _TrophyBadge extends StatelessWidget {
  final Offset position;
  final World world;

  const _TrophyBadge({required this.position, required this.world});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx - 50,
      top: position.dy - 110,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AnimatedAnimal(
            emoji: '🏆',
            size: 42,
            amplitude: 8,
            period: Duration(milliseconds: 1100),
          ),
          const SizedBox(height: 4),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: DdTheme.starGold,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: DdTheme.starGold.withValues(alpha: 0.45),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Text(
              'Alt løst! 🎉',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Floating decorations in background ───────────────────────────────────────

class _BoardDecorations extends StatelessWidget {
  final World world;
  final double width;

  const _BoardDecorations({required this.world, required this.width});

  static const _forestEmojis = ['🌲', '🌿', '🍄', '🌸', '🦋', '🌳'];
  static const _farmEmojis = ['🌾', '🌻', '🐝', '🌼', '🍀', '🌺'];

  @override
  Widget build(BuildContext context) {
    final emojis =
        world.id == 'forest' ? _forestEmojis : _farmEmojis;
    const boardH = _GameBoard._boardHeight;

    // Fixed positions that avoid the center path zone
    final positions = [
      Offset(width * 0.88, boardH * 0.06),
      Offset(width * 0.03, boardH * 0.12),
      Offset(width * 0.85, boardH * 0.40),
      Offset(width * 0.04, boardH * 0.52),
      Offset(width * 0.80, boardH * 0.74),
      Offset(width * 0.06, boardH * 0.80),
    ];

    return IgnorePointer(
      child: Stack(
        children: [
          for (int i = 0; i < math.min(emojis.length, positions.length); i++)
            Positioned(
              left: positions[i].dx,
              top: positions[i].dy,
              child: AnimatedAnimal(
                emoji: emojis[i],
                size: 26,
                amplitude: 4 + (i % 4) * 2.0,
                period: Duration(milliseconds: 1600 + i * 220),
                delay: Duration(milliseconds: i * 120),
              ),
            ),
        ],
      ),
    );
  }
}
