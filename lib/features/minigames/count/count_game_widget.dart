import 'package:flutter/material.dart';
import 'package:dyredetektiv/app/theme.dart';
import 'package:dyredetektiv/models/minigame_config.dart';
import 'package:dyredetektiv/widgets/character_dialog.dart';

/// CountGame — the player counts emoji objects on screen and taps the right number.
///
/// Callbacks:
///   [onCompleted]  — called with `true` when the correct answer is selected
///   [onHintUsed]   — called each time the player taps the hint button
class CountGameWidget extends StatefulWidget {
  final MinigameConfig config;
  final void Function(bool correct) onCompleted;
  final VoidCallback onHintUsed;

  const CountGameWidget({
    required this.config,
    required this.onCompleted,
    required this.onHintUsed,
    super.key,
  });

  @override
  State<CountGameWidget> createState() => _CountGameWidgetState();
}

class _CountGameWidgetState extends State<CountGameWidget> {
  int? _selectedAnswer;
  bool _answered = false;
  bool _showHint = false;

  void _handleAnswer(int value) {
    if (_answered) return;
    setState(() {
      _selectedAnswer = value;
      _answered = true;
    });

    // Short delay so the player sees the feedback before moving on
    Future.delayed(
      const Duration(milliseconds: 900),
      () {
        if (mounted) widget.onCompleted(value == widget.config.correctCount);
      },
    );
  }

  void _handleWrongAttempt(int value) {
    setState(() {
      _selectedAnswer = value;
    });
    // Reset selection after 600 ms to allow another try
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _selectedAnswer = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DdTheme.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Context text (character flavour)
          if (widget.config.contextText.isNotEmpty)
            GameContextCard(text: widget.config.contextText),
          const SizedBox(height: DdTheme.spaceL),

          // Question
          Text(
            widget.config.question,
            style: DdTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DdTheme.spaceXL),

          // Emoji grid to count
          _EmojiGrid(
            emoji: widget.config.emoji,
            count: widget.config.correctCount,
          ),
          const SizedBox(height: DdTheme.spaceXL),

          // Hint button
          if (!_answered)
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
                style: TextButton.styleFrom(
                  foregroundColor: DdTheme.warmOrange,
                ),
              ),
            ),

          if (_showHint) ...[
            const SizedBox(height: DdTheme.spaceM),
            HintBubble(hint: widget.config.hint),
          ],

          const SizedBox(height: DdTheme.spaceL),

          // Answer options
          _AnswerGrid(
            options: widget.config.options,
            correctAnswer: widget.config.correctCount,
            selectedAnswer: _selectedAnswer,
            answered: _answered,
            onTap: (value) {
              if (value == widget.config.correctCount) {
                _handleAnswer(value);
              } else {
                _handleWrongAttempt(value);
              }
            },
          ),
        ],
      ),
    );
  }
}

// ── Emoji grid ────────────────────────────────────────────────────────────────

class _EmojiGrid extends StatelessWidget {
  final String emoji;
  final int count;

  const _EmojiGrid({required this.emoji, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DdTheme.spaceL),
      decoration: BoxDecoration(
        color: DdTheme.cardWhite,
        borderRadius: BorderRadius.circular(DdTheme.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: DdTheme.spaceM,
        runSpacing: DdTheme.spaceM,
        children: List.generate(
          count,
          (i) => Text(emoji, style: const TextStyle(fontSize: 42)),
        ),
      ),
    );
  }
}

// ── Answer grid ───────────────────────────────────────────────────────────────

class _AnswerGrid extends StatelessWidget {
  final List<int> options;
  final int correctAnswer;
  final int? selectedAnswer;
  final bool answered;
  final void Function(int) onTap;

  const _AnswerGrid({
    required this.options,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.answered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: DdTheme.spaceM,
      mainAxisSpacing: DdTheme.spaceM,
      childAspectRatio: 2.2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: options.map((value) => _AnswerButton(
            value: value,
            isCorrect: value == correctAnswer,
            isSelected: value == selectedAnswer,
            answered: answered,
            onTap: () => onTap(value),
          )).toList(),
    );
  }
}

// ── Single answer button ──────────────────────────────────────────────────────

class _AnswerButton extends StatelessWidget {
  final int value;
  final bool isCorrect;
  final bool isSelected;
  final bool answered;
  final VoidCallback onTap;

  const _AnswerButton({
    required this.value,
    required this.isCorrect,
    required this.isSelected,
    required this.answered,
    required this.onTap,
  });

  Color get _backgroundColor {
    if (!isSelected) return DdTheme.cardWhite;
    if (isCorrect) return DdTheme.successGreen;
    return DdTheme.errorRed;
  }

  Color get _textColor {
    if (isSelected) return Colors.white;
    return DdTheme.warmBrown;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(DdTheme.radiusL),
        border: Border.all(
          color: isSelected
              ? (isCorrect ? DdTheme.successGreen : DdTheme.errorRed)
              : DdTheme.lockGrey.withValues(alpha: 0.3),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(DdTheme.radiusL),
          onTap: answered ? null : onTap,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected && isCorrect)
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.check_circle_rounded,
                        color: Colors.white, size: 24),
                  ),
                if (isSelected && !isCorrect)
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.cancel_rounded,
                        color: Colors.white, size: 24),
                  ),
                Text(
                  '$value',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: _textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

