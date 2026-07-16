import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/map_picker_page.dart';
import '../../data/models/maintenance_request_details_model.dart';
import '../controller/request_details_controller.dart';

/// Bottom sheet for reviewing and approving a maintenance request.
class ApproveSheetWidget extends StatefulWidget {
  final RequestDetailsController controller;

  const ApproveSheetWidget({super.key, required this.controller});

  @override
  State<ApproveSheetWidget> createState() => _ApproveSheetWidgetState();
}

class _ApproveSheetWidgetState extends State<ApproveSheetWidget> {
  double? _latitude;
  String? _locationName;

  Future<void> _openMapPicker() async {
    final result = await Get.to<MapPickerResult>(() => const MapPickerPage());
    if (result != null) {
      setState(() {
        _latitude = result.latitude;
        _locationName = result.locationName;
      });
      widget.controller.approveLatitude = result.latitude;
      widget.controller.approveLongitude = result.longitude;
    }
  }

  @override
  Widget build(BuildContext context) {
    final parts =
        widget.controller.requestParts.value?.parts ??
        widget.controller.request.value?.parts ??
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'review_and_approve'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'approve_sheet_sub'.tr,
                            style: const TextStyle(
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
                    _PartsSection(controller: widget.controller, parts: parts),
                    const SizedBox(height: 20),
                    _PaymentSection(controller: widget.controller),
                    const SizedBox(height: 20),
                    _ApproveLocationCard(
                      locationName: _locationName,
                      isSelected: _latitude != null,
                      onTap: _openMapPicker,
                    ),
                    const SizedBox(height: 20),
                    _TotalRow(controller: widget.controller),
                    const SizedBox(height: 24),
                    _ConfirmButton(
                      controller: widget.controller,
                      locationSelected: _latitude != null,
                    ),
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
        Text(
          'select_parts'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'required_parts_note'.tr,
          style: const TextStyle(color: Colors.white38, fontSize: 12),
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
                                child: Text(
                                  'required'.tr,
                                  style: const TextStyle(
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
                          '${'qty'.tr}: ${part.quantity}  •  ${part.price} ${'currency'.tr}',
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
                    '${part.total.toStringAsFixed(2)} ${'currency'.tr}',
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
        Text(
          'payment_method'.tr,
          style: const TextStyle(
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
                  if (v != null) controller.selectedPaymentMethod.value = v;
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
            Text(
              'selected_total'.tr,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${total.toStringAsFixed(2)} ${'currency'.tr}',
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

// ── Approve Location Card ─────────────────────────────────────────────────────

class _ApproveLocationCard extends StatelessWidget {
  final String? locationName;
  final bool isSelected;
  final VoidCallback onTap;

  const _ApproveLocationCard({
    required this.locationName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'pickup_location'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? AppColors.green.withValues(alpha: 0.4)
                    : Colors.white24,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.green.withValues(alpha: 0.15)
                        : Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isSelected
                        ? Icons.location_on_rounded
                        : Icons.add_location_alt_rounded,
                    color: isSelected ? AppColors.green : Colors.white54,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isSelected
                            ? 'location_selected'.tr
                            : 'set_pickup_location'.tr,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isSelected &&
                          locationName != null &&
                          locationName!.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          locationName!,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.55),
                            fontSize: 11,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  isSelected
                      ? Icons.edit_location_alt_rounded
                      : Icons.arrow_forward_ios_rounded,
                  color: isSelected ? AppColors.green : Colors.white38,
                  size: isSelected ? 20 : 14,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Confirm button ────────────────────────────────────────────────────────────

class _ConfirmButton extends StatelessWidget {
  final RequestDetailsController controller;
  final bool locationSelected;

  const _ConfirmButton({
    required this.controller,
    required this.locationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: AppSizes.buttonHeight,
        child: ElevatedButton(
          onPressed: (controller.isApproving.value || !locationSelected)
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
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      locationSelected
                          ? 'confirm_approval'.tr
                          : 'select_location_first'.tr,
                      style: const TextStyle(
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
