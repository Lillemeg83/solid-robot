# Dyredetektiv 🦔🔍

Pedagogisk detektivspill for Android rettet mot barn 6–9 år. Spilleren hjelper dyr med å løse morsomme hverdagsmysterier gjennom observasjon, lesing, telling og logikk.

## Teknologistack

| Lag | Teknologi |
|---|---|
| Rammeverk | Flutter 3.x |
| State management | Riverpod 2.x (`StateNotifierProvider`) |
| Navigasjon | GoRouter 13.x |
| Lokal lagring | SharedPreferences |
| Annonser | AdMob (stub — aktiveres i v1.1) |

## Prosjektstruktur

```
lib/
├── main.dart                   # Entry point, async init
├── app/
│   ├── app.dart                # MaterialApp.router
│   ├── router.dart             # GoRouter-konfigurasjon
│   └── theme.dart              # DdTheme — farger, spacing, tekststiler
├── models/                     # Rene dataklasser (ingen Flutter-deps)
├── data/
│   └── sample_data.dart        # Statisk innhold for MVP
├── core/
│   ├── storage/                # ProgressRepository (SharedPreferences)
│   └── ads/                    # AdService stub
├── providers/                  # Riverpod providers
└── features/
    ├── home/                   # Startskjerm
    ├── world_map/              # Verdenskart
    ├── mystery/                # Saksliste + saksskjerm
    ├── minigames/
    │   ├── minigame_screen.dart  # Orkestrerer alle mini-games
    │   └── count/              # CountGame (fullt implementert)
    ├── reward/                 # Belønningsskjerm
    └── parent/                 # Foreldreseksjon (gate + dashboard)
```

## Kom i gang

```bash
# Klon og installer avhengigheter
flutter pub get

# Kjør i debug-modus (Android emulator eller fysisk enhet)
flutter run

# Bygg release APK
flutter build apk --release
```

## Navigasjonsflyt

```
HomeScreen (/)
  └─▶ WorldMapScreen (/map)
        └─▶ MysteryListScreen (/world/:worldId)
              └─▶ MysterySceneScreen (/mystery/:mysteryId)
                    └─▶ MinigameScreen (/minigame/:mysteryId)
                          └─▶ RewardScreen (/reward/:mysteryId/:stars)
                                └─▶ WorldMapScreen  (eller neste sak)

HomeScreen (/)
  └─▶ ParentGateScreen (/parent)
        └─▶ ParentDashboardScreen (/parent/dashboard)
```

## Mini-games i MVP

| Type | Status | Beskrivelse |
|---|---|---|
| `count` | ✅ Ferdig | Tell emoji-objekter, velg riktig tall |
| `sort` | 🔜 Stub | Sorter gjenstander i kategorier |
| `read` | 🔜 Stub | Les ledetråd, velg riktig svar |
| `track` | 🔜 Stub | Følg spor i riktig rekkefølge |

## Monetisering (v1.1)

AdMob er klar som stub i `lib/core/ads/ad_service.dart`. For å aktivere:

1. Legg til `google_mobile_ads: ^5.1.0` i `pubspec.yaml`
2. Legg til AdMob App ID i `AndroidManifest.xml`
3. Fjern stub-kommentarene i `AdService`

**Viktig:** Behold alltid `tagForChildDirectedTreatment: yes` og `maxAdContentRating: G`.

## Innholdsutvidelse

Nye mysterier legges til i `lib/data/sample_data.dart`:

```dart
Mystery(
  id: 'forest_005',
  worldId: 'forest',
  title: 'Tittel på saken',
  characterId: 'edgar',
  introText: '...',
  sceneDescription: '...',
  clues: ['🔍 Ledetråd 1', '🐾 Ledetråd 2'],
  minigames: [
    MinigameConfig(
      type: 'count',
      data: {
        'question': 'Spørsmål?',
        'emoji': '🍎',
        'count': 5,
        'options': [3, 4, 5, 6],
        'hint': 'Hint fra Professor Padde',
        'contextText': 'Karakter sier: "..."',
      },
    ),
  ],
  sortOrder: 5,
),
```

## Google Play Families-sertifisering

Sjekkliste før publisering:
- [ ] AdMob konfigurert med `tagForChildDirectedTreatment = yes`
- [ ] Ingen annonser for gambling, alkohol eller vokseninnhold
- [ ] Personvernerklæring koblet til fra Play Store-oppføring
- [ ] Aldersrating: `PEGI 3` / `Everyone`
- [ ] Ingen datainnsamling uten foreldresamtykke
- [ ] Testet med barn 6–9 år (minst 5 testpersoner)
