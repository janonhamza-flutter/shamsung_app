import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_palette.dart';
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
        backgroundColor: context.colors.background,
        bottomNavigationBar: const BottomNavBar(currentIndex: 2),

        // ── AppBar ─────────────────────────────────────────────────────────────
        appBar: AppBar(
          backgroundColor: context.colors.primary,
          automaticallyImplyLeading: false,
          title: Text(
            'my_deliveries'.tr,
            style: TextStyle(
              color: context.colors.textOnPrimary,
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
              decoration: BoxDecoration(
                color: context.colors.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'track_deliveries'.tr,
                    style: TextStyle(
                      color: context.colors.textOnPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'all_deliveries_here'.tr,
                    style: TextStyle(
                      color: context.colors.textOnPrimary.withValues(
                        alpha: 0.65,
                      ),
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
                    Icon(
                      Icons.local_shipping_rounded,
                      color: context.colors.accent,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$count ${'deliveries_count_label'.tr}',
                      style: TextStyle(
                        color: context.colors.textSecondary,
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
                  color: context.colors.accent,
                  backgroundColor: context.colors.surface,
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
            Icon(
              Icons.wifi_off_rounded,
              color: context.colors.textSecondary,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(
                Icons.refresh_rounded,
                color: context.colors.textOnPrimary,
              ),
              label: Text(
                'retry'.tr,
                style: TextStyle(color: context.colors.textOnPrimary),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.accent,
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
            Icon(
              Icons.local_shipping_outlined,
              color: context.colors.textDisabled,
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              'no_deliveries_yet'.tr,
              style: TextStyle(
                color: context.colors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'no_deliveries_hint'.tr,
              style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
