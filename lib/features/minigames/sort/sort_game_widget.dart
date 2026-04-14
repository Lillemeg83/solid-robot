import 'package:flutter/material.dart';
import 'package:dyredetektiv/app/theme.dart';
import 'package:dyredetektiv/models/minigame_config.dart';
import 'package:dyredetektiv/widgets/character_dialog.dart';

/// SortGame (MG-03) — player taps an item to select it, then taps a bucket
/// to assign it. Correct assignments stay; wrong ones flash and return.
/// Game completes when all items are correctly sorted.
class SortGameWidget extends StatefulWidget {
  final MinigameConfig config;
  final void Function(bool correct) onCompleted;
  final VoidCallback onHintUsed;

  const SortGameWidget({
    required this.config,
    required this.onCompleted,
    required this.onHintUsed,
    super.key,
  });

  @override
  State<SortGameWidget> createState() => _SortGameWidgetState();
}

class _SortGameWidgetState extends State<SortGameWidget> {
  late final List<Map<String, Object?>> _items;
  String? _selectedId;
  final Map<String, String> _assignments = {}; // itemId → 'A' | 'B'
  final Set<String> _errorIds = {};
  bool _showHint = false;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _items = (widget.config.data['items'] as List)
        .map((e) => Map<String, Object?>.from(e as Map))
        .toList();
  }

  String get _instruction =>
      widget.config.data['instruction'] as String? ?? 'Sorter gjenstandene!';
  String get _categoryA =>
      widget.config.data['categoryA'] as String? ?? 'Kategori A';
  String get _categoryAEmoji =>
      widget.config.data['categoryAEmoji'] as String? ?? '📦';
  String get _categoryB =>
      widget.config.data['categoryB'] as String? ?? 'Kategori B';
  String get _categoryBEmoji =>
      widget.config.data['categoryBEmoji'] as String? ?? '📦';

  List<Map<String, Object?>> get _unassigned =>
      _items.where((e) => !_assignments.containsKey(e['id'] as String)).toList();

  List<Map<String, Object?>> _inBucket(String bucket) =>
      _items.where((e) => _assignments[e['id'] as String] == bucket).toList();

  void _onItemTap(String id) {
    if (_assignments.containsKey(id)) return;
    setState(() => _selectedId = (_selectedId == id) ? null : id);
  }

  void _onBucketTap(String bucket) {
    final id = _selectedId;
    if (id == null) return;

    final item = _items.firstWhere((e) => e['id'] == id);
    final correct = item['category'] as String;

    setState(() => _selectedId = null);

    if (bucket == correct) {
      setState(() => _assignments[id] = bucket);
      if (_assignments.length == _items.length) {
        setState(() => _done = true);
        Future.delayed(const Duration(milliseconds: 700), () {
          if (mounted) widget.onCompleted(true);
        });
      }
    } else {
      setState(() => _errorIds.add(id));
      Future.delayed(const Duration(milliseconds: 650), () {
        if (mounted) setState(() => _errorIds.remove(id));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final unassigned = _unassigned;
    final assignedA = _inBucket('A');
    final assignedB = _inBucket('B');
    final hasSelection = _selectedId != null;

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
          const SizedBox(height: DdTheme.spaceL),

          // Two category buckets side by side
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Bucket(
                  label: _categoryA,
                  emoji: _categoryAEmoji,
                  items: assignedA,
                  isTarget: hasSelection,
                  onTap: () => _onBucketTap('A'),
                ),
              ),
              const SizedBox(width: DdTheme.spaceM),
              Expanded(
                child: _Bucket(
                  label: _categoryB,
                  emoji: _categoryBEmoji,
                  items: assignedB,
                  isTarget: hasSelection,
                  onTap: () => _onBucketTap('B'),
                ),
              ),
            ],
          ),
          const SizedBox(height: DdTheme.spaceL),

          if (!_done) ...[
            // Hint button
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

            // Prompt text
            Text(
              hasSelection
                  ? 'Trykk på en bøtte for å plassere gjenstanden!'
                  : 'Trykk på en gjenstand, deretter en bøtte!',
              style: TextStyle(
                fontSize: 14,
                color: DdTheme.warmBrown.withValues(alpha: 0.65),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DdTheme.spaceM),

            // Unassigned items
            if (unassigned.isNotEmpty)
              Wrap(
                spacing: DdTheme.spaceM,
                runSpacing: DdTheme.spaceM,
                alignment: WrapAlignment.center,
                children: unassigned.map((item) {
                  final id = item['id'] as String;
                  return _ItemChip(
                    emoji: item['emoji'] as String,
                    label: item['label'] as String,
                    isSelected: _selectedId == id,
                    hasError: _errorIds.contains(id),
                    onTap: () => _onItemTap(id),
                  );
                }).toList(),
              ),
          ] else ...[
            const Center(
              child: Column(
                children: [
                  Text('🎉', style: TextStyle(fontSize: 64)),
                  SizedBox(height: DdTheme.spaceM),
                  Text(
                    'Alle er sortert riktig!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: DdTheme.successGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Category bucket ───────────────────────────────────────────────────────────

class _Bucket extends StatelessWidget {
  final String label;
  final String emoji;
  final List<Map<String, Object?>> items;
  final bool isTarget;
  final VoidCallback onTap;

  const _Bucket({
    required this.label,
    required this.emoji,
    required this.items,
    required this.isTarget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isTarget ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(minHeight: 110),
        padding: const EdgeInsets.all(DdTheme.spaceM),
        decoration: BoxDecoration(
          color: isTarget
              ? DdTheme.lightGreen.withValues(alpha: 0.18)
              : DdTheme.cardWhite,
          borderRadius: BorderRadius.circular(DdTheme.radiusL),
          border: Border.all(
            color: isTarget
                ? DdTheme.lightGreen
                : DdTheme.lockGrey.withValues(alpha: 0.3),
            width: isTarget ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: DdTheme.warmBrown,
              ),
              textAlign: TextAlign.center,
            ),
            if (items.isNotEmpty) ...[
              const SizedBox(height: DdTheme.spaceS),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: items.map((item) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: DdTheme.successGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(DdTheme.radiusM),
                      border: Border.all(
                        color: DdTheme.successGreen.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item['emoji'] as String,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item['label'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: DdTheme.successGreen,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Selectable item chip ──────────────────────────────────────────────────────

class _ItemChip extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final bool hasError;
  final VoidCallback onTap;

  const _ItemChip({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.hasError,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color border;
    final Color bg;

    if (isSelected) {
      border = DdTheme.warmOrange;
      bg = DdTheme.warmOrange.withValues(alpha: 0.1);
    } else if (hasError) {
      border = DdTheme.errorRed;
      bg = DdTheme.errorRed.withValues(alpha: 0.1);
    } else {
      border = DdTheme.lockGrey.withValues(alpha: 0.35);
      bg = DdTheme.cardWhite;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(DdTheme.radiusL),
          border: Border.all(color: border, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: DdTheme.warmBrown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
