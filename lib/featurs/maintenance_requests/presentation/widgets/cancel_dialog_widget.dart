import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_palette.dart';
import '../controller/request_details_controller.dart';

/// Confirmation dialog for cancelling a maintenance request.
class CancelDialogWidget extends StatelessWidget {
  final RequestDetailsController controller;

  const CancelDialogWidget({super.key, required this.controller});

  static void show(BuildContext context, RequestDetailsController controller) {
    showDialog(
      context: context,
      builder: (_) => CancelDialogWidget(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: context.colors.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colors.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.block_rounded,
                color: context.colors.error,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'cancel_request_title'.tr,
              style: TextStyle(
                color: context.colors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'cancel_request_body'.tr,
              style: TextStyle(
                color: context.colors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: context.colors.border),
                      ),
                    ),
                    child: Text(
                      'keep_it'.tr,
                      style: TextStyle(
                        color: context.colors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: controller.isCancelling.value
                          ? null
                          : () async {
                              Get.back();
                              await controller.cancelRequest();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.error,
                        disabledBackgroundColor: context.colors.error.withValues(
                          alpha: 0.4,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'cancel_request'.tr,
                        style: TextStyle(
                          color: context.colors.textOnPrimary,
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
      ),
    );
  }
}
