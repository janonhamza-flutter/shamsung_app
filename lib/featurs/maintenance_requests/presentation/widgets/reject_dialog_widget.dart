import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../controller/request_details_controller.dart';

/// Dialog for rejecting a maintenance request.
class RejectDialogWidget extends StatelessWidget {
  final RequestDetailsController controller;

  const RejectDialogWidget({super.key, required this.controller});

  static void show(BuildContext context, RequestDetailsController controller) {
    controller.rejectionReasonController.clear();
    showDialog(
      context: context,
      builder: (_) => RejectDialogWidget(controller: controller),
    );
  }

  List<String> get _presets => [
    'reject_preset_1'.tr,
    'reject_preset_2'.tr,
    'reject_preset_3'.tr,
    'reject_preset_4'.tr,
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.darkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Colors.redAccent.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DialogHeader(),
            const SizedBox(height: 20),
            Text(
              'quick_reasons'.tr,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 8),
            _PresetChips(
              presets: _presets,
              onSelect: (p) => controller.rejectionReasonController.text = p,
            ),
            const SizedBox(height: 16),
            _ReasonTextField(controller: controller.rejectionReasonController),
            const SizedBox(height: 20),
            _ActionButtons(controller: controller),
          ],
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.cancel_outlined,
            color: Colors.redAccent,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'reject_request'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'reject_request_sub'.tr,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PresetChips extends StatelessWidget {
  final List<String> presets;
  final ValueChanged<String> onSelect;

  const _PresetChips({required this.presets, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: presets
          .map(
            (p) => InkWell(
              onTap: () => onSelect(p),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.redAccent.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  p,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ReasonTextField extends StatelessWidget {
  final TextEditingController controller;
  const _ReasonTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
      ),
      child: TextField(
        controller: controller,
        maxLines: 3,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'write_own_reason'.tr,
          hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(14),
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final RequestDetailsController controller;
  const _ActionButtons({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'cancel'.tr,
              style: const TextStyle(color: Colors.white54),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isRejecting.value
                  ? null
                  : controller.rejectRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                disabledBackgroundColor: Colors.redAccent.withValues(
                  alpha: 0.4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: controller.isRejecting.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'confirm_reject'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
