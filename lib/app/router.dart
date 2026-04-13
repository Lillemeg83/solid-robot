import 'package:go_router/go_router.dart';
import 'package:dyredetektiv/features/home/home_screen.dart';
import 'package:dyredetektiv/features/world_map/world_map_screen.dart';
import 'package:dyredetektiv/features/mystery/mystery_list_screen.dart';
import 'package:dyredetektiv/features/mystery/mystery_scene_screen.dart';
import 'package:dyredetektiv/features/minigames/minigame_screen.dart';
import 'package:dyredetektiv/features/reward/reward_screen.dart';
import 'package:dyredetektiv/features/collection/collection_screen.dart';
import 'package:dyredetektiv/features/parent/parent_gate_screen.dart';
import 'package:dyredetektiv/features/parent/parent_dashboard_screen.dart';

/// Central route table for the app.
///
/// Route hierarchy:
///   /                        HomeScreen
///   /map                     WorldMapScreen
///   /world/:worldId          MysteryListScreen
///   /mystery/:mysteryId      MysterySceneScreen
///   /minigame/:mysteryId     MinigameScreen  (handles all games in the mystery)
///   /reward/:mysteryId/:stars RewardScreen
///   /parent                  ParentGateScreen
///   /parent/dashboard        ParentDashboardScreen
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const WorldMapScreen(),
    ),
    GoRoute(
      path: '/world/:worldId',
      builder: (context, state) => MysteryListScreen(
        worldId: state.pathParameters['worldId']!,
      ),
    ),
    GoRoute(
      path: '/mystery/:mysteryId',
      builder: (context, state) => MysterySceneScreen(
        mysteryId: state.pathParameters['mysteryId']!,
      ),
    ),
    GoRoute(
      path: '/minigame/:mysteryId',
      builder: (context, state) => MinigameScreen(
        mysteryId: state.pathParameters['mysteryId']!,
      ),
    ),
    GoRoute(
      path: '/reward/:mysteryId/:stars',
      builder: (context, state) => RewardScreen(
        mysteryId: state.pathParameters['mysteryId']!,
        stars: int.tryParse(state.pathParameters['stars'] ?? '3') ?? 3,
      ),
    ),
    GoRoute(
      path: '/collection',
      builder: (context, state) => const CollectionScreen(),
    ),
    GoRoute(
      path: '/parent',
      builder: (context, state) => const ParentGateScreen(),
    ),
    GoRoute(
      path: '/parent/dashboard',
      builder: (context, state) => const ParentDashboardScreen(),
    ),
  ],
);
