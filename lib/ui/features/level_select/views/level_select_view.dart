import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';
import 'package:pipes/ui/features/game/views/game_view.dart';
import 'package:pipes/ui/providers.dart';

class LevelSelectView extends ConsumerStatefulWidget {
  const LevelSelectView({super.key});

  @override
  ConsumerState<LevelSelectView> createState() => _LevelSelectViewState();
}

class _LevelSelectViewState extends ConsumerState<LevelSelectView> {
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
    final highestCompleted = state.progress?.highestLevelCompleted ?? 0;
    final unlockedLevel = math.max(highestCompleted + 1, state.progress?.currentLevel ?? 1);
    final int totalLevelsToShow = unlockedLevel + 10;

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: tokens.spacing.md,
                vertical: tokens.spacing.sm,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
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
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Levels',
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
              child: GridView.builder(
                padding: EdgeInsets.fromLTRB(
                  tokens.spacing.xl,
                  tokens.spacing.xl,
                  tokens.spacing.xxl,
                  tokens.spacing.xxl,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: tokens.spacing.lg,
                  mainAxisSpacing: tokens.spacing.lg,
                  childAspectRatio: 1.0,
                ),
                itemCount: totalLevelsToShow,
                itemBuilder: (context, index) {
                  final levelNumber = index + 1;
                  final isCompleted = levelNumber <= highestCompleted;
                  final isCurrent = levelNumber == unlockedLevel;
                  final isLocked = levelNumber > unlockedLevel;

                  return _buildLevelCard(
                    context,
                    levelNumber: levelNumber,
                    isCompleted: isCompleted,
                    isCurrent: isCurrent,
                    isLocked: isLocked,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard(
    BuildContext context, {
    required int levelNumber,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLocked,
  }) {
    final palette = context.palette;
    final tokens = context.tokens;

    Color cardBg = palette.surface;
    Color textColor = palette.textPrimary;
    Color borderColor = palette.glassBorder;
    Widget content;
    bool isClickable = !isLocked;

    if (isCompleted) {
      cardBg = palette.success;
      textColor = Colors.white;
      borderColor = palette.success;
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 20,
            color: Colors.white,
          ),
          SizedBox(height: tokens.spacing.xs),
        ],
      );
    } else if (isCurrent) {
      cardBg = palette.accent;
      textColor = palette.textPrimary;
      borderColor = palette.accent;
      content = const SizedBox.shrink();
    } else {
      cardBg = palette.surface.withValues(alpha: 0.5);
      textColor = palette.textSecondary;
      borderColor = palette.glassBorder.withValues(alpha: 0.4);
      content = const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: isClickable
          ? () async {
              ref.read(levelGeneratorProvider).pregenerateAround(levelNumber, range: 1);
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameView(levelNumber: levelNumber),
                ),
              );
              ref.read(homeViewModelProvider.notifier).loadProgress();
            }
          : null,
      child: AnimatedContainer(
        duration: tokens.motion.fast,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(tokens.radius.md),
          border: Border.all(
            color: borderColor,
            width: isCurrent ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: palette.textPrimary.withValues(alpha: 0.06),
              offset: const Offset(0, 3),
              blurRadius: 4,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: isLocked
            ? Icon(
                Icons.lock_rounded,
                size: 20,
                color: palette.textSecondary.withValues(alpha: 0.6),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$levelNumber',
                    style: tokens.text.body.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  if (isCompleted) content,
                ],
              ),
      ),
    );
  }
}
