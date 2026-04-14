import 'package:flutter/material.dart';

/// Cute detective fox composed from three emoji:
/// 🎩 (hat) above + 🦊 (fox body) + 🔍 (magnifying glass) to the right.
///
/// [size] controls the fox body font size; hat and glass scale proportionally.
class DetectiveFox extends StatelessWidget {
  final double size;

  const DetectiveFox({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    final hatSize = size * 0.50;
    final glassSize = size * 0.44;
    // Total canvas so nothing clips
    final totalW = size * 1.65;
    final totalH = size * 1.72;

    return SizedBox(
      width: totalW,
      height: totalH,
      child: Stack(
        children: [
          // 🎩 hat — above and centered over the fox head
          Positioned(
            top: 0,
            left: totalW * 0.08,
            child: Text('🎩', style: TextStyle(fontSize: hatSize)),
          ),
          // 🦊 fox body
          Positioned(
            top: totalH * 0.27,
            left: 0,
            child: Text('🦊', style: TextStyle(fontSize: size)),
          ),
          // 🔍 magnifying glass — lower-right (held in paw)
          Positioned(
            top: totalH * 0.52,
            right: 0,
            child: Text('🔍', style: TextStyle(fontSize: glassSize)),
          ),
        ],
      ),
    );
  }
}

/// Animated [DetectiveFox] that gently bobs and (optionally) pulses.
class AnimatedDetectiveFox extends StatefulWidget {
  final double size;
  final double amplitude;
  final Duration period;
  final bool bouncy;

  const AnimatedDetectiveFox({
    super.key,
    this.size = 48,
    this.amplitude = 7,
    this.period = const Duration(milliseconds: 1100),
    this.bouncy = false,
  });

  @override
  State<AnimatedDetectiveFox> createState() => _AnimatedDetectiveFoxState();
}

class _AnimatedDetectiveFoxState extends State<AnimatedDetectiveFox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.period);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _ctrl.repeat(reverse: true);
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
        final t = _anim.value;
        final dy = (t - 0.5) * 2 * widget.amplitude;
        final scale = widget.bouncy ? 1.0 + t * 0.08 : 1.0;
        return Transform.translate(
          offset: Offset(0, dy),
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: DetectiveFox(size: widget.size),
    );
  }
}
