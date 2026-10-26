import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pipes/ui/core/icons/pipes_icons.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';
import 'package:pipes/ui/core/widgets/pipes_header.dart';
import 'package:pipes/ui/core/widgets/pipes_icon_button.dart';
import 'package:pipes/ui/core/widgets/pipes_level_tile.dart';
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
            PipesHeader(
              leading: PipesIconButton(
                icon: PipesIcons.back,
                onTap: () => Navigator.pop(context),
                semanticLabel: 'Back to menu',
                iconSize: 18,
              ),
              center: Text(
                'Levels',
                style: tokens.text.title.copyWith(
                  color: palette.textPrimary,
                ),
              ),
              trailing: const SizedBox.shrink(),
            ),
            Expanded(
              child: GridView.builder(
                clipBehavior: Clip.none,
                padding: EdgeInsets.fromLTRB(
                  tokens.spacing.xl,
                  tokens.spacing.xl + 8, // Extra 8dp to clear header
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

                  PipesLevelTileState tileState;
                  if (isLocked) {
                    tileState = PipesLevelTileState.locked;
                  } else if (isCurrent) {
                    tileState = PipesLevelTileState.current;
                  } else if (isCompleted) {
                    tileState = PipesLevelTileState.completed;
                  } else {
                    tileState = PipesLevelTileState.unlocked;
                  }

                  return PipesLevelTile(
                    key: ValueKey('level_tile_$levelNumber'),
                    levelNumber: levelNumber,
                    state: tileState,
                    onTap: isLocked
                        ? null
                        : () async {
                            ref.read(levelGeneratorProvider).pregenerateAround(levelNumber, range: 1);
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GameView(levelNumber: levelNumber),
                              ),
                            );
                            ref.read(homeViewModelProvider.notifier).loadProgress();
                          },
                    semanticLabel: 'Level $levelNumber, ${_stateName(tileState)}',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _stateName(PipesLevelTileState s) {
    return switch (s) {
      PipesLevelTileState.locked => 'locked',
      PipesLevelTileState.unlocked => 'unlocked',
      PipesLevelTileState.current => 'current',
      PipesLevelTileState.completed => 'completed',
    };
  }
}
