import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';
import 'package:pipes/ui/core/widgets/tangible_button.dart';
import 'package:pipes/ui/providers.dart';

class HowToPlayView extends ConsumerWidget {
  const HowToPlayView({super.key});

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
                horizontal: tokens.spacing.md,
                vertical: tokens.spacing.md,
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
                        'How to Play',
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
                  vertical: tokens.spacing.lg,
                ),
                children: [
                  _guideStep(
                    context: context,
                    stepNumber: '1',
                    title: 'Goal',
                    description:
                        'Connect every pipe on the grid so water flows from the source to every single pipe.',
                  ),
                  SizedBox(height: tokens.spacing.xl),
                  _guideStep(
                    context: context,
                    stepNumber: '2',
                    title: 'Water Source',
                    description:
                        'The source is at the center tile. Water automatically flows through any aligned, matching pipe connections.',
                  ),
                  SizedBox(height: tokens.spacing.xl),
                  _guideStep(
                    context: context,
                    stepNumber: '3',
                    title: 'Rotate Pipes',
                    description:
                        'Tap any pipe tile to rotate it 90° clockwise. Align each pipe with adjacent neighbors to expand the water circuit.',
                  ),
                  SizedBox(height: tokens.spacing.xl),
                  _guideStep(
                    context: context,
                    stepNumber: '4',
                    title: 'Completion',
                    description:
                        'The puzzle is completed when all pipes are connected to the source without any loose, leaking ends.',
                  ),
                  SizedBox(height: tokens.spacing.xxl),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(tokens.spacing.xl),
              child: TangibleButton(
                text: 'Got it',
                height: 44,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _guideStep({
    required BuildContext context,
    required String stepNumber,
    required String title,
    required String description,
  }) {
    final palette = context.palette;
    final tokens = context.tokens;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$stepNumber.',
          style: tokens.text.label.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: palette.textPrimary,
          ),
        ),
        SizedBox(width: tokens.spacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: tokens.text.label.copyWith(
                  color: palette.textPrimary,
                ),
              ),
              SizedBox(height: tokens.spacing.xs),
              Text(
                description,
                style: tokens.text.body.copyWith(
                  color: palette.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
