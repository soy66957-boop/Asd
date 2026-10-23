import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pipes/data/services/hive_service.dart';
import 'package:pipes/data/services/settings_service.dart';
import 'package:pipes/data/services/user_progress_adapter.dart';
import 'package:pipes/main.dart' as app;
import 'package:pipes/ui/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Smoke Test', () {
    late HiveService hiveService;
    late SettingsService settingsService;

    setUpAll() async {
      SharedPreferences.setMockInitialValues({});
      await Hive.initFlutter();
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(UserProgressAdapter());
      }
      hiveService = HiveService();
      await hiveService.init();
      settingsService = SettingsService();
      await settingsService.init();
    }

    tearDownAll() async {
      await Hive.close();
    }

    testWidgets('App shows "Pipes" and "Play" on menu', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            hiveServiceProvider.overrideWithValue(hiveService),
            settingsServiceProvider.overrideWithValue(settingsService),
          ],
          child: const app.PipesApp(),
        ),
      );

      // Wait for async initialization
      await tester.pumpAndSettle();

      // Verify "Pipes" title exists
      expect(find.text('Pipes'), findsAtLeastNWidgets(1));

      // Verify "Play" button/text exists
      expect(find.text('Play'), findsAtLeastNWidgets(1));
    });
  });
}
