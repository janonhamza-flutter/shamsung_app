import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../data/models/delivery_model.dart';

class DeliveryCard extends StatelessWidget {
  final DeliveryModel delivery;

  const DeliveryCard({super.key, required this.delivery});

  Color _statusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return context.colors.success;
      case 'accepted':
        return context.colors.info;
      case 'pending':
        return context.colors.warning;
      case 'cancelled':
        return context.colors.error;
      default:
        return context.colors.textSecondary;
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return 'delivery_status_delivered'.tr;
      case 'accepted':
        return 'delivery_status_accepted'.tr;
      case 'pending':
        return 'delivery_status_pending'.tr;
      case 'cancelled':
        return 'delivery_status_cancelled'.tr;
      default:
        return status.replaceAll('_', ' ');
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Icons.check_circle_rounded;
      case 'accepted':
        return Icons.local_shipping_rounded;
      case 'pending':
        return Icons.hourglass_top_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  String _typeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'device_pickup':
        return 'delivery_type_pickup'.tr;
      case 'accessory_delivery':
        return 'delivery_type_accessory'.tr;
      case 'device_delivery':
        return 'delivery_type_device'.tr;
      default:
        return type.replaceAll('_', ' ');
    }
  }

  IconData _typeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'device_pickup':
        return Icons.smartphone_rounded;
      case 'accessory_delivery':
        return Icons.headphones_rounded;
      case 'device_delivery':
        return Icons.devices_rounded;
      default:
        return Icons.inventory_2_rounded;
    }
  }

  String _formatDate(String raw) {
    try {
      final cleaned = raw.trim().replaceAllMapped(
        RegExp(r'(\.\d{3})\d+'),
        (m) => m.group(1)!,
      );
      final dt = DateTime.parse(cleaned).toUtc();
      final date =
          '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
      final time =
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      return '$date  $time';
    } catch (_) {
      return raw
          .replaceAll('T', '  ')
          .replaceAll('Z', '')
          .replaceAllMapped(RegExp(r'\.\d+'), (_) => '');
    }
  }

  String _formatCreatedAt(String raw) {
    try {
      final cleaned = raw.trim().replaceAllMapped(
        RegExp(r'(\.\d{3})\d+'),
        (m) => m.group(1)!,
      );
      final dt = DateTime.parse(cleaned).toUtc().add(const Duration(hours: 3));
      final date =
          '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
      final time =
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      return '$date  $time';
    } catch (_) {
      return raw
          .replaceAll('T', '  ')
          .replaceAll('Z', '')
          .replaceAllMapped(RegExp(r'\.\d+'), (_) => '');
    }
  }

  String _formatEstimatedTime(String raw) {
    try {
      if (raw.contains('T') || raw.contains('-')) return _formatDate(raw);
      final parts = raw.split(':');
      if (parts.length >= 2) {
        return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
      }
      return raw;
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(context, delivery.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: context.colors.isDark
            ? null
            : Border.all(color: context.colors.border),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _typeIcon(delivery.type),
                    color: context.colors.textSecondary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _typeLabel(delivery.type),
                        style: TextStyle(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${'delivery_number'.tr}: #${delivery.id}',
                        style: TextStyle(
                          color: context.colors.textDisabled,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _statusIcon(delivery.status),
                        color: statusColor,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _statusLabel(delivery.status),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            Divider(color: context.colors.divider, height: 1),
            const SizedBox(height: 12),

            // ── Info rows ─────────────────────────────────────────────────
            if (delivery.shop != null && delivery.shop!.name.isNotEmpty)
              _InfoRow(
                icon: Icons.storefront_rounded,
                label: 'delivery_branch'.tr,
                value: delivery.shop!.name,
              ),

            _InfoRow(
              icon: Icons.person_pin_circle_rounded,
              label: 'delivery_worker'.tr,
              value:
                  delivery.deliveryWorker != null &&
                      delivery.deliveryWorker!.fullName.isNotEmpty
                  ? delivery.deliveryWorker!.fullName
                  : 'not_assigned_yet'.tr,
            ),

            if (delivery.paymentMethod.isNotEmpty)
              _InfoRow(
                icon: Icons.payments_rounded,
                label: 'payment_method'.tr,
                value: delivery.paymentMethod.replaceAll('_', ' '),
              ),

            if ((delivery.address ?? '').isNotEmpty)
              _InfoRow(
                icon: Icons.location_on_rounded,
                label: 'address'.tr,
                value: delivery.address!,
              ),

            if ((delivery.notes ?? '').isNotEmpty)
              _InfoRow(
                icon: Icons.note_alt_rounded,
                label: 'notes'.tr,
                value: delivery.notes!,
              ),

            _InfoRow(
              icon: Icons.schedule_rounded,
              label: 'estimated_time'.tr,
              value:
                  (delivery.estimatedTime != null &&
                      delivery.estimatedTime!.isNotEmpty &&
                      delivery.estimatedTime != 'null')
                  ? _formatEstimatedTime(delivery.estimatedTime!)
                  : 'not_set_yet'.tr,
            ),

            _InfoRow(
              icon: Icons.calendar_today_rounded,
              label: 'created_at'.tr,
              value: _formatCreatedAt(delivery.createdAt),
            ),
            if ((delivery.confirmationCode ?? '').isNotEmpty)
              _InfoRow(
                icon: Icons.verified_rounded,
                label: 'confirmation_code'.tr,
                value: delivery.confirmationCode!,
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: context.colors.textDisabled, size: 15),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(color: context.colors.textDisabled, fontSize: 13),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: context.colors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
