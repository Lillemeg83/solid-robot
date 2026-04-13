import 'package:flutter/material.dart';

/// Dyredetektiv design system — warm, child-friendly colours and large touch
/// targets suited for 6–9 year olds.
class DdTheme {
  DdTheme._();

  // ── Colour palette ─────────────────────────────────────────────────────────

  static const Color backgroundWarm = Color(0xFFFFFDE7); // very light yellow
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFF4CAF50);
  static const Color warmOrange = Color(0xFFFF8F00);
  static const Color skyBlue = Color(0xFF0288D1);
  static const Color warmBrown = Color(0xFF4E342E);
  static const Color starGold = Color(0xFFFFD600);
  static const Color lockGrey = Color(0xFF9E9E9E);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color successGreen = Color(0xFF388E3C);

  // World colours
  static const Color forestGreen = Color(0xFF1B5E20);
  static const Color forestLight = Color(0xFFE8F5E9);
  static const Color farmOrange = Color(0xFFE65100);
  static const Color farmLight = Color(0xFFFFF3E0);
  static const Color cityBlue = Color(0xFF0D47A1);
  static const Color cityLight = Color(0xFFE3F2FD);

  // ── Spacing ────────────────────────────────────────────────────────────────

  static const double spaceXS = 4;
  static const double spaceS = 8;
  static const double spaceM = 16;
  static const double spaceL = 24;
  static const double spaceXL = 32;
  static const double spaceXXL = 48;

  // ── Border radii ───────────────────────────────────────────────────────────

  static const double radiusS = 8;
  static const double radiusM = 16;
  static const double radiusL = 24;
  static const double radiusXL = 32;

  // ── Minimum touch target size (WCAG + child UX) ────────────────────────────

  static const double minTouchSize = 64;

  // ── Text styles ────────────────────────────────────────────────────────────

  static const TextStyle displayLarge = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w900,
    color: warmBrown,
    letterSpacing: -0.5,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: warmBrown,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: warmBrown,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: warmBrown,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: warmBrown,
    height: 1.4,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  // ── MaterialTheme ──────────────────────────────────────────────────────────

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGreen,
          surface: backgroundWarm,
        ),
        scaffoldBackgroundColor: backgroundWarm,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(120, minTouchSize),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusXL),
            ),
            textStyle: labelLarge,
            elevation: 4,
          ),
        ),
        cardTheme: CardTheme(
          color: cardWhite,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusL),
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: spaceM,
            vertical: spaceS,
          ),
        ),
      );
}
