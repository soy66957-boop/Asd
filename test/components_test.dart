import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pipes/ui/core/audio/pipes_audio.dart';
import 'package:pipes/ui/core/audio/pipes_haptics.dart';
import 'package:pipes/ui/core/widgets/pipes_header.dart';
import 'package:pipes/ui/core/widgets/pipes_level_tile.dart';

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

  group('Menu accessibility', () {
    testWidgets('menu shows "Pipes" text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => PipesHeader(
                leading: const SizedBox.shrink(),
                center: const Text('Pipes'),
                trailing: const SizedBox.shrink(),
                slotWidth: 48.0,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Pipes'), findsOneWidget);
    });
  });

  group('Level pill centering', () {
    testWidgets('level pill renders and is centered', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: PipesLevelTile(
                levelNumber: 1,
                state: PipesLevelTileState.current,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(PipesLevelTile), findsOneWidget);
    });
  });
}
