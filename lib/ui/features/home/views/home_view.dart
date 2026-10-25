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
            vertical: tokens.spacing.xl,
          ),
          child: Column(
            children: [
              // Header with centered title and level pill
              PipesHeader(
                leading: const SizedBox.shrink(),
                center: Text(
                  'Pipes',
                  style: tokens.text.display.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                trailing: state.progress != null
                    ? PipesPill(
                        text: 'Level ${state.progress!.currentLevel}',
                        variant: PipesPillVariant.standard,
                      )
                    : const SizedBox.shrink(),
              ),
              const Spacer(flex: 3),
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
                isLoading: state.isLoading,
              ),
              SizedBox(height: tokens.spacing.lg),
              PipesButton(
                text: 'Levels',
                variant: PipesButtonVariant.secondary,
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LevelSelectView(),
                    ),
                  );
                  ref.read(homeViewModelProvider.notifier).loadProgress();
                },
              ),
              SizedBox(height: tokens.spacing.lg),
              PipesButton(
                text: 'Random',
                variant: PipesButtonVariant.secondary,
                onPressed: () => _showDifficultyDialog(context),
              ),
              SizedBox(height: tokens.spacing.lg),
              PipesButton(
                text: 'How to Play',
                variant: PipesButtonVariant.secondary,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HowToPlayView(),
                  ),
                ),
              ),
              SizedBox(height: tokens.spacing.lg),
              PipesButton(
                text: 'Settings',
                variant: PipesButtonVariant.secondary,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsView(),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _showDifficultyDialog(BuildContext context) {
    final stages = [
      'Easy',
      'Medium',
      'Hard',
      'Expert',
      'Master',
    ];
    final palette = context.palette;
    final tokens = context.tokens;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: palette.background,
            borderRadius: BorderRadius.circular(tokens.radius.lg),
            border: Border.all(
              color: palette.glassBorder,
              width: 1.0,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: tokens.spacing.xl,
            vertical: tokens.spacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Choose Difficulty',
                  style: tokens.text.title.copyWith(
                    color: palette.textPrimary,
                  ),
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
      ),
    );
  }
}
