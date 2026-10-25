import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pipes/domain/models/app_settings.dart';
import 'package:pipes/ui/core/icons/pipes_icons.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';
import 'package:pipes/ui/core/widgets/pipes_button.dart';
import 'package:pipes/ui/core/widgets/pipes_header.dart';
import 'package:pipes/ui/core/widgets/pipes_icon_button.dart';
import 'package:pipes/ui/core/widgets/pipes_swatch.dart';
import 'package:pipes/ui/core/widgets/pipes_toggle.dart';
import 'package:pipes/ui/providers.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final palette = context.palette;
    final tokens = context.tokens;

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: Column(
          children: [
            PipesHeader(
              leading: PipesIconButton(
                icon: PipesIcons.close,
                onTap: () => Navigator.pop(context),
                semanticLabel: 'Close settings',
                iconSize: 20,
              ),
              center: Text(
                'Settings',
                style: tokens.text.title.copyWith(
                  color: palette.textPrimary,
                ),
              ),
              trailing: const SizedBox.shrink(),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: tokens.spacing.xl,
                  vertical: tokens.spacing.md,
                ),
                children: [
                  // Theme label
                  Text(
                    'Theme',
                    style: tokens.text.label.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                  SizedBox(height: tokens.spacing.md),
                  // Theme swatches
                  SizedBox(
                    height: 92, // 44dp swatch + 2 * 24dp for glow
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: AppThemePreset.values.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: tokens.spacing.md),
                      itemBuilder: (context, index) {
                        final preset = AppThemePreset.values[index];
                        final isSelected = settings.theme == preset;
                        final paletteTokens = _getPaletteTokens(context, preset);
                        return PipesSwatch(
                          palette: paletteTokens,
                          isSelected: isSelected,
                          onTap: () {
                            ref
                                .read(settingsProvider.notifier)
                                .setTheme(preset);
                          },
                          semanticLabel: preset.displayName,
                        );
                      },
                    ),
                  ),

                  _divider(context),

                  // Hints row (single toggle, label left of toggle)
                  Row(
                    children: [
                      Text(
                        'Hints',
                        style: tokens.text.label.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      PipesToggle(
                        value: settings.isHintEnabled,
                        onChanged: (value) =>
                            ref.read(settingsProvider.notifier).toggleHintEnabled(value),
                        semanticLabel: 'Hints',
                      ),
                    ],
                  ),

                  _divider(context),

                  // Reset Progress
                  PipesButton(
                    text: 'Reset Progress',
                    variant: PipesButtonVariant.danger,
                    height: 48,
                    onPressed: () => _confirmReset(context, ref),
                  ),
                  SizedBox(height: tokens.spacing.lg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(BuildContext context) {
    final palette = context.palette;
    final tokens = context.tokens;
    return Container(
      height: 1,
      color: palette.glassBorder.withValues(alpha: 0.25),
      margin: EdgeInsets.symmetric(vertical: tokens.spacing.xl),
    );
  }

  PaletteTokens _getPaletteTokens(BuildContext context, AppThemePreset preset) {
    final tokens = context.tokens;
    final key = '${preset.id}${preset.isDark ? 'Dark' : 'Light'}';
    return tokens.palettes[key]!;
  }

  void _confirmReset(BuildContext context, WidgetRef ref) {
    final palette = context.palette;
    final tokens = context.tokens;
    showDialog(
      context: context,
      barrierColor: palette.background.withValues(alpha: 0.75),
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(tokens.radius.lg),
            border: Border.all(
              color: palette.danger.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          padding: EdgeInsets.all(tokens.spacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Reset progress?',
                style: tokens.text.title.copyWith(
                  color: palette.textPrimary,
                ),
              ),
              SizedBox(height: tokens.spacing.md),
              Text(
                'All solved puzzles, best times, and saved games will be permanently erased.',
                textAlign: TextAlign.center,
                style: tokens.text.body.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              SizedBox(height: tokens.spacing.xl),
              Row(
                children: [
                  Expanded(
                    child: PipesButton(
                      text: 'Cancel',
                      variant: PipesButtonVariant.secondary,
                      height: 44,
                      onPressed: () => Navigator.pop(dialogContext),
                    ),
                  ),
                  SizedBox(width: tokens.spacing.md),
                  Expanded(
                    child: PipesButton(
                      text: 'Reset',
                      variant: PipesButtonVariant.danger,
                      height: 44,
                      onPressed: () async {
                        await ref
                            .read(homeViewModelProvider.notifier)
                            .resetProgress();
                        if (dialogContext.mounted) Navigator.pop(dialogContext);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
