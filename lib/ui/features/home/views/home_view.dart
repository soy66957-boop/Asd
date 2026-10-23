import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';
import 'package:pipes/ui/core/widgets/tangible_button.dart'
import 'package:pipes/ui/core/url_launcher.dart';
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

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    double iconSize = 20,
    Color? iconColor,
  }) {
    final palette = context.palette;
    final tokens = context.tokens;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(tokens.spacing.md),
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
          icon,
          size: iconSize,
          color: iconColor ?? palette.textPrimary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleButton(
                    icon: Icons.star_rounded,
                    iconColor: palette.star,
                    onTap: () => openUrl('https://github.com/sidhant947/Pipes'),
                  ),
                  if (state.progress != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: tokens.spacing.xl,
                        vertical: tokens.spacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: palette.surface,
                        borderRadius: BorderRadius.circular(tokens.radius.pill),
                        border: Border.all(
                          color: palette.glassBorder,
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        'Level ${state.progress!.currentLevel}',
                        style: tokens.text.label.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  // Heart button removed (was donation link)
                ],
              ),
              const Spacer(flex: 3),
              Image.asset(
                'assets/icon.png',
                width: 120,
                height: 120,
              ),
              const Spacer(flex: 4),
              TangibleButton(
                text: 'Play',
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
              ),
              SizedBox(height: tokens.spacing.lg),
              TangibleButton(
                text: 'Levels',
                isSecondary: true,
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
              TangibleButton(
                text: 'Random',
                isSecondary: true,
                onPressed: () => _showDifficultyDialog(context),
              ),
              SizedBox(height: tokens.spacing.lg),
              TangibleButton(
                text: 'How to Play',
                isSecondary: true,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HowToPlayView(),
                  ),
                ),
              ),
              SizedBox(height: tokens.spacing.lg),
              TangibleButton(
                text: 'Settings',
                isSecondary: true,
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
                  child: TangibleButton(
                    text: stage,
                    height: 44,
                    isSecondary: true,
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
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: tokens.text.label.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
