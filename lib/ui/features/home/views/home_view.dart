import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';
import 'package:pipes/ui/core/widgets/pipes_button.dart';
import 'package:pipes/ui/core/widgets/pipes_header.dart';
import 'package:pipes/ui/core/widgets/pipes_pill.dart';
import 'package:pipes/ui/features/game/views/game_view.dart';
import 'package:pipes/ui/features/how_to_play/views/how_to_play_view.dart';
import 'package:pipes/ui/features/level_select/views/level_select_view.dart';
import 'package:pipes/ui/features/settings/views/settings_view.dart';
import 'package:pipes/ui/providers.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(homeViewModelProvider.notifier).loadProgress());
  }

  void _showQuickPlayPicker(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => _QuickPlayDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);
    final palette = context.palette;
    final tokens = context.tokens;

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: tokens.spacing.xl,
            vertical: tokens.spacing.md,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  2 * tokens.spacing.md,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Header: [empty leading | Level pill centered | empty trailing]
                  PipesHeader(
                    leading: const SizedBox.shrink(),
                    center: state.progress != null
                        ? PipesPill(
                            text: 'Level ${state.progress!.currentLevel}',
                            variant: PipesPillVariant.standard,
                          )
                        : const SizedBox.shrink(),
                    trailing: const SizedBox.shrink(),
                  ),
                  // Body: Spacer(flex 2), title "Pipes", spacing, hero image, Spacer(flex 4), buttons
                  const Spacer(flex: 2),
                  Text(
                    'Pipes',
                    style: tokens.text.display.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                  SizedBox(height: tokens.spacing.md),
                  Image.asset(
                    'assets/icon.png',
                    width: 120,
                    height: 120,
                  ),
                  const Spacer(flex: 4),
                  PipesButton(
                    text: 'Play',
                    variant: PipesButtonVariant.primary,
                    onPressed: state.isLoading
                        ? null
                        : () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GameView(
                                  levelNumber: state.progress?.currentLevel ?? 1,
                                ),
                              ),
                            );
                            ref.read(homeViewModelProvider.notifier).loadProgress();
                          },
                    height: 44,
                  ),
                  SizedBox(height: tokens.spacing.md),
                  PipesButton(
                    text: 'Levels',
                    variant: PipesButtonVariant.secondary,
                    height: 44,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LevelSelectView(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: tokens.spacing.md),
                  PipesButton(
                    text: 'Random',
                    variant: PipesButtonVariant.secondary,
                    height: 44,
                    onPressed: () => _showQuickPlayPicker(context),
                  ),
                  SizedBox(height: tokens.spacing.md),
                  PipesButton(
                    text: 'How to Play',
                    variant: PipesButtonVariant.secondary,
                    height: 44,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HowToPlayView(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: tokens.spacing.md),
                  PipesButton(
                    text: 'Settings',
                    variant: PipesButtonVariant.secondary,
                    height: 44,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsView(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: tokens.spacing.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickPlayDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tokens = context.tokens;

    return Dialog(
      backgroundColor: palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radius.lg),
      ),
      child: Padding(
        padding: EdgeInsets.all(tokens.spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Quick Play',
              style: tokens.text.title.copyWith(
                color: palette.textPrimary,
              ),
            ),
            SizedBox(height: tokens.spacing.sm),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Play a dynamically generated Pipes puzzle.',
                textAlign: TextAlign.center,
                style: tokens.text.caption.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            ),
            SizedBox(height: tokens.spacing.xl),
            for (final stage in stages)
              Padding(
                padding: EdgeInsets.only(bottom: tokens.spacing.md),
                child: PipesButton(
                  text: stage,
                  variant: PipesButtonVariant.secondary,
                  height: 44,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameView(
                          levelNumber: 0,
                          isRandom: true,
                          randomDifficulty: stage,
                        ),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: tokens.spacing.sm),
            PipesButton(
              text: 'Cancel',
              variant: PipesButtonVariant.ghost,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

const stages = [
  'Beginner',
  'Easy',
  'Medium',
  'Hard',
  'Expert',
];
