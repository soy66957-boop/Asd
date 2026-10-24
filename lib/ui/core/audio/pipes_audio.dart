// PipesAudio - Sound abstraction for the app.
// Uses Riverpod for state management (same as the rest of the app).

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppSound {
  tap,
  rotate,
  connect,
  win,
}

/// Abstract interface for playing game sounds.
abstract class PipesAudio {
  Future<void> play(AppSound sound);
}

/// Silent implementation that does nothing. Used by default and in tests.
class SilentAudio implements PipesAudio {
  const SilentAudio();

  @override
  Future<void> play(AppSound sound) async {
    // No-op
  }
}

/// Provider for the audio implementation. Override in main.dart with real impl.
final pipesAudioProvider = Provider<PipesAudio>((ref) => const SilentAudio());

/// Extension for easy access from widgets.
extension PipesAudioRef on WidgetRef {
  PipesAudio get pipesAudio => read(pipesAudioProvider);
}
