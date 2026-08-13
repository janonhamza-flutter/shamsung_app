import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Not part of the fixed-navy hero (unused within home_page.dart's current
    // layout) — treated as adaptive body content, matching authTitle's size
    // and weight but sourcing color from the theme.
    return Text(
      title,
      style: TextStyle(
        color: context.colors.textPrimary,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
