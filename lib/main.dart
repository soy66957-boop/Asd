import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pipes/data/services/hive_service.dart';
import 'package:pipes/data/services/settings_service.dart';
import 'package:pipes/ui/core/theme/app_theme.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';
import 'package:pipes/ui/providers.dart';
import 'package:pipes/domain/models/app_settings.dart';
import 'package:pipes/ui/features/home/views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hiveService = HiveService();
  await hiveService.init();

  final settingsService = SettingsService();
  await settingsService.init();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(
    ProviderScope(
      overrides: [
        hiveServiceProvider.overrideWithValue(hiveService),
        settingsServiceProvider.overrideWithValue(settingsService),
      ],
      child: const PipesApp(),
    ),
  );
}

class PipesApp extends ConsumerWidget {
  const PipesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final tokens = _buildTokens(settings);
    return MaterialApp(
      title: 'Pipes',
      theme: AppTheme.fromTokens(tokens),
      darkTheme: AppTheme.fromTokens(tokens.copyWith(themeMode: ThemeMode.dark)),
      themeMode: ThemeMode.dark, // App runs dark by default
      home: const HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }

  PipesTokens _buildTokens(AppSettings settings) {
    // Map AppThemePreset.id to palette ID (they're the same)
    final paletteId = settings.theme.id;
    return PipesTokens.createDefault().copyWith(
      currentPaletteId: paletteId,
      themeMode: ThemeMode.dark,
    );
  }
}
