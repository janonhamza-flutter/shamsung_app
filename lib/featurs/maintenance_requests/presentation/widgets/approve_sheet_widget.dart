import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../data/models/maintenance_request_details_model.dart';
import '../controller/request_details_controller.dart';

/// Bottom sheet for reviewing and approving a maintenance request.
/// Shows selectable parts list + payment method picker.
class ApproveSheetWidget extends StatelessWidget {
  final RequestDetailsController controller;

  const ApproveSheetWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final parts =
        controller.requestParts.value?.parts ??
        controller.request.value?.parts ??
        [];

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.darkBlue,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.green,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Review & Approve",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Select parts and choose payment method",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white12, height: 1),
              // Body
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    _PartsSection(controller: controller, parts: parts),
                    const SizedBox(height: 20),
                    _PaymentSection(controller: controller),
                    const SizedBox(height: 20),
                    _TotalRow(controller: controller),
                    const SizedBox(height: 24),
                    _ConfirmButton(controller: controller),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Parts section ─────────────────────────────────────────────────────────────

class _PartsSection extends StatelessWidget {
  final RequestDetailsController controller;
  final List<PartModel> parts;

  const _PartsSection({required this.controller, required this.parts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Parts",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Required parts are mandatory and cannot be deselected",
          style: TextStyle(color: Colors.white38, fontSize: 12),
        ),
        const SizedBox(height: 12),
        ...parts.map((p) => _PartTile(controller: controller, part: p)),
      ],
    );
  }
}

class _PartTile extends StatelessWidget {
  final RequestDetailsController controller;
  final PartModel part;

  const _PartTile({required this.controller, required this.part});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedPartIds.contains(part.id);
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.green.withValues(alpha: 0.08)
              : AppColors.blue,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.green.withValues(alpha: 0.4)
                : Colors.white12,
            width: 1.2,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: part.isRequired ? null : () => controller.togglePart(part),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Checkbox
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.green : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: part.isRequired
                            ? Colors.orange
                            : (isSelected ? AppColors.green : Colors.white38),
                        width: 1.5,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 14)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                part.name,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white70,
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (part.isRequired)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Colors.orange.withValues(alpha: 0.4),
                                  ),
                                ),
                                child: const Text(
                                  "Required",
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Qty: ${part.quantity}  •  \$${part.price}",
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "\$${part.total.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: isSelected ? AppColors.green : Colors.white38,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

// ── Payment section ───────────────────────────────────────────────────────────

class _PaymentSection extends StatelessWidget {
  final RequestDetailsController controller;
  const _PaymentSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Payment Method",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...controller.paymentMethods.map(
          (method) => Obx(() {
            final isSelected =
                controller.selectedPaymentMethod.value == method["value"];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.green.withValues(alpha: 0.08)
                    : AppColors.blue,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppColors.green.withValues(alpha: 0.4)
                      : Colors.white12,
                  width: 1.2,
                ),
              ),
              child: RadioListTile<String>(
                value: method["value"]!,
                groupValue: controller.selectedPaymentMethod.value,
                onChanged: (v) {
                  if (v != null) {
                    controller.selectedPaymentMethod.value = v;
                  }
                },
                title: Text(
                  method["label"]!,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 14,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                activeColor: AppColors.green,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ── Total row ─────────────────────────────────────────────────────────────────

class _TotalRow extends StatelessWidget {
  final RequestDetailsController controller;
  const _TotalRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final total = controller.selectedTotal;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Selected Total",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "\$${total.toStringAsFixed(2)}",
              style: const TextStyle(
                color: AppColors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ── Confirm button ────────────────────────────────────────────────────────────

class _ConfirmButton extends StatelessWidget {
  final RequestDetailsController controller;
  const _ConfirmButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: AppSizes.buttonHeight,
        child: ElevatedButton(
          onPressed: controller.isApproving.value
              ? null
              : controller.approveRequest,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            disabledBackgroundColor: AppColors.green.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radius),
            ),
            elevation: 4,
          ),
          child: controller.isApproving.value
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Confirm Approval",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
