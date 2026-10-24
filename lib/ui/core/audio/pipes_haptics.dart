// PipesHaptics - The ONLY place that calls HapticFeedback.
// Centralizes all haptic feedback for the app.

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class PipesHaptics {
  PipesHaptics._();

  /// Light tap feedback for button presses, tile rotations, etc.
  static void tap() {
    if (!kIsWeb) HapticFeedback.selectionClick();
  }

  /// Light impact for pipe rotations.
  static void rotate() {
    if (!kIsWeb) HapticFeedback.lightImpact();
  }

  /// Medium impact for connections.
  static void connect() {
    if (!kIsWeb) HapticFeedback.mediumImpact();
  }

  /// Heavy impact for win/major events.
  static void win() {
    if (!kIsWeb) HapticFeedback.heavyImpact();
  }
}
