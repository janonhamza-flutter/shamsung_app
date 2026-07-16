import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                            item.accessory?.name ?? 'product'.tr,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${item.quantity} × ${item.unitPrice.toStringAsFixed(2)} ${'currency'.tr}',
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
                              ? 'payment_cash_on_delivery'.tr
                              : 'payment_pay_after_service'.tr,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${order.totalAmount.toStringAsFixed(2)} ${'currency'.tr}',
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
