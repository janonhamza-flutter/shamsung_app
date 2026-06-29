import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/route/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../data/models/maintenance_request_model.dart';
import 'request_status_helpers.dart';

/// Card shown in the MyRequestsPage list.
class RequestCardWidget extends StatelessWidget {
  final MaintenanceRequestModel request;

  const RequestCardWidget({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final statusColor = RequestStatusHelpers.color(request.status);

    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.requestDetails, arguments: request.id),
      borderRadius: BorderRadius.circular(AppSizes.radius),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(AppSizes.radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Device icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.phone_android_rounded,
                color: statusColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.deviceModel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  _InfoRow(icon: Icons.tag, text: request.trackingNumber),
                  if (request.shop != null)
                    _InfoRow(
                      icon: Icons.store_outlined,
                      text: request.shop!.name,
                    ),
                  const SizedBox(height: 8),
                  _StatusChip(status: request.status),
                ],
              ),
            ),

            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white38,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white38, size: 13),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = RequestStatusHelpers.color(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Text(
        RequestStatusHelpers.label(status),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
