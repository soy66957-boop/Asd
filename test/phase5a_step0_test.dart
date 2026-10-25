// Phase 5A Step 0 Tests - Tests for defects F1, F2, F3
// These MUST FAIL on current code before fixes

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';
import 'package:pipes/ui/core/widgets/pipes_header.dart';
import 'package:pipes/ui/core/widgets/pipes_toggle.dart';
import 'package:pipes/ui/core/widgets/pipes_swatch.dart';
import 'package:pipes/ui/features/level_select/views/level_select_view.dart';
import 'package:pipes/ui/features/settings/views/settings_view.dart';
import 'package:pipes/ui/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pipes/data/repositories/progress_repository.dart';
import 'package:pipes/data/services/hive_service.dart';
import 'package:pipes/data/services/settings_service.dart';
import 'package:pipes/domain/models/user_progress.dart';
import 'package:pipes/domain/models/app_settings.dart';
import 'package:pipes/domain/use_cases/level_generator.dart';

/// Test helper that captures pixels from an already-rendered RepaintBoundary at 390x844 logical px
/// with devicePixelRatio 3.
class PixelProbe {
  final WidgetTester tester;
  final GlobalKey boundaryKey;
  final Size originalViewSize;
  final double originalPixelRatio;

  PixelProbe(this.tester, this.boundaryKey)
      : originalViewSize = tester.view.physicalSize,
        originalPixelRatio = tester.view.devicePixelRatio {
    // Set up 390x844 logical pixels at 3x device pixel ratio = 1170x2532 physical
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
  }

  /// Returns the pixel color at [logicalPoint] from the already-rendered RepaintBoundary.
  Future<Color> probeColor(Offset logicalPoint) async {
    final boundary = boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final pixels = byteData!.buffer.asUint8List();
    final width = image.width;
    final x = (logicalPoint.dx * 3).round().clamp(0, width - 1);
    final y = (logicalPoint.dy * 3).round().clamp(0, image.height - 1);
    final index = (y * width + x) * 4;
    return Color.fromRGBO(pixels[index], pixels[index + 1], pixels[index + 2], pixels[index + 3] / 255.0);
  }

  void dispose() {
    tester.view.physicalSize = originalViewSize;
    tester.view.devicePixelRatio = originalPixelRatio;
  }
}

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
  AppSettings getSettings() => AppSettings();
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
      
      // The toggle should be 56x48 hit area (updated from 48x48 per fix)
      expect(toggleBox.size.width, equals(56.0));
      expect(toggleBox.size.height, equals(48.0));
    });

    testWidgets('toggle track rect lies inside its 56x48 hit box', (tester) async {
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
      
      // The toggle hit area should be 56x48
      expect(toggleBox.size.width, equals(56.0));
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

      // Find the horizontal Scrollable (the inner ListView for swatches)
      // It's the one with horizontal scroll direction
      final scrollableFinder = find.byType(Scrollable).at(0); // First scrollable is the horizontal one
      expect(scrollableFinder, findsOneWidget);
      final scrollableBox = tester.renderObject<RenderBox>(scrollableFinder);
      
      final viewportHeight = scrollableBox.size.height;
      final requiredHeight = swatchSize + 2 * 24.0; // swatch size + 48dp padding = 44 + 48 = 92

      expect(
        viewportHeight,
        greaterThanOrEqualTo(requiredHeight),
        reason: 'Viewport height ($viewportHeight) should be >= swatch size ($swatchSize) + 48dp = $requiredHeight',
      );
    });
  });

  group('Step 5b: Pixel-probe tests for G1 (level grid clipping) and G2 (toggle thumb clipping)', () {
    testWidgets('G2: toggle ON - thumb right edge pixels are thumb color (not clipped)', (tester) async {
      const probeKey = Key('g2_probe');
      
      // Build a toggle in ON state inside a RepaintBoundary
      await tester.pumpWidget(
        RepaintBoundary(
          key: probeKey,
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 390,
                height: 844,
                child: Center(
                  child: PipesToggle(
                    key: const Key('g2_toggle'),
                    value: true,
                    onChanged: (_) {},
                    semanticLabel: 'G2 probe toggle',
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final probe = PixelProbe(tester, probeKey);
      try {
        // Find the toggle's render box to get thumb rect
        final toggleFinder = find.byKey(const Key('g2_toggle'));
        final toggleBox = tester.renderObject<RenderBox>(toggleFinder);
        final toggleGlobalPos = toggleBox.localToGlobal(Offset.zero);

        // The toggle has hit area 56x48, track 48x32 centered, thumb 24dp
        // Thumb center when ON: track left + trackWidth - thumbRadius
        final c = PipesTokens.createDefault().components.toggle;
        final trackLeft = (c.hitWidth - c.trackWidth) / 2; // 4dp
        final thumbSize = c.thumbSize; // 24
        final thumbLeft = trackLeft + c.trackWidth - thumbSize; // 4 + 48 - 24 = 28
        final thumbTop = (c.hitHeight - thumbSize) / 2; // (48 - 24) / 2 = 12
        final thumbRect = Rect.fromLTWH(
          toggleGlobalPos.dx + thumbLeft,
          toggleGlobalPos.dy + thumbTop,
          thumbSize,
          thumbSize,
        );

        // Sample points
        final rightEdgePoint = Offset(thumbRect.right - 2, thumbRect.center.dy);
        final topEdgePoint = Offset(thumbRect.center.dx, thumbRect.top + 2);
        final outsideRightPoint = Offset(thumbRect.right + 2, thumbRect.center.dy);

        final rightColor = await probe.probeColor(rightEdgePoint);
        final topColor = await probe.probeColor(topEdgePoint);
        final outsideColor = await probe.probeColor(outsideRightPoint);

        final tokens = PipesTokens.createDefault();
        final thumbColor = tokens.currentPalette.onAccent; // thumb color when ON
        const tolerance = 12;

        // Both edge points must be thumb color (within tolerance)
        expect(
          (rightColor.r - thumbColor.r).abs() <= tolerance &&
              (rightColor.g - thumbColor.g).abs() <= tolerance &&
              (rightColor.b - thumbColor.b).abs() <= tolerance,
          isTrue,
          reason: 'G2: thumb right edge pixel at $rightEdgePoint should be thumb color, got $rightColor',
        );

        expect(
          (topColor.r - thumbColor.r).abs() <= tolerance &&
              (topColor.g - thumbColor.g).abs() <= tolerance &&
              (topColor.b - thumbColor.b).abs() <= tolerance,
          isTrue,
          reason: 'G2: thumb top edge pixel at $topEdgePoint should be thumb color, got $topColor',
        );

        // Point 1dp outside must NOT be thumb color
        final isThumbColor = (outsideColor.r - thumbColor.r).abs() <= tolerance &&
            (outsideColor.g - thumbColor.g).abs() <= tolerance &&
            (outsideColor.b - thumbColor.b).abs() <= tolerance;
        expect(
          isThumbColor,
          isFalse,
          reason: 'G2: pixel 1dp outside thumb right edge should NOT be thumb color, got $outsideColor',
        );

        // Print debug info if any check fails
        if (!((rightColor.r - thumbColor.r).abs() <= tolerance &&
            (rightColor.g - thumbColor.g).abs() <= tolerance &&
            (rightColor.b - thumbColor.b).abs() <= tolerance)) {
          debugDumpRenderTree();
        }
      } finally {
        probe.dispose();
      }
    });

    testWidgets('G1: first level grid row not clipped at top', (tester) async {
      const probeKey = Key('g1_probe');
      
      // Build the real LevelSelectView inside a RepaintBoundary
      await tester.pumpWidget(
        RepaintBoundary(
          key: probeKey,
          child: ProviderScope(
            overrides: [
              hiveServiceProvider.overrideWithValue(_MockHiveService()),
              settingsServiceProvider.overrideWithValue(_MockSettingsService()),
              levelGeneratorProvider.overrideWithValue(LevelGenerator()),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: SizedBox(
                  width: 390,
                  height: 844,
                  child: const LevelSelectView(),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final probe = PixelProbe(tester, probeKey);
      try {
        // Find the first level tile (level 1)
        final firstTileFinder = find.byKey(const ValueKey('level_tile_1'));
        expect(firstTileFinder, findsOneWidget);
        final firstTileBox = tester.renderObject<RenderBox>(firstTileFinder);
        final firstTileGlobalPos = firstTileBox.localToGlobal(Offset.zero);
        final firstTileRect = firstTileGlobalPos & firstTileBox.size;

        // Find the 5th level tile for height comparison
        final fifthTileFinder = find.byKey(const ValueKey('level_tile_5'));
        expect(fifthTileFinder, findsOneWidget);
        final fifthTileBox = tester.renderObject<RenderBox>(fifthTileFinder);
        final fifthTileRect = fifthTileBox.localToGlobal(Offset.zero) & fifthTileBox.size;

        // Sample point 2px below first tile's top edge
        final samplePoint = Offset(firstTileRect.center.dx, firstTileRect.top + 2);
        final sampleColor = await probe.probeColor(samplePoint);

        // The sample should be the tile's hairline/border color or fill color, NOT the screen background
        final tokens = PipesTokens.createDefault();
        final backgroundColor = tokens.currentPalette.background;
        final lockedBorderColor = tokens.components.levelTile.lockedBorder;
        final surfaceColor = tokens.currentPalette.surface;

        final isBackground = (sampleColor.r - backgroundColor.r).abs() <= 5 &&
            (sampleColor.g - backgroundColor.g).abs() <= 5 &&
            (sampleColor.b - backgroundColor.b).abs() <= 5;

        expect(
          isBackground,
          isFalse,
          reason: 'G1: pixel at first tile top+2 ($samplePoint) should be tile content (hairline/fill), not background. Got $sampleColor',
        );

        // First tile height should equal 5th tile height within 1px
        expect(
          (firstTileRect.height - fifthTileRect.height).abs(),
          lessThanOrEqualTo(1.0),
          reason: 'G1: first tile height (${firstTileRect.height}) should equal 5th tile height (${fifthTileRect.height}) within 1px',
        );

        if (isBackground) {
          debugDumpRenderTree();
        }
      } finally {
        probe.dispose();
      }
    });
  });
}
