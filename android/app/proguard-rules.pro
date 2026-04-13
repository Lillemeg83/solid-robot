# Flutter-specific ProGuard rules

# Keep Flutter wrapper classes
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep our app's MainActivity
-keep class no.dyredetektiv.app.** { *; }

# Shared Preferences
-keep class androidx.datastore.** { *; }
