import 'package:flutter/material.dart';
import 'package:dyredetektiv/app/theme.dart';

/// A large, rounded, child-friendly button.
/// All interactive elements meet the 64 dp minimum touch target.
class DdButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final String? emoji;
  final double? width;
  final double height;
  final double fontSize;

  const DdButton({
    required this.label,
    this.onPressed,
    this.backgroundColor = DdTheme.warmOrange,
    this.textColor = Colors.white,
    this.emoji,
    this.width,
    this.height = DdTheme.minTouchSize,
    this.fontSize = 18,
    super.key,
  });

  const DdButton.green({
    required String label,
    VoidCallback? onPressed,
    String? emoji,
    double? width,
    Key? key,
  }) : this(
          label: label,
          onPressed: onPressed,
          backgroundColor: DdTheme.primaryGreen,
          textColor: Colors.white,
          emoji: emoji,
          width: width,
          key: key,
        );

  const DdButton.blue({
    required String label,
    VoidCallback? onPressed,
    String? emoji,
    double? width,
    Key? key,
  }) : this(
          label: label,
          onPressed: onPressed,
          backgroundColor: DdTheme.skyBlue,
          textColor: Colors.white,
          emoji: emoji,
          width: width,
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed == null
              ? DdTheme.lockGrey
              : backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DdTheme.radiusXL),
          ),
          elevation: onPressed == null ? 0 : 5,
          shadowColor: Colors.black38,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (emoji != null) ...[
              Text(emoji!, style: TextStyle(fontSize: fontSize)),
              const SizedBox(width: DdTheme.spaceS),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                color: onPressed == null ? Colors.white70 : textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
