import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/route/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
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
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        automaticallyImplyLeading: false,
        title: Text(
          'store'.tr,
          style: const TextStyle(
            color: Colors.white,
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
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () => Get.toNamed(AppRoutes.cart),
                ),
                if (count > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        count > 99 ? '99+' : '$count',
                        style: const TextStyle(
                          color: Colors.white,
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
                  'store_header_title'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'store_header_sub'.tr,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
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
                        color: AppColors.green.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.green.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${'store_showing_from'.tr}: ${controller.filterShopName.value}',
                              style: const TextStyle(
                                color: AppColors.green,
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
                            child: const Icon(
                              Icons.close_rounded,
                              color: AppColors.green,
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
                style: const TextStyle(
                  color: Colors.white,
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
                color: AppColors.green,
                backgroundColor: AppColors.blue,
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
            const Icon(Icons.wifi_off_rounded, color: Colors.white54, size: 64),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: Text(
                'retry'.tr,
                style: const TextStyle(color: Colors.white),
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
          const Icon(
            Icons.inventory_2_outlined,
            color: Colors.white38,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'no_products'.tr,
            style: const TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
