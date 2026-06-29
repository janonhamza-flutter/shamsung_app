import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
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
      backgroundColor: AppColors.darkBlue,
      appBar: _buildAppBar(),
      bottomNavigationBar: Obx(() {
        final status = controller.request.value?.status.toLowerCase() ?? '';
        if (status != 'waiting_customer_approval') {
          return const SizedBox.shrink();
        }
        return ApproveRejectBar(controller: controller);
      }),
      body: Obx(() {
        if (controller.isLoading.value) return _loadingState();
        if (controller.errorMessage.value.isNotEmpty) return _errorState();
        if (controller.request.value == null) return const SizedBox.shrink();
        return _buildContent(controller.request.value!);
      }),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.darkBlue,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        "Request Details",
        style: TextStyle(
          color: Colors.white,
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
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.redAccent,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.block_rounded,
                      color: Colors.redAccent,
                    ),
                    tooltip: "Cancel Request",
                    onPressed: () =>
                        CancelDialogWidget.show(Get.context!, controller),
                  ),
          );
        }),
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
          onPressed: controller.refresh,
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  // ── States ────────────────────────────────────────────────────────────────

  Widget _loadingState() => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: AppColors.green),
        SizedBox(height: 16),
        Text(
          "Loading details...",
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
      ],
    ),
  );

  Widget _errorState() => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.white24,
            size: 72,
          ),
          const SizedBox(height: 16),
          Text(
            controller.errorMessage.value,
            style: const TextStyle(color: Colors.white54, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: controller.refresh,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text("Retry", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ),
  );

  // ── Content ───────────────────────────────────────────────────────────────

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
            const RequestSectionTitle(title: "Rejection Reason"),
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
