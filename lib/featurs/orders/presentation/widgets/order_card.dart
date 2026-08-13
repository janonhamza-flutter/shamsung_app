import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../data/models/order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: context.colors.elevatedSurface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  color: context.colors.accent,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  order.orderNumber,
                  style: TextStyle(
                    color: context.colors.textPrimary,
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
                      Icon(
                        Icons.store_rounded,
                        color: context.colors.textSecondary,
                        size: 15,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        order.shop!.name,
                        style: TextStyle(
                          color: context.colors.textSecondary,
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
                        Icon(
                          Icons.circle,
                          color: context.colors.accent,
                          size: 6,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.accessory?.name ?? 'product'.tr,
                            style: TextStyle(
                              color: context.colors.textSecondary,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${item.quantity} × ${item.unitPrice.toStringAsFixed(2)} ${'currency'.tr}',
                          style: TextStyle(
                            color: context.colors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Divider(color: context.colors.divider, height: 20),

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
                          color: context.colors.textDisabled,
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          order.paymentMethod == 'cash_on_delivery'
                              ? 'payment_cash_on_delivery'.tr
                              : 'payment_pay_after_service'.tr,
                          style: TextStyle(
                            color: context.colors.textDisabled,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${order.totalAmount.toStringAsFixed(2)} ${'currency'.tr}',
                      style: TextStyle(
                        color: context.colors.accent,
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
