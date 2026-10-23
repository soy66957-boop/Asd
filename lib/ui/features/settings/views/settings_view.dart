import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pipes/domain/models/app_settings.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';
import 'package:pipes/ui/core/widgets/tangible_button.dart';
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
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: tokens.spacing.lg,
                vertical: tokens.spacing.md,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: palette.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: palette.glassBorder,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: palette.textPrimary.withValues(alpha: 0.08),
                            offset: const Offset(0, 3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Settings',
                        style: tokens.text.title.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: tokens.spacing.xl),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: tokens.spacing.xl,
                  vertical: tokens.spacing.md,
                ),
                children: [
                  Text(
                    'Theme',
                    style: tokens.text.label.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                  SizedBox(height: tokens.spacing.md),
                  SizedBox(
                    height: 46,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: AppThemePreset.values.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: tokens.spacing.md),
                      itemBuilder: (context, index) {
                        final preset = AppThemePreset.values[index];
                        final isSelected = settings.theme == preset;
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            ref
                                .read(settingsProvider.notifier)
                                .setTheme(preset);
                          },
                          child: AnimatedContainer(
                            duration: tokens.motion.fast,
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: preset.bg,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? preset.accent
                                    : preset.border,
                                width: isSelected ? 2.5 : 1.0,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: preset.accent.withValues(alpha: 0.35),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: preset.accent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  _divider(context),

                  _gameToggle(
                    context,
                    label: 'Hints',
                    value: settings.isHintEnabled,
                    onChanged: (val) {
                      ref
                          .read(settingsProvider.notifier)
                          .toggleHintEnabled(val);
                    },
                  ),

                  _divider(context),

                  TangibleButton(
                    text: 'Reset Progress',
                    isSecondary: true,
                    height: 48,
                    backgroundColor: palette.surface,
                    textColor: palette.danger,
                    borderColor: palette.danger.withValues(alpha: 0.33),
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

  Widget _gameToggle(
    BuildContext context, {
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final palette = context.palette;
    final tokens = context.tokens;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.selectionClick();
        onChanged(!value);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: tokens.spacing.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: tokens.text.label.copyWith(
                color: palette.textPrimary,
              ),
            ),
            AnimatedContainer(
              duration: tokens.motion.base,
              width: 48,
              height: 28,
              padding: EdgeInsets.all(tokens.spacing.xs),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(tokens.radius.pill),
                color: value
                    ? palette.accent
                    : palette.textPrimary.withValues(alpha: 0.12),
                border: Border.all(
                  color: value ? palette.accent : palette.glassBorder,
                  width: 1.0,
                ),
              ),
              child: AnimatedAlign(
                duration: tokens.motion.base,
                curve: tokens.curves.easeOutCubic,
                alignment: value
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        offset: const Offset(0, 1.5),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmReset(BuildContext context, WidgetRef ref) {
    final palette = context.palette;
    final tokens = context.tokens;
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
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
                    child: TangibleButton(
                      text: 'Cancel',
                      isSecondary: true,
                      height: 44,
                      onPressed: () => Navigator.pop(dialogContext),
                    ),
                  ),
                  SizedBox(width: tokens.spacing.md),
                  Expanded(
                    child: TangibleButton(
                      text: 'Reset',
                      backgroundColor: palette.danger,
                      textColor: Colors.white,
                      borderColor: palette.danger,
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
