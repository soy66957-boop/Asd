// PipesIcons - The ONLY file that references Icons.
// One family, outlined/rounded variants only. No filled icons.

import 'package:flutter/material.dart';

class PipesIcons {
  PipesIcons._();

  // Navigation
  static const IconData back = Icons.arrow_back_ios_new_rounded;
  static const IconData close = Icons.close_rounded;

  // Actions
  static const IconData refresh = Icons.refresh_rounded;
  static const IconData star = Icons.star_rounded; // outlined star (was filled)
  static const IconData check = Icons.check_circle_rounded;
  static const IconData lock = Icons.lock_rounded;

  // Game stats
  static const IconData moves = Icons.trending_up_rounded;
  static const IconData timer = Icons.timer_outlined;
  static const IconData hint = Icons.lightbulb_rounded;
}
