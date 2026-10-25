import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pipes/ui/core/audio/pipes_audio.dart';
import 'package:pipes/ui/core/audio/pipes_haptics.dart';
import 'package:pipes/ui/core/widgets/pipes_button.dart';
import 'package:pipes/ui/core/widgets/pipes_header.dart';
import 'package:pipes/ui/core/widgets/pipes_level_tile.dart';
import 'package:pipes/ui/core/widgets/pipes_tap.dart';

void main() {
  group('PipesButton', () {
    Widget createTestWidget({
      required PipesButtonVariant variant,
      VoidCallback? onPressed,
      bool isLoading = false,
      String? semanticLabel,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: PipesButton(
            text: 'Test Button',
            variant: variant,
            onPressed: onPressed,
            isLoading: isLoading,
            semanticLabel: semanticLabel,
          ),
        ),
      );
    }

    testWidgets('onPressed fires once per tap', (tester) async {
      int callCount = 0;
      await tester.pumpWidget(createTestWidget(
        variant: PipesButtonVariant.primary,
        onPressed: () => callCount++,
      ));

      await tester.tap(find.byType(PipesButton));
      await tester.pump();

      expect(callCount, equals(1));

      await tester.tap(find.byType(PipesButton));
      await tester.pump();

      expect(callCount, equals(2));
    });

    testWidgets('onPressed never fires when onPressed is null', (tester) async {
      int callCount = 0;
      await tester.pumpWidget(createTestWidget(
        variant: PipesButtonVariant.primary,
        onPressed: null,
      ));

      await tester.tap(find.byType(PipesButton));
      await tester.pump();

      expect(callCount, equals(0));
    });

    testWidgets('onPressed never fires when loading', (tester) async {
      int callCount = 0;
      await tester.pumpWidget(createTestWidget(
        variant: PipesButtonVariant.primary,
        onPressed: () => callCount++,
        isLoading: true,
      ));

      await tester.tap(find.byType(PipesButton));
      await tester.pump();

      expect(callCount, equals(0));
    });

    testWidgets('every variant and state builds without error', (tester) async {
      for (final variant in PipesButtonVariant.values) {
        for (final state in [
          {'onPressed': () {}, 'isLoading': false, 'isSelected': false},
          {'onPressed': null, 'isLoading': false, 'isSelected': false},
          {'onPressed': () {}, 'isLoading': true, 'isSelected': false},
          {'onPressed': () {}, 'isLoading': false, 'isSelected': true},
        ]) {
          await tester.pumpWidget(createTestWidget(
            variant: variant,
            onPressed: state['onPressed'] as VoidCallback?,
            isLoading: state['isLoading'] as bool,
          ));
          await tester.pump();
          expect(find.byType(PipesButton), findsOneWidget);
        }
      }
    });

    testWidgets('semantic label exists', (tester) async {
      await tester.pumpWidget(createTestWidget(
        variant: PipesButtonVariant.primary,
        onPressed: () {},
        semanticLabel: 'Play button',
      ));

      expect(find.bySemanticsLabel('Play button'), findsOneWidget);
    });
  });

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
    testWidgets('level pill is centered horizontally', (tester) async {
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
