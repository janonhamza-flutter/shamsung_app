import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_palette.dart';

class OrderCard extends StatelessWidget {
  final String phoneName;

  final String repairType;

  final String status;

  const OrderCard({
    super.key,

    required this.phoneName,

    required this.repairType,

    required this.status,
    required String image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: context.colors.surface,

        borderRadius: BorderRadius.circular(AppSizes.radius),
      ),

      child: Row(
        children: [
          /// PHONE ICON
          Container(
            width: 70,
            height: 70,

            decoration: BoxDecoration(
              color: context.colors.surfaceVariant,

              borderRadius: BorderRadius.circular(15),
            ),

            child: Icon(
              Icons.phone_iphone,
              size: 35,
              color: context.colors.textPrimary,
            ),
          ),

          const SizedBox(width: 15),

          /// ORDER INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  phoneName,
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  repairType,
                  style: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          /// STATUS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),

            decoration: BoxDecoration(
              color: _getStatusColor(context),

              borderRadius: BorderRadius.circular(20),
            ),

            child: Text(
              status,

              style: TextStyle(
                color: context.colors.textOnPrimary,

                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// =========================
  /// STATUS COLOR
  /// =========================

  Color _getStatusColor(BuildContext context) {
    switch (status) {
      case "Completed":
        return context.colors.success;

      case "Pending":
        return context.colors.warning;

      case "Repairing":
        return context.colors.info;

      default:
        return context.colors.textDisabled;
    }
  }
}
