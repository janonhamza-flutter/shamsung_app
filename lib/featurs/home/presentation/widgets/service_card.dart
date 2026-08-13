import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_palette.dart';

class ServiceCard extends StatelessWidget {
  final IconData icon;

  final String title;

  const ServiceCard({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,

      decoration: BoxDecoration(
        color: context.colors.surface,

        borderRadius: BorderRadius.circular(AppSizes.radius),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(icon, size: 45, color: context.colors.accent),

          const SizedBox(height: 10),

          Text(title, style: TextStyle(color: context.colors.textPrimary)),
        ],
      ),
    );
  }
}
