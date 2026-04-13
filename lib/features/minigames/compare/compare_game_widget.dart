import 'package:flutter/material.dart';
import 'package:dyredetektiv/app/theme.dart';
import 'package:dyredetektiv/models/minigame_config.dart';
import 'package:dyredetektiv/widgets/character_dialog.dart';

/// CompareGame (MG-12) — player compares 2–3 items shown with repeating value
/// icons and picks the correct one (biggest, most, smallest, etc.).
class CompareGameWidget extends StatefulWidget {
  final MinigameConfig config;
  final void Function(bool correct) onCompleted;
  final VoidCallback onHintUsed;

  const CompareGameWidget({
    required this.config,
    required this.onCompleted,
    required this.onHintUsed,
    super.key,
  });

  @override
  State<CompareGameWidget> createState() => _CompareGameWidgetState();
}

class _CompareGameWidgetState extends State<CompareGameWidget> {
  late final List<Map<String, Object?>> _items;
  String? _selectedId;
  bool _answered = false;
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    _items = (widget.config.data['items'] as List)
        .map((e) => Map<String, Object?>.from(e as Map))
        .toList();
  }

  String get _question =>
      widget.config.data['question'] as String? ?? widget.config.question;
  String get _instruction =>
      widget.config.data['instruction'] as String? ?? 'Sammenlign og velg!';
  String get _valueEmoji =>
      widget.config.data['valueEmoji'] as String? ?? '●';

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
          const SizedBox(height: DdTheme.spaceS),

          Text(
            _question,
            style: DdTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DdTheme.spaceXL),

          // Item cards — horizontal row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _items.map((item) {
              final id = item['id'] as String;
              final label = item['label'] as String;
              final emoji = item['emoji'] as String;
              final value = item['value'] as int;
              final isCorrect = item['correct'] as bool;
              final isSelected = _selectedId == id;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: DdTheme.spaceXS),
                  child: _CompareCard(
                    label: label,
                    emoji: emoji,
                    value: value,
                    valueEmoji: _valueEmoji,
                    isCorrect: isCorrect,
                    isSelected: isSelected,
                    answered: _answered,
                    onTap: () => _handleSelect(id, isCorrect),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: DdTheme.spaceXL),

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
          ],
        ],
      ),
    );
  }
}

// ── Compare card ──────────────────────────────────────────────────────────────

class _CompareCard extends StatelessWidget {
  final String label;
  final String emoji;
  final int value;
  final String valueEmoji;
  final bool isCorrect;
  final bool isSelected;
  final bool answered;
  final VoidCallback onTap;

  const _CompareCard({
    required this.label,
    required this.emoji,
    required this.value,
    required this.valueEmoji,
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
    // Build a visual "bar" of value emojis stacked vertically
    final valueWidgets = List.generate(
      value,
      (_) => Text(
        valueEmoji,
        style: TextStyle(
          fontSize: isSelected ? 16 : 18,
          height: 1.3,
        ),
        textAlign: TextAlign.center,
      ),
    );

    return GestureDetector(
      onTap: answered ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(DdTheme.radiusL),
          border: Border.all(
            color: isSelected
                ? (isCorrect ? DdTheme.successGreen : DdTheme.errorRed)
                : DdTheme.lockGrey.withOpacity(0.3),
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DdTheme.spaceM,
          vertical: DdTheme.spaceM,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Value column (visual bar)
            Column(
              children: valueWidgets.reversed.toList(),
            ),
            const SizedBox(height: DdTheme.spaceS),
            const Divider(height: 1),
            const SizedBox(height: DdTheme.spaceS),

            // Animal emoji
            if (isSelected && isCorrect)
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 30)
            else if (isSelected && !isCorrect)
              const Icon(Icons.cancel_rounded, color: Colors.white, size: 30)
            else
              Text(emoji, style: const TextStyle(fontSize: 38)),

            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
