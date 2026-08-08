import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/exit_scope.dart';
import '../../../../../core/widgets/lottie_loading.dart';
import '../../../home/presentation/widgets/bottom_nav_bar.dart';
import '../controllers/deliveries_controller.dart';
import '../widgets/delivery_card.dart';

class MyDeliveriesPage extends StatelessWidget {
  MyDeliveriesPage({super.key});

  final DeliveriesController controller = Get.find<DeliveriesController>();

  @override
  Widget build(BuildContext context) {
    return ExitScope(
      child: Scaffold(
        backgroundColor: AppColors.darkBlue,
        bottomNavigationBar: const BottomNavBar(currentIndex: 2),

        // ── AppBar ─────────────────────────────────────────────────────────────
        appBar: AppBar(
          backgroundColor: AppColors.blue,
          automaticallyImplyLeading: false,
          title: Text(
            'my_deliveries'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: const [],
        ),

        // ── Body ───────────────────────────────────────────────────────────────
        body: Column(
          children: [
            // Header banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: const BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'track_deliveries'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'all_deliveries_here'.tr,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Count label
            Obx(() {
              if (controller.isLoading.value || controller.deliveries.isEmpty) {
                return const SizedBox.shrink();
              }
              final count = controller.deliveries.length;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_shipping_rounded,
                      color: AppColors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$count ${'deliveries_count_label'.tr}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 10),

            // Content
            Expanded(
              child: Obx(() {
                // Loading
                if (controller.isLoading.value) {
                  return LottieLoading(label: 'loading_deliveries'.tr);
                }

                // Error
                if (controller.errorMessage.value.isNotEmpty &&
                    controller.deliveries.isEmpty) {
                  return _ErrorView(
                    message: controller.errorMessage.value,
                    onRetry: controller.fetchMyDeliveries,
                  );
                }

                // Empty
                if (controller.deliveries.isEmpty) {
                  return const _EmptyView();
                }

                // List
                return RefreshIndicator(
                  color: AppColors.green,
                  backgroundColor: AppColors.blue,
                  onRefresh: controller.fetchMyDeliveries,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    itemCount: controller.deliveries.length,
                    itemBuilder: (_, index) =>
                        DeliveryCard(delivery: controller.deliveries[index]),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error View ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: Colors.white38, size: 64),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: Text(
                'retry'.tr,
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty View ────────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.local_shipping_outlined,
              color: Colors.white24,
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              'no_deliveries_yet'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'no_deliveries_hint'.tr,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
