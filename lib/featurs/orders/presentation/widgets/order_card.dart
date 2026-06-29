import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../data/models/order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF0D3880),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Order number
                Row(
                  children: [
                    const Icon(
                      Icons.receipt_long_rounded,
                      color: AppColors.green,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      order.orderNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                // Status badge
                _StatusBadge(status: order.status),
              ],
            ),
          ),

          // ── Body ──────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shop name
                if (order.shop != null) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.store_rounded,
                        color: Colors.white54,
                        size: 15,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        order.shop!.name,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],

                // Items list
                ...order.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          color: AppColors.green,
                          size: 6,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.accessory?.name ?? 'منتج',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${item.quantity} × ${item.unitPrice.toStringAsFixed(2)} SP',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(color: Colors.white12, height: 20),

                // Footer row: payment + total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Payment method
                    Row(
                      children: [
                        Icon(
                          order.paymentMethod == 'cash_on_delivery'
                              ? Icons.money_rounded
                              : Icons.credit_card_rounded,
                          color: Colors.white38,
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          order.paymentMethod == 'cash_on_delivery'
                              ? 'الدفع عند الاستلام'
                              : 'دفع إلكتروني',
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    // Total
                    Text(
                      '${order.totalAmount.toStringAsFixed(2)} SP',
                      style: const TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Status Badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _statusConfig(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config.color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, color: config.color, size: 12),
          const SizedBox(width: 4),
          Text(
            config.label,
            style: TextStyle(
              color: config.color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _statusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return _StatusConfig(
          label: 'قيد الانتظار',
          color: const Color(0xFFFFB300),
          icon: Icons.hourglass_empty_rounded,
        );
      case 'processing':
        return _StatusConfig(
          label: 'جاري المعالجة',
          color: const Color(0xFF42A5F5),
          icon: Icons.sync_rounded,
        );
      case 'completed':
        return _StatusConfig(
          label: 'مكتمل',
          color: AppColors.green,
          icon: Icons.check_circle_rounded,
        );
      case 'cancelled':
        return _StatusConfig(
          label: 'ملغى',
          color: const Color(0xFFEF5350),
          icon: Icons.cancel_rounded,
        );
      default:
        return _StatusConfig(
          label: status,
          color: Colors.white54,
          icon: Icons.info_outline_rounded,
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;
  final IconData icon;

  _StatusConfig({required this.label, required this.color, required this.icon});
}
