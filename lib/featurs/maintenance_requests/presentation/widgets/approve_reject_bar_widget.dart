import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../controller/request_details_controller.dart';
import 'approve_sheet_widget.dart';
import 'reject_dialog_widget.dart';

/// Bottom action bar shown when status == waiting_customer_approval.
class ApproveRejectBar extends StatelessWidget {
  final RequestDetailsController controller;

  const ApproveRejectBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: AppColors.blue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _InfoBanner(),
          const SizedBox(height: 12),
          Row(
            children: [
              // Reject
              Expanded(
                child: SizedBox(
                  height: AppSizes.buttonHeight,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        RejectDialogWidget.show(context, controller),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.redAccent,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radius),
                      ),
                    ),
                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                    label: Text(
                      'reject'.tr,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Approve
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: AppSizes.buttonHeight,
                  child: ElevatedButton.icon(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) =>
                          ApproveSheetWidget(controller: controller),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radius),
                      ),
                      elevation: 4,
                    ),
                    icon: const Icon(
                      Icons.check_circle_outline_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: Text(
                      'review_and_approve'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.amber, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'technician_waiting_approval'.tr,
              style: const TextStyle(color: Colors.amber, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
