import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dyredetektiv/app/theme.dart';
import 'package:dyredetektiv/widgets/dd_button.dart';

/// Simple cognitive gate for the parent section.
/// Uses a random arithmetic puzzle — easy for an adult, non-obvious for a
/// 6–9 year old. No PIN is stored; a new puzzle is generated each visit.
class ParentGateScreen extends StatefulWidget {
  const ParentGateScreen({super.key});

  @override
  State<ParentGateScreen> createState() => _ParentGateScreenState();
}

class _ParentGateScreenState extends State<ParentGateScreen> {
  late final int _a;
  late final int _b;
  late final int _correct;
  late final List<int> _options;

  int? _selected;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _generatePuzzle();
  }

  void _generatePuzzle() {
    final now = DateTime.now().millisecondsSinceEpoch;
    _a = (now % 7) + 4; // 4–10
    _b = (now % 5) + 3; // 3–7
    _correct = _a + _b;
    final wrongs = <int>{};
    while (wrongs.length < 3) {
      final offset = (wrongs.length + 1) * 2;
      wrongs.add(_correct + offset);
      if (wrongs.length < 3) wrongs.add(_correct - offset);
    }
    _options = ([_correct, ...wrongs.take(3).toList()]..shuffle());
  }

  void _handleTap(int value) {
    setState(() => _selected = value);
    if (value == _correct) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) context.go('/parent/dashboard');
      });
    } else {
      setState(() => _failed = true);
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _selected = null;
            _failed = false;
            _generatePuzzle();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DdTheme.backgroundWarm,
      appBar: AppBar(
        title: const Text('Foreldreseksjon'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(DdTheme.spaceXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🔒', style: TextStyle(fontSize: 72)),
              const SizedBox(height: DdTheme.spaceL),
              const Text(
                'Foreldreseksjon',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: DdTheme.warmBrown,
                ),
              ),
              const SizedBox(height: DdTheme.spaceS),
              Text(
                'Løs regnestykket for å gå videre',
                style: TextStyle(
                  fontSize: 16,
                  color: DdTheme.warmBrown.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: DdTheme.spaceXXL),

              // Puzzle display
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DdTheme.spaceXXL,
                  vertical: DdTheme.spaceL,
                ),
                decoration: BoxDecoration(
                  color: DdTheme.cardWhite,
                  borderRadius: BorderRadius.circular(DdTheme.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Text(
                  '$_a + $_b = ?',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: DdTheme.primaryGreen,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: DdTheme.spaceXL),

              if (_failed)
                Padding(
                  padding: const EdgeInsets.only(bottom: DdTheme.spaceM),
                  child: Text(
                    'Feil svar — prøv igjen',
                    style: TextStyle(
                      color: DdTheme.errorRed,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

              // Answer options
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: DdTheme.spaceM,
                mainAxisSpacing: DdTheme.spaceM,
                childAspectRatio: 2.5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: _options
                    .map((v) => _OptionButton(
                          value: v,
                          isSelected: v == _selected,
                          isCorrect: v == _correct,
                          onTap: () => _handleTap(v),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final int value;
  final bool isSelected;
  final bool isCorrect;
  final VoidCallback onTap;

  const _OptionButton({
    required this.value,
    required this.isSelected,
    required this.isCorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = DdTheme.cardWhite;
    if (isSelected) bg = isCorrect ? DdTheme.successGreen : DdTheme.errorRed;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(DdTheme.radiusL),
          border: Border.all(
            color: isSelected
                ? (isCorrect ? DdTheme.successGreen : DdTheme.errorRed)
                : DdTheme.lockGrey.withOpacity(0.3),
            width: 2.5,
          ),
        ),
        child: Center(
          child: Text(
            '$value',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: isSelected ? Colors.white : DdTheme.warmBrown,
            ),
          ),
        ),
      ),
    );
  }
}
