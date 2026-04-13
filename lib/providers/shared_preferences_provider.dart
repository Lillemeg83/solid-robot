import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dyredetektiv/core/storage/progress_repository.dart';

/// Injected at app startup via [ProviderScope] overrides.
/// Throw on access if not overridden so we catch missing setup early.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('SharedPreferences not injected'),
);

/// Derived repository provider — no overrides needed.
final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository(ref.watch(sharedPreferencesProvider));
});
