import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../theme/app_palette.dart';

/// Full-screen loading widget using Lottie animation.
/// Use [LottieLoading] for page-level loading states.
/// Use [LottieLoading.small] for inline/button loading indicators.
class LottieLoading extends StatelessWidget {
  final double size;
  final String? label;

  /// Overrides the label color. Only needed when this widget sits on a
  /// surface that doesn't follow the current theme (e.g. the always-navy
  /// profile header) — everywhere else it defaults to [AppPalette.textSecondary].
  final Color? labelColor;

  const LottieLoading({super.key, this.size = 160, this.label, this.labelColor});

  /// Small inline version — replaces CircularProgressIndicator in buttons/rows
  const LottieLoading.small({super.key, this.size = 24, this.label, this.labelColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/animations/loading.json',
            width: size,
            height: size,
            fit: BoxFit.contain,
            repeat: true,
            delegates: LottieDelegates(
              values: [
                ValueDelegate.color(
                  const ['**'],
                  value: context.colors.accent,
                ),
              ],
            ),
          ),
          if (label != null) ...[
            const SizedBox(height: 8),
            Text(
              label!,
              style: TextStyle(
                color: labelColor ?? context.colors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
