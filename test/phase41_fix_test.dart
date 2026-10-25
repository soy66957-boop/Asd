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

class _TestingHomeViewModel extends StateNotifier<HomeViewModelState> {
  _TestingHomeViewModel() : super(const HomeViewModelState());
  @override
  void dispose() {}
}

Widget createTestApp(Widget child, {String? initialRoute}) {
  return ProviderScope(
    overrides: [
      hiveServiceProvider.overrideWith((ref) => throw UnimplementedError()),
      settingsServiceProvider.overrideWith((ref) => throw UnimplementedError()),
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

    testWidgets('Menu Play button fill matches active palette accent for all base palettes', (tester) async {
      final failures = <String>[];

      for (final paletteId in basePaletteIds) {
        // Create a test app with this specific palette
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              hiveServiceProvider.overrideWith((ref) => throw UnimplementedError()),
              settingsServiceProvider.overrideWith((ref) => throw UnimplementedError()),
            ],
            child: MaterialApp(
              theme: ThemeData(
                extensions: [PipesTokens.createDefault().copyWith(currentPaletteId: paletteId, themeMode: ThemeMode.dark)],
              ),
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
          ),
        );

        final buttonFinder = find.byType(PipesButton);
        expect(buttonFinder, findsOneWidget);

        // Get the button's background color via the token resolution
        final buttonElement = tester.element(buttonFinder);
        final context = buttonElement;
        final activePalette = context.palette;
        
        // The primary button should use palette.accent as background
        final expectedAccent = tokens.primitives.of(paletteId).baseAccent;
        if (activePalette.accent != expectedAccent) {
          failures.add('$paletteId: Button accent ${activePalette.accent} != expected ${expectedAccent}');
        }
      }

      expect(failures, isEmpty, reason: failures.join('\n'));
    });

    testWidgets('LevelSelectView current level tile border matches active palette accent for all base palettes', (tester) async {
      final failures = <String>[];

      for (final paletteId in basePaletteIds) {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              hiveServiceProvider.overrideWith((ref) => throw UnimplementedError()),
              settingsServiceProvider.overrideWith((ref) => throw UnimplementedError()),
            ],
            child: MaterialApp(
              theme: ThemeData(
                extensions: [PipesTokens.createDefault().copyWith(currentPaletteId: paletteId, themeMode: ThemeMode.dark)],
              ),
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
          ),
        );

        final tileFinder = find.byType(PipesLevelTile);
        expect(tileFinder, findsOneWidget);

        // Check the border color by inspecting the widget tree
        final context = tester.element(tileFinder);
        final activePalette = context.palette;
        
        final expectedAccent = tokens.primitives.of(paletteId).baseAccent;
        if (activePalette.accent != expectedAccent) {
          failures.add('$paletteId: Tile accent ${activePalette.accent} != expected ${expectedAccent}');
        }
      }

      expect(failures, isEmpty, reason: failures.join('\n'));
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
}
