import 'package:flutter/material.dart';

/// Represents a game world (e.g. Skogen, Gården, Byen).
class World {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final int requiredStarsToUnlock; // total stars needed from previous worlds

  const World({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    this.requiredStarsToUnlock = 0,
  });
}
