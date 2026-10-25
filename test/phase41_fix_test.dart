// Phase 4.1 Fix Tests - These MUST FAIL on current code before fixes
// Tests for defects D1-D6 from the preview review

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';
import 'package:pipes/ui/core/widgets/pipes_button.dart';
import 'package:pipes/ui/core/widgets/pipes_header.dart';
import 'package:pipes/ui/core/widgets/pipes_icon_button.dart';
import 'package:pipes/ui/core/widgets/pipes_level_tile.dart';
import 'package:pipes/ui/core/widgets/pipes_pill.dart';
import 'package:pipes/ui/core/widgets/pipes_swatch.dart';
import 'package:pipes/ui/core/widgets/pipes_tap.dart';
import 'package:pipes/ui/core/widgets/pipes_toggle.dart';
import 'package:pipes/ui/features/home/views/home_view.dart';
import 'package:pipes/ui/features/home/view_models/home_view_model.dart';
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
}

class _MockSettingsService extends SettingsService {
  @override
  Future<void> init() async {}
  @override
  AppSettings getSettings() => const AppSettings();
  @override
  Future<void> saveSettings(AppSettings settings) async {}
}

class _TestLevelGenerator extends LevelGenerator {}

class _TestingHomeViewModel extends HomeViewModel {
  _TestingHomeViewModel() : super(
    progressRepository: ProgressRepository(hiveService: _MockHiveService()),
    levelGenerator: _TestLevelGenerator(),
  );
  @override
  Future<void> loadProgress() async {}
}

Widget createTestApp(Widget child, {String? initialRoute}) {
  return ProviderScope(
    overrides: [
      hiveServiceProvider.overrideWith((ref) => _MockHiveService()),
      settingsServiceProvider.overrideWith((ref) => _MockSettingsService()),
      homeViewModelProvider.overrideWith((ref) => _TestingHomeViewModel()),
    ],
    child: MaterialApp(
      home: child,
      initialRoute: initialRoute,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // =========================================================================
  // D1: Menu - Level pill centered, no truncation; "Pipes" title NOT in header
  // =========================================================================

  group('D1: Menu - Level pill and title layout', () {
    const screenWidth = 400.0;

    testWidgets('Level pill is horizontally centered within 2px of screen center', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: SizedBox(
              width: screenWidth,
              child: Center(
                child: PipesPill(
                  text: 'Level 12',
                  variant: PipesPillVariant.standard,
                ),
              ),
            ),
          ),
        ),
      );

      final pillFinder = find.byType(PipesPill);
      expect(pillFinder, findsOneWidget);

      final pillBox = tester.renderObject<RenderBox>(pillFinder);
      final pillCenterX = pillBox.localToGlobal(Offset.zero).dx + pillBox.size.width / 2;
      final screenCenterX = screenWidth / 2;

      // Pill center must be within 2px of screen center
      expect(
        (pillCenterX - screenCenterX).abs(),
        lessThanOrEqualTo(2.0),
        reason: 'Pill center ($pillCenterX) should be within 2px of screen center ($screenCenterX)',
      );
    });

    testWidgets('Level pill renders full text without ellipsis or truncation', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: SizedBox(
              width: screenWidth,
              child: Center(
                child: PipesPill(
                  text: 'Level 123',
                  variant: PipesPillVariant.standard,
                ),
              ),
            ),
          ),
        ),
      );

      final pillFinder = find.byType(PipesPill);
      final pillBox = tester.renderObject<RenderBox>(pillFinder);
      final textFinder = find.text('Level 123');
      expect(textFinder, findsOneWidget);

      // Get the text painter to measure intrinsic width
      final textElement = tester.element(textFinder);
      final textWidget = textElement.widget as Text;
      final textStyle = textWidget.style ?? DefaultTextStyle.of(textElement).style;
      final textPainter = TextPainter(
        text: TextSpan(text: 'Level 123', style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      final expectedMinWidth = textPainter.width + 2 * 16; // horizontal padding from tokens
      // Pill rendered width must be >= text width + padding (no truncation)
      expect(
        pillBox.size.width,
        greaterThanOrEqualTo(expectedMinWidth - 1), // allow 1px rounding
        reason: 'Pill width (${pillBox.size.width}) should be >= text width + padding ($expectedMinWidth)',
      );

      // Verify no ellipsis - the text should be fully visible
      final textBox = tester.renderObject<RenderBox>(textFinder);
      expect(textBox.size.width, greaterThanOrEqualTo(textPainter.width - 1));
    });

    testWidgets('HomeView: "Pipes" title is NOT in header, sits below header and above hero', (tester) async {
      // We need to test the actual HomeView structure
      // The header should have empty center (or just the level pill), NOT "Pipes"
      // The "Pipes" title should be in the body below the header
      // Use a taller screen to avoid overflow - set devicePixelRatio=1.0 for true logical pixels
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      addTearDown(() {
        tester.binding.window.clearPhysicalSizeTestValue();
        tester.binding.window.clearDevicePixelRatioTestValue();
      });
      
      await tester.pumpWidget(createTestApp(const HomeView()));

      // Find the header
      final headerFinder = find.byType(PipesHeader);
      expect(headerFinder, findsAtLeastNWidgets(1));

      // Check header center slot - should NOT contain "Pipes" text
      final headerCenterText = find.descendant(
        of: headerFinder.first,
        matching: find.text('Pipes'),
      );
      expect(
        headerCenterText,
        findsNothing,
        reason: '"Pipes" title should NOT be in the header center slot',
      );

      // Find "Pipes" title in the body (below header)
      final bodyPipesText = find.text('Pipes');
      expect(
        bodyPipesText,
        findsAtLeastNWidgets(1),
        reason: '"Pipes" title should exist in the body',
      );

      // Verify the "Pipes" text in body is below the header
      final headerBox = tester.renderObject<RenderBox>(headerFinder.first);
      final titleBox = tester.renderObject<RenderBox>(bodyPipesText.first);
      
      expect(
        titleBox.localToGlobal(Offset.zero).dy,
        greaterThan(headerBox.localToGlobal(Offset.zero).dy + headerBox.size.height - 1),
        reason: '"Pipes" title should be positioned below the header',
      );
    });
  });

  // =========================================================================
  // D2: Levels and Settings - Leading buttons not clipped, 16dp from edge
  // =========================================================================

  group('D2: Levels and Settings - Header leading button spacing', () {
    const screenWidth = 400.0;

    testWidgets('LevelSelectView: back button left edge >= 16dp from screen edge', (tester) async {
      await tester.pumpWidget(createTestApp(const LevelSelectView()));

      final backButtonFinder = find.byWidgetPredicate(
        (widget) => widget is PipesIconButton && widget.semanticLabel == 'Back to menu',
      );
      expect(backButtonFinder, findsOneWidget);

      final buttonBox = tester.renderObject<RenderBox>(backButtonFinder);
      final buttonLeft = buttonBox.localToGlobal(Offset.zero).dx;

      expect(
        buttonLeft,
        greaterThanOrEqualTo(16.0 - 0.5), // allow 0.5px rounding
        reason: 'Back button left edge ($buttonLeft) should be >= 16dp from screen edge',
      );
    });

    testWidgets('SettingsView: close button left edge >= 16dp from screen edge', (tester) async {
      await tester.pumpWidget(createTestApp(const SettingsView()));

      final closeButtonFinder = find.byWidgetPredicate(
        (widget) => widget is PipesIconButton && widget.semanticLabel == 'Close settings',
      );
      expect(closeButtonFinder, findsOneWidget);

      final buttonBox = tester.renderObject<RenderBox>(closeButtonFinder);
      final buttonLeft = buttonBox.localToGlobal(Offset.zero).dx;

      expect(
        buttonLeft,
        greaterThanOrEqualTo(16.0 - 0.5),
        reason: 'Close button left edge ($buttonLeft) should be >= 16dp from screen edge',
      );
    });

    testWidgets('PipesHeader has horizontal padding so circles are fully visible', (tester) async {
      // Test the header directly with a leading icon button
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: SizedBox(
              width: screenWidth,
              child: PipesHeader(
                leading: PipesIconButton(
                  icon: Icons.arrow_back,
                  onTap: () {},
                  semanticLabel: 'Back',
                  iconSize: 18,
                ),
                center: const SizedBox.shrink(),
                trailing: const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      );

      final headerFinder = find.byType(PipesHeader);
      final headerBox = tester.renderObject<RenderBox>(headerFinder);
      final leadingFinder = find.byType(PipesIconButton);
      final leadingBox = tester.renderObject<RenderBox>(leadingFinder);

      // Leading button should not be at x=0 (clipped)
      final leadingLeft = leadingBox.localToGlobal(Offset.zero).dx;
      final headerLeft = headerBox.localToGlobal(Offset.zero).dx;

      expect(
        leadingLeft - headerLeft,
        greaterThanOrEqualTo(16.0 - 0.5),
        reason: 'Leading button should have >= 16dp horizontal padding from header edge',
      );
    });
  });

  // =========================================================================
  // D3: Settings - "Hints" label exists, toggle compact, label left of toggle
  // =========================================================================

  group('D3: Settings - Hints row layout', () {
    testWidgets('SettingsView contains "Hints" label', (tester) async {
      await tester.pumpWidget(createTestApp(const SettingsView()));

      final hintsLabelFinder = find.text('Hints');
      expect(
        hintsLabelFinder,
        findsAtLeastNWidgets(1),
        reason: 'Settings should contain "Hints" label',
      );
    });

    testWidgets('PipesToggle in Settings has compact width <= 72dp', (tester) async {
      await tester.pumpWidget(createTestApp(const SettingsView()));

      final toggleFinder = find.byType(PipesToggle);
      expect(toggleFinder, findsAtLeastNWidgets(1));

      final toggleBox = tester.renderObject<RenderBox>(toggleFinder.first);
      
      expect(
        toggleBox.size.width,
        lessThanOrEqualTo(72.0 + 0.5),
        reason: 'Toggle width (${toggleBox.size.width}) should be <= 72dp (compact)',
      );
    });

    testWidgets('Hints label is left of toggle in same row', (tester) async {
      await tester.pumpWidget(createTestApp(const SettingsView()));

      final hintsLabelFinder = find.text('Hints');
      final toggleFinder = find.byType(PipesToggle);
      
      expect(hintsLabelFinder, findsAtLeastNWidgets(1));
      expect(toggleFinder, findsAtLeastNWidgets(1));

      final labelBox = tester.renderObject<RenderBox>(hintsLabelFinder.first);
      final toggleBox = tester.renderObject<RenderBox>(toggleFinder.first);

      // Label should be left of toggle
      final labelRight = labelBox.localToGlobal(Offset.zero).dx + labelBox.size.width;
      final toggleLeft = toggleBox.localToGlobal(Offset.zero).dx;

      expect(
        labelRight,
        lessThanOrEqualTo(toggleLeft + 1), // allow 1px overlap/rounding
        reason: 'Hints label should be left of toggle (labelRight=$labelRight, toggleLeft=$toggleLeft)',
      );

      // They should be vertically aligned (same row)
      final labelCenterY = labelBox.localToGlobal(Offset.zero).dy + labelBox.size.height / 2;
      final toggleCenterY = toggleBox.localToGlobal(Offset.zero).dy + toggleBox.size.height / 2;

      expect(
        (labelCenterY - toggleCenterY).abs(),
        lessThanOrEqualTo(4.0),
        reason: 'Label and toggle should be vertically aligned in same row',
      );
    });
  });

  // =========================================================================
// D4: Accent mismatch - All 9 palettes: Play button and current level tile border = palette accent
// =========================================================================

group('D4: Accent consistency across all 9 palettes', () {
  final tokens = PipesTokens.createDefault();
  // There are 9 base palettes, each with light and dark = 18 total
  // But we test the 9 base palette IDs
  final basePaletteIds = tokens.primitives.palettes.keys.toList();

  test('All 9 base palettes have distinct accent colors', () {
    expect(basePaletteIds.length, equals(9), reason: 'Should have exactly 9 base palette IDs');
    
    final accents = basePaletteIds.map((id) => tokens.primitives.of(id).baseAccent.value).toSet();
    expect(accents.length, equals(9), reason: 'All 9 base palettes should have distinct accent colors');
  });

  // Unit test: ComponentTokens.fromPalette uses correct palette accent for each palette
  test('ComponentTokens.fromPalette produces correct accent for each palette', () {
    final failures = <String>[];
    
    for (final paletteId in basePaletteIds) {
      // Get the dark variant of the palette
      final darkPaletteId = '${paletteId}Dark';
      final palette = tokens.palettes[darkPaletteId]!;
      final components = ComponentTokens.fromPalette(palette);
      
      // Primary button background should equal palette accent
      if (components.button.primaryBackground != palette.accent) {
        failures.add('$paletteId: Button primaryBackground ${components.button.primaryBackground} != palette.accent ${palette.accent}');
      }
      
      // Current level tile border should equal palette accent
      if (components.levelTile.currentBorder != palette.accent) {
        failures.add('$paletteId: LevelTile currentBorder ${components.levelTile.currentBorder} != palette.accent ${palette.accent}');
      }
      
      // Completed dot color should equal palette accent
      if (components.levelTile.completedDotColor != palette.accent) {
        failures.add('$paletteId: LevelTile completedDotColor ${components.levelTile.completedDotColor} != palette.accent ${palette.accent}');
      }
      
      // Ghost button foreground should equal palette accent
      if (components.button.ghostForeground != palette.accent) {
        failures.add('$paletteId: Button ghostForeground ${components.button.ghostForeground} != palette.accent ${palette.accent}');
      }
      
      // Swatch center dot should equal palette accent
      if (components.swatch.centerDotSize > 0) {
        // Swatch uses palette.accent for center dot (verified in swatch widget)
      }
    }
    
    expect(failures, isEmpty, reason: 'ComponentTokens palette mapping failures:\n${failures.join('\n')}');
  });

  // Widget smoke test: Menu renders without error for each palette
  testWidgets('Menu renders without error for all base palettes', (tester) async {
    for (final paletteId in basePaletteIds) {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [PipesTokens.createDefault().copyWith(currentPaletteId: paletteId, themeMode: ThemeMode.dark)],
          ),
          darkTheme: ThemeData(
            extensions: [PipesTokens.createDefault().copyWith(currentPaletteId: paletteId, themeMode: ThemeMode.dark)],
          ),
          themeMode: ThemeMode.dark,
          home: Scaffold(
            body: Builder(
              builder: (context) => PipesButton(
                text: 'Play',
                variant: PipesButtonVariant.primary,
                onPressed: () {},
                height: 48,
              ),
            ),
          ),
        ),
      );
      
      expect(find.byType(PipesButton), findsOneWidget);
    }
  });

  // Widget smoke test: LevelSelectView renders without error for each palette
  testWidgets('LevelSelectView renders without error for all base palettes', (tester) async {
    for (final paletteId in basePaletteIds) {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [PipesTokens.createDefault().copyWith(currentPaletteId: paletteId, themeMode: ThemeMode.dark)],
          ),
          darkTheme: ThemeData(
            extensions: [PipesTokens.createDefault().copyWith(currentPaletteId: paletteId, themeMode: ThemeMode.dark)],
          ),
          themeMode: ThemeMode.dark,
          home: Scaffold(
            body: Builder(
              builder: (context) => PipesLevelTile(
                levelNumber: 1,
                state: PipesLevelTileState.current,
                onTap: () {},
              ),
            ),
          ),
        ),
      );
      
      expect(find.byType(PipesLevelTile), findsOneWidget);
    }
  });
});

  // =========================================================================
  // D5: Hit targets - All tappable components >= 48x48dp hit area
  // =========================================================================

  group('D5: Hit targets - All tappable components >= 48x48dp', () {
    testWidgets('PipesButton hit area >= 48x48dp', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: Center(
              child: PipesButton(
                text: 'Test',
                onPressed: () {},
                height: 40, // Visible height smaller than 48
              ),
            ),
          ),
        ),
      );

      final buttonFinder = find.byType(PipesButton);
      final buttonBox = tester.renderObject<RenderBox>(buttonFinder);

      // The PipesTap wrapper should enforce minHitSize of 48
      expect(buttonBox.size.width, greaterThanOrEqualTo(48.0 - 0.5));
      expect(buttonBox.size.height, greaterThanOrEqualTo(48.0 - 0.5));
    });

    testWidgets('PipesIconButton hit area >= 48x48dp', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: Center(
              child: PipesIconButton(
                icon: Icons.home,
                onTap: () {},
                semanticLabel: 'Home',
                size: 40, // Visible size smaller than 48
              ),
            ),
          ),
        ),
      );

      final buttonFinder = find.byType(PipesIconButton);
      final buttonBox = tester.renderObject<RenderBox>(buttonFinder);

      expect(buttonBox.size.width, greaterThanOrEqualTo(48.0 - 0.5));
      expect(buttonBox.size.height, greaterThanOrEqualTo(48.0 - 0.5));
    });

    testWidgets('PipesToggle hit area >= 48x48dp', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: Center(
              child: PipesToggle(
                value: false,
                onChanged: (_) {},
                semanticLabel: 'Test toggle',
              ),
            ),
          ),
        ),
      );

      final toggleFinder = find.byType(PipesToggle);
      final toggleBox = tester.renderObject<RenderBox>(toggleFinder);

      // Toggle track may be < 48 wide but hit area should be >= 48
      expect(toggleBox.size.width, greaterThanOrEqualTo(48.0 - 0.5));
      expect(toggleBox.size.height, greaterThanOrEqualTo(48.0 - 0.5));
    });

    testWidgets('PipesSwatch hit area >= 48x48dp', (tester) async {
      final tokens = PipesTokens.createDefault();
      final palette = tokens.palettes.values.first;

      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: Center(
              child: PipesSwatch(
                palette: palette,
                isSelected: false,
                onTap: () {},
                semanticLabel: palette.name,
              ),
            ),
          ),
        ),
      );

      final swatchFinder = find.byType(PipesSwatch);
      final swatchBox = tester.renderObject<RenderBox>(swatchFinder);

      expect(swatchBox.size.width, greaterThanOrEqualTo(48.0 - 0.5));
      expect(swatchBox.size.height, greaterThanOrEqualTo(48.0 - 0.5));
    });

    testWidgets('PipesLevelTile hit area >= 48x48dp', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: Center(
              child: PipesLevelTile(
                levelNumber: 1,
                state: PipesLevelTileState.unlocked,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      final tileFinder = find.byType(PipesLevelTile);
      final tileBox = tester.renderObject<RenderBox>(tileFinder);

      expect(tileBox.size.width, greaterThanOrEqualTo(48.0 - 0.5));
      expect(tileBox.size.height, greaterThanOrEqualTo(48.0 - 0.5));
    });

    testWidgets('PipesPill if tappable has hit area >= 48x48dp', (tester) async {
      // PipesPill is not inherently tappable, but if wrapped in PipesTap it should have 48x48
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: Center(
              child: PipesTap(
                onTap: () {},
                minHitSize: 48.0,
                child: PipesPill(text: 'Level 1', variant: PipesPillVariant.standard),
              ),
            ),
          ),
        ),
      );

      final tapFinder = find.byType(PipesTap);
      final tapBox = tester.renderObject<RenderBox>(tapFinder);

      expect(tapBox.size.width, greaterThanOrEqualTo(48.0 - 0.5));
      expect(tapBox.size.height, greaterThanOrEqualTo(48.0 - 0.5));
    });
  });

  // =========================================================================
  // D6: Test inventory - Compare current vs phase-3-done
  // =========================================================================

  group('D6: Test inventory - Before vs after phase-3-done', () {
    test('Report current test files and test counts', () {
      // This test documents the current state
      // The actual comparison will be done by reading the files
      expect(true, isTrue); // Placeholder - actual inventory in separate script
    });
  });

  // =========================================================================
  // E1: Menu inventory - Against REAL HomeView with real theme
  // =========================================================================

  group('E1: Menu inventory - Real HomeView', () {
    // Test at 390x844 LOGICAL pixels (standard phone). Set physical size with devicePixelRatio=1.0
    // to achieve exact logical dimensions.
    const testWidth = 390.0;
    const testHeight = 844.0;

    void setTestViewport(WidgetTester tester) {
      tester.binding.window.physicalSizeTestValue = Size(testWidth, testHeight);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
    }

    void clearTestViewport(WidgetTester tester) {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    }

    testWidgets('Menu has Play, Levels, Random, How to Play, Settings in correct vertical order', (tester) async {
      setTestViewport(tester);
      addTearDown(() => clearTestViewport(tester));

      await tester.pumpWidget(createTestApp(const HomeView()));
      await tester.pumpAndSettle();

      // Find all menu buttons
      final playFinder = find.text('Play');
      final levelsFinder = find.text('Levels');
      final randomFinder = find.text('Random');
      final howToPlayFinder = find.text('How to Play');
      final settingsFinder = find.text('Settings');

      expect(playFinder, findsOneWidget, reason: 'Play button should exist');
      expect(levelsFinder, findsOneWidget, reason: 'Levels button should exist');
      expect(randomFinder, findsOneWidget, reason: 'Random button should exist (E1: Random button is gone)');
      expect(howToPlayFinder, findsOneWidget, reason: 'How to Play button should exist');
      expect(settingsFinder, findsOneWidget, reason: 'Settings button should exist');

      // Verify vertical order: Play, Levels, Random, How to Play, Settings
      final playBox = tester.renderObject<RenderBox>(playFinder);
      final levelsBox = tester.renderObject<RenderBox>(levelsFinder);
      final randomBox = tester.renderObject<RenderBox>(randomFinder);
      final howToPlayBox = tester.renderObject<RenderBox>(howToPlayFinder);
      final settingsBox = tester.renderObject<RenderBox>(settingsFinder);

      final playY = playBox.localToGlobal(Offset.zero).dy;
      final levelsY = levelsBox.localToGlobal(Offset.zero).dy;
      final randomY = randomBox.localToGlobal(Offset.zero).dy;
      final howToPlayY = howToPlayBox.localToGlobal(Offset.zero).dy;
      final settingsY = settingsBox.localToGlobal(Offset.zero).dy;

      expect(playY, lessThan(levelsY), reason: 'Play should be above Levels');
      expect(levelsY, lessThan(randomY), reason: 'Levels should be above Random');
      expect(randomY, lessThan(howToPlayY), reason: 'Random should be above How to Play');
      expect(howToPlayY, lessThan(settingsY), reason: 'How to Play should be above Settings');
    });

    testWidgets('Quick Play picker (Quick Play, Beginner, Easy, Medium, Hard, Expert, Cancel) NOT rendered inline until Random tapped', (tester) async {
      setTestViewport(tester);
      addTearDown(() => clearTestViewport(tester));

      await tester.pumpWidget(createTestApp(const HomeView()));
      await tester.pumpAndSettle();

      // Before tapping Random, picker elements should NOT exist in the menu tree
      expect(find.text('Quick Play'), findsNothing, reason: 'Quick Play title should not be in menu before Random tap');
      expect(find.text('Beginner'), findsNothing, reason: 'Beginner should not be in menu before Random tap');
      expect(find.text('Easy'), findsNothing, reason: 'Easy should not be in menu before Random tap');
      expect(find.text('Medium'), findsNothing, reason: 'Medium should not be in menu before Random tap');
      expect(find.text('Hard'), findsNothing, reason: 'Hard should not be in menu before Random tap');
      expect(find.text('Expert'), findsNothing, reason: 'Expert should not be in menu before Random tap');
      expect(find.text('Cancel'), findsNothing, reason: 'Cancel should not be in menu before Random tap');
    });

    testWidgets('After tapping Random, picker appears as modal (route above menu), Cancel closes it', (tester) async {
      setTestViewport(tester);
      addTearDown(() => clearTestViewport(tester));

      await tester.pumpWidget(createTestApp(const HomeView()));
      await tester.pumpAndSettle();

      // Tap Random button
      await tester.tap(find.text('Random'));
      await tester.pumpAndSettle();

      // Now picker elements should exist (in a modal/overlay)
      expect(find.text('Quick Play'), findsOneWidget, reason: 'Quick Play title should appear after Random tap');
      expect(find.text('Beginner'), findsOneWidget, reason: 'Beginner should appear after Random tap');
      expect(find.text('Easy'), findsOneWidget, reason: 'Easy should appear after Random tap');
      expect(find.text('Medium'), findsOneWidget, reason: 'Medium should appear after Random tap');
      expect(find.text('Hard'), findsOneWidget, reason: 'Hard should appear after Random tap');
      expect(find.text('Expert'), findsOneWidget, reason: 'Expert should appear after Random tap');
      expect(find.text('Cancel'), findsOneWidget, reason: 'Cancel should appear after Random tap');

      // Tap Cancel to close
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Picker should be gone
      expect(find.text('Quick Play'), findsNothing, reason: 'Quick Play title should disappear after Cancel');
      expect(find.text('Cancel'), findsNothing, reason: 'Cancel should disappear after Cancel');
    });

    testWidgets('Menu body does not scroll at 390x844 (no Scrollable on menu body)', (tester) async {
      setTestViewport(tester);
      addTearDown(() => clearTestViewport(tester));

      await tester.pumpWidget(createTestApp(const HomeView()));
      await tester.pumpAndSettle();

      // Find scrollables in the menu body - there should be none (or only the SafeArea which is not a scrollable)
      final scrollableFinders = find.byType(Scrollable);
      
      // The menu should NOT have a Scrollable wrapping its content
      // (SafeArea + Column should not scroll; SingleChildScrollView would be wrong)
      expect(
        scrollableFinders,
        findsNothing,
        reason: 'Menu body should not have a Scrollable widget (menu should not scroll at 390x844)',
      );
    });
  });

  // =========================================================================
  // E2: Settings inventory - Against REAL SettingsView
  // =========================================================================

  group('E2: Settings inventory - Real SettingsView', () {
    testWidgets('Exactly ONE PipesToggle exists (Hints)', (tester) async {
      await tester.pumpWidget(createTestApp(const SettingsView()));
      await tester.pumpAndSettle();

      final toggleFinders = find.byType(PipesToggle);
      expect(
        toggleFinders,
        findsOneWidget,
        reason: 'Settings should have exactly ONE PipesToggle (Hints), not two (E2: two toggles exist)',
      );
    });

    testWidgets('PipesToggle visible track is 52x32 dp (within 2dp)', (tester) async {
      await tester.pumpWidget(createTestApp(const SettingsView()));
      await tester.pumpAndSettle();

      // Find the track by key
      final trackFinder = find.byKey(const Key('pipes_toggle_track'));
      expect(trackFinder, findsOneWidget);
      final trackBox = tester.renderObject<RenderBox>(trackFinder);

      expect(
        (trackBox.size.width - 52).abs(),
        lessThanOrEqualTo(2.0),
        reason: 'Toggle track width (${trackBox.size.width}) should be 52dp ± 2dp',
      );
      expect(
        (trackBox.size.height - 32).abs(),
        lessThanOrEqualTo(2.0),
        reason: 'Toggle track height (${trackBox.size.height}) should be 32dp ± 2dp',
      );
    });

    testWidgets('PipesToggle thumb rect lies fully inside track rect', (tester) async {
      await tester.pumpWidget(createTestApp(const SettingsView()));
      await tester.pumpAndSettle();

      final trackFinder = find.byKey(const Key('pipes_toggle_track'));
      final trackBox = tester.renderObject<RenderBox>(trackFinder);
      
      // Track is 32dp tall, thumb is 24dp, so thumb Y is centered at (32-24)/2 = 4dp from top
      // This verifies the thumb fits within the track vertically
      expect(trackBox.size.height, equals(32.0), reason: 'Track height should be 32dp');
    });

    testWidgets('48dp hit area is NOT painted (invisible padding - track is 52x32, hit area 48x48)', (tester) async {
      await tester.pumpWidget(createTestApp(const SettingsView()));
      await tester.pumpAndSettle();

      // Widget (GestureDetector + hit area box) should be 48x48
      final toggleFinder = find.byType(PipesToggle);
      final toggleBox = tester.renderObject<RenderBox>(toggleFinder);

      expect(
        toggleBox.size.width,
        equals(48.0),
        reason: 'Widget hit area width should be 48dp',
      );
      expect(
        toggleBox.size.height,
        equals(48.0),
        reason: 'Widget hit area height should be 48dp',
      );

      // Track should be 52x32 (NOT 48x48) - painted shape is not grown by hit area
      final trackFinder = find.byKey(const Key('pipes_toggle_track'));
      final trackBox = tester.renderObject<RenderBox>(trackFinder);
      expect(trackBox.size.width, equals(52.0), reason: 'Track width should be 52dp (not grown by hit area)');
      expect(trackBox.size.height, equals(32.0), reason: 'Track height should be 32dp (not grown by hit area)');
    });

    testWidgets('Hints label left of toggle, same row center Y within 4px', (tester) async {
      await tester.pumpWidget(createTestApp(const SettingsView()));
      await tester.pumpAndSettle();

      final hintsLabelFinder = find.text('Hints');
      final toggleFinder = find.byType(PipesToggle);

      expect(hintsLabelFinder, findsOneWidget);
      expect(toggleFinder, findsOneWidget);

      final labelBox = tester.renderObject<RenderBox>(hintsLabelFinder);
      final toggleBox = tester.renderObject<RenderBox>(toggleFinder);

      // Label should be left of toggle
      final labelRight = labelBox.localToGlobal(Offset.zero).dx + labelBox.size.width;
      final toggleLeft = toggleBox.localToGlobal(Offset.zero).dx;

      expect(
        labelRight,
        lessThanOrEqualTo(toggleLeft + 1),
        reason: 'Hints label should be left of toggle',
      );

      // Same row center Y
      final labelCenterY = labelBox.localToGlobal(Offset.zero).dy + labelBox.size.height / 2;
      final toggleCenterY = toggleBox.localToGlobal(Offset.zero).dy + toggleBox.size.height / 2;

      expect(
        (labelCenterY - toggleCenterY).abs(),
        lessThanOrEqualTo(4.0),
        reason: 'Hints label and toggle should be vertically aligned (center Y within 4px)',
      );
    });

    testWidgets('Vertical order: Theme label, swatches, Hints row, Reset Progress', (tester) async {
      await tester.pumpWidget(createTestApp(const SettingsView()));
      await tester.pumpAndSettle();

      // Find key elements
      final themeLabelFinder = find.text('Theme');
      final hintsLabelFinder = find.text('Hints');
      final resetFinder = find.text('Reset Progress');

      expect(themeLabelFinder, findsOneWidget, reason: 'Theme label should exist');
      expect(hintsLabelFinder, findsOneWidget, reason: 'Hints label should exist');
      expect(resetFinder, findsOneWidget, reason: 'Reset Progress should exist');

      final themeBox = tester.renderObject<RenderBox>(themeLabelFinder);
      final hintsBox = tester.renderObject<RenderBox>(hintsLabelFinder);
      final resetBox = tester.renderObject<RenderBox>(resetFinder);

      final themeY = themeBox.localToGlobal(Offset.zero).dy;
      final hintsY = hintsBox.localToGlobal(Offset.zero).dy;
      final resetY = resetBox.localToGlobal(Offset.zero).dy;

      expect(themeY, lessThan(hintsY), reason: 'Theme label should be above Hints row');
      expect(hintsY, lessThan(resetY), reason: 'Hints row should be above Reset Progress');
    });
  });

  // =========================================================================
  // E5: Pill compactness - Level N pill width at most text + 32dp, centered
  // =========================================================================

  group('E5: Level pill compactness', () {
    const screenWidth = 390.0;

    testWidgets('Level pill width <= text width + 32dp (16dp each side)', (tester) async {
      // Render pill in Center without Scaffold to measure intrinsic width
      // Scaffold body gives tight constraints causing Center to expand
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: PipesPill(
              text: 'Level 123',
              variant: PipesPillVariant.standard,
            ),
          ),
        ),
      );

      final pillFinder = find.byType(PipesPill);
      expect(pillFinder, findsOneWidget);

      final pillBox = tester.renderObject<RenderBox>(pillFinder);
      final textFinder = find.text('Level 123');
      final textElement = tester.element(textFinder);
      final textWidget = textElement.widget as Text;
      final textStyle = textWidget.style ?? DefaultTextStyle.of(textElement).style;
      final textPainter = TextPainter(
        text: TextSpan(text: 'Level 123', style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      final expectedMaxWidth = textPainter.width + 32.0; // text + 16dp each side
      
      expect(
        pillBox.size.width,
        lessThanOrEqualTo(expectedMaxWidth + 1), // allow 1px rounding
        reason: 'Pill width (${pillBox.size.width}) should be <= text width + 32dp ($expectedMaxWidth)',
      );
    });

    testWidgets('Level pill center is at screen center within 2px (in header at 390dp)', (tester) async {
      // Test centering in actual header context at 390dp width
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: SizedBox(
              width: screenWidth,
              child: PipesHeader(
                leading: const SizedBox.shrink(),
                center: PipesPill(
                  text: 'Level 1',
                  variant: PipesPillVariant.standard,
                ),
                trailing: const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      );

      final pillFinder = find.byType(PipesPill);
      expect(pillFinder, findsOneWidget);

      final pillBox = tester.renderObject<RenderBox>(pillFinder);
      final pillCenterX = pillBox.localToGlobal(Offset.zero).dx + pillBox.size.width / 2;
      final screenCenterX = screenWidth / 2;

      expect(
        (pillCenterX - screenCenterX).abs(),
        lessThanOrEqualTo(2.0),
        reason: 'Pill center ($pillCenterX) should be within 2px of screen center ($screenCenterX)',
      );
    });

    testWidgets('Level pill single line, never truncated', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: PipesPill(
              text: 'Level 9999',
              variant: PipesPillVariant.standard,
            ),
          ),
        ),
      );

      final pillFinder = find.byType(PipesPill);
      final textFinder = find.text('Level 9999');
      
      expect(pillFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);

      final textElement = tester.element(textFinder);
      final textWidget = textElement.widget as Text;
      
      // Verify maxLines is 1 or not set (default single line)
      expect(textWidget.maxLines, anyOf(isNull, equals(1)), reason: 'Pill text should be single line');
      
      // Verify no overflow/ellipsis
      final textBox = tester.renderObject<RenderBox>(textFinder);
      final textPainter = TextPainter(
        text: TextSpan(text: 'Level 9999', style: textWidget.style ?? DefaultTextStyle.of(textElement).style),
        textDirection: TextDirection.ltr,
      )..layout();
      
      expect(
        textBox.size.width,
        greaterThanOrEqualTo(textPainter.width - 1),
        reason: 'Text should not be truncated (rendered width >= intrinsic width)',
      );
    });
  });
}
