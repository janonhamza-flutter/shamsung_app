import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_colors.dart';

// ─── Section Title ────────────────────────────────────────────────────────────

class RequestSectionTitle extends StatelessWidget {
  final String title;
  const RequestSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// ─── Info Card ────────────────────────────────────────────────────────────────

class RequestInfoCard extends StatelessWidget {
  final List<Widget> children;
  const RequestInfoCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

// ─── Info Row ─────────────────────────────────────────────────────────────────

class RequestInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const RequestInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Card Divider ─────────────────────────────────────────────────────────────

class RequestCardDivider extends StatelessWidget {
  const RequestCardDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white12,
    );
  }
}

// ─── Estimate Card ────────────────────────────────────────────────────────────

class RequestEstimateCard extends StatelessWidget {
  final String? estimatedCost;
  final int? estimatedDays;

  const RequestEstimateCard({
    super.key,
    required this.estimatedCost,
    required this.estimatedDays,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          if (estimatedCost != null)
            Expanded(
              child: _EstimateItem(
                icon: Icons.attach_money_rounded,
                label: 'estimated_cost'.tr,
                value: "$estimatedCost ${'currency'.tr}",
                color: AppColors.green,
              ),
            ),
          if (estimatedCost != null && estimatedDays != null)
            Container(
              width: 1,
              height: 50,
              color: Colors.white12,
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
          if (estimatedDays != null)
            Expanded(
              child: _EstimateItem(
                icon: Icons.access_time_rounded,
                label: 'estimated_days'.tr,
                value: estimatedDays! > 1
                    ? '$estimatedDays ${'days'.tr}'
                    : '$estimatedDays ${'day'.tr}',
                color: Colors.blueAccent,
              ),
            ),
        ],
      ),
    );
  }
}

class _EstimateItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _EstimateItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}
