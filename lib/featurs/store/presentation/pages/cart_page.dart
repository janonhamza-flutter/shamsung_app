import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/route/app_routes.dart';
import '../../../../../core/theme/app_palette.dart';
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
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.primary,
        title: Text(
          'cart'.tr,
          style: TextStyle(
            color: context.colors.textOnPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: context.colors.textOnPrimary),
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
                  Icon(
                    Icons.wifi_off_rounded,
                    color: context.colors.textSecondary,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.cartError.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.colors.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: controller.fetchCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(
                      Icons.refresh,
                      color: context.colors.textOnPrimary,
                    ),
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

        // ── Empty ────────────────────────────────────────────────────
        if (controller.cartItems.isEmpty) {
          return _EmptyCartView();
        }

        // ── Content ──────────────────────────────────────────────────
        return Column(
          children: [
            if (controller.isLoadingCart.value)
              LinearProgressIndicator(
                color: context.colors.accent,
                backgroundColor: context.colors.primary,
              ),

            Expanded(
              child: RefreshIndicator(
                color: context.colors.accent,
                backgroundColor: context.colors.surface,
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
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: const BorderRadius.only(
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
                            color: context.colors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        Obx(
                          () => Text(
                            '${controller.cartCount} ${'pieces'.tr}',
                            style: TextStyle(
                              color: context.colors.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Divider(color: context.colors.divider),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'total'.tr,
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Obx(
                          () => Text(
                            '${controller.cartTotal.toStringAsFixed(2)} ${'currency'.tr}',
                            style: TextStyle(
                              color: context.colors.accent,
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
                          backgroundColor: context.colors.accent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'place_order'.tr,
                          style: TextStyle(
                            color: context.colors.textOnPrimary,
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
          Icon(
            Icons.shopping_cart_outlined,
            color: context.colors.textDisabled,
            size: 80,
          ),
          const SizedBox(height: 20),
          Text(
            'cart_empty'.tr,
            style: TextStyle(
              color: context.colors.textSecondary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'cart_empty_sub'.tr,
            style: TextStyle(color: context.colors.textDisabled, fontSize: 14),
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.accent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(
              Icons.storefront_outlined,
              color: context.colors.textOnPrimary,
            ),
            label: Text(
              'browse_store'.tr,
              style: TextStyle(color: context.colors.textOnPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
