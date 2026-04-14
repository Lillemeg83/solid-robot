import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dyredetektiv/app/theme.dart';
import 'package:dyredetektiv/widgets/animated_animal.dart';
import 'package:dyredetektiv/widgets/cute_fox_detective.dart';
import 'package:dyredetektiv/widgets/dd_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DdTheme.backgroundWarm,
      body: SafeArea(
        child: Stack(
          children: [
            const _FloatingAnimals(),
            const _TreeRow(),
            _Content(),
          ],
        ),
      ),
    );
  }
}

// ── Floating background animals ───────────────────────────────────────────────

class _FloatingAnimals extends StatelessWidget {
  const _FloatingAnimals();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          return Stack(
            children: [
              Positioned(
                left: w * 0.05,
                top: h * 0.08,
                child: const AnimatedAnimal(
                  emoji: '🦊',
                  size: 38,
                  amplitude: 9,
                  period: Duration(milliseconds: 2000),
                  delay: Duration(milliseconds: 0),
                ),
              ),
              Positioned(
                right: w * 0.06,
                top: h * 0.12,
                child: const AnimatedAnimal(
                  emoji: '🐰',
                  size: 34,
                  amplitude: 7,
                  period: Duration(milliseconds: 1700),
                  delay: Duration(milliseconds: 300),
                ),
              ),
              Positioned(
                left: w * 0.08,
                top: h * 0.38,
                child: const AnimatedAnimal(
                  emoji: '🦋',
                  size: 28,
                  amplitude: 11,
                  period: Duration(milliseconds: 1500),
                  delay: Duration(milliseconds: 150),
                ),
              ),
              Positioned(
                right: w * 0.07,
                top: h * 0.42,
                child: const AnimatedAnimal(
                  emoji: '🐿️',
                  size: 30,
                  amplitude: 8,
                  period: Duration(milliseconds: 2200),
                  delay: Duration(milliseconds: 450),
                ),
              ),
              Positioned(
                left: w * 0.12,
                top: h * 0.65,
                child: const AnimatedAnimal(
                  emoji: '🐦',
                  size: 26,
                  amplitude: 12,
                  period: Duration(milliseconds: 1400),
                  delay: Duration(milliseconds: 600),
                ),
              ),
              Positioned(
                right: w * 0.10,
                top: h * 0.68,
                child: const AnimatedAnimal(
                  emoji: '🍄',
                  size: 24,
                  amplitude: 5,
                  period: Duration(milliseconds: 2500),
                  delay: Duration(milliseconds: 200),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Tree row at the bottom ────────────────────────────────────────────────────

class _TreeRow extends StatelessWidget {
  const _TreeRow();

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: IgnorePointer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('🌲', style: TextStyle(fontSize: 48)),
                  Text('🌳', style: TextStyle(fontSize: 36)),
                  Text('🌲', style: TextStyle(fontSize: 52)),
                  Text('🌳', style: TextStyle(fontSize: 40)),
                  Text('🌲', style: TextStyle(fontSize: 44)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Main content ──────────────────────────────────────────────────────────────

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(DdTheme.spaceXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LogoSection(),
            const SizedBox(height: DdTheme.spaceXXL),
            DdButton(
              label: 'Spill!',
              emoji: '🔍',
              backgroundColor: DdTheme.warmOrange,
              width: double.infinity,
              height: 72,
              fontSize: 22,
              onPressed: () => context.go('/map'),
            ),
            const SizedBox(height: DdTheme.spaceM),
            DdButton(
              label: 'Detektivboken',
              emoji: '📖',
              backgroundColor: DdTheme.skyBlue,
              width: double.infinity,
              height: 60,
              fontSize: 18,
              onPressed: () => context.go('/collection'),
            ),
            const SizedBox(height: DdTheme.spaceM),
            TextButton.icon(
              onPressed: () => context.go('/parent'),
              icon: const Icon(Icons.lock_outline, size: 18),
              label: const Text(
                'Foreldreseksjon',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: TextButton.styleFrom(
                foregroundColor: DdTheme.warmBrown.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Logo / title section ──────────────────────────────────────────────────────

class _LogoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mira — animated detective fox
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: DdTheme.warmOrange.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: DdTheme.warmOrange, width: 3),
            boxShadow: [
              BoxShadow(
                color: DdTheme.warmOrange.withValues(alpha: 0.25),
                blurRadius: 22,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Center(
            child: CuteFoxDetective(size: 78),
          ),
        ),
        const SizedBox(height: DdTheme.spaceL),
        const Text(
          'Dyredetektiv',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            color: DdTheme.primaryGreen,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: DdTheme.spaceS),
        Text(
          'Løs mysterier med dyrene!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: DdTheme.warmBrown.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
