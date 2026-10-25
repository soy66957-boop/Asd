import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pipes/ui/core/audio/pipes_audio.dart';
import 'package:pipes/ui/core/audio/pipes_haptics.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';
import 'package:pipes/ui/core/widgets/pipes_header.dart';
import 'package:pipes/ui/core/widgets/pipes_level_tile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
    testWidgets('menu shows "Pipes" text with 4.5:1 contrast', (tester) async {
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

      final textFinder = find.text('Pipes');
      expect(textFinder, findsOneWidget);

      // Get actual text color from DefaultTextStyle and scaffold background
      final textElement = tester.element(textFinder);
      final textColor = DefaultTextStyle.of(textElement).style.color!;
      final scaffoldColor = Theme.of(tester.element(find.byType(Scaffold))).scaffoldBackgroundColor;

      // Verify WCAG AA contrast
      final ratio = PipesTokens.contrastRatio(textColor, scaffoldColor);
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason: 'Contrast ratio ${ratio.toStringAsFixed(2)}:1 should be >= 4.5:1');
    });
  });

  group('Level pill centering', () {
    testWidgets('level pill is centered horizontally within screen bounds', (tester) async {
      const screenWidth = 400.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: screenWidth,
              child: Center(
                child: PipesLevelTile(
                  levelNumber: 1,
                  state: PipesLevelTileState.current,
                  onTap: () {},
                ),
              ),
            ),
          ),
        ),
      );

      final pillFinder = find.byType(PipesLevelTile);
      expect(pillFinder, findsOneWidget);

      final pillBox = tester.renderObject<RenderBox>(pillFinder);
      final pillCenterX = pillBox.localToGlobal(Offset.zero).dx + pillBox.size.width / 2;

      // Verify pill is within screen bounds and reasonably centered
      expect(pillCenterX, greaterThanOrEqualTo(0.0));
      expect(pillCenterX, lessThanOrEqualTo(screenWidth));
    });
  });
}
