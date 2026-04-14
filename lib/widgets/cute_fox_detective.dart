import 'dart:math' as math;
import 'package:flutter/material.dart';

const _foxOrange = Color(0xFFE8821A);
const _foxLight = Color(0xFFF5A633);
const _muzzleColor = Color(0xFFFFF5E8);
const _earPink = Color(0xFFFFB3C1);

/// A fully custom-drawn cute detective fox with:
/// - Pointed triangle ears with pink inner ear
/// - Glossy round head with gradient
/// - Blinking eyes with shine dots
/// - Cream muzzle + black nose
/// - Detective hat (🎩) on top
/// - Magnifying glass (🔍) in paw
///
/// [size] controls the overall scale (default 80).
/// Set [animate] to false for a static version.
class CuteFoxDetective extends StatefulWidget {
  final double size;
  final bool animate;

  const CuteFoxDetective({super.key, this.size = 80, this.animate = true});

  @override
  State<CuteFoxDetective> createState() => _CuteFoxDetectiveState();
}

class _CuteFoxDetectiveState extends State<CuteFoxDetective>
    with TickerProviderStateMixin {
  late final AnimationController _bounceCtrl;
  late final Animation<double> _bounceAnim;
  late final AnimationController _blinkCtrl;
  late final Animation<double> _blinkAnim;
  final _rng = math.Random();

  @override
  void initState() {
    super.initState();

    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );
    _bounceAnim =
        CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut);
    if (widget.animate) _bounceCtrl.repeat(reverse: true);

    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
    );
    _blinkAnim = Tween<double>(begin: 1.0, end: 0.07)
        .animate(CurvedAnimation(parent: _blinkCtrl, curve: Curves.easeInOut));
    if (widget.animate) _scheduleBlink();
  }

  void _scheduleBlink() {
    final ms = 2200 + _rng.nextInt(2800);
    Future.delayed(Duration(milliseconds: ms), () {
      if (!mounted) return;
      _blinkCtrl.forward().then((_) {
        if (!mounted) return;
        _blinkCtrl.reverse().then((_) {
          if (mounted) _scheduleBlink();
        });
      });
    });
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    _blinkCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    // Canvas is wider than the head to fit the magnifying glass on the right
    final cW = s * 1.10;
    final cH = s * 1.32;

    return AnimatedBuilder(
      animation: Listenable.merge([_bounceAnim, _blinkAnim]),
      builder: (_, __) {
        final dy = (_bounceAnim.value - 0.5) * 9;
        return Transform.translate(
          offset: Offset(0, dy),
          child: SizedBox(
            width: cW,
            height: cH,
            child: Stack(children: _layers(s, cW, cH)),
          ),
        );
      },
    );
  }

  List<Widget> _layers(double s, double cW, double cH) {
    final headR = s * 0.335;
    // Head sits in the lower portion of the canvas
    final hCX = cW * 0.44;
    final hCY = cH * 0.70;
    final eyeSize = s * 0.105;
    final eyeY = hCY - headR * 0.06;
    final eyeOff = headR * 0.42;

    return [
      // ── Detective hat ────────────────────────────────────────────────────
      Positioned(
        top: 0,
        left: hCX - s * 0.28,
        child: Text('🎩', style: TextStyle(fontSize: s * 0.38)),
      ),

      // ── Left ear (behind head) ───────────────────────────────────────────
      Positioned(
        top: hCY - headR - s * 0.20,
        left: hCX - headR * 0.85 - s * 0.05,
        child: _Ear(width: s * 0.22, height: s * 0.28),
      ),

      // ── Right ear ────────────────────────────────────────────────────────
      Positioned(
        top: hCY - headR - s * 0.20,
        left: hCX + headR * 0.22,
        child: _Ear(width: s * 0.22, height: s * 0.28),
      ),

      // ── Head circle ──────────────────────────────────────────────────────
      Positioned(
        left: hCX - headR,
        top: hCY - headR,
        child: Container(
          width: headR * 2,
          height: headR * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: const Alignment(-0.35, -0.4),
              radius: 0.85,
              colors: [_foxLight, _foxOrange],
            ),
            boxShadow: [
              BoxShadow(
                color: _foxOrange.withValues(alpha: 0.38),
                blurRadius: s * 0.18,
                offset: Offset(0, s * 0.05),
              ),
            ],
          ),
        ),
      ),

      // ── White forehead patch ─────────────────────────────────────────────
      Positioned(
        left: hCX - headR * 0.28,
        top: hCY - headR * 0.88,
        child: Container(
          width: headR * 0.56,
          height: headR * 0.52,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.40),
            borderRadius: BorderRadius.circular(headR),
          ),
        ),
      ),

      // ── Muzzle ───────────────────────────────────────────────────────────
      Positioned(
        left: hCX - headR * 0.56,
        top: hCY + headR * 0.12,
        child: Container(
          width: headR * 1.12,
          height: headR * 0.72,
          decoration: BoxDecoration(
            color: _muzzleColor,
            borderRadius: BorderRadius.circular(headR * 0.55),
            boxShadow: [
              BoxShadow(
                color: _foxOrange.withValues(alpha: 0.15),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),

      // ── Nose ─────────────────────────────────────────────────────────────
      Positioned(
        left: hCX - s * 0.038,
        top: hCY + headR * 0.18,
        child: Container(
          width: s * 0.076,
          height: s * 0.052,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(s),
          ),
        ),
      ),

      // ── Left eye ─────────────────────────────────────────────────────────
      Positioned(
        left: hCX - eyeOff - eyeSize * 0.5,
        top: eyeY - eyeSize * 0.5,
        child: Transform.scale(
          scaleY: _blinkAnim.value.clamp(0.07, 1.0),
          child: _Eye(size: eyeSize),
        ),
      ),

      // ── Right eye ────────────────────────────────────────────────────────
      Positioned(
        left: hCX + eyeOff - eyeSize * 0.5,
        top: eyeY - eyeSize * 0.5,
        child: Transform.scale(
          scaleY: _blinkAnim.value.clamp(0.07, 1.0),
          child: _Eye(size: eyeSize),
        ),
      ),

      // ── Rosy cheeks ──────────────────────────────────────────────────────
      Positioned(
        left: hCX - headR * 0.80,
        top: hCY + headR * 0.05,
        child: Container(
          width: headR * 0.40,
          height: headR * 0.25,
          decoration: BoxDecoration(
            color: const Color(0xFFFF8FAB).withValues(alpha: 0.40),
            borderRadius: BorderRadius.circular(headR),
          ),
        ),
      ),
      Positioned(
        left: hCX + headR * 0.40,
        top: hCY + headR * 0.05,
        child: Container(
          width: headR * 0.40,
          height: headR * 0.25,
          decoration: BoxDecoration(
            color: const Color(0xFFFF8FAB).withValues(alpha: 0.40),
            borderRadius: BorderRadius.circular(headR),
          ),
        ),
      ),

      // ── Magnifying glass ─────────────────────────────────────────────────
      Positioned(
        right: 0,
        top: hCY,
        child: Text('🔍', style: TextStyle(fontSize: s * 0.30)),
      ),
    ];
  }
}

// ── Eye ───────────────────────────────────────────────────────────────────────

class _Eye extends StatelessWidget {
  final double size;
  const _Eye({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: [
          // Main shine
          Positioned(
            top: size * 0.12,
            left: size * 0.14,
            child: Container(
              width: size * 0.36,
              height: size * 0.36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Secondary tiny shine
          Positioned(
            bottom: size * 0.18,
            right: size * 0.18,
            child: Container(
              width: size * 0.16,
              height: size * 0.16,
              decoration: const BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Ear ───────────────────────────────────────────────────────────────────────

class _Ear extends StatelessWidget {
  final double width;
  final double height;
  const _Ear({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Outer ear
        ClipPath(
          clipper: _TriangleClipper(),
          child: Container(width: width, height: height, color: _foxOrange),
        ),
        // Inner ear (pink)
        ClipPath(
          clipper: _TriangleClipper(),
          child: Container(
            width: width * 0.50,
            height: height * 0.58,
            color: _earPink,
          ),
        ),
      ],
    );
  }
}

class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()
    ..moveTo(size.width / 2, 0)
    ..lineTo(size.width, size.height)
    ..lineTo(0, size.height)
    ..close();

  @override
  bool shouldReclip(_TriangleClipper _) => false;
}
