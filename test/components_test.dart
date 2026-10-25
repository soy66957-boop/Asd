import 'package:flutter_test/flutter_test.dart';
import 'package:pipes/ui/core/audio/pipes_audio.dart';
import 'package:pipes/ui/core/audio/pipes_haptics.dart';

void main() {
  group('SilentAudio and PipesHaptics', () {
    test('SilentAudio.play does not throw', () async {
      final audio = const SilentAudio();
      await expectLater(audio.play(AppSound.tap), completes);
      await expectLater(audio.play(AppSound.rotate), completes);
      await expectLater(audio.play(AppSound.connect), completes);
      await expectLater(audio.play(AppSound.win), completes);
    });

    test('PipesHaptics methods do not throw', () {
      expect(() => PipesHaptics.tap(), returnsNormally);
      expect(() => PipesHaptics.rotate(), returnsNormally);
      expect(() => PipesHaptics.connect(), returnsNormally);
      expect(() => PipesHaptics.win(), returnsNormally);
    });
  });
}
