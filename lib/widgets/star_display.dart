import 'package:flutter/material.dart';
import 'package:dyredetektiv/app/theme.dart';

/// Renders 1–3 filled/empty stars. Used on mystery cards and the reward screen.
class StarDisplay extends StatelessWidget {
  final int earned; // 0–3
  final int total; // usually 3
  final double size;

  const StarDisplay({
    required this.earned,
    this.total = 3,
    this.size = 28,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final filled = i < earned;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Icon(
            filled ? Icons.star_rounded : Icons.star_outline_rounded,
            color: filled ? DdTheme.starGold : DdTheme.lockGrey,
            size: size,
          ),
        );
      }),
    );
  }
}

/// Animated star pop-in — shown on the reward screen.
class AnimatedStarDisplay extends StatefulWidget {
  final int stars;

  const AnimatedStarDisplay({required this.stars, super.key});

  @override
  State<AnimatedStarDisplay> createState() => _AnimatedStarDisplayState();
}

class _AnimatedStarDisplayState extends State<AnimatedStarDisplay>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _scales;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );
    _scales = _controllers
        .map(
          (c) => Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: c, curve: Curves.elasticOut),
          ),
        )
        .toList();

    // Stagger the star animations
    for (int i = 0; i < widget.stars; i++) {
      Future.delayed(Duration(milliseconds: 200 + i * 300), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final earned = i < widget.stars;
        return ScaleTransition(
          scale: _scales[i],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              earned ? Icons.star_rounded : Icons.star_outline_rounded,
              color: earned ? DdTheme.starGold : DdTheme.lockGrey,
              size: 64,
            ),
          ),
        );
      }),
    );
  }
}
