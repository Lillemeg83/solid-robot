import 'package:flutter/material.dart';
import 'package:dyredetektiv/models/character.dart';
import 'package:dyredetektiv/models/minigame_config.dart';
import 'package:dyredetektiv/models/mystery.dart';
import 'package:dyredetektiv/models/world.dart';
import 'package:dyredetektiv/app/theme.dart';

/// All static game content for the MVP.
/// In a later version this would be loaded from JSON assets or a CMS.
class SampleData {
  SampleData._();

  // ── Worlds ─────────────────────────────────────────────────────────────────

  static const List<World> worlds = [
    World(
      id: 'forest',
      name: 'Skogen',
      emoji: '🌲',
      description: 'Et magisk skogslandskap fullt av trær og dyr.',
      primaryColor: DdTheme.forestGreen,
      secondaryColor: DdTheme.forestLight,
      requiredStarsToUnlock: 0,
    ),
    World(
      id: 'farm',
      name: 'Gården',
      emoji: '🏡',
      description: 'En koselig bondegård med røde låver og grønne jorder.',
      primaryColor: DdTheme.farmOrange,
      secondaryColor: DdTheme.farmLight,
      requiredStarsToUnlock: 6, // need 6 stars in Skogen first
    ),
    World(
      id: 'city',
      name: 'Byen',
      emoji: '🏙️',
      description: 'En travel by med butikker, parker og mange hemmeligheter.',
      primaryColor: DdTheme.cityBlue,
      secondaryColor: DdTheme.cityLight,
      requiredStarsToUnlock: 12,
    ),
  ];

  // ── Characters ─────────────────────────────────────────────────────────────

  static const List<Character> characters = [
    Character(
      id: 'mira',
      name: 'Mira',
      emoji: '🦔',
      description:
          'Mira er din hjelpsomme venn. Hun er alltid nysgjerrig og vil hjelpe alle dyr hun møter!',
      worldId: 'all',
    ),
    Character(
      id: 'professor_padde',
      name: 'Professor Padde',
      emoji: '🐸',
      description:
          'Professor Padde vet svaret på nesten alt. Han gir hint når du sitter fast.',
      worldId: 'all',
    ),
    Character(
      id: 'edgar',
      name: 'Edgar',
      emoji: '🦌',
      description:
          'Elgen Edgar er høflig og snill, men glemmer ting hele tiden. Kanskje DU kan hjelpe ham?',
      worldId: 'forest',
    ),
    Character(
      id: 'rosa',
      name: 'Rosa',
      emoji: '🦊',
      description:
          'Reven Rosa er leken og litt lurvig, men har et godt hjerte. Hennes bærforråd forsvinner stadig!',
      worldId: 'forest',
    ),
    Character(
      id: 'oda',
      name: 'Oda',
      emoji: '🦉',
      description:
          'Uglen Oda er veldig vis og leser mange bøker. Men nattmysteriene er vanskelige selv for henne!',
      worldId: 'forest',
    ),
    Character(
      id: 'gunvor',
      name: 'Gunvor',
      emoji: '🐷',
      description:
          'Grisen Gunvor er munter og full av energi. Grisungene hennes forsvinner stadig vekk!',
      worldId: 'farm',
    ),
    Character(
      id: 'klara',
      name: 'Klara',
      emoji: '🐄',
      description:
          'Kua Klara er rolig og klok. Noen har drukket opp melken hennes — men hvem?',
      worldId: 'farm',
    ),
  ];

  // ── Mysteries ──────────────────────────────────────────────────────────────

  static const List<Mystery> mysteries = [
    // ── SKOGEN ────────────────────────────────────────────────────────────────

    Mystery(
      id: 'forest_001',
      worldId: 'forest',
      title: 'Edgars forsvunne hatt',
      characterId: 'edgar',
      introText:
          'Hjelp! Hatten min er borte! Jeg la den fra meg i går kveld, men nå er den helt forsvunnet!',
      sceneDescription:
          'Du er i en lysning i skogen. Snøen ligger hvit rundt store grantrær. Det er spor overalt!',
      clues: [
        '🐾 Det er mange spor i snøen rundt grantreet.',
        '🍃 Noen grener er bøyd ned — som om noe tungt hang der.',
        '🎩 Du ser noe svart langt oppe i treet!',
      ],
      minigames: [
        MinigameConfig(
          type: 'count',
          data: {
            'question': 'Hvor mange dyrespor ser du i snøen?',
            'emoji': '🐾',
            'count': 5,
            'options': [3, 4, 5, 6],
            'hint': 'Tell ett spor om gangen fra venstre til høyre!',
            'contextText':
                'Edgar sier: "Tellingsporene vil fortelle oss hvem som tok hatten!"',
          },
        ),
        MinigameConfig(
          type: 'count',
          data: {
            'question': 'Hvor mange grener er bøyd ned på treet?',
            'emoji': '🌿',
            'count': 3,
            'options': [2, 3, 4, 5],
            'hint': 'Husk: Bøyde grener er lavere enn de andre!',
            'contextText':
                'Professor Padde sier: "Antall bøyde grener forteller oss noe viktig!"',
          },
        ),
      ],
      sortOrder: 1,
    ),

    Mystery(
      id: 'forest_002',
      worldId: 'forest',
      title: 'Rosas forsvunne bær',
      characterId: 'rosa',
      introText:
          'Åh nei! Jeg hadde samlet 8 blåbær til kveldsmat, men noen har spist noen av dem! Hvor mange er det igjen?',
      sceneDescription:
          'Du finner deg i Rosa Revens hule. Det er koselig og lunt, men bærskålen ser tom ut...',
      clues: [
        '🫐 Bærskålen er ikke helt tom — noen bær er igjen.',
        '🐭 Det er musspor ved bærskålen.',
        '👣 En liten skapning har tydeligvis besøkt hulen.',
      ],
      minigames: [
        MinigameConfig(
          type: 'count',
          data: {
            'question': 'Hvor mange blåbær er det igjen i skålen?',
            'emoji': '🫐',
            'count': 4,
            'options': [2, 3, 4, 5],
            'hint': 'Tell de blå runde tingene i skålen nøye!',
            'contextText': 'Rosa sier: "Jeg er SIKKER på at jeg hadde 8 bær!"',
          },
        ),
      ],
      sortOrder: 2,
    ),

    Mystery(
      id: 'forest_003',
      worldId: 'forest',
      title: 'Uglas nattmysterium',
      characterId: 'oda',
      introText:
          'Hver natt hører jeg en merkelig lyd fra skogen. Jeg har telt lydene, men mister alltid tellingen!',
      sceneDescription:
          'Det er natt i skogen. Månen lyser opp mellom trærne. Noe lager lyder i mørket...',
      clues: [
        '🌙 Lydene høres kun om natten.',
        '🎵 Det er en rytmisk lyd — kanskje noen teller noe?',
        '🦇 Flaggermus flyr rundt det store eiketre.',
      ],
      minigames: [
        MinigameConfig(
          type: 'count',
          data: {
            'question': 'Hvor mange flaggermus ser du flyr rundt treet?',
            'emoji': '🦇',
            'count': 6,
            'options': [4, 5, 6, 7],
            'hint': 'Tell fra venstre til høyre — de er litt sjenerte!',
            'contextText':
                'Oda sier: "Flaggermusene lager lydene! Men hvor mange er de?"',
          },
        ),
      ],
      sortOrder: 3,
    ),

    Mystery(
      id: 'forest_004',
      worldId: 'forest',
      title: 'Det hemmelige skattekaret',
      characterId: 'edgar',
      introText:
          'Jeg fant et gammelt kart i hullet mitt, men kan ikke tyde det! Det er symboler og tall overalt!',
      sceneDescription:
          'Et gammelt, gulnet kart ligger på mosedekket stein. Pilene peker i alle retninger!',
      clues: [
        '🗺️ Kartet viser en sti gjennom skogen.',
        '🔢 Det er tall ved hvert kryss på stien.',
        '⭐ Stjernen markerer der skatten er gjemt!',
      ],
      minigames: [
        MinigameConfig(
          type: 'count',
          data: {
            'question': 'Kartet viser 3 trær, 2 steiner og 1 elv. Hvor mange ting totalt?',
            'emoji': '🗺️',
            'count': 6,
            'options': [5, 6, 7, 8],
            'hint': 'Legg sammen: 3 + 2 + 1 = ?',
            'contextText':
                'Edgar sier: "Svaret gir oss koden til skatteskrinet!"',
          },
        ),
      ],
      sortOrder: 4,
    ),

    // ── GÅRDEN ───────────────────────────────────────────────────────────────

    Mystery(
      id: 'farm_001',
      worldId: 'farm',
      title: 'De forsvunne grisungene',
      characterId: 'gunvor',
      introText:
          'Jeg hadde 5 grisuger i morges, men noen er borte! Hjelp meg å finne ut hvor mange som mangler!',
      sceneDescription:
          'En varm og koselig gårdsplass. Røde låver, grønne jorder — og en veldig bekymret gris.',
      clues: [
        '🐷 Noen grisuger leker gjemsel.',
        '🌾 Det er gress-spor bort til høystakken.',
        '🎪 Et lite telt er satt opp bak låven.',
      ],
      minigames: [
        MinigameConfig(
          type: 'count',
          data: {
            'question': 'Hvor mange grisuger ser du på gårdsplassen?',
            'emoji': '🐷',
            'count': 3,
            'options': [2, 3, 4, 5],
            'hint': 'Husk: Noen gjemmer seg! Tell de du KAN se.',
            'contextText':
                'Gunvor sier: "Jeg hadde 5 i morges — hvor mange mangler?"',
          },
        ),
        MinigameConfig(
          type: 'count',
          data: {
            'question': 'Gunvor hadde 5 grisuger. Du fant 3. Hvor mange mangler fremdeles?',
            'emoji': '❓',
            'count': 2,
            'options': [1, 2, 3, 4],
            'hint': '5 minus 3 = ?',
            'contextText': 'Mira sier: "Tenk deg at du har 5 fingre og gjemmer 3!"',
          },
        ),
      ],
      sortOrder: 1,
    ),

    Mystery(
      id: 'farm_002',
      worldId: 'farm',
      title: 'Det tomme melkespannet',
      characterId: 'klara',
      introText:
          'Noen har drukket opp melken min! Jeg fyller alltid spannet med 4 liter, men det er nesten tomt nå!',
      sceneDescription:
          'Fjøset er stille og lunt. Et stort melkespann står på gulvet, og noe er tydelig galt.',
      clues: [
        '🥛 Spannet er nesten tomt — bare litt er igjen.',
        '🐱 Det er kattepuster rundt spannet.',
        '🐭 Musespor leder bort til et hull i veggen.',
      ],
      minigames: [
        MinigameConfig(
          type: 'count',
          data: {
            'question': 'Klara hadde 4 liter melk. Det er 1 liter igjen. Hvor mange liter er borte?',
            'emoji': '🥛',
            'count': 3,
            'options': [2, 3, 4, 5],
            'hint': '4 minus 1 = ?',
            'contextText': 'Klara sier: "Noen drakk 3 liter! Men hvem?"',
          },
        ),
      ],
      sortOrder: 2,
    ),

    Mystery(
      id: 'farm_003',
      worldId: 'farm',
      title: 'Hvem åpnet porten?',
      characterId: 'gunvor',
      introText:
          'Porten til beitet sto åpen i morges! Heldigvis er alle dyrene trygge, men hvem åpnet den?',
      sceneDescription:
          'Den store gårdsporten henger på gløtt. Ingen ser ut til å ha sett hvem som åpnet den.',
      clues: [
        '🚪 Porten har en hengelås med en tallkode.',
        '🔢 Koden er et tall mellom 1 og 9.',
        '📝 En lapp ved porten sier: "Antall kuer + antall hester = koden".',
      ],
      minigames: [
        MinigameConfig(
          type: 'count',
          data: {
            'question': 'Det er 2 kuer og 3 hester på gården. Hva er portens kode?',
            'emoji': '🔢',
            'count': 5,
            'options': [4, 5, 6, 7],
            'hint': 'Legg sammen antall kuer og antall hester!',
            'contextText': 'Mira sier: "2 + 3 = ?"',
          },
        ),
      ],
      sortOrder: 3,
    ),

    Mystery(
      id: 'farm_004',
      worldId: 'farm',
      title: 'Hønenes hemmelige reir',
      characterId: 'gunvor',
      introText:
          'Hønene mine legger egg på et hemmelig sted! Jeg finner ikke eggene, og jeg vet ikke hvor mange det er!',
      sceneDescription:
          'Hønsegården er full av kakk og fjær. Hønene ser ut som om de vet mer enn de sier...',
      clues: [
        '🥚 Det er fjær som leder til et hemmelig sted.',
        '🐔 Hønene ler (på hønespråk) av hverandre.',
        '🌾 Høystakken beveger seg litt...',
      ],
      minigames: [
        MinigameConfig(
          type: 'count',
          data: {
            'question': 'Du finner eggene! Hvor mange egg er det i det hemmelige reiret?',
            'emoji': '🥚',
            'count': 7,
            'options': [5, 6, 7, 8],
            'hint': 'Tell dem nøye — noen gjemmer seg under halm!',
            'contextText': 'Gunvor sier: "Å, de er flinke, disse hønene!"',
          },
        ),
      ],
      sortOrder: 4,
    ),
  ];

  // ── Lookup helpers ─────────────────────────────────────────────────────────

  static World? worldById(String id) {
    try {
      return worlds.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }

  static Character? characterById(String id) {
    try {
      return characters.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<Mystery> mysteriesForWorld(String worldId) =>
      mysteries.where((m) => m.worldId == worldId).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  static Mystery? mysteryById(String id) {
    try {
      return mysteries.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Returns the mystery that comes after [mysteryId] in the same world,
  /// or null if it is the last one.
  static Mystery? nextMystery(String mysteryId) {
    final current = mysteryById(mysteryId);
    if (current == null) return null;
    final worldMysteries = mysteriesForWorld(current.worldId);
    final idx = worldMysteries.indexWhere((m) => m.id == mysteryId);
    if (idx < 0 || idx >= worldMysteries.length - 1) return null;
    return worldMysteries[idx + 1];
  }
}
