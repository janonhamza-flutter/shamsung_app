import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import '../../../../../core/route/app_routes.dart';
import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/widgets/lottie_loading.dart';
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
    final AccessoryModel? initial = Get.arguments as AccessoryModel?;
    if (initial != null) {
      controller.fetchAccessoryDetails(initial.id, initial: initial);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.primary,
        title: Text(
          'product_details'.tr,
          style: TextStyle(
            color: context.colors.textOnPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: context.colors.textOnPrimary),
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
                        '$count',
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
      body: Obx(() {
        final accessory = controller.selectedAccessory.value;
        final isLoading = controller.isLoadingDetails.value;
        final error = controller.detailsError.value;

        if (accessory == null && isLoading) {
          return LottieLoading(label: 'loading_product'.tr);
        }

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
          return LottieLoading(label: 'loading_product'.tr);
        }

        return Stack(
          children: [
            _DetailsContent(accessory: accessory, controller: controller),
            if (isLoading)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  color: context.colors.accent,
                  backgroundColor: context.colors.primary,
                ),
              ),
          ],
        );
      }),
    );
  }
}

class _DetailsContent extends StatelessWidget {
  final AccessoryModel accessory;
  final StoreController controller;

  const _DetailsContent({required this.accessory, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Product Image ─────────────────────────────────────────
            Container(
              width: double.infinity,
              height: 280,
              color: context.colors.surface,
              child: accessory.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: accessory.imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (_, __) => Center(
                        child: CircularProgressIndicator(
                          color: context.colors.accent,
                        ),
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
                  // ── Name & Price ──────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          accessory.name,
                          style: TextStyle(
                            color: context.colors.textPrimary,
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
                          color: context.colors.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: context.colors.accent.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          '${accessory.price.toStringAsFixed(2)} ${'currency'.tr}',
                          style: TextStyle(
                            color: context.colors.accent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  _StockBadge(stockQuantity: accessory.stockQuantity),
                  const SizedBox(height: 20),

                  // ── Description ───────────────────────────────────
                  Text(
                    'description'.tr,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    accessory.description,
                    style: TextStyle(
                      color: context.colors.textSecondary,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Shop Info ─────────────────────────────────────
                  if (accessory.shop != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.colors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: context.colors.isDark
                            ? null
                            : Border.all(color: context.colors.border),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.store_outlined,
                            color: context.colors.accent,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  accessory.shop!.name,
                                  style: TextStyle(
                                    color: context.colors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  accessory.shop!.address,
                                  style: TextStyle(
                                    color: context.colors.textSecondary,
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

                  // ── Add to Cart Button ────────────────────────────
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
                              ? context.colors.surfaceVariant
                              : context.colors.accent,
                          disabledBackgroundColor: isAdding
                              ? context.colors.surfaceVariant
                              : context.colors.textDisabled,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: inCart
                                ? BorderSide(color: context.colors.accent)
                                : BorderSide.none,
                          ),
                        ),
                        icon: isAdding
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: context.colors.accent,
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                inCart
                                    ? Icons.check_circle_outline
                                    : Icons.shopping_cart_outlined,
                                color: inCart
                                    ? context.colors.accent
                                    : context.colors.textOnPrimary,
                              ),
                        label: Text(
                          accessory.stockQuantity == 0
                              ? 'out_of_stock'.tr
                              : isAdding
                              ? 'adding_to_cart'.tr
                              : inCart
                              ? 'added_to_cart'.tr
                              : 'add_to_cart'.tr,
                          style: TextStyle(
                            color: inCart
                                ? context.colors.accent
                                : context.colors.textOnPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 12),

                  // ── View Cart Button ──────────────────────────────
                  Obx(() {
                    if (controller.cartCount == 0) return const SizedBox();
                    return SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Get.toNamed(AppRoutes.cart),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: context.colors.accent),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: Icon(
                          Icons.shopping_bag_outlined,
                          color: context.colors.accent,
                        ),
                        label: Text(
                          '${'view_cart'.tr} (${controller.cartCount})',
                          style: TextStyle(
                            color: context.colors.accent,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),

                  SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                ],
              ),
            ),
          ],
        ),
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
              Icons.error_outline,
              color: context.colors.textDisabled,
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

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        color: context.colors.textDisabled,
        size: 80,
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  final int stockQuantity;
  const _StockBadge({required this.stockQuantity});

  @override
  Widget build(BuildContext context) {
    final bool inStock = stockQuantity > 0;
    final Color statusColor = inStock
        ? context.colors.accent
        : context.colors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            inStock ? Icons.check_circle_outline : Icons.cancel_outlined,
            color: statusColor,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            inStock ? '${'in_stock'.tr} ($stockQuantity)' : 'out_of_stock'.tr,
            style: TextStyle(
              color: statusColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
