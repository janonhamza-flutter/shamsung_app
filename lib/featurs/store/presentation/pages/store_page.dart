import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/route/app_routes.dart';
import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/widgets/lottie_loading.dart';
import '../controllers/store_controller.dart';
import '../widgets/accessory_card.dart';
import '../widgets/store_search_bar.dart';

class StorePage extends StatelessWidget {
  StorePage({super.key});

  final StoreController controller = Get.find<StoreController>();

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    if (args is Map) {
      controller.applyShopFilter(
        shopId: args['shopId'] as int?,
        shopName: args['shopName'] as String?,
      );
    } else {
      controller.applyShopFilter();
    }

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.primary,
        automaticallyImplyLeading: false,
        title: Text(
          'store'.tr,
          style: TextStyle(
            color: context.colors.textOnPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Obx(() {
            final count = controller.cartCount;
            return Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: context.colors.textOnPrimary,
                  ),
                  onPressed: () => Get.toNamed(AppRoutes.cart),
                ),
                if (count > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.colors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        count > 99 ? '99+' : '$count',
                        style: TextStyle(
                          color: context.colors.textOnPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header banner ──────────────────────────────────────────
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
                  'store_header_title'.tr,
                  style: TextStyle(
                    color: context.colors.textOnPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'store_header_sub'.tr,
                  style: TextStyle(
                    color: context.colors.textOnPrimary.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
                // Branch filter banner
                Obx(() {
                  if (controller.filterShopId.value == null) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: context.colors.accent.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: context.colors.accent,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${'store_showing_from'.tr}: ${controller.filterShopName.value}',
                              style: TextStyle(
                                color: context.colors.accent,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.filterShopId.value = null;
                              controller.filterShopName.value = '';
                            },
                            child: Icon(
                              Icons.close_rounded,
                              color: context.colors.accent,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 14),
                StoreSearchBar(onChanged: controller.updateSearch),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Products count label ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(() {
              final count = controller.filteredAccessories.length;
              return Text(
                '${'products'.tr} ($count)',
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              );
            }),
          ),

          const SizedBox(height: 12),

          // ── Content ────────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return LottieLoading(label: 'loading_products'.tr);
              }

              if (controller.errorMessage.value.isNotEmpty &&
                  controller.accessories.isEmpty) {
                return _ErrorView(
                  message: controller.errorMessage.value,
                  onRetry: controller.fetchAccessories,
                );
              }

              if (controller.filteredAccessories.isEmpty) {
                return const _EmptyView();
              }

              return RefreshIndicator(
                color: context.colors.accent,
                backgroundColor: context.colors.surface,
                onRefresh: controller.fetchAccessories,
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: controller.filteredAccessories.length,
                  itemBuilder: (context, index) {
                    final item = controller.filteredAccessories[index];
                    return Obx(
                      () => AccessoryCard(
                        accessory: item,
                        isAdding: controller.isAddingToCart(item.id),
                        onTap: () => Get.toNamed(
                          AppRoutes.accessoryDetails,
                          arguments: item,
                        ),
                        onAddToCart: () => controller.addToCart(item),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

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
          mainAxisAlignment: MainAxisAlignment.center,
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
              style: TextStyle(color: context.colors.textSecondary, fontSize: 15),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.accent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
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
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            color: context.colors.textDisabled,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'no_products'.tr,
            style: TextStyle(color: context.colors.textSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
