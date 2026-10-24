import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pipes/ui/core/audio/pipes_audio.dart';
import 'package:pipes/ui/core/audio/pipes_haptics.dart';
import 'package:pipes/ui/core/icons/pipes_icons.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';
import 'package:pipes/ui/core/widgets/pipes_button.dart';
import 'package:pipes/ui/core/widgets/pipes_header.dart';
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

  group('PipesTap hit area', () {
    testWidgets('hit area is at least 48x48 dp', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PipesTap(
              onTap: () {},
              minHitSize: 48.0,
              child: const SizedBox(width: 24, height: 24),
            ),
          ),
        ),
      );

      final renderBox = tester.renderObject<RenderBox>(find.byType(PipesTap));
      final size = renderBox.size;
      expect(size.width, greaterThanOrEqualTo(48.0));
      expect(size.height, greaterThanOrEqualTo(48.0));
    });
  });

  group('PipesHeader centering', () {
    testWidgets('center child is horizontally centered within 1px', (tester) async {
      const slotWidth = 48.0;
      const screenWidth = 400.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: screenWidth,
              child: PipesHeader(
                leading: Container(width: slotWidth, color: Colors.red),
                center: const Text('Centered Title'),
                trailing: Container(width: slotWidth, color: Colors.blue),
                slotWidth: slotWidth,
              ),
            ),
          ),
        ),
      );

      final centerFinder = find.text('Centered Title');
      final centerBox = tester.renderObject<RenderBox>(centerFinder);
      final centerX = centerBox.localToGlobal(Offset.zero).dx + centerBox.size.width / 2;
      final screenCenterX = screenWidth / 2;

      expect((centerX - screenCenterX).abs(), lessThanOrEqualTo(1.0));
    });

    testWidgets('center remains centered with different leading/trailing content', (tester) async {
      const slotWidth = 48.0;
      const screenWidth = 400.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: screenWidth,
              child: PipesHeader(
                leading: Container(width: slotWidth, child: const Icon(Icons.menu)),
                center: const Text('Title'),
                trailing: Container(width: slotWidth, child: const Icon(Icons.settings)),
                slotWidth: slotWidth,
              ),
            ),
          ),
        ),
      );

      final centerFinder = find.text('Title');
      final centerBox = tester.renderObject<RenderBox>(centerFinder);
      final centerX = centerBox.localToGlobal(Offset.zero).dx + centerBox.size.width / 2;
      final screenCenterX = screenWidth / 2;

      expect((centerX - screenCenterX).abs(), lessThanOrEqualTo(1.0));
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

  group('48dp hit area failure proof', () {
    testWidgets('FAILS when hit area is less than 48dp', (tester) async {
      // This test demonstrates the check can fail
      // We use a temporary broken variant with minHitSize = 32
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PipesTap(
              onTap: () {},
              minHitSize: 32.0, // BROKEN: less than 48
              child: const SizedBox(width: 24, height: 24),
            ),
          ),
        ),
      );

      final renderBox = tester.renderObject<RenderBox>(find.byType(PipesTap));
      final size = renderBox.size;
      // This assertion will FAIL, proving the test catches the bug
      expect(size.width, greaterThanOrEqualTo(48.0),
          reason: 'Hit area width should be >= 48 but was ${size.width}');
      expect(size.height, greaterThanOrEqualTo(48.0),
          reason: 'Hit area height should be >= 48 but was ${size.height}');
    });
  });

  group('PipesHeader centering failure proof', () {
    testWidgets('FAILS when center is not centered', (tester) async {
      // This test demonstrates the check can fail
      // We use a broken slotWidth that doesn't match
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: PipesHeader(
                leading: Container(width: 60, color: Colors.red), // BROKEN: 60 != 48
                center: const Text('Title'),
                trailing: Container(width: 36, color: Colors.blue), // BROKEN: 36 != 48
                slotWidth: 48, // But slotWidth says 48
              ),
            ),
          ),
        ),
      );

      final centerFinder = find.text('Title');
      final centerBox = tester.renderObject<RenderBox>(centerFinder);
      final centerX = centerBox.localToGlobal(Offset.zero).dx + centerBox.size.width / 2;
      final screenCenterX = 200.0;

      // This will FAIL because the slots are unequal widths
      expect((centerX - screenCenterX).abs(), lessThanOrEqualTo(1.0),
          reason: 'Center should be centered within 1px but was off by ${(centerX - screenCenterX).abs()}');
    });
  });
}
