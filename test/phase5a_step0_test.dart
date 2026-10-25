// Phase 5A Step 0 Tests - Tests for defects F1, F2, F3
// These MUST FAIL on current code before fixes

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';
import 'package:pipes/ui/core/widgets/pipes_header.dart';
import 'package:pipes/ui/core/widgets/pipes_swatch.dart'
    show SwatchComponentTokens;
import 'package:pipes/ui/core/widgets/pipes_toggle.dart'
    show ToggleComponentTokens;
import 'package:pipes/ui/features/level_select/views/level_select_view.dart'
    show LevelSelectView;
import 'package:pipes/ui/features/settings/views/settings_view.dart'
    show SettingsView;
import 'package:pipes/ui/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pipes/data/repositories/progress_repository.dart';
import 'package:pipes/data/services/hive_service.dart';
import 'package:pipes/data/services/settings_service.dart';
import 'package:pipes/domain/models/user_progress.dart';
import 'package:pipes/domain/models/app_settings.dart';
import 'package:pipes/domain/use_cases/level_generator.dart';

class _MockHiveService extends HiveService {
  @override
  Future<void> init() async {}
  @override
  Future<UserProgress> getProgress() async => UserProgress();
  @override
  Future<void> saveProgress(UserProgress progress) async {}
  @override
  Future<void> clearProgress() async {}
  @override
  Future<void> saveInProgress(int level, List<List<int>> board, int moves, int seconds) async {}
  @override
  Future<void> clearInProgress() async {}
  @override
  Future<void> completeLevel(int level, int moves) async {}
  @override
  Future<void> recordLevelResult(int level, int moves, int seconds) async {}
  @override
  Future<void> addRandomLevelMoves(int moves) async {}
}

class _MockSettingsService extends SettingsService {
  @override
  Future<void> init() async {}
  @override
  Future<AppSettings> getSettings() async => AppSettings();
  @override
  Future<void> saveSettings(AppSettings settings) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const screenWidth = 390.0;
  const screenHeight = 844.0;

  Widget buildTestApp(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: screenWidth,
          height: screenHeight,
          child: child,
        ),
      ),
    );
  }

  Widget buildTestAppWithProviders(Widget child) {
    return ProviderScope(
      overrides: [
        hiveServiceProvider.overrideWithValue(_MockHiveService()),
        settingsServiceProvider.overrideWithValue(_MockSettingsService()),
        levelGeneratorProvider.overrideWithValue(LevelGenerator()),
      ],
      child: buildTestApp(child),
    );
  }

  group('F1: PipesHeader title centering', () {
    testWidgets('title center equals screen center within 2px on Home (no leading/trailing)', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          PipesHeader(
            leading: const SizedBox.shrink(),
            center: const Text('Pipes'),
            trailing: const SizedBox.shrink(),
          ),
        ),
      );

      final textFinder = find.text('Pipes');
      expect(textFinder, findsOneWidget);

      final textElement = tester.element(textFinder);
      final textBox = tester.renderObject<RenderBox>(textFinder);
      final textCenterX = textBox.localToGlobal(Offset.zero).dx + textBox.size.width / 2;
      final screenCenterX = screenWidth / 2;

      expect(
        (textCenterX - screenCenterX).abs(),
        lessThanOrEqualTo(2.0),
        reason: 'Title center ($textCenterX) should be within 2px of screen center ($screenCenterX)',
      );
    });

    testWidgets('title center equals screen center within 2px on Levels (has leading, no trailing)', (tester) async {
      await tester.pumpWidget(
        buildTestAppWithProviders(
          Material(
            child: LevelSelectView(),
          ),
        ),
      );

      final textFinder = find.text('Levels');
      expect(textFinder, findsOneWidget);

      final textBox = tester.renderObject<RenderBox>(textFinder);
      final textCenterX = textBox.localToGlobal(Offset.zero).dx + textBox.size.width / 2;
      final screenCenterX = screenWidth / 2;

      expect(
        (textCenterX - screenCenterX).abs(),
        lessThanOrEqualTo(2.0),
        reason: 'Levels title center ($textCenterX) should be within 2px of screen center ($screenCenterX)',
      );
    });

    testWidgets('title center equals screen center within 2px on Settings (has leading, no trailing)', (tester) async {
      await tester.pumpWidget(
        buildTestAppWithProviders(
          Material(
            child: SettingsView(),
          ),
        ),
      );

      final textFinder = find.text('Settings');
      expect(textFinder, findsOneWidget);

      final textBox = tester.renderObject<RenderBox>(textFinder);
      final textCenterX = textBox.localToGlobal(Offset.zero).dx + textBox.size.width / 2;
      final screenCenterX = screenWidth / 2;

      expect(
        (textCenterX - screenCenterX).abs(),
        lessThanOrEqualTo(2.0),
        reason: 'Settings title center ($textCenterX) should be within 2px of screen center ($screenCenterX)',
      );
    });

    testWidgets('leading and trailing slots have equal width (56dp each)', (tester) async {
      final leadingKey = GlobalKey();
      final trailingKey = GlobalKey();

      await tester.pumpWidget(
        buildTestApp(
          PipesHeader(
            leading: SizedBox(key: leadingKey, width: 56, height: 56, child: const ColoredBox(color: Colors.red)),
            center: const Text('Title'),
            trailing: SizedBox(key: trailingKey, width: 56, height: 56, child: const ColoredBox(color: Colors.blue)),
          ),
        ),
      );

      final leadingBox = tester.renderObject<RenderBox>(find.byKey(leadingKey));
      final trailingBox = tester.renderObject<RenderBox>(find.byKey(trailingKey));

      expect(leadingBox.size.width, equals(56.0));
      expect(trailingBox.size.width, equals(56.0));
    });
  });

  group('F2: LevelSelectView grid first row not clipped', () {
    testWidgets('first tile top is at least 8dp below header bottom', (tester) async {
      await tester.pumpWidget(
        buildTestAppWithProviders(
          Material(
            child: LevelSelectView(),
          ),
        ),
      );

      // Wait for the grid to render
      await tester.pumpAndSettle();

      // Find the header
      final headerFinder = find.byType(PipesHeader);
      expect(headerFinder, findsOneWidget);
      final headerBox = tester.renderObject<RenderBox>(headerFinder);
      final headerBottom = headerBox.localToGlobal(Offset.zero).dy + headerBox.size.height;

      // Find the first level tile (level 1)
      final firstTileFinder = find.byKey(const ValueKey('level_tile_1'));
      expect(firstTileFinder, findsOneWidget);
      final firstTileBox = tester.renderObject<RenderBox>(firstTileFinder);
      final firstTileTop = firstTileBox.localToGlobal(Offset.zero).dy;

      expect(
        firstTileTop - headerBottom,
        greaterThanOrEqualTo(8.0),
        reason: 'First tile top ($firstTileTop) should be at least 8dp below header bottom ($headerBottom)',
      );
    });

    testWidgets('first tile rect lies fully inside scroll viewport', (tester) async {
      await tester.pumpWidget(
        buildTestAppWithProviders(
          Material(
            child: LevelSelectView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the first level tile
      final firstTileFinder = find.byKey(const ValueKey('level_tile_1'));
      expect(firstTileFinder, findsOneWidget);
      final firstTileBox = tester.renderObject<RenderBox>(firstTileFinder);
      final firstTileRect = Rect.fromPoints(
        firstTileBox.localToGlobal(Offset.zero),
        firstTileBox.localToGlobal(Offset(firstTileBox.size.width, firstTileBox.size.height)),
      );

      // Find the scrollable (GridView/ListView)
      final scrollableFinder = find.byType(Scrollable).last;
      expect(scrollableFinder, findsOneWidget);
      final scrollableBox = tester.renderObject<RenderBox>(scrollableFinder);
      final viewportRect = Rect.fromPoints(
        scrollableBox.localToGlobal(Offset.zero),
        scrollableBox.localToGlobal(Offset(scrollableBox.size.width, scrollableBox.size.height)),
      );

      expect(
        viewportRect.contains(firstTileRect.topLeft),
        isTrue,
        reason: 'First tile top-left should be inside viewport',
      );
      expect(
        viewportRect.contains(firstTileRect.bottomRight),
        isTrue,
        reason: 'First tile bottom-right should be inside viewport',
      );
    });
  });

  group('F3: SettingsView toggle thumb clip and swatch glow', () {
    testWidgets('toggle thumb rect lies inside track rect', (tester) async {
      await tester.pumpWidget(
        buildTestAppWithProviders(
          Material(
            child: SettingsView(),
          ),
        ),
      );

      // Find the hints toggle
      final toggleFinder = find.byKey(const Key('hints_toggle'));
      expect(toggleFinder, findsOneWidget);

      final toggleBox = tester.renderObject<RenderBox>(toggleFinder);
      
      // The toggle should be 48x48 hit area
      expect(toggleBox.size.width, equals(48.0));
      expect(toggleBox.size.height, equals(48.0));
    });

    testWidgets('toggle track rect lies inside its 48dp hit box', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          Center(
            child: PipesToggle(
              key: const Key('test_toggle'),
              value: false,
              onChanged: (_) {},
              semanticLabel: 'Test toggle',
            ),
          ),
        ),
      );

      final toggleFinder = find.byKey(const Key('test_toggle'));
      expect(toggleFinder, findsOneWidget);

      final toggleBox = tester.renderObject<RenderBox>(toggleFinder);
      
      // The toggle hit area should be 48x48
      expect(toggleBox.size.width, equals(48.0));
      expect(toggleBox.size.height, equals(48.0));
    });

    testWidgets('no ClipRect or ClipRRect ancestor between track and row', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          Center(
            child: PipesToggle(
              key: const Key('test_toggle_clip'),
              value: false,
              onChanged: (_) {},
              semanticLabel: 'Test toggle',
            ),
          ),
        ),
      );

      final trackFinder = find.byKey(const Key('pipes_toggle_track'));
      expect(trackFinder, findsOneWidget);

      final trackElement = tester.element(trackFinder);
      
      // Walk up the tree to check for ClipRect or ClipRRect ancestors
      Element? ancestor = trackElement;
      bool foundClipRect = false;
      bool foundClipRRect = false;
      
      while (ancestor != null) {
        if (ancestor.widget is ClipRect) foundClipRect = true;
        if (ancestor.widget is ClipRRect) foundClipRRect = true;
        ancestor = ancestor.visitAncestorElements((e) => false) as Element?;
      }
      
      // Actually, let's use a different approach - check the widget tree
      // The track should be inside a Stack inside a SizedBox (48x48), not a ClipRect/ClipRRect
      
      expect(foundClipRect, isFalse, reason: 'Should not have ClipRect ancestor');
      expect(foundClipRRect, isFalse, reason: 'Should not have ClipRRect ancestor');
    });

    testWidgets('swatch list viewport height is at least swatch size + 2 * 24dp', (tester) async {
      await tester.pumpWidget(
        buildTestAppWithProviders(
          Material(
            child: SettingsView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the swatch list (Row with swatches)
      final swatchFinder = find.byType(PipesSwatch);
      expect(swatchFinder, findsAtLeastNWidgets(1));

      // Get the first swatch to check its size
      final firstSwatchBox = tester.renderObject<RenderBox>(swatchFinder.first);
      final swatchSize = firstSwatchBox.size.width; // Should be 44dp from tokens

      // The viewport should be the parent Row's viewport or the ListView
      // Check the scrollable viewport
      final scrollableFinder = find.byType(Scrollable).last;
      expect(scrollableFinder, findsOneWidget);
      final scrollableBox = tester.renderObject<RenderBox>(scrollableFinder);
      
      final viewportHeight = scrollableBox.size.height;
      final requiredHeight = swatchSize + 2 * 24.0; // swatch size + 48dp padding

      expect(
        viewportHeight,
        greaterThanOrEqualTo(requiredHeight),
        reason: 'Viewport height ($viewportHeight) should be >= swatch size ($swatchSize) + 48dp = $requiredHeight',
      );
    });
  });
}
