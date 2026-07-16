import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/route/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/lottie_loading.dart';
import '../controllers/store_controller.dart';
import '../widgets/cart_item_tile.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final StoreController controller = Get.find<StoreController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        title: Text(
          'cart'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        // ── Loading ─────────────────────────────────────────────────
        if (controller.isLoadingCart.value && controller.cartItems.isEmpty) {
          return LottieLoading(label: 'loading_cart'.tr);
        }

        // ── Error ────────────────────────────────────────────────────
        if (controller.cartError.value.isNotEmpty &&
            controller.cartItems.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.wifi_off_rounded,
                    color: Colors.white38,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.cartError.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white60, fontSize: 15),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: controller.fetchCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
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

        // ── Empty ────────────────────────────────────────────────────
        if (controller.cartItems.isEmpty) {
          return _EmptyCartView();
        }

        // ── Content ──────────────────────────────────────────────────
        return Column(
          children: [
            if (controller.isLoadingCart.value)
              const LinearProgressIndicator(
                color: AppColors.green,
                backgroundColor: AppColors.blue,
              ),

            Expanded(
              child: RefreshIndicator(
                color: AppColors.green,
                backgroundColor: AppColors.blue,
                onRefresh: controller.fetchCart,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  itemCount: controller.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.cartItems[index];
                    return Obx(
                      () => CartItemTile(
                        item: item,
                        isLoading: controller.addingToCartIds.contains(
                          item.accessory.id,
                        ),
                        onIncrease: () =>
                            controller.increaseQuantity(item.accessory.id),
                        onDecrease: () =>
                            controller.decreaseQuantity(item.accessory.id),
                        onRemove: () =>
                            controller.removeFromCart(item.accessory.id),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ── Order Summary ────────────────────────────────────────
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                decoration: const BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'items_count'.tr,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                        Obx(
                          () => Text(
                            '${controller.cartCount} ${'pieces'.tr}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'total'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Obx(
                          () => Text(
                            '${controller.cartTotal.toStringAsFixed(2)} ${'currency'.tr}',
                            style: const TextStyle(
                              color: AppColors.green,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.toNamed(AppRoutes.checkout),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'place_order'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white24,
            size: 80,
          ),
          const SizedBox(height: 20),
          Text(
            'cart_empty'.tr,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'cart_empty_sub'.tr,
            style: const TextStyle(color: Colors.white38, fontSize: 14),
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.storefront_outlined, color: Colors.white),
            label: Text(
              'browse_store'.tr,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
