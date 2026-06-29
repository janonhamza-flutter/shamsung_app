import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../data/models/maintenance_request_details_model.dart';
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
    final color = RequestStatusHelpers.color(status);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue, color.withValues(alpha: 0.18)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
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
                  style: const TextStyle(
                    color: Colors.white,
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
    final color = RequestStatusHelpers.color(status);
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
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.green.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.qr_code_2_rounded, color: AppColors.green, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tracking Number",
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 3),
                Text(
                  trackingNumber,
                  style: const TextStyle(
                    color: Colors.white,
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
                "Copied",
                "Tracking number copied",
                backgroundColor: AppColors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(16),
              );
            },
            icon: const Icon(
              Icons.copy_rounded,
              color: Colors.white54,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

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
                label: "Estimated Cost",
                value: "\$$estimatedCost",
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
                label: "Estimated Days",
                value: "$estimatedDays day${estimatedDays! > 1 ? 's' : ''}",
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

// ─── Parts Card ───────────────────────────────────────────────────────────────

class RequestPartsCard extends StatelessWidget {
  final List<PartModel> parts;

  const RequestPartsCard({super.key, required this.parts});

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
                  color: AppColors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.settings_outlined,
                  color: AppColors.green,
                  size: 18,
                ),
              ),
              if (part.isRequired)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.priority_high,
                      color: Colors.white,
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
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      "Qty: ${part.quantity}",
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                    if (part.isRequired) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.orange.withValues(alpha: 0.4),
                          ),
                        ),
                        child: const Text(
                          "Required",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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
                "\$${part.price}",
                style: const TextStyle(
                  color: AppColors.green,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (part.quantity > 1)
                Text(
                  "= \$${part.total.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
            ],
          ),
        ],
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
        color: AppColors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Total Parts Cost",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "\$${total.toStringAsFixed(2)}",
            style: const TextStyle(
              color: AppColors.green,
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
        color: Colors.orange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.orange, fontSize: 13),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text(
              "Retry",
              style: TextStyle(color: Colors.orange, fontSize: 12),
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
        color: Colors.redAccent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              reason,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
