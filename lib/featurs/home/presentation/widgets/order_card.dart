import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

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
        color: AppColors.blue,

        borderRadius: BorderRadius.circular(AppSizes.radius),
      ),

      child: Row(
        children: [
          /// PHONE ICON
          Container(
            width: 70,
            height: 70,

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(15),
            ),

            child: const Icon(Icons.phone_iphone, size: 35),
          ),

          const SizedBox(width: 15),

          /// ORDER INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(phoneName, style: AppTextStyles.body),

                const SizedBox(height: 5),

                Text(repairType, style: AppTextStyles.body),
              ],
            ),
          ),

          /// STATUS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),

            decoration: BoxDecoration(
              color: _getStatusColor(),

              borderRadius: BorderRadius.circular(20),
            ),

            child: Text(
              status,

              style: const TextStyle(
                color: Colors.white,

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

  Color _getStatusColor() {
    switch (status) {
      case "Completed":
        return Colors.green;

      case "Pending":
        return Colors.orange;

      case "Repairing":
        return Colors.blue;

      default:
        return Colors.grey;
    }
  }
}
