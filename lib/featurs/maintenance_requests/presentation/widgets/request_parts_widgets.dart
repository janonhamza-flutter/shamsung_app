import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_palette.dart';
import '../../data/models/maintenance_request_details_model.dart';
import 'request_info_widgets.dart';

// ─── Parts Card ───────────────────────────────────────────────────────────────

class RequestPartsCard extends StatelessWidget {
  final List<PartModel> parts;
  const RequestPartsCard({super.key, required this.parts});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: parts.asMap().entries.map((entry) {
          final isLast = entry.key == parts.length - 1;
          final part = entry.value;
          return Column(
            children: [
              _PartTile(part: part),
              if (!isLast) const RequestCardDivider(),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _PartTile extends StatelessWidget {
  final PartModel part;
  const _PartTile({required this.part});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.colors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.settings_outlined,
                  color: context.colors.accent,
                  size: 18,
                ),
              ),
              if (part.isRequired)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: context.colors.warning,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.priority_high,
                      color: context.colors.textOnPrimary,
                      size: 10,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  part.name,
                  style: TextStyle(color: context.colors.textPrimary, fontSize: 14),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      '${'qty'.tr}: ${part.quantity}',
                      style: TextStyle(
                        color: context.colors.textDisabled,
                        fontSize: 12,
                      ),
                    ),
                    if (part.isRequired) ...[
                      const SizedBox(width: 8),
                      _RequiredBadge(),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${part.price} ${'currency'.tr}",
                style: TextStyle(
                  color: context.colors.accent,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (part.quantity > 1)
                Text(
                  "= ${part.total.toStringAsFixed(2)} ${'currency'.tr}",
                  style: TextStyle(color: context.colors.textDisabled, fontSize: 11),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RequiredBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: context.colors.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: context.colors.warning.withValues(alpha: 0.4)),
      ),
      child: Text(
        'required'.tr,
        style: TextStyle(
          color: context.colors.warning,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── Parts Total Row ──────────────────────────────────────────────────────────

class RequestPartsTotalRow extends StatelessWidget {
  final double total;
  const RequestPartsTotalRow({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.colors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'total_parts_cost'.tr,
            style: TextStyle(
              color: context.colors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "${total.toStringAsFixed(2)} ${'currency'.tr}",
            style: TextStyle(
              color: context.colors.accent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Parts Error Banner ───────────────────────────────────────────────────────

class RequestPartsErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const RequestPartsErrorBanner({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: context.colors.warning,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: context.colors.warning, fontSize: 13),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'retry'.tr,
              style: TextStyle(color: context.colors.warning, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Rejection Card ───────────────────────────────────────────────────────────

class RequestRejectionCard extends StatelessWidget {
  final String reason;
  const RequestRejectionCard({super.key, required this.reason});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(color: context.colors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.cancel_outlined, color: context.colors.error, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              reason,
              style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
