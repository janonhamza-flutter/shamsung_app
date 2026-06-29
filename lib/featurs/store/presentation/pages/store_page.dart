import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsoung/core/services/storage_service.dart';

import '../../../../../core/route/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../home/presentation/widgets/bottom_nav_bar.dart';
import '../controllers/store_controller.dart';
import '../widgets/accessory_card.dart';
import '../widgets/store_search_bar.dart';

class StorePage extends StatelessWidget {
  StorePage({super.key});

  final StoreController controller = Get.find<StoreController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),

      // ── AppBar ────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        automaticallyImplyLeading: false,
        title: const Text(
          'المتجر',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          // Cart icon with badge
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

      // ── Body ──────────────────────────────────────────────────────────
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                const Text(
                  'إكسسوارات سامسونج',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'منتجات أصلية بأفضل الأسعار',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 14),
                // Search bar
                StoreSearchBar(onChanged: controller.updateSearch),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Products section label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(() {
              final count = controller.filteredAccessories.length;
              return Text(
                'المنتجات ($count)',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              );
            }),
          ),

          const SizedBox(height: 12),

          // Content
          Expanded(
            child: Obx(() {
              // Loading
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.green),
                );
              }

              // Error
              if (controller.errorMessage.value.isNotEmpty &&
                  controller.accessories.isEmpty) {
                return _ErrorView(
                  message: controller.errorMessage.value,
                  onRetry: controller.fetchAccessories,
                );
              }

              // Empty
              if (controller.filteredAccessories.isEmpty) {
                return const _EmptyView();
              }

              // Grid
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
                    final StorageService _storage = StorageService();
                    print("==================${_storage.getToken()}");
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

// ── Error Widget ─────────────────────────────────────────────────────────────
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
              label: const Text(
                'إعادة المحاولة',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty Widget ──────────────────────────────────────────────────────────────
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, color: Colors.white38, size: 64),
          SizedBox(height: 16),
          Text(
            'لا توجد منتجات متاحة',
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
