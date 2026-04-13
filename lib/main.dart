import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dyredetektiv/app/app.dart';
import 'package:dyredetektiv/core/ads/ad_service.dart';
import 'package:dyredetektiv/providers/shared_preferences_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait — best UX for children on phones
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialise local storage
  final prefs = await SharedPreferences.getInstance();

  // Initialise ad service (no-op stub in MVP)
  await AdService.instance.initialize();

  runApp(
    ProviderScope(
      overrides: [
        // Inject the pre-initialised SharedPreferences instance
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const DyredetektivApp(),
    ),
  );
}
