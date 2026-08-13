import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsoung/core/route/app_routes.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/widgets/lottie_loading.dart';
import '../controllers/orders_controller.dart';
import '../widgets/order_card.dart';

class MyOrdersPage extends StatelessWidget {
  MyOrdersPage({super.key});

  final OrdersController controller = Get.find<OrdersController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.primary,
        title: Text(
          'my_orders'.tr,
          style: TextStyle(
            color: context.colors.textOnPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: context.colors.textOnPrimary),
        actions: const [],
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
          color: context.colors.accent,
          backgroundColor: context.colors.surface,
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
            Icon(
              Icons.inventory_2_outlined,
              color: context.colors.textDisabled,
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              'no_orders_yet'.tr,
              style: TextStyle(
                color: context.colors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'no_orders_hint'.tr,
              style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onGoToStore,
              icon: Icon(
                Icons.shopping_bag_outlined,
                color: context.colors.textOnPrimary,
              ),
              label: Text(
                'browse_store'.tr,
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
