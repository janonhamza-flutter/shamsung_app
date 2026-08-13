import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_palette.dart';
import 'request_status_helpers.dart';

// ─── Status Banner ────────────────────────────────────────────────────────────

class RequestStatusBanner extends StatelessWidget {
  final String deviceModel;
  final String status;

  const RequestStatusBanner({
    super.key,
    required this.deviceModel,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final color = RequestStatusHelpers.color(context, status);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colors.surface, color.withValues(alpha: 0.18)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              RequestStatusHelpers.icon(status),
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviceModel,
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                RequestStatusChip(
                  status: status,
                  label: RequestStatusHelpers.detailLabel(status),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Status Chip ──────────────────────────────────────────────────────────────

class RequestStatusChip extends StatelessWidget {
  final String status;
  final String? label;

  const RequestStatusChip({super.key, required this.status, this.label});

  @override
  Widget build(BuildContext context) {
    final color = RequestStatusHelpers.color(context, status);
    final text = label ?? RequestStatusHelpers.detailLabel(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ─── Tracking Card ────────────────────────────────────────────────────────────

class RequestTrackingCard extends StatelessWidget {
  final String trackingNumber;

  const RequestTrackingCard({super.key, required this.trackingNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colors.accent.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'tracking_number'.tr,
                  style: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  trackingNumber,
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: trackingNumber));
              Get.snackbar(
                'copied'.tr,
                'tracking_number_copied'.tr,
                backgroundColor: context.colors.accent,
                colorText: context.colors.textOnPrimary,
                duration: const Duration(seconds: 2),
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(16),
              );
            },
            icon: Icon(
              Icons.copy_rounded,
              color: context.colors.textSecondary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
