import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../theme/app_colors.dart';

/// Full-screen loading widget using Lottie animation.
/// Use [LottieLoading] for page-level loading states.
/// Use [LottieLoading.small] for inline/button loading indicators.
class LottieLoading extends StatelessWidget {
  final double size;
  final String? label;

  const LottieLoading({super.key, this.size = 160, this.label});

  /// Small inline version — replaces CircularProgressIndicator in buttons/rows
  const LottieLoading.small({super.key, this.size = 24, this.label});

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
                ValueDelegate.color(const ['**'], value: AppColors.green),
              ],
            ),
          ),
          if (label != null) ...[
            const SizedBox(height: 8),
            Text(
              label!,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}
