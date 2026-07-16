import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsoung/core/route/app_routes.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/lottie_loading.dart';
import '../controllers/orders_controller.dart';
import '../widgets/order_card.dart';

class MyOrdersPage extends StatelessWidget {
  MyOrdersPage({super.key});

  final OrdersController controller = Get.find<OrdersController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        title: Text(
          'my_orders'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Pull-to-refresh button
          Obx(
            () => controller.isLoading.value
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                    ),
                    onPressed: controller.fetchMyOrders,
                    tooltip: 'refresh'.tr,
                  ),
          ),
        ],
      ),
      body: Obx(() {
        // ── Loading state ────────────────────────────────────────────────
        if (controller.isLoading.value) {
          return LottieLoading(label: 'loading_orders'.tr);
        }

        // ── Error state ──────────────────────────────────────────────────
        if (controller.errorMessage.value.isNotEmpty &&
            controller.orders.isEmpty) {
          return _ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.fetchMyOrders,
          );
        }

        // ── Empty state ──────────────────────────────────────────────────
        if (controller.orders.isEmpty) {
          return _EmptyView(onGoToStore: () => Get.toNamed(AppRoutes.store));
        }

        // ── Orders list ──────────────────────────────────────────────────
        return RefreshIndicator(
          color: AppColors.green,
          backgroundColor: AppColors.blue,
          onRefresh: controller.fetchMyOrders,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: controller.orders.length,
            itemBuilder: (_, index) =>
                OrderCard(order: controller.orders[index]),
          ),
        );
      }),
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
  final VoidCallback onGoToStore;

  const _EmptyView({required this.onGoToStore});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              color: Colors.white24,
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              'no_orders_yet'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'no_orders_hint'.tr,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onGoToStore,
              icon: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
              ),
              label: Text(
                'browse_store'.tr,
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
