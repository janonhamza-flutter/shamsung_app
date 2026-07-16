import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../data/models/accessory_model.dart';

class AccessoryCard extends StatelessWidget {
  final AccessoryModel accessory;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  final bool isAdding; // true while POST /cart is in flight

  const AccessoryCard({
    super.key,
    required this.accessory,
    required this.onTap,
    required this.onAddToCart,
    this.isAdding = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool outOfStock = accessory.stockQuantity == 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──────────────────────────────────────────────────
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: accessory.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: accessory.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                const _CardPlaceholder(loading: true),
                            errorWidget: (_, __, ___) =>
                                const _CardPlaceholder(),
                          )
                        : const _CardPlaceholder(),
                  ),
                  // Out of stock overlay
                  if (outOfStock)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'out_of_stock'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Info ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    accessory.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${accessory.price.toStringAsFixed(2)} ${'currency'.tr}',
                        style: const TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      // Add to cart button — shows spinner while API call is in flight
                      GestureDetector(
                        onTap: (outOfStock || isAdding) ? null : onAddToCart,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: outOfStock
                                ? Colors.grey.withValues(alpha: 0.2)
                                : AppColors.green.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: isAdding
                              ? const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: CircularProgressIndicator(
                                    color: AppColors.green,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  Icons.add_shopping_cart_outlined,
                                  size: 18,
                                  color: outOfStock
                                      ? Colors.grey
                                      : AppColors.green,
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

class _CardPlaceholder extends StatelessWidget {
  final bool loading;
  const _CardPlaceholder({this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.darkBlue,
      child: Center(
        child: loading
            ? const CircularProgressIndicator(
                color: AppColors.green,
                strokeWidth: 2,
              )
            : const Icon(Icons.image_outlined, color: Colors.white24, size: 36),
      ),
    );
  }
}
