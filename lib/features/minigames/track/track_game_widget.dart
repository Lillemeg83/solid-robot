import 'package:flutter/material.dart';
import 'package:dyredetektiv/app/theme.dart';
import 'package:dyredetektiv/models/minigame_config.dart';
import 'package:dyredetektiv/widgets/character_dialog.dart';

/// TrackGame (MG-01) — player taps numbered footprints in sequence (1 → N).
/// Steps are scattered across a play area. Tapping out of order gives a brief
/// red flash. All steps done → complete.
class TrackGameWidget extends StatefulWidget {
  final MinigameConfig config;
  final void Function(bool correct) onCompleted;
  final VoidCallback onHintUsed;

  const TrackGameWidget({
    required this.config,
    required this.onCompleted,
    required this.onHintUsed,
    super.key,
  });

  @override
  State<TrackGameWidget> createState() => _TrackGameWidgetState();
}

class _TrackGameWidgetState extends State<TrackGameWidget> {
  int _nextStep = 1;
  final Set<int> _tapped = {};
  int? _errorStep;
  bool _showHint = false;

  // Pre-defined fractional positions (dx, dy) for up to 6 steps.
  // They trace a loose S-curve across the play area.
  static const List<Offset> _positions = [
    Offset(0.12, 0.08),
    Offset(0.62, 0.12),
    Offset(0.72, 0.50),
    Offset(0.28, 0.62),
    Offset(0.10, 0.84),
    Offset(0.58, 0.84),
  ];

  String get _instruction =>
      widget.config.data['instruction'] as String? ?? 'Trykk i riktig rekkefølge!';
  String get _emoji => widget.config.emoji;
  int get _steps => widget.config.data['steps'] as int? ?? 4;

  void _onStepTap(int step) {
    if (_tapped.contains(step)) return;

    if (step == _nextStep) {
      setState(() {
        _tapped.add(step);
        _nextStep++;
      });
      if (_tapped.length == _steps) {
        Future.delayed(const Duration(milliseconds: 700), () {
          if (mounted) widget.onCompleted(true);
        });
      }
    } else {
      setState(() => _errorStep = step);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => _errorStep = null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DdTheme.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.config.contextText.isNotEmpty)
            GameContextCard(text: widget.config.contextText),
          const SizedBox(height: DdTheme.spaceM),

          Text(
            _instruction,
            style: DdTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DdTheme.spaceS),

          // Progress counter
          Text(
            'Steg ${_tapped.length} / $_steps',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: DdTheme.warmBrown.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DdTheme.spaceM),

          // Play area
          LayoutBuilder(
            builder: (context, constraints) {
              const itemSize = 64.0;
              const areaHeight = 310.0;
              final areaWidth = constraints.maxWidth;
              final positions = _positions.take(_steps).toList();

              return Container(
                width: areaWidth,
                height: areaHeight,
                decoration: BoxDecoration(
                  color: DdTheme.forestLight.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(DdTheme.radiusL),
                  border: Border.all(
                    color: DdTheme.forestGreen.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  children: [
                    for (int i = 0; i < positions.length; i++)
                      Positioned(
                        left: positions[i].dx * (areaWidth - itemSize),
                        top: positions[i].dy * (areaHeight - itemSize),
                        child: SizedBox(
                          width: itemSize,
                          height: itemSize,
                          child: _FootprintStep(
                            number: i + 1,
                            emoji: _emoji,
                            tapped: _tapped.contains(i + 1),
                            isNext: i + 1 == _nextStep,
                            hasError: _errorStep == i + 1,
                            onTap: () => _onStepTap(i + 1),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: DdTheme.spaceL),

          Center(
            child: TextButton.icon(
              onPressed: () {
                widget.onHintUsed();
                setState(() => _showHint = true);
              },
              icon: const Text('🐸', style: TextStyle(fontSize: 20)),
              label: const Text(
                'Hint fra Professor Padde',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              style: TextButton.styleFrom(foregroundColor: DdTheme.warmOrange),
            ),
          ),
          if (_showHint) ...[
            const SizedBox(height: DdTheme.spaceS),
            HintBubble(hint: widget.config.hint),
          ],
        ],
      ),
    );
  }
}

// ── Single footprint step ─────────────────────────────────────────────────────

class _FootprintStep extends StatelessWidget {
  final int number;
  final String emoji;
  final bool tapped;
  final bool isNext;
  final bool hasError;
  final VoidCallback onTap;

  const _FootprintStep({
    required this.number,
    required this.emoji,
    required this.tapped,
    required this.isNext,
    required this.hasError,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color border;

    if (tapped) {
      bg = DdTheme.successGreen;
      border = DdTheme.successGreen;
    } else if (hasError) {
      bg = DdTheme.errorRed.withValues(alpha: 0.15);
      border = DdTheme.errorRed;
    } else if (isNext) {
      bg = DdTheme.warmOrange.withValues(alpha: 0.18);
      border = DdTheme.warmOrange;
    } else {
      bg = DdTheme.cardWhite;
      border = DdTheme.lockGrey.withValues(alpha: 0.4);
    }

    return GestureDetector(
      onTap: tapped ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: border, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: tapped
            ? const Center(
                child: Icon(Icons.check_rounded, color: Colors.white, size: 28),
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  Text(emoji,
                      style: TextStyle(
                        fontSize: isNext ? 26 : 22,
                      )),
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: isNext ? DdTheme.warmOrange : DdTheme.warmBrown,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$number',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
