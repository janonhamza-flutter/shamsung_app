import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_palette.dart';
import '../../data/models/maintenance_request_details_model.dart';
import '../controller/request_details_controller.dart';
import 'request_details_widgets.dart';

// ─── Device Section ───────────────────────────────────────────────────────────

class DeviceSection extends StatelessWidget {
  final MaintenanceRequestDetailsModel req;
  const DeviceSection({super.key, required this.req});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RequestSectionTitle(title: 'device_information'.tr),
        const SizedBox(height: AppSizes.space10),
        RequestInfoCard(
          children: [
            RequestInfoRow(
              icon: Icons.phone_android_outlined,
              label: 'device_model'.tr,
              value: req.deviceModel,
            ),
            const RequestCardDivider(),
            RequestInfoRow(
              icon: Icons.report_problem_outlined,
              label: 'problem_description'.tr,
              value: req.problemDescription,
            ),
          ],
        ),
        const SizedBox(height: AppSizes.space20),
      ],
    );
  }
}

// ─── Estimate Section ─────────────────────────────────────────────────────────

class EstimateSection extends StatelessWidget {
  final MaintenanceRequestDetailsModel req;
  final RequestDetailsController controller;

  const EstimateSection({
    super.key,
    required this.req,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final days =
          controller.requestParts.value?.estimatedDays ?? req.estimatedDays;
      if (req.estimatedCost == null && days == null)
        return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RequestSectionTitle(title: 'repair_estimate'.tr),
          const SizedBox(height: AppSizes.space10),
          RequestEstimateCard(
            estimatedCost: req.estimatedCost,
            estimatedDays: days,
          ),
          const SizedBox(height: AppSizes.space20),
        ],
      );
    });
  }
}

// ─── Shop Section ─────────────────────────────────────────────────────────────

class ShopSection extends StatelessWidget {
  final ShopModel shop;
  const ShopSection({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RequestSectionTitle(title: 'shop_information'.tr),
        const SizedBox(height: AppSizes.space10),
        RequestInfoCard(
          children: [
            RequestInfoRow(
              icon: Icons.store_outlined,
              label: 'shop_name'.tr,
              value: shop.name,
            ),
            if (shop.address.isNotEmpty) ...[
              const RequestCardDivider(),
              RequestInfoRow(
                icon: Icons.location_on_outlined,
                label: 'address'.tr,
                value: shop.address,
              ),
            ],
            if (shop.phone.isNotEmpty) ...[
              const RequestCardDivider(),
              RequestInfoRow(
                icon: Icons.phone_outlined,
                label: 'phone'.tr,
                value: shop.phone,
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSizes.space20),
      ],
    );
  }
}

// ─── Parts Section ────────────────────────────────────────────────────────────

class PartsSection extends StatelessWidget {
  final MaintenanceRequestDetailsModel req;
  final RequestDetailsController controller;

  const PartsSection({super.key, required this.req, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final partsData = controller.requestParts.value;
      final isPartsLoading = controller.isPartsLoading.value;
      final partsError = controller.partsErrorMessage.value;
      final parts = partsData?.parts ?? req.parts;
      final total = partsData?.totalPrice ?? req.totalPartsPrice;

      if (isPartsLoading) return const _PartsLoadingState();
      if (parts.isEmpty && partsError.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RequestSectionTitle(title: '${'parts'.tr} (${parts.length})'),
          const SizedBox(height: AppSizes.space10),
          if (partsError.isNotEmpty && parts.isEmpty)
            RequestPartsErrorBanner(
              message: partsError,
              onRetry: controller.getRequestParts,
            )
          else ...[
            RequestPartsCard(parts: parts),
            const SizedBox(height: AppSizes.space10),
            RequestPartsTotalRow(total: total),
          ],
          const SizedBox(height: AppSizes.space20),
        ],
      );
    });
  }
}

class _PartsLoadingState extends StatelessWidget {
  const _PartsLoadingState();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RequestSectionTitle(title: 'parts'.tr),
        const SizedBox(height: AppSizes.space10),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: CircularProgressIndicator(
              color: context.colors.accent,
              strokeWidth: 2,
            ),
          ),
        ),
        const SizedBox(height: AppSizes.space20),
      ],
    );
  }
}
