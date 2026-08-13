import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../data/models/maintenance_request_details_model.dart';
import '../controller/request_details_controller.dart';
import '../widgets/approve_reject_bar_widget.dart';
import '../widgets/cancel_dialog_widget.dart';
import '../widgets/request_details_sections.dart';
import '../widgets/request_details_widgets.dart';

class RequestDetailsPage extends StatelessWidget {
  RequestDetailsPage({super.key});

  final RequestDetailsController controller = Get.put(
    RequestDetailsController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: _buildAppBar(context),
      bottomNavigationBar: Obx(() {
        final status = controller.request.value?.status.toLowerCase() ?? '';
        if (status != 'waiting_customer_approval')
          return const SizedBox.shrink();
        return ApproveRejectBar(controller: controller);
      }),
      body: Obx(() {
        if (controller.isLoading.value) return _loadingState(context);
        if (controller.errorMessage.value.isNotEmpty) {
          return _errorState(context);
        }
        if (controller.request.value == null) return const SizedBox.shrink();
        return _buildContent(controller.request.value!);
      }),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.colors.background,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: context.colors.textPrimary),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'request_details'.tr,
        style: TextStyle(
          color: context.colors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Obx(() {
          final status = controller.request.value?.status.toLowerCase() ?? '';
          if (status != 'pending') return const SizedBox.shrink();
          return Obx(
            () => controller.isCancelling.value
                ? Padding(
                    padding: const EdgeInsets.all(14),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: context.colors.error,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : IconButton(
                    icon: Icon(
                      Icons.block_rounded,
                      color: context.colors.error,
                    ),
                    tooltip: 'cancel_request'.tr,
                    onPressed: () =>
                        CancelDialogWidget.show(Get.context!, controller),
                  ),
          );
        }),
        IconButton(
          icon: Icon(Icons.refresh_rounded, color: context.colors.textSecondary),
          onPressed: controller.refresh,
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _loadingState(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/animations/loading.json',
          width: 160,
          height: 160,
          fit: BoxFit.contain,
          repeat: true,
          delegates: LottieDelegates(
            values: [
              ValueDelegate.color(const ['**'], value: context.colors.accent),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'loading_details'.tr,
          style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
        ),
      ],
    ),
  );

  Widget _errorState(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: context.colors.textDisabled,
            size: 72,
          ),
          const SizedBox(height: 16),
          Text(
            controller.errorMessage.value,
            style: TextStyle(color: context.colors.textSecondary, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: controller.refresh,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(Icons.refresh, color: context.colors.textOnPrimary),
            label: Text(
              'retry'.tr,
              style: TextStyle(color: context.colors.textOnPrimary),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildContent(MaintenanceRequestDetailsModel req) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RequestStatusBanner(deviceModel: req.deviceModel, status: req.status),
          const SizedBox(height: AppSizes.space20),
          RequestTrackingCard(trackingNumber: req.trackingNumber),
          const SizedBox(height: AppSizes.space20),
          DeviceSection(req: req),
          EstimateSection(req: req, controller: controller),
          if (req.shop != null) ShopSection(shop: req.shop!),
          PartsSection(req: req, controller: controller),
          if (req.rejectionReason != null &&
              req.rejectionReason!.isNotEmpty) ...[
            RequestSectionTitle(title: 'rejection_reason'.tr),
            const SizedBox(height: AppSizes.space10),
            RequestRejectionCard(reason: req.rejectionReason!),
            const SizedBox(height: AppSizes.space20),
          ],
          const SizedBox(height: AppSizes.space30),
        ],
      ),
    );
  }
}
