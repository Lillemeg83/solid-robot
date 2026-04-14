import 'package:flutter/material.dart';

/// A floating / bouncing animal emoji that continuously animates.
///
/// Use [amplitude] to control how many pixels it floats up and down.
/// Use [bouncy] to also add a gentle scale pulse.
/// Use [delay] to stagger multiple animals so they don't all move in sync.
class AnimatedAnimal extends StatefulWidget {
  final String emoji;
  final double size;
  final Duration period;
  final Duration delay;
  final double amplitude;
  final bool bouncy;

  const AnimatedAnimal({
    super.key,
    required this.emoji,
    this.size = 36,
    this.period = const Duration(milliseconds: 1800),
    this.delay = Duration.zero,
    this.amplitude = 8,
    this.bouncy = false,
  });

  @override
  State<AnimatedAnimal> createState() => _AnimatedAnimalState();
}

class _AnimatedAnimalState extends State<AnimatedAnimal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.period);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) {
        final t = _anim.value; // 0 → 1
        final dy = (t - 0.5) * 2 * widget.amplitude;
        final scale = widget.bouncy ? 1.0 + t * 0.10 : 1.0;
        return Transform.translate(
          offset: Offset(0, dy),
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: Text(widget.emoji, style: TextStyle(fontSize: widget.size)),
    );
  }
}
