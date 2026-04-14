import 'package:flutter/material.dart';
import 'package:dyredetektiv/app/theme.dart';
import 'package:dyredetektiv/models/minigame_config.dart';
import 'package:dyredetektiv/widgets/character_dialog.dart';

/// ReadGame (MG-05) — player reads a short text clue and picks the correct
/// answer from 4 options. Wrong taps flash red and reset; correct tap
/// turns green and completes the game.
class ReadGameWidget extends StatefulWidget {
  final MinigameConfig config;
  final void Function(bool correct) onCompleted;
  final VoidCallback onHintUsed;

  const ReadGameWidget({
    required this.config,
    required this.onCompleted,
    required this.onHintUsed,
    super.key,
  });

  @override
  State<ReadGameWidget> createState() => _ReadGameWidgetState();
}

class _ReadGameWidgetState extends State<ReadGameWidget> {
  late final List<Map<String, Object?>> _options;
  String? _selectedId;
  bool _answered = false;
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    _options = (widget.config.data['options'] as List)
        .map((e) => Map<String, Object?>.from(e as Map))
        .toList();
  }

  String get _readText =>
      widget.config.data['text'] as String? ?? '';
  String get _question =>
      widget.config.data['question'] as String? ?? widget.config.question;
  String get _instruction =>
      widget.config.data['instruction'] as String? ?? 'Les og svar!';

  void _handleSelect(String id, bool isCorrect) {
    if (_answered) return;
    setState(() => _selectedId = id);

    if (isCorrect) {
      setState(() => _answered = true);
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) widget.onCompleted(true);
      });
    } else {
      Future.delayed(const Duration(milliseconds: 650), () {
        if (mounted) setState(() => _selectedId = null);
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
          const SizedBox(height: DdTheme.spaceM),

          // The text clue — big and prominent
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DdTheme.spaceXL,
              vertical: DdTheme.spaceL,
            ),
            decoration: BoxDecoration(
              color: DdTheme.skyBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(DdTheme.radiusL),
              border: Border.all(
                color: DdTheme.skyBlue.withValues(alpha: 0.45),
                width: 2,
              ),
            ),
            child: Text(
              _readText,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: DdTheme.warmBrown,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: DdTheme.spaceXL),

          Text(
            _question,
            style: DdTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DdTheme.spaceL),

          if (!_answered) ...[
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
                style:
                    TextButton.styleFrom(foregroundColor: DdTheme.warmOrange),
              ),
            ),
            if (_showHint) ...[
              const SizedBox(height: DdTheme.spaceS),
              HintBubble(hint: widget.config.hint),
            ],
            const SizedBox(height: DdTheme.spaceM),
          ],

          // Answer grid (2 × 2)
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: DdTheme.spaceM,
            mainAxisSpacing: DdTheme.spaceM,
            childAspectRatio: 1.25,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: _options.map((opt) {
              final id = opt['id'] as String;
              final label = opt['label'] as String;
              final emoji = opt['emoji'] as String;
              final isCorrect = opt['correct'] as bool;
              final isSelected = _selectedId == id;

              return _OptionCard(
                label: label,
                emoji: emoji,
                isCorrect: isCorrect,
                isSelected: isSelected,
                answered: _answered,
                onTap: () => _handleSelect(id, isCorrect),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Answer option card ────────────────────────────────────────────────────────

class _OptionCard extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isCorrect;
  final bool isSelected;
  final bool answered;
  final VoidCallback onTap;

  const _OptionCard({
    required this.label,
    required this.emoji,
    required this.isCorrect,
    required this.isSelected,
    required this.answered,
    required this.onTap,
  });

  Color get _bg {
    if (!isSelected) return DdTheme.cardWhite;
    return isCorrect ? DdTheme.successGreen : DdTheme.errorRed;
  }

  Color get _textColor => isSelected ? Colors.white : DdTheme.warmBrown;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(DdTheme.radiusL),
        border: Border.all(
          color: isSelected
              ? (isCorrect ? DdTheme.successGreen : DdTheme.errorRed)
              : DdTheme.lockGrey.withValues(alpha: 0.3),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
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
          child: Padding(
            padding: const EdgeInsets.all(DdTheme.spaceM),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isSelected && isCorrect)
                  const Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 32)
                else if (isSelected && !isCorrect)
                  const Icon(Icons.cancel_rounded,
                      color: Colors.white, size: 32)
                else
                  Text(emoji, style: const TextStyle(fontSize: 38)),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
