import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import '../../../../../core/route/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../data/models/accessory_model.dart';
import '../controllers/store_controller.dart';

class AccessoryDetailsPage extends StatefulWidget {
  const AccessoryDetailsPage({super.key});

  @override
  State<AccessoryDetailsPage> createState() => _AccessoryDetailsPageState();
}

class _AccessoryDetailsPageState extends State<AccessoryDetailsPage> {
  final StoreController controller = Get.find<StoreController>();

  @override
  void initState() {
    super.initState();
    // The list page passes the AccessoryModel as arguments for instant display.
    // We also trigger a fresh API fetch to get up-to-date details.
    final AccessoryModel? initial = Get.arguments as AccessoryModel?;
    if (initial != null) {
      controller.fetchAccessoryDetails(initial.id, initial: initial);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        title: const Text(
          'تفاصيل المنتج',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
                        '$count',
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
      body: Obx(() {
        final accessory = controller.selectedAccessory.value;
        final isLoading = controller.isLoadingDetails.value;
        final error = controller.detailsError.value;

        // No data at all → loading spinner
        if (accessory == null && isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.green),
          );
        }

        // No data and error → error view with retry
        if (accessory == null && error.isNotEmpty) {
          return _ErrorView(
            message: error,
            onRetry: () => controller.fetchAccessoryDetails(
              (Get.arguments as AccessoryModel).id,
              initial: Get.arguments as AccessoryModel?,
            ),
          );
        }

        if (accessory == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.green),
          );
        }

        // Show content (with optional loading indicator overlay while refreshing)
        return Stack(
          children: [
            _DetailsContent(accessory: accessory, controller: controller),
            // Subtle top loading bar while refreshing in background
            if (isLoading)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  color: AppColors.green,
                  backgroundColor: AppColors.blue,
                ),
              ),
          ],
        );
      }),
    );
  }
}

// ── Main Content ─────────────────────────────────────────────────────────────
class _DetailsContent extends StatelessWidget {
  final AccessoryModel accessory;
  final StoreController controller;

  const _DetailsContent({required this.accessory, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Product Image ─────────────────────────────────────────────
          Container(
            width: double.infinity,
            height: 280,
            color: AppColors.blue,
            child: accessory.imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: accessory.imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(color: AppColors.green),
                    ),
                    errorWidget: (_, __, ___) => const _PlaceholderImage(),
                  )
                : const _PlaceholderImage(),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Name & Price ──────────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        accessory.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.green.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        '${accessory.price.toStringAsFixed(2)} SP',
                        style: const TextStyle(
                          color: AppColors.green,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Stock Badge ───────────────────────────────────────
                _StockBadge(stockQuantity: accessory.stockQuantity),

                const SizedBox(height: 20),

                // ── Description ───────────────────────────────────────
                const Text(
                  'الوصف',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  accessory.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 24),

                // ── Shop Info ─────────────────────────────────────────
                if (accessory.shop != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.store_outlined,
                          color: AppColors.green,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                accessory.shop!.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                accessory.shop!.address,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // ── Add to Cart Button ────────────────────────────────
                Obx(() {
                  final inCart = controller.isInCart(accessory.id);
                  final isAdding = controller.isAddingToCart(accessory.id);
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: (accessory.stockQuantity == 0 || isAdding)
                          ? null
                          : () => controller.addToCart(accessory),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: inCart
                            ? AppColors.blue
                            : AppColors.green,
                        disabledBackgroundColor: isAdding
                            ? AppColors.blue
                            : Colors.grey.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: inCart
                              ? const BorderSide(color: AppColors.green)
                              : BorderSide.none,
                        ),
                      ),
                      icon: isAdding
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.green,
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(
                              inCart
                                  ? Icons.check_circle_outline
                                  : Icons.shopping_cart_outlined,
                              color: inCart ? AppColors.green : Colors.white,
                            ),
                      label: Text(
                        accessory.stockQuantity == 0
                            ? 'غير متوفر'
                            : isAdding
                            ? 'جاري الإضافة...'
                            : inCart
                            ? 'تمت الإضافة إلى السلة'
                            : 'أضف إلى السلة',
                        style: TextStyle(
                          color: inCart ? AppColors.green : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 12),

                // ── View Cart Button ──────────────────────────────────
                Obx(() {
                  if (controller.cartCount == 0) return const SizedBox();
                  return SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Get.toNamed(AppRoutes.cart),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.green),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.green,
                      ),
                      label: Text(
                        'عرض السلة (${controller.cartCount})',
                        style: const TextStyle(
                          color: AppColors.green,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white38, size: 64),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60, fontSize: 15),
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

// ── Placeholder Image ─────────────────────────────────────────────────────────
class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        color: Colors.white24,
        size: 80,
      ),
    );
  }
}

// ── Stock Badge ───────────────────────────────────────────────────────────────
class _StockBadge extends StatelessWidget {
  final int stockQuantity;
  const _StockBadge({required this.stockQuantity});

  @override
  Widget build(BuildContext context) {
    final bool inStock = stockQuantity > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: inStock
            ? AppColors.green.withValues(alpha: 0.12)
            : Colors.red.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: inStock
              ? AppColors.green.withValues(alpha: 0.4)
              : Colors.red.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            inStock ? Icons.check_circle_outline : Icons.cancel_outlined,
            color: inStock ? AppColors.green : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            inStock ? 'متوفر في المخزون ($stockQuantity)' : 'غير متوفر',
            style: TextStyle(
              color: inStock ? AppColors.green : Colors.red,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
