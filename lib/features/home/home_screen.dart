import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dyredetektiv/app/theme.dart';
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
            _Background(),
            _Content(),
          ],
        ),
      ),
    );
  }
}

// ── Decorative background ─────────────────────────────────────────────────────

class _Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: IgnorePointer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16),
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
            // Logo / title
            _LogoSection(),
            const SizedBox(height: DdTheme.spaceXXL),

            // Play button
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

            // Detective Book button
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

            // Parent section button (smaller, less prominent)
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

class _LogoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mira avatar
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: DdTheme.lightGreen.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: DdTheme.lightGreen, width: 3),
          ),
          child: const Center(
            child: Text('🦔', style: TextStyle(fontSize: 64)),
          ),
        ),
        const SizedBox(height: DdTheme.spaceL),

        // App title
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

        // Tagline
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
