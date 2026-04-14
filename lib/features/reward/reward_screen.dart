import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dyredetektiv/app/theme.dart';
import 'package:dyredetektiv/core/ads/ad_service.dart';
import 'package:dyredetektiv/data/sample_data.dart';
import 'package:dyredetektiv/providers/progress_provider.dart';
import 'package:dyredetektiv/widgets/dd_button.dart';
import 'package:dyredetektiv/widgets/star_display.dart';

/// Celebrates a solved mystery, saves progress, and offers navigation forward.
class RewardScreen extends ConsumerStatefulWidget {
  final String mysteryId;
  final int stars;

  const RewardScreen({
    required this.mysteryId,
    required this.stars,
    super.key,
  });

  @override
  ConsumerState<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends ConsumerState<RewardScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnimation;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bounceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
    _bounceController.forward();
    _saveAndShowAd();
  }

  Future<void> _saveAndShowAd() async {
    if (_saved) return;
    _saved = true;

    // Persist the result
    final clampedStars = widget.stars.clamp(1, 3);
    await ref
        .read(progressProvider.notifier)
        .completeMystery(widget.mysteryId, clampedStars);

    // Collect the character into the detective book
    final mystery = SampleData.mysteryById(widget.mysteryId);
    if (mystery != null) {
      await ref
          .read(progressProvider.notifier)
          .collectCharacter(mystery.characterId);
    }

    // Show an interstitial ad between mysteries (stub in MVP)
    await AdService.instance.showPostMysteryAd();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mystery = SampleData.mysteryById(widget.mysteryId);
    final character = mystery != null
        ? SampleData.characterById(mystery.characterId)
        : null;
    final nextMystery = mystery != null
        ? SampleData.nextMystery(widget.mysteryId)
        : null;

    final stars = widget.stars.clamp(1, 3);
    final message = stars == 3
        ? 'Perfekt! Du er en ekte detektiv! 🕵️'
        : stars == 2
            ? 'Bra jobbet! Du løste saken! 🎉'
            : 'Du klarte det! Øv mer for å få flere stjerner! 💪';

    return Scaffold(
      backgroundColor: DdTheme.backgroundWarm,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(DdTheme.spaceXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Character celebration
              ScaleTransition(
                scale: _bounceAnimation,
                child: Column(
                  children: [
                    Text(
                      character?.emoji ?? '🎉',
                      style: const TextStyle(fontSize: 96),
                    ),
                    const SizedBox(height: DdTheme.spaceM),
                    const Text(
                      'Saken er løst!',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: DdTheme.primaryGreen,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: DdTheme.spaceXL),

              // Stars
              AnimatedStarDisplay(stars: stars),
              const SizedBox(height: DdTheme.spaceM),

              Text(
                message,
                style: DdTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DdTheme.spaceXL),

              // New character collected badge
              if (character != null)
                Container(
                  padding: const EdgeInsets.all(DdTheme.spaceM),
                  decoration: BoxDecoration(
                    color: DdTheme.starGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(DdTheme.radiusM),
                    border: Border.all(
                        color: DdTheme.starGold.withValues(alpha: 0.5), width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('📖', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: DdTheme.spaceS),
                      Text(
                        '${character.name} ${character.emoji} er lagt til i detektivboken!',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: DdTheme.warmBrown,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: DdTheme.spaceXXL),

              // Navigation buttons
              if (nextMystery != null)
                DdButton(
                  label: 'Neste sak: ${nextMystery.title}',
                  emoji: '➡️',
                  backgroundColor: DdTheme.primaryGreen,
                  width: double.infinity,
                  height: 64,
                  onPressed: () =>
                      context.go('/mystery/${nextMystery.id}'),
                ),
              if (nextMystery != null)
                const SizedBox(height: DdTheme.spaceM),

              DdButton(
                label: 'Tilbake til kartet',
                emoji: '🗺️',
                backgroundColor: DdTheme.skyBlue,
                width: double.infinity,
                height: 64,
                onPressed: () => context.go('/map'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
